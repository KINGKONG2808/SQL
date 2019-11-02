use QuanLyKho
go 
create table Ton (
    mavt nvarchar(20) primary key not null,
    tenvt nvarchar(20) not null,
    soluongt int,
)
go 
create table Nhap (
    sohdn nvarchar(20) not null,
    mavt nvarchar(20) not null,
    soluongn int,
    dongian float,
    ngayn datetime,
    constraint PK_Nhap primary key (sohdn, mavt),
    constraint FK_Nhap foreign key (mavt) references Ton(mavt)
)
go 
create table Xuat (
    sohdx nvarchar(20) not null,
    mavt nvarchar(20) not null,
    soluongx int,
    dongiax float,
    ngayx datetime,
    constraint PK_Xuat primary key (sohdx, mavt),
    constraint FK_Xuat foreign key (mavt) references Ton(mavt)
)
go 

insert into Ton values ('001', 'banh', 500)
insert into Ton values ('002', 'keo', 400)
insert into Ton values ('003', 'sua', 300)
insert into Ton values ('004', 'che', 200)
insert into Ton values ('005', 'bcs', 500)
insert into Nhap values ('01a', '001', 200, 2000, '3/3/2019')
insert into Nhap values ('02a', '002', 100, 3000, '3/4/2019')
insert into Nhap values ('03a', '003', 200, 4000, '3/5/2019')
insert into Xuat values ('01b', '001', 50, 3000, '4/3/2019')
insert into Xuat values ('02b', '002', 50, 4000, '4/4/2019')
insert into Xuat values ('03b', '003', 50, 5000, '4/5/2019')
insert into Xuat values ('04b', '004', 50, 5000, '4/5/2019')

select * from Ton
select * from Nhap
select * from Xuat


-- cau 1 (V-I-E-W)
    -- view tong tien ban theo soluongx
        create view tienBan 
        as 
            select Ton.mavt, Ton.tenvt, sum(Xuat.soluongx*Xuat.dongiax) as 'TienBan'
            from Ton inner join Xuat on Ton.mavt=Xuat.mavt
            group by Ton.mavt, Ton.tenvt

        -- run
        select * from tienBan

    -- view tinh tong so du trong kho
        create view cau5
        as 
            select Ton.mavt, Ton.tenvt, sum(Nhap.soluongn)-sum(Xuat.soluongx)+sum(Ton.soluongt) as 'tongton'
            from Nhap inner join Xuat on Nhap.mavt=Xuat.mavt
                      inner join Ton on Nhap.mavt=Ton.mavt
            group by Ton.mavt, Ton.tenvt

        -- run
        select * from cau5

-- cau 2 (F-U-N-C-T-I-O-N)
    -- dua ra danh sach tien ban (TABLE)
        alter function tongTienBan(@mavt nvarchar(20), @ngayx datetime)
        returns @thongke table (
            mavt nvarchar(20),
            tenvt nvarchar(20),
            tongtien float
        )
        as 
            begin 
                insert into @thongke
                select Xuat.mavt, Ton.tenvt, sum(Xuat.soluongx*Xuat.dongiax)
                from Xuat inner join Ton on Xuat.mavt=Ton.mavt 
                where Xuat.mavt=@mavt and Xuat.ngayx=@ngayx
                group by Xuat.mavt, Ton.tenvt
                return
            end 

        -- run
        select * from tongTienBan('001', '4/3/2019')

    -- dua ra tong tien nhap (RETURN VALUE)
        create function tongTienNhap(@ngayn datetime, @tenvt nvarchar(20))
        returns float 
        as 
            begin 
                declare @tongNhap float
                select @tongNhap=sum(Nhap.soluongn*Nhap.dongian) from Nhap inner join Ton on Nhap.mavt=Ton.mavt
                where Nhap.ngayn=@ngayn and Ton.tenvt=@tenvt
                group by Nhap.ngayn, Ton.tenvt
                return @tongNhap
            end 

        -- run
        select dbo.tongTienNhap('3/3/2019', 'banh')

-- cau 3 (P-R-O-C)
    -- xoa vat tu
        create proc xoaVT(@mavt nvarchar(20))
        as 
            begin 
                if(exists(select * from Nhap where Nhap.mavt=@mavt))
                    print 'Ma vat tu da ton tai trong bang nhap, khong the xoa'
                else
                    if(exists(select * from Xuat where Xuat.mavt=@mavt))
                        print 'Ma vat tu da ton tai trong bang xuat, khong the xoa'
                    else 
                        begin 
                            delete from Ton where Ton.mavt=@mavt
                            print 'Xoa vat tu thanh cong'
                        end
            end

        -- run
        exec xoaVT '004'
        select * from Ton

    -- nhap du lieu bang xuat
        alter proc nhapXuat(@sohdx nvarchar(20), @mavt nvarchar(20), @soluongx int, @dongiax float, @ngayxuat datetime)
        as 
            begin 
                if(not exists(select * from Ton where Ton.mavt=@mavt))
                    print 'Ma vat tu khong ton tai trong bang ton. khong the them'
                else 
                    if(exists(select * from Xuat where Xuat.sohdx=@sohdx and Xuat.mavt=@mavt))
                        print 'So hoa don xuat hoac ma vat tu da ton tai, khong the them'
                    else 
                        if(not exists(select * from Ton where @soluongx<=Ton.soluongt))
                            print 'So luong xuat lon hon so luong ton, khong the them'
                        else 
                            begin 
                                insert into Xuat values (@sohdx, @mavt, @soluongx, @dongiax, @ngayxuat)
                                print 'Xuat du lieu thanh cong'
                            end 
            end 

        -- run
        exec nhapXuat '05b', '005', 100, 5000, '4/5/2019'

-- cau 4 (T-R-I-G-G-E-R)
    -- trigger nhap
        alter trigger trg_nhap on Nhap
        for insert
        as 
            begin 
                declare @soluongn int 
                declare @mavt nvarchar(20)
                set @soluongn = (select soluongn from inserted)
                set @mavt = (select mavt from inserted)
                if(not exists(select * from Ton where mavt=@mavt))
                    begin 
                        raiserror('Ma vat tu khong ton tai trong bang ton', 16, 1)
                        rollback transaction
                    end
                else 
                    begin 
                        update Ton set soluongt=soluongt+@soluongn
                        where mavt=@mavt
                    end
            end 

        -- run
        insert into Nhap values ('04a', '004', 100, 2000, '3/8/2019')
        insert into Nhap values ('06a', '005', 100, 2000, '3/8/2019')
        insert into Nhap values ('05a', '004', 100, 2000, '3/8/2019')
        select * from Nhap
        select * from Ton

    -- trigger xuat
        create trigger trg_xuat on Xuat
        for insert
        as 
            begin 
                declare @soluongx int 
                declare @mavt nvarchar(20)
                set @soluongx = (select soluongx from inserted)
                set @mavt = (select mavt from inserted)
                if(not exists(select * from Ton where mavt=@mavt))
                    begin 
                        raiserror('Ma vat tu khong ton tai trong bang ton', 16, 1)
                        rollback transaction
                    end
                else 
                    begin 
                        update Ton set soluongt=soluongt-@soluongx
                        where mavt=@mavt
                    end
            end 

        -- run
        select * from Xuat
        select * from Ton
        insert into Xuat values ('01a', '002', 100, 2000, '3/8/2019')
        insert into Xuat values ('02a', '001', 100, 2000, '3/8/2019')
        insert into Xuat values ('02a', '003', 100, 2000, '3/8/2019')
        select * from Xuat
        select * from Ton