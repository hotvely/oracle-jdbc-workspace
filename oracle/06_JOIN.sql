/*
    JOIN
    - 두개 이상의 테이블에서 데이터를 조회하고자 할 때, 사용되는 구문
    - 조회 결과는 하나의 결과물 (RESULT SET)으로 나옴
    
    - 관계형 데이터 베이스는 최소한의 데이터로 각각의 테이블에 담고 있음
        (중복을 최소화 하기 위해 최대한 쪼개서 관리 -> 다양한 테이블로 나눠서 관리하는 것)
    그런데.. 만약 어떤 사람이 어떤 부서에 속해있는지 부서명과 같이 조회 하고 싶으면?
            만약 어떤 사람이 어떤 직급인지 직급명과 같이 조회 하고 싶으면?
        => 즉, JOIN은 관계형 데이터 베이스에서 SQL 문을 이용한 테이블간 "관계'를 맺어 원하는 데이터를 조회하는 방법이다.
            (크게 '오라클 구문'과 'ANSI' 두가지가 존재함)
            ANSI (미국 국립 표준 협회 == 산업표준을 제정하는 단체..) : 다른 DBMS에서도 사용 가능;
 */
 
 /*
    1. 오라클 : 등가조인(EQUAL JOIN) / ANSI : 내부조인 (INNER JOIN/ NATURAL JOIN)
    - 연결 시키는 컬럼의 값이 일치하는 행들만 조인되서 조회 (일치하는 값이 없으면 조회 X)
        1) 오라클 전용 구문
            SELECT 컬럼,컬럼,...,컬럼
            FROM 테이블1, 테이블2
            WHERE 테이블1.컬럼명 = 테이블2.컬럼명;
            
            - FROM 절에 조회하려고 하는 테이블들을 ,로 구분하여 나열함
            - WHERE 절에 매칭 시킬 컬럼명에 대한 조건 제시함
        
        2) ANSI 표준 구문
            SELECT 컬럼, 컬럼, ..., 컬럼
            FROM 테이블1
            JOIN 테이블2 ON (테이블1.컬럼명 = 테이블2.컬럼명);
        `   
            - FROM 절에서는 기준이 되는 테이블 기술
            - JOIN 절에서 같이 조회하는 테이블을 기술 후 매칭시킬 컬럼에대한 조건 기술 (USING OR ON)
            - 연결에 사용하려는 컬럼명이 같으면 ON대신에 USING 사용
 */
 -- 1) 연결할 두 컬럼 명이 다른 경우
 -- 사번 , 사원명, 부서코드, 부서명을 같이 조회;
 ------- 오라클 구문 -------
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
 FROM EMPLOYEE , DEPARTMENT 
 WHERE DEPT_CODE = DEPT_ID;
 
 ------- ANSI -------
 SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
 FROM EMPLOYEE 
 JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
 
 -- 2) 연결할 두 컬럼 명이 같은 경우
 -- 사번, 사원명, 직급코드, 직급명
 ------- 오라클 구문 -------
 -- 해결방법 : 테이블명 이용 OR 테이블에 별칭부여해서 이용
 SELECT 
     E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
 FROM EMPLOYEE E, JOB J
 WHERE E.JOB_CODE = J.JOB_CODE;
 
 ------- ANSI -------
 SELECT 
    E.EMP_ID, E.EMP_NAME, E.JOB_CODE, J.JOB_NAME
 FROM EMPLOYEE E
 JOIN JOB  J
 ON (E.JOB_CODE = J.JOB_CODE);
 --USING (JOB_CODE);            -- 이렇게 USING 을 사용하게 되면 SELECT 컬럼에 별칭을 사용할 수 없대; 안쓸래 그냥;
 
 
 -- 자연조인 (NATURAL JOIN) : 각 테이블 마다 동일한 컬럼이 한개만 존재할 경우
 SELECT 
    EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
 FROM EMPLOYEE
 NATURAL JOIN JOB;
 
 
 
-------PRACTICE-------
-- 직급이 대리인 사원의 사번, 이름, 직급명, 급여 조회
SELECT 
    EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE J.JOB_CODE = 'J6'
ORDER BY SALARY;

-- 1. 부서가 인사관리부인 사원들의 사번, 이름, 보너스 조회
SELECT
    EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE E.DEPT_CODE = 'D1';

-- 2. DEPARTMENT 와 LOCATION을 참고해서 전체부서의 부서코드, 부서명, 지역코드, 지역명 조회
SELECT
D.DEPT_ID, 
D.LOCATION_ID , 
L.LOCAL_CODE, 
L.LOCAL_NAME
FROM DEPARTMENT D
JOIN LOCATION L ON (D.LOCATION_ID = L.LOCAL_CODE);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE BONUS IS NOT NULL
ORDER BY BONUS;


-- 4. 부서가 총무부가 아닌 사원들의 사원명 급여조회
SELECT EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON (E.DEPT_CODE = D.DEPT_ID)
WHERE D.DEPT_ID != 'D9'
ORDER BY DEPT_ID, SALARY;


/*
    내부 JOIN
    2. 오라클 : 포괄 조인 / ANSI : 외부조인
    - 두 테이블 간 JOIN시 일치하지 않는 행도 포함시켜서 조회 가능
    - 단, 반드시! 기준이 되는 테이블(컬럼)을 지정해야함
        (LEFT, RIGHT, FULL, (+))
*/
-- 사원명, 부서명, 급여, 연봉조회
-- 부서 배치 안된 사원 2명 정도 조회 X (-> null 제외하고 조인한다는 의미)
select emp_name, dept_title, salary, salary * 12
from employee e
join department d on d.dept_id = e.dept_code;


-- 1) left [outer] join : 두테이블 중 왼쪽에 기술된 테이블 기준으로 join
-- 부서배치를 받지 않았던 2명의 사원 정도보 조회가 됨
------- ANSI -------
select emp_name, dept_title, salary, salary * 12
from employee e
left join department d on d.dept_id = e.dept_code;
------- ORACLE -------
select EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID(+);       -- 기준으로 삼고자하는 테이블 반대편 테이블 컬럼뒤에 (+) 붙임;; 아 불편하다아;; ㅋㅋ

-- 2) RIGHT [outer] join : 두테이블 중 오른쪽에 기술된 테이블 기준으로 join
------- ANSI -------
select emp_name, dept_title, salary, salary * 12
from employee e
RIGHT join department d on d.dept_id = e.dept_code;
------- ORACLE -------
select EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE(+) = D.DEPT_ID;

-- 3) FULL [outer] join : 두테이블 중 왼쪽,오른쪽 모두에 기술된 테이블 기준으로 join
------- ANSI -------
select emp_name, dept_title, salary, salary * 12
from employee e
FULL join department d on d.dept_id = e.dept_code;
------- ORACLE -------
-- 오라클 구문으로는 FULL JOIN 불가능 !!!!!!!!@@@@@@@@@@
--select EMP_NAME, DEPT_TITLE, SALARY, SALARY * 12
--FROM EMPLOYEE E, DEPARTMENT D
--WHERE E.DEPT_CODE(+) = D.DEPT_ID(+);



/*
    3. 비등가조인 (NON EQUAL JOIN) : 매칭시킬 컬럼에 대한 조건 작성시 '='(등호) 를 사용하지 않는 조인문
                                   값 의 범위에 포함되는 행들을 연결하는 방식, ANSI 구문은 JOIN ON만 사용가능(USING !X!)
*/
SELECT EMP_NAME ,SALARY
FROM EMPLOYEE;

SELECT SAL_LEVEL, MIN_SAL, MAX_SAL
FROM SAL_GRADE;
-- 사원명, 급여, 급여레벨
------- ANSI -------
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE
JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

------- ORACLE -------
SELECT EMP_NAME, SALARY, SAL_LEVEL
FROM EMPLOYEE, SAL_GRADE
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;


/*
    4, 자체 조인(SELF JOIN)
    - 같은 테이블을 다시 한번 조인하는 경우
*/
SELECT * FROM EMPLOYEE;
-- 사원사번, 사원명, 부서코드, 사수사번, 사수명, 사수부서코드
SELECT 
    직원.EMP_ID "ID", 
    직원.EMP_NAME "NAME",
    직원.DEPT_CODE "부서코드",
    사수.EMP_ID "사수사번", 
    사수.EMP_NAME "사수이름", 
    사수.DEPT_CODE "사수부서"
FROM EMPLOYEE 직원
LEFT JOIN EMPLOYEE 사수 ON 직원.MANAGER_ID = 사수.EMP_ID;



/*
    5, 카테시안곱(CARTESIAN PRODUCT) / 교차 조인(CROSS JOIN)
    - 조인되는 모든 테이블의 각 행들이 서로서로 모두 매핑된 데이터가 검색됨 (곱집합)
    - 두 테이블의 행들이 모두 곱해진 행들의 조합이 출력됨;;;;
            -> 방대한 데이터 출력으로 인한 과부하의 위험 있음 (잘써야댕 ㅠㅠ)
*/
------- ANSI -------
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;
------- ORACLE -------
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT;



/*
    6, 다중 JOIN
    - 여러 개의 테이블을 조인할때,
*/
-- 사번, 사원명, 부서명, 직급명 조회
------- ANSI ------
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID 
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE;

------- ORACLE -------
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE ,DEPARTMENT, JOB
WHERE DEPT_CODE = DEPT_ID AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 사번, 사원명, 부서명, 지역명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID
JOIN LOCATION ON LOCATION.LOCAL_CODE = DEPARTMENT.LOCATION_ID;


-- 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회
-- 모든 테이블 조인해야 할듯 ㅎ;
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, SAL_LEVEL
FROM EMPLOYEE E
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID
JOIN SAL_GRADE SG ON E.SALARY BETWEEN SG.MIN_SAL AND SG.MAX_SAL;


--1. 직급이 대리이면서 ASIA 지역에서 근무하는 직원들의 사번, 직원명, 직급명, 부서명, 근무지역, 급여를 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE JOB_NAME = '대리';
-- 2. 70년대생 이면서 여자이고, 성이 전 씨인 직원들의 직원명, 주민번호, 부서명, 직급명을 조회
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE INSTR(EMP_NAME, '전') > 0 AND SUBSTR(EMP_NO,8,1) = 2;

-- 3. 보너스를 받는 직원들의 직원명, 보너스, 연봉, 부서명, 근무지역을 조회
SELECT EMP_NAME, BONUS, SALARY * 12, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
LEFT JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
WHERE BONUS IS NOT NULL;
--    단, 부서 코드가 없는 사원도 출력될 수 있게 Outer JOIN 사용

-- 4. 한국과 일본에서 근무하는 직원들의 직원명, 부서명, 근무지역, 근무 국가를 조회
SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE NATIONAL_NAME = '한국' OR NATIONAL_NAME = '일본'
ORDER BY NATIONAL_NAME;


-- 5. 각 부서별 평균 급여를 조회하여 부서명, 평균 급여(정수 처리)를 조회
SELECT DEPT_TITLE, TO_CHAR(ROUND(AVG(NVL(SALARY, 0))),'999,999,999')
FROM EMPLOYEE E
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
GROUP BY DEPT_TITLE;

-- 6. 각 부서별 총 급여의 합이 1000만원 이상인 부서명, 급여의 합을 조회
SELECT DEPT_TITLE, TO_CHAR(SUM(SALARY), '999,999,999')
FROM EMPLOYEE E
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
GROUP BY D.DEPT_TITLE
HAVING SUM(SALARY) > 10000000;

-- 7. 사번, 직원명, 직급명, 급여 등급, 구분을 조회 이때 구분에 해당하는 값은 아래와 같이 조회 되도록 하시오.
--  급여 등급이 S1, S2인 경우 '고급'
--  급여 등급이 S3, S4인 경우 '중급'
--  급여 등급이 S5, S6인 경우 '초급'
SELECT EMP_ID, EMP_NAME, JOB_NAME,
CASE
    WHEN (SAL_LEVEL = 'S1' OR SAL_LEVEL = 'S2') THEN '고급'
    WHEN (SAL_LEVEL = 'S3' OR SAL_LEVEL = 'S4') THEN '중급'
    WHEN (SAL_LEVEL = 'S5' OR SAL_LEVEL = 'S6') THEN '초급' 
END
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
JOIN SAL_GRADE SG ON SALARY BETWEEN SG.MIN_SAL AND SG.MAX_SAL; 

-- 8. 보너스를 받지 않는 직원들 중 직급 코드가 J4 또는 J7인 직원들의 직원명, 직급명, 급여를 조회
SELECT EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E
JOIN JOB J ON E.JOB_CODE = J.JOB_CODE
WHERE J.JOB_CODE = 'J4' OR J.JOB_CODE = 'J7';

-- 9. 부서가 있는 직원들의 직원명, 직급명, 부서명, 근무 지역을 조회
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE E
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID;

-- 10. 해외영업팀에 근무하는 직원들의 직원명, 직급명, 부서 코드, 부서명을 조회
SELECT EMP_NAME, JOB_NAME, DEPT_ID, DEPT_TITLE
FROM EMPLOYEE E
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
JOIN DEPARTMENT D ON D.DEPT_ID = E.DEPT_CODE
JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID
WHERE L.NATIONAL_CODE != 'KO' AND D.LOCATION_ID BETWEEN 'L2' AND 'L4';

-- 11. 이름에 '형'자가 들어있는 직원들의 사번, 직원명, 직급명을 조회
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON J.JOB_CODE = E.JOB_CODE
WHERE INSTR(EMP_NAME, '형') > 0;



