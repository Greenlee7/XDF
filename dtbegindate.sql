select
*
from bs_class
where
bs_class.dtbegindate >= to_date('2018-05-01','yyyy-mm-dd')
and
bs_class.dtbegindate <= to_date('2018-05-27','yyyy-mm-dd')
