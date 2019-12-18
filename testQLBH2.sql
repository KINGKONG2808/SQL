create database testQLBH2
go
use testQLBH2
go
create table congty
(
	mact int not null primary key,
	tenct nvarchar(30) not null,
	trangthai bit not null,
	thanhpho nvarchar(30) not null
)
go
create table sanpham
(
	masp int not null primary key,
	tensp nvarchar(30) not null,
	mausac nvarchar(30) not null,
	soluong int not null,
	giaban float not null
)
go
create table cungung
(
	mact int not null,
	masp int not null,
	slcu int not null,
	ngaycu date not null,
	constraint PK_cungung primary key(mact,masp),
	constraint FK_cu_ct foreign key (mact) references congty(mact),
	constraint FK_cu_sp foreign key (masp) references sanpham(masp)
)
go
insert into congty values(1,'cta',1,'tp1')
insert into congty values(2,'ctb',1,'tp2')
insert into congty values(3,'ctc',1,'tp1')
go
insert into sanpham values(1,'sp1','vang',50,20)
insert into sanpham values(2,'sp2','do',100,10)	
insert into sanpham values(3,'sp3','xanh',20,50)
go
insert into cungung values(1,3,10,'1-1-2001')
insert into cungung values(3,2,50,'2-1-2001')
insert into cungung values(2,3,1,'4-1-2001')
insert into cungung values(1,1,20,'9-1-2001')
insert into cungung values(3,1,5,'11-1-2001')
go
--cau2
alter function fn_cau2(@tenct nvarchar(30),@ngaycu date)
returns @bang table(
					tensp nvarchar(30),
					mausac nvarchar(30),
					soluong int,
					giaban float
					)
as
begin
			insert into @bang
				select ct.tenct,sp.mausac,sp.soluong,sp.giaban
				from congty ct join cungung cu on ct.mact = cu.mact join sanpham sp on cu.masp = sp.masp
				where ct.tenct=@tenct and cu.ngaycu = @ngaycu
	return
end
go
--test cau2
select * from fn_cau2('cta','1-1-2001')
go
--cau3
create proc prd_cau3
	@tenct nvarchar(30),
	@tensp nvarchar(30),
	@slcu int,
	@ngaycu date
as
begin
	declare @mact int
	declare @masp int
	set @mact = (select mact from congty where tenct=@tenct)
	set @masp = (select masp from sanpham where tensp=@tensp)
	insert into cungung 
	values(@mact,@masp,@slcu,@ngaycu)
end
go
--test cau3
exec prd_cau3 'ctb','sp2',10,'11-11-1999'
select * from cungung
go
--cau4
create trigger trg_cau4
on cungung
for update
as
begin
	declare @slcu_moi int
	declare @slcu_cu int
	declare @sl int
	declare @mact int
	declare @masp int
	set @mact=(select mact from inserted)
	set @masp=(select masp from inserted)
	set @slcu_cu =(select slcu from deleted)
	set @slcu_moi=(select slcu from inserted)
	set @sl = (select sp.soluong from inserted i inner join sanpham sp on i.masp=sp.masp)
	if(not exists(select * from cungung where mact=@mact and masp=@masp))
		begin
			raiserror('K ton tai cung ung nay',16,1)
			rollback transaction
		end
	else
		begin
			if(@sl<(@slcu_moi-@slcu_cu))
				begin
					raiserror('so luong san pham k du de cung ung',16,1)
					rollback transaction
				end
			else
				begin
					update sanpham
					set soluong = soluong - (@slcu_moi-@slcu_cu)
					where masp=@masp
				end
		end
end
go
select * from sanpham
select * from cungung
update cungung set slcu=slcu+1 where mact='1' and masp='3'
select * from sanpham
select * from cungung