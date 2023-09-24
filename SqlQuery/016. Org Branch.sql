Create proc spGetULCBranch
as
begin
	SELECT ULCBranchID,ULCBranchName FROM tblULCBranch
	where isActive =1 order by ULCBranchName 
end