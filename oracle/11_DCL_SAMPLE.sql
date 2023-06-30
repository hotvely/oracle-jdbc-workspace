-- 3. SAMPLE 계정에서 테이블 생성할 수 있는 CREATE TABLE 권한 부여
CREATE TABLE TEST
(
    TID NUMBER

);


SELECT * FROM TEST;

-- 4. 생성한 테이블에 데이터를 넣을 수 있는  UNLIMITED TABLESPACE(테이블,뷰,인덱스 등 객체저장공간) 접근 권한 부여
INSERT INTO TEST VALUES(1);


-- 5. KH.EMPLOYEE 테이블을 조회할 수 있는 권한 부여 하고 싶음..ㅠㅠ
SELECT * FROM KH.EMPLOYEE;
INSERT INTO KH.DEPARTMENT(DEPT_ID, DEPT_TITLE, LOCATION_ID) VALUES ('D0', '개발부', 'L1');

SELECT * FROM KH.DEPARTMENT;
