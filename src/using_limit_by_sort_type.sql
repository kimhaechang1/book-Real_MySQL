-- 다음의 테이블이 존재한다고 생각해보자.

-- tb_test1 테이블: col1, col2의 컬럼을 가지고 있다. 레코드 건수는 100건
-- tb_test2 테이블: col3, col1의 컬럼을 가지고 있다. tb_test1 테이블의 col1 컬럼하나당 10개의 레코드를 가지며 총 1000건이 있다.

-- 두 테이블을 조인하면 1000건이 조회된다고 가정하자.

-- 다음의 쿼리를 실행할 때 각 조건별로 생각해보자.

select *
from tb_test1 t1, tb_test2 t2
where t1.col1 = t2.col1
order by t1.col2
limit 10;

-- 드라이빙 테이블도 tb_test1인 기준


-- 먼저 tb_test1 이 col2에 대해서 인덱스가 있는 경우를 생각해보자.
-- 그러면 인덱스를 사용한 정렬의 조건을 부합하게 된다.
-- 왜냐하면 첫번째 테이블에 속해있기도 하고, 인덱스 순서도 맞고, where 조건에 사용된 컬럼이 PK라면 orderby 의 인덱스와 결국 같다.

-- 따라서 인덱스를 사용한 정렬이 수행되고, 10건이 채워질 때까지 스트리밍 방식으로 처리된다.
-- 이 때 t1의 경우 col2를 기준으로 한 정렬이 되어있으므로 (인덱스 덕분), 
-- t1의 col1중에서 t2의 col1과 같은 레코드를 하나 조회하고 t2와 조인을 수행하면 전제조건에 의해 10건이 채워진다.

-- 따라서 조회의 경우 tb_test1 기준 1건, tb_test2 기준 10건, 조인의 경우 1건 수행, 정렬의 경우 0건 수행된다.


-- 반대로 드라이빙 테이블이 tb_test2인 기준으로 생각해보자.


-- 똑같은 인덱스 조건을 가지고 있기 때문에 인덱스를 사용한 정렬이 수행될 것이고, 스트리밍 방식도 동일할 것이고
-- t2 테이블을 기준으로 한 레코드씩 col1이 같은 것을 조회하고 조인을 수행하게 된다. 
-- 이 때 어짜피 col2기준으로 tb_test1은 정렬되어 있으므로, 추가 정렬이 필요하지 않다.
-- 물론 기준 테이블은 tb_test2지만, order by가 결국 t1.col2이기에 t1.col2를 기준으로 매칭하면 된다.
-- 대신 드라이빙 테이블이 t2이면서서, t1:t2가 1:10이므로, 10건의 조인이 필요하다.

-- 결국 조회의 경우 tb_test1 기준 10건, tb_test2 기준 10건, 조인의 경우 10건 수행, 정렬의 경우 0건 수행


-- 드라이빙 테이블이 tb_test1이면서 조인의 드라이빙 테이블 정렬을 사용하는 경우


-- 드라이빙 테이블의 레코드들을 전부 들고와서 order by에 따른 정렬을 수행하고, limit만큼만 레코드가 반환되도록 조인을 수행하면 된다.

-- 그러면 조회의 경우 tb_test1 기준 100건, tb_test2 기준 10건, 조인의 경우 1건 수행, 정렬의 경우 100건 수행된다.

-- 드라이빙 테이블이 tb_test2이면서 조인의 드라이빙 테이블 정렬을 사용하는 경우


-- 드라이빙 테이블의 레코드들을 전부 들고와서 order by에 따른 정렬을 수행하고, limit만큼만 레코드가 반환되도록 조인을 수행하면 된다.

-- 그러면 조회의 경우 tb_test1 기준 10건, tb_test2 기준 1000건, 조인의 경우 10건 수행, 정렬의 경우 1000건 수행된다.


-- 드라이빙 테이블이 tb_test1이면서 임시 테이블 정렬을 사용하는 경우


-- 조인의 결과가 1000건이라고 했으므로 모든 조인을 수행한 후 정렬을 수행한다.

-- 그러면 조회의 경우 tb_test1 기준 100건, tb_test2 기준 1000건, 조인의 경우 100건 수행, 정렬의 경우 1000건 수행된다.

-- 드라이빙 테이블이 tb_test2이면서 임시 테이블 정렬을 사용하는 경우


-- 조인의 결과가 1000건이라고 했으므로 모든 조인을 수행한 후 정렬을 수행한다.

-- 그러면 조회의 경우 tb_test1 기준 100건, tb_test2 기준 1000건, 조인의 경우 1000건 수행, 정렬의 경우 1000건 수행된다.

