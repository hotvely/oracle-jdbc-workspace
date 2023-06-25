-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 “학생 이름”, “주소지”로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
SELECT STUDENT_NAME "학생 이름", STUDENT_ADDRESS "주소지"
FROM TB_STUDENT
ORDER BY STUDENT_NAME;


-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT STUDENT_NAME, STUDENT_SSN
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
ORDER BY STUDENT_SSN DESC;


-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 
--    이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 “학생이름”, “학번”, “거주지 주소”가출력되도록 한다
SELECT STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS 거주지주소
FROM TB_STUDENT
WHERE  (STUDENT_ADDRESS LIKE ('%강원%') OR STUDENT_ADDRESS LIKE ('%경기%')) AND STUDENT_NO NOT LIKE '%A%'
ORDER BY STUDENT_NAME;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오. 
--    (법학과의 ‘학과코드’는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
SELECT PROFESSOR_NAME
FROM TB_PROFESSOR P
JOIN TB_DEPARTMENT D ON D.DEPARTMENT_NO = P.DEPARTMENT_NO
WHERE P.DEPARTMENT_NO = (SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME = '법학과')
ORDER BY PROFESSOR_SSN;


-- 5. 2004년 2학기에 ‘C3118100’ 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
SELECT STUDENT_NO 학번, POINT 학점
FROM TB_GRADE 
WHERE TERM_NO = 200402 AND CLASS_NO = 'C3118100'
ORDER BY POINT DESC, STUDENT_NO ASC;


-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
FROM TB_STUDENT TS
JOIN TB_DEPARTMENT TD ON TS.DEPARTMENT_NO = TD.DEPARTMENT_NO
ORDER BY STUDENT_NAME;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT CLASS_NAME , DEPARTMENT_NAME
FROM TB_CLASS TC
JOIN TB_DEPARTMENT TD ON TC.DEPARTMENT_NO = TD.DEPARTMENT_NO;


-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오
SELECT CLASS_NAME, PROFESSOR_NAME
FROM TB_CLASS TC
JOIN TB_CLASS_PROFESSOR TCP ON TC.CLASS_NO = TCP.CLASS_NO
JOIN TB_PROFESSOR TP ON TCP.PROFESSOR_NO = TP.PROFESSOR_NO;

-- 9. ‘음악학과’ 학생들의 평점을 구하려고 한다.
--    음악학과 학생들의 “학번”, “학생 이름”, “전체 평점”을 출력하는 SQL 문장을 작성하시오. 
--    단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
SELECT TS.student_no, TS.STUDENT_NAME, ROUND(AVG(POINT),1)
FROM TB_STUDENT TS
JOIN TB_GRADE TG ON TS.STUDENT_NO = TG.STUDENT_NO 
WHERE DEPARTMENT_NO = 059
GROUP BY TS.student_no, TS.STUDENT_NAME;

--10. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 
--학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을 작성하시오. 
--단, 출력헤더는 “학과이름”, “학생이름”, “지도교수이름”으로 출력되도록 한다.
SELECT DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름
FROM TB_STUDENT TS
JOIN TB_DEPARTMENT TB ON TB.DEPARTMENT_NO = TS.DEPARTMENT_NO
JOIN TB_PROFESSOR TP ON TS.COACH_PROFESSOR_NO = TP.PROFESSOR_NO
WHERE STUDENT_NO = 'A313047';


-- 11. 2007년도에 ‘인간관계론’ 과목 C2604100 을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오.
SELECT STUDENT_NAME, TERM_NO
FROM TB_STUDENT TS
JOIN TB_GRADE TG ON TG.STUDENT_NO = TS.STUDENT_NO
JOIN TB_CLASS TC ON TC.CLASS_NO = TG.CLASS_NO
WHERE TG.CLASS_NO = 'C2604100' AND TERM_NO LIKE '%2007%';


-- 12. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력
-- 아 어렵네 ㅋㅋ; 일단 방법이 몇개가 생각나긴 하는데.. 차집합으로 TB_CLASS_PROFESSOR에 없는 과목을 TB_CLASS에서 빼준 이후에 나오는 테이블로 작업을
-- 해도 될것 같기도 하고;

-- 아래 방법 처럼 그냥 조인시키면서 데이터 없는거 NULL로 밀어서 넣어버리고 NULL인 데이터를 조건으로 걸어서 출력해도 되는 것 같네; ㅠㅜㅠ
SELECT CLASS_NAME, DEPARTMENT_NAME
FROM TB_CLASS
LEFT JOIN TB_CLASS_PROFESSOR ON TB_CLASS_PROFESSOR.CLASS_NO = TB_CLASS.CLASS_NO
JOIN TB_DEPARTMENT ON TB_DEPARTMENT.DEPARTMENT_NO = TB_CLASS.DEPARTMENT_NO
WHERE TB_DEPARTMENT.CATEGORY = '예체능' AND TB_CLASS_PROFESSOR.PROFESSOR_NO IS NULL;


--13. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다.
--학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 “지도교수 미지정”으로 표시
--단, 출력헤더는 “학생이름”, “지도교수” 로 표시하며 고학번 학생이 먼저 표시되도록한다
SELECT STUDENT_NAME 학생이름, NVL2(COACH_PROFESSOR_NO, PROFESSOR_NAME ,'지도교수 미지정') 지도교수
FROM TB_STUDENT TS
LEFT JOIN TB_PROFESSOR TP ON TP.PROFESSOR_NO = TS.COACH_PROFESSOR_NO
WHERE TS.DEPARTMENT_NO = 020
ORDER BY ENTRANCE_DATE;


--14. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력
--단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
SELECT TB_STUDENT.STUDENT_NO "학번",
TB_STUDENT.STUDENT_NAME "이름",
TB_DEPARTMENT.DEPARTMENT_NAME "학과명",
ROUND(AVG(TB_GRADE.POINT),1) "평균"
FROM TB_GRADE
JOIN TB_STUDENT ON TB_STUDENT.STUDENT_NO = TB_GRADE.STUDENT_NO
JOIN TB_DEPARTMENT ON TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO
WHERE TB_STUDENT.ABSENCE_YN = 'N'
GROUP BY TB_STUDENT.STUDENT_NO, TB_STUDENT.STUDENT_NAME,TB_DEPARTMENT.DEPARTMENT_NAME
HAVING AVG(TB_GRADE.POINT) >= 4.0
ORDER BY TB_STUDENT.STUDENT_NO;


-- 15. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는코드 . 단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
SELECT TB_DEPARTMENT.DEPARTMENT_NAME, TB_CLASS.CLASS_NAME , ROUND(AVG(TB_GRADE.POINT),1)
FROM TB_GRADE
JOIN TB_CLASS ON TB_CLASS.CLASS_NO = TB_GRADE.CLASS_NO
JOIN TB_DEPARTMENT ON TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO
WHERE TB_DEPARTMENT.DEPARTMENT_NO = 034 AND TB_CLASS.CLASS_TYPE LIKE '%전공%'
GROUP BY TB_DEPARTMENT.DEPARTMENT_NAME, TB_GRADE.CLASS_NO,TB_CLASS.CLASS_NAME ;



-- 16. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문을 작성하시오.
--최경희 학생의 과 구하기
SELECT TB_STUDENT.STUDENT_NAME, TB_STUDENT.STUDENT_ADDRESS, TB_STUDENT.DEPARTMENT_NO
FROM TB_STUDENT
WHERE 
(SELECT TB_DEPARTMENT.DEPARTMENT_NO
FROM TB_DEPARTMENT
JOIN TB_STUDENT ON TB_STUDENT.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO 
WHERE TB_STUDENT.STUDENT_NAME LIKE '%최경희%') = TB_STUDENT.DEPARTMENT_NO;

--17. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오.
-- 학생별로.. 평균 점수 구해!

-- 아 짱나네 ㅈ닌짜
select 
tb_grade.student_no, 
avg(point),
tb_student.student_name,
tb_student.department_no

from tb_grade
join tb_student on tb_student.student_no = tb_grade.student_no
where tb_student.department_no = 001
group by tb_grade.student_no, tb_student.student_name,tb_student.department_no

having avg(point) = (select max(avg(point)) 
from tb_grade 
join tb_student on tb_student.student_no = tb_grade.student_no
where tb_student.department_no = 001 
group by tb_grade.student_no);












