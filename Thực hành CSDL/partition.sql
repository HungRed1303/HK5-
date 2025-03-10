CREATE DATABASE DBForPartitioning
ON 
PRIMARY 
(NAME='DBForPartitioning_1',
FILENAME= 'E:\PartitionDB\FG1\DBForPartitioning_1.mdf',
SIZE=2,
MAXSIZE=100,
FILEGROWTH=1 ),
FILEGROUP FG2
(NAME = 'DBForPartitioning_2',
FILENAME = 'E:\PartitionDB\FG2\DBForPartitioning_2.ndf', SIZE = 2, MAXSIZE=100,
FILEGROWTH=1 ),
FILEGROUP FG3
(NAME = 'DBForPartitioning_3', 
FILENAME ='E:\PartitionDB\FG3\DBForPartitioning_3.ndf',
SIZE = 2,
MAXSIZE=100,
FILEGROWTH=1 )
GO
Use DBFOrPartitioning
GO 
-- Confirm Filegroups
SELECT name as [File Group Name]
FROM sys.filegroups
WHERE type = 'FG'
GO 
SELECT name as [DB FileName],physical_name as [DB File Path] 
FROM sys.database_files
where type_desc = 'ROWS'
GO
CREATE PARTITION FUNCTION salesYearPartitions (datetime)
AS 
RANGE RIGHT 
FOR VALUES ( '2009-01-01', '2010-01-01')
GO
CREATE PARTITION SCHEME Test_PartitionScheme
AS 
	PARTITION salesYearPartitions
	TO ([PRIMARY], FG2, FG3 )
GO
CREATE TABLE SalesArchival
(
	SaleTime datetime PRIMARY KEY,
	ItemName varchar(50)
)
ON Test_PartitionScheme (SaleTime);
GO
SELECT
p.partition_number AS PartitionNumber,
f.name AS PartitionFilegroup, 
p.rows AS NumberOfRows 
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'SalesArchival'
GO
--THÊM DỮ LIỆU
SELECT * FROM SalesArchival
INSERT SalesArchival 
VALUES('2009-1-12','1'),
('2010-12-1','2'),
('2009-11-12','1'),
('2009-2-1','2'),
('2010-1-12','1'),
('2009-1-1','2'),
('2008-1-12','1'),
('2008-12-1','2')
--------------------------
USE QL_PHIM
GO
ALTER DATABASE QL_PHIM
ADD FILEGROUP FG4

ALTER DATABASE QL_PHIM
ADD FILEGROUP FG5

--
ALTER DATABASE QL_PHIM
ADD FILE (
	NAME = FG4_2000,
	FILENAME = 'E:\PartitionDB\FG4\DBPartition_4.ndf',
	SIZE = 1MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1
) TO FILEGROUP FG4
ALTER DATABASE QL_PHIM
ADD FILE (
	NAME = FG5_2001,
	FILENAME = 'E:\PartitionDB\FG4\DBPartition_5.ndf',
	SIZE = 1MB,
	MAXSIZE = UNLIMITED,
	FILEGROWTH = 1
) TO FILEGROUP FG5
--
CREATE PARTITION FUNCTION salesYearPartitions(DATE)
AS RANGE LEFT
FOR VALUES('2000-12-31','2001-12-31')
--
CREATE PARTITION SCHEME salesYearPartitionsScheme
AS PARTITION salesYearPartitions
TO (FG4,FG5,[PRIMARY])
--
ALTER TABLE MUONPHIM
DROP CONSTRAINT PK_MP
--
ALTER TABLE MUONPHIM
ADD PRIMARY KEY NONCLUSTERED(CMND,TENPHIM, STT ASC)
ON [PRIMARY]
--
CREATE CLUSTERED INDEX IX_NGAYMUON_DATE
ON MUONPHIM
(
	NGAYMUON
) ON salesYearPartitionsScheme(NGAYMUON)

SELECT 
	p.partition_number AS partition_number,
	f.name AS file_group, 
	p.rows AS row_count
FROM sys.partitions p
JOIN sys.destination_data_spaces dds ON p.partition_number = dds.destination_id
JOIN sys.filegroups f ON dds.data_space_id = f.data_space_id
WHERE OBJECT_NAME(OBJECT_ID) = 'MUONPHIM'
order by partition_number;
