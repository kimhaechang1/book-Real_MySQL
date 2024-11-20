-- 두 개의 MySQL client 를 사용해서 각각을 실행한다고 생각해야 한다.
-- 우선 두 클라이언트를 켰으면 아래의 코드를 통해 autocommit을 꺼야 한다.

-- 물론 실제로 MySQL에서 실행해보면 락이 해제 되기를 기다리고 있기에 멈추게 된다.
-- 아래의 예시는 어디까지나 갭락이 없는 dbms에서의 repeatable read 격리수준의 경우에 발생가능한 팬텀리드 시나리오를 얘기한다.

-- 테이블 구조는 m_id, m_name, m_area 이고 각각 INT PRIMARY KEY, VARCHAR(20), VARCHAR(20) 인 member 테이블이다.
-- 테이블에 미리 INSERT INTO member VALUES (12, 'NAME', 'CITY'); 가 하나 들어가있는 상태임을 가정한다.

set autocommit=off;

-- 세션 A

start transaction;

select * from member where m_id >= 12 for update; 

-- 여기서 사실 일반적인 갭락이 존재하는 dbms라면, 12번 레코드잠금, 12이상에 대한 갭락 혹은 넥스트 키 락이 발동한다.
-- 단순히 레코드락만 걸렸다고 가정하는 것이다.

-- 세션 B

start transaction;

insert into member values (13, 'ANOTHER', 'HELLO');

COMMIT;

-- 원래라면 락을 획득할 때 까지 쿼리가 실행되지 않고 기다려지지만, GAP락이 없는 환경에서는 실행된다.

-- 세션 A

select * from member where m_id >= 12 for update; 

-- 위 쿼리를 실행하면, 기본적으로는 미리 넣어둔 12번 레코드만 잡혀야 하지만 13번 레코드도 잡히게 된다.
-- 이것이 팬텀리드가 발생한 것이다.
-- 발생한 이유는, 분명 MVCC에는 이전값이 함께 있을것이다. 하지만 갭락에 의해 막힌다는 대답보다 먼저 봐야할 것은 잠금 획득과정이다.
-- 잠금 획득에 있어서 언두로그에 있는 12번 레코드에 대해서는 잠금을 걸 수 없다. 그렇다고 잠금을 안걸면 원래 쓰기잠금을 걸어야 하는 입장에서 말이안된다.
-- 따라서 테이블을 기준으로 잠금을 걸게 되는것이고, 그렇기에 테이블에 데이터를 그대로 조회할 수 밖에 없다.



