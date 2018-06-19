select
scode as 班级编码,
sname as 班级名称,
ncurrentcount as 当前人数,
scourseconsultant as 课程顾问,
sclasssubject as 科目,
squarter as 季度,
bcontinuedclass as 是否续班,
sareacode as 教学区,
dtbegindate as 开课日期,
dtenddate as 结课日期,
sprinttime as 上课时间,
nlesson as 课次,
nnormalcount as 正常人数,
nmaxcount as 最大人数,
dfee as 学费,
smanagementcode as 管理部门
from bs_class
where
dtbegindate >= to_date('2018-05-01','yyyy-mm-dd')
and
dtbegindate <= to_date('2018-05-28','yyyy-mm-dd')
