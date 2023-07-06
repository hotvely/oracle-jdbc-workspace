/*
  커서 (CURSOR)
  - SQL 구문의 처리 결과를 담고 있는 객체
  - 여러 행으로 나타난 처리 결과를 순차적으로 접근 가능
  
  * 종류
  1. 묵시적(implicit) 커서
     오라클에서 자동으로 생성되어 사용하는 커서 (커서명 : SQL)
     PL/SQL에서 SQL문 실행 시 마다 자동으로 만들어짐
     
  2. 명시적(explicit) 커서
     사용자가 직접 선언해서 사용할 수 있는 이름이 있는 커서
     
     [표현]
     CURSOR 커서명 IS SELECT 문
     OPEN 커서명;
     FETCH 커서명 INTO 변수,변수,변수,....;
     ...
     CLOSE 커서명;
     
     
  * 커서 속성
    커서명%FOUND : 커서 영역에 남아있는 행의 수가 한개 이상일 경우 TRUE, 없으면 FALSE
    커서명%NOTFOUND : 커서 영역에 남아있는 행의 수가 없으면 TRUE, 있으면 FALSE
    커서명%ISOPEN : 커서 OPEN 상태이면 TRUE, CLOSE 상태이면 FALSE (묵시적 커서의 DEFAULT는 FALSE)
    커서명%ROWCOUNT : SQL 처리 결과로 얻어온 행(ROW)의 수
*/
SET SERVEROUTPUT ON;
-- 1. 묵시적 커서
CREATE TABLE EMP_COPY
AS SELECT * FROM EMPLOYEE;

DROP TABLE EMP_COPY;
-- PL/SQL에서 EMP_COPY 테이블에 BONUS가 NULL인 사원의 BONUS를 0으로 수정
BEGIN
    UPDATE EMP_COPY SET BONUS = 0
    WHERE BONUS IS NULL;    
    
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || '행 수정됨');
END;
/
ROLLBACK;

-- 2. 명시적 커서
-- PL/SQL 이용해서 급여가 300만원 이상인 사원의 사번, 이름, 급여 출력
DECLARE 
    EID EMP_COPY.EMP_ID%TYPE;
    ENAME EMP_COPY.EMP_NAME%TYPE;
    SAL EMP_COPY.SALARY%TYPE;
    
    CURSOR C1 IS 
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMP_COPY WHERE SALARY >= 3000000;
        
    BEGIN
        OPEN C1;
        LOOP
            FETCH C1 INTO EID, ENAME, SAL;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('사번 > ' || EID || ' | 이름 > ' || ENAME || ' | 급여 > ' || SAL);
        END LOOP;            
        CLOSE C1;
END;
/

-- 전체 부서에 대해 부서코드, 부서명, 지역조회 
DECLARE 
    DEPT DEPARTMENT%ROWTYPE;
    CURSOR C1 IS 
        SELECT * FROM DEPARTMENT ;
    BEGIN
        OPEN C1;
        LOOP
            FETCH C1 INTO DEPT.DEPT_ID, DEPT.DEPT_TITLE, DEPT.LOCATION_ID;
            EXIT WHEN C1%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
        END LOOP;            
        CLOSE C1;
END;
/

-- FOR LOOP 를 이용해 커서 사용
-- 1) LOOP 시작 시 자동으로 커서 오픈함.
-- 2) 반복할 때 마다 FETCH도 자동으로 함.
-- 3) LOOP종료시 자동으로 커서 CLOSE함.
-- > 테이블 싹 긁어 올때 개 편함 ;;
DECLARE 
    DEPT DEPARTMENT%ROWTYPE;
    BEGIN
        FOR DEPT IN (SELECT * FROM DEPARTMENT)
        LOOP
            DBMS_OUTPUT.PUT_LINE(DEPT.DEPT_ID || ' ' || DEPT.DEPT_TITLE || ' ' || DEPT.LOCATION_ID);
        END LOOP;
END;
/























































