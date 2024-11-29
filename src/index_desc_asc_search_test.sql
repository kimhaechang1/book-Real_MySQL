create table t1 (
	tid INT NOT NULL AUTO_INCREMENT,
    TABLE_NAME VARCHAR(64),
    COLUMN_NAME VARCHAR(64),
    ORDINAL_POSITION INT,
    PRIMARY KEY(tid)
) ENGINE=InnoDB;
-- tid에 대하여 클러스터 인덱스가 생성되고, 이는 곧 정방향 정렬로 저장된다.
INSERT INTO t1
	SELECT NULL, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION FROM information_schema.columns;

-- 12번 사용
insert into t1 
	select null, TABLE_NAME, COLUMN_NAME, ORDINAL_POSITION FROM t1;
    
-- 약 1400만건 레코드 발생
select count(*) from t1;

select * from t1 order by tid asc limit 14958591, 1; -- 정방향 정렬상태에서 정방향으로 순회하면서 가장 끝에있는 값 -- 평균적으로 6초
select * from t1 order by tid desc limit 14958591, 1; -- 정방향 정렬상태에서 역방향으로 순회하면서 가장 첫번째 값 -- 평균적으로 7초
-- 약 위 두 쿼리가 1초정도 차이가 난다.