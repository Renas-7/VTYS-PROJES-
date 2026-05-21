-- ============================================================================
-- 3. GÖRÜNÜMLER (VIEWS)
-- Proje: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
-- Yazar: Renas Ayaz
-- ============================================================================

USE YemekSiparisDB;
GO

-- View 1: Karmaşık havuz durumunu anlık gösteren görünüm
CREATE VIEW vw_AskidaYemekHavuzDurumu AS
SELECT 
    GuncelBakiye AS [Mevcut Bakiye (TL)], 
    ToplamBagislanan AS [Gelen Toplam Bagis (TL)], 
    ToplamKullanilan AS [Kullanilan Toplam Bakiye (TL)]
FROM AskidaYemekBakiye;
GO

-- View 2: Sadece aktif olan ürünleri, kategori ve restoranlarıyla birlikte listeleyen menü görünümü
CREATE VIEW vw_AktifRestoranMenuleri AS
SELECT 
    R.RestoranAdi, 
    K.KategoriAdi, 
    U.UrunAdi, 
    U.Fiyat
FROM Urunler U
INNER JOIN Restoranlar R ON U.RestoranID = R.RestoranID
INNER JOIN Kategoriler K ON U.KategoriID = K.KategoriID
WHERE U.IsActive = 1 AND R.IsActive = 1;
GO
