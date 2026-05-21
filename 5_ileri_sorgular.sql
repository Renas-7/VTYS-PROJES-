-- ============================================================================
-- 5. İLERİ DÜZEY ANALİTİK SORGULAR (DQL)
-- Proje: ÇEVRİMİÇİ YEMEK SİPARİŞ PLATFORMU VERİTABANI TASARIMI
-- Yazar: Renas Ayaz
-- ============================================================================

USE YemekSiparisDB;
GO

-- SORU 1: En az 3 tabloyu bağlayan detaylı sipariş fişi sorgusu (JOIN Kullanımı)
-- AÇIKLAMA: Müşteri, Sipariş, Kurye ve Restoran tablolarını birleştirerek 'Teslim Edilmiş' siparişlerin detaylı fişini getirir.
SELECT 
    S.SiparisID,
    M.Ad + ' ' + M.Soyad AS MusteriBilgisi,
    R.RestoranAdi,
    ISNULL(K.Ad + ' ' + K.Soyad, N'Kurye Atanmadı') AS KuryeBilgisi,
    S.SiparisTutari AS [Sipariş Tutarı (TL)],
    S.SiparisTarihi AS [Sipariş Tarihi],
    S.AskidaYemekKullanildiMi AS [Askıdan mı Karşılandı?]
FROM Siparisler S
INNER JOIN Musteriler M ON S.MusteriID = M.MusteriID
INNER JOIN Restoranlar R ON S.RestoranID = R.RestoranID
LEFT JOIN Kuryeler K ON S.KuryeID = K.KuryeID
WHERE S.SiparisDurumu = N'Teslim Edildi'
ORDER BY S.SiparisID DESC;
GO

-- SORU 2: Agregasyon ve Gruplama (GROUP BY & HAVING)
-- AÇIKLAMA: Sistemde toplamda 5'ten fazla teslim edilmiş siparişi olan restoranların, 
-- toplam teslim edilen sipariş adetlerini, toplam kazandıkları ciroyu ve ortalama sepet tutarlarını raporlar.
SELECT 
    R.RestoranAdi,
    COUNT(S.SiparisID) AS ToplamSiparisAdedi,
    SUM(S.SiparisTutari) AS ToplamCiro,
    ROUND(AVG(S.SiparisTutari), 2) AS OrtalamaSepetTutari
FROM Siparisler S
INNER JOIN Restoranlar R ON S.RestoranID = R.RestoranID
WHERE S.SiparisDurumu = N'Teslim Edildi'
GROUP BY R.RestoranAdi
HAVING COUNT(S.SiparisID) > 5
ORDER BY ToplamCiro DESC;
GO

-- SORU 3: Alt Sorgu (Subquery) NOT EXISTS kullanımı
-- AÇIKLAMA: Hiç "Askıda Yemek" bağışı YAPMAMIŞ ama platformdan en az bir sipariş vermiş olan aktif normal müşterileri tespit eder.
SELECT 
    M.MusteriID, 
    M.Ad, 
    M.Soyad, 
    M.Email,
    M.Telefon
FROM Musteriler M
WHERE M.IsActive = 1 
  AND M.IhtiyacSahibiMi = 0 -- İhtiyaç sahipleri hariç normal aktif kullanıcılar
  AND EXISTS (
      SELECT 1 
      FROM Siparisler S 
      WHERE S.MusteriID = M.MusteriID
  )
  AND NOT EXISTS (
      SELECT 1 
      FROM AskidaYemekBagislari A 
      WHERE A.MusteriID = M.MusteriID
  );
GO
