explain
select *
from dept_emp de, employees e
where de.from_date > '1995-01-01' and e.emp_no < 109004;

-- 위의 쿼리는 조인 연산이 수행되는데
-- where절에 조인조건이 아닌 일반적인 컬럼에 대한 필터링 조건만 있으므로
-- dept_emp 레코드와 employees 레코드에 대한 카테시안 곱이 발생한다.

-- 그러면 Join Buffer를 활용하게 될 것이고, 드라이빙 테이블의 컬럼을 미리 메모리위에 올려놓고
-- 드라이븐 테이블을 들고와서 조인을 한번에 수행하게 된다.

-- 하지만 실제로 실행해보면 Using Join Buffer는 나오지만 (block nested loop) 가 아닌 (hash join) 이 나오는데
-- 이는 MySQL 8.0.20 버전부터 Block Nested Loop Join 대신 Hash Join을 수행하도록 대체되었기 때문이다.

-- 어쨋든 조인버퍼를 사용한다는 점과 MRR로 이어지는 키워드를 생각하면 좋다.