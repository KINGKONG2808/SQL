USE QLSV
GO

-- cau 1
alter function tinhSoSV (@malop int)
returns int
AS 
    BEGIN
        declare @demSL INT
        SELECT @demSL=count(SinhVien.masv) from SinhVien inner join Lop on SinhVien.malop=Lop.malop
        where Lop.malop=@malop
        return @demSL
    END

    SELECT dbo.tinhSoSV(2)

-- cau 2
create function dsSV (@tenlop nvarchar(20))
returns @ds table (
    MaSV int, 
    TenSV nvarchar(20)
)
as 
    begin 
        insert into @ds 
            select SinhVien.masv, SinhVien.tensv from SinhVien inner join Lop on SinhVien.malop=Lop.malop
            where Lop.tenlop=@tenlop
        return
    end

SELECT * FROM dsSV('CD')

-- cau 3
create function thongKeSV(@tenlop nvarchar(20))
returns @tk table (
    malop int,
    tenlop nvarchar(20),
    soluong int
)
as 
    begin
        if(not exists(select malop from Lop where Lop.tenlop=@tenlop))
            insert into @tk
                select Lop.malop, Lop.tenLop, count(SinhVien.masv)
                from Lop inner join SinhVien on Lop.malop=SinhVien.malop
            group by Lop.malop, Lop.tenlop
        else 
            insert into @tk
                select Lop.malop, Lop.tenlop, count(SinhVien.masv)
                from Lop inner join SinhVien on Lop.malop=SinhVien.malop
                where Lop.tenlop=@tenlop
            group by Lop.malop, Lop.tenlop
        return
    end

select * from thongKeSV('cd')

-- cau 4
create function tenPhong(@tensv nvarchar(20))
returns int
as 
    begin 
        declare @bien int 
        select @bien=Lop.phong from Lop inner join SinhVien on Lop.malop=SinhVien.malop
        where SinhVien.tensv=@tensv
        return @bien
    end

select dbo.tenPhong('b')

-- cau 5
create function thongKePhong(@phong int)
returns @tkp table (
    MaSV int,
    TenSV nvarchar(20),
    TenLop nvarchar(20)
)
as 
    begin 
        if(not exists(select Lop.malop from Lop where Lop.phong=@phong))
            insert into @tkp
                select SinhVien.masv, SinhVien.tensv, Lop.tenlop from SinhVien inner join Lop on SinhVien.malop=Lop.malop
                group by SinhVien.masv, SinhVien.tensv, Lop.tenlop
        else 
            insert into @tkp
                select SinhVien.masv, SinhVien.tensv, Lop.tenlop from SinhVien inner join Lop on SinhVien.malop=Lop.malop
                where Lop.phong=@phong
                group by SinhVien.masv, SinhVien.tensv, Lop.tenlop
        return
    end

select * from thongKePhong(5)

-- cau 6
alter function thongKeLopHoc(@phong int)
returns int 
as 
    begin 
        declare @soPhong int 
        if(not exists(select Lop.malop from Lop where Lop.phong=@phong))
            set @soPhong = 0
        else 
            select @soPhong=count(Lop.tenlop) from Lop where Lop.phong=@phong
        return @soPhong
    end

select dbo.thongKeLopHoc(2)