-- 1. 학과 이름과 계열을 표시하시오.. 단 헤더는 학과명, 계열으로 표시
select DEPARTMENT_NAME "학과명", CATEGORY "계열"
FROM TB_DEPARTMENT;


-- 2. 학과의 학과 정원을 XXXXX과의 정원은 XX명 입니다. 출력
select DEPARTMENT_NAME || '의 정원은 ' || CAPACITY || '명 입니다.'
FROM TB_DEPARTMENT;


-- 3. 국어 국문학과 여학생중 휴학중인 여학생 찾아달라고 함.
select student_NAME 
from tb_student
WHERE 
    department_no = (select DEPARTMENT_NO
                     FROM tb_department
                     WHERE department_name = '국어국문학과') 
    AND ABSENCE_YN = 'Y'
    AND SUBSTR(STUDENT_SSN, INSTR(STUDENT_SSN, '-') + 1 , 1) = 2;
 

-- 4. 도서관에서 대출 도서 장기 연체자 찾아서 이름 게시해달래 대상자 학번이 A513079, A513090, A513091, A513110, A513119 임!
select student_name
from tb_student
where student_no IN ('A513079','A513090','A513091','A513110','A513119');


-- 5. 입학정원이 20~30명 이상이하인 학과들의 이름과 계열 제출 !
select department_name, category
from tb_department
where capacity between 20 and 30;


-- 6. 총장제외 모든 교수가 소속학과가 있는데 그럼 총장 이름알아낼 수 있는 sql문
select professor_name
from tb_professor
where department_no is null;


-- 7. 전산 ㄴ착오로 학과가 지정되지 않은 학생 있는지 확인~
select student_name
from tb_student
where department_no is null;


-- 8. 선수과목 여부 확인해야 하는데 선수과목이 존재하는 과목은 어떤 과목인지?
select class_no
from tb_class
where preattending_class_no is not null;


-- 9. 언떤 계열들이 있는지 조사해보슈
select distinct category
from tb_department;


-- 10. 02학번 전주 거주자 모임 만들라는데 휴학생 빼고 재학생 학번 이름 주민번호 출력해보세유
select student_no, student_name, student_ssn
from tb_student
where student_address like '%전주%' and entrance_date = '2002/03/01' and absence_yn = 'N';

















