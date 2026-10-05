================================================================================
HW 2 — COMPUTATIONAL THINKING DENGAN DART: SYSTEM PERHITUNGAN LAUNDRY DIGITAL
================================================================================
Mata Kuliah : Aplikasi Mobile (KB1185)
Dosen       : I Ketut Gunawan, S.Kom., M.TI
Mahasiswa   : Fajar Hikmayatul Islami
NIM         : 1124160221
================================================================================

--------------------------------------------------------------------------------
1. IMPLEMENTASI KODE PROGRAM UTUH (main.dart)
--------------------------------------------------------------------------------

// =============================================
// HW 2 - Aplikasi Manajemen Laundry Digital
// Nama : Fajar Hikmayatul Islami
// NIM  : 1124160221
// Mata Kuliah: Aplikasi Mobile (KB1185)
// =============================================

// ---------- ABSTRACTION ----------
// BR-02: Pilihan jenis layanan laundry
enum TipeLayanan { reguler, express }

// Status pengerjaan laundry
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

// ---------- DATA STORE ----------
final List<PesananLaundry> daftarPesanan = [];

// ---------- DECOMPOSITION ----------

// BR-01: Menghitung berat efektif (minimal 2kg)
double hitungBeratEfektif(double beratAsli) {
  if (beratAsli <= 0) return 0.0;
  return beratAsli < 2.0 ? 2.0 : beratAsli;
}

// BR-02 & BR-03: Menghitung tarif per kg berdasarkan tipe layanan
double hitungTarifPerKg(TipeLayanan layanan) {
  const double tarifDasar = 7000.0; // Rp 7.000 / kg
  if (layanan == TipeLayanan.express) {
    return tarifDasar * 1.5; // Layanan express +50% (Rp 10.500/kg)
  }
  return tarifDasar;
}

// Menghitung total biaya transaksi laundry
double hitungTotalBiaya(double beratAsli, TipeLayanan layanan) {
  double beratEfektif = hitungBeratEfektif(beratAsli);
  if (beratEfektif == 0.0) return 0.0;
  
  double tarifPerKg = hitungTarifPerKg(layanan);
  return beratEfektif * tarifPerKg;
}

// Memasukkan pesanan baru ke dalam sistem
String buatPesanan({
  required String id,
  required String nama,
  required double berat,
  required TipeLayanan layanan,
}) {
  // Validasi input awal
  if (berat <= 0) {
    return 'Gagal: Berat laundry tidak valid (minimal > 0 kg)';
  }

  double totalBiaya = hitungTotalBiaya(berat, layanan);
  
  // Simpan ke daftar pesanan
  daftarPesanan.add(PesananLaundry(
    idPesanan: id,
    namaPelanggan: nama,
    beratKg: berat,
    layanan: layanan,
  ));

  String infoLayanan = layanan == TipeLayanan.express ? 'Express' : 'Reguler';
  return 'Berhasil: Pesanan $id atas nama $nama ($infoLayanan) diproses. Total: Rp ${totalBiaya.toStringAsFixed(0)}';
}

// ---------- TEST SCENARIO & MAIN RUNNER ----------
void main() {
  print('=== SYSTEM TEST LAUNDRY DIGITAL ===\n');

  // Skenario 1 (Sukses Reguler Standard) - expected: Berat 3kg * 7000 = Rp 21.000
  print('[Skenario 1]');
  print(buatPesanan(id: 'LND-01', nama: 'Budi', berat: 3.0, layanan: TipeLayanan.reguler));

  // Skenario 2 (BR-01 Pembulatan Minimal 2kg) - expected: Berat 1kg dihitung 2kg * 7000 = Rp 14.000
  print('\n[Skenario 2]');
  print(buatPesanan(id: 'LND-02', nama: 'Siti', berat: 1.0, layanan: TipeLayanan.reguler));

  // Skenario 3 (BR-02 Layanan Express +50%) - expected: Berat 4kg * (7000 * 1.5) = Rp 42.000
  print('\n[Skenario 3]');
  print(buatPesanan(id: 'LND-03', nama: 'Andi', berat: 4.0, layanan: TipeLayanan.express));

  // Skenario 4 (Kombinasi BR-01 & BR-02) - expected: Berat 1.5kg dihitung 2kg * 10500 = Rp 21.000
  print('\n[Skenario 4]');
  print(buatPesanan(id: 'LND-04', nama: 'Dewi', berat: 1.5, layanan: TipeLayanan.express));

  // Skenario 5 (Gagal Validasi Berat Invalid) - expected: Gagal berat tidak valid
  print('\n[Skenario 5]');
  print(buatPesanan(id: 'LND-05', nama: 'Eko', berat: 0.0, layanan: TipeLayanan.reguler));

  // Agregasi Data
  print('\n---------------------------------------');
  print('Total Pesanan Terdaftar : ${daftarPesanan.length} transaksi');
  
  // Hitung total pendapatan toko
  double totalPendapatan = daftarPesanan.fold(0.0, (sum, item) {
    return sum + hitungTotalBiaya(item.beratKg, item.layanan);
  });
  print('Total Omset Laundry     : Rp ${totalPendapatan.toStringAsFixed(0)}');
}


--------------------------------------------------------------------------------
2. DOKUMEN ANALISIS SYSTEM
--------------------------------------------------------------------------------

A. PROBLEM STATEMENT
--------------------
Banyak tempat usaha laundry tradisional yang masih mengandalkan kalkulasi biaya
secara manual. Hal ini rentan memicu human error (kesalahan hitung), terutama saat
berhadapan dengan aturan bisnis khusus seperti ambang batas berat minimal maupun
kalkulasi biaya tambahan untuk paket layanan cepat (express). Program ini dirancang
untuk memproses dan menghitung total tarif transaksi laundry secara otomatis,
akurat, dan terstruktur berbasis algoritma Dart.

B. ACTOR
--------
* Kasir / Admin Laundry: Operator yang memasukkan data masukan transaksi (berat
  pakaian dalam kilogram dan jenis paket layanan yang dipilih) serta menyampaikan
  rincian total tagihan biaya kepada pelanggan.

C. INPUT & OUTPUT
-----------------
* Input:
  - Berat pakaian dalam satuan kilogram (contoh: 1.0, 1.5, 3.0, 4.0).
  - Jenis paket layanan (opsi terbatas: reguler atau express).
* Output:
  - Rincian status pemrosesan transaksi.
  - Total harga pembayaran yang wajib dibayar pelanggan (dalam format Rupiah).
  - Rekapitulasi akumulasi omset seluruh transaksi.

D. FUNCTIONAL REQUIREMENT
-------------------------
* FR-01: Sistem dapat memeriksa dan menyesuaikan berat pakaian berdasarkan aturan
         batas minimal transaksi.
* FR-02: Sistem dapat menghitung total tarif berdasarkan jenis paket layanan yang
         dipilih pelanggan.
* FR-03: Sistem dapat mengkalkulasi dan menampilkan hasil akhir total pembayaran
         serta rekapitulasi data ke layar.

E. BUSINESS RULES (ATURAN BISNIS)
----------------------------------
* BR-01 (Batas Minimal Berat): Jika berat pakaian di bawah 2 kg (misal: 1.0 kg
  atau 1.5 kg), maka berat transaksi secara otomatis dibulatkan dan dihitung
  tetap 2 kg.
* BR-02 (Tarif Dasar): Biaya dasar pengerjaan laundry adalah Rp 7.000 per kg.
* BR-03 (Layanan Express): Jika pelanggan memilih layanan express, dikenakan biaya
  tambahan sebesar 50% dari total tarif dasar (tarif efektif Rp 10.500 per kg).


--------------------------------------------------------------------------------
3. PENERAPAN 4 PILAR COMPUTATIONAL THINKING
--------------------------------------------------------------------------------

A. DECOMPOSITION (PEMECAHAN MASALAH)
------------------------------------
Masalah kompleks perhitungan transaksi laundry dipecah menjadi beberapa fungsi
kecil (modular) yang memiliki tanggung jawab spesifik:

* hitungBeratEfektif(double beratAsli)
  -> Memeriksa dan membulatkan berat pakaian ke batas minimal 2 kg jika < 2.0 kg.
* hitungTarifPerKg(TipeLayanan layanan)
  -> Menetapkan harga per kg (Reguler: Rp 7.000/kg | Express: Rp 10.500/kg).
* hitungTotalBiaya(double beratAsli, TipeLayanan layanan)
  -> Mengalikan berat efektif dengan tarif per kg untuk menghitung total tagihan.
* buatPesanan(...)
  -> Melakukan validasi input awal, menyimpan data ke List, dan return status.
* main()
  -> Mengeksekusi skenario uji dan menghitung omset akhir pakai fold().

B. PATTERN RECOGNITION (PENGENALAN POLA)
----------------------------------------
Setiap transaksi laundry selalu mengikuti pola perhitungan berulang:

   Input (Berat & Tipe Layanan)
                │
                ▼
   Cek & Penyesuaian Berat Minimal (BR-01)
                │
                ▼
   Kalkulasi Tarif Dasar per Kg (BR-02)
                │
                ▼
   Cek & Penyesuaian Biaya Express +50% (BR-03)
                │
                ▼
   Hitung Total Pembayaran

+----------------------+-----------------------+---------------+
| Komponen Perhitungan | Cara Perhitungan      | Hasil Nominal |
+----------------------+-----------------------+---------------+
| Harga Dasar          | 3.0 kg x Rp 7.000     | Rp 21.000     |
| Tambahan Express 50% | Rp 21.000 x 0.5       | Rp 10.500     |
| Total Biaya Akhir    | Rp 21.000 + Rp 10.500 | Rp 31.500     |
+----------------------+-----------------------+---------------+

C. ABSTRACTION (ABSTRAKSI DATA)
-------------------------------
1. enum TipeLayanan { reguler, express }
   -> Membatasi opsi pilihan paket laundry agar aman dari typo.
2. enum StatusPesanan { diterima, diproses, selesai }
   -> Mencatat siklus status pengerjaan cucian pelanggan.
3. class PesananLaundry
   -> Membungkus atribut utama transaksi (id, nama, berat, layanan, status).

D. ALGORITHM (LANGKAH-LANGKAH LOGIKA)
-------------------------------------
1. Menerima data masukan berupa ID, Nama, Berat Pakaian, dan Tipe Layanan.
2. Validasi awal: Jika berat <= 0, hentikan proses dan kembalikan pesan gagal.
3. Jika berat < 2.0 kg, ubah berat efektif menjadi 2.0 kg.
4. Hitung tarif per kg (Express = 10500, Reguler = 7000).
5. Total biaya = berat efektif x tarif per kg.
6. Simpan transaksi ke List dan tampilkan konfirmasi berhasil.


--------------------------------------------------------------------------------
4. PERANCANGAN SYSTEM
--------------------------------------------------------------------------------

FLOWCHART UTAMA:

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


PSEUDOCODE PROGRAM:

PROCEDURE hitungBeratEfektif(beratAsli)
    IF beratAsli <= 0 THEN
        RETURN 0.0
    END IF
    IF beratAsli < 2.0 THEN
        RETURN 2.0
    ELSE
        RETURN beratAsli
    END IF
END PROCEDURE

PROCEDURE hitungTarifPerKg(layanan)
    tarifDasar = 7000.0
    IF layanan == express THEN
        RETURN tarifDasar * 1.5
    ELSE
        RETURN tarifDasar
    END IF
END PROCEDURE

PROCEDURE buatPesanan(id, nama, berat, layanan)
    IF berat <= 0 THEN
        RETURN "Gagal: Berat laundry tidak valid"
    END IF
    
    beratEfektif = hitungBeratEfektif(berat)
    tarif = hitungTarifPerKg(layanan)
    totalBiaya = beratEfektif * tarif
    
    SAVE pesanan(id, nama, berat, layanan)
    RETURN "Berhasil"
END PROCEDURE

PROCEDURE main()
    DISPLAY buatPesanan("LND-01", "Budi", 3.0, reguler)
    DISPLAY buatPesanan("LND-02", "Siti", 1.0, reguler)
    DISPLAY buatPesanan("LND-03", "Andi", 4.0, express)
    DISPLAY buatPesanan("LND-04", "Dewi", 1.5, express)
    DISPLAY buatPesanan("LND-05", "Eko", 0.0, reguler)
END PROCEDURE


--------------------------------------------------------------------------------
5. TABEL TRACEABILITY (UJI KEPATUHAN ATURAN BISNIS)
--------------------------------------------------------------------------------

+------------------------------+--------------------+-----------------------+-----------------------------+
| Business Rule                | Function           | Skenario Pengujian    | Expected Output             |
+------------------------------+--------------------+-----------------------+-----------------------------+
| BR-01 (Berat Minimal 2.0 kg) | hitungBerat()      | Siti - 1.0 kg Reguler | 2 kg x 7000 = Rp 14.000     |
| BR-02 (Tarif Dasar 7.000/kg) | hitungTarifPerKg() | Budi - 3.0 kg Reguler | 3 kg x 7000 = Rp 21.000     |
| BR-03 (Express +50%)         | hitungTarifPerKg() | Andi - 4.0 kg Express | 4 kg x 10500 = Rp 42.000    |
| Kombinasi BR-01 & BR-03      | hitungTotalBiaya() | Dewi - 1.5 kg Express | 2 kg x 10500 = Rp 21.000    |
| Validasi Input Invalid       | buatPesanan()      | Eko - 0.0 kg Reguler  | Gagal: Berat tidak valid    |
+------------------------------+--------------------+-----------------------+-----------------------------+
================================================================================
