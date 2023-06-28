/*
    * ALTER
    - 객체 수정 구문
    
    * 테이블 수정
    [표현법]
    ALTER TABLE 테이블이름 수정할내용;
    
    * 수정할 내용
    1. 컬럼 추가/수정/삭제
    2. 제약조건 추가/삭제 -> 수정은 불가 (수정하고자 하면 삭제한 후 새로 추가)
    3. 테이블명/컬럼명/제약조건명 변경
*/

CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

/*
    1 컬럼 추가/수정/삭제/이름 변경
        1) 추가 (ADD)
            ALTER TABLE TABLE이름 ADD 컬럼명 데이터타입 [DEFAULT 기본값];
            
        2) 컬럼수정 (MODIFY)
            - 데이터 타입 변경 : ALTER TABLE 테이블명 MODIFY 컬럼명 변경할 데이터타입
            - 기본값 변경 : ALTER TABLE 테이블명 MODIFY 컬럼명 DEFAULT 변경할 기본값;
                            --> DEFAULT NULL : DEFAULT 삭제
        
        3) 컬럼 삭제
        ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
            - 데이터 값이 있어도 걍 같이 밀어버림...(삭제하면 복구 불가능!!!!!)
            - 참조되는 컬럼이 있을 경우에만 삭제 불가능
            - 테이블에 최소 한개의 컬럼은 존재해야 함.
        
        4) 컬럼명 변경
        ALTER TABLE 테이블명 RENAME COLUMN 기존 컬럼명 TO 변경할 컬럼명;
        
*/

------------------------------------------1-1 추가 (ADD)
-- CNAME 컬럼 추가
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20); --> 새 컬럼 만들고 NULL로 초기화

-- LNAME 컬럼 추가 (기본값을 지정한 채로)
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국'; --> 새 컬럼 만들고 지정한 기본값으로 초기화
------------------------------------------1-1 추가 (ADD)

------------------------------------------1-2 컬럼수정 (MODIFY)
-- DEPT_ID 컬럼의 데이터 타입을 CHAR(3)으로 변경 
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);
ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;        -- 오류 발생 (데이터 값이 이미 있어서 CHAR -> NUMBER로 변경이 안됨 ..)
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(30);   -- 들어 있는 데이터가 변경하려는 값을 초과하는 값이 존재하면 변경 x

ALTER TABLE DEPT_COPY MODIFY CNAME NUMBER;      --> 값이 없으면 데이터타입 변경 가능


-- 다중 수정 
-- DEPT_COPY 테이블에서 DEPT_TITLE 컬럼 데이터 타입을 VARCHAR2(40), 
-- LOCATION_ID 컬럼의 데이터 타입을 VARCHAR2(2),
-- LNAME 컬럼의 기본값을 미국으로 변경 ㄱㄱ
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40) 
                      MODIFY LOCATION_ID VARCHAR2(2)
                      MODIFY LNAME DEFAULT '미국';
------------------------------------------1-2 컬럼수정 (MODIFY)

------------------------------------------1-3 컬럼 삭제
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY DROP COLUMN LNAME;

SELECT * FROM DEPT_COPY;

ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE;        --> 참조되고 있는 컬럼이 있으면 삭제 불가능함
ALTER TABLE MEMBER_GRADE DROP COLUMN GRADE_CODE CASCADE CONSTRAINTS;   --> 참조 되고 있을때 강제 삭제하는법 (조심해야 할듯..?)
SELECT * FROM MEMBER_GRADE;
------------------------------------------1-3 컬럼 삭제

------------------------------------------1-4 컬럼명 변경
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO LOCATION_NAME;
------------------------------------------1-4 컬럼명 변경
--



/*
    2. 제약조건 추가/ 삭제
        1) 제약조건 추가
            - PRIMARY KET : ADD [CONSTRAINT 제약조건명] PRIMARY KEY(컬럼명);
            - FORIGN KET : ADD [CONSTRAINT 제약조건명] FORIGN KEY(컬럼명) REFERENCES 테이블명 [(컬럼명)];
            - UNIQUE : ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명);
            - CHECK : ADD [CONSTRAINT 제약조건명] CHECK(컬럼명);
            - NOT NULL : MODIFY 컬럼명 [CONSTRAINT 제약조건명] NOT NULL;
        2) 제약조건 삭제
            - NOT NULL : ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;
            - 나머지 : ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
        3) 컬럼명(위에서 함 MODIFY로)/제약조건명/테이블명 변경
            - 제약조건명 변경 ALTER TABLE 테이블명 RENAME CONSTRAINT 기존 제약조건명 TO 변경할 제약조건명;
            - 테이블명 변경  ALTER TABLE 테이블명 RENAME TO 변경할 테이블명;
                           RENAME 기존테이블명 TO 변경할 테이블명;
*/
DROP TABLE DEPT_COPY;
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;

------------------------------------------2-1 제약조건 추가
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_DEPT_ID_PK PRIMARY KEY(DEPT_ID);
------------------------------------------2-1 제약조건 추가

------------------------------------------2-2 제약조건 삭제
-- DEPT_COPY 테이블의 DEPT_COPY_DEPT_ID_PK 제약조건 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DEPT_COPY_DEPT_ID_PK;
------------------------------------------2-2 제약조건 삭제

------------------------------------------2-3 컬럼명/제약조건명/테이블명 변경
-- 2-3-2 제약조건명 변경
ALTER TABLE DEPT_COPY ADD CONSTRAINT DEPT_COPY_DEPT_ID_PK PRIMARY KEY(DEPT_ID); -- 위에서 삭제 했으니까 추가하고
ALTER TABLE DEPT_COPY RENAME CONSTRAINT DEPT_COPY_DEPT_ID_PK TO DEPT_COPY_DEPT_ID_PRIMARY_KEY;

-- 2-3-3 테이블명 변경
RENAME DEPT_COPY TO DEPT_TEST;
SELECT * FROM DEPT_TEST;
------------------------------------------2-3 컬럼명/제약조건명/테이블명 변경


/*
    3. DROP : 오라클에서 제공하는 객체를 삭제하는 구문
*/
DROP TABLE DEPT_TEST;

-- 참조되고 있는 부모테이블은 함부로 삭제 안됨
DROP TABLE MEMBER_GRADE;


-- 만약 삭제하려고 하면...
-- 방법 1. 자식 테이블 먼저 삭제하고 부모테이블 삭제함
DROP TABLE MEMBER; DROP TABLE MEMBER_GRADE;

-- 방법 2. 그냥 부모 테이블만 삭제하는데 제약조건까지 같이 삭제하는 법
DROP TABLE MEMBER_GRADE CASCADE CONSTRAINTS;









CREATE TABLE MEMBER_GRADE (
    GRADE_CODE NUMBER,
    GRADE_NAME VARCHAR2(20) NOT NULL,
    CONSTRAINT MEMBER_GRADE_PK PRIMARY KEY(GRADE_CODE)
);
INSERT INTO MEMBER_GRADE VALUES(10, '일반회원');
INSERT INTO MEMBER_GRADE VALUES(20, '우수회원');
INSERT INTO MEMBER_GRADE VALUES(30, '특별회원');
-- 자식테이블
CREATE TABLE MEMBER (
    NO NUMBER,
    ID VARCHAR2(20) NOT NULL,
    PASSWORD VARCHAR2(20) NOT NULL,
    NAME VARCHAR2(15)NOT NULL,
    GENDER CHAR(3),
    AGE NUMBER,
    GRADE_ID NUMBER CONSTRAINT MEMBER_GRADE_ID_FK REFERENCES MEMBER_GRADE (GRADE_CODE),
    ENROLL_DATE DATE DEFAULT SYSDATE,
    CONSTRAINT MEMBER_NO_PK PRIMARY KEY(NO),
    CONSTRAINT MEMBER_ID_UQ UNIQUE(ID),
    CONSTRAINT MEMBER_GENDER_CK CHECK(GENDER IN ('남', '여')),
    CONSTRAINT MEMBER_AGE_CK CHECK(AGE > 0)
);
INSERT INTO MEMBER VALUES(1, 'USER1', '1234', '문인수', '남', 25, 10, DEFAULT);
INSERT INTO MEMBER VALUES(2, 'USER2', '1234', '성춘향', '여', 18, NULL, DEFAULT);
SELECT * FROM MEMBER_GRADE;
SELECT * FROM MEMBER;
