WITH T AS (
  SELECT
        s_dept.sname as 部门,
  CASE
      WHEN bs_lesson.dtdate >= to_date('2018-05-01','yyyy-mm-dd') and bs_lesson.dtdate <= to_date('2018-05-31','yyyy-mm-dd') then '本周'
      WHEN bs_lesson.dtdate >= to_date('2017-05-01','yyyy-mm-dd') and bs_lesson.dtdate <= to_date('2017-05-31','yyyy-mm-dd') then '同期'
  END AS 时间,
  CASE
      WHEN s_dept.sname = '英语学习部' then '国内考试部'
      ELSE to_char(s_dept.sname)
  END AS 部门名称,
  bs_lesson.sclasscode as 班级编码,
  bs_lesson.steacherode as 教师编码,
  bs_lesson.sroomcode as 教室编码,
  to_char(bs_lesson.dtdate,'yyyy-mm-dd') as 上课日期,
  round(to_number(bs_lesson.nminute*1.0/60),2) as 小时数,
  bs_class.ncurrentcount as 当前人数,
  bs_class.bVIP as 班级类型,
  CASE
      WHEN bs_class.nnormalcount >= 6 then '班课',
      WHEN bs_class.nnormalcount < 6 then 'VIP',
      ELSE to_char(bs_class.bVIP)
  END AS 班级类型,
  bs_project.sname as 项目名称
  FROM bs_lesson
  LEFT JOIN bs_class ON bs_class.scode = bs_lesson.scode
  LEFT JOIN bs_classtype ON bs_class.classtype_code = bs_classtype.scode
  LEFT JOIN bs_project ON bs_project.scode = bs_classtype.sprojectcode
  LEFT JOIN s_dept ON s_dept.scode = bs_project.sdeptcode
  WHERE
  (
    (bs_lesson.dtdate >= to_date('2018-05-01','yyyy-mm-dd') and bs_lesson.dtdate <= to_date('2018-05-31','yyyy-mm-dd'))
    OR
    (bs_lesson.dtdate >= to_date('2017-05-01','yyyy-mm-dd') and bs_lesson.dtdate <= to_date('2017-05-31','yyyy-mm-dd'))
  )
  AND bs_lesson.sroomcode IS NOT NULL
  AND bs_lesson.steacherode IS NOT NULL
),
--在读人数--
A1 AS
(
  SELECT DISTINCT T.时间,T.部门名称,T.班级编码,T.班级类型,T.当前人数
  FROM T
),
A2 AS
(
  SELECT A1.时间,A1.部门名称,A1.班级类型,SUM(A1.当前人数) AS 在读人次
  FROM A1
  GROUP BY T.时间,T.部门名称
),
--课时--
B1 AS
(
  SELECT T.时间,T.部门名称,SUM(T.小时数) AS 课时数
  FROM T
  GROUP BY T.时间,T.部门名称
)
B2 AS
(
  SELECT T.时间,T.部门名称,COUNT(DISTINCT T.教室编码) AS 上课教师数
  FROM T
  GROUP BY T.时间,T.部门名称
),
B3 AS
(
  SELECT B1.时间,B1.部门名称,B1.课时数,B2.上课教师数,ROUND(B1.课时数/B2.上课教师数) AS 平均课时
  FROM B1
  LEFT JOIN B2 ON B1.时间 = B2.时间 AND B1.部门名称 = B2.部门名称
  GROUP BY B1.时间,B1.部门名称,B1.课时数,B2.上课教师数
  ORDER BY B1.时间,B1.部门名称
),
--一对一课消--
C1 AS
(
  SELECT T.时间,T.部门名称,SUM(T.小时数) AS 课时数
  FROM T
  WHERE T.班级编码 LIKE '%CLNB%'
  GROUP BY T.时间,T.部门名称
),
C2 AS
(
  SELECT T.时间,T.部门名称,COUNT(DISTINCT T.班级编码) AS 在读人次
  FROM T
  WHERE T.班级编码 LIKE '%CLNB%'
  GROUP BY T.时间,T.部门名称
),
C3 AS
(
  SELECT C1.时间,C1.部门名称,C1.课时数,C2.在读人次,ROUND(C1.课时数/C2.在读人次，2) AS 一对一课消
  FROM T1
  LEFT JOIN C2 ON C1.时间 = C2.时间 AND C1.部门名称 = C2.部门名称
  GROUP BY C1.时间, C1.部门名称, C1.课时数, C2.在读人次
  ORDER BY C1.时间, C1.部门名称
)
SELECT
B3.时间, B3.部门名称, B3.课时数 AS 总课时数, B3.上课教师数,C3.课时数 AS 一对一课时数, C3.在读人次, C3.一对一课消
FROM B3
LEFT JOIN C3 ON C3.时间 = B3.时间 AND C3.部门名称 = B3.部门名称
