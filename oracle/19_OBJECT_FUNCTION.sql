/*
    함수 (FUNCTION)
    - 프로시저와 거의 유사한 용도로 사용하지만.. 실행 결과를 되돌려 받을 수 있다는 점이 다르다.
    
    [표현]
    CREATE [OR REPLACE] FUNCTION 함수이름
    (
        매개변수1 데이터타입,
        매개변수2 데이터타입,
        ... 
    )
    RETRUN 데이터타입
    IS [AS]
        선언부
    BEGIN
        실행부
        RETURN 반환값;
    [EXCEPTION
        예외처리부]
    END [함수명];
    /
    
    * 실행
    EXECUTE (OR EXEC) 함수이름 [ 매개값1, 매개값2,...]
    * 삭제
    DROP FUNCTION 함수이름    
*/
-- 사번을 입력받아 보너스를 포함하는 연봉 계산후 리턴하는 함수
CREATE OR REPLACE FUNCTION BONUS_CALC
(
    V_EMP_ID EMP_COPY.EMP_ID%TYPE
)
RETURN NUMBER
IS
    V_SALARY EMP_COPY.SALARY%TYPE;
    V_BONUS EMP_COPY.BONUS%TYPE;
BEGIN
    SELECT SALARY, NVL(BONUS , 0)
    INTO V_SALARY , V_BONUS
    FROM EMP_COPY
    WHERE EMP_ID = V_EMP_ID;
    
    RETURN  (V_SALARY + (V_SALARY * V_BONUS)) * 12;

END;
/

-- 함수 호출 ( SELECT 문 안에서)
SELECT BONUS_CALC('&사번') FROM DUAL;

-- 함수 호출 결과를 반환받아 저장할 바인드 변수 선언
VAR VAR_CALC_SALARY NUMBER;
EXECUTE :VAR_CALC_SALARY := BONUS_CALC('&사번');
PRINT VAR_CALC_SALARY;


-- EMPLOYEE 테이블에서 방금 만든 함수(BONUS_CALC)를 이용해서 보너스를 포함한 연봉이 4000만원 이상인 사원의 사번 직원명 급여 보너스 조회

SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0) , BONUS_CALC(EMP_ID)
FROM EMPLOYEE
WHERE BONUS_CALC(EMP_ID) >= 40000000;










