const express = require('express');
const pool = require('./db');
const app = express();

app.use(express.json());


// 1. METODE GET: Dapatkan semua data obat
app.get('/api/obat', async (req, res) => {
    try {
        const allObat = await pool.query('SELECT * FROM obat ORDER BY id ASC');
        res.json(allObat.rows);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
});

// 2. METODE GET: Dapatkan data obat berdasarkan ID
app.get('/api/obat/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const obat = await pool.query('SELECT * FROM obat WHERE id = $1', [id]);
        
        if (obat.rows.length === 0) {
            return res.status(404).json({ message: 'Data obat tidak ditemukan' });
        }
        
        res.json(obat.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
});

// 3. METODE POST: Membuat data obat baru
app.post('/api/obat', async (req, res) => {
    try {
        const { nama_obat, kategori, stok, satuan } = req.body;
        const newObat = await pool.query(
            'INSERT INTO obat (nama_obat, kategori, stok, satuan) VALUES ($1, $2, $3, $4) RETURNING *',
            [nama_obat, kategori, stok, satuan]
        );
        res.status(201).json({ message: 'Data obat berhasil ditambahkan', data: newObat.rows[0] });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
});

// 4. METODE PUT: Memperbarui data obat berdasarkan ID
app.put('/api/obat/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nama_obat, kategori, stok, satuan } = req.body;
        
        const updateObat = await pool.query(
            'UPDATE obat SET nama_obat = $1, kategori = $2, stok = $3, satuan = $4 WHERE id = $5 RETURNING *',
            [nama_obat, kategori, stok, satuan, id]
        );

        if (updateObat.rows.length === 0) {
            return res.status(404).json({ message: 'Data obat tidak ditemukan untuk di-update' });
        }

        res.json({ message: 'Data obat berhasil diperbarui', data: updateObat.rows[0] });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
});

// 5. METODE DELETE: Menghapus data obat berdasarkan ID
app.delete('/api/obat/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const deleteObat = await pool.query('DELETE FROM obat WHERE id = $1 RETURNING *', [id]);

        if (deleteObat.rows.length === 0) {
            return res.status(404).json({ message: 'Data obat tidak ditemukan untuk dihapus' });
        }

        res.json({ message: 'Data obat berhasil dihapus' });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: err.message });
    }
});

// Menjalankan Server pada Port 3000
const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});