
create proc spInsertLeaveException
@ExceptionDate date,
@Remarks nvarchar(50)
as
begin
	Insert into tblExceptions(ExceptionDate,Remarks)values(@ExceptionDate,@Remarks)
end

go

create proc spDeleteLeaveException
@ExceptionID int
as
begin
	delete from tblExceptions where ExceptionID=@ExceptionID
end

go

alter proc spGetLeaveExceptionList
as
begin
	select ExceptionID,convert(nvarchar,ExceptionDate,106) as ExceptionDate,Remarks from tblExceptions order by ExceptionDate desc;
end

go

select * from tblCompensatoryLeave;

GO

create proc spInsertCompensatoryLeave
@CompensatoryDate date,
@Remarks nvarchar(50)
as
begin
	insert into tblCompensatoryLeave(CompensatoryDate,Remarks)values(@CompensatoryDate,@Remarks);
end

go

create proc spDeleteCompensatoryLeave
@CompensatoryLeaveID int
as
begin
	delete from tblCompensatoryLeave where CompensatoryLeaveID = @CompensatoryLeaveID;
end

GO

create proc spGetCompensatoryLeaveList
as
begin
	select CompensatoryLeaveID,convert(nvarchar,CompensatoryDate,106) as CompensatoryDate,Remarks
	from tblCompensatoryLeave order by CompensatoryDate desc;
end