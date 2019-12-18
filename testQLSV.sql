create database testQLSV
go
use testQLSV
go
create table khoa
(
	makhoa int not null primary key,
	tenkhoa nvarchar(30) not null
)
go
create table Lop
(
	malop int not null primary key,
	tenlop nvarchar(30) not null,
	siso int,
	makhoa int foreign key references khoa(makhoa)
)
go
create table sinhvien
(
	masv int not null primary key,
	hoten nvarchar(30) not null,
	ngaysinh date,
	gioitinh nvarchar(10),
	malop int foreign key references Lop(malop)
)
go
insert into khoa values(1,'cntt')
insert into khoa values(2,'kt')
go
insert into Lop values(1,'abc',60,2)
insert into Lop values(2,'khmt',50,1)
go
insert into sinhvien values(1,'nguyen van a','1-1-1111','nam',2)
insert into sinhvien values(2,'b','2-2-2222','nu',1)
insert into sinhvien values(3,'c','3-3-2000','nam',1)
insert into sinhvien values(4,'d','4-4-2000','nu',2)
insert into sinhvien values(5,'e','5-4-2000','nam',1)
go
--cau2:
create function cau2(@tenkhoa nvarchar(30))
returns @bang table(
					masv int,
					hoten nvarchar(30),
					tuoi int
					)
as
begin
	insert into @bang
		select sv.masv,sv.hoten,Year(getDate())-year(sv.ngaysinh) as 'tuoi'
		from sinhvien sv inner join Lop l on sv.malop = l.malop inner join khoa k on l.makhoa=k.makhoa
		where k.tenkhoa=@tenkhoa
	return 
end
--test cau 2
select * from dbo.cau2('cntt')
go
--cau3
create proc cau3
	@tuT int,
	@denT int
as
begin
	select sv.masv,sv.hoten,sv.ngaysinh,l.tenlop,k.tenkhoa,Year(getDate())-year(sv.ngaysinh) as 'tuoi'
	from sinhvien sv inner join Lop l on sv.malop = l.malop inner join khoa k on l.makhoa=k.makhoa
	where Year(getDate())-year(sv.ngaysinh)>= @tuT and Year(getDate())-year(sv.ngaysinh)<=@denT
end
--test cau3
exec cau3 '10','100'
go
--cau4
alter trigger trg_cau4
on sinhvien
for insert
as
begin
	declare @sisobandau int 
	declare @malop int

	set @malop =(select malop from inserted)
	set @sisobandau = (select l.siso from inserted i inner join Lop l on i.malop=l.malop)
	
	if(not exists(select * from sinhvien where malop=@malop))
		begin
			print('Ma lop khong hop le')
			rollback transaction
		end
	else
		begin
			if(@sisobandau>80)
				begin
					print('Lop da qua dong sinh vien')
					rollback transaction
				end
			else
				begin
					update Lop
					set siso=siso+1
					where malop=@malop
				end
		end
end
--test cau4
insert into Lop values(3,'loptrigger',88,2)
select * from sinhvien
select * from lop
insert into sinhvien values(9,'hs moi','9-9-2000','nam',3)
select * from sinhvien
select * from lop