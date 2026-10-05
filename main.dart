// =============================================
// HW 2 - Aplikasi Manajemen Laundry Digital
// Nama : [Fajar Hikmayatul Islami]
// NIM  : [1124160221]
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

// ---------- DATA ----------
final List<PesananLaundry> daftarPesanan = [];

// ---------- DECOMPOSITION ----------

// BR-01: Menghitung berat efektif (minimal 2kg)
double hitungBeratEfektif(double beratAsli) {
  if (beratAsli <= 0) return 0.0;
  return beratAsli < 2.0 ? 2.0 : beratAsli;
}

// BR-02: Menghitung tarif per kg berdasarkan tipe layanan
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

// ---------- TEST SCENARIO ----------
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
