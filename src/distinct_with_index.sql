explain
select count(distinct s.salary)
from employees e, salaries s
where e.emp_no = s.emp_no
and e.emp_no between 100001 and 100100;

-- 위 쿼리를 보면 단순히 from, where 절을 거치고 나서 인덱스 만을 활용해서 중복을 제거할 수 없다.
-- 따라서 임시테이블을 사용하게 될 것이다.
-- 물론 EXPLAIN FORMAT=JSON 을 사용하면 금방 알 수 있지만 실행계획을 말로 풀어서 적겠다.

-- FROM절에 두 테이블을 확인하고 접근이 가능한지 권한 체크를 할 것이다.
-- 다음으로 조인이 필요한 것을 확인하고 두 테이블 중 where절 조건에 있어서 인덱스 사용이 유리한 employees 테이블을 드라이빙 테이블로 선택한다.
-- employees 테이블을 기준으로 where절 조건에 해당하는 emp_no 컬럼을 조회해야 하는데, 여기서 emp_no는 employees 테이블을 기준으로 PK 제약조건 즉 클러스터드 인덱스이다.
-- 추가적인 조회에 필요한 컬럼이 없고, 인덱스의 컬럼만으로 조회조건을 달성하기에 using index 즉 커버링인덱스가 작동된다.

-- 다음 salaries의 경우 드라이븐 테이블이기 때문에 e.emp_no와 동일한 emp_no값을 빠르게 찾아야한다.
-- 이때 salaries 테이블에 show index 를 해보면 (emp_no, from_date)에 해당하는 인덱스가 PK제약조건 즉 클러스터드 인덱스로 잡혀있다.
-- 따라서 그러한 인덱스에서 emp_no를 기준으로 빠르게 s.emp_no 조회가 가능하다.
-- 그리고 select를 위해 salary 컬럼이 필요하기에 추가적으로 가져온다.
-- 그렇게 조인의 결과에서 salary에 distinct가 걸려있으므로 temporary 테이블을 salary기준 unique 제약조건을 걸어 insert한다.
-- 중복이 제거된 결과를 반환한다.

explain
select count(distinct s.salary),
count(distinct e.last_name)
from employees e, salaries s
where e.emp_no = s.emp_no
and e.emp_no between 100001 and 100100;

-- 이 경우도 위와 동일하게 임시 테이블을 사용하는 경우이다.
-- 왜냐하면 조인의 결과 이후 select가 영향을 받기 때문이다.
-- 위와 대부분 실행계획이 동일하지만 한가지 차이점으로 employees 테이블에 대해서 using index 즉 커버링인덱스가 Extra 컬럼에 보이지 않게 된다.
-- 그 이유는 e.last_name은 인덱스가 걸려있지 않은 컬럼이기 때문이다.
-- 물론 클러스터드 인덱스의 리프노드에는 해당 레코드의 모든 컬럼값이 들어있기 때문에 emp_no만으로 처리되는거 아니냐? 라고 할 수 있다.
-- 하지만 옵티마이저의 커버링인덱스(Using index) 의 기준은 조회에 필요한 컬럼들이 모두 인덱스로 처리가 가능하냐이다.
-- 따라서 실제 실행계획에 Extra 컬럼의 값을 보면 employees 를 기준으로 using where만 존재한다.

SHOW STATUS LIKE 'Created_tmp%';
-- 이 명령어로 실행전 실행후로 임시테이블 생성된 수가 증가함을 알 수 있다.

select count(distinct emp_no) from employees;

-- 위의 조회의 경우 emp_no는 pk 제약조건이 걸려있기 때문에, 중복이 허용안되고 null도 허용안되므로 
-- 인덱스를 순서대로 읽는것이 곧 조건을 만족하고 있기에 임시테이블이 사용되지 않는다.

select count(distinct emp_no) from dept_emp group by dept_emp;

-- 위의 테이블의 경우 복합 인덱스(emp_no, dept_emp) 에 PK 제약조건이 걸려있다.
-- 위와 동일한 이유로 임시테이블 사용이 필요없다.