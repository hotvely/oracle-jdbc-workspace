/*
    서브쿼리(SUBQUERY) : 하나의 SQL문 안에 포함된 또 다른 SQL문.ㅋㅋㅋㅋㅋ참 쉽죠?ㅋㅋㅋㅋㅋ
*/

-- 간단한 서브쿼리 예시1
-- 노옹철 사원과 같은 부서원들을 조회
-- 1) 먼저 노옹철 사원의 부서코드를 조회

SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '노옹철');

-- 전직원의 평균 급여보다 많은 급여를 받는 사번, 사원명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT AVG(SALARY)FROM EMPLOYEE);



/*
    서브 쿼리의 분류
    - 서브쿼리를 수행한 결과값이 몇 행 몇 열이냐에 따라서 분류됨
    - 서브쿼리의 종류에 따라 서브쿼리 앞에 붙는 연산자가 달라짐;
    
    1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
    - 서브쿼리의 조회 결과 값의 개수가 온리 1개 일때 (한 행 한 열)
    - 일반 비교 연산자 사용가능함 : = !=, ^=, >, <, >=, <=,...
    
*/
-- 노옹철 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서명, 직급코드, 급여 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_CODE, SALARY
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME ='노옹철');
SELECT SUM(SALARY)FROM EMPLOYEE GROUP BY DEPT_CODE;
-- 부서별 급여의 합이 가장 큰 부서의 부서코드, 급여의 합 조회
SELECT DEPT_CODE, SUM(SALARY) "급여합" 
FROM EMPLOYEE 
GROUP BY DEPT_CODE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY)) FROM EMPLOYEE GROUP BY DEPT_CODE);

-- 전지연 사원이 속해있는 부서원들의 사번, 사원명, 전화번호, 직급명, 부서명, 입사일 조회( 단, 전지원사원은 제외)
SELECT 
EMP_ID,
EMP_NAME,
PHONE,
JOB_NAME,
DEPT_TITLE,
HIRE_DATE
FROM EMPLOYEE
JOIN JOB ON JOB.JOB_CODE = EMPLOYEE.JOB_CODE
JOIN DEPARTMENT ON DEPARTMENT.DEPT_ID = EMPLOYEE.DEPT_CODE
WHERE EMP_NAME != '전지연' AND
                  DEPT_CODE = (SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME LIKE '%전지연%');





-- 
-- 사수에 해당하는 사번 조회

select
distinct manager_id 
from employee where manager_id is not null;

-- 사번이 위와 같은 직원들의 사번, 이름 부서코드 조회;
-- 유니온 써서 합치믄 됨;
-- 일반 사원에 해당하는 직원들의 사번, 이름, 부서코드 구분 조회
select emp_id, emp_name, dept_code, '사수' as "구분"
from employee
where emp_id in (select distinct manager_id 
                        from employee where manager_id is not null)                        
union                        
select emp_id, emp_name, dept_code, '사원' as "구분"
from employee
where emp_id not in (select distinct manager_id 
                        from employee where manager_id is not null);


-- select 절에서 서브 쿼리 사용하는 법
select
emp_id, emp_name, dept_code
case when emp_id in (select distinct manager_id from employee
                        where manager_id is not null) then '사수'
                        else '사원'
                        end as "구분"
from employee;


/*
    비교대상 > any(서브쿼리) : 여러개의 결과값 중에서 "한개라도" 클경우 (여러개의 결과값 중에서 가장 작은 값보다 클 경우)
    비교대상 < any(서브쿼리) : 여러개의 결과값 중에서 "한개라도" 작을 경우 (여러 결과값 중에서 가장 큰 값 보다 작을 경우)
*/

-- 대리 직급임에도 과장 직급들의 최소 급여보다 많이 받는 직원의 사번, 이름, 직급명, 급여 조회
-- 과장 직급 급여
select salary
from employee e
join job j using(job_code)
where j.job_name = '과장'; 

-- 직급이 대리인 직원들 중 위 값 목록중에 하나라도 큰경우;
select emp_id, emp_name, j.job_name, salary
from employee e
join job j using(job_code)
where j.job_name = '대리' 
and salary  > any (select salary
                from employee e
                join job j using(job_code)
                where j.job_name = '과장');


/*
    비교대상 > all(서브쿼리) : 여러개의 '모든' 결과값들 보다 클 경우 
    비교대상 < all(서브쿼리) : 여러개의 '모든' 결과값들 보다 작은 경우
*/
-- 과장 직급인데도 차장 직급 최대 급여보다 더 많이 받는 직원들의 사번, 이름, 직급, 급여

-- 차장 직급
select salary
from employee e
join job j using(job_code)
where job_name = '차장';

-- 과장직급인데도 큰경우
select emp_id, emp_name, job_name, salary
from employee
join job using(job_code)
where job_name = '과장' 
and salary >  all (select salary
                    from employee e
                    join job j using(job_code)
                    where job_name = '차장');


/*
    3. 다중열 서브쿼리
    - 서브쿼리의 조회 결과값이 한 행이지만, 컬럼이 여러개 일 떄 (한행 여러열)
*/
-- 하이유 사원과 같은 부서코드, 같은 직급 코드에 해당하는 사원 조회
-- 하이유 부서코드, 직급코드
select dept_code "부서코드", job_code "직급코드"
from employee
where emp_name = '하이유';
-- 즉, 부서코드 d5이면서 직급코드 j5인 사람 조회
select emp_name, dept_code, job_code
from employee
where dept_code = 'D5' and job_code = 'J5';

-- 단일행 서브쿼리로 작성
select emp_name, dept_code, job_code
from employee
where dept_code = select dept_code
from employee
where emp_name = '하이유'
        and job_code = select job_code form employee where emp_name = '하이유';

-- 다중 열 서브쿼리 사용해서 작성하는법
select emp_name, dept_code, job_code
from employee
where (dept_code, job_code) = (('D5','J5'));



-- 박나라 사원과 직급코드가 일치하면서 같은 사수를 가지고 있는 사원의 사번, 이름, 직급코드, 사수사번 조회
select emp_id, emp_name, job_code, manager_id
from employee
where (job_code, manager_id) = ( select job_code, manager_id from employee where emp_name = '박나라');
--where (job_code, manager_id) in ( select job_code, manager_id from employee where emp_name = '박나라');

select emp_id, emp_name, job_code, manager_id
from employee
where (job_code, manager_id) = (( 'J7','207'));

/*
    다중행 다중열 서브쿼리
    - 서브쿼리의 조회 결과 값이 여러 행, 여러 열 일 경우
*/

-- 각 직급별로 최소 급여를 받는 사원들의 사번, 이름, 직급 코드, 급여 조회
select emp_id, emp_name, job_code, salary
from employee
where (salary) in (select min(salary) from employee group by job_code);


/*
    인라인 뷰
    - FROM 절에 서브쿼리를 제시하고, 서브쿼리를 수행한 결과를 테이블 대신 사용함
*/

--직원 중 급여가 가장 높은 상위 5명 순위, 이름, 급여 조회
--rownum : 오라클에서 제공하는 컬럼, 조회된 순서대로 1번부터 순번을 부여하는 컬럼

select rownum ,emp_name, salary
from (select emp_name, salary
from employee
order by salary desc)
where rownum <= 5;


-- 부서별 평균 급여가 높은 3개 부서의 부서 코드, 평균 급여 조회
select rownum, dept_code, AVG_SALARY
from 
(
select  dept_code, round(avg(nvl(salary,0)))as "AVG_SALARY"
from employee
group by dept_code
order by avg(nvl(salary,0)) desc
)
where rownum <= 3;

-- 2) with를 사용하는 방법
with topn_sal as
(
select  dept_code, round(avg(nvl(salary,0)))as "어이없네"
from employee
group by dept_code
order by avg(nvl(salary,0)) desc
)
select rownum, dept_code, 어이없네
from topn_sal
where rownum <= 3;


/*
    rank 함수
    - rank() over(정렬기준) : 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너 뛰고 순위를 계산한다
    ex) 공동1위가 2명이면 다음 순위는 3위가 됨
    - dense_rank() over(정렬기준) : 동일한 순위 이후의 등수를 무조건 1씩 증가 시킨다.
    ex) 공동1위가 2명이어도 다음 순위는 2위가 됨
*/
-- 사원별 급여가 높은 순서대로 순위 매겨서 순위, 사원명, 급여 조회
-- 공동 19위 2명 뒤 순위 21위 시작
select rank() over(order by salary desc) "ㅇ", emp_name, salary
from employee;

-- 공동 19위 2명 뒤 순위 20위 시작
select dense_rank() over(order by salary desc), emp_name, salary
from employee;



-- 아래 방법의 뭐.. 불가능한 대체 방법은 아닌데 자르는 와중에 문제가 좀 있음 !
-- 20위로 하면 장쯔위하고 하동운 사이에 원래 4명인가 있어야 되는데 지금 짤라 보니까 다 안나옴;;ㅋㅋ

-- 상위 5명만 조회 정석 방법
select RNAK, emp_name, salary 
from
(
select rank() over(order by salary desc) RNAK , emp_name, salary
from employee
)
where RNAK <= 20;



