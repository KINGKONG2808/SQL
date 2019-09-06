USE QuanLySinhVien
GO
CREATE TABLE tblSinhVien(
    maSinhVien NVARCHAR(20) NOT NULL PRIMARY KEY,
    hoDem NVARCHAR(20) NOT NULL,
    ten NVARCHAR(10) NOT NULL,
    namSinh INT,
    gioiTinh NVARCHAR(10)
)
GO
CREATE TABLE tblMonHoc(
    maMonHoc NVARCHAR(20) NOT NULL PRIMARY KEY,
    tenMonHoc NVARCHAR(20) NOT NULL,
    heSoMonHoc INT
)
GO
CREATE TABLE tblDiem(
    maSinhVien NVARCHAR(20) NOT NULL,
    maMonHoc NVARCHAR(20) NOT NULL,
    diemSo FLOAT,
    CONSTRAINT PK_tblDiem PRIMARY KEY (maSinhVien, maMonHoc),
    CONSTRAINT FK_tblSinhVien FOREIGN KEY (maSinhVien) REFERENCES tblSinhVien(maSinhVien),
    CONSTRAINT FK_tblMonHoc FOREIGN KEY (maMonHoc) REFERENCES tblMonHoc(maMonHoc)
)
GO