select
scode as �༶����,
sname as �༶����,
ncurrentcount as ��ǰ����,
scourseconsultant as �γ̹���,
sclasssubject as ��Ŀ,
squarter as ����,
bcontinuedclass as �Ƿ�����,
sareacode as ��ѧ��,
dtbegindate as ��������,
dtenddate as �������,
sprinttime as �Ͽ�ʱ��,
nlesson as �δ�,
nnormalcount as ��������,
nmaxcount as �������,
dfee as ѧ��,
smanagementcode as ������
from bs_class
where
dtbegindate >= to_date('2018-05-01','yyyy-mm-dd')
and
dtbegindate <= to_date('2018-05-28','yyyy-mm-dd')
