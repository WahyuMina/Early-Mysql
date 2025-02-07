USE music;

-- 9.	Buatlah store procedure untuk fungsi search dengan nama search yang menampilkan EmployeeName,
-- Address, Phone, Gender. Fungsi ini akan mencari ke seluruh kolom sesuai inputan. (CREATE PROCEDURE, LIKE, CONCAT)

-- delimiter bisa menggunakan tanda $$,!!,&&
DELIMITER $$ 

-- IN = input
CREATE PROCEDURE search(IN input VARCHAR(255)) -- Parameter / Argument 
BEGIN
    SELECT EmployeeName, Address, Phone, Gender 
    FROM MsEmployee 
    WHERE EmployeeName LIKE CONCAT('%', input, '%') -- 
      OR Address LIKE CONCAT('%', input, '%') 
      OR Phone LIKE CONCAT('%', input, '%') 
      OR Gender LIKE CONCAT('%', input, '%');
END$$

DELIMITER ; -- tanda akhir menggunakan tanda ;

SELECT * FROM MsEmployee;

CALL search("Ma");

drop procedure search;

-- 10.	Buatlah Stored Procedure dengan nama “Check_Transaction” yang menampilkan data CustomerName,
-- EmployeeName, BranchName, MusicIns, Price berdasarkan TransactionID yang diinput.
 
DELIMITER $$ 

create procedure Check_Transaction(in input varchar(255))
begin
	select CustomerName, EmployeeName, BranchName, MusicIns, Price
    from HeaderTransaction as a
    join MsEmployee as b on a.EmployeeID = b.EmployeeID
    join MsBranch as c on b.BranchID = c.BranchID
    join DetailTransaction as d on a.TransactionID = d.TransactionID
    join MsMusicIns as e on d.MusicInsID = e.MusicInsID
    where a.TransactionID like input;
end$$

DELIMITER ;

select * from HeaderTransaction;

call Check_Transaction("TR001");

drop procedure Check_Transaction;

-- 11.	Tampilkan data yang menunjukan detail jumlah transaksi musicins per employee
-- JumlahTransaksi, EmployeeName

select count(a.TransactionID) as JumlahTransaksi, EmployeeName
from HeaderTransaction as a
-- JOIN DetailTransaction AS b ON a.TransactionID = b.TransactionID
join MsEmployee as c on a.EmployeeID = c.EmployeeID
group by EmployeeName;

-- 12.	Buatlah Stored Procedure dengan nama "Add_Stock_MusicIns" untuk menambah stock MusicIns.
-- Jika stock yang diinput lebih kecil atau sama dengan 0, maka akan dimunculkan pesan
-- "Stok yang di input harus lebih besar dari 0"

DELIMITER $$

create procedure Add_Stock_MusicIns(in inputID varchar(255), in inputStock int)
begin
	if exists (select * from MsMusicIns where MusicInsID = inputID) then
		if inputStock <= 0 then
			select 'Stok yang di input harus lebih besar dari 0';
		else
			update MsMusicIns set Stock = Stock + inputStock where MusicInsID = inputID;
		end if;
	else
			select 'Data Tidak ditemukan / Kode yang dimasukkan salah';
	end if;
end$$

DELIMITER ;

select * from MsMusicIns;

call Add_Stock_MusicIns("MI002", 2);

-- drop procedure Add_Stock_MusicIns;

-- 13. Buatlah Stored Procedure dengan nama “Check_Sale” untuk melihat MusicInsType
-- apa saja yang terjual pada bulan tertentu beserta jumlah yang terjualnya.

DELIMITER $$

create procedure Check_Sale(in input varchar(255))
begin
	select a.MusicInsType, sum(c.Qty) as Qty
    from MsMusicInsType a
    join MsMusicIns b on a.MusicInsTypeID = b.MusicInsTypeID
    join DetailTransaction c on b.MusicInsID = c.MusicInsID
    join HeaderTransaction d on c.TransactionID = d.TransactionID
    where monthname(TransactionDate) = input
    group by a.MusicInsType;
end$$

DELIMITER ;

-- Aggregation -> SUM, COUNT, MAX, MIN, AVG
-- Guitar 10
-- Guitar 5

-- + 

-- Guitar 15

 

-- drop procedure Check_Sale;

-- 14.	Buatlah Stored Procedured dengan nama “Check_Employee”
-- yang berfungsi untuk memberikan informasi employeename, address, phone,
-- DateOfBirth, dan BranchName berdasarkan TransactionID. Jika TransactionID
-- tidak dimasukan, maka akan dimunculkan semua data employee yang ada.

DELIMITER $$

create procedure Check_Employee (in input varchar(255))
begin
	if input != '' then
		select a.EmployeeName, a.Address, a.Phone, date_format(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
        from MsEmployee a 
        join MsBranch b on a.BranchID = b.BranchID
        join HeaderTransaction c on a.EmployeeID = c.EmployeeID
        where c.TransactionID = input;
	else 
		SELECT a.EmployeeName, a.Address, a.Phone, DATE_FORMAT(a.DateOfBirth, '%d %M %Y') AS DateOfBirth, b.BranchName
		FROM MsEmployee a
		JOIN MsBranch b ON a.BranchID = b.BranchID;
	END IF;
END$$

DELIMITER ;

call Check_Employee('TR001');

drop procedure Check_Employee;
    