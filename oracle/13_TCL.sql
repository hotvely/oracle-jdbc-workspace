

/*
    트랜잭션 (TRANSACTION)
    - 하나의 논리적인 작업단위
    - ex) ATM기에서 현금 출력
        1. 카드 삽입
        2. 메뉴 선택
        3. 금액 확인 및 인증
        4. 실제 계좌에서 금액만큼 인출
        5. 현금 인출
        6. 완료
    - 각각의 업무들을 묶어서 하나의 작업 단위로 만드는 것을 트랜잭션이라 함.    
    
    
    COMMIT 
    - 모든 작업들으르 정상적으로 처리하겠다고 확정하는 구문
    
    ROLLBACK
    - 모든 작업들을 취소하겠다고 확정하는 구문 (마지막 COMMIT 시점으로 돌아감)
    
    SAVEPOINT
    - 저장점을 지정하고 ROLLBACK 진행시 전체 작업을 ROLLBACK 하는게 아니라 SAVEPOINT 까지 일부만 롤백함
    
    SAVEPOINT 포인트명;
    .....
    ROLLBACK TO 포인트명;
        
*/


CREATE TABLE EMP_TEST AS SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE;

-- EMP_TEST 테이블에서 EMP_ID가 213, 218인 사원 삭제
DELETE FROM EMP_TEST
WHERE EMP_ID IN (213, 218);

SAVEPOINT SP1;

DELETE FROM EMP_TEST WHERE EMP_ID IN (200);

ROLLBACK TO SP1;
SELECT * FROM EMP_TEST;
-- EMP_TEST 에서 EMP_ID 202 사원 삭제
DELETE FROM EMP_TEST WHERE EMP_ID IN (202);
CREATE TABLE TEST(TID NUMBER);
ROLLBACK;
SELECT * FROM EMP_TEST;



---------------- JDBC ----------------------------------------------------------
CREATE TABLE CUSTOMER
(
    NAME VARCHAR2(20),
    AGE NUMBER,
    ADDRESS VARCHAR2(100)
);
SELECT * FROM CUSTOMER;


CREATE TABLE BANK
(
    NAME VARCHAR2(20),
    BANKNAME VARCHAR2(40),
    BALANCE NUMBER
);
INSERT INTO BANK VALUES('김도경', '국민은행', 1000000);
INSERT INTO BANK VALUES('김민소', '신한은행', 500000);


SELECT BALANCE FROM bank WHERE name = '김도경';








