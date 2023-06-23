-- 1. 영어영문학과(학과코드 002) 학생의 학번,이름,입학년도를 입학년도 빠른 순으로 정렬하는 sql
SELECT 
    STUDENT_NO "학번", STUDENT_NAME "이름", ENTRANCE_DATE "입학년도"
FROM TB_STUDENT
WHERE DEPARTMENT_NO != 002
ORDER BY ENTRANCE_DATE;


-- 2. 교수 중 이름이 세글자가 아닌 교수가 한 명 있는데, 그 교수의 이름과 주민번호를 화면에 출력하는 SQL
SELECT PROFESSOR_NAME, PROFESSOR_SSN
FROM TB_PROFESSOR
WHERE LENGTH(PROFESSOR_NAME) != 3;



-- 3. 남자 교수들의 이름과 나이를 출력하는 SQL문 (단, 나이를 오름차순 정렬)
SELECT PROFESSOR_NAME, FLOOR(MONTHS_BETWEEN(SYSDATE, '19'||SUBSTR(PROFESSOR_SSN,0,6))/12)"나이"
FROM TB_PROFESSOR
WHERE SUBSTR(PROFESSOR_SSN,8,1) = 1
ORDER BY SUBSTR(PROFESSOR_SSN,0,6) DESC;



-- 4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL문장을 작성하쇼 (단, 성이 2글자 이상인 교수는 없!)
SELECT 
    SUBSTR(PROFESSOR_NAME, 2)
FROM TB_PROFESSOR;



-- 5. 재주생 입학자 구하려고 하는데, 어떻게 찾으실? 19살에 입학하면 재수 하지 않은것으로 간주함
-- 주민앞자리 + 19 하면  원래 재수 안한 학번임**
SELECT STUDENT_NAME,STUDENT_SSN, ENTRANCE_DATE,
to_char(to_date(ENTRANCE_DATE), 'RRRR') - to_char(to_date(substr(STUDENT_SSN,1,6)),'RRRR')"입학년도 - 태어난년도"
FROM TB_STUDENT
WHERE
to_char(to_date(ENTRANCE_DATE), 'RRRR') - to_char(to_date(substr(STUDENT_SSN,1,6)),'RRRR') > 19;


-- 6. 2020년 크리스마스는 무슨 요일인가
select to_char(to_date('2020/12/25'),'day')
from dual;


-- 7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/NN/DD')은 각 몇년 몇월 몇일?
--    TO_DATE('99/10/11','RR/MM/DD'), TO_DATE('99/10/11','RR/MM/DD')
SELECT
TO_CHAR(TO_DATE('99/10/11'),'YYYY/MM/DD'), 
TO_CHAR(TO_DATE('49/10/11'),'YYYY/MM/DD'),
TO_CHAR(TO_DATE('99/10/11'),'RRRR/MM/DD'), 
TO_CHAR(TO_DATE('49/10/11'),'RRRR/MM/DD')
FROM DUAL;


-- 8. 춘 기술대학교의 2000년도 이후 입학자들은 학번이 A로 시작하게 되어있다.
--      2000년도 이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오

SELECT
STUDENT_NO, STUDENT_NAME
FROM TB_STUDENT
WHERE INSTR(STUDENT_NO, 'A') > 0;
--WHERE STUDENT_NO LIKE '%A%';


-- 9.  학번이 A517178인 한아름 학생의 학점 총 평점을 구하는 SQL문을 작성하시오.
-- 단, 이때 출력 화면의 헤더는 “평점”이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한 자리까지만 표시한다.
SELECT 
AVG(NVL(POINT, 0))
FROM TB_GRADE
WHERE STUDENT_NO = 'A517178';


-- 10. 학과별 학생수를 구하여 “학과번호”, “학생수” 의 형태로 헤더를 만들어 결과값이 출력되도록하시오
SELECT DEPARTMENT_NO"학과번호", COUNT(DEPARTMENT_NO)"학생수"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

-- 11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는지 알아내는 SQL 문을 작성하시오
SELECT  
COUNT(CASE WHEN COACH_PROFESSOR_NO IS NULL THEN 'NULL' END)
FROM TB_STUDENT;


-- 12. 학번이 A112113인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 
--    단, 이때 출력 화면의 헤더는 “년도”, “년도 별 평점” 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하 한자리까지만
SELECT 
SUBSTR(TERM_NO,1,4) "년도", ROUND(AVG(POINT),1) "평균"
FROM TB_GRADE
GROUP BY SUBSTR(TERM_NO,1,4), STUDENT_NO
HAVING STUDENT_NO = 'A112113'
ORDER BY SUBSTR(TERM_NO,1,4);


-- 13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을 작성하시오
SELECT DEPARTMENT_NO 학과코드, count(absence_yn)
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO,ABSENCE_YN
HAVING ABSENCE_YN = 'Y'
order by department_no;

SELECT DEPARTMENT_NO 학과코드, count(CASE WHEN absence_yn = 'Y' THEN 1 ELSE NULL END)
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO
order by department_no;
