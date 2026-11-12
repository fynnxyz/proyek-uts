# Filter Wajah AR: Wisuda dan Kampus (Prototipe v0.5)

Aplikasi Augmented Reality (AR) berbasis web yang menempelkan aksesori 3D beranimasi bertema wisuda dan kehidupan kampus secara *real-time* pada wajah pengguna melalui browser smartphone.

Proyek ini disusun untuk memenuhi tugas Miniproject UTS mata kuliah **Praktikum Augmented dan Virtual Reality (ITIA730591)**, Program Studi Teknologi Informasi, Fakultas Ilmu Komputer dan Teknologi Informasi (FIKTI), Universitas Muhammadiyah Sumatera Utara (UMSU).

## Teknologi yang Digunakan
* **Three.js** (`v0.175.0`) — Rendering objek dan klip animasi 3D
* **MindAR** — *Face tracking* berbasis web
* **HTML5, CSS3, JavaScript (ES Modules)** — Antarmuka pengguna (HUD) dan logika interaksi
* **GitHub Pages** — Hosting HTTPS untuk akses kamera perangkat mobile

## Anggota Kelompok & Pembagian Tugas
| No | Nama | NPM | Peran | Tanggung Jawab Utama |
| :--- | :--- | :--- | :--- | :--- |
| 1 | Muhammad Rafly | 2409020044 | Project Manager & Integrator | Papan tugas, pengelolaan repository & *merge*, *deployment* HTTPS, kode QR |
| 2 | Gilang Indra Trisanu | 2409020076 | Engineer Tracking | MindAR *face tracking*, kalibrasi titik tempel wajah, uji kestabilan cahaya |
| 3 | Fanny Fadhillah | 2409020083 | Aset 3D & Animasi | Model 3D `.glb`, klip animasi *idle*/*loop*, optimasi ukuran file, tabel lisensi aset |
| 4 | M. Vicky Azhari | 2409020070 | Interaksi & UI/UX | HUD, tombol ganti filter, tombol ambil foto, penanganan izin kamera ditolak |
| 5 | R. Gilang Setyo Nugroho | 2409020019 | Data, Persistence, QA & Dokumentasi | Struktur `filters.json`, simpan foto ke perangkat, `docs/device-matrix.md`, `README.md`, video demo, *issue log* |

## Daftar Fitur (v0.5)

### Fitur Wajib
* **Face Tracking Real-Time:** Mendeteksi wajah dan menempelkan minimal 2 model aksesori 3D (`.glb`) secara stabil (misalnya Topi Toga dan Kacamata Kampus).
* **Animasi 3D Aktif:** Menjalankan minimal 1 animasi *idle* atau *loop* pada aksesori (seperti tali toga yang bergoyang).
* **Ganti Filter Dinamis:** Tombol untuk berpindah antar aksesori yang datanya dimuat dari file `filters.json`.
* **Ambil & Simpan Foto:** Menangkap tampilan kamera beserta filter 3D dan menyimpannya langsung ke perangkat pengguna.
* **Penanganan Izin Kamera:** Menampilkan pesan instruksi yang jelas apabila akses kamera ditolak oleh pengguna.

### Fitur Pilihan (Opsional)
* Menyimpan pilihan filter terakhir menggunakan `localStorage`.
* Dukungan pergantian kamera depan dan belakang.

## Struktur Folder
```text
├── assets/
│   ├── models/           # File model 3D beranimasi (.glb)
│   └── icons/            # Ikon tombol antarmuka
├── data/
│   └── filters.json      # Konfigurasi daftar filter dan parameter posisi/skala
├── docs/
│   ├── device-matrix.md  # Hasil pengujian perangkat Android & iPhone
│   └── asset-licenses.md # Tabel lisensi dan atribusi aset 3D
├── src/
│   ├── main.js           # Inisialisasi MindAR, Three.js, dan loop render
│   └── ui.js             # Logika tombol filter, ambil foto, dan error handling
├── index.html            # Halaman utama aplikasi
└── README.md             # Dokumentasi proyek