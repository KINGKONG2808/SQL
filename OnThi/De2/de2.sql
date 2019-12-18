-- use master 
-- go 
-- create database QLBenhVien
-- go 

use QLBenhVien 
go 
create table BenhVien(
    mabv nvarchar(30) primary key not null,
    tenbv nvarchar(30),
)
go 
create table KhoaKham(
    makhoa nvarchar(30) primary key not null,
    tenkhoa nvarchar(30),
    sobenhnhan int,
    mabv nvarchar(30),
    constraint fk_mabv foreign key (mabv) references BenhVien(mabv),
)
go 
create table BenhNhan(
    mabn nvarchar(30) primary key not null,
    hoten nvarchar(30) not null,
    ngaysinh datetime,
    gioitinh nvarchar(10),
    songaynv int,
    makhoa nvarchar(30),
    constraint fk_makhoa foreign key (makhoa) references KhoaKham(makhoa),
)
go 

insert into BenhVien values ('001', 'Bach Mai')
insert into BenhVien values ('002', 'Viet Duc')
insert into KhoaKham values ('01a', 'Ngoai chan thuong', 100, '001')
insert into KhoaKham values ('02a', 'Noi chan thuong', 200, '002')
insert into BenhNhan values ('001', 'Vu Van Hung', '08/28/1999', 'Nam', 10, '01a')
insert into BenhNhan values ('002', 'Vu Thi Hung', '07/28/1999', 'Nu', 15, '02a')
insert into BenhNhan values ('003', 'Nguyen Khac Hieu', '06/20/1999', 'Nu', 11, '01a')
insert into BenhNhan values ('004', 'Phan Duc Hai', '07/07/1999', 'Nu', 20, '02a')
insert into BenhNhan values ('005', 'Phan Thi Hai', '04/04/1999', 'Nam', 25, '02a')

select * from BenhVien
select * from BenhNhan 
select * from KhoaKham

-- cau 1
create view BenhNhanNu
as 
    select KhoaKham.makhoa, KhoaKham.tenkhoa, count(BenhNhan.mabn) as 'SoNguoi'
    from KhoaKham inner join BenhNhan on KhoaKham.makhoa = BenhNhan.makhoa
    where BenhNhan.gioitinh='nu'
    group by KhoaKham.makhoa, KhoaKham.tenkhoa

select * from BenhNhanNu
