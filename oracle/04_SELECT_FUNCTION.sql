/*
    함수 : 전달된 컬럼값을 읽어들여서 함수를 실행한 결과를 반환
    - 단일행 함수 : N 개의 값을 읽어서 N 개의 결과값을 리턴 (매 행마다 함수 실행 결과 반환)
    - 그룹 함수 : N 개의 값을 읽어서 1개의 결과값을 리턴 (그룹별로 함수 실행 결과 반환)
    >> SELECT 절에 단일행 함수와 그룹 함수는 함께 사용하지 못함!
    왜? 결과 행의 갯수가 다르기 때문에!
    >> 함수식을 기술할 수 있는 위치 : SELECT, WHERE, ORDER BY, GROUP BY, HAVING
*/
-- 단일행 함수---------------------------------------------------------------------
/*
    문자 처리 함수
    LENGTH / LENGTHB
    - LENGTH(컬럼|'문자열값') : 해당 값의 글자 수 반환
    - LENGTHB(컬럼|'문자열값') : 해당 값의 바이트 수 반환
    한글 한 글자 -> 3BYTE
    영문자, 숫자, 특수문자 한 글자 -> 1BYTE
*/
select
length('오라클'), LENGTHB('오라클'),
length('ORACLE'), LENGTHB('ORACLE')
from DUAL; -- 가상테이블
-- 사원명, 사원명의 글자 수, 사원명의 바이트 수, 이메일, 이메일의 글자 수, 이메일의 바이트 수 조회
select
    EMP_NAME, length(EMP_NAME), LENGTHB(EMP_NAME),
    EMAIL, length(EMAIL), LENGTHB(EMAIL)
from EMPLOYEE;
/*
    INSTR
    - INSTR('STRING', 'STR' [, POSITION, OCCURRENCE])
    - 지정한 위치부터 지정된 숫자 번째로 나타나는 문자의 시작 위치를 반환
    설명
    - STRING : 문자 타입 컬럼 또는 문자열
    - STR : 찾으려는 문자열
    - POSITION : 찾을 위치의 시작 값(기본값1)
      1 : 앞에서부터 찾는다.
     -1 : 뒤에서부터 찾는다.
    - OCCURRENCE : 찾을 문자값이 반복될 때 지정하는 빈도(기본값1)
                   음수 사용 불가
*/
select INSTR('AABAACAABBAA', 'B') from DUAL;
select INSTR('AABAACAABBAA', 'B', -1) from DUAL;
select INSTR('AABAACAABBAA', 'B', 1, 2) from DUAL;
-- 's' 가 포함되어있는 이메일 중 이메일, 이메일의 @ 위치, 이메일에서 뒤에서 2번째에 있는 's'위치 조회
select EMAIL, INSTR(EMAIL,'@'), INSTR(EMAIL, 's', -1, 2)
from EMPLOYEE
where EMAIL like '%s%';



/*
    LPAD / RPAD
    - 문자열을 조회할 때 통일감있게 조회하고자 할 때 사용
    - LPAD / RPAD (STRING, 최종적으로 반환할 문자의 길이, [덧붙이고자하는문자])
*/
select LPAD('hello', 10) -- 덧 붙이고자하는 문자 생략시 공백으로 채움
from DUAL;
select LPAD('hello', 10, '@') 
from DUAL;
select RPAD('hello', 10) 
from DUAL;
select RPAD('hello', 10, '@') 
from DUAL;


/*
    LTRIM / RTRIM
    - 문자열에서 특정 문자를 제거한 나머지를 반환
    - LTRIN / RTRIM (STRING, [제거하고자하는 문자])
    - 문자열의 왼쪽 또는 오른쪽에서 제거하고자하는 문자를 찾아 제거한 나머지를 리턴
*/
-- 제거하고자하는 문자 생략시 기본값으로 공백제거 !
select ltrim( rtrim('hhellow', 'w'), 'h')
from DUAL;

select ltrim('ACABACCKH', 'ABC') from DUAL;
select rtrim('5782kh12', '0123456789') from DUAL;


/*
    TRIM
    - 문자열의 앞 뒤 양옆에 있는 지정한 문자를 제거한 나머지 문자열 반환
    - TRIM ([LEADING|TRAILING|BOTH] 제거하고자하는 문자들 FROM STRING)
    
*/
select trim('                      k  h            ') from DUAL;
select trim('z' from 'zzzzzzkhzzz') from DUAL;

select trim(leading 'z' from 'zzzzzzkzhzzz') from DUAL;     --LTRIM
select trim(trailing 'z' from 'zzzzzzkzhzzz') from DUAL;    --RTRIM
select trim(both 'z' from 'zzzzzzkzhzzz') from DUAL;        --BOTH


/*
    SUBSTR
    - 문자열에서 특정 문자열을 추출해서 반환함
    -SUBSTR(STRING, POSITION, [LENGTH])
        STRING : 문자타입 컬럼 또는 '문자열값'
        POSITION : 문자열을 추출할 시작위치값 (음수가능)
        LENGTH : 추출할 문자 개수 (생략시 끝까지)
*/
select SUBSTR('PROGRAMMING', 5, 2) from DUAL;
select SUBSTR('PROGRAMMING', -8, 3) from DUAL;

-- 여자 사원들의 이름만 조회
select EMP_NAME
from EMPLOYEE
where (select SUBSTR(EMP_NO, 8,1) from DUAL) in(2, 4);

-- 남자 사원들의 이름만 조회
select EMP_NAME
from EMPLOYEE
where not (select SUBSTR(EMP_NO, 8,1) from DUAL) in(2, 4);

-- 사원이름 주민번호 조회(991212-1*******..)
select EMP_NAME , RPAD(SUBSTR(EMP_NO, 0,8), 14, '*') from EMPLOYEE;

-- 직원 이름, 이메일, 아이디 (이메일에서 '@'앞 문자 ) 조회
select EMP_NAME, EMAIL, SUBSTR(EMAIL, 0, INSTR(EMAIL,'@') -1 ) "ID", EMP_ID
from EMPLOYEE;


/*
    LOWER(전부 소문자) / UPPER(전부 대문자) / INITCAP(단어 앞 글자마다 대문자)
*/
select lower('WELCOME to My World!') from DUAL;
select upper('WELCOME to My World!') from DUAL;
select INITCAP('wELCOME to my world!') from DUAL;

/*
    connat :  문자열 두개 받아서 합침
*/
select concat('가나다라', 1234) from DUAL;
select '가나다라' || 'abcd' from DUAL;      --연결 연산자와 동일함;

select '가나다라' ||'abcd' || '1234' from DUAL;


/*
    replace
    - replace (String, str1, str2);
    String : 컬럼 또는 문자열 (변경하기 전 문자열이나 컬럼값)
    str1 : 변경시키려고 하는 문자 혹은 문자열
    str2 : str1대신에 바꿔줄 문자열
*/
select replace('서울시 강남구 역삼동' , '역삼동', '삼성동') from DUAL;
-- 사원명, 이메일, 이메일변경한거 / email의 kh.or.kr -> gmail.com으로 변경해서 조회
-- ex) sun_di@kh.or.kr -> sun_di@gamil.com
select EMP_NAME "NAME", EMAIL "EMAIL", replace(EMAIL, 'kh.or.kr','gmail.com') "REPLACE EMAIL"
from EMPLOYEE;


/*---------------------------------------
    숫자 처리 함수들
---------------------------------------*/
/*
    ABS(NUMBER) : 숫자의 절대값을 구해주는 함수
*/
select abs(-10) from DUAL;

/*
    MOD(NUMBER1, NUMBER2) : 두 수를 나눈 나머지 값을 반환해주는 함수
*/
select mod(10, 3) from DUAL;

/*
    ROUND(NUMBER, position) : 반올림한 결과를 반환하는 함수
*/
select ROUND(123.656) from DUAL;
select ROUND(123.456, 2) from DUAL;
select ROUND(123.456, 1) from DUAL;
select ROUND(123.456, 0) from DUAL;
select ROUND(123.456, -1) from DUAL;
select ROUND(123.456, -2) from DUAL;

/*
    CEIL(NUMBER) : 올림한 결과를 반환하는 함수
*/
select CEIL(123.153) from DUAL;

/*
    FLOOR(NUMBER) : 소수점 아래 버림한 결과를 반환하는 함수
*/
select FLOOR(123.153) from DUAL;

/*
    TRUNC(NUMBER, pos) : 위치 지정 가능한 버림처리
*/
select trunc(123.952, -2) "-2번째", trunc(123.952, -1) "-1번째", trunc(123.952) "0번째",trunc(123.952, 1) "1번째", trunc(123.952, 2)"2번째" from DUAL;

/*
    날짜 처리 함수
    SYSDATE : system의 날짜를 반환 (현재 날짜)
*/
select SYSDATE from DUAL;
-- 날짜 포맷 변경
alter session set NLS_DATE_FORMAT = 'YYYY-MM-DD HH:MI:SS';
alter session set NLS_DATE_FORMAT = 'RR/MM/DD';  --기존 포멧으로 변경

/*
    MONTHS_BETWEEN (DATE1, DATE2) : 입력받는 두 날짜 사이의 개월 수 반환
*/
select MONTHS_BETWEEN(SYSDATE, '2023-05-21') from DUAL;
-- practice) 직원명, 입사일, 근무개월 수 조회
select EMP_NAME"이름", HIRE_DATE"입사일", trunc( MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무개월"
from EMPLOYEE;

/*
    ADD_MONTHS(DATE, NUMBER) : 특정날짜에 입력받는 숫자만큼의 개월 수를 더한 날짜를 반환해줌
*/
select ADD_MONTHS(SYSDATE, 5) from DUAL;
-- practice) 직원명, 입사일, 입사 후 6개월이 된 날짜 조회
select EMP_NAME "NAME", HIRE_DATE "입사날", ADD_MONTHS(HIRE_DATE, 6)"6개월차날짜" 
from EMPLOYEE;

/*
    NEXT_DAY (DATE, 요일(문자|숫자)) : 특정 날짜에서 구하려는 요일의 가장 가까운 날짜를 리턴
*/
select 
SYSDATE,
NEXT_DAY(SYSDATE, '목') "가까운 목요일?",
NEXT_DAY(SYSDATE, '금요일') "가까운 금요일?",
NEXT_DAY(SYSDATE, 4) "가까운 수요일? 0이 일요일~"
--NEXT_DAY(SYSDATE, 'THURSDAY') --현재 언어가 KOREAN 이기 때문에 에러나는거임;
from DUAL;

--언어 변경
alter session set NLS_LANGUAGE = AMERICAN;
alter session set NLS_LANGUAGE = KOREAN;

/*
    LAST_DAY(DATE) : 해당 월의 마지막 날짜를 반환함
*/
select LAST_DAY(SYSDATE) from DUAL;
select LAST_DAY('20230515') from DUAL;
select LAST_DAY('23/11/01') from DUAL;

-- 직원명, 입사일, 입사월의 마지막 날짜, 입사한 월에 근무한 일수 조회
select EMP_NAME"이름", HIRE_DATE"입사일", LAST_DAY(HIRE_DATE) "입사월의 마지막날" , LAST_DAY(HIRE_DATE) - HIRE_DATE + 1 "입사달 근무날" from EMPLOYEE;

/*
    EXTRACT (YEAR | MONTH | DAY FROM DATE) : 특정 날짜에서 연,월,일 정보를 추출해서 반환함
*/
-- 직원명, 입사년도, 입사월, 입사일로 조회
select 
EMP_NAME, 
extract(year from HIRE_DATE),
extract(month from HIRE_DATE),
extract(day from HIRE_DATE) 
from EMPLOYEE
order by 2,3,4,1 asc;





/*---------------------------------------
    형 변환 함수들
---------------------------------------*/
/*
    TO_CHAR(DATE | NUMBER, [FORAMTING]) : 날짜 OR 숫자형 데이터를 문자 타입으로 변환해서 반환
*/
select TO_CHAR(1234, 'L999999')from DUAL;       -- 현재 설정된 나라의 화폐단위가 나옴
select TO_CHAR(1234, '$99999999')from DUAL;     -- 
select TO_CHAR(1234, 'L99')from DUAL;           -- 포맷 자리수가 안맞아서
select TO_CHAR(1234, 'L9,999')from DUAL;        -- 
 
--직원명 급여 연봉 (위의 TO_CHAR이용해서) 조회
select EMP_NAME "이름", TO_CHAR(SALARY, '999,9999L') "월급", TO_CHAR(SALARY * 12, '999,999,999L') "인센제외 연봉"
from EMPLOYEE
order by 3 , "월급";
-- 날짜 -> 문자
select TO_CHAR(SYSDATE, 'AM HH12:MI:SS') from DUAL;
select TO_CHAR(SYSDATE, 'AM HH24:MI:SS') from DUAL;
select TO_CHAR(SYSDATE, 'MONTH dd, day, YYyy') from DUAL;
select TO_CHAR(SYSDATE, 'MONTH dd, dy, yyyy')from DUAL;
-- dy, day : 요일(수요일..)/ dd : 일(11일,24일)


-------------------- 년도와 관련된 포맷------------------
select 
    TO_CHAR(SYSDATE, 'YYYY'),       --2023
    TO_CHAR(SYSDATE,'YY'),          --23
    TO_CHAR(SYSDATE,'RRRR'),        --2023
    TO_CHAR(SYSDATE,'RR'),          --23
    TO_CHAR(SYSDATE,'YEAR')         --TWENTY TWENTY-THREE    
from DUAL;
-------------------- 년도와 관련된 포맷------------------

-------------------- 월과관련된 포맷 --------------------
select 
    TO_CHAR(SYSDATE, 'MM'),     --06
    TO_CHAR(SYSDATE,'MON'),     --6월
    TO_CHAR(SYSDATE,'MONTH'),   --6월
    TO_CHAR(SYSDATE,'RM')       --VI ????ㅋㅋㅋ갑자기 왠 로마숫자 ㅋㅋ
from DUAL;
-------------------- 월(6월...)와 관련된 포맷 --------------------

-------------------- 일(11일,23일)와 관련된 포맷 --------------------
select 
    TO_CHAR(SYSDATE, 'd'),    --4 (주를기준)
    TO_CHAR(SYSDATE,'dd'),    --21(월기준)
    TO_CHAR(SYSDATE,'ddd')    --172(년기준)
from DUAL;
-------------------- 일(11일,23일)와 관련된 포맷 --------------------

---------------- 요일(수요일, 목요일...)와 관련된 포맷 ----------------
select 
    TO_CHAR(SYSDATE, 'day'),       --수요일
    TO_CHAR(SYSDATE,'dy')          --수
from DUAL;
---------------- 요일(수요일, 목요일...)와 관련된 포맷 ----------------

-- 직원명, 입사일 조회 단, 입사일은 포맷지정해서 조회 2023년 06월 21일 (수)
select
EMP_NAME "NAME",
TO_CHAR(HIRE_DATE, 'yyyy"년" MM"월" DD"일" (DY)')
from EMPLOYEE;



/*
    TO_DATE(NUMBER | STRING, [FORMATING]): 숫자나 문자형 데이터를 날짜 타입으로 반환
*/

-- 날짜 포맷 변경 !
alter session set nls_date_format = 'yyyy"년" MM"월" dd"일" PMhh:mi:ss';


select TO_DATE(20230101) from dual;
select TO_DATE(20230621153410, 'yyyy-mm-dd hh24-mi-ss') from dual;

-- 문자 -> 날짜
select to_date('20230621','yyyymmdd') from dual;
select to_date('20230621 033823', 'yyyymmdd hh24miss') from dual;


/*
    TO_NUMBER(STRING, FORMATING) : 문자형 데이터 -> 숫자타입으로 변환
*/
select '100000'+ '550000' from dual;
select '1,000,000'+ '550,000' from dual;
select to_number('1,000,000', '9,999,999') + to_number('550,000', '9,999,999') from dual;



/*
    NULL 처리 함수
    
    1. NVL (value1, value2) : value1이 null이 아니면 value1을 반환하고 null이면 value2반환

*/
-- 사원명, 보너스조회
select emp_name, NVL(bonus, 0)
from employee;

-- 사원명, 보너스포함 연봉(월급 + 원급*보너스) * 12
select
    emp_name "이름",
    to_char((salary + salary * NVL(bonus,0))*12) "인센 포함 연봉",
    NVL(dept_code, '부서없음')"부서"
from employee
order by 2 asc;

-- 사원명, 부서코드 조회 (부서코드 null이면 '부서없음' 조회)
select
    emp_name "이름",
    NVL(dept_code, '부서없음')"부서"
from employee
order by 2 asc;


/*
    NVL2(value1, value2, value3) : value1 null아니면 value2 , null이면 value3
*/
-- 사원명, 부서코드가 있는 경우 "부서있음", 없는 경우 "부서없음" 조회
select
    (emp_name) "name",
    NVL2(dept_Code, '부서있음', '부서없음') "dept"
FROM EMPLOYEE
order by 2 asc;


/*
    NULLIF(value1, value2) : value1 ,value2 같으면 null, 다르면 value1반환
*/
select nullif('123','123') FROM DUAL;
select nullif('123','456') FROM DUAL;

/*
    선택함수 : 여러가지 중에 선택을 할 수 있는 기능 제공하는 함수
    DECODE(컬럼|산술연산|함수식, 조건값1, 결과값1, 조건값2, 결과값2, .... ,)
    - 비교하고자 하는 값이 조건값과 일치할 경우 그에 해당하는 결과값을 반환해 주는 함수
*/

-- 사번, 사원명, 주민번호, 성별(남,여) 조회
select 
    emp_id,
    emp_name,
    DECODE(substr(emp_no,8,1),1, '남',2,'여' ) "성별"
    FROM employee;

-- 사원명, 직급코드, 기존급여, 인상된급여
-- 직급 코드가 J7인 사원은 급여 10%인상
-- J6인 사원은 15%인상
-- J5인 사원은 20%
-- 그 외 5%인상
-- 직급 J1부터 인상된 급여 높은 순으로

select
    emp_name,
    job_code,
    salary,
    decode(job_code, 'J7' , salary * 1.10, 'j6', salary * 1.15, 'j5', salary * 1.20, salary * 1.05) "인상된급여"
    FROM employee
    order by 2 asc,4 desc ;
    
/*
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값2
         ...
         ELSE 결과값N
         END
*/
-- 사번, 사원명, 주민번호, 성별(남,여) 조회
select 
    emp_id,
    emp_name,
    emp_no,
    case when substr(emp_no, 8,1) = 1 then '남자'
         when substr(emp_no, 8,1) = 2 then '여자'
         else '잘못된 주민번호 임당' 
         end AS "성별"
    FROM EMPLOYEE;
    
    
    -- 사원명, 급여, 급여등급 (1 ~ 4) 조회
    -- 급여 값이 500초과 이면 1
    -- 350초과 ~ 500 2
    -- 200초과 ~ 350 3
    -- 그외4
select 
    emp_id,
    SALARY,
    case when salary > 5000000 then '1'
         when salary > 3500000 AND salary <= 5000000 then '2'
         when salary > 2000000 AND salary <= 3500000 then '3'
         else '4' 
         end AS "급여등급"
    FROM EMPLOYEE;


/*
    그룹함수
    - 대량의 데이터들로 집계나 통계 같은 작업 처리 하는 경우 사용하는 함수들
    - 모든 그룹 함수는 NULL값을 자동으로 제외하고 값이 있는 것들만 계산함;
    
    sum(NUMBER타입의 컬럼)
    - 해당 컬럼 값들의 총 합계를 반환
*/
-- 전체 사원의 총 급여 합
select to_char(sum(salary), 'FM999,999,999') "total salary"
from employee;

-- 부서 코드가 D5인 사원의 총 연봉 합
select 
sum(salary * 12)
from employee
where DEPT_CODE = 'D5';


/*
    avg(NUMBER)
    - 해당 컬럼 값들의 평균값을 반환
    - 모든 그룹함수는 NULL값 제외함 -> avg함수 사용시 NVL사용하는것을 권장;
*/
-- 전체 사원의 평균 급여
select 
ROUND(avg(NVL( salary,0)), 0)
from employee;


select avg(nvl(bonus,0))
from employee;


/*
    MIN/MAX (모든 타입의 컬럼)
    - MIN 컬럼값중 젤 작은거
    - MAX 컬럼중 젤 큰거
*/

-- 가장 작은 값에 해당하는 사원명, 급여 입사일
-- 가장 큰 값에 해당하는 사원명, 급여, 입사일
select MIN(emp_name), MIN(salary), MIN(hire_date)
from employee;

select MAX(emp_name), MAX(salary), MAX(hire_date)
from employee;

/*
    count(* | 컬럼 | DISTINCT컬럼 )
    - 컬럼 또는 행의 개수를 세서 반환
    count(*) : 조회 결과에 해당하는 모든 행 개수 반환
    count(컬럼) : 해당 컬럼값이 null이 아닌 행 개수 반환
    count(distinct컬럼) : 중복되지 않은 해당컬럼의 값이 null아닌 행 개수 반환
*/
-- 전체 사원 수
select count(*)
from employee;


-- 보너스 받는 사원의 수
select count(bonus)
from employee;

-- 부서가 배치된 사원의 수 
select count(dept_code)
from employee;

-- 현재 사원들이 속해 있는 부서 수
select count(distinct(dept_code))
from employee;

-- 현재 사원들이 속해 있는 직급 수
select count(distinct(job_code))
from employee;

-- 퇴사한 직원 수 
select count(ent_date)
from employee;



