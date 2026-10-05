Markdown# HW 2 — Computational Thinking dengan Dart: System Perhitungan Laundry Digital

**Mata Kuliah:** Aplikasi Mobile (KB1185)  
**Dosen Pengampu:** I Ketut Gunawan, S.Kom., M.TI  
**Nama Mahasiswa:** Fajar Hikmayatul Islami  
**NIM:** 1124160221  

---

## Laporan Analisis & Perancangan Sistem

---

### 1. Problem Statement
Banyak tempat usaha laundry tradisional yang masih mengandalkan kalkulasi biaya secara manual. Hal ini rentan memicu human error (kesalahan hitung), terutama saat berhadapan dengan aturan bisnis khusus seperti ambang batas berat minimal maupun kalkulasi biaya tambahan untuk paket layanan cepat (express). Program ini dirancang untuk memproses dan menghitung total tarif transaksi laundry secara otomatis, akurat, dan terstruktur berbasis algoritma Dart.

---

### 2. Actor
* **Kasir / Admin Laundry**: Operator yang memasukkan data masukan transaksi (berat pakaian dalam kilogram dan jenis paket layanan yang dipilih) serta menyampaikan rincian total tagihan biaya kepada pelanggan.

---

### 3. Input & Output
* **Input**:
  * Berat pakaian dalam satuan kilogram (contoh: 1.0, 1.5, 3.0, 4.0).
  * Jenis paket layanan (opsi terbatas: reguler atau express).
* **Output**:
  * Rincian status pemrosesan transaksi.
  * Total harga pembayaran yang wajib dibayar pelanggan (dalam format Rupiah).
  * Rekapitulasi akumulasi omset seluruh transaksi.

---

### 4. Functional Requirement
* **FR-01**: Sistem dapat memeriksa dan menyesuaikan berat pakaian berdasarkan aturan batas minimal transaksi.
* **FR-02**: Sistem dapat menghitung total tarif berdasarkan jenis paket layanan yang dipilih pelanggan.
* **FR-03**: Sistem dapat mengkalkulasi dan menampilkan hasil akhir total pembayaran serta rekapitulasi data ke layar.

---

### 5. Business Rules (Aturan Bisnis)
* **BR-01 (Batas Minimal Berat)**: Jika berat pakaian di bawah 2 kg (misal: 1.0 kg atau 1.5 kg), maka berat transaksi secara otomatis dibulatkan dan dihitung tetap 2 kg.
* **BR-02 (Tarif Dasar)**: Biaya dasar pengerjaan laundry adalah Rp 7.000 per kg.
* **BR-03 (Layanan Express)**: Jika pelanggan memilih layanan express, dikenakan biaya tambahan sebesar 50% dari total tarif dasar (tarif efektif menjadi Rp 10.500 per kg).

---

### 6. Decomposition (Pemecahan Masalah)
Masalah kompleks perhitungan transaksi laundry dipecah menjadi beberapa fungsi kecil (modular) yang memiliki tanggung jawab spesifik:

* **hitungBeratEfektif(double beratAsli)**: Bertugas memeriksa dan membulatkan berat pakaian ke batas minimal 2 kg apabila berat asli kurang dari 2.0 kg (Implementasi BR-01).
* **hitungTarifPerKg(TipeLayanan layanan)**: Bertugas menetapkan harga per kg berdasarkan jenis layanan, yaitu Rp 7.000/kg untuk reguler dan Rp 10.500/kg untuk express (Implementasi BR-02 & BR-03).
* **hitungTotalBiaya(double beratAsli, TipeLayanan layanan)**: Bertugas mengalikan berat efektif dengan tarif per kg untuk menghasilkan total tagihan.
* **buatPesanan(...)**: Bertugas melakukan validasi input awal, merekam data ke dalam List, dan mengembalikan pesan status.
* **main()**: Bertugas mengeksekusi skenario pengujian (test cases) serta menghitung akumulasi total pendapatan menggunakan fungsi agregasi fold().

---

### 7. Pattern Recognition (Pengenalan Pola)
Setiap transaksi laundry selalu mengikuti pola perhitungan berulang yang konsisten:

```text
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
Rumus Perhitungan Formula Bisnis:Berat Fix: Jika berat kurang dari 2.0 kg, maka beratFix = 2.0 kg.Harga Dasar: totalHarga = beratFix * Rp 7.000.Tambahan Express: Jika express dipilih, totalBiaya = totalHarga + (totalHarga * 0.5).Contoh Perhitungan (3.0 kg, Express):Komponen PerhitunganCara PerhitunganHasil NominalHarga Dasar3.0 kg x Rp 7.000Rp 21.000Tambahan Express (50%)Rp 21.000 x 0.5Rp 10.500Total Biaya AkhirRp 21.000 + Rp 10.500Rp 31.5008. Abstraction (Abstraksi Data)Abstraksi diterapkan untuk menyaring entitas penting dan mengabaikan detail yang tidak relevan dengan masalah transaksi:enum TipeLayanan { reguler, express }:Membatasi opsi pilihan paket pengerjaan laundry agar terhindar dari kesalahan pengetikan manual (typo) dan menjamin tipe data aman.enum StatusPesanan { diterima, diproses, selesai }:Mencatat siklus status pengerjaan cucian pelanggan.class PesananLaundry:Membungkus atribut utama transaksi (idPesanan, namaPelanggan, beratKg, layanan, status).9. Algorithm (Langkah-Langkah Logika)Menerima data masukan berupa ID, Nama, Berat Pakaian (beratKg), dan Tipe Layanan (layanan).Melakukan validasi awal: Jika beratKg <= 0, hentikan proses dan kembalikan pesan gagal.Memeriksa nilai beratKg: Jika kurang dari 2.0 kg, ubah berat efektif menjadi 2.0 kg.Menghitung tarif per kg:Jika layanan == TipeLayanan.express, tarif per kg = 7000 * 1.5 = 10500.Jika layanan == TipeLayanan.reguler, tarif per kg = 7000.Mengalikan berat efektif dengan tarif per kg untuk memperoleh total biaya.Menyimpan objek transaksi ke dalam koleksi List.Mengembalikan pesan konfirmasi berhasil beserta total harga.10. Flowchart (Proses Utama)Plaintext[START]
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
11. PseudocodePlaintextPROCEDURE hitungBeratEfektif(beratAsli)
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
Bagian B — Tabel Traceability (Uji Kepatuhan Aturan Bisnis)Tabel berikut membuktikan bahwa seluruh Business Rules telah terimplementasi dalam fungsi dan teruji pada skenario pengujian:Business Rule (Aturan Bisnis)Function ImplementasiSkenario PengujianHasil yang Diharapkan (Expected)BR-01 (Berat Minimal 2.0 kg)hitungBeratEfektif()Skenario 2 (Siti - 1.0 kg Reguler)Berat dihitung 2 kg x 7000 = Rp 14.000BR-02 (Tarif Dasar Rp 7.000/kg)hitungTarifPerKg()Skenario 1 (Budi - 3.0 kg Reguler)Berat 3 kg x 7000 = Rp 21.000BR-03 (Layanan Express +50%)hitungTarifPerKg()Skenario 3 (Andi - 4.0 kg Express)Berat 4 kg x 10.500 = Rp 42.000Kombinasi BR-01 & BR-03hitungTotalBiaya()Skenario 4 (Dewi - 1.5 kg Express)Berat dihitung 2 kg x 10.500 = Rp 21.000Validasi Input InvalidbuatPesanan()Skenario 5 (Eko - 0.0 kg Reguler)Output: Gagal: Berat laundry tidak valid
