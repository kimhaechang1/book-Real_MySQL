create table tb_parent (
    id int not null,
    fd varchar(100) not null, primary key (id)
) engine=InnoDB;

create table tb_child (
    id int not null,
    pid int default null, -- 부모의 키와 제약조건이 형성됨
    fd varchar(100) default null,
    primary key (id),
    key ix_parentid (pid),
    constraint child_ibfk1 foreign key (pid) references tb_parent (id) on delete cascade
) engine=InnoDB;

insert into tb_parent values (1, 'parent-1'), (2, 'parent-2');
insert into tb_child values (100, 1, 'child-100');

-- 두 개의 클라이언트 세션이 필요함
-- A, B의 코드를 분리하자면

-- A

begin;

update tb_parent set fd='changed-2' where id=2;

-- B

begin;

update tb_child set pid=2 where id=100;

-- B 잠금 발생

-- A

rollback;

-- B update sql 실행

rollback;

-- 위의 경우에서는 자식 데이터의 쓰기가 부모 테이블에 의해 대기하는 경우이다.
-- 왜냐하면 부모 테이블에서 먼저 트랜잭션을 열고 제약조건이 매겨져 있는 id=2에 대해서 쓰기 잠금을 가져간 상태이기 때문이다.
-- tb_child의 경우 pid가 tb_parent 의 id와 이어져 있기 때문에, pid=2에 대한 쓰기작업은 곧 tb_parent의 id=2 레코드에 대한 쓰기잠금을 획득해야 함을 의미한다.

-- 아래는 부모 테이블의 쓰기가 잠금대기하는 경우이다.

-- A

begin;

update tb_child set fd='changed-100' where id=100;

-- B

begin;

delete from tb_parent where id=1;

-- B 잠금 발생

-- A

rollback;

-- B

rollback;

-- 여기서도 동일하다
-- 잠금이 발생한 이유는 먼저 A 세션에서 child 테이블의 프라이머리키 100번에 대해서 쓰기잠금을 가져간 상태이다.
-- B 세션이 이때 부모 테이블의 1번에 대해서 쓰기 잠금을 획득하려 하는데, 부모 키 1번은 CASCADE 옵션으로 인하여 해당하는 자식 레코드의 쓰기잠금을 가져와야 한다.
-- 여기서 자식 100번은 부모 1번과 연결되어 있어서, 잠금 경합이 발생하게 된다.