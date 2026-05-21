-- ============================================================================
-- 1. TABLOLARI OLUŞTURMA VE İNDEKSLEME (DDL & Constraints)
-- Proje: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
-- Yazar: Renas Ayaz
-- ============================================================================

USE master;
GO

-- Varsa mevcut veritabanını kapatıp siliyoruz
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'YemekSiparisDB')
BEGIN
    ALTER DATABASE YemekSiparisDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE YemekSiparisDB;
END;
GO

-- Veritabanını yeni baştan oluşturma
CREATE DATABASE YemekSiparisDB;
GO

USE YemekSiparisDB;
GO

-- Mükerrer çalıştırmalarda hata almamak için eski görünümleri ve tabloları bağımlılık sırasına göre siliyoruz
DROP VIEW IF EXISTS vw_AskidaYemekHavuzDurumu;
DROP VIEW IF EXISTS vw_AktifRestoranMenuleri;
GO

DROP TABLE IF EXISTS SiparisDetaylari;
DROP TABLE IF EXISTS Siparisler;
DROP TABLE IF EXISTS AskidaYemekBagislari;
DROP TABLE IF EXISTS Urunler;
DROP TABLE IF EXISTS Kategoriler;
DROP TABLE IF EXISTS Kuryeler;
DROP TABLE IF EXISTS Restoranlar;
DROP TABLE IF EXISTS Musteriler;
DROP TABLE IF EXISTS AskidaYemekBakiye;
GO

-- Müşteriler Tablosu (3NF)
CREATE TABLE Musteriler (
    MusteriID INT IDENTITY(1,1) PRIMARY KEY,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL, -- UNIQUE Constraint
    Email NVARCHAR(100) UNIQUE NOT NULL,  -- UNIQUE Constraint
    Sifre NVARCHAR(50) NOT NULL,
    IhtiyacSahibiMi BIT DEFAULT 0, -- 1 ise doğrulanmış ihtiyaç sahibidir
    IsActive BIT DEFAULT 1 -- Soft Delete için. 1: Aktif, 0: Pasif
);
GO

-- Restoranlar Tablosu (3NF)
CREATE TABLE Restoranlar (
    RestoranID INT IDENTITY(1,1) PRIMARY KEY,
    RestoranAdi NVARCHAR(100) NOT NULL,
    Adres NVARCHAR(255) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NULL,
    Puan DECIMAL(3,2) NULL,
    ToplamCiro DECIMAL(15,2) DEFAULT 0.00,
    IsActive BIT DEFAULT 1,
    
    -- CHECK Kısıtlamaları
    CONSTRAINT chk_RestoranPuan CHECK (Puan BETWEEN 1.00 AND 5.00),
    CONSTRAINT chk_RestoranCiro CHECK (ToplamCiro >= 0.00)
);
GO

-- Kuryeler Tablosu (3NF)
CREATE TABLE Kuryeler (
    KuryeID INT IDENTITY(1,1) PRIMARY KEY,
    Ad NVARCHAR(50) NOT NULL,
    Soyad NVARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) UNIQUE NOT NULL,
    AracTipi NVARCHAR(30) NOT NULL,
    IsActive BIT DEFAULT 1
);
GO

-- Kategoriler Tablosu (3NF)
CREATE TABLE Kategoriler (
    KategoriID INT IDENTITY(1,1) PRIMARY KEY,
    KategoriAdi NVARCHAR(50) NOT NULL UNIQUE,
    IsActive BIT DEFAULT 1
);
GO

-- Ürünler (Menü) Tablosu (3NF)
CREATE TABLE Urunler (
    UrunID INT IDENTITY(1,1) PRIMARY KEY,
    RestoranID INT NOT NULL,
    KategoriID INT NOT NULL,
    UrunAdi NVARCHAR(100) NOT NULL,
    Fiyat DECIMAL(10,2) NOT NULL,
    IsActive BIT DEFAULT 1,
    
    -- İlişkiler (FK)
    FOREIGN KEY (RestoranID) REFERENCES Restoranlar(RestoranID) ON DELETE CASCADE,
    FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID),
    
    -- CHECK Kısıtlaması
    CONSTRAINT chk_UrunFiyat CHECK (Fiyat > 0.00)
);
GO

-- Askıda Yemek Havuzu Bakiye Tablosu (Tek satırlık havuz)
CREATE TABLE AskidaYemekBakiye (
    BakiyeID INT PRIMARY KEY DEFAULT 1,
    GuncelBakiye DECIMAL(10,2) DEFAULT 0.00,
    ToplamBagislanan DECIMAL(10,2) DEFAULT 0.00,
    ToplamKullanilan DECIMAL(10,2) DEFAULT 0.00,
    
    -- CHECK Kısıtlamaları
    CONSTRAINT chk_HavuzBakiye CHECK (GuncelBakiye >= 0.00),
    CONSTRAINT chk_AskidaYemekTekSatir CHECK (BakiyeID = 1) -- Sadece tek satır olmasını garanti eder
);
GO

-- Askıda Yemek Bağışları Tablosu (3NF)
CREATE TABLE AskidaYemekBagislari (
    BagisID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT NULL, -- NULL ise anonim (gizli) bağıştır
    BagisMiktari DECIMAL(10,2) NOT NULL,
    GizliMi BIT DEFAULT 0, -- 1 ise isim görünmez
    BagisTarihi DATETIME DEFAULT GETDATE(),
    
    -- İlişki (FK)
    FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    
    -- CHECK Kısıtlaması
    CONSTRAINT chk_BagisMiktari CHECK (BagisMiktari > 0.00)
);
GO

-- Siparişler Tablosu (3NF)
CREATE TABLE Siparisler (
    SiparisID INT IDENTITY(1,1) PRIMARY KEY,
    MusteriID INT NOT NULL,
    RestoranID INT NOT NULL,
    KuryeID INT NULL, -- Sipariş ilk açıldığında kurye atanmamış olabilir
    SiparisTarihi DATETIME DEFAULT GETDATE(),
    SiparisTutari DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    SiparisDurumu NVARCHAR(30) DEFAULT N'Hazırlanıyor',
    AskidaYemekKullanildiMi BIT DEFAULT 0, -- Sipariş havuzdaki bakiye ile mi ödendi?
    IsActive BIT DEFAULT 1,
    
    -- İlişkiler (FK)
    FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    FOREIGN KEY (RestoranID) REFERENCES Restoranlar(RestoranID),
    FOREIGN KEY (KuryeID) REFERENCES Kuryeler(KuryeID),
    
    -- CHECK Kısıtlamaları
    CONSTRAINT chk_SiparisTutari CHECK (SiparisTutari >= 0.00),
    CONSTRAINT chk_SiparisDurumu CHECK (SiparisDurumu IN (N'Hazırlanıyor', N'Yolda', N'Teslim Edildi', N'İptal'))
);
GO

-- Sipariş Detayları Tablosu (Sepetteki ürünler) (3NF)
CREATE TABLE SiparisDetaylari (
    DetayID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT NOT NULL,
    UrunID INT NOT NULL,
    Adet INT NOT NULL DEFAULT 1,
    BirimFiyat DECIMAL(10,2) NOT NULL,
    
    -- İlişkiler (FK)
    FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID) ON DELETE CASCADE,
    FOREIGN KEY (UrunID) REFERENCES Urunler(UrunID),
    
    -- CHECK Kısıtlamaları
    CONSTRAINT chk_SiparisDetayAdet CHECK (Adet > 0),
    CONSTRAINT chk_SiparisDetayFiyat CHECK (BirimFiyat >= 0.00)
);
GO

-- Havuzu Başlatmak İçin Bakiye Tablosuna İlk Kaydı Atıyoruz
INSERT INTO AskidaYemekBakiye (BakiyeID, GuncelBakiye, ToplamBagislanan, ToplamKullanilan) 
VALUES (1, 0.00, 0.00, 0.00);
GO

-- ============================================================================
-- İNDEKSLEME (INDEXES)
-- ============================================================================

-- Index 1: Sipariş durumlarına göre (Hazırlanıyor, Teslim Edildi vb.) aramaları hızlandırır
CREATE NONCLUSTERED INDEX IX_Siparisler_Durum 
ON Siparisler(SiparisDurumu);
GO

-- Index 2: Ürünlerin aktif/pasif durumuna göre hızlı filtreleme yapmak için
CREATE NONCLUSTERED INDEX IX_Urunler_IsActive 
ON Urunler(IsActive);
GO
