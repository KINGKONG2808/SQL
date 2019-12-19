-- use master
-- go 
-- create database QLSinhVien

use QLSinhVien 
go 
--cau 1
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

insert into Khoa values ('001', 'abc')
insert into Khoa values ('002', 'def')
insert into Lop values ('01a', 'a', 60, '001')
insert into Lop values ('02a', 'b', 66, '002')
insert into SinhVien values ('001a', 'aaa', '01/01/1999', 'nam', '01a')
insert into SinhVien values ('002a', 'bbb', '02/03/1999', 'nam', '02a')
insert into SinhVien values ('003a', 'ccc', '03/04/1999', 'nu', '01a')
insert into SinhVien values ('004a', 'ddd', '04/01/1999', 'nam', '02a')
insert into SinhVien values ('005a', 'eee', '05/01/1999', 'nu', '01a')

select * from Khoa
select * from Lop
select * from SinhVien

-- cau 2
alter function ThongTin(@tenkhoa nvarchar(30))
returns @thongtin table (
    masv nvarchar(30),
    hoten nvarchar(30),
    tuoi int
)
as 
    begin 
        insert into @thongtin
        select SinhVien.masv, SinhVien.hoten, year(getdate())-year(SinhVien.ngaysinh)
        from SinhVien, Lop, Khoa
        where SinhVien.malop=Lop.malop and Lop.makhoa=Khoa.makhoa and Khoa.tenkhoa=@tenkhoa
        return
    end

select * from SinhVien
select * from ThongTin('abc')

-- cau 3
alter proc LuuTru(@tuoivao int, @tuoira int)
as 
    begin 
        if(@tuoira<0 or @tuoivao<0)
            print 'Tuoi nhap vao khong hop le.'
        else 
            begin 
                select SinhVien.masv, SinhVien.hoten, SinhVien.ngaysinh, Lop.tenlop, Khoa.tenkhoa, year(getdate())-year(SinhVien.ngaysinh) as 'Tuoi'
                from SinhVien inner join Lop on SinhVien.malop=Lop.malop inner join Khoa on Lop.makhoa=Khoa.makhoa
                where @tuoivao<=year(getdate())-year(SinhVien.ngaysinh) and year(getdate())-year(SinhVien.ngaysinh)<=@tuoira
            end
    end 

exec LuuTru -1, 20

create proc Nhap(@masv nvarchar(30), @hoten nvarchar(30), @ngaysinh datetime, @gioitinh nvarchar(10), @malop nvarchar(30), @report int output)
as 
    begin 
        if(exists(select * from SinhVien where masv=@masv))
            set @report = 1
        else 
            begin 
                if(exists(select * from SinhVien where hoten=@hoten))
                    set @report=1
                else 
                    begin 
                        set @report=0
                        insert into SinhVien values (@masv, @hoten, @ngaysinh, @gioitinh, @malop)
                    end 
            end 
    end

declare @report int 
exec Nhap '010a', 'eae', '05/01/1999', 'nu', '02a', @report output
select @report
select * from SinhVien

-- cau 4
alter trigger trg_add on SinhVien
for insert 
as 
    begin 
        declare @masv nvarchar(30)
        declare @siso int
        declare @malop nvarchar(30)

        set @masv = (select masv from inserted)
        set @siso = (select siso from inserted inner join Lop on Lop.malop=inserted.malop)
        set @malop = (select malop from inserted)

        if(not exists(select * from SinhVien where SinhVien.masv=@masv))
            begin 
                raiserror('Ma sinh vien khong ton tai, khong the them.', 16, 1)
                rollback transaction
            end
        else 
            begin 
                if(@siso>80) 
                    begin 
                        raiserror('Si so qua 80 nguoi/lop, khong the them.', 16, 1)
                        rollback transaction
                    end 
                else 
                    begin 
                        update Lop set siso = siso + 1
                        where malop=@malop
                    end
            end
    end 


select * from Lop
select * from SinhVien
insert into SinhVien values ('009a', 'eee', '05/01/1999', 'nu', '02a')
select * from Lop
select * from SinhVien

update Lop set siso=90 where malop='01a'