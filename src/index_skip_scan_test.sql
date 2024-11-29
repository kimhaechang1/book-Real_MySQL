use employees;

alter table employees add index ix_gender_birthdate (gender, birth_date);

set optimizer_switch='skip_scan=off';

explain
select gender, birth_date
from employees
where birth_date >= '1965-02-01';
-- type: index 이란 뜻은 풀 인덱스 스캔을 사용했다는 것이다.
-- 왜냐하면 첫 번째 인덱스를 사용하고 있지 않아서 이다.

-- 그리고 다시 스킵스캔 기능을 켜보자

set optimizer_switch='skip_scan=on';

explain
select gender, birth_date
from employees
where birth_date >= '1965-02-01';

-- type 이 range인데, 이는 인덱스 중에서도 꼭 필요한 부분만 읽었다는 것을 의미한다.
-- 그리고 Extra쪽에 Using index for skip scan으로 스킵스캔을 사용했다는 것이 확인가능하다.
-- 마치 아래의 두 쿼리의 실행결과를 반환환것과 비슷한 효율을 낸다.

select gender, birth_date from employees where gender = 'M' and birth_date >= '1965-02-01';
select gender, birth_date from employees where gender = 'F' and birth_date >= '1965-02-01';