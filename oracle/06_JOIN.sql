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











