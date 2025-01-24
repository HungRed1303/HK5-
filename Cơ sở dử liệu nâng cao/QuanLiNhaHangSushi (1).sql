CREATE DATABASE SUSHISTORE_MANAGEMENT
GO

USE SUSHISTORE_MANAGEMENT
GO

CREATE TABLE AREA (
    AreaID INT PRIMARY KEY,
    AreaName NVARCHAR(255)
);
GO

CREATE TABLE QUALITY (
    BranchID INT,
    AreaID INT,
    ServicePoints INT,
    LocationPoints INT,
    FoodPoints INT,
    PricePoints INT,
    SpacePoint INT,
    Comment NVARCHAR(255),
    PRIMARY KEY (BranchID, AreaID)
);
GO

CREATE TABLE BRANCH (
    BranchID INT PRIMARY KEY,
    BranchName NVARCHAR(255),
    BranchAddress NVARCHAR(255),
    OpenHour TIME,
    CloseHour TIME,
    PhoneNumber CHAR(15),
    HasCarParking VARCHAR(10) CHECK (HasCarParking IN ('YES', 'NO')),
    HasMotorParking VARCHAR(10) CHECK (HasMotorParking IN ('YES', 'NO')),
    AreaID INT,
    ManagerID INT,
    HasDeliveryService VARCHAR(10) CHECK (HasDeliveryService IN ('YES', 'NO'))
);
GO

CREATE TABLE MENU_DIRECTORY (
    BranchID INT,
    DirectoryID INT,
    PRIMARY KEY (BranchID, DirectoryID)
);
GO

CREATE TABLE DIRECTORY (
    DirectoryID INT PRIMARY KEY,
    DirectoryName NVARCHAR(255)
);
GO

CREATE TABLE DIRECTORY_DISH (
    DirectoryID INT,
    DishID INT,
    PRIMARY KEY (DirectoryID, DishID)
);
GO

CREATE TABLE DEPARTMENT (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(255),
    BranchID INT
);
GO

CREATE TABLE EMPLOYEE (
    EmployeeID INT PRIMARY KEY,
    EmployeeName NVARCHAR(255),
    EmployeeBirth DATE,
    EmployeeGender NVARCHAR(10),
    Salary INT CHECK (Salary > 0),
    EntryDate DATE,
    LeaveDate DATE,
    DepartmentID INT,
    BranchID INT,
    EmployeeAddress NVARCHAR(255),
    EmployeePhone CHAR(15)
);
GO

CREATE TABLE EMPLOYEE_HISTORY (
    EmployeeID INT,
    BranchID INT,
    EntryDate DATE,
    LeaveDate DATE,
    PRIMARY KEY (EmployeeID, BranchID, EntryDate),
    CHECK (EntryDate < LeaveDate)
);
GO

CREATE TABLE CARD_CUSTOMER (
    CardID INT PRIMARY KEY,
    CardEstablishDate DATE,
    EmployeeID INT,
    Score INT,
    CardType NVARCHAR(100)
);
GO

CREATE TABLE CUSTOMER (
    CardID INT PRIMARY KEY,
    CustomerName NVARCHAR(255),
    CustomerEmail NVARCHAR(255),
    CustomerGender NVARCHAR(10) CHECK (CustomerGender IN ('male', 'female', 'other')),
    CustomerPhone CHAR(15),
    CCCD CHAR(12)
);
GO

CREATE TABLE ORDER_DIRECTORY (
    OrderID INT PRIMARY KEY,
    EmployeeID INT,
    NumberTable INT
);
GO

CREATE TABLE ORDER_ONLINE (
    OnOrderID INT PRIMARY KEY,
    BranchID INT,
    DateOrder DATE,
    TimeOrder TIME,
    AmountCustomer INT,
    Note NVARCHAR(255)
);
GO

CREATE TABLE ORDER_DISH_AMOUNT (
    OrderID INT,
    DishID INT,
    AmountDish INT CHECK (AmountDish > 0),
    PRIMARY KEY (OrderID, DishID)
);
GO

CREATE TABLE DISH (
    DishID INT PRIMARY KEY,
    DishName NVARCHAR(255),
    Price INT
);
GO

CREATE TABLE INVOICE (
    InvoiceID INT PRIMARY KEY,
    CardID INT,
    TotalMoney INT,
    DiscountMoney INT,
    PaymentDate DATE,
    OrderID INT
);
GO

CREATE TABLE ORDER_OFFLINE (
    OffOrderID INT PRIMARY KEY,
    OrderEstablishDate DATE
);
GO

CREATE TABLE RevenueByDate (
    RevenueDate DATE PRIMARY KEY,
    TotalRevenue INT
);
GO

CREATE TABLE RevenueByMonth (
    RevenueMonth INT,
	RevenueYear INT,
    TotalRevenue INT,
	PRIMARY KEY (REVENUEMONTH, REVENUEYEAR)
);
GO

CREATE TABLE RevenueByQuarter (
    RevenueYear INT,
    RevenueQuarter INT,
    TotalRevenue INT,
    PRIMARY KEY (RevenueYear, RevenueQuarter)
);
GO

CREATE TABLE RevenueByYear (
    RevenueYear INT PRIMARY KEY,
    TotalRevenue INT
);
GO

ALTER TABLE QUALITY
ADD CONSTRAINT FK_Quality_Area FOREIGN KEY (AreaID) REFERENCES AREA(AreaID),
    CONSTRAINT FK_Quality_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID);
GO

ALTER TABLE BRANCH
ADD CONSTRAINT FK_Branch_Area FOREIGN KEY (AreaID) REFERENCES AREA(AreaID),
    CONSTRAINT FK_Branch_Manager FOREIGN KEY (ManagerID) REFERENCES EMPLOYEE(EmployeeID);
GO

ALTER TABLE MENU_DIRECTORY
ADD CONSTRAINT FK_MenuDirectory_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID),
    CONSTRAINT FK_MenuDirectory_Directory FOREIGN KEY (DirectoryID) REFERENCES DIRECTORY(DirectoryID);
GO

ALTER TABLE DIRECTORY_DISH
ADD CONSTRAINT FK_DirectoryDish_Directory FOREIGN KEY (DirectoryID) REFERENCES DIRECTORY(DirectoryID),
    CONSTRAINT FK_DirectoryDish_Dish FOREIGN KEY (DishID) REFERENCES DISH(DishID);
GO

ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_Department_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID);
GO

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_Employee_Department FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENT(DepartmentID),
    CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID);
GO

ALTER TABLE EMPLOYEE_HISTORY
ADD CONSTRAINT FK_EmployeeHistory_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID),
    CONSTRAINT FK_EmployeeHistory_Employee FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID);
GO

ALTER TABLE CARD_CUSTOMER
ADD CONSTRAINT FK_CardCustomer_Employee FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID);
GO

ALTER TABLE CUSTOMER
ADD CONSTRAINT FK_Customer_Card FOREIGN KEY (CardID) REFERENCES CARD_CUSTOMER(CardID);
GO

ALTER TABLE ORDER_DIRECTORY
ADD CONSTRAINT FK_OrderDirectory_Employee FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE(EmployeeID);
GO

ALTER TABLE ORDER_ONLINE
ADD CONSTRAINT FK_OrderOnline_Branch FOREIGN KEY (BranchID) REFERENCES BRANCH(BranchID);
GO

ALTER TABLE ORDER_DISH_AMOUNT
ADD CONSTRAINT FK_OrderDishAmount_Order FOREIGN KEY (OrderID) REFERENCES ORDER_DIRECTORY(OrderID),
    CONSTRAINT FK_OrderDishAmount_Dish FOREIGN KEY (DishID) REFERENCES DISH(DishID);
GO

ALTER TABLE INVOICE
ADD CONSTRAINT FK_Invoice_Card FOREIGN KEY (CardID) REFERENCES CARD_CUSTOMER(CardID),
    CONSTRAINT FK_Invoice_Order FOREIGN KEY (OrderID) REFERENCES ORDER_DIRECTORY(OrderID);
GO

ALTER TABLE ORDER_OFFLINE
ADD CONSTRAINT FK_OfflineOrder FOREIGN KEY (OffOrderID) REFERENCES ORDER_DIRECTORY(OrderID);
GO

-- Insert into AREA table
INSERT INTO AREA (AreaID, AreaName)
VALUES 
(1, 'Hà Nội'),
(2, 'Hồ Chí Minh'),
(3, 'Đà Nẵng'),
(4, 'Hải Phòng'),
(5, 'Cần Thơ'),
(6, 'Huế'),
(7, 'Nha Trang'),
(8, 'Vũng Tàu'),
(9, 'Quảng Ninh'),
(10, 'Thanh Hóa'),
(11, 'Nghệ An'),
(12, 'Quảng Nam'),
(13, 'Bình Dương'),
(14, 'Đồng Nai'),
(15, 'Lâm Đồng'),
(16, 'Thái Nguyên'),
(17, 'Nam Định'),
(18, 'Quảng Bình'),
(19, 'Bắc Ninh'),
(20, 'Phú Thọ');
GO

-- Insert into BRANCH table with reference to AREA
INSERT INTO BRANCH (BranchID, BranchName, BranchAddress, OpenHour, CloseHour, PhoneNumber, HasCarParking, HasMotorParking, AreaID, ManagerID, HasDeliveryService)
VALUES
-- Hanoi
(1, 'Tokyo Sushi Hanoi', '123 Kim Ma, Ba Dinh, Hanoi', '10:00:00', '22:00:00', '0912345678', 'YES', 'YES', 1, NULL, 'YES'),
(2, 'Ramen House Hanoi', '45 Trang Tien, Hoan Kiem, Hanoi', '11:00:00', '21:00:00', '0923456789', 'NO', 'YES', 1, NULL, 'YES'),
(3, 'Tempura King Hanoi', '78 Hoang Hoa Tham, Ba Dinh, Hanoi', '09:00:00', '22:30:00', '0934567890', 'YES', 'YES', 1, NULL, 'NO'),

-- Ho Chi Minh City
(4, 'Tokyo Sushi HCM', '234 Nguyen Hue, District 1, HCM', '10:30:00', '23:00:00', '0945678901', 'YES', 'YES', 2, NULL, 'YES'),
(5, 'Ramen House HCM', '567 Le Loi, District 3, HCM', '09:00:00', '22:00:00', '0956789012', 'YES', 'YES', 2, NULL, 'NO'),
(6, 'Tempura King HCM', '890 Hai Ba Trung, District 1, HCM', '10:00:00', '21:30:00', '0967890123', 'NO', 'YES', 2, NULL, 'YES'),

-- Da Nang
(7, 'Tokyo Sushi Da Nang', '12 Tran Phu, Da Nang', '11:00:00', '22:00:00', '0978901234', 'YES', 'YES', 3, NULL, 'YES'),
(8, 'Ramen House Da Nang', '34 Bach Dang, Da Nang', '10:00:00', '21:00:00', '0989012345', 'NO', 'YES', 3, NULL, 'YES'),
(9, 'Tempura King Da Nang', '56 Phan Chau Trinh, Da Nang', '10:30:00', '22:30:00', '0990123456', 'YES', 'YES', 3, NULL, 'NO'),

-- Hai Phong
(10, 'Tokyo Sushi Hai Phong', '78 Le Hong Phong, Hai Phong', '10:00:00', '22:00:00', '0910987654', 'YES', 'YES', 4, NULL, 'YES'),
(11, 'Ramen House Hai Phong', '90 Tran Nguyen Han, Hai Phong', '10:30:00', '21:30:00', '0921098765', 'NO', 'YES', 4, NULL, 'YES'),
(12, 'Tempura King Hai Phong', '123 Nguyen Duc Canh, Hai Phong', '11:00:00', '22:30:00', '0932109876', 'YES', 'YES', 4, NULL, 'NO'),

-- Can Tho
(13, 'Tokyo Sushi Can Tho', '456 Hung Vuong, Can Tho', '10:00:00', '22:00:00', '0943210987', 'YES', 'YES', 5, NULL, 'YES'),
(14, 'Ramen House Can Tho', '789 Le Loi, Can Tho', '10:30:00', '21:30:00', '0954321098', 'NO', 'YES', 5, NULL, 'YES'),
(15, 'Tempura King Can Tho', '90 Phan Dinh Phung, Can Tho', '11:00:00', '22:00:00', '0965432109', 'YES', 'YES', 5, NULL, 'NO'),

-- Hue
(16, 'Tokyo Sushi Hue', '12 Nguyen Hue, Hue', '09:00:00', '21:30:00', '0976543210', 'YES', 'YES', 6, NULL, 'YES'),
(17, 'Ramen House Hue', '34 Le Loi, Hue', '10:30:00', '22:00:00', '0987654321', 'NO', 'YES', 6, NULL, 'YES'),
(18, 'Tempura King Hue', '56 Tran Hung Dao, Hue', '11:00:00', '22:30:00', '0998765432', 'YES', 'YES', 6, NULL, 'NO'),

-- Nha Trang (AreaID = 17)
(19, 'Tokyo Sushi Nha Trang', '45 Tran Phu, Nha Trang', '10:00:00', '22:30:00', '0911223344', 'YES', 'YES', 7, NULL, 'YES'),
(20, 'Ramen House Nha Trang', '67 Le Thanh Ton, Nha Trang', '09:30:00', '21:30:00', '0922334455', 'NO', 'YES', 7, NULL, 'YES'),
(21, 'Tempura King Nha Trang', '89 Nguyen Thien Thuat, Nha Trang', '10:30:00', '22:00:00', '0933445566', 'YES', 'YES', 7, NULL, 'NO'),

-- Vũng Tàu (AreaID = 18)
(22, 'Tokyo Sushi Vung Tau', '123 Le Hong Phong, Vung Tau', '10:00:00', '22:00:00', '0944556677', 'YES', 'YES', 8, NULL, 'YES'),
(23, 'Ramen House Vung Tau', '45 Truong Cong Dinh, Vung Tau', '10:30:00', '22:30:00', '0955667788', 'NO', 'YES', 8, NULL, 'YES'),
(24, 'Tempura King Vung Tau', '89 Ha Long, Vung Tau', '11:00:00', '22:00:00', '0966778899', 'YES', 'YES', 8, NULL, 'NO'),

-- Quảng Ninh (AreaID = 19)
(25, 'Tokyo Sushi Quang Ninh', '12 Le Loi, Ha Long, Quang Ninh', '10:00:00', '22:00:00', '0977889900', 'YES', 'YES', 9, NULL, 'YES'),
(26, 'Ramen House Quang Ninh', '34 Nguyen Trai, Ha Long, Quang Ninh', '10:30:00', '22:30:00', '0988990011', 'NO', 'YES', 9, NULL, 'YES'),
(27, 'Tempura King Quang Ninh', '56 Bai Chay, Ha Long, Quang Ninh', '11:00:00', '22:00:00', '0999001122', 'YES', 'YES', 9, NULL, 'NO'),

-- Thanh Hóa (AreaID = 10)
(28, 'Tokyo Sushi Thanh Hoa', '123 Le Loi, Thanh Hoa', '10:00:00', '22:00:00', '0911223345', 'YES', 'YES', 10, NULL, 'YES'),
(29, 'Ramen House Thanh Hoa', '56 Tran Phu, Thanh Hoa', '10:30:00', '22:30:00', '0912233445', 'NO', 'YES', 10, NULL, 'YES'),
(30, 'Tempura King Thanh Hoa', '89 Nguyen Trai, Thanh Hoa', '11:00:00', '21:30:00', '0913233445', 'YES', 'YES', 10, NULL, 'NO'),

-- Nghệ An (AreaID = 11)
(31, 'Tokyo Sushi Nghe An', '123 Nguyen Van Cu, Vinh, Nghe An', '10:00:00', '22:00:00', '0914233445', 'YES', 'YES', 11, NULL, 'YES'),
(32, 'Ramen House Nghe An', '67 Ho Tung Mau, Vinh, Nghe An', '10:30:00', '22:30:00', '0915233445', 'NO', 'YES', 11, NULL, 'YES'),
(33, 'Tempura King Nghe An', '45 Le Hong Phong, Vinh, Nghe An', '11:00:00', '21:30:00', '0916233445', 'YES', 'YES', 11, NULL, 'NO'),

-- Quảng Nam (AreaID = 12)
(34, 'Tokyo Sushi Quang Nam', '12 Tran Hung Dao, Tam Ky, Quang Nam', '10:00:00', '22:00:00', '0917233445', 'YES', 'YES', 12, NULL, 'YES'),
(35, 'Ramen House Quang Nam', '45 Hung Vuong, Tam Ky, Quang Nam', '10:30:00', '22:30:00', '0918233445', 'NO', 'YES', 12, NULL, 'YES'),
(36, 'Tempura King Quang Nam', '78 Le Loi, Tam Ky, Quang Nam', '11:00:00', '21:30:00', '0919233445', 'YES', 'YES', 12, NULL, 'NO'),

-- Bình Dương (AreaID = 13)
(37, 'Tokyo Sushi Binh Duong', '123 Nguyen Thi Minh Khai, Thu Dau Mot, Binh Duong', '10:00:00', '22:00:00', '0911234567', 'YES', 'YES', 13, NULL, 'YES'),
(38, 'Ramen House Binh Duong', '56 Le Lai, Thu Dau Mot, Binh Duong', '10:30:00', '22:30:00', '0912234567', 'NO', 'YES', 13, NULL, 'YES'),
(39, 'Tempura King Binh Duong', '89 Hoang Hoa Tham, Thu Dau Mot, Binh Duong', '11:00:00', '21:30:00', '0913234567', 'YES', 'YES', 13, NULL, 'NO'),

-- Đồng Nai (AreaID = 14)
(40, 'Tokyo Sushi Dong Nai', '123 Nguyen Du, Bien Hoa, Dong Nai', '10:00:00', '22:00:00', '0914234567', 'YES', 'YES', 14, NULL, 'YES'),
(41, 'Ramen House Dong Nai', '67 Le Duan, Bien Hoa, Dong Nai', '10:30:00', '22:30:00', '0915234567', 'NO', 'YES', 14, NULL, 'YES'),
(42, 'Tempura King Dong Nai', '45 Hoang Hoa Tham, Bien Hoa, Dong Nai', '11:00:00', '21:30:00', '0916234567', 'YES', 'YES', 14, NULL, 'NO'),

-- Lâm Đồng (AreaID = 15)
(43, 'Tokyo Sushi Lam Dong', '123 Tran Phu, Da Lat, Lam Dong', '10:00:00', '22:00:00', '0917234567', 'YES', 'YES', 15, NULL, 'YES'),
(44, 'Ramen House Lam Dong', '56 Le Hong Phong, Da Lat, Lam Dong', '10:30:00', '22:30:00', '0918234567', 'NO', 'YES', 15, NULL, 'YES'),
(45, 'Tempura King Lam Dong', '89 Nguyen Chi Thanh, Da Lat, Lam Dong', '11:00:00', '21:30:00', '0919234567', 'YES', 'YES', 15, NULL, 'NO'),

-- Thái Nguyên (AreaID = 16)
(46, 'Tokyo Sushi Thai Nguyen', '123 Hoang Hoa Tham, Thai Nguyen', '10:00:00', '22:00:00', '0920234567', 'YES', 'YES', 16, NULL, 'YES'),
(47, 'Ramen House Thai Nguyen', '56 Le Duan, Thai Nguyen', '10:30:00', '22:30:00', '0921234567', 'NO', 'YES', 16, NULL, 'YES'),
(48, 'Tempura King Thai Nguyen', '89 Nguyen Trai, Thai Nguyen', '11:00:00', '21:30:00', '0922234567', 'YES', 'YES', 16, NULL, 'NO'),

-- Nam Định (AreaID = 17)
(49, 'Tokyo Sushi Nam Dinh', '123 Tran Quoc Toan, Nam Dinh', '10:00:00', '22:00:00', '0923234567', 'YES', 'YES', 17, NULL, 'YES'),
(50, 'Ramen House Nam Dinh', '56 Phan Boi Chau, Nam Dinh', '10:30:00', '22:30:00', '0924234567', 'NO', 'YES', 17, NULL, 'YES'),
(51, 'Tempura King Nam Dinh', '45 Le Hong Phong, Nam Dinh', '11:00:00', '21:30:00', '0925234567', 'YES', 'YES', 17, NULL, 'NO'),

-- Quảng Bình (AreaID = 18)
(52, 'Tokyo Sushi Quang Binh', '123 Le Duan, Dong Hoi, Quang Binh', '10:00:00', '22:00:00', '0926234567', 'YES', 'YES', 18, NULL, 'YES'),
(53, 'Ramen House Quang Binh', '56 Phan Chu Trinh, Dong Hoi, Quang Binh', '10:30:00', '22:30:00', '0927234567', 'NO', 'YES', 18, NULL, 'YES'),
(54, 'Tempura King Quang Binh', '45 Hoang Hoa Tham, Dong Hoi, Quang Binh', '11:00:00', '21:30:00', '0928234567', 'YES', 'YES', 18, NULL, 'NO'),

-- Bắc Ninh (AreaID = 19)
(55, 'Tokyo Sushi Bac Ninh', '123 Nguyen Trai, Bac Ninh', '10:00:00', '22:00:00', '0929234567', 'YES', 'YES', 19, NULL, 'YES'),
(56, 'Ramen House Bac Ninh', '56 Le Hong Phong, Bac Ninh', '10:30:00', '22:30:00', '0930234567', 'NO', 'YES', 19, NULL, 'YES'),
(57, 'Tempura King Bac Ninh', '45 Hoang Hoa Tham, Bac Ninh', '11:00:00', '21:30:00', '0931234567', 'YES', 'YES', 19, NULL, 'NO'),

-- Phú Thọ (AreaID = 20)
(58, 'Tokyo Sushi Phu Tho', '123 Nguyen Tuan, Viet Tri, Phu Tho', '10:00:00', '22:00:00', '0932234567', 'YES', 'YES', 20, NULL, 'YES'),
(59, 'Ramen House Phu Tho', '56 Le Duan, Viet Tri, Phu Tho', '10:30:00', '22:30:00', '0933234567', 'NO', 'YES', 20, NULL, 'YES'),
(60, 'Tempura King Phu Tho', '45 Phan Chu Trinh, Viet Tri, Phu Tho', '11:00:00', '21:30:00', '0934234567', 'YES', 'YES', 20, NULL, 'NO');

GO


