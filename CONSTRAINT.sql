--제약조건
--NOT NULL 
--NULL을 불허한다.
DROP TABLE EMP01;
CREATE TABLE EMP01(
			EMPNO NUMBER(4),
			ENAME VARCHAR2(10),
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2)
			);
INSERT INTO EMP01 
VALUES(NULL,NULL,'SALESMAN',30);
DESC EMP01;
DROP TABLE EMP02;
--COLUMN LEVEL CONSTRAINT
CREATE TABLE EMP02(
			EMPNO NUMBER(4) NOT NULL,
			ENAME VARCHAR2(10) NOT NULL,
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2)
			);
INSERT INTO EMP02
VALUES(NULL,NULL,'SALESMAN',30);
--NULL을 삽입 할 수 없으므로 에러가 발생한다.
DESC EMP02;

--UNIQUE 중복값을 허용하지 않는 컬럼제약
DROP TABLE EMP03;
CREATE TABLE EMP03(
			EMPNO NUMBER(4) UNIQUE,
			ENAME VARCHAR2(10) NOT NULL,
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2)
			);
INSERT INTO EMP03
VALUES(7499,'ALLEN','SALESMAN',30);

INSERT INTO EMP03
VALUES(7499,'JONES','MANAGER',20);
--무결성에 위배된다.

INSERT INTO EMP03
VALUES(NULL,'JONES','MANAGER',20);
INSERT INTO EMP03
VALUES(NULL,'JONES','MANAGER',20);
SELECT * FROM EMP03;
--NULL은 값이 아니기때문에 중복이 허용된다.
DESC EMP03;
--제약조건은 USER_CONSTRAINTS 테이블 에서 찾아 확인해야한다.(명칭이 없을경우)

--제약조건 이름은 테이블명_컬럼명_제약조건유형 의 규칙을 지켜주는것이 좋다.

CREATE TABLE EMP04(
			EMPNO NUMBER(4) CONSTRAINT EMP04_EMPNO_UK UNIQUE,
			ENAME VARCHAR2(10) CONSTRAINT EMP04_ENAME_NN NOT NULL,
			JOB VARCHAR2(9),
			DEPT NUMBER(2)
			);
DESC EMP04;
--세팅한 제약조건이름을 확인할때
SELECT TABLE_NAME, CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('EMP04');

SELECT * FROM USER_CONSTRAINTS;

--PRIMARY KEY 유일하면서 NULL을 허용하지 않는 기본키
--개체 무결성
--식별기능을 가지면서 NULL을 불허
--테이블에 반드시 값이 존재해야 한다.(행을 구분해서 볼 수 있게)
DROP TABLE EMP05;
--PRIMARY KEY는 자동으로 NOT NULL 과 UNIQUE 가 적용된다.
CREATE TABLE EMP05 (
			EMPNO NUMBER(4) CONSTRAINT EMP05_EMPNO_PK  PRIMARY KEY,
			ENAME VARCHAR2(2) CONSTRAINT EMP05_ENAME_NN NOT NULL,
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2)
			);
DESC EMP05;

--FOREIGN KEY
--참조 무결성 다른테이블(부모테이블)에 P KEY이며 이외의 데이터를 허용하지 않는..
INSERT INTO EMP
		(EMPNO,ENAME,DEPTNO)
		VALUES(8000,'SYJ',50); --무결성 제약 오류
		
SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME,R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('DEPT','EMP');

--P KEY를 참조하고있는 (REFERANCE) F KEY   PK_DEPT

DROP TABLE EMP06;

CREATE TABLE EMP06(
			EMPNO NUMBER(4) CONSTRAINT EMP06_EMPNO_PK PRIMARY KEY,
			ENAME VARCHAR2(10) CONSTRAINT EMP06_ENAME_NN NOT NULL,
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2) CONSTRAINT EMP06_DEPTNO_FK REFERENCES DEPT(DEPTNO) --DEPT TABLE의 (DEPTNO컬럼)을 참조한다.
			);
			DESC EMP06;
INSERT INTO EMP06
VALUES(9000,'YJJ','SALESMAN',40);

SELECT TABLE_NAME, CONSTRAINT_TYPE, CONSTRAINT_NAME, R_CONSTRAINT_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('DEPT','EMP07');
--USER CONSTRAINT 테이블에서 확인...


--CHECK 해당 컬럼에 입력되는 데이터의 범위, 종류, 패턴을 지정할수 있도록 걸러준다.

CREATE TABLE EMP07(
			EMPNO NUMBER(4) CONSTRAINT EMP07_EMPNO_PK PRIMARY KEY,
			ENAME VARCHAR2(10) CONSTRAINT EMP07_ENAME_NN NOT NULL, --컬럼레벨에서만 설정가능하다.
			SAL NUMBER(7,2) CONSTRAINT EMP07_SAL_CK CHECK(SAL BETWEEN 500 AND 5000),
			GENDER VARCHAR2(1) CONSTRAINT EMP07_GENDER_CK CHECK(GENDER IN('M','F'))
			);
INSERT INTO EMP07
VALUES(1111,'HONG',3000,'M');


--DEFAULT 제약 조건.. 기본값 삽입
DROP TABLE DEPT01;
CREATE TABLE DEPT01(
				DEPTNO NUMBER(2) PRIMARY KEY,
				DNAME VARCHAR2(14),
				LOC VARCHAR2(13) DEFAULT 'SEOUL'
				);
INSERT INTO DEPT01
(DEPTNO,DNAME)
VALUES(20,'JUNE');

SELECT * FROM DEPT01;


--테이블레벨 제약조건 CONSTRAINT (TABLE)
--NOT NULL을 제외한 제한 조건은 테이블레벨에서 다룰수 있다. NOT NULL은 ALTER MODIFY로 수정가능
--ALTER ADD를 이용한 테이블 구조 수정
--P KEY를 복합키로 지정할 경우 (T1,T2)로
DROP TABLE EMP01;

CREATE TABLE EMP01(
			EMPNO NUMBER(4),
			ENAME VARCHAR2(10),
			JOB VARCHAR2(9),
			DEPTNO NUMBER(2)
			);


ALTER TABLE EMP01
ADD CONSTRAINT EMP01_EMPNO_PK PRIMARY KEY(EMPNO);

ALTER TABLE EMP01
ADD CONSTRAINT EMP01_DEPTNO_FK FOREIGN KEY(DEPTNO) REFERENCES DEPT(DEPTNO);

--NOT NULL 은 MODIFY로
ALTER TABLE EMP01
MODIFY ENAME CONSTRAINT EMP01_ENAME_NN NOT NULL;

SELECT *
FROM SYS.USER_CONSTRAINTS
WHERE TABLE_NAME IN('EMP01');

ALTER TABLE EMP01
DROP CONSTRAINT EMP01_EMPNO_PK;

ALTER TABLE EMP01
DROP CONSTRAINT EMP01_ENAME_NN;

DROP TABLE EMP02;

CREATE TABLE EMP02
AS
SELECT * FROM EMP;

SELECT* FROM EMP02;
--필드에 NULL이 있으면 바꿀 수 없다.
ALTER TABLE EMP02
MODIFY COMM CONSTRAINT EMP02_COMM_NN NOT NULL;

DROP TABLE DEPT01;

CREATE TABLE DEPT01(
			DEPTNO NUMBER(2) CONSTRAINT DEPT01_DEPTNO_PK PRIMARY KEY,
			DNAME VARCHAR2(14),
			LOC VARCHAR2(13)
			);
DROP TABLE EMP01;
CREATE TABLE EMP01(
EMPNO NUMBER (4) CONSTRAINT EMP01_PK PRIMARY KEY,
ENAME VARCHAR2(10) CONSTRAINT ENAME_NN NOT NULL,
JOB VARCHAR2(9),
DEPTNO NUMBER(4) CONSTRAINT DEPTNO_FK REFERENCES DEPT01(DEPTNO)
);
INSERT INTO DEPT01 VALUES(20,'RESERCH','SEOUL');
INSERT INTO DEPT01 VALUES(10,'SALES','TOKYO'); --부모키가 존재하는데..

INSERT INTO EMP01 VALUES(7499,'ALLEN','SALESMAN',10); --에러 부모키가 없슴 
DELETE DEPT01 WHERE DEPTNO=10; --연결된 자식레코드가 있으면 삭제를 할수가 없다. 없으면 삭제가능
ROLLBACK;

--제약조건의 DISABLE ENABLE 비활성화...
ALTER TABLE EMP01
DISABLE CONSTRAINT DEPTNO_FK;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME IN('EMP01');
--DEPT_PK의 STATUS가 DISABLE 되었다.

--삭제

DELETE FROM DEPT01
WHERE DEPTNO=10;
ROLLBACK;
SELECT * FROM DEPT01;
--삭제 후 다시 활성화는 불가능하다. 참조무결성에 위반되기때문에

ALTER TABLE EMP01
ENABLE CONSTRAINT DEPTNO_FK; --부모키가 삭제되었으므로 ENABLE되지 않는다.

INSERT INTO DEPT01
VALUES(10,'DYCE','NEWYORK');

--CASCADE 파도처럼 연결된 FKEY와 PKEY를 해제시켜준다.
ALTER TABLE DEPT01
DISABLE PRIMARY KEY;
--종속된 테이블에서 FKEY로 사용중이기 때문에 DISABLE 될 수 없습니다.
--이걸 한방에 가능하게 만들어주는..옵션 키워드

ALTER TABLE DEPT01
DISABLE PRIMARY KEY CASCADE;

SELECT *
FROM SYS.USER_CONSTRAINTS
WHERE TABLE_NAME IN('DEPT01','EMP01');
--두 테이블의 PKEY FKEY STATUS가 DISABLE 된 것을 확인 할 수있다.

ALTER TABLE DEPT01
DROP PRIMARY KEY; --참조가 되어있는 상태이기 때문에 삭제는 할 수 없다. DISABLE되었다고 하더라도

ALTER TABLE DEPT01
DROP PRIMARY KEY CASCADE;
--CASCADE로 연결된 두 FKEY PKEY를 DROP해 버린다.