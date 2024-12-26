explain
select count(distinct s.salary)
from employees e, salaries s
where e.emp_no = s.emp_no
and e.emp_no between 100001 and 100100;

-- 위 쿼리의 경우 우선 salary가 첫 번째 테이블의 인덱스로 존재하진 않는다. 따라서 임시 테이블을 사용하게 될 것이다.
-- 드라이빙 테이블에 대해서 between에 해당하는 조건도 그렇고 where 절 조건이 드라이빙 테이블을 employees로 만들기 충분하다.
-- 또한 employees는 emp_no에 대해서 클러스터드 인덱스화 되어있다.
-- 따라서 인덱스 레인지 스캔으로 employees에서 emp_no를 읽을것이고
-- 그에 따른 조인 결과를 임시 테이블 (salary 컬럼과 동일한 타입이면서 unique 인덱스가 추가되어 있는)을 사용하여 중복을 제거한다.
-- 하지만 Using temporary는 보이지 않는다. 

-- group by에서 인덱스를 전혀 활용할 수 없는 상황이거나, order by에서 조인을 수행하고 난 뒤에 정렬을 수행해야 하는 경우에서 
-- 임시 테이블을 사용하면 Using temporary가 보이기 마련이다.

explain
select count(distinct s.salary),
count(distinct e.last_name)
from employees e, salaries s
where e.emp_no = s.emp_no
and e.emp_no between 100001 and 100100;

-- 이 경우도 위와 동일하게 임시 테이블을 사용하는 경우이다.
-- 그런데 using index가 보이지 않는다. 그 이유는 e.emp_no 의 조건은 프라이머리 키 이기 때문에 인덱스를 활용할 수 있으나,
-- distinct를 위한 last_name은 인덱스가 존재하지 않기 때문에 using index가 employees 테이블에 대해서 사라지게 된다.

SHOW STATUS LIKE 'Created_tmp%';
-- 이 명령어로 실행전 실행후로 임시테이블 생성된 수가 증가함을 알 수 있다.