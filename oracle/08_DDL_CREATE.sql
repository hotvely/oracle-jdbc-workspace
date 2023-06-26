/*
    DDL(DATA DEFINITION LANGUAGE) : 데이터 정의어
    - 오라클에서 제공하는 객체(OBJECT) / 스키마(SCHEMA)를 만들고(CREATE), 변경하고(ALTER), 삭제(DROP)하는 언어
    - 즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어로 주로 DB관리자나 설계자가 사용함

    * 오라클에서 객체(구조) : 테이블(TABLE), 뷰(VIEW), 시퀀스(SEQUENCE),
                            인덱스(INDEX), 패키지(PACKAGE),
                            트리거(TRIGGER), 프로시저(PROCEDURE),
                            함수(FUNCTION), 동의어(SYNONYM), 사용자(USER)


*/

/*
    * CREATE 
    - 객체를 생성하는 구문
    
    * 테이블 생성
    - 테이블이란? : 행(ROW)와 열(COLUMN)로 구성되는 가장 기본적인 데이터 베이스 객체
                  데이터베이스 내 모든 데이터는 테이블에 저장됨

    [표현식]
    CREATE TABLE 테이블명(
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        컬럼명 자료형(크기),
        ...
    );
    
    * 자료형
    1. 문자(CHAR/ VARCHAR2)
        - CHAR : 최대 2000BYTE까지 저장 가능
                 고정길이 (아무리 적은 값이 들어와도 처음 할당된 크기 그대로)
                 고정된 글자수의 데이터만이 담길 경우 사용..
        - VARCHAR2 : 최대 4000BYTE까지 저장가능
                 가변길이 (담긴 값에 따라 사이즈 변함)
                 몇글자의 데이터가 들어올지 모를 경우 사용함
    2. 숫자(NUMBER)
    3. 날짜(DATE)

*/
-- 회원에 대한 데이터를 담을 MEMBER TABLE 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PWD VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR(50),
    MEM_DATE DATE
);

/*
    테이블 구조를 표시해 주는 구문
*/
DESC MEMBER;
--이름       널? 유형           
---------- -- ------------ 
--MEM_NO      NUMBER       
--MEM_ID      VARCHAR2(20) 
--MEM_PWD     VARCHAR2(20) 
--MEM_NAME    VARCHAR2(20) 
--GENDER      CHAR(3)      
--PHONE       VARCHAR2(13) 
--EMAIL       VARCHAR2(50) 
--MEM_DATE    DATE 



/*
    데이터 딕셔너리
    - 다양한 객체들의 정보를 저장하고 있는 시스템 테이블
    - 사용자가 객체를 생성하거나 객체를 변경하는 등의 작업을 할 때 데이터베이스 서버에 의해서 자동으로 갱신되는 테이블
*/
-- USER_TABLES : 사용자가 가지고 있는 테이블들의 전반적인 구조를 확인할 수 있는 시스템 테이블
SELECT * FROM USER_TABLES;
SELECT * 
FROM USER_TABLES
WHERE TABLE_NAME = 'MEMBER';

-- USER_TAB_COLUMNS : 사용자가 가지고 있는 테이블들 상의 모든 컬럼구조를 전반적으로 확인 할 수 있는 시스템 테이블
SELECT * FROM USER_TAB_COLUMNS;


/*
    컬럼 주석
    - 테이블 컬럼에 대한 설명을 작성할 수 있는 구문
    
    [표현법]
    COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

*/
    COMMENT ON COLUMN MEMBER.MEM_NO IS '회원번호';
    COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
    COMMENT ON COLUMN MEMBER.MEM_PWD IS '회원비밀번호';
    COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
    COMMENT ON COLUMN MEMBER.GENDER IS '성별(남/여)';
    COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
    COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
    COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';



/*
    테이블에 데이터 추가 (DML : INSERT)
    - INSERT INTO 테이블이름 VALUES(VALUE1, VALUE2, VALUE3....);
*/
INSERT INTO MEMBER VALUES(1, 'user01', 'pass01', '홍길동', '남', '010-1111-2222', 'aaa@naver.com', '23/06/26');
INSERT INTO MEMBER VALUES(2, 'user02', 'pass02', '홍길녀', '여', NULL, NULL, SYSDATE);
INSERT INTO MEMBER VALUES(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
SELECT * FROM MEMBER;


/*
    * 제약 조건(CONSTRAINT) 
    - 사용자가 원하는 조건의 데이터만 유지 하기 위해서 각 컬럼에 대해 저장될 값에 대한 제약조건을 설정함
    - 제약 조건은 데이터 무결성 보장을 목적으로 한다.
        (데이터의 정확성과 일관성을 유지 시키는 것 !)
    - 종류 : NOT NULL, UNIQUE, CHECK, PRIMARY KEY, FOREIGN KEY
    
    [표현법]
    1) 컬럼 레벨 방식
    CREATE TABLE 테이블이름 ( 컬럼명 자료형(크기) [CONSTRAINT 제약조건명] 제약조건, ..... );
    2) 테이블 레벨 방식
    CREATE TABLE 테이블이름 
    ( 
        컬러명 자료형(크기), 
        ....... 
        [CONSTRAINT 제약조건명] 제약조건(컬럼명)
    )
*/


/*
    * NOT NULL 제약조건
    - 해당 컬럼에 반드시 값이 존재해야만 하는 경우 (즉, 해당 컬럼에 절대 NULL이 들어와서는 안되는 경우)
    - 삽입/수정시 NULL값을 허용하지 않도록 제한
    - 오로지 컬럼 레벨 방식으로만 설정 가능 !
*/
CREATE TABLE MEM_NOTNULL(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) ,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)  
    
);

INSERT INTO MEM_NOTNULL VALUES(1, 'user01', 'pass01', '홍길동', '남', NULL, NULL);
INSERT INTO MEM_NOTNULL VALUES(2, 'user02', NULL, '김말순', '여', NULL, 'aaa@naveR.com');
--> NOT NULL 제약조건에 위배되어 오류 발생중.
INSERT INTO MEM_NOTNULL VALUES(2, 'user01', 'pass02', '강개똥', NULL,NULL,NULL);

SELECT * FROM MEM_NOTNULL;


/*
    UNIQUE 제약조건
    - 해당 컬럼에 중복된 값이 들어와서는 안 되는 경우
    - 컬럼값에 중복값을 제한하는 제약조건
    - 삽입/수정시 기존에 있는 데이터 값 중 중복값이 있을 경우 오류 발생!
*/

-- 컬럼 레벨 방식
CREATE TABLE MEN_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) ,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)  
);

DROP TABLE MEN_UNIQUE;

-- 테이블 레벨 방식 (모든 컬럼 나열한 이후 맨 마지막에 기술)
CREATE TABLE MEN_UNIQUE(
    MEM_NO NUMBER NOT NULL,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) ,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    UNIQUE(MEM_NO, MEM_ID, EMAIL)
);

INSERT INTO MEN_UNIQUE VALUES(1, 'user01', 'pass01', '홍길동', '남', NULL, NULL);
INSERT INTO MEN_UNIQUE VALUES(1, 'user01', 'pass02', '강개똥', NULL,NULL,NULL);
--> UNIQUE 제약조건에 위배되었으므로 INSERT 실패
--> 오류 구문에 제약조건명으로 알려줌
--> 제약 조건 부여시 제약조건이름을 지정하지 않으면 시스템에서 임의의 이름을 부여함
SELECT * FROM MEN_UNIQUE;



/*
    * ,제약조건 부여시 이름까지 지어주는법
    > 컬렘레벨방식
    CREATE TABLE 테이블이름 ( 컬럼명자료형[CONSTRAINT 제약조건명] 제약조건,...);
     > 테이블레벨방식
    CREATE TABLE 테이블이름 ( 컬럼명 자료형, .... 
                            CONSTRAINT 제약조건명 제약조건(컬럼));
*/
DROP TABLE MEN_UNIQUE;

CREATE TABLE MEM_UNIQUE
(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL,
    MEM_ID VARCHAR2(20) CONSTRAINT MEMID_NN NOT NULL,
    MEM_PWD VARCHAR2(20) CONSTRAINT MEMPWD_NN NOT NULL,
    MEM_NAME VARCHAR2(20) CONSTRAINT MEMRENAME_NN NOT NULL,
    GENDER CHAR(3) ,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMID_UQ UNIQUE(MEM_ID)
);

INSERT INTO MEM_UNIQUE VALUES(1,'user01', 'pass01', '홍길동', NULL,NULL,NULL);
INSERT INTO MEM_UNIQUE VALUES (2, 'user02', 'pass02', '홍길녀', 'ㅇ', NULL,NULL);
SELECT * FROM MEM_UNIQUE;


/*
    CHECK(조건식) 제약조건 
    - 해당 컬럼에 들어올 수 있는 값에대한 조건 제시 가능
    - 해당 조건에 만족하는 데이터만 담길 수 있음
*/

CREATE TABLE MEM_CHECK(
    MEM_NO NUMBER  NOT NULL,
    MEM_ID VARCHAR2(20)  NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20)   NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50)
);
INSERT INTO MEM_CHECK VALUES(1,'user01', 'pass01', '홍길동', '남',NULL,NULL);
INSERT INTO MEM_CHECK VALUES(2,'user02', 'pass02', '홍길녀', 'ㅇ', NULL,NULL);
INSERT INTO MEM_CHECK VALUES(2,'user02', 'pass02', '홍길녀', '여',NULL,NULL);

SELECT * FROM MEM_CHECK;
INSERT INTO MEM_CHECK VALUES(2, 'user03' ,'pass03', '강개순', '여', NULL, NULL);



/*
    PRIMARY KEY (기본키) 제약조건
    - 테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자 역할)
    ex) 회원번호, 학번, 사원번호, 부서코드, 직급코드, 주문번호, 예약번호, 운송장번호, ..... 등등
    - PRIMARY KEY 제약조건을 부여하면 컬럼에 자동으로 NOT NULL + UNIQUE 제약조건이 설정된당. 굿!bb
    - 한 테이블당 오로지 한개만 설정 가능함 ㅠㅠㅠㅠ
*/
CREATE TABLE MEM_PRI(
    MEM_NO NUMBER,  -- CONSTRAINT MEMNO_PK PRIMARY KEY,     --> 컬럼 레벨상식
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    CONSTRAINT MEMNO_PK PRIMARY KEY(MEM_NO) --> 테이블 레벨방식
);

INSERT INTO MEM_PRI VALUES(1,'USER01','PASS01', '강개순','여','010-1111-2222', NULL);
INSERT INTO MEM_PRI VALUES(1,'USER02','PASS02', '이순신','남','010-2222-3333', NULL);   --> 기본키 중복값 담으려고 할때 (UNIQUE계약조건 위배)
INSERT INTO MEM_PRI VALUES(NULL,'USER02','PASS02', '이순신','남','010-2222-3333', NULL);    --> PRIMARY KEY 계약은 NOT NULL 조건이 기본계약으로 들어감.


SELECT * FROM MEM_PRI;


CREATE TABLE MEM_PRI2(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20) NOT NULL,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')) NOT NULL,
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    PRIMARY KEY(MEM_NO, MEM_ID) --> 묶어서 PRIMARY KEY 제약조건 부여는 가능함;;;;;;;;;(복합키)
);

INSERT INTO MEM_PRI2 VALUES (1, 'USER01', 'PASS01', 'HONG GIL DONG', '남',NULL,NULL);
INSERT INTO MEM_PRI2 VALUES (1, 'USER02', 'PASS02', 'HONG GIL ZERO', '여',NULL,NULL);

-- 복합키 사용 예시 (어떤 회원이 어떤 상품을 찜하는지에 대한 데이터를 보관하는 테이블)
CREATE TABLE TB_LIKE(
    MEM_NO NUMBER,
    PRODUCT_NAME VARCHAR2(10),
    LIKE_DATE DATE,
    PRIMARY KEY (MEM_NO, PRODUCT_NAME)

);
INSERT INTO TB_LIKE VALUES (1, 'A', SYSDATE);
INSERT INTO TB_LIKE VALUES (1, 'B', SYSDATE);
INSERT INTO TB_LIKE VALUES (1, 'A', SYSDATE);



-- 회원 등급에 대한 데이터를 보관하는 테이블
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
    
);
INSERT INTO MEM_GRADE VALUES (10, '일반회원');
INSERT INTO MEM_GRADE VALUES (20, '우수회원');
INSERT INTO MEM_GRADE VALUES (30, '특별회원');
SELECT * FROM MEM_GRADE;

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER     --> 회원 등급 번호 보관할 컬럼
);
INSERT INTO MEM VALUES(1, 'user01', 'pass01', '홍길순', '여', NULL, NULL,NULL);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '김말똥', NULL, NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '강개순', '남', NULL, NULL, 40);

--> 유효한 회원등급 번호가 아님에도 불구하고 INSERT !! 아직 연결이 되지 않음..
SELECT * FROM MEM;

/*
    * FOREIGN KEY(외래키) 제약조건
    - 외래키 역할을 하는 컬럼에 부여하는 제약조건
    - 다른 테이블에 존재하는 값만 들어와야 되는 특정 컬럼에 부여하는 제약조건 (단, NULL값도 가질 수 있음)
    --> 다른 테이블을 참조한다라고 표현함.
    --> 주로 , FOREIGN KEY 제약조건에 의해 테이블 간의 관계 형성됨
    
    [표현법]
    > 컬럼 레벨방식
    컬럼명 자료형 [CONSTRAINT 제약조건명] REFERENCES 참조할테이블명 [(참조할컬럼명)]
    > 테이블 레벨방식
    [CONSTRAINT 제약조건명] FOREIGN KEY (컬럼명) REFERENCES 참조할테이블명 [(참조할컬럼명)]
    
    --> 참조할 컬럼명 생략시 참조할테이블명에 PRIMARY KEY로 지정된 컬럼으로 매칭
    
*/
DROP TABLE MEM;
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER CONSTRAINT ERROR_FOREIGN  REFERENCES MEM_GRADE(GRADE_CODE)   --> 컬럼레벨방식
    --, FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) --> 테이블 레벨방식
);

INSERT INTO MEM VALUES(1, 'user01', 'pass01', '홍길순', '여', NULL, NULL,NULL);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '김말똥', NULL, NULL, NULL, 10);
INSERT INTO MEM VALUES(3, 'user03', 'pass03', '강개순', '남', NULL, NULL, 40);


--> MEM_GRADE(부모테이블) -|-------<- MEM(자식테이블)
--> 이때 부모테이블(MEM_GRADE) 에서 데이터 값을 삭제하는 경우 문제 발생함 ㅠㅠ!!!
-- 데이터 삭제 : DELETE FROM TABLE_NAME WHERE 조건;
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;        -- 얘는 삭제 안됨 ㅋㅋ 자식 데이터에서 참조하고 있는 데이터가 잇어서~

DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30;        -- 얘는 삭제됨 ㅎㅎ
--> 자식 테이블에서 사용하고 있는 값이 있을 경우 부모 테이블로부터 무조건 삭제가 안되는 '삭제제한' 옵션이 걸려이씀

ROLLBACK;
SELECT * FROM MEM_GRADE;
/*
    자식 테이블 생성시 외래키 제약조건 부여할 때 삭제옵션 지정가능
    * 삭제옵션 : 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블의 값을 어떻게 처리할지
    
    - 1) ON DELETE RESTRICTED (기본값) : 삭제 제한옵션으로, 자식데이터로 쓰이는 부모 데이터는 삭제 아예 안되게끔
    - 2) ON DELETE SET NULL : 부모데이터 삭제시 해당 데이터를 사용하고 있는 자식 데이터의 값을 NULL로 변경함~
    - 3) ON DELETE CASCADE : 부모 데이터 삭제시 해당 데이터를 사용중인 자식 데이터 같이 삭제시킴
*/
DROP TABLE MEM;
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PWD VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN ('남','여')),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    GRADE_ID NUMBER CONSTRAINT ERROR_FOREIGN  REFERENCES MEM_GRADE(GRADE_CODE) ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'user01', 'pass01', '홍길순', '여', NULL, NULL,NULL);
INSERT INTO MEM VALUES(2, 'user02', 'pass02', '김말똥', NULL, NULL, NULL, 10);

DELETE FROM MEM_GRADE WHERE GRADE_CODE = 10;     
DELETE FROM MEM_GRADE WHERE GRADE_CODE = 30;      

ROLLBACK;
SELECT * FROM MEM_GRADE;
SELECT * FROM MEM;





















