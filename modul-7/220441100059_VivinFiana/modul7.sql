CREATE DATABASE modul7;
USE modul7;
drop database modul7;

CREATE TABLE mobil (
	id_mobil INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	merk VARCHAR (50) NOT NULL,
	model VARCHAR (50) NOT NULL,
	tahun INT (11) NOT NULL,
	warna VARCHAR (20) NOT NULL,
	harga_sewa DECIMAL (10,2) NOT NULL,
	STATUS ENUM ('Dipinjam','Tersedia')
);
INSERT INTO mobil (merk, model, tahun, warna, harga_sewa, STATUS) VALUES
	('Toyota', 'Avanza', 2020, 'Putih', 480000, 'Tersedia'),
	('Hond', 'Civic', 2019, 'Putih', 460000, 'Dipinjam'), 
	('Mitsubishi', 'Pajero', 2022, 'Abu-abu', 500000, 'Tersedia'),
	('Renault', 'Koleos', 2018, 'Abu-Abu', 490000, 'Dipinjam'),
	('BMW', 'X5', 2020, 'Hitam', 700000, 'Tersedia');
SELECT * FROM mobil;

CREATE TABLE perawatan (
	id_perawatan INT (11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_mobil INT (11)NOT NULL ,
	tanggal DATE NOT NULL,
	deskripsi TEXT NOT NULL ,
	biaya DECIMAL (10,2) NOT NULL,
	FOREIGN KEY (id_mobil)REFERENCES mobil(id_mobil)
);
INSERT INTO perawatan (id_mobil, tanggal, deskripsi, biaya) VALUES
	(1, '2024-01-10', 'Ganti aki', 350000.00),
	(2, '2024-02-20', 'Ganti oli mesin', 500000.00),
	(3, '2024-03-30', 'Servis rutin', 750000.00),
	(4, '2024-04-15', 'Perbaikan AC', 500000.00),
	(5, '2024-05-25', 'Pengecekan rem', 300000.00);
SELECT * FROM perawatan;


CREATE TABLE pelanggan (
	id_pelanggan INT (11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nama VARCHAR (100) NOT NULL,
	alamat TEXT NOT NULL,
	no_telepon VARCHAR (15)NOT NULL,
	email VARCHAR (50) NOT NULL 
);
INSERT INTO pelanggan (nama, alamat, no_telepon, email) VALUES
	('Imam Bukhori', 'Jl. Teratai No. 3, Jakarta', '081234567802', 'imam@gmail.com'),
	('Martha Mainolo', 'Jl. Bougenville No. 4, Jakarta', '081234567803', 'martha@gmail.com'),
	('Elly Ermawati', 'Jl. Alamanda No. 5, Jakarta', '081234567804', 'elly@gmail.com'),
	('Syaiful Anam', 'Jl. Asoka No. 6, Jakarta', '081234567805', 'anam@gmail.com'),
	('Yudistira Girindra', 'Jl. Bakung No. 7, Jakarta', '081234567806', 'yudis@gmail.com');
SELECT * FROM pelanggan;


CREATE TABLE pegawai(
	id_pegawai INT (11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nama VARCHAR (50) NOT NULL,
	jabatan VARCHAR (50) NOT NULL,
	no_telepon VARCHAR (15)NOT NULL,
	email VARCHAR (50) NOT NULL 
);
INSERT INTO pegawai (nama, jabatan, no_telepon, email) VALUES
	('Irsyad Mubarok', 'Manager', '084567890123', 'irsyad@gmail.com'),
	('Risalatul Hikmah', 'Administrasi', '085678901234', 'risa@gmail.com'),
	('Malikhatul Atthiyah', 'Marketing', '086789012345', 'malika@gmail.com'),
	('Hidayat Rozikim', 'Mekanik', '087890123456', 'dayat@gmail.com'),
	('Lisha Nur Cahyani', 'Kasir', '088901234567', 'lisha@gmail.com');
SELECT * FROM pegawai;


CREATE TABLE transaksi (
	id_transaksi INT (11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_pelanggan INT (11) NOT NULL,
	id_mobil INT (11) NOT NULL,
	id_pegawai INT (11) NOT NULL,
	tanggal_mulai DATE NOT NULL,
	tanggal_Selesai DATE NOT NULL,
	total_biaya DECIMAL (10,2) NOT NULL,
	status_transaksi ENUM ('Belum Selesai','Selesai') NOT NULL,
	FOREIGN KEY (id_pelanggan) REFERENCES pelanggan(id_pelanggan),
	FOREIGN KEY (id_mobil) REFERENCES mobil(id_mobil),
	FOREIGN KEY (id_pegawai) REFERENCES pegawai(id_pegawai)
);
INSERT INTO transaksi (id_pelanggan, id_mobil, id_pegawai, tanggal_mulai, tanggal_selesai, total_biaya, status_transaksi) VALUES
	(1, 1, 4, '2024-05-01', '2024-05-05', 300000.00, 'Belum Selesai'),
	(2, 2, 4, '2024-05-10', '2024-05-15', 350000.00, 'Selesai'),
	(3, 3, 4, '2024-05-16', '2024-05-20', 240000.00, 'Belum Selesai'),
	(4, 4, 4, '2024-05-21', '2024-05-25', 400000.00, 'Selesai'),
	(5, 5, 4, '2024-05-26', '2024-05-30', 600000.00, 'Selesai');
SELECT * FROM transaksi;

CREATE TABLE pembayaran (
	id_pembayaran INT (11) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	id_transaksi INT(11) NOT NULL,
	tanggal_pembayaran DATE NOT NULL,
	jumlah_pembayaran DECIMAL (10,2),
	metode_pembayaran VARCHAR (50),
	FOREIGN KEY (id_transaksi) REFERENCES transaksi (id_transaksi)
);
INSERT INTO pembayaran (id_transaksi, tanggal_pembayaran, jumlah_pembayaran, metode_pembayaran) VALUES
	(1, '2024-05-05', 450000.00, 'Transfer Bank'),
	(2, '2024-05-15', 600000.00, 'Tunai'),
	(3, '2024-05-10', 240000.00, 'QRis'),
	(4, '2024-05-25', 640000.00, 'Transfer Bank');
SELECT * FROM pembayaran;

-- NOMOR 1
DELIMITER //
CREATE TRIGGER after_update_transaksi
	AFTER UPDATE ON transaksi
	FOR EACH ROW
BEGIN
	IF new.status_transaksi = 'Selesai' THEN
		UPDATE mobil SET STATUS = 'Tersedia' WHERE id_mobil=new.id_mobil;
	END IF;
END //
DELIMITER ;

UPDATE transaksi SET status_transaksi='Selesai' WHERE id_transaksi = 1;
 
SELECT * FROM transaksi; 
SELECT * FROM mobil;

-- NOMOR 2
CREATE TABLE log_pembayaran (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_pembayaran INT NOT NULL,
    id_transaksi INT NOT NULL,
    tanggal_pembayaran DATE NOT NULL,
    jumlah_pembayaran DECIMAL(10, 2) NOT NULL,
    metode_pembayaran VARCHAR(50) NOT NULL,
    TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- waktu data dicatat dg nilai default
);

DELIMITER //
CREATE TRIGGER after_insert_pembayaran
	AFTER INSERT ON pembayaran
	FOR EACH ROW
BEGIN 
	INSERT INTO log_pembayaran (id_pembayaran, id_transaksi, tanggal_pembayaran, jumlah_pembayaran, metode_pembayaran)
	VALUES (new.id_pembayaran, new.id_transaksi, new.tanggal_pembayaran, new.jumlah_pembayaran, new.metode_pembayaran);

END //
DELIMITER ;

INSERT INTO pembayaran (id_transaksi, tanggal_pembayaran, jumlah_pembayaran, metode_pembayaran) VALUES 
(5, '2024-05-15', 200000.00, 'Tunai'),
(6, "2024-05-20", 300000.00, 'Transfer Bank');

SELECT * FROM pembayaran;
SELECT * FROM log_pembayaran;


-- NOMOR 3
DELIMITER //
CREATE TRIGGER before_insert_transaksi
	BEFORE INSERT ON transaksi
	FOR EACH ROW
BEGIN
    DECLARE harga_per_hari DECIMAL(10, 2);
    DECLARE jumlah_hari INT;

    -- Mendapatkan harga sewa per hari dari tabel mobil
    SELECT harga_sewa INTO harga_per_hari FROM mobil WHERE id_mobil = new.id_mobil;

    -- menghitung jumlah hari dg selisih hari dr tanggal selesai dan tanggal mulai. 
    SET jumlah_hari = DATEDIFF(new.tanggal_selesai, new.tanggal_mulai);

    -- Menghitung total biaya
    SET new.total_biaya = harga_per_hari * jumlah_hari;
END //
DELIMITER ;

INSERT INTO transaksi (id_pelanggan, id_mobil, id_pegawai, tanggal_mulai, tanggal_selesai, status_transaksi) 
VALUES (3, 3, 3, '2024-05-16', '2024-05-20', 'Belum Selesai');

SELECT * FROM mobil;
SELECT * FROM transaksi;

-- NOMOR 4
CREATE TABLE log_hapus_transaksi (
    id_log INT AUTO_INCREMENT PRIMARY KEY,
    id_transaksi INT NOT NULL,
    id_pelanggan INT NOT NULL,
    id_mobil INT NOT NULL,
    tanggal_mulai DATE NOT NULL,
    tanggal_selesai DATE NOT NULL,
    total_biaya DECIMAL(10, 2) NOT NULL,
    TIMESTAMP TIMESTAMP DEFAULT CURRENT_TIMESTAMP   -- waktu data dicatat dg nilai default
);

DELIMITER //
CREATE TRIGGER before_delete_transaksi
	BEFORE DELETE ON transaksi
	FOR EACH ROW
BEGIN
    INSERT INTO log_hapus_transaksi (id_transaksi, id_pelanggan, id_mobil, tanggal_mulai, tanggal_selesai, total_biaya)
    VALUES (OLD.id_transaksi, OLD.id_pelanggan, OLD.id_mobil, OLD.tanggal_mulai, OLD.tanggal_selesai, OLD.total_biaya);
END //
DELIMITER ;

DELETE FROM pembayaran WHERE id_transaksi = 2;
DELETE FROM transaksi WHERE id_transaksi = 1;

SELECT * FROM log_hapus_transaksi;