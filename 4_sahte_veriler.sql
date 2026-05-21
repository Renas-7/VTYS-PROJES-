-- ============================================================================
-- 4. VERİ MANİPÜLASYONU (DML - Mock Data Ekleme ve Testler)
-- Proje: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
-- Yazar: Renas Ayaz
-- ============================================================================

USE YemekSiparisDB;
GO

-- 1. KATEGORİLER (5 Adet)
INSERT INTO Kategoriler (KategoriAdi) VALUES 
(N'Burgerler'), (N'Pizzalar'), (N'Kebaplar'), (N'İçecekler'), (N'Tatlılar');
GO

-- 2. KURYELER (5 Adet)
INSERT INTO Kuryeler (Ad, Soyad, Telefon, AracTipi) VALUES 
(N'Ahmet', N'Hızlı', '05551112233', N'Motosiklet'),
(N'Mehmet', N'Uçar', '05552223344', N'Bisiklet'),
(N'Ali', N'Yılmaz', '05553334455', N'Motosiklet'),
(N'Veli', N'Demir', '05554445566', N'Otomobil'),
(N'Ayşe', N'Rüzgar', '05555556677', N'Motosiklet');
GO

-- 3. RESTORANLAR (5 Adet)
INSERT INTO Restoranlar (RestoranAdi, Adres, Telefon, Puan) VALUES 
(N'Burger King', N'Kadıköy Meydan', '02161112233', 4.50),
(N'Dominos Pizza', N'Beşiktaş Sahil', '02122223344', 4.20),
(N'Kasap Döner', N'Şişli Merkez', '02123334455', 4.80),
(N'Hafız Mustafa', N'Eminönü', '02124445566', 4.90),
(N'Kral Lahmacun', N'Üsküdar', '02165556677', 4.00);
GO

-- 4. MÜŞTERİLER (20 Adet: 15 Normal, 5 İhtiyaç Sahibi)
INSERT INTO Musteriler (Ad, Soyad, Telefon, Email, Sifre, IhtiyacSahibiMi) VALUES 
(N'Can', N'Öz', '05001002030', 'can@mail.com', '1234', 0),
(N'Eda', N'Gül', '05001002031', 'eda@mail.com', '1234', 0),
(N'Cem', N'Taş', '05001002032', 'cem@mail.com', '1234', 0),
(N'Oya', N'Ay', '05001002033', 'oya@mail.com', '1234', 0),
(N'Efe', N'Ak', '05001002034', 'efe@mail.com', '1234', 0),
(N'Nil', N'Su', '05001002035', 'nil@mail.com', '1234', 0),
(N'Ali', N'Can', '05001002036', 'ali@mail.com', '1234', 0),
(N'Ata', N'Er', '05001002037', 'ata@mail.com', '1234', 0),
(N'Bora', N'Uz', '05001002038', 'bora@mail.com', '1234', 0),
(N'Gök', N'Ay', '05001002039', 'gok@mail.com', '1234', 0),
(N'Han', N'Dağ', '05001002040', 'han@mail.com', '1234', 0),
(N'Ece', N'Gür', '05001002041', 'ece@mail.com', '1234', 0),
(N'Mert', N'Zor', '05001002042', 'mert@mail.com', '1234', 0),
(N'Nur', N'Işık', '05001002043', 'nur@mail.com', '1234', 0),
(N'Canan', N'Sön', '05001002044', 'canan@mail.com', '1234', 0),
-- Doğrulanmış İhtiyaç Sahipleri (Askıdan Ücretsiz Sipariş Yetkisi Olanlar)
(N'Zeki', N'Yok', '05001002045', 'zeki@mail.com', '1234', 1),
(N'Suna', N'Dar', '05001002046', 'suna@mail.com', '1234', 1),
(N'Vefa', N'Zor', '05001002047', 'vefa@mail.com', '1234', 1),
(N'Hale', N'Güz', '05001002048', 'hale@mail.com', '1234', 1),
(N'Tarık', N'Bol', '05001002049', 'tarik@mail.com', '1234', 1);
GO

-- 5. ÜRÜNLER (50 Adet: Her restorana 10 farklı ürün)
INSERT INTO Urunler (RestoranID, KategoriID, UrunAdi, Fiyat) VALUES 
(1, 1, 'Whopper', 120.00), (1, 1, 'Chicken Royale', 100.00), (1, 1, 'Big King', 130.00), (1, 1, 'Texas Smoke', 150.00), (1, 1, 'Steakhouse', 160.00),
(1, 1, 'Double Whopper', 180.00), (1, 1, 'Köfteburger', 90.00), (1, 4, 'Kola', 30.00), (1, 4, 'Ayran', 20.00), (1, 4, 'Buzlu Çay', 35.00),
(2, 2, 'Margarita', 140.00), (2, 2, 'Karışık Pizza', 180.00), (2, 2, 'Sucuklu Pizza', 160.00), (2, 2, 'Bol Malzemos', 200.00), (2, 2, 'Tavuklu Pizza', 170.00),
(2, 2, 'Meksika Ateşi', 190.00), (2, 2, 'Akdeniz Pizza', 150.00), (2, 4, 'Kola', 30.00), (2, 4, 'Fanta', 30.00), (2, 4, 'Sprite', 30.00),
(3, 3, 'Et Döner Dürüm', 150.00), (3, 3, 'Tavuk Döner', 100.00), (3, 3, 'İskender', 250.00), (3, 3, 'Porsiyon Döner', 220.00), (3, 3, 'Pilav Üstü Et', 200.00),
(3, 3, 'Pilav Üstü Tavuk', 140.00), (3, 3, 'Tombik Döner', 160.00), (3, 4, 'Yayık Ayran', 30.00), (3, 4, 'Şalgam', 25.00), (3, 4, 'Su', 10.00),
(4, 5, 'Fıstıklı Baklava', 300.00), (4, 5, 'Cevizli Baklava', 250.00), (4, 5, 'Sütlaç', 80.00), (4, 5, 'Kazandibi', 75.00), (4, 5, 'Tavuk Göğsü', 75.00),
(4, 5, 'Trileçe', 90.00), (4, 5, 'Künefe', 120.00), (4, 4, 'Türk Kahvesi', 50.00), (4, 4, 'Çay', 20.00), (4, 4, 'Limonata', 40.00),
(5, 3, 'Acılı Lahmacun', 50.00), (5, 3, 'Acısız Lahmacun', 50.00), (5, 3, 'Kıymalı Pide', 130.00), (5, 3, 'Kuşbaşılı Pide', 150.00), (5, 3, 'Kaşarlı Pide', 120.00),
(5, 3, 'Karışık Pide', 160.00), (5, 3, 'Adana Kebap', 200.00), (5, 3, 'Urfa Kebap', 200.00), (5, 4, 'Ayran', 20.00), (5, 4, 'Şalgam', 25.00);
GO

-- 6. ASKIDA YEMEK BAĞIŞLARI (Trigger 1 çalışarak havuz bakiyesini otomatik artıracaktır)
INSERT INTO AskidaYemekBagislari (MusteriID, BagisMiktari, GizliMi) VALUES 
(1, 500.00, 0),     -- Can 500 TL bağışladı
(2, 1000.00, 1),    -- Eda 1000 TL bağışladı (Gizli)
(3, 250.00, 0),     -- Cem 250 TL bağışladı
(NULL, 1250.00, 1), -- Anonim biri 1250 TL bağışladı
(5, 2000.00, 0);    -- Efe 2000 TL bağışladı (TOPLAM HAVUZ BAKİYESİ: 5000 TL)
GO

-- 7. 100 ADET GERÇEKÇİ SİPARİŞİ VE DETAYINI OLUŞTURAN DÖNGÜ (T-SQL WHILE LOOP)
DECLARE @i INT = 1;
DECLARE @MusteriID INT, @RestoranID INT, @KuryeID INT, @UrunID INT, @Adet INT, @Fiyat DECIMAL(10,2), @Tutar DECIMAL(10,2), @AskidaMi BIT, @YeniSiparisID INT;

WHILE @i <= 100
BEGIN
    -- Rastgele müşteri, restoran ve kurye seçimi
    SET @MusteriID = (ABS(CHECKSUM(NEWID())) % 20) + 1;
    SET @RestoranID = (ABS(CHECKSUM(NEWID())) % 5) + 1;
    SET @KuryeID = (ABS(CHECKSUM(NEWID())) % 5) + 1;
    
    SET @AskidaMi = 0;
    
    -- Eğer seçilen müşteri İhtiyaç Sahibi ise %50 ihtimalle Askıda Yemek havuzunu kullansın
    IF EXISTS(SELECT 1 FROM Musteriler WHERE MusteriID = @MusteriID AND IhtiyacSahibiMi = 1)
    BEGIN
        IF (ABS(CHECKSUM(NEWID())) % 2) = 1 SET @AskidaMi = 1;
    END
    
    -- Seçilen restoranın menüsünden rastgele 1 ürün seç
    SELECT TOP 1 @UrunID = UrunID, @Fiyat = Fiyat 
    FROM Urunler 
    WHERE RestoranID = @RestoranID 
    ORDER BY NEWID();
    
    SET @Adet = (ABS(CHECKSUM(NEWID())) % 3) + 1; -- 1, 2 veya 3 adet
    SET @Tutar = @Fiyat * @Adet;
    
    BEGIN TRY
        -- Siparişi ekleme (Trigger 2 devreye girip yetki/bakiye kontrolü yapar)
        INSERT INTO Siparisler (MusteriID, RestoranID, KuryeID, SiparisTutari, SiparisDurumu, AskidaYemekKullanildiMi)
        VALUES (@MusteriID, @RestoranID, @KuryeID, @Tutar, N'Hazırlanıyor', @AskidaMi);
        
        -- Yeni Sipariş ID'sini alma
        SET @YeniSiparisID = SCOPE_IDENTITY();
        
        -- Sipariş detayını ekleme
        INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, BirimFiyat)
        VALUES (@YeniSiparisID, @UrunID, @Adet, @Fiyat);
        
        SET @i = @i + 1;
    END TRY
    BEGIN CATCH
        -- Bakiye bittiğinde veya yetkisiz kullanımda döngünün durmaması için hatayı yakalayıp devam ediyoruz
        PRINT N'Sipariş #' + CAST(@i AS NVARCHAR(10)) + N' eklenirken hata oluştu (Askıda yemek bakiyesi yetersiz olabilir). Yeniden deneniyor... Hata: ' + ERROR_MESSAGE();
    END CATCH;
END;
GO

-- 8. TRİGGER 3 TESTİ: 100 siparişin 80 tanesini 'Teslim Edildi' yapıyoruz.
-- Bu kümülatif güncelleme "Ciro Güncelleme" Trigger'ını ateşleyecek ve Restoranların "ToplamCiro" kolonu hatasız güncellenecektir.
-- Identity atlamalarından etkilenmemek için TOP 80 siparişi güncelliyoruz.
UPDATE Siparisler 
SET SiparisDurumu = N'Teslim Edildi'
WHERE SiparisID IN (
    SELECT TOP 80 SiparisID 
    FROM Siparisler 
    ORDER BY SiparisID ASC
);
GO

-- 9. SOFT DELETE (Pasife Çekme) ÖRNEĞİ
-- Burger King menüsündeki 'Whopper' ürününü (UrunID = 1) fiziksel silmek yerine IsActive = 0 yapıyoruz
UPDATE Urunler 
SET IsActive = 0 
WHERE UrunID = 1;
GO
