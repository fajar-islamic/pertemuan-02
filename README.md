# HW 2 — Computational Thinking dengan Dart: System Perhitungan Laundry Digital

**Mata Kuliah:** Aplikasi Mobile (KB1185)  
**Dosen Pengampu:** I Ketut Gunawan, S.Kom., M.TI  
**Nama Mahasiswa:** Fajar Hikmayatul Islami  
**NIM:** 1124160221  

---

## 1. Kode Program Utuh (main.dart)

// =============================================
// HW 2 - Aplikasi Manajemen Laundry Digital
// Nama : Fajar Hikmayatul Islami
// NIM  : 1124160221
// Mata Kuliah: Aplikasi Mobile (KB1185)
// =============================================

enum TipeLayanan { reguler, express }
enum StatusPesanan { diterima, diproses, selesai }

class PesananLaundry {
  final String idPesanan;
  final String namaPelanggan;
  final double beratKg;
  final TipeLayanan layanan;
  StatusPesanan status;

  PesananLaundry({
    required this.idPesanan,
    required this.namaPelanggan,
    required this.beratKg,
    required this.layanan,
    this.status = StatusPesanan.diterima,
  });
}

final List<PesananLaundry> daftarPesanan = [];

double hitungBeratEfektif(double beratAsli) {
  if (beratAsli <= 0) return 0.0;
  return beratAsli < 2.0 ? 2.0 : beratAsli;
}

double hitungTarifPerKg(TipeLayanan layanan) {
  const double tarifDasar = 7000.0;
  if (layanan == TipeLayanan.express) {
    return tarifDasar * 1.5;
  }
  return tarifDasar;
}

double hitungTotalBiaya(double beratAsli, TipeLayanan layanan) {
  double beratEfektif = hitungBeratEfektif(beratAsli);
  if (beratEfektif == 0.0) return 0.0;
  
  double tarifPerKg = hitungTarifPerKg(layanan);
  return beratEfektif * tarifPerKg;
}

String buatPesanan({
  required String id,
  required String nama,
  required double berat,
  required TipeLayanan layanan,
}) {
  if (berat <= 0) {
    return 'Gagal: Berat laundry tidak valid (minimal > 0 kg)';
  }

  double totalBiaya = hitungTotalBiaya(berat, layanan);
  
  daftarPesanan.add(PesananLaundry(
    idPesanan: id,
    namaPelanggan: nama,
    beratKg: berat,
    layanan: layanan,
  ));

  String infoLayanan = layanan == TipeLayanan.express ? 'Express' : 'Reguler';
  return 'Berhasil: Pesanan $id atas nama $nama ($infoLayanan) diproses. Total: Rp ${totalBiaya.toStringAsFixed(0)}';
}

void main() {
  print('=== SYSTEM TEST LAUNDRY DIGITAL ===\n');

  print('[Skenario 1]');
  print(buatPesanan(id: 'LND-01', nama: 'Budi', berat: 3.0, layanan: TipeLayanan.reguler));

  print('\n[Skenario 2]');
  print(buatPesanan(id: 'LND-02', nama: 'Siti', berat: 1.0, layanan: TipeLayanan.reguler));

  print('\n[Skenario 3]');
  print(buatPesanan(id: 'LND-03', nama: 'Andi', berat: 4.0, layanan: TipeLayanan.express));

  print('\n[Skenario 4]');
  print(buatPesanan(id: 'LND-04', nama: 'Dewi', berat: 1.5, layanan: TipeLayanan.express));

  print('\n[Skenario 5]');
  print(buatPesanan(id: 'LND-05', nama: 'Eko', berat: 0.0, layanan: TipeLayanan.reguler));

  print('\n---------------------------------------');
  print('Total Pesanan Terdaftar : ${daftarPesanan.length} transaksi');
  
  double totalPendapatan = daftarPesanan.fold(0.0, (sum, item) {
    return sum + hitungTotalBiaya(item.beratKg, item.layanan);
  });
  print('Total Omset Laundry     : Rp ${totalPendapatan.toStringAsFixed(0)}');
}

---

## 2. Dokumen Analisis System

A. Problem Statement
Banyak tempat usaha laundry tradisional yang masih mengandalkan kalkulasi biaya secara manual. Hal ini rentan memicu human error (kesalahan hitung), terutama saat berhadapan dengan aturan bisnis khusus seperti ambang batas berat minimal maupun kalkulasi biaya tambahan untuk paket layanan cepat (express).

B. Actor
* Kasir / Admin Laundry: Operator yang memasukkan data transaksi dan menyampaikan rincian total tagihan biaya kepada pelanggan.

C. Input & Output
* Input: Berat pakaian (kg) dan jenis paket layanan (reguler/express).
* Output: Status pemrosesan, total harga pembayaran, dan rekapitulasi omset.

D. Business Rules (Aturan Bisnis)
* BR-01: Berat minimal 2 kg. Jika berat < 2 kg, tetap dihitung 2 kg.
* BR-02: Tarif dasar laundry sebesar Rp 7.000 per kg.
* BR-03: Layanan Express dikenakan biaya tambahan 50% (Rp 10.500 per kg).

---

## 3. Penerapan 4 Pilar Computational Thinking

A. Decomposition
* hitungBeratEfektif(): Menyesuaikan batas minimal berat 2 kg.
* hitungTarifPerKg(): Menentukan tarif per kg berdasarkan layanan.
* hitungTotalBiaya(): Mengalikan berat efektif dengan tarif per kg.
* buatPesanan(): Validasi input dan menyimpan transaksi.
* main(): Menjalankan skenario uji dan hitung omset.

B. Pattern Recognition
Input (Berat & Layanan) -> Cek Minimal 2kg -> Kalkulasi Tarif per Kg -> Tambahan Express +50% -> Total Biaya.

C. Abstraction
* enum TipeLayanan { reguler, express }
* enum StatusPesanan { diterima, diproses, selesai }
* class PesananLaundry

D. Algorithm & Flowchart

[START]
   │
   ▼
Input: ID, Nama, Berat, Layanan
   │
   ▼
Apakah Berat <= 0? ──── (Ya) ────► Return "Gagal: Berat tidak valid"
   │ (Tidak)
   ▼
Apakah Berat < 2.0? ─── (Ya) ────► BeratEfektif = 2.0
   │ (Tidak)
   ▼
BeratEfektif = Berat
   │
   ▼
Apakah Layanan == Express? ─ (Ya) ─► TarifPerKg = 7000 * 1.5
   │ (Tidak)
   ▼
TarifPerKg = 7000
   │
   ▼
TotalBiaya = BeratEfektif * TarifPerKg
   │
   ▼
Simpan Ke List & Return Status Berhasil
   │
   ▼
[END]

---

## 4. Tabel Traceability

| Business Rule | Function Implementasi | Skenario Pengujian | Hasil yang Diharapkan |
| :--- | :--- | :--- | :--- |
| BR-01 (Berat Minimal 2.0 kg) | hitungBeratEfektif() | Skenario 2 (Siti - 1.0 kg Reguler) | 2 kg x 7000 = Rp 14.000 |
| BR-02 (Tarif Dasar Rp 7.000/kg) | hitungTarifPerKg() | Skenario 1 (Budi - 3.0 kg Reguler) | 3 kg x 7000 = Rp 21.000 |
| BR-03 (Layanan Express +50%) | hitungTarifPerKg() | Skenario 3 (Andi - 4.0 kg Express) | 4 kg x 10.500 = Rp 42.000 |
| Kombinasi BR-01 & BR-03 | hitungTotalBiaya() | Skenario 4 (Dewi - 1.5 kg Express) | 2 kg x 10.500 = Rp 21.000 |
| Validasi Input Invalid | buatPesanan() | Skenario 5 (Eko - 0.0 kg Reguler) | Output: Gagal: Berat tidak valid |
