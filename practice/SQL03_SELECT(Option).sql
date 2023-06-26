-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 “학생 이름”, “주소지”로 하고, 정렬은 이름으로 오름차순 표시하도록 한다.
select STUDENT_NAME "학생 이름", STUDENT_ADDRESS "주소지"
from TB_STUDENT
order by STUDENT_NAME;


-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
select STUDENT_NAME, STUDENT_SSN
from TB_STUDENT
where ABSENCE_YN = 'Y'
order by STUDENT_SSN desc;


-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번, 주소를 
--    이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 “학생이름”, “학번”, “거주지 주소”가출력되도록 한다
select STUDENT_NAME 학생이름, STUDENT_NO 학번, STUDENT_ADDRESS 거주지주소
from TB_STUDENT
where  (STUDENT_ADDRESS like ('%강원%') or STUDENT_ADDRESS like ('%경기%')) and STUDENT_NO not like '%A%'
order by STUDENT_NAME;

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 작성하시오. 
--    (법학과의 ‘학과코드’는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 내도록 하자)
select PROFESSOR_NAME
from TB_PROFESSOR p
join TB_DEPARTMENT d on d.DEPARTMENT_NO = p.DEPARTMENT_NO
where p.DEPARTMENT_NO = (select DEPARTMENT_NO from TB_DEPARTMENT where DEPARTMENT_NAME = '법학과')
order by PROFESSOR_SSN;


-- 5. 2004년 2학기에 ‘C3118100’ 과목을 수강한 학생들의 학점을 조회하려고 한다. 
--학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 작성해보시오.
select STUDENT_NO 학번, point 학점
from TB_GRADE 
where TERM_NO = 200402 and CLASS_NO = 'C3118100'
order by point desc, STUDENT_NO asc;


-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 문을 작성하시오.
select STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
from TB_STUDENT TS
join TB_DEPARTMENT TD on TS.DEPARTMENT_NO = TD.DEPARTMENT_NO
order by STUDENT_NAME;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
select CLASS_NAME , DEPARTMENT_NAME
from TB_CLASS tc
join TB_DEPARTMENT TD on tc.DEPARTMENT_NO = TD.DEPARTMENT_NO;


-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오
select CLASS_NAME, PROFESSOR_NAME
from TB_CLASS tc
join TB_CLASS_PROFESSOR TCP on tc.CLASS_NO = TCP.CLASS_NO
join TB_PROFESSOR TP on TCP.PROFESSOR_NO = TP.PROFESSOR_NO;

-- 9. ‘음악학과’ 학생들의 평점을 구하려고 한다.
--    음악학과 학생들의 “학번”, “학생 이름”, “전체 평점”을 출력하는 SQL 문장을 작성하시오. 
--    단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
select TS.STUDENT_NO, TS.STUDENT_NAME, ROUND(avg(point),1)
from TB_STUDENT TS
join TB_GRADE TG on TS.STUDENT_NO = TG.STUDENT_NO 
where DEPARTMENT_NO = 059
group by TS.STUDENT_NO, TS.STUDENT_NAME;

--10. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 위한 
--학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을 작성하시오. 
--단, 출력헤더는 “학과이름”, “학생이름”, “지도교수이름”으로 출력되도록 한다.
select DEPARTMENT_NAME 학과이름, STUDENT_NAME 학생이름, PROFESSOR_NAME 지도교수이름
from TB_STUDENT TS
join TB_DEPARTMENT tb on tb.DEPARTMENT_NO = TS.DEPARTMENT_NO
join TB_PROFESSOR TP on TS.COACH_PROFESSOR_NO = TP.PROFESSOR_NO
where STUDENT_NO = 'A313047';


-- 11. 2007년도에 ‘인간관계론’ 과목 C2604100 을 수강한 학생을 찾아 학생이름과 수강학기를 표시하는 SQL 문장을 작성하시오.
select STUDENT_NAME, TERM_NO
from TB_STUDENT TS
join TB_GRADE TG on TG.STUDENT_NO = TS.STUDENT_NO
join TB_CLASS tc on tc.CLASS_NO = TG.CLASS_NO
where TG.CLASS_NO = 'C2604100' and TERM_NO like '%2007%';


-- 12. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 이름과 학과 이름을 출력
-- 아 어렵네 ㅋㅋ; 일단 방법이 몇개가 생각나긴 하는데.. 차집합으로 TB_CLASS_PROFESSOR에 없는 과목을 TB_CLASS에서 빼준 이후에 나오는 테이블로 작업을
-- 해도 될것 같기도 하고;

-- 아래 방법 처럼 그냥 조인시키면서 데이터 없는거 NULL로 밀어서 넣어버리고 NULL인 데이터를 조건으로 걸어서 출력해도 되는 것 같네; ㅠㅜㅠ
select CLASS_NAME, DEPARTMENT_NAME
from TB_CLASS
left join TB_CLASS_PROFESSOR on TB_CLASS_PROFESSOR.CLASS_NO = TB_CLASS.CLASS_NO
join TB_DEPARTMENT on TB_DEPARTMENT.DEPARTMENT_NO = TB_CLASS.DEPARTMENT_NO
where TB_DEPARTMENT.category = '예체능' and TB_CLASS_PROFESSOR.PROFESSOR_NO is null;


--13. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다.
--학생이름과 지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 “지도교수 미지정”으로 표시
--단, 출력헤더는 “학생이름”, “지도교수” 로 표시하며 고학번 학생이 먼저 표시되도록한다
select STUDENT_NAME 학생이름, NVL2(COACH_PROFESSOR_NO, PROFESSOR_NAME ,'지도교수 미지정') 지도교수
from TB_STUDENT TS
left join TB_PROFESSOR TP on TP.PROFESSOR_NO = TS.COACH_PROFESSOR_NO
where TS.DEPARTMENT_NO = 020
order by ENTRANCE_DATE;


--14. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 이름, 평점을 출력
--단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
select TB_STUDENT.STUDENT_NO "학번",
TB_STUDENT.STUDENT_NAME "이름",
TB_DEPARTMENT.DEPARTMENT_NAME "학과명",
ROUND(avg(TB_GRADE.point),1) "평균"
from TB_GRADE
join TB_STUDENT on TB_STUDENT.STUDENT_NO = TB_GRADE.STUDENT_NO
join TB_DEPARTMENT on TB_DEPARTMENT.DEPARTMENT_NO = TB_STUDENT.DEPARTMENT_NO
where TB_STUDENT.ABSENCE_YN = 'N'
group by TB_STUDENT.STUDENT_NO, TB_STUDENT.STUDENT_NAME,TB_DEPARTMENT.DEPARTMENT_NAME
having avg(TB_GRADE.point) >= 4.0
order by TB_STUDENT.STUDENT_NO;


-- 15. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는코드 . 단, 평점은 소수점 1자리까지만 반올림하여 표시한다.
select TB_DEPARTMENT.DEPARTMENT_NAME, TB_CLASS.CLASS_NAME , ROUND(avg(TB_GRADE.point),1)
from TB_GRADE
join TB_CLASS on TB_CLASS.CLASS_NO = TB_GRADE.CLASS_NO
join TB_DEPARTMENT on TB_CLASS.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO
where TB_DEPARTMENT.DEPARTMENT_NO = 034 and TB_CLASS.CLASS_TYPE like '%전공%'
group by TB_DEPARTMENT.DEPARTMENT_NAME, TB_GRADE.CLASS_NO,TB_CLASS.CLASS_NAME ;



-- 16. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 SQL문을 작성하시오.
--최경희 학생의 과 구하기
select TB_STUDENT.STUDENT_NAME, TB_STUDENT.STUDENT_ADDRESS, TB_STUDENT.DEPARTMENT_NO
from TB_STUDENT
where 
(select TB_DEPARTMENT.DEPARTMENT_NO
from TB_DEPARTMENT
join TB_STUDENT on TB_STUDENT.DEPARTMENT_NO = TB_DEPARTMENT.DEPARTMENT_NO 
where TB_STUDENT.STUDENT_NAME like '%최경희%') = TB_STUDENT.DEPARTMENT_NO;

--17. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 작성하시오.
-- 음.. 일단 국문학과 학생 그룹의 평균 점수 중에서 가장 큰 max값을 구하고... 그 점수를 학생들 평균 점수를 내서 국문학과 일 때..
-- 같은 평균 점수인 학생 정보를 뻄;; ...?!
-- 1
select 
TB_GRADE.STUDENT_NO, 
avg(point),
TB_STUDENT.STUDENT_NAME,
TB_STUDENT.DEPARTMENT_NO

from TB_GRADE
join TB_STUDENT on TB_STUDENT.STUDENT_NO = TB_GRADE.STUDENT_NO
where TB_STUDENT.DEPARTMENT_NO = 001
group by TB_GRADE.STUDENT_NO, TB_STUDENT.STUDENT_NAME,TB_STUDENT.DEPARTMENT_NO
having avg(point) = (select max(avg(point)) 
from TB_GRADE 
join TB_STUDENT on TB_STUDENT.STUDENT_NO = TB_GRADE.STUDENT_NO
where TB_STUDENT.DEPARTMENT_NO = 001 
group by TB_GRADE.STUDENT_NO);

-- 2
select STUDENT_NO, STUDENT_NAME
from TB_GRADE
join TB_STUDENT using(STUDENT_NO)
where DEPARTMENT_NO = 001
group by STUDENT_NO, STUDENT_NAME
having avg(point) = (select max(avg(point)) 
from TB_GRADE 
join TB_STUDENT using(STUDENT_NO)
where TB_STUDENT.DEPARTMENT_NO = 001
group by STUDENT_NO);



-- 18. 춘 기술대학교의 “환경조경학과”가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 파악하기 위한 적절한 SQL 문을 찾아내시오. 
--    단, 출력헤더는 “계열 학과명”, “전공평점”으로 표시되도록하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 한다

SELECT  DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT),1) "전공평점"
FROM TB_GRADE TG
JOIN TB_STUDENT TS ON TG.STUDENT_NO = TS.STUDENT_NO
JOIN TB_DEPARTMENT TD ON TD.DEPARTMENT_NO = TS.DEPARTMENT_NO
JOIN TB_CLASS TC ON TD.DEPARTMENT_NO = TC.DEPARTMENT_NO
WHERE CATEGORY = '자연과학' AND CLASS_TYPE LIKE '%전공%'
GROUP BY DEPARTMENT_NAME;







