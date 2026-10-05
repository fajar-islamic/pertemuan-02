# HW 2 — Computational Thinking dengan Dart: Aplikasi Laundry Digital

**Mata Kuliah:** Aplikasi Mobile (KB1185)  
**Dosen Pengampu:** I Ketut Gunawan, S.Kom., M.TI  
**Nama:** [Fajar Hikmayatul Islami]  
**NIM:** [1124160221]  

---

## Bagian A — Dokumen Analisis

### 1. Problem Statement
Sistem manajemen transaksi usaha laundry sederhana yang memproses perhitungan tarif pencatatan transaksi secara otomatis dan akurat berdasarkan berat pakaian dan pilihan paket layanan pelanggan.

### 2. Actor
* **Admin / Kasir Laundry**: Menginputkan data transaksi (nama pelanggan, berat pakaian, dan jenis layanan).

### 3. Input & Output
* **Input**: ID Transaksi, Nama Pelanggan, Berat Pakaian (kg), Tipe Layanan (`reguler` / `express`).
* **Output**: Status Transaksi (`Berhasil` / `Gagal`) beserta rincian total biaya pembayaran.

### 4. Business Rules (Aturan Bisnis)
* **BR-01**: Tarif dasar laundry sebesar Rp 7.000 per kg.
* **BR-02**: Ketentuan berat minimal adalah 2 kg. Jika berat pakaian di bawah 2 kg (misal: 1 kg atau 1.5 kg), biaya tetap dihitung 2 kg.
* **BR-03**: Layanan *Express* dikenakan biaya tambahan sebesar 50% dari tarif dasar (menjadi Rp 10.500 per kg).

### 5. Penerapan 4 Pilar Computational Thinking
* **Decomposition**: Memecah logika kalkulasi menjadi beberapa fungsi modular: `hitungBeratEfektif()`, `hitungTarifPerKg()`, dan `hitungTotalBiaya()`.
* **Pattern Recognition**: Menggunakan koleksi `fold()` untuk mengakumulasi total omset dari seluruh transaksi laundry yang berhasil diproses.
* **Abstraction**: Membentuk `enum TipeLayanan` dan `class PesananLaundry` untuk menyaring variabel yang relevan saja.
* **Algorithm**: Menggunakan struktur percabangan `if-else` dan *ternary operator* untuk mengeksekusi aturan bisnis berat minimal dan biaya express.

### 6. Pseudocode
```text
PROCEDURE buatPesanan(id, nama, berat, layanan)
    IF berat <= 0 THEN
        RETURN "Gagal: Berat laundry tidak valid"
    END IF
    
    IF berat < 2.0 THEN
        beratEfektif = 2.0
    ELSE
        beratEfektif = berat
    END IF
    
    tarifPerKg = 7000
    IF layanan == express THEN
        tarifPerKg = tarifPerKg * 1.5
    END IF
    
    totalBiaya = beratEfektif * tarifPerKg
    SAVE pesanan(id, nama, berat, layanan)
    
    RETURN "Berhasil"
END PROCEDURE

BAGIAN A — DOKUMEN ANALISIS1. Problem StatementSistem manajemen transaksi usaha laundry sederhana yang memproses perhitungan tarif pencatatan transaksi secara otomatis dan akurat berdasarkan berat pakaian dan pilihan paket layanan pelanggan.2. ActorAdmin / Kasir Laundry: Menginputkan data transaksi (nama pelanggan, berat pakaian, dan jenis layanan).3. Input & OutputInput: ID Transaksi, Nama Pelanggan, Berat Pakaian (kg), Tipe Layanan (reguler / express).Output: Status Transaksi (Berhasil / Gagal) beserta rincian total biaya pembayaran.4. Business Rules (Aturan Bisnis)BR-01: Tarif dasar laundry sebesar Rp 7.000 per kg.BR-02: Ketentuan berat minimal adalah 2 kg. Jika berat pakaian di bawah 2 kg (misal: 1 kg atau 1.5 kg), biaya tetap dihitung 2 kg.BR-03: Layanan Express dikenakan biaya tambahan sebesar 50% dari tarif dasar (menjadi Rp 10.500 per kg).5. Penerapan 4 Pilar Computational ThinkingDecomposition: Memecah logika kalkulasi menjadi beberapa fungsi modular: hitungBeratEfektif(), hitungTarifPerKg(), dan hitungTotalBiaya().Pattern Recognition: Menggunakan koleksi fold() untuk mengakumulasi total omset dari seluruh transaksi laundry yang berhasil diproses.Abstraction: Membentuk enum TipeLayanan dan class PesananLaundry untuk menyaring variabel yang relevan saja.Algorithm: Menggunakan struktur percabangan if-else dan ternary operator untuk mengeksekusi aturan bisnis berat minimal dan biaya express.6. PseudocodePlaintextPROCEDURE buatPesanan(id, nama, berat, layanan)
    IF berat <= 0 THEN
        RETURN "Gagal: Berat laundry tidak valid"
    END IF
    
    IF berat < 2.0 THEN
        beratEfektif = 2.0
    ELSE
        beratEfektif = berat
    END IF
    
    tarifPerKg = 7000
    IF layanan == express THEN
        tarifPerKg = tarifPerKg * 1.5
    END IF
    
    totalBiaya = beratEfektif * tarifPerKg
    SAVE pesanan(id, nama, berat, layanan)
    
    RETURN "Berhasil"
END PROCEDURE
BAGIAN C — TABEL TRACEABILITYBusiness RuleFunction ImplementasiSkenario PengujianBR-01 (Tarif Dasar Rp 7.000/kg)hitungTarifPerKg()Skenario 1 (Budi - 3kg Reguler)BR-02 (Berat Minimal 2 kg)hitungBeratEfektif()Skenario 2 (Siti - 1kg Reguler) & Skenario 4BR-03 (Layanan Express +50%)hitungTarifPerKg()Skenario 3 (Andi - 4kg Express) & Skenario 4
