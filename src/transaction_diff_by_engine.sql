set autocommit=ON;

create table tab_myisam ( fdpk INT NOT NULL, PRIMARY KEY (fdpk) ) ENGINE=MyISAM;

insert into tab_myisam (fdpk) values(3);

create table tab_innodb ( fdpk INT NOT NULL, PRIMARY KEY (fdpk) ) ENGINE=INNODB;

insert into tab_innodb (fdpk) values (3);

INSERT INTO tab_myisam (fdpk) values (1), (2), (3);
INSERT INTO tab_innodb (fdpk) values (1), (2), (3);

select * from tab_myisam; -- transaction 이 보장되지 않기 때문에 실행가능한 쿼리는 실행되어서 1, 2는 저장되었다.
select * from tab_innodb; -- transaction 이 보장되기 때문에 전체 실행이 중단되었다.
