-- DML - SELECT
USE hrdb;
select database();  --  선택된 DB 확인

--------------------
-- SELECT ~ FROM
--------------------
-- 테이블 구조 확인
describe employees;
describe departments;

-- 가장 기본적인 select의 형태: 전체 데이터(모든 컬럼, 모든 레코드)
select * 
from employees;    --  107 rows
select * 
from departments;  --  27  rows

-- 테이블 내에 정의된 모든 컬럼을 Projection
-- 순서는 테이블을 작성할 때 정의한 순서를 따른다.

-- 특정 컬럼만 선별적으로 Projection 할 수 있다.
select first_name 
from employees;
select first_name, salary 
from employees;
-- Alias (별칭)
select first_name 이름, salary 월급 
from employees;
select first_name as 이름, salary as 월급 
from employees;

/*
연습문제
사원의 이름(first_name)과 전화번호, 입사일, 급여를 출력해 봅시다
*/
select first_name 이름, phone_number 전화번호, hire_date 입사일, salary 급여 
from employees;


/*
연습문제
사원의 이름(first_name), 성(last_name), 급여, 전화번호, 입사일을 출력해 봅시다
*/
select first_name 이름, last_name 성, salary 급여,  phone_number 전화번호, hire_date 입사일 
from employees;

-- 산술연산 : 기본적인 산술 연산을 사용할 수 있다.
select 3.14159 * 10 * 10 as 연산 
from dual;
-- 특정 테이블이 아니라 데이터베이스 자체에 문의할 경우 dual 테이블을 사용
-- 특정 필드의 값을 수치로 산술 계산을 할 수 있다.
select first_name, salary, salary * 12 as 연봉 
from employees;
-- 커미션까지 포함한 최종 급여
select first_name, salary, commission_pct, salary + salary * commission_pct
from employees;

-- COALESCE or IFNULL
-- COALESCE (ANSI-SQL) : 주어진 인수 중, NULL이 아닌 첫 값 출력
select coalesce(NULL, NULL, "A", "B");
-- IFNULL (MySQL) : 두개의 인수 중에서 첫 값이 NULL이면 두번째 값 출력
select IFNULL(NULL, "대체값"); 

select first_name, salary, commission_pct, salary + salary * IFNULL(commission_pct, 0)
from employees;

select first_name, salary, commission_pct, salary + salary * coalesce(commission_pct,0)
from employees;

-- FULL Name과 salary
select first_name + " " + last_name , salary
from employees;
-- 문자열을 합칠 때는 concat 함수를 사용
select concat(first_name, " ", last_name) as 이름
from employees;

-- distinct (중복제거)
select job_id 
from employees; -- 로우 107개  
select distinct job_id
from employees; -- 로우 19개(중복제거)

------------------
-- WHERE
------------------
-- SELECTION을 위한 조건

-- 부서 번호가 10번인 부서 정보
select * 
from departments;

select * 
from departments
where department_id = 10;

-- 급여가 15000원 이상인 사원의 목록을 출력
select *
from employees
where salary >= 15000;

-- 입사일이 2001년 1월 1일 이후인 사원들의 이름과 입사일 출력
select concat(first_name, ' ', last_name) as name , 
        hire_date as "입사일"
from employees
where hire_date > '2008-01-01'; 

-- 급여가 10000원 미만이거나 17000원 초과인 사원의 이름과 급여
select concat(first_name, ' ', last_name) as name , salary as "급여"
from employees
where salary < 10000 or salary > 17000; 

-- 급여가 10000원 이상이고 17000원 이하인 사원의 이름과 급여
select concat(first_name, ' ', last_name) as name , salary as "급여"
from employees
where salary >= 10000 and salary <= 17000; 

-- BETWEEN 연산자
select concat(first_name, ' ', last_name) as name , salary as "급여"
from employees
where salary between 10000 and 17000;

-- IN 연산자
-- 10, 20, 30번 부서 정보를 확인
select employee_id , first_name, department_id
from employees
where department_id = 10 or department_id = 20 or department_id = 30;

select employee_id , first_name, department_id
from employees
where department_id in (10 ,20 ,30);

-- 10, 20, 30부서가 아닌 부서에 소속된 직원들
select employee_id, first_name, department_id
from employees
where department_id <> 10 and department_id != 20 and department_id <> 30  ;

select employee_id , first_name, department_id
from employees
where department_id not in (10,20,30);

-- where 절에서 null 체크
-- is null로 체크한다.
-- = null <- 이표현은 불가하다.
select first_name, commission_pct
from employees
where commission_pct is null; -- = null로 하면 안됨

select first_name, commission_pct
from employees
where commission_pct = null; -- 잘못된 null 체크

------------------
-- LIKE
------------------
-- 부분 문자열 검색
-- Wildcard
-- % : 정해지지 않은 길이의 문자열
-- _ : 문자 1개

-- 이름에 am을 포함하는 사원의 이름과 급여 출력
select first_name, salary
from employees
where lower(first_name) like "%am%";
-- where first_name like '%am%';

-- 이름의 두번째 글자가 a인 사원의 이름과 급여
select first_name, salary
from employees
where lower(first_name) like "_a%";
-- where upper(first_name) like "_a%";  

------------------
-- ORDER BY 
------------------

-- 부서 번호를 오름차순으로 정렬하고 이름, 부서번호, 급여를 출력 
-- asc(오름차순) 이 defalt
select first_name, department_id, salary
from employees
order by department_id asc; -- asc 생략가능

-- 정렬 기준은 여러 컬럼에 지정할 수 있음
select * 
from employees
order by first_name, hire_date desc limit 10;

-- 급여가 15000 이하인 직원들 중에서 목록을 급여의 내림차순으로 출력
select *
from employees
where salary <= 15000
order by salary desc;

-- 부서 번호를 오름차순으로 정렬하고 
-- 같은 부서 사람들을 급여가 높은사람부터 출력하되
-- 이름, 부서번호, 급여 순으로 출력
select first_name , department_id, salary
from employees
order by department_id asc , salary desc ;

------------------
-- 문자열 단일행 함수
------------------
select first_name, last_name ,
    concat(first_name, ' ' ,last_name),
    lower(first_name), lcase(first_name),
    upper(first_name), ucase(first_name)    
from employees;

select '    MySQL   ',
    "*****Database*****"
From dual;

select ltrim('      MySQL       ') as "LTRIM",
    rtrim('      MySQL       ') as "RTRIM",
    trim(BOTH '*' FROM "*****Database*****") as "TRIM" ,
    trim(LEADING '*' FROM "*****Database*****") as "LEADING TRIM" ,
    trim(TRAILING '*' FROM "*****Database*****") as "TRAILING TRIM"
From dual;    

Select "Oracle Database" ,
    length("Oracle Database") ,
    substring("Oracle Database" , 8 , 4) , 
    substring("Oracle Database" , -8 , 8)
From Dual;

select 
    replace("Sad Day", "Sad", "Happy"),
    lpad(first_name, 20, '*'),
    rpad(first_name, 20, '*')
from employees;    

------------------
-- 수치형 단일행 함수
------------------
select abs(-3.14),      -- 절대값
    ceiling(3.14),      -- 소수점을 올림 (천장)
    floor(3.14),        -- 소수점을 버림 (바닥)
    mod(7,3),           -- 나눗셈의 몫
    power(2,4),         -- 제곱 함수
    round(3.5),         -- 반올림
    round(3.56, 1),     -- 소수점 1자리까지 반올림
    truncate(3.56, 1)  -- 소주점 1자리까지 내림
from dual;    

select sign(-10),
    sign(0),
    sign(10),
    greatest(2, 1, 0),
    greatest(4.0, 5.0, 3.0),
    greatest('B', 'A', 'C'),
    least(2, 1, 0),
    least(4.0, 5.0, 3.0),
    least('B', 'A', 'C')
From dual;    
    
------------------
-- 날짜형 단일행 함수
------------------    
Select curdate(), current_date(),
        curtime(), current_time(),
        current_timestamp(),
        now(), sysdate()
From dual;       
    
-- EXTRACT 함수 : 날짜 혹은 시간에서 특정 요소 추출
Select extract(year from '2024-11-18') 
From dual;

-- 모든 직원들의 입사년도 조회
Select first_name, hire_date ,extract(year from hire_date) as 입사년도
From employees;    

-- 2008이후에 입사한 직원 목록
Select first_name , hire_date , extract(year from hire_date) as hire_year
From employees
Where extract(year from hire_date) >= 2008;

-- DATE_FORMAT : 날짜 출력 형식 지정
Select date_format(curdate(), '%W %M %Y'),
    date_format(curdate(), '%Y. %m. %d')
From dual;    

-- PERIOD_DIFF : 두 날짜 정보 사이의 간격값을 반환
-- 직원들이 지금까지 몇 개월 근속했는가?
Select first_name, date_format(curdate(), '%Y%m') as 현재시간,
    date_format(hire_date, '%Y%m') as 입사일,
    period_diff(date_format(curdate(), '%Y%m'), date_format(hire_date, '%Y%m')) as 근속월수    
From employees;    

-- DATE_ADD, DATE_SUB : 특정 간격을 더하거나 뺄 수 있다.
Select first_name, hire_date,
    date_add(hire_date, interval 1 year),
    date_sub(hire_date, interval 1 year)
From employees;    

-- CAST : 변환
Select cast(now() as date);
Select cast("123" as unsigned); -- 문자열 -> unsigned

-- CONVER 함수로 대신할 수 있음
Select convert(now() , DATE) 
FROM Dual;
Select convert("123", unsigned) 
From Dual;
    
-- NULL
-- 비어있는 데이터
-- 어떠한 타입에서도 사용이 가능하다.
-- NOT NULL 컬럼, PK 컬럼에서는 사용할 수 없다.
select first_name, salary, salary * null 
from employees;
-- NULL이 포함된 산술식의 결과는 항상 NULL 이다.
select salary, isnull(salary * null)
from employees;
select salary, not isnull(salary * null)
from employees;
