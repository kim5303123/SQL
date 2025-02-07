--------------------
-- DCL and DDL
--------------------
-- root 계정으로 수행

-- 사용자 생성
create user 'testuser'@'localhost' identified by 'test';

-- 사용자 수정
alter user 'testuser'@'localhost'
    identified by 'abcd';
    
-- 사용자 삭제
drop user 'testuser'@'localhost';    

-- 사용자 생성(다시)
create user 'testuser'@'localhost' identified by 'test';

-- 접속 후 계정 정보 확인
select current_user;



--------------------
-- GRANT / REVOKE
--------------------
-- 권한 (Privilege)
-- 특정 작업을 수행할 수 있는 권리

-- 권한을 부여하는 작업을 GRANT
-- 권한을 회수하는 작업을 REVOKE

show grants;    --  권한의 확인
show grants for current_user;   --  현재 유저에게 부여된 권한들
show grants for 'testuser'@'localhost'; --  특정 유저의 권한 확인


-- testuser에게 hrdb 스키마의 모든 테이블 조회 권한
grant select on hrdb.* to 'testuser'@'localhost';   --  권한 부여
revoke select on hrdb.* from 'testuser'@'localhost';    --  권한 회수

--------------------
-- ROLE
--------------------

-- ROLE을 활용하면 특정 권한의 묶음을 일괄적으로 적용하거나 아니면 회수할 수 있음
create role reader; --  역할의 생성
grant select on hrdb.* to reader; --  hr스키마의 모든 객체의 select 권한을 reader에게 부여

create role author;
grant select, insert, update, delete on hrdb.* to author;

create role editor;
grant select, update on hrdb.* to editor;

-- role에게 부여된 grant 확인
show grants for reader;
show grants for author;
show grants for editor;

-- 권한을 묶음으로 관리할 수 있어서 편하다.
grant reader to 'testuser'@'localhost';
revoke reader from 'testuser'@'localhost';
grant author to 'testuser'@'localhost';

-- role에 의해 부여된 권한 확인
show grants for 'testuser'@'localhost' using reader;
show grants for 'testuser'@'localhost' using author;

-- role 삭제
drop role reader;
drop role author;
drop role editor;

-- create : db 객체 생성 키워드
-- alter : db 객체 수정 키워드
-- drop : db 객체 삭제 키워드

--------------------
-- DDL
--------------------
-- 데이터베이스(스키마 생성과 삭제)
create database test_db;    --  기본 생성법
drop database test_db;      -- 데이터베이스 삭제  

create database test_db default character set utf8mb4 collate utf8mb4_general_ci;

-- 현재 선택된 데이터베이스 확인
select database();

-- 데이터베이스 사용
use test_db;
select database();

-- 여기서부터는 testuser로 진행
create user 'test_user'@'localhost' identified by 'test';
grant all privileges on test_db.* to 'test_user'@'localhost';
grant select on hrdb.* to 'test_user'@'localhost';

-- 테이블 생성 create table
create table book (
    book_id INTEGER, 
    title VARCHAR(50), 
    author VARCHAR(20), 
    pub_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 테이블 구조 확인
describe book;

-- 테이블 삭제
drop table book;

-- 트랜잭션 활성화
--  1:  자동 커밋
--  0:  자동 커밋 안함
select @@autocommit;    
set autocommit = 0; --  자동 commit off, 트랜젝션 작동


-- subquery를 이용한 테이블 생성
-- job_id가 fi_account인 모든 직원의 레코드를 새 테이블로 생성
create table account_employees as (
    select * 
    from hrdb.employees
    where job_id='FI_ACCOUNT'
);

desc account_employees;
select * 
from account_employees;

-- 테이블 변경 ALTER TABLE
-- 컬럼 추가 (ADD)

alter table book add (pubs varchar(50));
desc book;

-- 컬럼 변경 (MODIFY)
alter table book modify title varchar(100);
desc book;

-- 컬럼 삭제 (DROP)
alter table book drop author;
desc book;

-- 컬럼 코멘트
alter table book modify title varchar(100) comment '도서 제목';
desc book;
show create table book;

-- RENAME
rename table book to article;
desc article;

-- 주요 제약 조건(Constraints)
create table book (
    book_id integer not null);

-- not null : 컬럼 레벨 제약 조건    
insert into book values(1);    
insert into book values(null);

drop table book;
-- unique
create table book (
    book_id integer, unique(book_id));

-- unique : 유일한 값, 테이블 레벨, 인덱스 자동 부여
insert into book values(1);
insert into book values(2);
insert into book values(2);
drop table book;

-- pk
create table book (
    book_id integer primary key auto_increment
    ,book_title varchar(100));

-- PRIMARY KEY : NOT NULL + UNIQUE - > 자동 인덱스    
insert into book (book_title) values ('홍길동전');    
insert into book (book_title) values ('전우치전');
insert into book (book_title) values ('춘향전');

select * 
from book;

drop table book;

-- check
create table book (
    rate integer check (rate in (1,2,3,4,5)));
    
insert into book values(1);
insert into book values(6); --  체크 조건에 위배

drop table book;

-- 제약 조건을 포함 book 테이블 생성
create table book (
    book_id integer primary key auto_increment comment '도서 아이디'
    ,book_title varchar(50) not null comment '도서 제목'
    ,author varchar(20) not null comment '작가명'
    ,rate integer check(rate in (1,2,3,4,5)) comment '별점'
    ,pub_date datetime default current_timestamp comment '출간일')
    comment '도서정보';
    
-- author 테이블 생성    
create table author(
    author_id integer primary key comment '작가 아이디' 
    ,author_name varchar(100) not null comment '작가 이름'
    ,author_desc varchar(256) comment '작가 설명')
    comment '작가 정보';

/*
[연습] book 테이블 변경
 book 테이블의 author 컬럼을 삭제해 봅니다
 book 테이블에 author_id 컬럼을 추가합니다
 author 테이블의 author_id 컬럼과 같은 형식(INTEGER)으로 지정합니다
*/

-- author 컬럼 삭제
-- -> author_id (FK) -> author.author_id 참조
alter table book drop author;
    
-- author_id 컬럼 추가
-- book 테이블의 book_title 뒤에 author_id 추가 (앞에 위치하려면 반대인 before 하면 됨)
alter table book add author_id integer after book_title;

-- foreign key 추가
alter table book add constraint c_book_fk
    foreign key (author_id) references author(author_id)
        on delete set null;
        
show create table book;

drop table book;

-- 테이블 생성 시점에 Constraints 부여
create table book (
        book_id integer primary key comment '도서아이디'
        ,book_title varchar(50) not null comment '도서 제목'
        ,author_id integer
        ,rate integer check(rate in (1,2,3,4,5)) comment '별점'
        ,pub_date datetime default current_timestamp comment '출간일'
        , foreign key (author_id) references
            author(author_id) on delete set null
            ) comment '도서 정보';


drop table author;

create table author (
    author_id integer primary key auto_increment comment '작가 아이디'
    ,author_name varchar(100) not null comment '작가 이름'
    ,author_desc varchar(256) comment '작가 설명'
    ,regdate datetime default current_timestamp comment '작가 정보 등록일'
) comment '작가 정보';

select *
from author;








