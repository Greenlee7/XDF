WITH T AS
(
  SELECT
  CASE
    WHEN BS_Lesson.dtDate >= TO_DATE('2018-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2018-08-31','YYYY-MM-DD') THEN 'FY19'
    WHEN BS_Lesson.dtDate >= TO_DATE('2017-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2017-08-31','YYYY-MM-DD') THEN 'FY18'
    WHEN BS_Lesson.dtDate >= TO_DATE('2016-06-01','YYYY-MM-DD') AND BS_Lesson.dtDate <= TO_DATE('2016-08-31','YYYY-MM-DD') THEN 'FY17'
  END AS 时间,
  CASE
    WHEN S_Dept.sName = '英语学习部' THEN '国内考试部'
    ELSE to_char(S_Dept.sName)
  END AS 部门名称,
  BS_Lesson.sClassCode AS 班级编码,
  BS_Lesson.sTeacherCode AS 教师编码,
  BS_Lesson.sRoomCode AS 教室编码,
  to_char(BS_Lesson.dtDate,'YYYY-MM-DD') AS 上课日期,
  round(to_number(BS_Lesson.nMinute*1.0/60),2) AS 小时数,
  BS_Class.nCurrentCount AS 当前人数,
  CASE
    WHEN BS_Class.nNormalCount >= 6 THEN '班课'
    WHEN BS_Class.nNormalCount < 6 THEN 'VIP'
    ELSE to_char(BS_Class.bVIP)
  END AS 班级类型
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
    T.时间, T.部门名称, T.班级编码,T.当前人数
  FROM T
)
SELECT A1.时间, A1.部门名称, SUM(A1.当前人次) AS 在读人次
FROM A1
GROUP BY A1.时间, A1.部门名称
