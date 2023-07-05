/*
    PL/SQL (PROCEFURE LANGUAGE EXTENSION TO SQL)
    - 오라클에서 제공하는 절차 지향 프로그래밍 언어
    - SQL 문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE) 등을 지원해서 SQL의 단점을 보완함 ~ 개꿀!..???
    - 다수의 SQL문을 한번에 실행 가능하게 하는 (BLOCK)구조
        * 블록(BLOCK) : 명령어를 모아 둔 PL/SQL 프로그램의 기본 단위
        
        
    * PL / SQL 구조
    [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수 OR 상수를 선언 및 초기화 하는 부분
    실행부 (EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건,반복) 등의 로직을 기술하는 부분
    [예외처리부(EXCEPTION SECTION)] : EXCEPTION 으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술해 둘 수 있음
*/
-- 출력 기능 활성화
SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/


/*
    1. DECLARE 선언부
    - 변수 및 상수를 선언하는 공간 (선언과 동시에 초기화 가능)
    - 일반, 레퍼런스, ROW 타입 변수
*/
/*
  1-1) 일반 타입 변수의 선언 및 초기화
        [표현식]
        변수명 [CONSTANT] 자료형 [:=값];
*/

DECLARE 
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' ||PI);
    
END;
/



/*
    1-2) 레퍼런스 타입 변수 선언 및 초기화 (특정 테이블의 특정 컬럼의 데이터 타입을 참조해서 지정함)
        [표현식]
        변수명 테이블명.컬럼명%TYPE;
*/
-- 박나라 사원의 사번, 이름, 급여 정보 조회해서 출력
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY
    INTO EID, ENAME, SAL
    FROM EMPLOYEE WHERE EMP_NAME = '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('SAL : ' ||SAL);
END;
/

-- 문제로 풀어보기!
-- 레퍼런스 타입의 변수로 EID, ENAME, JCODE, DTITLE, SAL선언
-- EMP_ID, EMP_NAME, JOB_CODE, SALARY 컬럼과 DEPARTMENT 테이블 DEPT_TITLE 자료형 참조
-- 사용자가 입력한 사번과 일치하는 사원을 조회한 후 결과 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    
    BEGIN 
    SELECT EMP_ID, EMP_NAME, JOB_CODE, DEPT_TITLE, SALARY
    INTO EID, ENAME, JCODE, DTITLE, SAL
    FROM EMPLOYEE 
    JOIN DEPARTMENT ON DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE
    WHERE EMP_ID = '&사번';

    DBMS_OUTPUT.PUT_LINE('EID : '|| EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' ||JCODE);
    DBMS_OUTPUT.PUT_LINE('DTITLE : ' ||DTITLE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' ||SAL);
    
EXCEPTION    WHEN NO_DATA_FOUND THEN  DBMS_OUTPUT.PUT_LINE('데이터가 없음');
    
END;
/



/*
    1-3) ROW 타입 변수 선언 및 초기화 
*/
DECLARE 
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * INTO EMP FROM EMPLOYEE
    WHERE EMP_NAME = '&직원명';
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('입사일 : '|| TO_CHAR(EMP.HIRE_DATE, 'YYYY"년-"MM"월-"DD"일"'));
END;
/


/*
    2. 실행부
        제어문, 반복문, 쿼리문 등의 로직 기술 영역
        
    1) 선택문
        1-1) IF    
            IF 조건식 THEN 실행문 END IF;
        1-2) IF ELSE 문    
            IF 조건식 THEN 실행문
            ELSE 실행내용
            END IF;
        1-3) IF ~ ELSEIF ~ ELSE
            IF 조건1 THEN 실행1
            ELSIF 조건2 THEN 실행2
            ....
            ELSE 실행N
            END IF;
        1-4) CASE
            CASE 비교대상
                WHEN 비교값1 THEN 결과값1
                WHEN 비교값2 THEN 결과값2
                ...
                ELSE 결과값N
                END;
*/
-- 사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스 출력
-- 단, 보너스를 받지 않는 사원은 보너스 출력 전에 '보너스를 지급받지 않는 사원입니다.' 라는 문구 출력할 것
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
    
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0.0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : '|| SAL);
    
    IF BONUS = 0 THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');    
    ELSE 
         DBMS_OUTPUT.PUT_LINE('보너스 받는 사원임!');    
    END IF;    
  
    DBMS_OUTPUT.PUT_LINE('보너스 : '|| BONUS);
    
    
END;
/
-- 사용자가 입력한 사번, 이름, 부서명, 근무국가코드 조회 후 각 변수에 대입
-- 일반타입 변수 TEAM 을 데이터 타입 VARCHAR2(10)으로 선언하고
-- NODE 값이 KO => TEAM에 '국내팀' 그 외에는 '해외팀' 넣기

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
    
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, L.NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    JOIN DEPARTMENT D ON D.DEPT_ID = EMPLOYEE.DEPT_CODE
    JOIN LOCATION L ON L.LOCAL_CODE = D.LOCATION_ID
    WHERE EMP_ID = '&사번';
    
    
    
    IF NCODE = 'KO' THEN
        TEAM := '국내팀';    
    ELSE 
         TEAM := '해외팀';  
    END IF;  
    
  
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EID);
    DBMS_OUTPUT.PUT_LINE('이름 : '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('DTITLE : '|| DTITLE);
    DBMS_OUTPUT.PUT_LINE('TEAM : '|| TEAM);
    
    
END;
/

-- 사용자에게 점수를 입력받아서 SCORE(NUMBER) 변수에 저장한 후 학점은 입력된 점수에 따라 GRADE(CHAR(1)) 변수에 저장 
-- 90 >= 'A' 80 >= B 70 >= C 60 >= D 60 < F
-- 출력 : 당신의 점수는 xx점이고, 학점은 x학점 입니다.
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := '&점수';
    IF SCORE >= 90 THEN
        GRADE := 'A';
    ELSIF SCORE >= 80 THEN
        GRADE := 'B';
    ELSIF SCORE >= 70 THEN
        GRADE := 'C';
    ELSIF SCORE >= 60 THEN
        GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' ||SCORE||'점이고, 학점은 '||GRADE||'학점 입니다.');
END;
/

-- 사용자에게 입력받은 사원과 일치하는 사원의 급여 조회 후 출력
-- (조회한 급여는 sal변수 대입)
-- 500 이상 고급 300이상 중급 300미만 초급
-- 출력 : 해당 사원의 급여 등급은 고급입니다. 

DECLARE
    GRADE VARCHAR2(10);
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BEGIN
    SELECT EMP_NAME, SALARY
    INTO ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF SAL >= 5000000 THEN GRADE := '고급';
    ELSIF SAL >= 3000000 THEN GRADE := '중급';
    ELSE 
    GRADE := '초급';
    END IF;
        
    DBMS_OUTPUT.PUT_LINE(ENAME ||' 사원의 급여 등급은 '|| GRADE || '입니다.');
    
END;
/

DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);

BEGIN
    SELECT SALARY
    INTO SAL
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    SELECT SAL_LEVEL
    INTO GRADE
    FROM SAL_GRADE
    WHERE SAL BETWEEN MIN_SAL AND MAX_SAL;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 '|| GRADE || '입니다.');
END;
/

-- 사번을 입력받은 후 사원의 모든 컬럼 데이터를 EMP에 대입하고
-- DEPT_CODE 에 따라서 알맞는 부서를 출력
-- D1 :인사관리부, D2 :회계관리부, D3 :마케팅부, D4 :국내영업부, D5 : 해외영업1부 , D6:해외영업2부, D7 :해외영업3부, D8 :기술지원부, D9 :총무부
-- 나머지는 부서없음.
DECLARE 
     EMP EMPLOYEE%ROWTYPE;
     DNAME VARCHAR2(20);
     
 BEGIN
    SELECT * INTO EMP FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN  '인사관리부'
                WHEN 'D2' THEN '회계관리부'
                WHEN 'D3' THEN '마케팅부'
                WHEN 'D4' THEN '국내영업부'
                WHEN 'D5' THEN '해외영업1부'
                WHEN 'D6' THEN  '해외영업2부'
                WHEN 'D7' THEN  '해외영업3부'
                WHEN 'D8' THEN  '기술지원부'
                WHEN 'D9' THEN  '총무부'
                ELSE '부서없음'
                END;        
     DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
     DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
     DBMS_OUTPUT.PUT_LINE('부서코드 : ' || EMP.DEPT_CODE);
     DBMS_OUTPUT.PUT_LINE('부서 : ' || DNAME);
END;
/


/*
    2-1) BASIC LOOP
        LOOP
            반복실행구문;
        END LOOP;
        
        * 반복문 탈출 구문 2가지
        - IF 조건식 THEN EXIT; END IF;
        - EXIT WHEN 조건식;
*/
-- 1~5 까지 순차적으로 1씩 증가하는 값을 출력
DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM + 1;
        IF(NUM > 5 ) THEN EXIT;      
        END IF;
    END LOOP;
END;
/

DECLARE
    NUM NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);
        NUM := NUM + 1;
        EXIT WHEN NUM>10;
    END LOOP;
END;
/

/*
    2-2) FOR LOOP
        FOR 변수 IN 초기값.. 최종값
        LOOP
            반복실행구문;
        END LOOP;
*/

BEGIN
    FOR NUM IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);  
    END LOOP;
    END;
    /

-- 구구단 2~9 출력 단, 짝수만
BEGIN
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN,2) = 0 THEN
            DBMS_OUTPUT.PUT_LINE('구구단 ' || DAN || '단');  
            FOR NUM IN 1..9
            LOOP
                    DBMS_OUTPUT.PUT_LINE(DAN || '*' || NUM || '=' || DAN*NUM);  
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');  
        END IF;    
    END LOOP;
END;
/

DROP TABLE TEST;
CREATE TABLE TEST
(
    NUM NUMBER,
    CREATE_DATE DATE
);
-- TEST 테이블에 10개 행을 INSERT 하는 PL / SQL 작성
BEGIN
    FOR NUM IN 1..10
    LOOP
        INSERT INTO TEST VALUES(NUM);
    END LOOP;
END;
/

/*
    2-3) WHILE LOOP
        WHILE 반복문수행조건
        LOOP
            반복실행구문;
        END LOOP;
*/
-- 1~5 출력
DECLARE 
NUM NUMBER := 1;
BEGIN
    WHILE NUM < 6
    LOOP
        DBMS_OUTPUT.PUT_LINE(NUM);  
        NUM := NUM + 1;
    END LOOP;
END;
/
-- 2~9단 구구단 출력
DECLARE
DAN NUMBER := 2;
NUM NUMBER := 1;
BEGIN
    WHILE DAN < 10
    LOOP
        IF NUM = 1 THEN DBMS_OUTPUT.PUT_LINE('구구단 - ' || DAN || '단');  
        END IF;
        DBMS_OUTPUT.PUT_LINE(DAN || '*' || NUM || '=' || DAN*NUM); 
        NUM := NUM + 1;
        IF NUM > 9 THEN NUM := 1; DAN := DAN + 1; END IF;
    END LOOP;
END;
/

/*
    3. 예외처리
    EXCEPTION : 실행중 발생하는 오류
        EXCEPTION
            WHEN 예외명1 THEN 예외처리구문1;
            WHEN 예외명2 THEN 예외처리구문2;
            ...
            WHEN OTHERS THEN 예외처리구문N;
            
    * 오라클에서 미리 정의되어 있는 시스템 예외
    - NO_DATE_FOUND : SELECT한 결과가 하나의 행도 없는 경우에.
    - TOO_MANY_ROWS : SELECT한 결과가 한 행이 리턴되어야 하는데 여러 행인 경우
    - ZERO_DIVIDE : 0으로 나누려고 할때
    - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되는 경우
    등등..
*/



-- 사용자가 입력한 수로 나눗셈 연산 결과 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE(10 / &숫자);
    EXCEPTION
        WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0은 못나눔 ㅎㅎ;;');
END;
/

-- UNIQUE 위배시
BEGIN
    UPDATE EMPLOYEE SET EMP_ID = 203
    WHERE EMP_NAME = '&이름';
    EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');

END;
/

-- NO_DATA_FOUND : 결과 없을때
-- TOO_MANY_ROWS : 결과가 여러행으로 나올때

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
BEGIN
    SELECT EMP_ID, DEPT_CODE
    INTO EID, DCODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = '&부서코드';
    
    DBMS_OUTPUT.PUT_LINE('사번 : '|| EID);
    DBMS_OUTPUT.PUT_LINE('부서코드 : '|| DCODE);
    
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('데이터 행이 너무 많아요 ㅠ..');
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('데이터가 존재 하지않는다는디?????');
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('오류 만하염.. 관리자한테 문의 ㄱㄱ');
END;
/    


































