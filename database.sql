-- ========================================================
-- SKEMA DATABASE: SISTEM INFORMASI POSYANDU & KESEHATAN DESA
-- ========================================================

-- 1. Tabel Peran (Master Hak Akses)
CREATE TABLE peran (
    id SERIAL PRIMARY KEY,
    nama_peran VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel Pengguna (Akun Login Pengguna)
CREATE TABLE pengguna (
    id SERIAL PRIMARY KEY,
    peran_id INT NOT NULL,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pengguna_peran FOREIGN KEY (peran_id) REFERENCES peran(id) ON DELETE CASCADE
);

-- 3. Tabel Pasien (Detail Profil Pasien / Ibu & Anak)
CREATE TABLE pasien (
    id SERIAL PRIMARY KEY,
    pengguna_id INT NOT NULL UNIQUE,
    nik VARCHAR(16) NOT NULL UNIQUE,
    nama_lengkap VARCHAR(150) NOT NULL,
    jenis_kelamin VARCHAR(10) NOT NULL,
    tanggal_lahir DATE NOT NULL,
    alamat TEXT NOT NULL,
    nomor_telepon VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pasien_pengguna FOREIGN KEY (pengguna_id) REFERENCES pengguna(id) ON DELETE CASCADE
);

-- 4. Tabel Obat (Stok Obat & Vitamin)
CREATE TABLE obat (
    id SERIAL PRIMARY KEY,
    nama_obat VARCHAR(100) NOT NULL,
    kategori VARCHAR(50) NOT NULL,
    stok INT NOT NULL DEFAULT 0,
    satuan VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabel Jadwal (Jadwal Kegiatan Posyandu Bulanan)
CREATE TABLE jadwal (
    id SERIAL PRIMARY KEY,
    dibuat_oleh INT NOT NULL,
    judul VARCHAR(150) NOT NULL,
    tanggal_kegiatan DATE NOT NULL,
    lokasi VARCHAR(200) NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_jadwal_pembuat FOREIGN KEY (dibuat_oleh) REFERENCES pengguna(id) ON DELETE CASCADE
);

-- 6. Tabel Pemeriksaan (Catatan Hasil Pemeriksaan Medis)
CREATE TABLE pemeriksaan (
    id SERIAL PRIMARY KEY,
    pasien_id INT NOT NULL,
    jadwal_id INT NOT NULL,
    berat_badan NUMERIC(5, 2) NOT NULL,
    tinggi_badan NUMERIC(5, 2) NOT NULL,
    catatan TEXT,
    tanggal_pemeriksaan TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pemeriksaan_pasien FOREIGN KEY (pasien_id) REFERENCES pasien(id) ON DELETE CASCADE,
    CONSTRAINT fk_pemeriksaan_jadwal FOREIGN KEY (jadwal_id) REFERENCES jadwal(id) ON DELETE CASCADE
);

-- 7. Tabel Peserta Jadwal (Tabel Pivot Kehadiran - Many-to-Many)
CREATE TABLE peserta_jadwal (
    id SERIAL PRIMARY KEY,
    jadwal_id INT NOT NULL,
    pasien_id INT NOT NULL,
    status_kehadiran VARCHAR(20) DEFAULT 'Hadir',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_peserta_jadwal FOREIGN KEY (jadwal_id) REFERENCES jadwal(id) ON DELETE CASCADE,
    CONSTRAINT fk_peserta_pasien FOREIGN KEY (pasien_id) REFERENCES pasien(id) ON DELETE CASCADE,
    CONSTRAINT unique_jadwal_pasien UNIQUE (jadwal_id, pasien_id)
);