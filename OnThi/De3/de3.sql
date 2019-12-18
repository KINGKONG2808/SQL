-- use master 
-- go 
-- create database QLBanHang 

-- cau 1
use QLBanHang 
go 
create table CongTy(
    mact nvarchar(30) primary key not null,
    tenct nvarchar(30) not null,
    trangthai nvarchar(10),
    thanhpho nvarchar(30),
)
go 
create table SanPham(
    masp nvarchar(30) primary key not null,
    tensp nvarchar(30) not null,
    mausac nvarchar(20),
    soluong int,
    giaban float,
)
go 
create table CungUng(
    mact nvarchar(30) not null,
    masp nvarchar(30) not null,
    soluongcungung int,
    ngaycunung datetime,
    constraint pk_cungung primary key (mact, masp),
    constraint fk_congty foreign key (mact) references CongTy(mact),
    constraint fk_sanpham foreign key (masp) references SanPham(masp)
)
go 

insert into CongTy values ('001', 'abc', 'tot', 'hanoi')
insert into CongTy values ('002', 'def', 'tb', 'hanam')
insert into CongTy values ('003', 'igh', 'yeu', 'thaibinh')
insert into SanPham values ('01a', 'bcs', 'red', 50, 70)
insert into SanPham values ('02a', 'bcs1', 'blu', 30, 40)
insert into SanPham values ('03a', 'bcs2', 'black', 50, 60)
insert into CungUng values ('001', '01a', 10, '01/01/2019')
insert into CungUng values ('002', '02a', 20, '02/01/2019')
insert into CungUng values ('003', '03a', 30, '03/01/2019')
insert into CungUng values ('001', '03a', 5, '04/01/2019')
insert into CungUng values ('003', '02a', 5, '05/01/2019')

select * from CongTy
select * from SanPham
select * from CungUng

-- cau 2
create function ThongTin (@tenct nvarchar(30), @ngaycungung datetime)
returns @thongtinsp table (
    tensp nvarchar(30),
    mausac nvarchar(20),
    soluong int,
    giaban float
)
as 
    begin 
        insert into @thongtinsp
        select SanPham.tensp, SanPham.mausac, SanPham.soluong, SanPham.giaban
        from CungUng inner join CongTy on CungUng.mact=CongTy.mact
                     inner join SanPham on CungUng.masp=SanPham.masp
        where CungUng.ngaycunung=@ngaycungung and CongTy.tenct=@tenct
        return
    end

select * from ThongTin('abc', '01/01/2019')

-- cau 3
create proc ThemCungUng (@tenct nvarchar(30), @tensp nvarchar(30), @soluongcungung int, @ngaycungung datetime)
as 
    begin 
        if(not exists(select * from CongTy where CongTy.tenct=@tenct))
            print 'Ten cong ty khong ton tai trong bang Cong Ty'
        else 
            if(not exists(select * from SanPham where SanPham.tensp=@tensp))
                print 'Ten san pham khong co trong bang San Pham'
            else 
                begin 
                    declare @mact nvarchar(30)
                    declare @masp nvarchar(30)
                    set @mact = (select mact from CongTy where CongTy.tenct=@tenct)
                    set @masp = (select masp from SanPham where SanPham.tensp=@tensp)
                    if(exists(select * from CungUng where CungUng.mact=@mact and CungUng.masp=@masp))
                        print 'Ten cong ty va ten san pham da ton tai trong bang Cung Ung'
                    else 
                        begin 
                            insert into CungUng values (@mact, @masp, @soluongcungung, @ngaycungung)
                            print 'Them thong tin thanh cong'
                        end
                end 
    end

exec ThemCungUng 'abc', 'bcs1', 100, '03/03/2019'

-- cau 4
create trigger trg_update on CungUng
for update 
as 
    begin 
        declare @soluongmoi int
        declare @soluongcu int
        declare @soluong int
        declare @mact nvarchar(30)
        declare @masp nvarchar(30)
        
        set @mact = (select mact from inserted)
        set @masp = (select masp from inserted)
        set @soluongmoi = (select soluongcungung from inserted)
        set @soluongcu = (select soluongcungung from deleted)
        set @soluong = (select SanPham.soluong from SanPham inner join inserted on SanPham.masp=inserted.masp)
       
        if(not exists(select * from CungUng where CungUng.mact=@mact and CungUng.masp=@masp))
            begin 
                raiserror('Ma cong ty va ma san pham khong ton tai.', 16, 1)
                rollback transaction
            end 
        else 
            if(@soluongmoi-@soluongcu>@soluong) 
                begin 
                    raiserror('So luong cung ung vuot qua so luong hien co.', 16, 1)
                    rollback transaction
                end 
            else 
                begin 
                    update SanPham set soluong = soluong - (@soluongmoi-@soluongcu)
                    where masp = @masp
                end 
    end

select * from SanPham
select * from CungUng
update CungUng set soluongcungung = 30 where mact = '002' and masp = '02a'
select * from SanPham
select * from CungUng