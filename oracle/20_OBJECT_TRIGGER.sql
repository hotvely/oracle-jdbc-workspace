/*
    TRIGGER
    - 테이블이나 뷰가 DML(INSERT, UPDATE, DELETE)문에 의해 변경되는 경우에 자동으로 실행될 내용을 정의하여 저장
    
    EX)
    - 회원탈퇴시 기존 회원 테이블에 데이터 DELETE 후에 곧바로 탈퇴된 회원들만 따로 보관하는 테이블에 자동으로 INSERT 처리함.
    - 신고횟수가 일정 수를 넘었을 때 해당 회원 자동으로 블랙리스트 처리
    - 입출고에 대한 데이터가 기록(INSERT)될 때 마다 해당 상품에 대한 재고수량을 매번 수정(UPDATE)해야 할 때
    
    * 트리거 종류
    - SQL 문의 실행 시기에 따른 분류 
        > BEFORE TRIGGER : 내가 지정한 테이블에 이벤트가 발생되기 전에 트리거 실행
        > AFTER TRIGGER : 지정한 테이블에 이벤트 발생이후 트리거 실행
    - SQL 문에 의해 영향을 받는 각 행에 따른 분류
        > STATEMENT TRIGGER (문장 트리거) : 이벤트 발생한 SQL 문에 대해 딱 한번만 트리거 실행
        > ROW TRIGGER (행 트리거) : 해당 SQL문 실행 할 때 마다 트리거 실행 (FOR EACH ROW 옵션 기술필요함)
                            -> :OLD - BEFORE UPDATE (수정전 자료), BEFORE DELETE(삭제전 자료)
                            -> :NEW - AFTER INSERT (추가된 자료), AFTER UPDATE(수정후 자료)
                            
    * 트리거 생성
    [표현]
    CREATE [OR REPLACE] TRIGGER 트리거이름
    BEFORCE|AFTER  INSERT|UPDATE|DELETE ON 테이블이름
    [FOR EACH ROW] (행트리거 실행할땐 필요함)
    DECLARE
        변수 선언;
    BEGIN
        실행내용 (위에 지정된 이벤트 발생시 자동으로 실행 할 구문)
    EXCEPTION
        예외처리구문
    END;
    /
    
*/

-- 1. 문장트리거
-- EMPLOYEE 테이블에 새로운 행이 INSERT 될 때 '신입사원이 입사했습니다.!' 메시지 자동 출력하는 트리거 생성
CREATE OR REPLACE TRIGGER TRG_01
    AFTER INSERT ON EMPLOYEE
    DECLARE
    BEGIN
        DBMS_OUTPUT.PUT_LINE('신입사원이 입사했습니다.!!!');
    END;
    /

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME,EMP_NO) VALUES(500,'박진실','111111-2222222');
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME,EMP_NO) VALUES(501,'이창희','222222-1111111');
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME,EMP_NO) VALUES(502,'멍멍이','333333-4444444');
ROLLBACK;

-- 2. 행트리거
-- :OLD : 수정 삭제 전 데이터 접근 가능
-- :NEW : 추가 수정 후 데이터 접근 가능
-- EMPLOYEE 테이블에 UPDATE 수행 후 '업데이트 실행' 메시지 자동 출력

-- 문장트리거로 UPDATE 했을때.. 트리거 발동 하게 생성
CREATE OR REPLACE TRIGGER TRG_02
    AFTER UPDATE ON EMPLOYEE
    FOR EACH ROW
    DECLARE
    BEGIN
        DBMS_OUTPUT.PUT_LINE('변경전 : ' || :OLD.DEPT_CODE|| ', 변경후 : ' || :NEW.DEPT_CODE);
        DBMS_OUTPUT.PUT_LINE('업데이트 완료.!!!');
    END;
    /
UPDATE EMPLOYEE SET EMP_NAME = '&변경명' WHERE EMP_ID = '&사번';
SELECT * FROM EMPLOYEE WHERE EMP_ID = '&사번';

UPDATE EMPLOYEE SET DEPT_CODE = 'D3' WHERE DEPT_CODE = 'D6';
ROLLBACK;    



-- 상품 입/출고 관련 예시
-- 1. 상품에 대한 데이터 보관할 테이블 생성 (TB_PRODUCT)
CREATE TABLE TB_PRODUCT
(
    PCODE NUMBER PRIMARY KEY,       -- 상품번호
    PNAME VARCHAR2(30) NOT NULL,    -- 상품명
    BRAND VARCHAR2(30) NOT NULL,    -- 브랜드명
    PRICE NUMBER,               -- 가격
    STOCK NUMBER DEFAULT 0      -- 재고수량
);
CREATE SEQUENCE SEQ_PCODE;

INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시23', '삼성', 1500000, DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시Z 프립4', '삼성', 1000000, 10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰14', '애플', 1180000, 20);
COMMIT;

-- 2. 상품 입/출고 상세 이력 테이블 생성 (TB_PRODUCTAIL)
CREATE TABLE TB_PRODETAIL
(
    DCODE NUMBER PRIMARY KEY,                           -- 이력번호                                   
    PCODE NUMBER REFERENCES TB_PRODUCT,                 -- 상품번호
    PDATE DATE NOT NULL,                                -- 상품 입출고일
    AMOUNT NUMBER NOT NULL,                             -- 입출고 수량
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고'))     -- 상태    
);
CREATE SEQUENCE SEQ_DCODE;

-- 1번 상품이 오늘 날짜로 10개 입고..됨..
INSERT INTO TB_PRODETAIL VALUES(SEQ_DCODE.NEXTVAL, 1, SYSDATE, 10, '입고');
--> 1번 상품의 재고수량 10개 증가됨..
UPDATE TB_PRODUCT SET STOCK = STOCK + 10 WHERE PCODE = 1;

COMMIT;

SELECT * FROM TB_PRODETAIL;
SELECT * FROM TB_PRODUCT;


-- 3번 상품이 오늘날짜로 5개 출고
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL, 3, SYSDATE, 5, '출고');
UPDATE TB_PRODUCT SET STOCK = STOCK - 5 WHERE PCODE = 3;


-- TB_PRODETAIL 테이블에 INSERT 이벤트 발생하면.. TB_PRODUCT 테이블에 매번 자동으로 재고수량 UPDATE 되게 트리거 정의
CREATE OR REPLACE TRIGGER TRG_03
    AFTER INSERT ON TB_PRODETAIL
    FOR EACH ROW
    DECLARE
        PRODUCT_IN_OUT VARCHAR2(10) := :NEW.STATUS;
        PRODUCT_CODE NUMBER := :NEW.PCODE;
BEGIN
    IF (PRODUCT_IN_OUT = '입고') THEN
        UPDATE TB_PRODUCT SET STOCK = STOCK + (:NEW.AMOUNT) WHERE PCODE = PRODUCT_CODE;
        DBMS_OUTPUT.PUT_LINE('입고 데이터 추가 완료.');
    ELSIF (PRODUCT_IN_OUT = '출고') THEN
        UPDATE TB_PRODUCT SET STOCK = STOCK - (:NEW.AMOUNT) WHERE PCODE = PRODUCT_CODE;
        DBMS_OUTPUT.PUT_LINE('출고 데이터 추가 완료.');
    END IF;
END;
/
INSERT INTO TB_PRODETAIL VALUES (SEQ_DCODE.NEXTVAL, 3, SYSDATE, 5, '출고');




























