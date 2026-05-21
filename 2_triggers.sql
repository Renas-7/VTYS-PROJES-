-- ============================================================================
-- 2. TETİKLEYİCİLER (TRIGGERS - T-SQL Set-Based)
-- Proje: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
-- Yazar: Renas Ayaz
-- ============================================================================

USE YemekSiparisDB;
GO

-- TRİGGER 1: Bağış yapıldığında havuzdaki parayı otomatik artıran tetikleyici (Set-Based)
CREATE TRIGGER trg_BagisYapildi
ON AskidaYemekBagislari
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Küme tabanlı (Set-Based) güncelleme ile çoklu insert durumlarında hata vermez
    UPDATE a
    SET a.GuncelBakiye = a.GuncelBakiye + i.ToplamBagis,
        a.ToplamBagislanan = a.ToplamBagislanan + i.ToplamBagis
    FROM AskidaYemekBakiye a
    INNER JOIN (
        SELECT SUM(BagisMiktari) AS ToplamBagis
        FROM inserted
    ) i ON a.BakiyeID = 1; -- BakiyeID = 1 kaydı güncellenir
END;
GO

-- TRİGGER 2: Askıda Yemek kullanan biri sipariş verdiğinde bakiye kontrolü yapan ve havuzdan düşen tetikleyici
CREATE TRIGGER trg_AskidaYemekKullanildi
ON Siparisler
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. İhtiyaç Sahibi yetki kontrolü
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Musteriler m ON i.MusteriID = m.MusteriID
        WHERE i.AskidaYemekKullanildiMi = 1 AND m.IhtiyacSahibiMi = 0
    )
    BEGIN
        RAISERROR('Hata: Sadece doğrulanmış ihtiyaç sahipleri askıdaki yemek havuzunu kullanabilir!', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END;

    -- 2. Havuz bakiye kontrolü ve düşümü
    DECLARE @ToplamKullanilacak DECIMAL(10,2);
    SELECT @ToplamKullanilacak = SUM(SiparisTutari)
    FROM inserted
    WHERE AskidaYemekKullanildiMi = 1;

    IF @ToplamKullanilacak IS NOT NULL AND @ToplamKullanilacak > 0
    BEGIN
        DECLARE @MevcutBakiye DECIMAL(10,2);
        SELECT @MevcutBakiye = GuncelBakiye
        FROM AskidaYemekBakiye
        WHERE BakiyeID = 1;

        IF @MevcutBakiye < @ToplamKullanilacak
        BEGIN
            DECLARE @ErrorMessage NVARCHAR(250);
            SET @ErrorMessage = N'Hata: Askıda yemek havuzunda yeterli bakiye bulunmamaktadır! Mevcut Bakiye: ' + CAST(@MevcutBakiye AS NVARCHAR(50)) + N' TL, Gerekli Tutar: ' + CAST(@ToplamKullanilacak AS NVARCHAR(50)) + N' TL';
            RAISERROR(@ErrorMessage, 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        -- Küme tabanlı güvenli güncelleme
        UPDATE a
        SET a.GuncelBakiye = a.GuncelBakiye - @ToplamKullanilacak,
            a.ToplamKullanilan = a.ToplamKullanilan + @ToplamKullanilacak
        FROM AskidaYemekBakiye a
        WHERE a.BakiyeID = 1;
    END;
END;
GO

-- TRİGGER 3: Sipariş "Teslim Edildi" statüsüne geçtiğinde, restoranın Toplam Cirosunu güncelleyen tetikleyici (Set-Based & Güvenli)
CREATE TRIGGER trg_SiparisTeslimEdildiCiroGuncelle
ON Siparisler
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF UPDATE(SiparisDurumu)
    BEGIN
        -- 1. Durumu 'Teslim Edildi' yapılan siparişlerin tutarını restoran cirosuna ekle (Kümülatif Group By ile güvenli)
        UPDATE r
        SET r.ToplamCiro = r.ToplamCiro + c.EklenenCiro
        FROM Restoranlar r
        INNER JOIN (
            SELECT i.RestoranID, SUM(i.SiparisTutari) AS EklenenCiro
            FROM inserted i
            INNER JOIN deleted d ON i.SiparisID = d.SiparisID
            WHERE i.SiparisDurumu = 'Teslim Edildi' 
              AND d.SiparisDurumu <> 'Teslim Edildi'
            GROUP BY i.RestoranID
        ) c ON r.RestoranID = c.RestoranID;

        -- 2. Daha önce 'Teslim Edildi' iken iptal veya başka duruma çekilen siparişlerin tutarını cirodan geri düş (İptal/İade durumları için)
        UPDATE r
        SET r.ToplamCiro = r.ToplamCiro - c.EksilenCiro
        FROM Restoranlar r
        INNER JOIN (
            SELECT d.RestoranID, SUM(d.SiparisTutari) AS EksilenCiro
            FROM deleted d
            INNER JOIN inserted i ON d.SiparisID = i.SiparisID
            WHERE d.SiparisDurumu = 'Teslim Edildi' 
              AND i.SiparisDurumu <> 'Teslim Edildi'
            GROUP BY d.RestoranID
        ) c ON r.RestoranID = c.RestoranID;
    END;
END;
GO
