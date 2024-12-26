
-- 인덱스를 전혀 사용하지 못하는 경우이다.
-- 말그대로 첫 번째 테이블에 아에 없는 컬럼을 사용한다던가
-- 드라이빙 테이블만을 사용해서 그루핑 할 수 없는 상황에 해당 될 것이다.

select e.last_name, AVG(s.salary)
from employees e, salaries s
where s.emp_no = e.emp_no
group by e.last_name;

-- last_name을 기준으로 group-by 를 수행하는데, 
-- last_name은 employees 와 salaries 테이블의 조인에서 드라이빙 테이블인 employees에 속하긴 하지만
-- group by 에서는 인덱스를 전혀 사용하지 못한다면 임시 테이블을 사용하게 되어있다.
-- 만약 order by 의 경우였다면 file_sort만 일어났을 것이다.

-- 따라서 임시 테이블을 사용해서 그루핑을 수행하는데
-- 다음과 같은 임시 테이블이 생성될 것이다.
-- 바로 last_name에 대해서 유니크 인덱스가 잡혀있는 임시 테이블이다.
CREATE TEMPORARY TABLE ... (
    last_name VARCHAR(),
    salary INT,
    UNIQUE INDEX ux_lastname (last_name)
)

-- 위의 임시테이블에 insert 혹은 update를 실행한다.
-- 그리하여 중복을 제거하게 된다.