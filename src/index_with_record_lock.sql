use employees;
select count(*) from employees;

select count(*) from employees e where first_name = 'Georgi';
select count(*) from employees e where first_name = 'Georgi' and last_name = 'klassen';

show index from employees;
describe employees;

-- employees 테이블에서 first_name은 georgi 이며 last_name은 klassen인 사원의 입사일자를 오늘날짜로 변경하는 쿼리
update employees set hire_date = now() where first_name = 'georgi' and last_name ='klassen';

-- innodb 엔진 락 중 record lock은 인덱스를 기반으로 작동하기 때문에, first_name에만 인덱스가 걸려있는 employee 테이블에서 해당 쿼리를 실행하면
-- first_name = 'georgi' 에 대한 253건의 레코드에 대해서 모두 락이 발생한다.

explain
select * from employees e where first_name = 'Georgi' and last_name = 'klassen';