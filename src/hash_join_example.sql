use employees;
explain
select *
from employees e ignore index (primary, ix_hiredate)
inner join dept_emp de ignore index (ix_empno_fromdate, ix_fromdate)
on de.emp_no = e.emp_no and de.from_date=e.hire_date;

-- 현재 employees 에는 emp_no가 pk로 걸려있고, hire_date에 인덱스가 추가로 있다.
-- 그리고 dept_emp 테이블에는 from_date의 단독 인덱스와 emp_no, from_date로 결합된 복합인덱스가 있다.
-- 조인 조건을 보면 emp_no와 from_date = hire_date로서 모두 인덱스가 걸린 컬럼이기 때문에
-- ignore가 없으면 인덱스를 사용할 수 있으나, 막아놨기 때문에 인덱스를 사용하지 못하는 조인이 된다.
-- 이러한 경우 차선책으로 hash_join을 사용하게 된다.

explain format=tree
select *
from employees e ignore index (primary, ix_hiredate)
inner join dept_emp de ignore index (ix_empno_fromdate, ix_fromdate)
on de.emp_no = e.emp_no and de.from_date=e.hire_date;

-- 이를 실행해보면 Hash 보다 안쪽으로 들여쓰기 된 테이블이 바로 빌드 테이블이 된다.

-- 그러면 아래와 같이 ignore를 제거하면 using index가 발생할까?
explain
select *
from employees e
inner join dept_emp de
on de.emp_no = e.emp_no and de.from_date=e.hire_date;

-- 놀랍게도 ALL 즉, 풀 테이블 스캔을 감행하게 된다.
-- 왜냐하면 인덱스를 사용하려고 해도 다른 레코드들 또한 select해야하기 때문이다.
-- using index 즉 커버링인덱스의 의미는 해당 인덱스만을 사용해서 조회가 문제없어야 한다는 것이다.

-- 차라리 아래와 같이 조회하면 이제 커버링 인덱스가 작동하게 되는것이다.

explain
select e.emp_no, e.hire_date, de.from_date
from employees e
inner join dept_emp de
on de.emp_no = e.emp_no and de.from_date=e.hire_date;

-- 
