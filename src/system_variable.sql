# join_buffer_size 는 both scope의 system variable임

show global variables like 'join_buffer_size';
# 글로벌 변수로 조회

show variables like 'join_buffer_size';
# 세션 변수로 조회

set global join_buffer_size=524288;
# 글로벌 변수 수정

show variables like 'join_buffer_size';
# 세션 변수로서 조회했을 때 변동이 없음

show global variables like 'join_buffer_size';
# 글로벌 변수는 수정되어있는 모습을 볼 수 있음

set global join_buffer_size=262144;
# 다시 원상 복구

show global variables like 'rand_seed1';
# SESSION SCOPE 변수라서 조회 되지 않음

show variables like 'rand_seed1';
# global 키워드를 제거하면 조회됨

