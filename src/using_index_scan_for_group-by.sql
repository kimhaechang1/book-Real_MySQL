show index from salaries;

-- salaries 테이블은 emp_no, from_date, salary 라는 3가지 컬럼을 갖고 있다.
-- salaries 테이블의 인덱스를 살펴보면 emp_no, from_date 에 PRIMARY 키 제약조건이 달려있고, salary는 세컨더리 인덱스로 적용되어 있다.

explain select emp_no, from_date from salaries group by emp_no, from_date;

-- 위의 쿼리를 실행하게 되면 인덱스만을 사용하는 group-by 의 조건을 만족한다.
-- 왜냐하면 첫 번째(조인 시 드라이빙 테이블)에 group-by의 컬럼이 모두 속해있으며 그 인덱스 순서도 동일하기 때문이다.
-- 따라서 실행계획에 Using index for group-by는 나오지 않는다.