
-- 아래의 쿼리들의 GROUP BY 시 EXPLAIN 실행계획 Extra 를 예상해보자.

explain
select emp_no, from_date
from salaries
group by emp_no, from_date;
-- group by 에 사용된 컬럼들이 첫 번째 테이블에 포함되어 있으며 인덱스 순서가 같다.
-- 루즈 인덱스 스캔을 사용하지 않을 가능성이 높다.
-- 인덱스를 그대로 읽어오는 GROUP BY 를 수행한다.

explain
select emp_no, from_date
from salaries
group by emp_no, from_date;
-- 집계함수가 없는 group by 의 경우 group by 를 사용한 것과 유사하게 실제로 실행된다.
-- 따라서 위의 조건과 동일하므로 인덱스를 그대로 읽어오는 GROUP BY 를 수행한다.

explain
select emp_no, min(from_date)
from salaries
group by emp_no;
-- group by 의 컬럼이 첫 번째 테이블에 속하고
-- 인덱스 순서도 동일하다. 그기에다가 (emp_no, from_date)로 인덱스가 잡혀있기에
-- 같은 emp_no일지라도 from_date 값 또하 정렬되어 있다. 즉, 각 emp_no별로 첫 번째 from_date만 읽으면 된다.
-- 중복된 emp_no가 많다고 판단 할 것이며, 이에 따라 루즈 인덱스 스캔이 발생한다.


