
explain
select emp_no
from salaries
where from_date='1985-03-01'
group by emp_no;

-- salaries는 (emp_no, from_date) 에 대한 primary key 제약조건, salaries 에 대한 세컨더리 인덱스가 잡혀있다.
-- emp_no를 통한 group by는 인덱스를 활용하면 되나, 그대로 다 읽으면 안된다.
-- 왜냐하면 where 절 조건이 있기 때문에 신중하게 선택해야 한다. 
-- 다행히 복합 인덱스로 인해 같은 emp_no 안에서도 from_date가 정렬되어 있다.
-- 따라서 하나의 emp_no를 읽고서 from_date에 대한 where 절 조건이 만족되는지 확인하면 된다.
-- 확인이 완료된 emp_no는 다음 emp_no 번호가 등장할때 까지 모두 건너뛰게 된다.
