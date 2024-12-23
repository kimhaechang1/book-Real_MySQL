use employees;

explain
select * 
from employees e, salaries s
where s.emp_no = e.emp_no
and e.emp_no between 100002 and 100010
order by e.last_name

-- 위의 쿼리를 살펴보면, from 절에 조인이 필요한 두 테이블이 있는것이 확인되고
-- where 절 조건을 보게 되면 emp_no는 두 테이블에 모두 있지만, 100002, 100010 의 경우 PK 제약조건이 emp_no에 있는 employees가 드라이빙 테이블로 선정된다.
-- 그럼 반대로 salaries는 드라이븐 테이블이 된다.
-- 다음으로 orderby 에 사용되는 e.last_name 첫번째 테이블에 속해 있지만, 인덱스는 아니다.
-- 마지막으로 조건절에 첫 번째 테이블에 소속된 emp_no는 order by에 e.last_name가 인덱스가 아니어서 인덱스를 사용한 정렬을 사용할 수 없다.
-- 따라서 조건절도 그렇고 order by도 그렇고 드라이빙 테이블만으로 충분히 정렬수행이 가능하지만, 인덱스를 사용할 수 없기 때문에 조인 드라이빙 테이블 정렬을 수행한다.
-- 실행하면 Extra절에 Using filesort;Using where 로 되어있다.
-- 이는 인덱스를 사용할 수 없기 때문에 소트 버퍼와 멀티 머지를 활용한 filesort를 사용했다는 것이다.