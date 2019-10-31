use QLNV
go 
drop database QLNV
create table ChucVu (
    macv nvarchar(20) primary key not null,
    tencv nvarchar(20) not null,
)
go 
create table NhanVien(
    manv nvarchar(20) primary key not null,
    macv nvarchar(20) not null,
    tennv nvarchar(20) not null,
    ngaysinh datetime,
    luongcanban float,
    ngaycong int,
    phucap float,
    constraint FK_macv foreign key (macv) references ChucVu(macv)
)
go 

insert into ChucVu values ('bv', 'bao ve')
insert into ChucVu values ('gd', 'giam doc')
insert into ChucVu values ('hc', 'hanh chinh')
insert into ChucVu values ('kt', 'ke toan')
insert into ChucVu values ('tq', 'thu quy')
insert into ChucVu values ('vd', 've sinh')
insert into NhanVien values ('NV01', 'gd', 'nguyen van an', '12/12/1977', 70000, 25, 5000)
insert into NhanVien values ('NV02', 'bv', 'bui van ti', '10/10/1978', 40000, 24, 1000)
insert into NhanVien values ('NV03', 'kt', 'tran thanh nhat', '9/9/1977', 60000, 26, 4000)
insert into NhanVien values ('NV04', 'vd', 'nguyen thi ut', '10/10/1980', 30000, 26, 3000)
insert into NhanVien values ('NV05', 'hc', 'nguyen thi ha', '12/12/1979', 50000, 27, 2000)

-- cau 1
alter proc ThemNV (@manv nvarchar(20), @macv nvarchar(20), @tennv nvarchar(20), @ngaysinh datetime, @luongcanban float, @ngaycong int, @phucap float)
as 
    begin 
        if(exists(select * from ChucVu where ChucVu.macv=@macv))
            if(@ngaycong<=30)
                insert into NhanVien values (@manv, @macv, @tennv, @ngaysinh, @luongcanban, @ngaycong, @phucap)
            else 
                print 'Ngay cong khong hop le.'
        else 
            print 'Ma cong viec khong ton tai.'
    end

exec ThemNV 'NV07', 'vd', 'vu thi hung', '4/28/1995', 5000, 20, 300
select * from NhanVien

-- cau 2
alter proc SuaNV (@manv nvarchar(20), @macv nvarchar(20), @tennv nvarchar(20), @ngaysinh datetime, @luongcanban float, @ngaycong int, @phucap float)
as 
    begin 
        if(exists(select * from ChucVu where ChucVu.macv=@macv))
            if(@ngaycong<=30)
                update NhanVien set macv=@macv, tennv=@tennv, ngaysinh=@ngaysinh, luongcanban=@luongcanban, ngaycong=@ngaycong, phucap=@phucap where NhanVien.manv=@manv
            else 
                print 'Ngay cong khong hop le.'
        else 
            print 'Ma cong viec khong ton tai.'
    end

exec SuaNV 'NV07', 'gd', 'vu thi hung', '4/28/1995', 500000, 30, 30000

-- cau 2
alter proc Luong
as 
    begin 
        select *, ngaycong*luongcanban+phucap as Luong from NhanVien
    end

exec Luong


-- cau 3
alter proc luongTB (@manv nvarchar(20), @tennv nvarchar(20), @tencv nvarchar(20), @luong float output)
as 
    begin 
        if(exists(select * from NhanVien where manv=@manv))
            if(exists(select * from NhanVien where ngaycong<25))
                select @luong=ngaycong*luongcanban+phucap from NhanVien where manv=@manv and tennv=@tennv
            else 
                select @luong=24*luongcanban + (ngaycong-24)*luongcanban*2 + phucap from NhanVien where manv=@manv and tennv=@tennv
        else 
            print 'Ma nhan vien khong ton tai'
    end

declare @luong float
exec luongTB 'NV02', 'bui van ti', 'bao ve', @luong output
select @luong
select * from NhanVien