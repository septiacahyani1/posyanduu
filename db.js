const { Pool } = require('pg');

const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'posyanduu', 
  password: '123', 
  port: 5432,
});

pool.connect((err, client, release) => {
  if (err) {
    console.error('❌ DETAIL ERROR KONEKSI:', err.stack);
  } else {
    console.log('✅ BERHASIL KONEK KE DATABASE POSYANDUU!');
    release();
  }
});

module.exports = pool;