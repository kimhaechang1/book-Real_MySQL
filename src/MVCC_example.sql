## 두개의 세션이 필요하다는것을 명심하자

## session 1

select @@autocommit;
SET @@autocommit=0;

create schema if not exists realmysql;

use realmysql;

CREATE TABLE if not exists member (
    m_id INT NOT NULL,
    m_name VARCHAR(20) NOT NULL,
    m_area VARCHAR(100) NOT NULL, 
    PRIMARY KEY (m_id),
    INDEX ix_area (m_area)
);

start transaction;

insert into member(m_id, m_name, m_area) values (12, '홍길동', '서울');

commit;

start transaction;

update member set m_area='경기' where m_id = 12;

## session 2

select * from member;

select @@session.transaction_isolation;

set @@SESSION.transaction_isolation = 'read-uncommitted';