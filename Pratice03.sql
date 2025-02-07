-- 문제1.
-- 직원들의 사번(employee_id), 이름(firt_name), 성(last_name)과 부서명(department_name)을
-- 조회하여 부서이름(department_name) 오름차순, 사번(employee_id) 내림차순 으로 정렬하세요.
-- (106건)
select emp.employee_id as 사번
    ,emp.first_name as 이름
    ,emp.last_name as 성
    ,dept.department_name as 부서명
from employees emp , departments dept
where emp.department_id = dept.department_id
order by dept.department_name, employee_id desc;



-- 문제2.
-- employees 테이블의 job_id는 현재의 업무아이디를 가지고 있습니다.
-- 직원들의 사번(employee_id), 이름(firt_name), 월급(salary), 부서명(department_name), 
-- 현재업무(job_title)를 사번(employee_id) 오름차순 으로 정렬하세요.
-- 부서가 없는 Kimberely(사번 178)은 표시하지 않습니다.
-- (106건)
select employee_id as 사번
    ,first_name as 이름
    ,salary as 월급
    ,department_name as 부서명    
    ,job_title as 현재업무
from employees emp , departments dept, jobs jo
where emp.department_id = dept.department_id 
  and emp.job_id = jo.job_id
order by employee_id;


-- 문제2-1.
-- 문제2에서 부서가 없는 Kimberely(사번 178)까지 표시해 보세요
-- (107건)
select emp.employee_id as 사번
    ,emp.first_name as 이름
    ,emp.salary as 월급
    ,dept.department_name as 부서명        
    ,jo.job_title as 현재업무
from employees emp  
 left outer join departments dept 
    on emp.department_id = dept.department_id
 right outer join jobs jo
    on emp.job_id = jo.job_id
order by emp.employee_id;


-- 문제3.
-- 도시별로 위치한 부서들을 파악하려고 합니다.
-- 도시아이디, 도시명, 부서명, 부서아이디를 도시아이디(오름차순)로 정렬하여 출력하세요
-- 부서가 없는 도시는 표시하지 않습니다.
-- (27건)
select loc.location_id as 도시아이디
    , loc.city as 도시명
    , dept.department_name as 부서명
    , dept.department_id as 부서아이디
from departments dept ,locations loc
where dept.location_id = loc.location_id 
order by dept.location_id;
  

-- 문제3-1.
-- 문제3에서 부서가 없는 도시도 표시합니다.
-- (43건)
select dept.location_id as 도시아이디
    , loc.city as 도시명
    , dept.department_name as 부서명
    , dept.department_id as 부서아이디
from departments dept 
right outer join locations loc
  on dept.location_id = loc.location_id 
order by dept.location_id;



-- 문제4.
-- 지역(regions)에 속한 나라들을 지역이름(region_name), 나라이름(country_name)으로 출력하
-- 되 지역이름(오름차순), 나라이름(내림차순) 으로 정렬하세요.
-- (25건)
select reg.region_name as 지역이름
    ,cnt.country_name as 나라이름
from regions reg
left outer join countries cnt
    on reg.region_id = cnt.region_id
order by reg.region_name , cnt.country_name desc;

-- 문제5. 
-- 자신의 매니저보다 채용일(hire_date)이 빠른 사원의
-- 사번(employee_id), 이름(first_name)과 채용일(hire_date), 매니저이름(first_name), 매니저입
-- 사일(hire_date)을 조회하세요.
-- (37건)

select emp.employee_id as 사번
    ,emp.first_name as 이름
    ,emp.hire_date as 채용일
    ,man.first_name as 매니저이름
    ,man.hire_date as 매니저입사일
from employees emp
join employees man
  on emp.manager_id = man.employee_id
where man.hire_date > emp.hire_date;


-- 문제6.
-- 나라별로 어떠한 부서들이 위치하고 있는지 파악하려고 합니다.
-- 나라명, 나라아이디, 도시명, 도시아이디, 부서명, 부서아이디를 나라명(오름차순)로 정렬하여 출력하세요.
-- 값이 없는 경우 표시하지 않습니다.
-- (27건)

select cnt.country_name as 나라명
    , cnt.country_id as 나라아이디
    , loc.city as 도시명
    , loc.location_id as 도시아이디
    , dept.department_name as 부서명
    , dept.department_id as 부서아이디
from locations loc 
right outer join departments dept
    on loc.location_id = dept.location_id
left outer join countries cnt
        on loc.country_id = cnt.country_id
order by cnt.country_name;
    


-- 문제7.
-- job_history 테이블은 과거의 담당업무의 데이터를 가지고 있다.
-- 과거의 업무아이디(job_id)가 ‘AC_ACCOUNT’로 근무한 사원의 사번, 이름(풀네임), 업무아이디, 시작일, 종료일을 출력하세요.
-- 이름은 first_name과 last_name을 합쳐 출력합니다.
-- (2건)
select johi.job_id as '근무한 사원의 사번'
    , concat(emp.first_name, ' ', emp.last_name) as 이름
    , johi.job_id as 업무아이디
    , johi.start_date as 시작일
    , johi.end_date as 종료일
from job_history johi 
left outer join employees emp
    on johi.employee_id = emp.employee_id
where johi.job_id = 'AC_ACCOUNT';    



-- 문제8.
-- 각 부서(department)에 대해서 부서번호(department_id), 부서이름(department_name), 
-- 매니저(manager)의 이름(first_name), 위치(locations)한 도시(city), 나라(countries)의 이름
-- (countries_name) 그리고 지역구분(regions)의 이름(resion_name)까지 전부 출력해 보세요.
-- (11건)
-- regions reg , employees emp, countries cnt, locations loc, departments dept
-- * 조인목록
-- countries cnt = regions reg
-- employees emp = departments dept
-- departments dept = locations loc
-- locations loc = countries cnt

/*
내가 한것

select 
emp.department_id as 부서번호
    ,dept.department_name as 부서이름
    ,emp.first_name as 매니저이름    
    ,loc.city as 도시
    ,cnt.country_name as 나라이름
    ,loc.country_id
from locations loc , departments dept 
left outer join employees emp
    on dept.department_id = emp.department_id
    left outer join countries cnt
    on cnt.country_id = loc.country_id;
    
 -- union
--     select region_id as 지역구분
--     ,region_name as 지역명 
--     from regions;    
  */ 
select dept.department_id as 부서번호
    ,dept.department_name as 부서이름
    ,emp.first_name as 매니저이름    
    ,loc.city as 도시
    ,cnt.country_name as 나라이름
    ,reg.region_name as 지역명    
from departments dept
    ,employees emp
    ,locations loc
    ,countries cnt
    ,regions reg
where dept.department_id = employee_id
and dept.location_id = loc.location_id
and loc.country_id = cnt.country_id
and cnt.region_id = reg.region_id
order by dept.department_id;

    

-- 문제9.
-- 각 사원(employee)에 대해서 사번(employee_id), 이름(first_name), 부서명
-- (department_name), 매니저(manager)의 이름(first_name)을 조회하세요.
-- 부서가 없는 직원(Kimberely)도 표시합니다.
-- 매니저가 없는 Steven도 표시합니다.
-- (107명)

/*
내가한것
select emp.employee_id as 사번
    ,emp.first_name as 이름
    ,emp.salary as 월급
    ,dept.department_name as 부서명
    ,man.first_name as 매니저이름
from employees emp  
 left outer join departments dept 
    on emp.department_id = dept.department_id
 join employees man
    on  emp.manager_id = man.manager_id;
*/

select emp.employee_id as 사번
    ,emp.first_name as 이름    
    ,dept.department_name as 부서명
    ,man.first_name as 매니저이름   
from employees emp  
left outer join departments dept
    on emp.department_id = dept.department_id
left outer join employees man
    on  emp.manager_id = man.employee_id;




-- 문제9-1.
-- 문제9 에서 부서가 없는 직원(Kimberely)도 표시하고.
-- 매니저가 없는 Steven도 표시하지 않습니다.
-- (106명)
select emp.employee_id as 사번
    ,emp.first_name as 이름    
    ,dept.department_name as 부서명
    ,man.first_name as 매니저이름   
from employees emp  
left outer join departments dept
    on emp.department_id = dept.department_id
inner join employees man
    on  emp.manager_id = man.employee_id;



-- 문제9-2.
-- 문제9 에서 부서가 없는 직원(Kimberely)도 표시하지 않고
-- 매니저가 없는 Steven도 표시하지 않습니다.
-- 105명
select emp.employee_id as 사번
    ,emp.first_name as 이름    
    ,dept.department_name as 부서명
    ,man.first_name as 매니저이름   
from employees emp  
inner join departments dept
    on emp.department_id = dept.department_id
inner join employees man
    on  emp.manager_id = man.employee_id
order by emp.employee_id;    
