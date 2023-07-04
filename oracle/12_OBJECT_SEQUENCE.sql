/*
    시퀀스(SEQUENCE)
    - 자동으로 번호 발생시켜 주는 역할을 하는 객체
    - 정수값을 순차적으로 일정값씩 증가시키면서 생성해줌
    
    EX) 회원번호, 사원번호, 게시글 번호, ... 
*/

/*
    1. 시퀀스 객체 생성
    
    [표현법]
    CREATE SEQUENCE 시퀀스명 
    [START WITH 시작넘버]   --> 처음 발생 시킬 시작값 지정 (기본값 1)
    [INCREMENT BY 숫자]  --> 얼마씩 증가 시킬 건지 (기본값 1)
    [MAXVALUE 숫자] --> 최대값 '숫자'까지 지정 (기본값은 겁나큼~)
    [MINVALUE 숫자] --> 최소값 '숫자' 지정 (기본값 1)
    [CYCLE | NOCYCLE] --> 값 순환 여부 지정 (기본값 NOCYCLE)
    [NOCACHE | CACHE 바이트크기] --> 캐시메모리 할당 (기본값 CACHE 20)
    
    * CACHE 메모리 (캐시메모리)
            - 미리 발생된 값을 생성해서 저장하는 공간 
            - 매번 호출 될 때 마다 새롭게 번호 생성하는 것이 아닌 캐시메모리 공간에 생선된 값을 가져다 씀
            - 접속이 해제되면 => 캐시메모리에 '미리' 만들어둔 번호가 날아감
    
    
    
    * 오라클 명명 기본 규칙..?
    테이블 이름 : TB_
    뷰 이름 : VW_
    시퀀스 이름 : SEQ_
    트리거 이름 : TRG_
*/

-- EMPLOYEE 테이블의 PK값을 생성할 시퀀스 생성
CREATE SEQUENCE SEQ_EMPID
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- 현재 계정이 소유하고 있는 시퀀스들의 구조를 보고자 할때
SELECT * FROM USER_SEQUENCES;

/*
    2. 시퀀스 사용
    시퀀스명.CURRVAL : 현재 시퀀스의 값 확인
    시퀀스명.NEXTVAL : 시퀀스값에 일정 값을 증가시켜 발생된 값 
    (현재 시퀀스 값에서 INCREMENT BY 값 만큼 증가된 값. 즉, 시퀀스명.CURRVAL + INCREMENT BY 값)
*/


SELECT SEQ_EMPID.CURRVAL FROM DUAL; -- NEXTVAL을 한번이라도 수행하지 않으면, CURRVAL 가져올 수 가 없음!!!!!@@@
                                    -- WHY? CURRVAL은 마지막으로 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값이라서..

SELECT SEQ_EMPID.NEXTVAL, SEQ_EMPID.CURRVAL FROM DUAL;


/*
    3. 시퀀스 구조 변경
    
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY NUMBER]
    [MXAVALUE NUMBER]
    [MINVALUE NUMBER]
    [CYCLE | NOCYCLE]
    [NOCACHE | CACHE  byteSIZE]
    --> 초기값(START WITH)은 변경 불가능 ~
    
*/

ALTER SEQUENCE SEQ_EMPID
INCREMENT BY 10
MAXVALUE 400;

SELECT SEQ_EMPID.NEXTVAL FROM DUAL;
SELECT SEQ_EMPID.CURRVAL FROM DUAL;

/*
    4. 시퀀스 삭제
*/
DROP SEQUENCE SEQ_EMPID;

SELECT * FROM USER_SEQUENCES;



/*
    5. SEQUENCE 예시
*/
-- 1) 매번 새로운 사번이 발생되는 SEQUENCE 생성
CREATE SEQUENCE SEQ_EMPID
START WITH 300;

-- 2) 매번 새로운 사번이 발생되는 SEQUENCE 사용해서 INSERT 구문 작성
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO)
VALUES(SEQ_EMPID.NEXTVAL, '김강우', '221227-3123456');

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO)
VALUES (SEQ_EMPID.NEXTVAL, '고아라', '230629-4987654');

SELECT * FROM EMPLOYEE ORDER BY EMP_ID DESC;




-- 자바 연동해서 사용할 임시 테이블
CREATE TABLE EMP(
    EMP_ID NUMBER PRIMARY KEY,
    EMP_NAME VARCHAR2(30) NOT NULL,
    DEPT_TITLE VARCHAR2(30) DEFAULT '개발팀',
    HIRE_DATE DATE DEFAULT SYSDATE
);


CREATE TABLE PERSON(
    ID  NUMBER PRIMARY KEY,
    NAME VARCHAR2(20) NOT NULL,
    ADDRESS VARCHAR2(50)
);

CREATE SEQUENCE SEQ_PERSON;
SELECT SEQ_PERSON.NEXTVAL FROM DUAL;

SELECT * FROM user_sequences
WHERE SEQUENCE_NAME LIKE '%person%';
DROP SEQUENCE SEQ_PERSON;
