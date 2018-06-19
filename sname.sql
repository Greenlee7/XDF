select
bs_class.sname as 班级名称,
bs_class.scode as 班级编码,
bs_class.dtbegindate as 开课日期,
bs_class.dtenddate as 结课日期
from bs_class
where
bs_class.dtbegindate >= to_date('2018-05-01','yyyy-mm-dd')
and
bs_class.dtbegindate <= to_date('2018-05-27','yyyy-mm-dd')
