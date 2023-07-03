/*
    뷰(VIEW)
    - SELECT 문을 저장할 수 있는 객체 (개꿀??!??!!!)
    - 가상 테이블 (실제로 데이터가 담겨있진 않음 => 논리적인 테이블)
    - DML (INSERT, UPDATE, DELETE) 작업 가능 ~~~~ (단,!!! 일부만 !!! 전부 다 되는건 아님)
    
    * 사용 목적
    - 편리성 : SELECT 문의 복잡도 완화 
    - 보안성 : 테이블의 특정 열을 노출 하고 싶지 않은 경우    
    
    
    
*/

-- 한국에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID  = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE NATIONAL_NAME LIKE '%한국%';


-- 러시아에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID  = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE NATIONAL_NAME LIKE '%러시아%';


-- 일본에서 근무하는 사원들의 사번, 이름, 부서명, 급여, 국가명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
JOIN LOCATION L ON D.LOCATION_ID  = L.LOCAL_CODE
JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE
WHERE NATIONAL_NAME LIKE '%일본%';


/*
    1. VIEW 생성 방법
    
    [표현식]
    CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰명
    AS 서브쿼리
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    * VIEW 옵션들..
    - OR REPLACE : 뷰 생성시 기존에 중복된 이름의 뷰가 없다면 새롭게 뷰를 생성하고, 중복된 뷰가 있으면 해당 뷰를 변경(갱신)하는 옵션
    - FORCE : 서브쿼리에 기술된 테이블이 존재 하지 않더라도 뷰가 생성됨
    - NOFORCE : 서브쿼리에 기술된 테이블이 존재해야지만 뷰가 생성된다. (기본 DEFAULT)
    - WITH CHECK OPTION : 서브쿼리에 기술된 조건에 부합하지 않는 값으로 수정하는 경우 오류를 발생시킨다.
    - WITH READ ONLY : 뷰에 대해 조회만 가능함 ()
    
*/

GRANT CREATE VIEW TO KH;

-- VIEW 생성
CREATE OR REPLACE VIEW VW_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY, NATIONAL_NAME
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
    JOIN LOCATION L ON D.LOCATION_ID  = L.LOCAL_CODE
    JOIN NATIONAL N ON L.NATIONAL_CODE = N.NATIONAL_CODE;

-- 가상의 테이블로 실제 데이터가 담겨있는 것은 아님!
SELECT * FROM VW_EMPLOYEE;

-- 참고 : 접속한 계정이 가지고 있는 VIEW에대한 정보를 조회하는 뷰 테이블
SELECT * FROM USER_VIEWS;


-- '한국' ,'러시아', '일본' 에서 근무하는 사원 사번, 이름, 부서명, 급여, 근무국가명 조회
SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME IN ('한국');

SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME IN ('러시아');

SELECT * FROM VW_EMPLOYEE
WHERE NATIONAL_NAME IN ('일본');


/*
    VIEW 컬럼에 별칭 부여
    - 서브 쿼리의 SELECT 절에 함수 식이나 산술 연산식이 기술되어 있으면, 반드시 별칭 지정해야함.~~

*/


-- 사원의 사번, 사원명, 직급명, 성별(남/여), 근무년수 조회
-- 할 수 있는 SELECT 문을 뷰(VW_EMP_JOB)으로 정의
-- 1)) 서브쿼리에 별칭 부여 하는 방법
CREATE OR REPLACE VIEW VW_EMP_JOB AS
SELECT EMP_ID,
EMP_NAME,
JOB_NAME, 
CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남'
     WHEN SUBSTR(EMP_NO,8 , 1) = 2 THEN '여' 
     END AS "성별",
     -- DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여'),
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) AS "근무 년수"
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);
DROP VIEW VW_EMP_JOB;
-- 2)) 뷰 생성 시 모든 컬럼에 별칭 부여 하는 방법
CREATE OR REPLACE VIEW VW_EMP_JOB("사번","사원명","직급명","성별","근무년수") AS
SELECT EMP_ID,
EMP_NAME,
JOB_NAME, 
CASE WHEN SUBSTR(EMP_NO, 8, 1) = 1 THEN '남'
     WHEN SUBSTR(EMP_NO,8 , 1) = 2 THEN '여' 
     END AS,
     -- DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여'),
EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) 
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);


SELECT * FROM VW_EMP_JOB;


-- 성별이 남자인 사원의 사원명과 직급명 조회
SELECT 사원명, 직급명
FROM VW_EMP_JOB;

-- 근무 년수 20년 이상인 사원 조회
SELECT 사원명, 근무년수
FROM VW_EMP_JOB
WHERE 근무년수 >= 20;


/*
    VIEW를 이용해서 DML(INSERT, UPDATE, DELETE)사용가능함
    - 뷰를 통해서 조작하게 되면, 실제 데이터가 담겨있는 베이스 테이블에 반영이 됨.
*/

CREATE OR REPLACE VIEW VW_JOB
AS SELECT JOB_CODE, JOB_NAME FROM JOB;

-- 뷰로 인서트
INSERT INTO VW_JOB VALUES ('J8', '인턴');

-- 뷰로 업데이트
UPDATE VW_JOB
SET JOB_NAME = '알바'
WHERE JOB_CODE = 'J8';

-- 뷰로 딜리트
DELETE VW_JOB
WHERE JOB_CODE = 'J8';

DROP VIEW VW_JOB;
/*
    DML 구문으로 VIEW 조작이 불가능한 경우
    1. 뷰 정의에 포함되지 않는 컬럼을 조작하는 경우
    2. 뷰에 포함되지 않는 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약 조건이 지정된 경우
    3. 산술표현식 또는 함수식으로 정의된 경우
    4. 그룹함수나 GROUP BY 절을 포함한 경우
    5. DISTINCT 구문이 포함된 경우
    6. JOIN을 이용해서 여러 테이블을 연결한 경우
*/
-- 1. 뷰 정의에 포함되지 않는 컬럼을 조작하는 경우
CREATE OR REPLACE VIEW VW_JOB AS
SELECT JOB_CODE
FROM JOB;

INSERT INTO VW_JOB VALUES('J8','인턴');       -- ERROR 
INSERT INTO VW_JOB VALUES('J8');             
UPDATE VW_JOB SET JOB_NAME = '인턴' WHERE JOB_CODE = 'J7';            -- ERROR
UPDATE VW_JOB SET JOB_CODE = 'J0' WHERE JOB_CODE = 'J8';
DELETE FROM VW_JOB WHERE JOB_NAME = '사원';               -- ERROR
DELETE FROM VW_JOB WHERE JOB_CODE = 'J0';
DROP VIEW VW_JOB;


-- 2. 뷰에 포함되지 않는 컬럼 중에 베이스가 되는 컬럼이 NOT NULL 제약 조건이 지정된 경우
CREATE OR REPLACE VIEW VW_JOB AS
SELECT JOB_NAME FROM JOB;

INSERT INTO VW_JOB VALUES('인턴');            -- ERROR
UPDATE VW_JOB SET JOB_NAME = '알바' WHERE JOB_NAME IN ('사원');
ROLLBACK;

DELETE VW_JOB WHERE JOB_NAME IN ('사원');
ROLLBACK;

SELECT * FROM VW_JOB; -- 논리적인 테이블 (실질적인 데이터 담겨있지 않음)
SELECT * FROM JOB;  -- 베이스 테이블 (실제 데이터 담겨있음)

DROP VIEW VW_JOB;
-- 3. 산술표현식 또는 함수식으로 정의된 경우
CREATE OR REPLACE VIEW VW_EMP_SAL AS
SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 "연봉"
FROM EMPLOYEE;

INSERT INTO VW_EMP_SAL VALUES(400,'홍길동',3000000, 36000000);     -- ERROR 산술연산으로 정의된 컬럼에 데이터 삽입 X
INSERT INTO VW_EMP_SAL(EMP_ID, EMP_NAME, SALARY) VALUES(400,'홍길동', 3000000);        -- ERROR EMPLOYEE 에 있는 EMP_NO가 NOT NULL 제약조건에 걸려서 ㅠ
-- 위 에러 같은 경우 아예 EMPLOYEE 의 EMP_NO에 걸려있는 제약조건을 NULL받을 수 있게 바꿔주면 삽입 가능함 !
UPDATE VW_EMP_SAL SET 연봉 = 80000000 WHERE EMP_ID = 200;     -- ERROR 연봉 컬럼의 경우 산술 표현 컬럼이기 때문에 UPDATE X
UPDATE VW_EMP_SAL SET SALARY = 7000000 WHERE EMP_ID = 200;
ALTER TABLE EMPLOYEE  MODIFY EMP_NO NULL;
DELETE FROM VW_EMP_SAL WHERE 연봉 = 72000000;

ROLLBACK;
SELECT * FROM VW_EMP_SAL;
SELECT * FROM EMPLOYEE;

-- 4. 그룹함수나 GROUP BY 절을 포함한 경우
-- 부서별 급여의 합계, 평균 조회
CREATE OR REPLACE VIEW VW_GROUPDEPT AS
SELECT DEPT_CODE "부서코드", 
COUNT(NVL(DEPT_CODE, 1)) "부서별인원", 
SUM(SALARY) "합계", 
FLOOR(AVG(NVL(SALARY,0))) "평균"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 그룹함수로 묶은 테이블의 경우에는 .. DML사용 불가!
INSERT INTO VW_GROUPDEPT VALUES('D3', 2 ,8000000, 4000000);     -- ERROR 가상열 사용 불가 ~
UPDATE VW_GROUPDEPT SET 합계 = 8000000 WHERE 부서코드 = 'D1';     -- ERROR
DELETE FROM VW_GROUPDEPT WHERE 합계 =  5210000;                   -- ERROR

DROP VIEW VW_GROUPDEPT;
SELECT * FROM VW_GROUPDEPT;

-- 5. DISTINCT 구문이 포함된 경우
CREATE OR REPLACE VIEW VW_DT_JOB AS
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

SELECT * FROM VW_DT_JOB;

INSERT INTO VW_DT_JOB VALUES ('J8');                        -- ERROR
UPDATE VW_DT_JOB SET JOB_CODE = 'J8' WHERE JOB_CODE = 'J7'; -- ERROR
DELETE FROM VW_DT_JOB WHERE JOB_CODE = 'J7';                -- ERROR







