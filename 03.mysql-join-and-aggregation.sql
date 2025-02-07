use hrdb;

select * 
from departments
where department_id = 80;

--------------------
-- set operation
--------------------
select concat(first_name, ' ', last_name) as full_name
    ,salary , hire_date 
from employees
where department_id = 80;   --  row 45
select concat(first_name, ' ', last_name) as full_name
    ,salary , hire_date
from employees
where salary > 9000;    -- row 23

select concat(first_name, ' ', last_name) as full_name
    ,salary , hire_date 
from employees
where department_id = 50
union all
select concat(first_name, ' ', last_name) as full_name
    ,salary , hire_date
from employees
where salary > 9000;
-- UNION ALL : 중복을 제거하지 않은 합집합

-- mysql은 intersect, except는 지원하지 않는다.

--------------------
-- Simple Join or Equi Join
--------------------
select * 
from employees; -- row 107
select *
from departments; -- row 27

-- 카티전 프로덕트 ( 조합 가능 한 모든 레코드의 쌍 ) -- 총 107 * 27 개
select first_name, department_name
from employees , departments;

-- 두 테이블을 연결(JOIN)해서 큰 테이블을 만듦
select * 
from employees , departments 
where employees.department_id = departments.department_id;

-- 이름 , 부서 ID , 부서명
select concat(first_name, ' ', last_name) as full_name 
    ,emp.department_id
    ,dept.department_id
    ,department_name    
from employees emp , departments dept
where emp.department_id = dept.department_id;   --  row 106

select concat(first_name, ' ', last_name) as full_name 
    ,emp.department_id
    ,dept.department_id
    ,department_name    
from employees emp 
join departments dept 
using(department_id);  --  조인 조건 필드
    
--------------------
-- OUTER JOIN
--------------------
-- 조건이 만족하는 짝이 없는 경우에도 NULL을 포함하여 결과를 출력
-- 모든결과를 표현할 테이블이 어느 위치에 있느냐에 따라
-- LEFT, RIGHT, FULL OUTER JOIN으로 구분

--------------------
-- LEFT OUTER JOIN
--------------------
select first_name
    ,emp.department_id
    ,dept.department_id
    ,department_name 
from employees emp 
left outer join departments dept 
    on emp.department_id = dept.department_id;

--------------------
-- RIGHT OUTER JOIN
--------------------
select first_name
    ,emp.department_id
    ,dept.department_id
    ,department_name 
from employees emp 
right outer join departments dept 
    on emp.department_id = dept.department_id;

--------------------
-- FULL OUTER JOIN
--------------------
-- mysql은 FULL OUTER JOIN을 지원하지않음
-- 그렇지만, LEFT JOIN과 RIGHT JOIN결과를 UNION 연산해서
-- FULL OUTER JOIN을 구현할 수 있다.

select employee_id
    ,concat(first_name, ' ', last_name) as full_name 
    ,emp.department_id
    ,dept.department_id
    ,department_name
from employees emp 
left outer join departments dept
    on emp.department_id = dept.department_id
union    
select employee_id
    ,concat(first_name, ' ', last_name) as full_name 
    ,emp.department_id
    ,dept.department_id
    ,department_name
from employees emp 
right outer join departments dept
    on emp.department_id = dept.department_id;    
    
--------------------
-- SELF JOIN
--------------------    
-- 자기 자신과 JOIN
-- 자기 자신을 두번 이상 호출하므로, 별칭을 사용할 수 밖에 없음.

select emp.employee_id
    ,emp.first_name
    ,emp.manager_id
    ,man.employee_id
    ,man.first_name
from employees emp
join employees man
    on emp.manager_id = man.employee_id;

select *
from employees;    

select emp.employee_id
    ,emp.first_name
    ,emp.manager_id
    ,man.employee_id
    ,man.first_name
from employees emp
left outer join employees man
    on emp.manager_id = man.employee_id;
    
--------------------
-- Aggregation (집계)
-------------------- 
-- 여러 행의 데이터를 입력으로 받아서 하나의 행을 반환
-- NULL이 포함된 데이터는 NULL을 제외하고 집계

-- 갯수 세기 : count()
select count(*)
    ,count(commission_pct)
    ,count(department_id)
from employees;

-- *로 카운트하면 모든 행의 수
-- 특정 컬럼에 null 포함여부는 중요하지 않음
select count(commission_pct)
from employees;

-- 위 쿼리는 아래의 쿼리와 같은 의미이다.
select count(*)
from employees
where commission_pct is not null;

-- 합계 함수 : sum()
-- 사원들의 월급의 총합은 얼마?
select sum(salary)
from employees;

-- 평균 함수 : avg()
-- 사원들의 월급의 평균은 얼마?
select avg(salary)
from employees;

-- 사원들이 받는 커미션 비율의 평균치는?
select avg(commission_pct)
from employees; --  22.2%

select count(commission_pct)
from employees;
-- 집계 함수는 null을 제외하고 집계
-- NULL을 변환하여 사용해야 할지의 여부를 정책적으로 결정하고 수행해야 한다.

select avg(IFNULL(commission_pct,0))
from employees; --  7%

-- min / max
-- 월급의 최소값, 최대값, 평균, 중앙값
select min(salary)
    , max(salary)
    , avg(salary)
from employees;

-- 부서별로 평균 급여를 확인
-- 안됨 : why?
select department_id
    ,avg(salary)
from employees; --  error code : 1140

select department_id 
from employees
order by department_id;


-- 안됨? 의 수정된 쿼리
select department_id 
    ,avg(salary)
from employees
group by department_id
order by department_id;


select department_id
    ,salary
from employees
order by department_id;

-- 평균 급여가 7000 이상인 부서만 출력
-- 집계 함수 실행 이전에 where 절을 이용한 selection이 이루어짐
-- gruop by 절쪽에서 집계가 이루어지기 때문에 where절에서 사용할 수 가 없음
-- 집계 함수는 where 절에서 활용할 수 없는 상태
-- 집계 이후에 조건 검사를 하려면 having 절을 활용해야함
select department_id
    ,avg(salary)
from employees
where avg(salary) >= 7000
group by department_id; --  error code : 1111

                         -- 쿼리실행순서
select department_id        -- (5)
    ,avg(salary)
from employees              -- (1)
group by department_id      -- (2)
having avg(salary) >= 7000  -- (3)
order by department_id;     -- (4)

--------------------
-- SUBQUERY
-------------------- 

-- susan보다 많은 급여를 받는 직원의 목록

-- Query 1. 이름이 Susan인 직원의 급여를 뽑는 쿼리
select salary 
from employees
where first_name = 'susan'; -- salary= 6500

-- Query 2. 급여를 6500보다 많이 받는 직원의 목록을 뽑는 쿼리
select first_name 
    ,salary
from employees
where salary > 6500;    -- row 49

-- Query 3. 쿼리의 결합
select first_name
    ,salary
from employees
where salary > (select salary
                from employees
                where first_name = 'susan');   

-- 연습문제
-- 'Den'보다 급여를 많이 받는 사원의 이름과 급여는?

-- 급여를 가장 적게 받는 사람의 이름, 급여, 사원번호를 출력
-- Query 1. 가장 적은 급여
select min(salary)
from employees; --  급여 = 2100    
-- Query 2. Query 1의 결과보다 salary가 작은 직원의 목록
select employee_id
    ,first_name
    ,salary
from employees
where salary = 2100;    

-- Query 3. 쿼리의 결합

select employee_id
    ,first_name
    ,salary
from employees
where salary > (select min(salary)
                from employees )
order by salary desc;                

-- 평균 급여보다 적게 받는 사원의 이름과 급여
-- Query 1. 평균 급여 쿼리
select avg(salary)
from employees; -- 평균급여는 약 6461 
-- Query 2. Query 1의 결과보다 salary가 적은 사람의 목록 쿼리
select employee_id, first_name, salary
from employees
where salary < 6462;    --  평균 급여보다 높게 받는 사람 대략 56명

-- Query 3. 쿼리의 결합
select employee_id, first_name, salary
from employees
where salary < (select avg(salary)
                from employees);
                
-- 다중행 서브쿼리
-- 서브쿼리의 결과 레코드가 둘 이상일 떄는 단순비교연산자는 사용 불가
-- 서브쿼리의 결과가 둘 이상일 때는
-- 집합 연산자 ( in, any, all, exists 등을 사용해야 한다.)

select salary
from employees 
where department_id = 110;

-- 110번 부서 사람들이 받는 급여와 동일한 급여를 받는 사원들
select first_name, salary
from employees
where salary in (select salary
                    from employees
                    where department_id = 110);
                    
                    
-- 110번 부서 사람들이 받는 급여중 1개 이상보다 많은 급여를 받는 사람들                    
select first_name, salary
from employees
where salary > any (select salary
                    from employees
                    where department_id = 110);                    
-- any 연산자 비교연산자와 결합해서 작동
-- or 연산자와 비슷  

-- 110번 부서 사람들이 받는 급여 전체보다 많은 급여를 받는 직원의 목록              
select first_name, salary
from employees
where salary > all (select salary
                    from employees
                    where department_id = 110);                    

-- all 연산자 : 비교연산자와 결합하여 사용
-- and 연산자와 비슷

-- 서브쿼리 연습
-- 각 부서별로 최고 급여를 받는 사원을 출력 ( 조건절에서 서브쿼리를 사용하여서 )
-- Query 1. 각 부서의 최고 급여
select department_id
    ,max(salary)
from employees
group by department_id
order by department_id;

-- Query 2. Query 1에서 나온 department_id, salary값을 이용해서 비교 연산 
select department_id
    ,employee_id
    ,first_name
    ,salary
from employees
where (department_id, salary) in 
    (select department_id, max(salary)
        from employees
        group by department_id)
order by department_id;
    
-- 각 부서별로 최고 급여를 받는 사원을 출력 ( 서브쿼리 테이블 조인 사용 )
select emp.department_id
    ,emp.employee_id
    ,emp.first_name
    ,emp.salary
from employees emp 
join (select department_id
        ,max(salary)
        from employees
        group by department_id) sal
    on emp.department_id = sal.department_id
order by emp.department_id;    


--------------------
-- LIMIT
-------------------- 
-- LIMIT : 출력 갯수의 제한
select first_name
    ,salary
from employees
order by salary desc
limit 3;    -- 앞으로부터 3개 row 출력

select first_name
    ,salary
from employees
order by salary desc
limit 10, 3;    -- 앞에서 10개 건너뛰고 3개 row 출력
    
select first_name
    ,salary
from employees
order by salary desc;











