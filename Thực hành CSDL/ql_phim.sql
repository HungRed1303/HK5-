USE [master]
GO
/****** Object:  Database [QLPHIM]    Script Date: 9/23/2022 9:01:23 PM ******/
CREATE DATABASE [QLPHIM]
 go
 USE QLPHIM
 GO
CREATE TABLE [dbo].[MUONPHIM](
	[CMND] [char](12) NOT NULL,
	[TENPHIM] [nvarchar](30) NOT NULL,
	[STTTAP] [int] NOT NULL,
	[NGAYMUON] [date] NOT NULL,
	[SONGAYQUYDINH] [int] NULL,
	[NGAYTRA] [date] NULL,
 CONSTRAINT [PK_MUONPHIM] PRIMARY KEY CLUSTERED 
(
	[CMND] ASC,
	[TENPHIM] ASC,
	[STTTAP] ASC,
	[NGAYMUON] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[F_MUONPHIM]    Script Date: 9/23/2022 9:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE
FUNCTION [dbo].[F_MUONPHIM](@CMND VARCHAR(10))
RETURNS TABLE
AS
	RETURN (SELECT MUONPHIM.*, PHIM.NAMSX FROM MUONPHIM JOIN PHIM ON PHIM.TENPHIM = MUONPHIM.TENPHIM WHERE CMND = @CMND)
GO
/****** Object:  Table [dbo].[TAPPHIM]    Script Date: 9/23/2022 9:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TAPPHIM](
	[TENPHIM] [nvarchar](30) NOT NULL,
	[STTTAP] [int] NOT NULL,
	[THOILUONG] [int] NULL,
	[SLTON] [int] NULL,
 CONSTRAINT [PK_TAPPHIM] PRIMARY KEY CLUSTERED 
(
	[TENPHIM] ASC,
	[STTTAP] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[MUONPHIM] ([CMND], [TENPHIM], [STTTAP], [NGAYMUON], [SONGAYQUYDINH], [NGAYTRA]) VALUES (N'11111       ', N'MA', 1, CAST(N'2022-09-23' AS Date), NULL, NULL)
GO
INSERT [dbo].[MUONPHIM] ([CMND], [TENPHIM], [STTTAP], [NGAYMUON], [SONGAYQUYDINH], [NGAYTRA]) VALUES (N'111111      ', N'MA', 1, CAST(N'2022-09-23' AS Date), NULL, NULL)
GO
INSERT [dbo].[MUONPHIM] ([CMND], [TENPHIM], [STTTAP], [NGAYMUON], [SONGAYQUYDINH], [NGAYTRA]) VALUES (N'12334       ', N'MA', 1, CAST(N'2000-12-30' AS Date), 3, CAST(N'2003-03-03' AS Date))
GO
INSERT [dbo].[PHIM] ([TENPHIM], [NAMSX], [NUOCSX], [THELOAI]) VALUES (N'HÌNH SỰ', 1990, N'ANH', NULL)
GO
INSERT [dbo].[PHIM] ([TENPHIM], [NAMSX], [NUOCSX], [THELOAI]) VALUES (N'MA', 1999, N'VIETNAM', NULL)
GO
INSERT [dbo].[TAPPHIM] ([TENPHIM], [STTTAP], [THOILUONG], [SLTON]) VALUES (N'MA', 1, NULL, 10)
GO
INSERT [dbo].[TAPPHIM] ([TENPHIM], [STTTAP], [THOILUONG], [SLTON]) VALUES (N'MA', 2, NULL, NULL)
GO
ALTER TABLE [dbo].[MUONPHIM]  WITH CHECK ADD  CONSTRAINT [FK_MP_TP] FOREIGN KEY([TENPHIM], [STTTAP])
REFERENCES [dbo].[TAPPHIM] ([TENPHIM], [STTTAP])
GO
ALTER TABLE [dbo].[MUONPHIM] CHECK CONSTRAINT [FK_MP_TP]
GO
ALTER TABLE [dbo].[TAPPHIM]  WITH CHECK ADD  CONSTRAINT [FK_TPHIM_PHIM] FOREIGN KEY([TENPHIM])
REFERENCES [dbo].[PHIM] ([TENPHIM])
GO
ALTER TABLE [dbo].[TAPPHIM] CHECK CONSTRAINT [FK_TPHIM_PHIM]
GO
/****** Object:  StoredProcedure [dbo].[THEM_MP]    Script Date: 9/23/2022 9:01:23 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE 
--ALTER
PROC [dbo].[THEM_MP]
	@CMND VARCHAR(10),
	@TENPHIM VARCHAR(30),
	@STTTAP INT
AS
	IF @CMND IS NULL 
	BEGIN
		RETURN 0 -- LỖI
	END
	IF @TENPHIM NOT IN (SELECT TENPHIM FROM PHIM)
		RETURN 0
	IF @STTTAP <= 0 
		RETURN 0
	INSERT MUONPHIM(CMND,TENPHIM,STTTAP,NGAYMUON)
	VALUES(@CMND,@TENPHIM,@STTTAP,GETDATE())

	IF @@ERROR = 0
		RETURN 1
GO
USE [master]
GO
ALTER DATABASE [QLPHIM] SET  READ_WRITE 
GO
