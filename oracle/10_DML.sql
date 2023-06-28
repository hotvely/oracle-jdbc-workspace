CREATE TABLE EMP_01
(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30) NOT NULL,
    DEPT_TITLE VARCHAR2(30),
    HIRE_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT EMP_01_EMP_ID_PK PRIMARY KEY (EMP_ID)
);


/*
    DML(Data Manipulation Language) : 데이터 조작 언어로 테이블에 값을 삽입(INSERT),수정(UPDATE),삭제(DELETE)하는 구문
    
    1. INSERT : 테이블에 새로운 '행'을 추가하는 구문
        [표현법]
        1) INSERT INTO TABLE_NAME VALUES(VALUE1, VALUE2, VALUE3, .... ) 
            - 모든 컬럼에 대한 값을 추가 하려고 할때 (객체생성용..?)
            - 컬럼 순번을 지켜서 VALUES 값 나열해야함
        2) INSERT INTO TABLE_NAME (COLUMNS_NAME1, COLUMNS_NAME2, COLUMNS_NAME3, ...) (VALUE1, VALUE2, VALUE3, ....);
            - 특정 컬럼의 값만 추가하려고 할때 사용
            - 선택 안된 컬럼은 DEFAULT 값으로 NULL로 초기화 됨 (****단, NOT NULL 조건일 때에는 무조건 제시 해주어야 함)
            - 기본값(DEFAULT)이 지정되어 있으면 기본값으로 초기화 됨
        3) INSERT INTO TABLE_NAME (SubQuery);
            - VALUES 대신 서브쿼리도 조회한 결과값을 통째로 INSERT
            - 서브쿼리의 결과값이 INSERT 문에 지정된 테이블 컬럼의 개수와 데이터 타입이 같아야함.
    
    
    1-2. INSERT ALL : 다수의 테이블에 각각 INSERT 할때 동일한 서브쿼리가 사용되는 경우?! INSERT ALL로 여러테이블에 한번에 데이터 삽입 가능!
        [표현법]
        1) INSERT ALL INTO 테이블명1[(컬럼,컬럼,...)] VALUES(값,값,... )
                      INTO 테이블명2[(컬럼,컬럼,...)] VALUES(값,값,... )
                      서브쿼리;
        2) INSERT ALL WHEN 조건1 THEN INTO 테이블명1[(컬럼,컬럼,...)] VALUSE(값,값,...)
                      WHEN 조건2 THEN INTO 테이블명2[(컬럼,컬럼,...)] VALUSE(값,값,...)
                      서브쿼리;


    2. UPDATE : 테이블에 기록된 데이터를 수정하는 구문
        [표현법]
        UPDATE 테이블명
        SET 컬럼명 = 변경하려는값 or 서브쿼리,
            컬럼명 = 변경하려는값 or 서브쿼리,
            ...
        [WHERE 조건];
        
        - SET 절에서 여러개의 컬럼을 콤마(,)로 나열해서 값을 동시에 변경할 수 있다.
        - WHERE 절을 생략하면 모든 행의 데이터가 변경됨
        - 서브쿼리를 사용해서 결과값으로 컬럼 값을 변경 할 수 있다
    
    
    3. DELETE : 테이블에 기록된 데이터를 삭제하는 구문 (행단위 삭제)
        [표현법]
        DELETE FROM 테이블명
        [WHERE 조건식];
        
        - WHERE 절을 제시하지 않으면 전체 행이 삭제.
    
    
    4. TRUNCATE : 테이블의 전체 행을 삭제할 때 사용하는 구문
        - DELETE 보다 수행 속도가 더 빠르다.
        - 별도의 조건 제시가 되지 않고, 롤백안됨~
        [표현법]
        TRUNCATE TABLE TABLE명
*/

----------------------------------------1 INSERT
-------------1-1 표현법
INSERT INTO EMP_01
VALUES(100, '이정재', '서비스 개발팀',DEFAULT);

INSERT INTO EMP_01
VALUES (200,'이병헌','개발지원팀');         -- ERROR : 모든 컬럼에 값지정 하지 않아서 에러 

INSERT INTO EMP_01
VALUES (300, '유아지원팀','공유', DEFAULT);    -- 넣어지기는 함. 단, 이름과 부서명이 바뀌어서 들어감

INSERT INTO EMP_01
VALUES('유아지원팀', 300, '위하준', DEFAULT);   -- ERROR : 컬럼순서와 데이터 타입이 맞지 않아서.


-------------1-2 표현법
INSERT INTO EMP_01(EMP_ID, EMP_NAME, DEPT_TITLE, HIRE_DATE)
VALUES(400, '임시완', '인사팀', NULL);

INSERT INTO EMP_01 (EMP_NAME, EMP_ID, DEPT_TITLE, HIRE_DATE)
VALUES('강하늘', 500, '보안팀', SYSDATE);

INSERT INTO EMP_01 (EMP_ID, EMP_NAME)
VALUES(600, '박성훈');

INSERT INTO EMP_01 (EMP_ID, DEPT_TITLE)
VALUES(700,'마케팅팀');                     -- ERROR : EMP_NAME이 없어서(제약조건으로 EMP_NAME에 NOT NULL이 들어가 있기 때문)

INSERT INTO EMP_01 (EMP_ID, EMP_NAME, DEPT_TITLE)
VALUES (700, '양동근', '마케팅팀');


-------------1-3 표현법
-- EMPLOYEE 테이블에서 직원사번, 이름, 부서명, 입사일 조회해서 INSERT 하세욤
INSERT INTO EMP_01 (
SELECT EMP_ID, EMP_NAME, DEPARTMENT.DEPT_TITLE, HIRE_DATE FROM EMPLOYEE JOIN DEPARTMENT ON DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE
);

DROP TABLE EMP_01;      -- 밑에 확인하려공
-- 내가 원하는 것만 맞춰서 데이터 넣어 주는 방법
INSERT INTO EMP_01(EMP_ID, EMP_NAME) (SELECT EMP_ID, EMP_NAME FROM EMPLOYEE);





-------------2-1 표현법
CREATE TABLE EMP_DEPT
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE FROM EMPLOYEE
WHERE 1=0;
CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE
WHERE 1=0;

SELECT * FROM EMP_DEPT;
SELECT * FROM EMP_MANAGER;

---EMP_DEPT 테이블에 EMPLOYEE 테이블의 부서코드가 D1인 직원의 사번, 이름, 부서코드, 입사일을 삽입
---EMP_MANAGER 테이블에 EMPLOYEE 테이블의 부서코드가 D1인 직원의 사번, 이름, 관리자 사번을 조회해 삽입
INSERT ALL INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE) 
           INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
(SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D1');

-------------2-2 표현법
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE  0=1;
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
FROM EMPLOYEE
WHERE  0=1;
SELECT * FROM EMP_OLD;
SELECT * FROM EMP_NEW;

DROP TABLE EMP_OLD; 
DROP TABLE EMP_NEW;
-- EMPLOYEE 테이블의 입사일 기준으로 2000년 1월 1일 이전에 이사한 사원은 EMP_OLD삽입
--                      2000년 1월 1일 이후 입사한 사원의 정보는 EMP_NEW 테이블 삽입
INSERT ALL WHEN HIRE_DATE_TEST < TO_DATE('2000/1/1', 'RR/MM/DD')
                    THEN INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE_TEST, SALARY)  
           WHEN HIRE_DATE_TEST >= TO_DATE('2000/1/1', 'RR/MM/DD') 
                    THEN INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE_TEST, SALARY) 
           SELECT EMP_ID, EMP_NAME, TO_CHAR(HIRE_DATE, 'RRRR/MM/DD') "HIRE_DATE_TEST", SALARY FROM EMPLOYEE;


------------- INSERT 확인용 출력 구문.
SELECT * FROM EMP_01;
----------------------------------------1 INSERT




----------------------------------------2 UPDATE
CREATE TABLE DEPT_COPY 
AS SELECT * FROM DEPARTMENT;

CREATE TABLE EMP_SALARY
AS SELECT  EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS FROM EMPLOYEE;

SELECT * FROM DEPT_COPY;
SELECT * FROM EMP_SALARY;

-- DEPT_COPY 테이블에서 DEPT_ID가 'D9'인 부서이름을 '전략기획팀'으로 수정
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID = 'D9';

ROLLBACK;       -- 데이터 되돌리기 가능 ~~ @@@

-- EMP_SALARY 테이블에서 노옹철 사원의 급여를 100원으로 변경
--                      성동일 사장의 급여는 7000원 보너스0.2로 변경
-- 모든 사원의 급여를 기존 급여에서 10퍼 인상한 급여로 변경
UPDATE EMP_SALARY
SET SALARY = 100
WHERE EMP_NAME = '노옹철';

UPDATE EMP_SALARY
SET SALARY = 7000, BONUS = 0.2
WHERE EMP_NAME = '선동일';

UPDATE EMP_SALARY
SET SALARY =  SALARY * 1.1;


UPDATE EMP_SALARY
SET EMP_ID = NULL
WHERE EMP_ID = 200;     -- NOT NULL 제약조건 위배됨

--UPDATE EMP_SALARY
--SET DETP_CODE = 'D0'

-- UPDATE 시 서브쿼리 사용 가능
-- 방명수 사원의 급여와 보너스를 유재식 사원과 동일하게 변경
UPDATE EMP_SALARY
SET (SALARY,BONUS) =  (SELECT SALARY, BONUS FROM EMPLOYEE WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

-- EMP_SALARY 테이블에서 아시아 지역 근무하는 직원 보너스 0.3 변경
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                FROM EMP_SALARY 
                JOIN DEPARTMENT ON DEPARTMENT.DEPT_ID = EMP_SALARY.DEPT_CODE
                JOIN LOCATION ON LOCATION.LOCAL_CODE = DEPARTMENT.LOCATION_ID
                WHERE LOCATION.LOCAL_NAME LIKE '%ASIA%');
----------------------------------------2 UPDATE




----------------------------------------3 DELETE
-- EMP_SALARY 테이블에서 선동일 사장의 데이터를 지우기
SELECT * FROM EMP_SALARY;
DELETE FROM EMP_SALARY
WHERE EMP_ID = 200;


-- EMP_SALARY 테이블에서 DEPT_CODE가 D5인 직원 삭제
DELETE FROM EMP_SALARY
WHERE DEPT_CODE = 'D5';

-- DEPT_CODE 테이블에서 DEPT_ID 가 D1인부서 삭제
DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';
----------------------------------------3 DELETE




----------------------------------------4 TRUNCATE   --> 왠만하면..안써야겠다...ㅠㅠ 테이블뼈대만 남기고 싹 지워뿐다 ㅠ
TRUNCATE TABLE DEPT_COPY;
TRUNCATE TABLE EMP_SALARY;

DROP TABLE DEPT_COPY;
DROP TABLE EMP_SALARY;
DROP TABLE EMP_NEW;
DROP TABLE EMP_OLD;

ROLLBACK;
----------------------------------------4 TRUNCATE


ROLLBACK;














