create database music;
use music;

-- drop database music (Menjatuhkan database)
/* 
	DROP TABLE DetailTransaction
   	DROP TABLE HeaderTransaction
   	DROP TABLE MsMusicIns
   	DROP TABLE MsMusicInsType
   	DROP TABLE MsEmployee
   	DROP TABLE MsBranch
*/

create table MsBranch
(
	BranchID varchar(6) primary key,
   	BranchName varchar(50)  Not Null,
   	Address varchar(100) Not Null,
    Phone varchar(50),
    constraint CheckBran1 check(char_length(BranchID)=5),
    constraint CheckBran2 check(BranchID regexp '^BR[0-9][0-9][0-9]$')
    -- regexp (Reguler Expression) EX = BR000
    -- ^ (Awali setelah BR) 
);

create table MsMusicInsType
(
	MusicInsTypeID varchar(6) primary key,
   	MusicInsType varchar(50) not null, 
    constraint CheckMsct1 check(char_length(MusicInsTypeID)=5),
    constraint CheckMsct2 check(MusicInsTypeID regexp 'MT[0-9][0-9][0-9]')
);

-- drop table MsMusicInsType;

create table MsEmployee
(
	EmployeeID varchar(6) primary key,	-- Variable Character
	EmployeeName varchar(50) not null,
	Address varchar(100) not null,
	Phone varchar(50),
   	Gender char(1) not null, --  M / F Example: M (1 char)
    DateOfBirth datetime,
    salary decimal(10,2), -- 5000000,16 <-- angka 16 yang dipanggil
    BranchID varchar(6),
    constraint CheckEmpl1 check(char_length(EmployeeID)=5),
    constraint CheckEmpl2 check(EmployeeID regexp 'EM[0-9][0-9][0-9]'),
    constraint CheckEmpl3 check(Gender in ('M','F')),
	constraint FK_MsEmployee_MsBranch foreign key (BranchID) references MsBranch (BranchID) on update cascade on delete set null -- BR001 -> BR000	
);

-- drop table MsEmployee;

create table MsMusicIns
(
	MusicInsID varchar(6) primary key,
    MusicIns	varchar(50) not null,
    Price 	decimal(10,2) not null, -- 10.00 itu desimal
    Stock int not null, -- 10
    MusicInsTypeID varchar(6),
    constraint	CheckMsci1 check (char_length(MusicInsID)=5),
    constraint 	CheckMsci2 check (MusicInsID regexp 'MI[0-9][0-9][0-9]'),
    constraint 	CheckMsci3 check (Stock >= 0),
    constraint FK_MsMusicIns_MsMusicInsType foreign key (MusicInsTypeID) references MsMusicInsType(MusicInsTypeID) on update cascade on delete set null
);

create table HeaderTransaction
(
	TransactionID varchar(6) primary key,
	TransactionDate datetime not null,
    EmployeeID varchar(6) references MsEmployee(EmployeeID) on update cascade on delete set null,
    CustomerName varchar(50),
    check (char_length(TransactionID)=5),
    check (TransactionID regexp 'TR[0-9][0-9][0-9]')
);

create table DetailTransaction
(
	TransactionID varchar(6) references HeaderTransaction(TransactionID) on update cascade on delete cascade,
    MusicInsID varchar(6) references MsMusicIns(MusicInsID) on update cascade on delete cascade,
    Qty  int not null,
    primary key (TransactionID, MusicInsID)
);

-- 		CF2	 		--

select * from MsBranch;
select * from MsEmployee;
select * from MsMusicInsType;
select * from MsMusicIns;
select * from HeaderTransaction;
select * from DetailTransaction;

insert into MsBranch values ('BR001','Cabang Merdeka','Jl. Gang Merdeka No. 17','021-7771234');
insert into MsBranch values ('BR002','Cabang Sejahtera','Jl. Sejahtera Sehat Selalu No. 88','022-2008972');
insert into MsBranch values ('BR003','Cabang Adil','Jl. Adil No. 33','021-8983234');
insert into MsBranch values ('BR004','Cabang Makmur','Jl. Gang Makmur No. 12','021-6526321');
insert into MsBranch values ('BR005','Cabang Damai','Jl. Damai Aman Sentosa No. 45','044-8989898');

insert into MsEmployee values ('EM001','Kikis Sabrina Mona','Jl. Putar-Putar No. 8','022-1239995','F','1989-03-21','3500000','BR001');
insert into MsEmployee values ('EM002','Marlene Martani','Jl. Gajebo No. 32','022-5675542','F','1988-06-14','4250000','BR002');
insert into MsEmployee values ('EM003','Rakhmat Suryahadi','Gang Gansing No. 19','021-3451232','M','1988-01-30','3670000','BR002');
insert into MsEmployee values ('EM004','Suhandi','Jl. Pintu Lima No. 5','022-4519377','M','1985-02-10','5600000','BR001');
insert into MsEmployee values ('EM005','Lisye Mareta Cahya','Jl. Gang Medan Merdeka No. 25','021-9798123','F','1986-12-12','5400000','BR001');
insert into MsEmployee values ('EM006','Sofian Chandra','Jl. Putar-Putar No. 12','021-8763445','M','1987-12-11','5500000','BR005');
insert into MsEmployee values ('EM007','William Salim','Jl. Pusing-Pusing No. 76','022-4859345','M','1987-08-14','5490000','BR005');
insert into MsEmployee values ('EM008','William Wijaya','Jl. Gichung No. 10','022-7859123','M','1989-11-04','5590000','BR003');
  
insert into MsMusicInsType values ('MT001','Guitar');
insert into MsMusicInsType values ('MT002','Violin');
insert into MsMusicInsType values ('MT003','Piano');
insert into MsMusicInsType values ('MT004','Drum');
insert into MsMusicInsType values ('MT005','Keyboard');

insert into MsMusicIns values ('MI001','Yamaha CX-40','1150000','23','MT001');
insert into MsMusicIns values ('MI002','Yamaha KX-5000','5950000','12','MT005');
insert into MsMusicIns values ('MI003','Yamaha C-390','1250000','10','MT001');
insert into MsMusicIns values ('MI004','Excellent P-77','25700000','17','MT003');
insert into MsMusicIns values ('MI005','Board B-123','5650000','30','MT005');
insert into MsMusicIns values ('MI006','Pearl Q-300','9570000','26','MT004');
insert into MsMusicIns values ('MI007','Supernova X-23','4510000','56','MT002');
insert into MsMusicIns values ('MI008','Yamaha Grand X-1','49750000','12','MT003');

insert into HeaderTransaction values ('TR001','2010-10-02 15:30:00.000','EM003','Veronica');
insert into HeaderTransaction values ('TR002','2010-10-15 09:50:00.000','EM008','Richard Parker');
insert into HeaderTransaction values ('TR003','2010-10-16 13:26:00.000','EM005','Steven Michael');
insert into HeaderTransaction values ('TR004','2010-11-22 10:55:00.000','EM004','Anabelle Setiawan Wati');
insert into HeaderTransaction values ('TR005','2010-11-25 15:30:00.000','EM003','Michelle Regina');
insert into HeaderTransaction values ('TR006','2010-12-13 08:23:00.000','EM001','Dian Sastro');
insert into HeaderTransaction values ('TR007','2010-12-13 18:19:00.000','EM001','Cathy');
insert into HeaderTransaction values ('TR008','2010-12-27 15:21:00.000','EM006','Stephanie Meyer');
insert into HeaderTransaction values ('TR009','2010-01-02 10:28:00.000','EM007','Michael J.');
insert into HeaderTransaction values ('TR010','2010-01-03 12:39:00.000','EM002','Arnold Swasana Segar');

insert into DetailTransaction values ('TR001','MI001','1');
insert into DetailTransaction values ('TR001','MI004','2');
insert into DetailTransaction values ('TR002','MI003','1');
insert into DetailTransaction values ('TR002','MI005','2');
insert into DetailTransaction values ('TR002','MI008','5');
insert into DetailTransaction values ('TR003','MI007','4');
insert into DetailTransaction values ('TR004','MI004','3');
insert into DetailTransaction values ('TR004','MI006','3');
insert into DetailTransaction values ('TR005','MI002','1');
insert into DetailTransaction values ('TR006','MI001','2');
insert into DetailTransaction values ('TR007','MI003','3');
insert into DetailTransaction values ('TR007','MI006','5');
insert into DetailTransaction values ('TR008','MI002','3');
insert into DetailTransaction values ('TR008','MI004','2');
insert into DetailTransaction values ('TR008','MI008','1');
insert into DetailTransaction values ('TR009','MI002','2');
insert into DetailTransaction values ('TR009','MI005','4');
insert into DetailTransaction values ('TR010','MI001','2');
insert into DetailTransaction values ('TR010','MI003','2');
insert into DetailTransaction values ('TR010','MI004','2');
insert into DetailTransaction values ('TR011','MI004','1');
insert into DetailTransaction values ('TR011','MI005','1'); 

select MusicInsTypeID, MusicIns from MsMusicIns;
select MusicInsID, Qty from DetailTransaction where TransactionID = 'TR011';

UPDATE DetailTransaction 
SET Qty = 3
WHERE TransactionID = 'TR011' AND MusicInsID = 'MI005' ;

UPDATE DetailTransaction 
SET Qty = 5
WHERE TransactionID = 'TR011';

DELETE FROM DetailTransaction WHERE TransactionID = 'TR011'; 

UPDATE DetailTransaction SET QTY = 5;

DELETE FROM DetailTransaction; 
