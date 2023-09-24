WITH cte AS (
    SELECT 
        UserAttendanceID, 
        EmployeeID, 
        LogIndex, 
        LogTime, 
        ROW_NUMBER() OVER (
            PARTITION BY 
                EmployeeID, 
				LogIndex, 
				LogTime
            ORDER BY 
                EmployeeID, 
				LogIndex, 
				LogTime
        ) row_num
     FROM 
        tblUserAttendance
)

--select * from cte where LogTime >= '02/01/2022' and row_num > 1;

DELETE FROM cte WHERE row_num > 1;0 