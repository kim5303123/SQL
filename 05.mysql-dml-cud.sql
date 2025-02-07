--------------------------
-- CUD
--------------------------
use test_db;
desc author;

-- 테이블 비우기
truncate author;

-- insert : 테이블에 새 데이터를 추가(create)
-- 데이터를 넣을 컬럼을 지정하지 않으면 전체 데이터를 제공해야한다.
insert into author values(1, '박경리', '토지작가');

select * 
from author;

-- 특정 컬럼의 내용만 입력할 때는 컬럼 목록을 지정한다.
-- author의 author_id는 PK AUTO_INCREMENT 했기 때문에 직접 입력하지 않아도 된다.
insert into author (author_id, author_name) values (2, '김영하');

select * 
from author;

insert into author values(3,'무명씨','그냥작가');

select * 
from author;

-- update
update author set author_desc='알쓸신잡 출연'
where author_id=2;

select *
from author;

-- 주의 : update , delete는 where절을 이용 변경 조건을 부여해야 한다.

-- delete
delete from author 
where author_id =3;

select *
from author;

-- workbench 보호 장치 해제
-- edit > preferences
-- > sql editor > safe update 해제
-- workbench 재시작

select @@autocommit;    --  1: 오토커밋 on , 0: 오토커밋 off

set autocommit=0;   --  autocommit off

create table transactions (
    id integer primary key auto_increment
    ,log varchar(100)
    ,logdate datetime default now()
    );

start transaction;

insert into transactions (log) values ('1번째 insert');
INSERT INTO transactions (log) VALUES ('2번째 INSERT');
SELECT * FROM transactions;

-- 세이브포인트 설정
SAVEPOINT x1;
SELECT * FROM transactions;

INSERT INTO transactions (log) VALUES ('3번째 INSERT');
SELECT * FROM transactions;

ROLLBACK TO x1;
SELECT * FROM transactions;

-- 트랜잭션 진행중

-- 변경 사항 반영
commit;
select * 
from transactions;

start transaction;

delete
from transactions;
select *
from transactions;

rollback;
select *
from transactions;

-- truncate는 transaction의 대상이 아니다.
truncate table transactions;
select *
from transactions;

-- safe update 원상 복구
SELECT * FROM transactions;