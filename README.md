# Real MySQL

## 예제 데이터베이스 파일

<a href="https://github.com/wikibook/realmysql80">Real MySQL github</a>

## Chapter 2 설치와 설정

<ul>
    <li><a href="docs/ch02.md">연결과 설정</a></li>
</ul>

## Chapter 3 사용자 및 권한

<ul>
    <li><a href="docs/ch03.md">계정, 역할 그리고 권한</a></li>
</ul>

## Chapter 4 아키텍처

### MySQL 구조
<ul>
    <li><a href="docs/ch04-1-1.md">스레드, 메모리 할당 및 사용</a></li>
    <li><a href="docs/ch04-1-2.md">쿼리 실행 구조와 트랜잭션을 지원하는 메타 데이터</a></li>
</ul>

### InnoDB 스토리지 엔진 구조

<ul>
    <li><a href="docs/ch04-2-1.md">프라이머리 키와 외래키</a></li>
    <li><a href="docs/ch04-2-2.md">MVCC와 잠금없는 일관된 읽기</a></li>
    <li><a href="docs/ch04-2-3.md">자동 데드락 감지</a></li>
    <li><a href="docs/ch04-2-4.md">버퍼 풀</a></li>
    <li><a href="docs/ch04-2-5.md">Double Wirte Buffer & Undo log</a>
</ul>

## Chapter 5 트랜잭션과 잠금 (중요)

<ul>
    <li><a href="docs/ch05-lock.md">잠금</a></li>
    <li><a href="docs/ch05-transaction.md">트랜잭션</a></li>
</ul>

## Chapter 8 인덱스 (중요)

<ul>
    <li><a href="docs/ch08-인덱스.md">B트리 인덱스</a></li>
</ul>

## Chapter 9 옵티마이저와 힌트 (중요)

### 옵티마이저 기본
<ul>
    <li><a href="docs/ch09-실행절차와 ORDER BY.md">쿼리 실행절차와 ORDER BY</a></li>
    <li><a href="docs/ch09-GROUP BY와 DISTINCT.md">GROUP BY 와 DISTINCT</a></li>
    <li><a href="docs/ch09-임시테이블.md">내부 임시 테이블 활용</a></li>
</ul>

### 고급 최적화 (지속적 업데이트, 내용 방대)

<ul>
    <li><a href="docs/ch09-Nested Loop Join 과 Join Buffer (Block Nested loop).md">Nested Loop Join 과 Join Buffer를 활용한 Disk I/O 최적화</a></li>
    <li><a href="docs/ch09-해시조인.md">해시 조인</a></li>
    <li><a href="docs/ch09-스킵스캔.md">스킵 스캔</a></li>
    <li><a href="docs/ch09-고급최적화.md">위 내용 밖의 고급 최적화</a></li>
</ul>

### 힌트

<ul>
    <li><a href="docs/ch09-인덱스 힌트.md"></a></li>
    <li><a href="docs/ch09-옵티마이저 힌트.md"></a></li>
</ul>

## Chapter 10 실행 계획 (중요)