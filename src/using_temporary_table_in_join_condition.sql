use employees;

explain
select * 
from employees e, salaries s
where s.emp_no = e.emp_no
and e.emp_no between 100002 and 100010
order by s.salary

-- 위의 쿼리를 살펴보면, from 절에 조인이 필요한 두 테이블이 있는것이 확인되고
-- where 절 조건을 보게 되면 emp_no는 두 테이블에 모두 있지만, 100002, 100010 의 경우 PK 제약조건이 emp_no에 있는 employees가 드라이빙 테이블로 선정된다.
-- 그럼 반대로 salaries는 드라이븐 테이블이 된다.
-- 다음으로 orderby 에 사용되는 s.salary는 첫 번째 테이블에 소속되어 있지 않다.
-- 마지막으로 조건절에 첫 번째 테이블에 소속된 emp_no는 order by에 s.salary가 첫 번째 테이블에 소속되어 있지 않기 때문에, 조인 드라이빙 테이블을 사용할 정렬도 수행할 수 없다.
-- 실행하면 Extra절에 Using temporary;Using filesort;Using where 로 되어있다.
-- 이는 두 테이블의 조인결과를 임시 테이블에 저장하고 소트 버퍼와 멀티 머지를 활용한 filesort를 사용했다는 것이다.