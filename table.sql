--ROW ID 오라클에서 데이타 삽입시 부여하는 ROW의 주소값
SELECT ROWID, EMPNO, ENAME
FROM EMP;

--테이블 생성
CREATE TABLE EMP01(
			EMPNO NUMBER(4),
			ENAME VARCHAR2(20),
			SAL NUMBER(7,2));
DESC EMP01;

--구조와 데이터를 동일하게 만들고 싶을때 AS SELECT 제약조건은 복사(P KEY, F KEY)가 되지 않는다.
CREATE TABLE EMP02
AS
SELECT *FROM EMP;

SELECT *
FROM EMP02;
DESC EMP02;
DESC EMP;

CREATE TABLE EMP03
AS
SELECT EMPNO,ENAME
FROM EMP;

DESC EMP03;
SELECT *
FROM EMP03;
--DETNO가 10인 결과가 복제
CREATE TABLE EMP05
AS
SELECT *
FROM EMP
WHERE DEPTNO=10;

SELECT *
FROM EMP05;

--구조만 복사할때 조건이 (EX..1=0) 거짓인 값을 WHERE절에 넣는다.

CREATE  TABLE EMP06
AS
SELECT * 
FROM EMP
WHERE 1=0;

SELECT* 
FROM EMP06;

DROP TABLE DEPT02;

CREATE TABLE DEPT02
AS
SELECT *
FROM DEPT
WHERE 1=0;

SELECT *
FROM DEPT02;

--ALTER 테이블의 구조를 변경하는 키워드
--컬럼 추가 변경 삭제,
--ADD, MODIFY,  DROP COLUMN
--ADD 추가
ALTER TABLE EMP01
ADD(JOB VARCHAR2(9));

SELECT *
FROM DEPT02;

ALTER TABLE DEPT02
ADD(DMGR NUMBER(4));

DESC DEPT02;

DESC EMP01
--수정 MODIFY
ALTER TABLE EMP01
MODIFY(JOB VARCHAR2(30));

--삭제 DROP COLUMN columnname 

ALTER TABLE EMP01
DROP COLUMN JOB;
DESC EMP01;

--SET UNUSED 데이터 접근제한을 걸어둘 수있다.(데이터는 유지하지만)

ALTER TABLE EMP02
SET UNUSED(JOB);

SELECT * FROM EMP02;


--DROP TABLE 
-- 테이블의 모든 데이터와 테이블을 삭제한다.
DROP TABLE EMP01;

SELECT *
FROM EMP02;
--TRUNCATE 는 복구 불가한 삭제
TRUNCATE TABLE EMP02;


RENAME EMP03 TO EMP02;

--DATA DICTIONARY 데이터 사전
--원데이터는 직접적인 접근이 어렵다.
--DATA DICTIONARY VIEW를 이용해서 정보를 확인한다.
--VIEW(가상테이블) 물리적인데이터가 존재하지 않는다.

-- DBA_  ALL_   USER ..
--USER 자신의 계정이 소유한 객체등의 정보를 확인할수있다.

DESC USER_TABLES;

SHOW USER;--현재 사용자를 알려준다.

SELECT TABLE_NAME 
FROM USER_TABLES
ORDER BY TABLE_NAME DESC;
-- 계정의 테이블 목록을 확인 할수 있다.

--DBA_ 는 DBA 접근자만 가능하다.
SELECT TABLE_NAME, OWNER
FROM DBA_TABLES;
--SCOTT계정은 접근불가

