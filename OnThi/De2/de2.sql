-- use master 
-- go 
-- create database QLBenhVien
-- go 

-- cau 1
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

-- cau 2
create view BenhNhanNu
as 
    select KhoaKham.makhoa, KhoaKham.tenkhoa, count(BenhNhan.mabn) as 'SoNguoi'
    from KhoaKham inner join BenhNhan on KhoaKham.makhoa = BenhNhan.makhoa
    where BenhNhan.gioitinh='nu'
    group by KhoaKham.makhoa, KhoaKham.tenkhoa


select * from BenhVien
select * from BenhNhan 
select * from KhoaKham
select * from BenhNhanNu

-- cau 3
create proc TongTien(@makhoa nvarchar(30))
as 
    begin 
        if(not exists(select * from KhoaKham where KhoaKham.makhoa=@makhoa))
            print 'Ma khoa khong ton tai trong bang Khoa Kham'
        else 
            if(not exists(select * from BenhNhan where BenhNhan.makhoa=@makhoa))
                print 'Ma khoa khong ton tai trong bang Benh Nhan'
            else 
                begin 
                    select BenhVien.tenbv, KhoaKham.tenkhoa, sum(BenhNhan.songaynv*80000) as 'Tien'
                    from BenhVien, KhoaKham, BenhNhan
                    where BenhVien.mabv=KhoaKham.mabv
                    and KhoaKham.makhoa=BenhNhan.makhoa
                    group by BenhVien.tenbv, KhoaKham.tenkhoa
                end
    end 

exec TongTien'01a'

-- cau 4
alter trigger trg_khoakham on BenhNhan
for insert 
as 
    begin 
        declare @sobenhnhan int
        declare @makhoa nvarchar(30)
        set @sobenhnhan = (select sobenhnhan from KhoaKham inner join inserted on KhoaKham.makhoa=inserted.makhoa)
        set @makhoa = (select makhoa from inserted)
        if(@sobenhnhan>100)
            begin 
                raiserror('So benh nhan lon hon 100, khong the them', 16, 1)
                rollback transaction
            end 
        else 
            begin 
                update KhoaKham set sobenhnhan = sobenhnhan + 1
                where @makhoa = KhoaKham.makhoa
            end 
    end 


select * from BenhNhan 
select * from KhoaKham
insert into BenhNhan values ('006', 'Pham Hoang Tien', '02/28/1999', 'Nu', 10, '02a')
select * from BenhNhan 
select * from KhoaKham


update KhoaKham set sobenhnhan=50 where makhoa='01a'
update KhoaKham set sobenhnhan=60 where makhoa='02a'
