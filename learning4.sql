create database review;
use review;

-- drop database review;

create table Mahasiswa
(
	NIM char(10) primary key,
    Nama varchar(100),
    Alamat varchar(150),
    Gender char(1)
    constraint CheckGender check(Gender = 'L' or Gender = 'P')
);

select * from Mahasiswa;

-- Query Alter digunakan untuk mengupdate dan juga masukkan Data ke dalam table  

alter table Mahasiswa
add Email varchar(100);

-- drop table Mahasiswa;

insert into Mahasiswa (NIM, Nama, Gender, Alamat)
values ('2001541876', 'Budi', 'L', 'Jalan Panjanag');

INSERT INTO Mahasiswa 
VALUES ('2001541871', 'Andi', 'Jalan Panjang 2', 'L');

select NIM, Nama as 'Nama Saya' from Mahasiswa;

select * from Mahasiswa
where NIM = '2001541876';

START TRANSACTION;

-- Update digunakan mengupdate data yang dipilih untuk mengubah data tersebut

update Mahasiswa 
set Nama = 'abc'
where NIM = '2001541876';

rollback;
commit;

update Mahasiswa 
set Nama = 'Jacky',
Alamat = 'Jalan Pendek'
where NIM = '2001541876';

delete from Mahasiswa
where NIM = '2001541876';

-- Query Auto_Increment ketika digunakan pada saat primary key tidak perlu isi nilai bulatnya lagi, karena otomasti diisi sendiri

create table Sks 
(
	ID int not null auto_increment,
    NIM char(10),
    JumlahSks int,
    primary key(ID),
    foreign key(NIM) references Mahasiswa(NIM)
);

select * from Sks;
select * from Mahasiswa;

-- INSERT INTO Sks VALUES('2001541876', 20);

INSERT INTO Sks(NIM, JumlahSks) VALUES('2001541876', 20);
INSERT INTO Sks(NIM, JumlahSks) VALUES('2001541871', 10);

-- Ketika di run kan hasilnya di sks maka nim "2001541876" tidak akan dipenuhi, karena data tersebut tidak ada di foreign key "NIM" nya di tabel mahasiswa.
INSERT INTO Sks(NIM, JumlahSks) VALUES('2001541877', 20);

delete from Sks where NIM = "2001541876";

-- Query Join digunakan untuk menghubungkan dua tabel.
-- OPSI 1 
select a.NIM, Nama, JumlahSks
from Mahasiswa a join Sks b on a.NIM = b.NIM;

-- OPSI 2
-- Tetapi OPSI ini ada yang berhasil ada yang juga tidak berhasil digabungkan tabel ketika data lain tersebut. 
select Mahasiswa.NIM, Nama, JumlahSks
from Mahasiswa, Sks
where Mahasiswa.NIM = Sks.NIM;

CREATE VIEW vw_mahasiswa_sks
AS
SELECT a.NIM, Nama, JumlahSks
FROM Mahasiswa a JOIN Sks b ON a.NIM = b.NIM;

select * from Mahasiswa;

select * from vw_mahasiswa_sks;

drop view vw_mahasiswa_sks;

SET GLOBAL log_bin_trust_function_creators = 1;

-- Function 

DELIMITER //
CREATE FUNCTION returnInteger()
RETURNS INT
BEGIN
	RETURN 10;
END; //

DELIMITER ;

SELECT returnInteger();

DELIMITER //
CREATE FUNCTION returnWord()
RETURNS VARCHAR(10)
BEGIN
	RETURN 'HELLO';
END; //
DELIMITER ;

SELECT returnWord() ;

DELIMITER //
CREATE FUNCTION sksKurang(Jumlah INT) -- Jumlah
RETURNS INT
BEGIN
	RETURN (Jumlah - 10);
END; //
DELIMITER ;

select sksKurang(20);
select * from sks;

select NIM, sksKurang(JumlahSks)
from Sks;

SELECT * FROM Sks;

insert into Sks(NIM, JumlahSks) VALUES ('2001541871', 30);

-- Avg (AVERATE) digunakan untuk rata-rata nilai 

select avg(JumlahSks) as 'Rata-rata'
from Sks;

select nim, sum(JumlahSks) as 'Total SKS'
from Sks
group by NIM
having sum(JumlahSks) > 10; -- Where + Aggregation = Having

DELIMITER //
CREATE PROCEDURE update_dan_select(p_nim  CHAR(10))
BEGIN
	update Sks
	set JumlahSks = sksKurang(JumlahSks) -- JumlahSks + 10
	WHERE NIM = p_nim ;
    
	select * from Sks WHERE NIM = p_nim ;
END; //
DELIMITER ;

DROP PROCEDURE update_dan_select;

SELECT * FROM sks;
CALL update_dan_select('2001541871');



