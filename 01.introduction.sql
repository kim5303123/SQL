-- 이것은 SQL 주석입니다.
-- 기본적인 확인
show databases; -- 현재 접근 가능한 스키마 목록alter
-- or
show schemas;

use hrdb; -- HRDB를 사용하겠음

-- 현재 사용중인 user는?
select user();

-- 현재 사용중인 db 확인
select database();

-- 현재 스키마에 있는 테이블 목록
show tables;

-- employees 테이블 구조 확인
describe employees;

-- 서비스에서 root 사용은 위험하다.
-- root 계정은 전체 DB에 모든 권한을 가지고 있어서
-- 가급적 개별 서비스 계정을 만들어서 데이터베이스에 
-- 적절한 접근권한을 부여해서 제어해야 한다.

-- localhost에 hrdb 계정 생성
create user 'hrdb'@'localhost' identified by 'hrdb';

-- db 접근 권한 부여
grant all privileges on hrdb.* to 'hrdb'@'localhost';

-- 새로 Workbench Connection을 만들어 접속
