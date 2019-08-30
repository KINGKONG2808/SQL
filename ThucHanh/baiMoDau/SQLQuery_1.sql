USE SQLex
GO

CREATE TABLE NhanVien (
    maNV NVARCHAR(10) NOT NULL PRIMARY KEY ,
    tenNV NVARCHAR(30) NOT NULL,
    que NVARCHAR(30),
    gioiTinh NVARCHAR(10),
    phone NVARCHAR(10),
    email NVARCHAR(30),
    phong NVARCHAR(20)
) 
GO

CREATE TABLE HangSX (
    maHangSX NVARCHAR(10) NOT NULL PRIMARY KEY,
    tenHang NVARCHAR(10),
    diaChi NVARCHAR(30),
    phone NVARCHAR(10),
    email NVARCHAR(30)
)
GO

CREATE TABLE SanPham (
    maSP NVARCHAR(10) NOT NULL PRIMARY KEY,
    maHangSX NVARCHAR(10) NOT NULL,
    tenSP NVARCHAR(20) NOT NULL,
    soLuong int,
    mauSac NVARCHAR(10),
    giaBan money,
    donViTinh NVARCHAR(10),
    moTa ntext,
    CONSTRAINT FK_SanPham_hangSX FOREIGN KEY
    (maHangSX) REFERENCES HangSX(maHangSX)
)
GO

CREATE TABLE Nhap(
    soDN NVARCHAR(10) NOT NULL,
    maNV NVARCHAR(10) NOT NULL,
    maSP NVARCHAR(10) NOT NULL,
    soLuongN INT,
    donGiaN money,
    ngayN DATE,
    CONSTRAINT PK_Nhap PRIMARY KEY(soDN, maSP),
    CONSTRAINT FK_Nhap_SanPham FOREIGN KEY (maSP) REFERENCES SanPham(maSP),
    CONSTRAINT FK_Nhap_NhanVien FOREIGN KEY(maNV) REFERENCES NhanVien(maNV)
)
GO