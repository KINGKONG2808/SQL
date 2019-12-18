-- use master
-- go 
-- create database QLSinhVien

use QLSinhVien 
go 
create table Khoa(
    makhoa nvarchar(30) primary key not null,
    tenkhoa nvarchar(30),
)
go 
create table Lop(
    malop nvarchar(30) primary key not null,
    tenlop nvarchar(30) not null,
    siso int,
    makhoa nvarchar(30),
    constraint fk_khoa foreign key (makhoa) references Khoa(makhoa),
)
go 
create table SinhVien(
    masv nvarchar(30) primary key not null,
    hoten nvarchar(30) not null,
    ngaysinh datetime,
    gioitinh nvarchar(10),
    malop nvarchar(30),
    constraint fk_malop foreign key (malop) references Lop(malop),
)
go 
