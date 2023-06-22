 /*
    group by
    - 그룹 기준을 제시할 수 있는 구문
    - 여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용
 */
 -- 직급별 사원의 총 급여 합
 select job_code, sum(salary)
 from employee
 group by Job_code
 order by 1;
 
 
 -- 각 부서별(null인 경우 부서 없음
 -- 사원의 수, 보너스를 받는 사원 수 , 총 급여, 평균급여, 최저 급여, 최고 급여 조회
 select
        NVL(dept_code,  '부서없음'), 
        count(*) "사원수",
        count(bonus)"보너스 받는 사원(명)",
        sum(salary) "총급여",
        FLOOR(avg(NVL(salary, 0))) "평균급여",
        min(salary) "최저급여",
        max(salary) "최고급여"    
 from employee 
 group by dept_code
 order by DEPT_CODE NULLS FIRST;
 
 
 -- 성별 별(남/여) 사원 수 조회
 select
 DECODE(SUBSTR(EMP_NO, 8,1),1,'남자',2,'여자') "성별", 
 COUNT(*) "사원수"
 from employee
 group by SUBSTR(EMP_NO, 8,1);
 
 
 
 /*
    HAVING 
    - 그룹에 대한 조건을 제시할 때 사용하는 구문
    - 
    SELECT 문 실행순서
    SELECT      5   * | 조회하고자 하는 컬럼명
    FROM        1   조회하고자 하는 테이블
    WHERE       2   조건식 (연산자들 가지고 기술)
    GROUP BY    3   그룹 기준에 해당하는 컬럼명 | 계산식 | 함수식
    HAVING      4   조건식
    ORDER BY    6   컬럼명 | 별칭 | 컬럼순번 [ASC | DESC] [NULLS FIRST | NULLS LAST]
 */
 
 -- 부서별 평균 급여가 300이상인 직원의 평균 급여 조회
 -- 부서코드 , 평균 급여
 SELECT 
 DEPT_CODE "부서",
 FLOOR(AVG(SALARY)) "부서 평균 급여"
 
 FROM EMPLOYEE
 GROUP BY DEPT_CODE
 HAVING ROUND(AVG(SALARY)) >= 3000000
 ORDER BY DEPT_CODE;
 
 -- 직급별 총 급여의 합이 1000만원 이상인 직급만 조회
 SELECT 
 JOB_CODE,
 SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY JOB_CODE
 HAVING SUM(SALARY) >= 10000000
 ORDER BY JOB_CODE;
 
 -- 부서별 보너스 받는 사원이 없는 부서만 조회
 SELECT
 DEPT_CODE "보너스가 없는 부서"
 
 FROM EMPLOYEE
 GROUP BY DEPT_CODE
 HAVING COUNT(BONUS) = 0
 ORDER BY DEPT_CODE;
 
 
 /*
    집계 함수
    - 그룹별 산출한 결과 값의 중간 집계를 계산 해주는 함수
    - ROLLUP (컬럼1, 컬럼2) : 컬럼1을 가지고 다시 중간 집계를 내는 함수????
    - CUBE (컬럼1, 컬럼2) : 컬럼1을 가지고 중간집계 내고, 컬럼2로도 중간집계 또냄;
    
 */
 -- 직급별 급여의 합
 SELECT JOB_CODE, SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY JOB_CODE;

-- ROLLUP(컬럼)
 SELECT JOB_CODE, SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY ROLLUP( JOB_CODE);
-- CUBE(컬럼)
 SELECT JOB_CODE, SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY CUBE(JOB_CODE);
 -- 컬럼이 하나일 때에는 사실상 CUBE ROLLUP이 차이점이 딱히 없음;


 -- 부서 코드와 직급 코드가 같은 사원들의 급여 합계 조회
 SELECT 
    DEPT_CODE,
    JOB_CODE , 
    SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY DEPT_CODE, JOB_CODE
 ORDER BY DEPT_CODE, JOB_CODE;
 
 -- ROLLUP (컬럼,컬럼)
 SELECT 
    DEPT_CODE,
    JOB_CODE , 
    SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY ROLLUP( DEPT_CODE, JOB_CODE)
 ORDER BY DEPT_CODE,JOB_CODE;
 
 -- CUBE (컬럼,컬럼)
 SELECT 
    DEPT_CODE,
    JOB_CODE , 
    SUM(SALARY)
 FROM EMPLOYEE
 GROUP BY CUBE( DEPT_CODE, JOB_CODE)
 ORDER BY JOB_CODE, DEPT_CODE;
 
 
 /*
    GROUPING
    - ROLLUP 이나 CUBE에 의해 산출된 값이 해당 컬럼의 집합의 산출물이면 0반환, 아니면 1반환
 */
 
  -- ROLLUP (컬럼,컬럼)
 SELECT 
    DEPT_CODE,
    JOB_CODE , 
    SUM(SALARY),
    GROUPING(DEPT_CODE),
    GROUPING(JOB_CODE)
 FROM EMPLOYEE
 GROUP BY ROLLUP( DEPT_CODE, JOB_CODE)
 ORDER BY DEPT_CODE,JOB_CODE;
 
 -- CUBE (컬럼,컬럼)
 SELECT 
    DEPT_CODE,
    JOB_CODE , 
    SUM(SALARY),
    GROUPING(DEPT_CODE),
    GROUPING(JOB_CODE)
 FROM EMPLOYEE
 GROUP BY CUBE( DEPT_CODE, JOB_CODE)
 ORDER BY JOB_CODE, DEPT_CODE;
 
 /*
    집합 연산자 
    - 여러개의 쿼리문을 하나의 쿼리문으로 만드는 연산자
    - 여러개의 쿼리문에서 조회하려고 하는 컬럼의 개수와 이름이 같아야 집합연사자 사용가능
    
    UNION (합집합) : 두 쿼리문을 수행한 결과값을 하나로 합쳐서 추출 (중복행 제거됨)
    UNION ALL(합집합) : 두 쿼리문을 수행한 결과값을 하나로 합쳐서 추출 (**중복행 제거 XXXX)
    
    INTERSECT (교집합) : 두 쿼리문을 수행해서 중복되는 값만 추출
    MINUS (차집합) : 선행 쿼리문의 결과값에서 후행 쿼리문의 결과값을 뺀 값을 추출..??    
 */
 
 -- 부서코드가 D5인 사원들의 사번, 사원명, 부서코드 급여를 조회
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D5';
 
 -- 급여가 300만원 초과인 사원들의 사번, 사원명, 부서코드, 급여를 조회
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE
 FROM EMPLOYEE 
 WHERE SALARY > 3000000;
 
 ------- 1. UNION -------
 -- 부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원들의 사원명, 부서코드, 급여 조회
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D5'
 UNION
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000;
 -- 위 쿼리문 대신 WHERE절에 OR넣으면 더 간단 !
  SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000 OR DEPT_CODE = 'D5';
 
 
 ------- 2. UNION ALL -------
  SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D5'
 UNION ALL
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000
 ORDER BY EMP_NAME;
 
 ------- 3. INTERSECT -------
 -- 부서 코드가 D5이면서 급여가 300만원 초과인 사원 조회
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D5'
 INTERSECT
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000
 ORDER BY EMP_NAME;
 -- 위 쿼리문 대신 WHERE절에 AND 넣으면 더 간단 !
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000 AND DEPT_CODE = 'D5';
 
 
 ------- 4. MINUS -------
 -- 부서 코드가 D5인 사원중 급여가 300만원 초과인 사원 제외해서 조회
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D5'
 MINUS
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE SALARY > 3000000
 ORDER BY EMP_NAME;
 -- 위 쿼리문 대신 WHERE절에 NOT 넣으면 더 간단 !
 SELECT 
    EMP_ID,
    EMP_NAME,
    DEPT_CODE,
    SALARY
 FROM EMPLOYEE 
 WHERE NOT SALARY > 3000000 AND DEPT_CODE = 'D5';
 
 
 
 /*
    GROUPING SETS
    - 그룹별로 처리된 여러개의 SELECT문을 하나로 합친 결과를 원할때 사용
 */
 -- 부서별, 직급별 사원수
 SELECT 
 DEPT_CODE,
 COUNT(*)
 FROM EMPLOYEE
 GROUP BY DEPT_CODE
 UNION ALL
 SELECT 
 JOB_CODE,
 COUNT(*)
 FROM EMPLOYEE
 GROUP BY JOB_CODE;
 -- 위 코드 대신 GROUPING SET 함수 사용
 SELECT DEPT_CODE, JOB_CODE, COUNT(*)
 FROM EMPLOYEE
 GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE)
 ORDER BY DEPT_CODE, JOB_CODE;
 
 
 
 