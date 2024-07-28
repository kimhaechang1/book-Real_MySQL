# 사용자 계정 추가

CREATE USER 'user'@'%'                                      # 모든 호스트에 대해서 접근가능한 계정
    IDENTIFIED WITH 'mysql_native_password' by 'password'   # 비밀번호 암호화 수준 결정 by절 뒤에 비밀번호 (mysql_native_password: SHA-1)
    REQUIRE NONE                                            # SSL 및 보안접속 여부 결정 (Caching SHA-2 Authentication 사용시 자동으로 켜짐)
    PASSWORD EXPIRE INTERVAL 30 DAY                         # 비밀번호 만료 기한 (30일)
    ACCOUNT UNLOCK                                          # 계정 잠금 결정 (비 잠금)
    PASSWORD HISTORY DEFAULT                                # 비밀번호 히스토리 설정 (이전 비밀번호를 얼마나 저장할 것인지)
    PASSWORD REUSE INTERVAL DEFAULT                         # 비밀번호 재사용에 대한 설정 (이전 비밀번호를 어떤기간후에 재사용 가능한지)
    PASSWORD REQUIRE CURRENT DEFAULT;                       # 비밀번호 만료로 인한 새 설정시 기존 비밀번호 입력과 관련한 설정


# 글로벌 권한 추가

GRANT SUPER ON *.* TO 'user'@'localhost'; # O
GRANT SUPER ON employees.* TO 'user'@'localhost'; # X : 항상 모든 테이블 혹은 DB여야 한다.

# 객체 권한 추가

GRANT EVENT ON employees.* TO 'user'@'localhost'; # O
GRANT EVENT ON employees.employees TO 'user'@'localhost'; # X : DB에만 사용가능하다.


# 역할 실습

# 역할 두가지 추가

CREATE ROLE role_emp_read role_emp_write;

# 계정 생성

CREATE USER reader@'127.0.0.1' IDENTIFIED 'qwerty';
CREATE USER writer@'127.0.0.1' IDENTIFIED 'qwerty';

# 역할 삭제

# CREATE ROLE [역할 명];

# 역할에 권한 부여

GRANT SELECT ON employee.* TO role_emp_read;
GRANT INSERT, UPDATE, DELETE ON employee.* TO role_emp_write;

# 계정에 역할 부여

GRANT role_emp_read TO reader@'127.0.0.1';
GRANT role_emp_write TO writer@'127.0.0.1';

# 계정 상태 확인

SELECT USER, HOST, account_locked FROM mysql.user;

# 계정 접속

mysql -h 127.0.0.1 -u reader -p

# 접속 후 권한 설정 확인 

SELECT current_role();

# 권한이 부여되어 있지 않을시 수동 방법

SET ROLE 'role_emp_read';

# 로그인시 활성화 하는방법

SET GLOBAL activate_all_roles_on_login=ON;