select
S_Dept.sname as 部门名称,
case
when bs_class.nNormalCount <= 5 then 'VIP'
when bs_class.nNormalCount > 5 then '班级'
end as 班级类型,
count ( distinct bs_roster.sstudentcode ) as 在读人数

from
bs_class
left join
BS_ClassType ON BS_Class.classtype_code  = BS_ClassType.sCode

left join
BS_Project ON BS_ClassType.sProjectCode = BS_Project.sCode

left join
S_Dept ON BS_Project.sDeptCode = S_Dept.sCode

left join
bs_roster on bs_class.scode = bs_roster.sclasscode

left join
bs_lesson on bs_class.scode = bs_lesson.sclasscode

LEFT JOIN
BS_Room ON BS_Room.sCode = BS_Class.sRoomCode

LEFT JOIN
BS_Area ON BS_Area.sCode = BS_Room.sAreaCode


where
trunc(bs_lesson.dtdate) = TO_DATE('2016-10-26','YYYY-MM-DD')
and
bs_lesson.sRoomCode is not null
and
bs_lesson.sTeacherCode is not null
and
(
S_Dept.sname like '%北美%'
or
S_Dept.sname like '%英联邦%'
)
and
BS_Area.sname not like '%合作%'


group by
s_dept.sname,
bs_class.nNormalCount
