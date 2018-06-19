WITH T AS
(
  SELECT
  CASE
    WHEN BS_Lesson.dtDate >= TO_DATE('2018-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2018-08-31','YYYY-MM-DD') THEN 'FY19'
    WHEN BS_Lesson.dtDate >= TO_DATE('2017-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2017-08-31','YYYY-MM-DD') THEN 'FY18'
    WHEN BS_Lesson.dtDate >= TO_DATE('2016-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2016-08-31','YYYY-MM-DD') THEN 'FY17'
  END AS ʱ��,
  CASE
    WHEN S_Dept.sName = 'Ӣ��ѧϰ��' THEN '���ڿ��Բ�'
    ELSE to_char(S_Dept.sName)
  END AS ��������,
  BS_Lesson.sClassCode AS �༶����,
  BS_Lesson.sTeacherCode AS ��ʦ����,
  BS_Lesson.sRoomCode AS ���ұ���,
  to_char(BS_Lesson.dtDate,'YYYY-MM-DD') AS �Ͽ�����,
  round(to_number(BS_Lesson.nMinute*1.0/60),2) AS Сʱ��,
  BS_Class.nCurrentCount AS ��ǰ����,
  CASE
    WHEN BS_Class.nNormalCount >= 6 THEN '���'
    WHEN BS_Class.nNormalCount < 6 THEN 'VIP'
    ELSE to_char(BS_Class.bVIP)
  END AS �༶����
  FROM
  BS_Lesson
  LEFT JOIN BS_Class ON BS_Class.sCode = BS_Lesson.sClassCode
  LEFT JOIN BS_ClassType ON BS_ClassType.sCode = BS_Class.CLASSTYPE_CODE
  LEFT JOIN BS_Project ON BS_Project.sCode = BS_ClassType.sProjectCode
  LEFT JOIN S_Dept ON S_Dept.sCode = BS_Project.sProjectCode
  WHERE
  (
    (WHEN BS_Lesson.dtDate >= TO_DATE('2018-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2018-08-31','YYYY-MM-DD') THEN 'FY19')
    OR
    (WHEN BS_Lesson.dtDate >= TO_DATE('2017-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2017-08-31','YYYY-MM-DD') THEN 'FY18')
    OR
    (WHEN BS_Lesson.dtDate >= TO_DATE('2016-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2016-08-31','YYYY-MM-DD') THEN 'FY17')
    AND BS_Lesson.sRoomCode IS NOT NULL
    AND BS_Lesson.sTeacherCode IS NOT NULL
  )
),
A1 AS(
  SELECT DISTINCT
    T.ʱ��, T.��������, T.�༶����,T.��ǰ����
  FROM T
)
SELECT A1.ʱ��, A1.��������, SUM(A1.��ǰ�˴�) AS �ڶ��˴�
FROM A1
GROUP BY A1.ʱ��, A1.��������
