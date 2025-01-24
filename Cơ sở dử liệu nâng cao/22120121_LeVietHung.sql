--22120121
--Cau 1 : 
--Viết stored hoặc function thực hiện yêu cầu: Cho danh sách quản lý (mã, họ tên,
--tên khu vực đang quản lý hiện tại, số lượng khu vực đã từng quản lý, số năm
--kinh nghiệm quản lý) có số năm quản lý lâu nhất.
USE [SaleManagementDB]
GO

CREATE OR ALTER PROCEDURE QuanLiLauNamNhat
AS
BEGIN
    WITH ManagerExperience AS (
        SELECT 
            mh.ManagerID,
            e.FullName,
            MAX(r.RegionName) AS CurrentRegion,
            COUNT(DISTINCT mh.RegionID) AS TotalRegionsManaged, 
            SUM(DATEDIFF(YEAR, 
                ISNULL(mh.StartDate, GETDATE()), 
                ISNULL(mh.EndDate, GETDATE()))) AS TotalYearsExperience
        FROM 
            ManagerHistory mh
        JOIN Employee e ON mh.ManagerID = e.EmployeeID
        LEFT JOIN Region r ON r.CurrentManagerID = mh.ManagerID
        GROUP BY mh.ManagerID, e.FullName
    ),
    MaxExperience AS (
        SELECT MAX(TotalYearsExperience) AS MaxYears FROM ManagerExperience
    )
    SELECT 
        me.ManagerID,
        me.FullName,
        me.CurrentRegion,
        me.TotalRegionsManaged,
        me.TotalYearsExperience
    FROM 
        ManagerExperience me
    CROSS JOIN MaxExperience mx
    WHERE 
        me.TotalYearsExperience = mx.MaxYears
    ORDER BY 
        me.TotalYearsExperience DESC
END
GO

EXEC QuanLiLauNamNhat;

--Cau 2:
CREATE OR ALTER PROCEDURE NhanVienDieuChuyen
AS
BEGIN
    SELECT 
        e.EmployeeID,
        e.FullName,
        r.RegionName AS CurrentRegion,
        ISNULL(COUNT(c.ContractID), 0) AS TotalContractsSigned,
        DATEDIFF(YEAR, e.HireDate, GETDATE()) AS YearsWorked
    FROM 
        Employee e
    LEFT JOIN EmployeeRegion er ON e.EmployeeID = er.EmployeeID
    LEFT JOIN Region r ON er.RegionID = r.RegionID AND er.EndDate IS NULL
    LEFT JOIN Contract c ON e.EmployeeID = c.EmployeeID
    WHERE 
        (
            (
                DATEDIFF(YEAR, er.StartDate, GETDATE()) > 3 
                AND NOT EXISTS (
                    SELECT 1 
                    FROM EmployeeRegion er2 
                    WHERE er2.EmployeeID = e.EmployeeID 
                    AND er2.EndDate IS NOT NULL
                )
            )
            OR 
            (
                NOT EXISTS (
                    SELECT 1 
                    FROM Contract c2 
                    WHERE c2.EmployeeID = e.EmployeeID
                )
            )
        )
    GROUP BY 
        e.EmployeeID, 
        e.FullName, 
        r.RegionName, 
        e.HireDate
    ORDER BY 
        YearsWorked DESC, 
        TotalContractsSigned ASC;
END
GO

EXEC NhanVienDieuChuyen;


--Cau 3
CREATE TRIGGER QuanLiThamNien
ON Region
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        LEFT JOIN ManagerHistory mh 
            ON i.CurrentManagerID = mh.ManagerID 
            AND i.RegionID = mh.RegionID
        WHERE 
            ISNULL(DATEDIFF(YEAR, mh.StartDate, ISNULL(mh.EndDate, GETDATE())), 0) < 3
    )
    BEGIN
        RAISERROR ('Manager must have at least 3 years tenure in the region.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    INSERT INTO Region (RegionID, RegionName, CurrentManagerID)
    SELECT RegionID, RegionName, CurrentManagerID
    FROM inserted;
END;

INSERT INTO ManagerHistory (ManagerHistoryID ,ManagerID, RegionID, StartDate, EndDate)
VALUES 
(5,1, 1, '2018-01-01', '2021-01-01'),
(6,1, 2, '2021-01-01', '2022-01-01');


INSERT INTO ManagerHistory (ManagerHistoryID,ManagerID, RegionID, StartDate, EndDate)
VALUES 
(7,2, 3, '2020-01-01', '2022-01-01');

INSERT INTO ManagerHistory (ManagerHistoryID,ManagerID, RegionID, StartDate, EndDate)
VALUES 
(9,3,2, '2020-01-01', '2024-01-01');

INSERT INTO Region (RegionID, RegionName,CurrentManagerID)
VALUES (5, 'D Region',NULL);
select* from ManagerHistory
select* from Region

UPDATE Region
SET CurrentManagerID = 1
WHERE RegionID = 4;
