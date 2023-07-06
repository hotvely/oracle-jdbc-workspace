/*
    프로시저 (PROCEDURE)
    - PL/SQL 문을 저장하여 필요할 때마다 복잡한 구문을 다시 입력할 필요 없이 간단하게 호출해서 실행 결과를 얻음.
    
    [표현]
    CREATE [OR REPLACE] PROCEDURE 프로시저이름
    (
        매개변수 1 [IN | OUT] 테이터 타입 [:= DEFAULT 값],
        매개변수 2 [IN | OUT] 테이터 타입 [:= DEFAULT 값],
        ...
    )
    IS [AS]
        선언부
    BEGIN
        실행부
    [EXCEPTION
        예외처리부]
    END [프로시저명];
    /
    
    
    * IN : 사용자로 부터 값을 입력받아 PROCEDURE로 전달해 주는 역할 (기본값)
    * OUT : PROCEDURE 에서 호출 환경으로 값을 전달하는 역할
    
    * 사용 
    EXECUTE(또는 EXEC) 프로시저명 [(매개값1, 매개값2, .....)]
    
    * 삭제
    DROP PROCEDURE 프로시저명;
*/

-- EMP COPY 테이블의 모든 데이터 삭제하는 프로시저.
CREATE PROCEDURE DEL_ALL_EMP
IS
BEGIN
    DELETE FROM EMP_COPY
    COMMIT;
END;
/
DROP PROCEDURE DEL_ALL_EMP;
EXECUTE DEL_ALL_EMP;

SELECT * FROM EMP_COPY;

--GRANT CREATE SESSION TO KH;

/*
    1. 매개변수가 있는 프로시저.
*/
-- 사번을 입력받아서 해당하는 사번의 사원을 삭제하는 프로시저 생성
-- (P_EMP_ID)
CREATE PROCEDURE DEL_EMP_WITH_ID
(
    P_EMP_ID IN EMP_COPY.EMP_ID%TYPE
)
IS
BEGIN
    DELETE FROM EMP_COPY 
    WHERE EMP_ID = P_EMP_ID;
END DEL_EMP_WITH_ID;
/


DROP PROCEDURE DEL_EMP_WITH_ID;
EXECUTE DEL_EMP_WITH_ID('&사번');
SELECT * FROM EMP_COPY;




/*
    2. IN / OUT 매개변수가 있는 프로시저
*/
-- 사번을 입력받아서 해당하는 사원 이름, 급여, 보너스 전달
CREATE PROCEDURE SELECT_EMP_ID(
    P_EMP_ID IN EMP_COPY.EMP_ID%TYPE,
    P_EMP_NAME OUT EMP_COPY.EMP_NAME%TYPE,
    P_SALARY OUT EMP_COPY.SALARY%TYPE,
    P_BONUS OUT EMP_COPY.BONUS%TYPE
)
IS
BEGIN
    SELECT EMP_NAME, SALARY, BONUS 
    INTO P_EMP_NAME, P_SALARY, P_BONUS
    FROM EMP_COPY
    WHERE EMP_ID = P_EMP_ID;
END;
/

-- 출력 변수 추가 (바인드변수)
VAR VAR_EMP_NAME VARCHAR2(30);
VAR VAR_SALARY NUMBER;
VAR VAR_BONUS NUMBER;

EXECUTE SELECT_EMP_ID('&사번', :VAR_EMP_NAME, :VAR_SALARY, :VAR_BONUS);

-- 바인드 변수의 값 출력 하기 위해선 PRINT 구문 사용
PRINT VAR_EMP_NAME;
PRINT VAR_SALARY;
PRINT VAR_BONUS;

-- 바인드 변수의 값이 변경되면 변수의 값을 자동으로 출력
SET AUTOPRINT ON;



