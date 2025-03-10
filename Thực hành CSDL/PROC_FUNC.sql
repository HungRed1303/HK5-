--một số lệnh để viết thân thủ tục
---> lệnh khai báo biến
declare @tenbien int, @t int = 0
---> gán giá trị cho biến
-- gán từng giá trị
set @tenbien = 10
set @t = (SElect SONGAYQUYDINH from MUONPHIM where CMND = '12334') --nếu trả nhiều dòng => báo lỗi
--gán nhiều giá một lúc
select @tenbien = STTTAP, @t = SONGAYQUYDINH from MUONPHIM --nếu bảng trả ra nhiều dòng => trả về dòng cuối
--thông báo
print @t
;throw 50000,'thong bao',1
raiserror('thong bao',16,1)
--điều kiện
if @t < 10
begin
	print @t
	return
end
--vòng lặp while
while @t < 10
begin
	print @t
	set @t=@t + 1
end
--các câu truy vấn select - update - delete - insert
--viết thủ tục
go
create or alter proc usp_ThemPhim
	--tham số
	@a int,
	@b int out --out kiểu gì cũng được và bao nhiêu tham số out cũng được
as
	--xử lí theo yêu cầu
	if @a > 10
		print @a
	set @b = @a + 1
	select * from MUONPHIM --out truy vấn
	return @a --chỉ out kiểu số nguyên, 1 return
go
--thực thi thủ tục
create or alter proc usp_1
as
	declare @output_k1 int, @return_k2 int
	exec @return_k2 = usp_ThemPhim 11,@output_k1 out
	if dbo.uf_demsophim(@output_k1) < 10
		update MUONPHIM
		set SONGAYQUYDINH = @output_k1
go
select * from MUONPHIM
exec usp_1
exec @return_k2 = usp_ThemPhim @a = 3,@b = @output_k1 out
--mục tiêu của function đơn giản trong truy vấn
--function trả về giá trị (scalar)
go
CREATE OR ALTER FUNCTION UF_DEMSOPHIM
	(
		@t int
	)
returns int
as
begin
--có thể viết nhiều lệnh bên trong thân của function scalar
	return (select count(*) from MUONPHIM where SONGAYQUYDINH = @t)
end

print dbo.uf_demsophim(12)
--function trả về bảng (table)
go
create or alter function uf_layphim
	(@ma int)
returns table
as
	return (select songayquydinh from MUONPHIM where STTTAP = @ma)
go
select * from dbo.uf_layphim(1) a join MUONPHIM p on a.SONGAYQUYDINH > p.STTTAP