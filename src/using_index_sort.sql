
use employees;

explain
select * 
from employees e, salaries s
where s.emp_no = e.emp_no
and e.emp_no between 100002 and 100010
order by e.emp_no

-- 위의 쿼리를 살펴보면, from 절에 조인이 필요한 두 테이블이 있는것이 확인되고
-- where 절 조건을 보게 되면 emp_no는 두 테이블에 모두 있지만, 100002, 100010 의 경우 PK 제약조건이 emp_no에 있는 employees가 드라이빙 테이블로 선정된다.
-- 그럼 반대로 salaries는 드라이븐 테이블이 된다.
-- 다음으로 orderby 에 사용되는 e.emp_no는 첫번째 테이블에 속해있고 인덱스 순서도 동일하다.
-- 마지막으로 조건절에 첫 번째 테이블에 소속된 emp_no는 order by의 emp_no와 인덱스상 동일하다.
-- 따라서 인덱스 정렬을 그대로 사용하므로 
-- 실행 했을 때 Extra 컬럼에 Using where; 만 존재하게 된다.


