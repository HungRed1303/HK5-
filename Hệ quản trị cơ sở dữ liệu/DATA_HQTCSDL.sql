CREATE DATABASE HQTCSDL
GO
USE HQTCSDL
GO
CREATE TABLE KHACHHANG (
	MaKH INT,
  	SDT CHAR(10) NOT NULL,
  	HoTen NVARCHAR(255) NOT NULL,
  	DiaChi NVARCHAR(255) NOT NULL,
  	NgaySinh DATETIME NOT NULL,
    NgayDangKy DATETIME NOT NULL,
  	MaPH INT,
  	MaNV INT,
  	PRIMARY KEY (MaKH)
)

CREATE TABLE PHANHANG (
	MaPH INT, 
  	TenPH NVARCHAR(255) NOT NULL,
  	TongMin INT,
  	TongMax INT,
  	PRIMARY KEY (MaPH)
)

CREATE TABLE LOAIPHIEUMUAHANG (
	MaLP INT,
  	MaPH INT NOT NULL,
  	TriGia INT NOT NULL,
  	PRIMARY KEY (MaLP)
)

CREATE TABLE PHIEUMUAHANG (
	MaPhieu INT, 
  	MaKH INT NOT NULL,
  	NgayTang DATETIME NOT NULL,
  	MaLP INT NOT NULL,
  	MaNV INT NOT NULL,
  	HanSuDung DATETIME,
  	TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Đã sử dụng', N'Chưa sử dụng', N'Hết hạn')),
	PRIMARY KEY (MaPhieu)
)

CREATE TABLE DANHMUC (
	MaDM INT,
  	TenDM NVARCHAR(255) NOT NULL,
  	PRIMARY KEY (MaDM)
)

CREATE TABLE SANPHAM (
	MaSP INT,
  	TenSP NVARCHAR(255) NOT NULL,
  	MoTa TEXT,
  	GiaNiemYet INT NOT NULL,
  	SLToiDa INT NOT NULL,
  	SLTonKho INT NOT NULL,
  	DonVi NVARCHAR(255),
  	NgayThem DATETIME NOT NULL,
  	NgayCapNhat DATETIME NOT NULL,
  	MaDM INT NOT NULL,
  	MaNSX INT NOT NULL,
  	PRIMARY KEY (MaSP)
)

CREATE TABLE NHASANXUAT (
	MaNSX INT, 
  	TenNSX NVARCHAR(255) NOT NULL,
  	SDT CHAR(10) NOT NULL,
  	DiaChi NVARCHAR(255),
  	PRIMARY KEY (MaNSX)
)

CREATE TABLE BOPHAN (
	MaBP INT,
  	TenBP NVARCHAR(255) NOT NULL,
  	PRIMARY KEY (MaBP)
)

CREATE TABLE NHANVIEN (
	MaNV INT,
  	HoTen NVARCHAR(255) NOT NULL,
  	DiaChi NVARCHAR(255),
  	GioiTinh NVARCHAR(3),
  	SDT CHAR(10) NOT NULL,
  	CCCD CHAR(12) NOT NULL,
  	MaBP INT NOT NULL,
  	PRIMARY KEY (MaNV)
)

CREATE TABLE DONDATNSX (
	MaDDH INT, 
  	MaNSX INT NOT NULL,
  	SoLuong INT NOT NULL,
  	MaSP INT NOT NULL,
  	NgayDat DATETIME,
  	TinhTrang NVARCHAR(20) CHECK(TinhTrang IN (N'Chưa giao', N'Đã giao')),
  	MaNV INT NOT NULL,
  	PRIMARY KEY (MaDDH)
)

CREATE TABLE DONNHANHANG (
	MaDNH INT,
  	MaNV INT NOT NULL,
  	NgayNhan DATETIME,
  	TongTien INT,
  	MaNSX INT,
  	PRIMARY KEY (MaDNH)
)

CREATE TABLE CTDONNHANHANG (
	STT INT,
  	MaDNH INT,
  	SoLuong INT NOT NULL,
  	DonGia INT NOT NULL,
  	ThanhTien INT,
  	MaDDH INT,
  	PRIMARY KEY (MaDNH, STT)
)

CREATE TABLE DONHANG (
	MaDH INT,
  	NgayDat DATETIME,
  	NgayGiao DATETIME,
  	TinhTrang NVARCHAR(20) CHECK (TinhTrang IN (N'Đang xử lý', N'Đang vận chuyển', N'Đã giao', N'Đã hủy')),
  	ThanhTien INT NOT NULL,
  	TongPhaiTra INT NOT NULL,
  	MaPhieu INT,
  	MaNV INT NOT NULL,
  	MaKH INT,
  	PRIMARY KEY (MaDH)
)

CREATE TABLE CTDONHANG (
	MaDH INT,
  	STT INT,
  	MaSP INT NOT NULL,
  	SoLuong INT NOT NULL,
  	ThanhTien INT NOT NULL,
  	MaKhuyenMai INT,
  	TienPhaiTra INT NOT NULL,
  	PRIMARY KEY (MaDH, STT)
)

CREATE TABLE KHUYENMAI (
	MaKhuyenMai INT,
  	NgayBatDau DATETIME NOT NULL,
  	NgayKetThuc DATETIME NOT NULL,
  	NgayTaoMaKM DATETIME,
  	TiLe FLOAT NOT NULL,
  	SLToiDa INT NOT NULL,
  	TinhTrang NVARCHAR(20) CHECK (TinhTrang IN (N'Đang diễn ra', N'Kết thúc')), 
  	SLDaBan INT NOT NULL,
  	LoaiKM NVARCHAR(20) CHECK (LoaiKM IN ('Flash-sale', 'Combo-sale', 'Member-sale')),
  	MaNV INT NOT NULL,
  	PRIMARY KEY (MaKhuyenMai)
)

CREATE TABLE COMBOSALE (
	MaKhuyenMai INT,
  	MaSP1 INT NOT NULL,
  	MaSP2 INT NOT NULL,
  	PRIMARY KEY (MaKhuyenMai)
)

CREATE TABLE FLASHSALE (
	MaKhuyenMai INT,
  	MaSP INT NOT NULL,
  	PRIMARY KEY (MaKhuyenMai)
)

CREATE TABLE MEMBERSALE (
	MaKhuyenMai INT,
  	MaPH INT NOT NULL,
  	PRIMARY KEY (MaKhuyenMai)
)

ALTER TABLE SANPHAM
ADD CONSTRAINT FK_SANPHAM_DANHMUC FOREIGN KEY (MaDM) REFERENCES DANHMUC(MaDM)

ALTER TABLE NHANVIEN
ADD CONSTRAINT FK_NHANVIEN_BOPHAN FOREIGN KEY (MaBP) REFERENCES BOPHAN(MaBP)

ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KHACHHANG_PHANHANG FOREIGN KEY (MaPH) REFERENCES PHANHANG(MaPH)

ALTER TABLE KHACHHANG
ADD CONSTRAINT FK_KHACHHANG_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE LOAIPHIEUMUAHANG 
ADD CONSTRAINT FK_LOAIPHIEUMUAHANG_PHANHANG FOREIGN KEY (MaPH) REFERENCES PHANHANG(MaPH)

ALTER TABLE PHIEUMUAHANG
ADD CONSTRAINT FK_PHIEUMUAHANG_LOAIPHIEUMUAHANG FOREIGN KEY (MaLP) REFERENCES LOAIPHIEUMUAHANG(MaLP)

ALTER TABLE PHIEUMUAHANG
ADD CONSTRAINT FK_PHIEUMUAHANG_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE PHIEUMUAHANG
ADD CONSTRAINT FK_PHIEUMUAHANG_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)

ALTER TABLE SANPHAM
ADD CONSTRAINT FK_SANPHAM_NHASANXUAT FOREIGN KEY (MaNSX) REFERENCES NHASANXUAT(MaNSX) 

ALTER TABLE KHUYENMAI
ADD CONSTRAINT FK_KHUYENMAI_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE COMBOSALE
ADD CONSTRAINT FK_COMBOSALE_KHUYENMAI FOREIGN KEY (MaKhuyenMai) REFERENCES KHUYENMAI(MaKhuyenMai)

ALTER TABLE COMBOSALE
ADD CONSTRAINT FK_COMBOSALE_SANPHAM_1 FOREIGN KEY (MaSP1) REFERENCES SANPHAM(MaSP)

ALTER TABLE COMBOSALE
ADD CONSTRAINT FK_COMBOSALE_SANPHAM_2 FOREIGN KEY (MaSP2) REFERENCES SANPHAM(MaSP)

ALTER TABLE MEMBERSALE
ADD CONSTRAINT FK_MEMBERSALE_KHUYENMAI FOREIGN KEY (MaKhuyenMai) REFERENCES KHUYENMAI(MaKhuyenMai)

ALTER TABLE MEMBERSALE 
ADD CONSTRAINT FK_MEMBERSALE_PHANHANG FOREIGN KEY (MaPH) REFERENCES PHANHANG(MaPH)

ALTER TABLE FLASHSALE
ADD CONSTRAINT FK_FLASHSALE_KHUYENMAI FOREIGN KEY (MaKhuyenMai) REFERENCES KHUYENMAI(MaKhuyenMai)

ALTER TABLE FLASHSALE
ADD CONSTRAINT FK_FLASHSALE_SANPHAM FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_PHIEUMUAHANG FOREIGN KEY (MaPhieu) REFERENCES PHIEUMUAHANG(MaPhieu)

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)

ALTER TABLE DONHANG
ADD CONSTRAINT FK_DONHANG_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE CTDONHANG
ADD CONSTRAINT FK_CTDONHANG_SANPHAM FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)

ALTER TABLE CTDONHANG
ADD CONSTRAINT FK_CTDONHANG_DONHANG FOREIGN KEY (MaDH) REFERENCES DONHANG(MaDH)

ALTER TABLE CTDONHANG
ADD CONSTRAINT FK_CTDONHANG_KHUYENMAI FOREIGN KEY (MaKhuyenMai) REFERENCES KHUYENMAI(MaKhuyenMai)

ALTER TABLE DONDATNSX
ADD CONSTRAINT FK_DONDATNSX_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE DONDATNSX
ADD CONSTRAINT FK_DONDATNSX_NHASANXUAT FOREIGN KEY (MaNSX) REFERENCES NHASANXUAT(MaNSX)

ALTER TABLE DONDATNSX
ADD CONSTRAINT FK_DONDATNSX_SANPHAM FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)

ALTER TABLE DONNHANHANG
ADD CONSTRAINT FK_DONNHANHANG_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)

ALTER TABLE DONNHANHANG
ADD CONSTRAINT FK_DONNHANHANG_NHASANXUAT FOREIGN KEY (MaNSX) REFERENCES NHASANXUAT(MaNSX)

ALTER TABLE CTDONNHANHANG
ADD CONSTRAINT FK_CTDONNHANHANG_DONNHANHANG FOREIGN KEY (MaDNH) REFERENCES DONNHANHANG(MaDNH)

ALTER TABLE CTDONNHANHANG
ADD CONSTRAINT FK_CTDONNHANHANG_DONDATNSX FOREIGN KEY (MaDDH) REFERENCES DONDATNSX(MaDDH)

INSERT INTO PHANHANG (MaPH, TenPH, TongMin, TongMax) VALUES
(1, N'Kim Cương', 50000000, NULL),
(2, N'Bạch Kim', 30000000, 49999999),
(3, N'Vàng', 15000000, 29999999),
(4, N'Bạc', 5000000, 14999999),
(5, N'Đồng', 1000000, 4999999),
(6, N'Thân Thiết', 0, 999999);

INSERT INTO DANHMUC (MaDM, TenDM) VALUES
(1, N'Điện tử'),
(2, N'Gia dụng'),
(3, N'Thời trang'),
(4, N'Thực phẩm'),
(5, N'Đồ chơi trẻ em'),
(6, N'Sách vở'),
(7, N'Phụ kiện'),
(8, N'Thiết bị y tế'),
(9, N'Nội thất'),
(10, N'Đồ dùng học tập');

INSERT INTO BOPHAN (MaBP, TenBP) VALUES
(1, N'Chăm sóc khách hàng'),
(2, N'Quản lý ngành hàng'),
(3, N'Xử lý đơn hàng'),
(4, N'Quản lý kho hàng'),
(5, N'Kinh doanh'),
(6, N'Nhân sự'),
(7, N'Tài chính'),
(8, N'Marketing'),
(9, N'IT hỗ trợ'),
(10, N'An ninh');

INSERT INTO NHASANXUAT (MaNSX, TenNSX, SDT, DiaChi) VALUES
(1, N'Samsung', '0987654321', N'Hàn Quốc'),
(2, N'Apple', '0987123456', N'Mỹ'),
(3, N'Sony', '0978112233', N'Nhật Bản'),
(4, N'LG', '0911223344', N'Hàn Quốc'),
(5, N'Xiaomi', '0933445566', N'Trung Quốc'),
(6, N'Asus', '0913445566', N'Đài Loan'),
(7, N'Dell', '0923445566', N'Mỹ'),
(8, N'Lenovo', '0935445566', N'Trung Quốc'),
(9, N'Panasonic', '0943445566', N'Nhật Bản'),
(10, N'Toshiba', '0953445566', N'Nhật Bản');

INSERT INTO NHANVIEN (MaNV, HoTen, DiaChi, GioiTinh, SDT, CCCD, MaBP) VALUES
(1, N'Nguyễn Văn A', N'Tp.HCM', N'Nam', '0901234567', '123456789012', 1),
(2, N'Trần Thị B', N'Tp.HCM', N'Nữ', '0912345678', '987654321098', 2),
(3, N'Lê Văn C', N'Hà Nội', N'Nam', '0934567890', '456789123456', 3),
(4, N'Phạm Thị D', N'Tp.HCM', N'Nữ', '0909876543', '123789456123', 4),
(5, N'Huỳnh Văn E', N'Tp.HCM', N'Nam', '0904567890', '789123456789', 5),
(6, N'Ngô Thị F', N'Đà Nẵng', N'Nữ', '0913456789', '456123789456', 6),
(7, N'Võ Văn G', N'Hải Phòng', N'Nam', '0921234567', '987321654987', 7),
(8, N'Đỗ Thị H', N'Cần Thơ', N'Nữ', '0936789012', '321654987321', 8),
(9, N'Nguyễn Văn I', N'Nha Trang', N'Nam', '0945678901', '654789321654', 9),
(10, N'Phan Thị K', N'Vũng Tàu', N'Nữ', '0956789012', '789654123789', 10);

INSERT INTO KHACHHANG (MaKH, SDT, HoTen, DiaChi, NgaySinh, NgayDangKy, MaPH, MaNV) VALUES
(1, '0961234567', N'Nguyễn Thị D', N'Tp.HCM', '1990-01-01', '2022-01-01', 1, 1),
(2, '0952345678', N'Lê Văn E', N'Hà Nội', '1985-05-05', '2022-02-15', 2, 2),
(3, '0943456789', N'Trần Thị F', N'Tp.HCM', '1992-03-10', '2022-03-01', 3, 3),
(4, '0934567890', N'Phạm Văn G', N'Cần Thơ', '1988-04-15', '2022-04-01', 4, 4),
(5, '0925678901', N'Huỳnh Thị H', N'Nha Trang', '1995-05-20', '2022-05-01', 5, 5),
(6, '0916789012', N'Ngô Văn I', N'Tp.HCM', '1990-06-25', '2022-06-01', 6, 6),
(7, '0907890123', N'Võ Thị J', N'Hải Phòng', '1987-07-30', '2022-07-01', 1, 7),
(8, '0988901234', N'Đỗ Văn K', N'Tp.HCM', '1993-08-05', '2022-08-01', 2, 8),
(9, '0979012345', N'Phan Thị L', N'Hà Nội', '1996-09-10', '2022-09-01', 3, 9),
(10, '0960123456', N'Lê Văn M', N'Đà Nẵng', '1989-10-15', '2022-10-01', 4, 10);

INSERT INTO SANPHAM (MaSP, TenSP, MoTa, GiaNiemYet, SLToiDa, SLTonKho, DonVi, NgayThem, NgayCapNhat, MaDM, MaNSX) VALUES
(1, N'TV Samsung', N'Smart TV 4K UHD', 15000000, 100, 50, N'Cái', '2023-01-01', '2023-01-05', 1, 1),
(2, N'TV Sony', N'Smart TV OLED 4K', 20000000, 80, 40, N'Cái', '2023-01-02', '2023-01-06', 1, 3),
(3, N'Tủ lạnh LG', N'Tủ lạnh 2 cánh 500L', 12000000, 50, 25, N'Cái', '2023-01-03', '2023-01-07', 2, 4),
(4, N'Tủ lạnh Samsung', N'Tủ lạnh Inverter 400L', 10000000, 60, 30, N'Cái', '2023-01-04', '2023-01-08', 2, 1),
(5, N'Điều hòa Panasonic', N'Điều hòa 1 chiều 12000BTU', 8500000, 70, 35, N'Cái', '2023-01-05', '2023-01-09', 2, 9),
(6, N'Lò vi sóng Sharp', N'Lò vi sóng 30L', 3000000, 100, 50, N'Cái', '2023-01-06', '2023-01-10', 2, 5),
(7, N'Điện thoại iPhone 14', N'Điện thoại thông minh', 30000000, 200, 100, N'Cái', '2023-01-07', '2023-01-11', 1, 2),
(8, N'Điện thoại Samsung Galaxy S23', N'Điện thoại thông minh', 25000000, 200, 120, N'Cái', '2023-01-08', '2023-01-12', 1, 1),
(9, N'Laptop Dell XPS', N'Laptop màn hình 4K', 45000000, 50, 20, N'Cái', '2023-01-09', '2023-01-13', 1, 7),
(10, N'Laptop Asus ROG', N'Laptop gaming cao cấp', 50000000, 30, 15, N'Cái', '2023-01-10', '2023-01-14', 1, 6),
(11, N'Áo sơ mi nam', N'Áo sơ mi vải cotton', 300000, 500, 250, N'Cái', '2023-01-11', '2023-01-15', 3, 5),
(12, N'Quần jean nữ', N'Quần jean thời trang', 500000, 400, 200, N'Cái', '2023-01-12', '2023-01-16', 3, 4),
(13, N'Dép nhựa', N'Dép nhựa chống trơn', 100000, 1000, 500, N'Đôi', '2023-01-13', '2023-01-17', 3, 9),
(14, N'Balo thời trang', N'Balo chống nước', 700000, 200, 100, N'Cái', '2023-01-14', '2023-01-18', 3, 8),
(15, N'Gạo thơm', N'Gạo thơm Jasmine 5kg', 200000, 500, 250, N'Bao', '2023-01-15', '2023-01-19', 4, 10),
(16, N'Mì gói Hảo Hảo', N'Mì gói chua cay', 50000, 1000, 500, N'Thùng', '2023-01-16', '2023-01-20', 4, 10),
(17, N'Bánh kẹo Kinh Đô', N'Bánh kẹo tết 500g', 150000, 300, 150, N'Hộp', '2023-01-17', '2023-01-21', 4, 3),
(18, N'Búp bê trẻ em', N'Búp bê Barbie', 250000, 400, 200, N'Cái', '2023-01-18', '2023-01-22', 5, 6),
(19, N'Xe điều khiển từ xa', N'Xe đua mini 4 bánh', 500000, 300, 150, N'Cái', '2023-01-19', '2023-01-23', 5, 4),
(20, N'Lego xếp hình', N'Bộ lego 1000 mảnh', 1000000, 200, 100, N'Hộp', '2023-01-20', '2023-01-24', 5, 8),
(21, N'Sách tiếng Anh', N'Sách luyện thi IELTS', 200000, 300, 150, N'Quyển', '2023-01-21', '2023-01-25', 6, 1),
(22, N'Vở kẻ ngang', N'Vở 200 trang', 15000, 1000, 500, N'Quyển', '2023-01-22', '2023-01-26', 6, 10),
(23, N'Ốp lưng điện thoại', N'Ốp silicon chống sốc', 50000, 500, 250, N'Cái', '2023-01-23', '2023-01-27', 7, 7),
(24, N'Sạc dự phòng', N'Sạc 20000mAh', 400000, 300, 150, N'Cái', '2023-01-24', '2023-01-28', 7, 8),
(25, N'Máy đo huyết áp', N'Máy đo bắp tay', 800000, 100, 50, N'Cái', '2023-01-25', '2023-01-29', 8, 9),
(26, N'Giường gỗ', N'Giường ngủ 2m', 5000000, 50, 25, N'Cái', '2023-01-26', '2023-01-30', 9, 6),
(27, N'Tủ quần áo', N'Tủ gỗ 3 cánh', 7000000, 40, 20, N'Cái', '2023-01-27', '2023-01-31', 9, 7),
(28, N'Bút bi', N'Bút bi Thiên Long', 5000, 2000, 1000, N'Cái', '2023-01-28', '2023-02-01', 10, 2),
(29, N'Thước kẻ', N'Thước kẻ 30cm', 10000, 1500, 750, N'Cái', '2023-01-29', '2023-02-02', 10, 3),
(30, N'Máy in HP', N'Máy in laser', 3000000, 50, 20, N'Cái', '2023-01-30', '2023-02-03', 7, 1),
(31, N'Ghế sofa', N'Sofa vải nỉ', 7000000, 30, 15, N'Bộ', '2023-02-01', '2023-02-05', 9, 5),
(32, N'Đèn LED', N'Đèn LED tiết kiệm điện', 150000, 200, 100, N'Cái', '2023-02-02', '2023-02-06', 7, 4),
(33, N'Quạt điện', N'Quạt bàn 3 cánh', 500000, 100, 50, N'Cái', '2023-02-03', '2023-02-07', 2, 9),
(34, N'Lò nướng', N'Lò nướng 20L', 2000000, 70, 35, N'Cái', '2023-02-04', '2023-02-08', 2, 10),
(35, N'Nồi cơm điện', N'Nồi cơm cao tần', 2500000, 60, 30, N'Cái', '2023-02-05', '2023-02-09', 2, 1),
(36, N'Chuột máy tính', N'Chuột không dây Logitech', 300000, 500, 250, N'Cái', '2023-02-06', '2023-02-10', 7, 8),
(37, N'Bàn phím cơ', N'Bàn phím gaming RGB', 1500000, 100, 50, N'Cái', '2023-02-07', '2023-02-11', 7, 6),
(38, N'Máy ảnh Canon', N'Máy ảnh chuyên nghiệp', 20000000, 30, 15, N'Cái', '2023-02-08', '2023-02-12', 1, 3),
(39, N'Ống kính Sony', N'Ống kính tele', 15000000, 20, 10, N'Cái', '2023-02-09', '2023-02-13', 1, 3),
(40, N'Đèn bàn', N'Đèn học sinh', 300000, 400, 200, N'Cái', '2023-02-10', '2023-02-14', 10, 7),
(41, N'Gối nằm', N'Gối ngủ cao su non', 500000, 200, 100, N'Cái', '2023-02-11', '2023-02-15', 9, 5),
(42, N'Máy lọc nước', N'Lọc nước RO', 5000000, 50, 25, N'Cái', '2023-02-12', '2023-02-16', 2, 4),
(43, N'Nồi áp suất', N'Nồi áp suất điện tử', 3000000, 60, 30, N'Cái', '2023-02-13', '2023-02-17', 2, 8),
(44, N'Màn hình máy tính', N'Màn hình 24 inch', 3000000, 70, 35, N'Cái', '2023-02-14', '2023-02-18', 7, 9),
(45, N'Tai nghe Bluetooth', N'Tai nghe Sony WH-1000XM4', 8000000, 50, 25, N'Cái', '2023-02-15', '2023-02-19', 1, 3),
(46, N'Robot hút bụi', N'Robot tự động Xiaomi', 10000000, 30, 15, N'Cái', '2023-02-16', '2023-02-20', 2, 5),
(47, N'Dép bông', N'Dép đi trong nhà', 150000, 500, 250, N'Đôi', '2023-02-17', '2023-02-21', 3, 6),
(48, N'Áo khoác nam', N'Áo gió chống nước', 700000, 200, 100, N'Cái', '2023-02-18', '2023-02-22', 3, 4),
(49, N'Sữa tươi Vinamilk', N'Sữa hộp 1L', 30000, 1000, 500, N'Hộp', '2023-02-19', '2023-02-23', 4, 10),
(50, N'Dầu ăn Tường An', N'Dầu ăn 5L', 150000, 300, 150, N'Chai', '2023-02-20', '2023-02-24', 4, 9);

INSERT INTO LOAIPHIEUMUAHANG (MaLP, MaPH, TriGia) VALUES
(1, 1, 1200000),  -- Kim Cương
(2, 2, 700000),   -- Bạch Kim
(3, 3, 500000),   -- Vàng
(4, 4, 200000),   -- Bạc
(5, 5, 100000),   -- Đồng
(6, 6, 0);        -- Thân Thiết (không nhận phiếu)

INSERT INTO PHIEUMUAHANG (MaPhieu, MaKH, NgayTang, MaLP, MaNV, HanSuDung, TrangThai) VALUES
(1, 1, '2023-01-01', 1, 1, '2023-12-31', N'Chưa sử dụng'),
(2, 2, '2023-02-01', 2, 2, '2023-12-31', N'Đã sử dụng'),
(3, 3, '2023-03-01', 3, 3, '2023-12-31', N'Chưa sử dụng'),
(4, 4, '2023-04-01', 4, 4, '2023-12-31', N'Hết hạn'),
(5, 5, '2023-05-01', 5, 5, '2023-12-31', N'Chưa sử dụng'),
(6, 6, '2023-06-01', 1, 6, '2023-12-31', N'Đã sử dụng'),
(7, 7, '2023-07-01', 2, 7, '2023-12-31', N'Hết hạn'),
(8, 8, '2023-08-01', 3, 8, '2023-12-31', N'Chưa sử dụng'),
(9, 9, '2023-09-01', 4, 9, '2023-12-31', N'Chưa sử dụng'),
(10, 10, '2023-10-01', 5, 10, '2023-12-31', N'Chưa sử dụng');

INSERT INTO DONHANG (MaDH, NgayDat, NgayGiao, TinhTrang, ThanhTien, TongPhaiTra, MaPhieu, MaNV, MaKH) VALUES
(1, '2023-01-01', '2023-01-05', N'Đã giao', 1500000, 1400000, 1, 1, 1),
(2, '2023-02-01', '2023-02-06', N'Đã giao', 2000000, 1800000, 2, 2, 2),
(3, '2023-03-01', '2023-03-05', N'Đang xử lý', 3000000, 2800000, 3, 3, 3),
(4, '2023-04-01', '2023-04-10', N'Đã giao', 2500000, 2300000, 4, 4, 4),
(5, '2023-05-01', '2023-05-06', N'Đã giao', 1200000, 1100000, 5, 5, 5),
(6, '2023-06-01', '2023-06-05', N'Đã giao', 5000000, 4700000, 6, 6, 6),
(7, '2023-07-01', '2023-07-06', N'Đã giao', 800000, 750000, NULL, 7, 7),
(8, '2023-08-01', '2023-08-05', N'Đã giao', 900000, 850000, NULL, 8, 8),
(9, '2023-09-01', '2023-09-10', N'Đang vận chuyển', 3000000, 3000000, NULL, 9, 9),
(10, '2023-10-01', '2023-10-06', N'Đã giao', 1500000, 1400000, 10, 10, 10);

INSERT INTO KHUYENMAI (MaKhuyenMai, NgayBatDau, NgayKetThuc, NgayTaoMaKM, TiLe, SLToiDa, TinhTrang, SLDaBan, LoaiKM, MaNV) VALUES
(1, '2023-01-01', '2023-01-10', '2022-12-25', 10, 50, N'Đang diễn ra', 20, N'Flash-sale', 1),
(2, '2023-01-05', '2023-01-15', '2022-12-28', 15, 30, N'Kết thúc', 30, N'Flash-sale', 2),
(3, '2023-01-10', '2023-01-20', '2023-01-01', 20, 20, N'Đang diễn ra', 10, N'Combo-sale', 3),
(4, '2023-01-15', '2023-01-25', '2023-01-05', 25, 25, N'Đang diễn ra', 15, N'Member-sale', 4),
(5, '2023-02-01', '2023-02-10', '2023-01-20', 5, 100, N'Đang diễn ra', 50, N'Flash-sale', 5),
(6, '2023-02-05', '2023-02-15', '2023-01-25', 10, 40, N'Kết thúc', 40, N'Flash-sale', 1),
(7, '2023-02-10', '2023-02-20', '2023-02-01', 15, 30, N'Đang diễn ra', 20, N'Combo-sale', 2),
(8, '2023-02-15', '2023-02-25', '2023-02-05', 20, 50, N'Đang diễn ra', 30, N'Member-sale', 3),
(9, '2023-03-01', '2023-03-10', '2023-02-20', 30, 60, N'Đang diễn ra', 40, N'Flash-sale', 4),
(10, '2023-03-05', '2023-03-15', '2023-02-25', 35, 50, N'Kết thúc', 50, N'Combo-sale', 5),
(11, '2023-03-10', '2023-03-20', '2023-03-01', 20, 100, N'Đang diễn ra', 70, N'Member-sale', 1),
(12, '2023-03-15', '2023-03-25', '2023-03-05', 10, 40, N'Đang diễn ra', 20, N'Flash-sale', 2),
(13, '2023-04-01', '2023-04-10', '2023-03-20', 25, 50, N'Đang diễn ra', 35, N'Combo-sale', 3),
(14, '2023-04-05', '2023-04-15', '2023-03-25', 30, 60, N'Kết thúc', 50, N'Member-sale', 4),
(15, '2023-04-10', '2023-04-20', '2023-04-01', 20, 50, N'Đang diễn ra', 40, N'Flash-sale', 5),
(16, '2023-05-01', '2023-05-10', '2023-04-20', 15, 30, N'Đang diễn ra', 20, N'Combo-sale', 1),
(17, '2023-05-05', '2023-05-15', '2023-04-25', 25, 40, N'Đang diễn ra', 30, N'Member-sale', 2),
(18, '2023-05-10', '2023-05-20', '2023-05-01', 10, 100, N'Đang diễn ra', 80, N'Flash-sale', 3),
(19, '2023-05-15', '2023-05-25', '2023-05-05', 20, 60, N'Đang diễn ra', 40, N'Combo-sale', 4),
(20, '2023-06-01', '2023-06-10', '2023-05-20', 30, 40, N'Đang diễn ra', 30, N'Member-sale', 5),
(21, '2023-06-05', '2023-06-15', '2023-05-25', 35, 50, N'Kết thúc', 50, N'Flash-sale', 1),
(22, '2023-06-10', '2023-06-20', '2023-06-01', 20, 30, N'Đang diễn ra', 20, N'Combo-sale', 2),
(23, '2023-06-15', '2023-06-25', '2023-06-05', 25, 50, N'Đang diễn ra', 30, N'Member-sale', 3),
(24, '2023-07-01', '2023-07-10', '2023-06-20', 10, 60, N'Đang diễn ra', 40, N'Flash-sale', 4),
(25, '2023-07-05', '2023-07-15', '2023-06-25', 15, 40, N'Đang diễn ra', 30, N'Combo-sale', 5),
(26, '2023-07-10', '2023-07-20', '2023-07-01', 30, 50, N'Đang diễn ra', 40, N'Member-sale', 1),
(27, '2023-08-01', '2023-08-10', '2023-07-20', 25, 70, N'Kết thúc', 70, N'Flash-sale', 2),
(28, '2023-08-05', '2023-08-15', '2023-07-25', 20, 40, N'Đang diễn ra', 20, N'Combo-sale', 3),
(29, '2023-08-10', '2023-08-20', '2023-08-01', 15, 50, N'Đang diễn ra', 30, N'Member-sale', 4),
(30, '2023-08-15', '2023-08-25', '2023-08-05', 10, 100, N'Đang diễn ra', 80, N'Flash-sale', 5);

INSERT INTO CTDONHANG (MaDH, STT, MaSP, SoLuong, ThanhTien, MaKhuyenMai, TienPhaiTra) VALUES
(1, 1, 1, 1, 1500000, NULL, 1400000),
(1, 2, 2, 1, 1500000, 1, 1400000),
(2, 1, 3, 2, 4000000, NULL, 3600000),
(3, 1, 4, 1, 2500000, 2, 2300000),
(3, 2, 5, 1, 2500000, NULL, 2300000),
(4, 1, 6, 3, 9000000, NULL, 8700000),
(5, 1, 7, 2, 6000000, NULL, 5800000),
(5, 2, 8, 1, 3000000, 3, 2800000),
(6, 1, 9, 1, 4500000, NULL, 4200000),
(6, 2, 10, 1, 5000000, NULL, 4700000),
(7, 1, 11, 5, 1500000, NULL, 1400000),
(7, 2, 12, 2, 1000000, 4, 950000),
(8, 1, 13, 4, 200000, NULL, 180000),
(9, 1, 14, 2, 2000000, NULL, 2000000),
(10, 1, 15, 3, 3000000, NULL, 2700000);

INSERT INTO FLASHSALE (MaKhuyenMai, MaSP) VALUES
(1, 1), 
(2, 2), 
(5, 3), 
(6, 4), 
(9, 5), 
(12, 6), 
(15, 7), 
(18, 8), 
(24, 9), 
(30, 10);


INSERT INTO COMBOSALE (MaKhuyenMai, MaSP1, MaSP2) VALUES
(3, 1, 2),
(7, 3, 4),
(10, 5, 6),
(13, 7, 8),
(16, 9, 10),
(19, 11, 12),
(22, 13, 14),
(25, 15, 16),
(28, 17, 18),
(29, 19, 20);


INSERT INTO MEMBERSALE (MaKhuyenMai, MaPH) VALUES
(4, 1), 
(8, 2), 
(11, 3), 
(14, 4), 
(17, 5), 
(20, 1), 
(23, 2), 
(26, 3), 
(27, 4), 
(29, 5);

INSERT INTO DONDATNSX (MaDDH, MaNSX, SoLuong, MaSP, NgayDat, TinhTrang, MaNV) VALUES
(1, 1, 50, 1, '2023-01-01', N'Chưa giao', 1),
(2, 2, 30, 2, '2023-01-05', N'Đã giao', 2),
(3, 3, 40, 3, '2023-01-10', N'Đã giao', 3),
(4, 4, 20, 4, '2023-01-15', N'Chưa giao', 4),
(5, 5, 60, 5, '2023-01-20', N'Đã giao', 5),
(6, 6, 70, 6, '2023-01-25', N'Chưa giao', 1),
(7, 7, 80, 7, '2023-02-01', N'Đã giao', 2),
(8, 8, 90, 8, '2023-02-05', N'Đã giao', 3),
(9, 9, 100, 9, '2023-02-10', N'Chưa giao', 4),
(10, 10, 110, 10, '2023-02-15', N'Đã giao', 5);

INSERT INTO DONNHANHANG (MaDNH, MaNV, NgayNhan, TongTien, MaNSX) VALUES
(1, 1, '2023-01-06', 5000000, 1),
(2, 2, '2023-01-10', 3000000, 2),
(3, 3, '2023-01-15', 4000000, 3),
(4, 4, '2023-01-20', 2000000, 4),
(5, 5, '2023-01-25', 6000000, 5),
(6, 1, '2023-02-01', 7000000, 6),
(7, 2, '2023-02-06', 8000000, 7),
(8, 3, '2023-02-10', 9000000, 8),
(9, 4, '2023-02-15', 10000000, 9),
(10, 5, '2023-02-20', 11000000, 10);

INSERT INTO CTDONNHANHANG (STT, MaDNH, SoLuong, DonGia, ThanhTien, MaDDH) VALUES
(1, 1, 50, 100000, 5000000, 1),
(2, 2, 30, 100000, 3000000, 2),
(1, 3, 40, 100000, 4000000, 3),
(1, 4, 20, 100000, 2000000, 4),
(1, 5, 60, 100000, 6000000, 5),
(1, 6, 70, 100000, 7000000, 6),
(1, 7, 80, 100000, 8000000, 7),
(1, 8, 90, 100000, 9000000, 8),
(1, 9, 100, 100000, 10000000, 9),
(1, 10, 110, 100000, 11000000, 10);



