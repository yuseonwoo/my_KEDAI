-- 오라클 계정 생성을 위해서는 SYS 또는 SYSTEM 으로 연결하여 작업을 해야 합니다. [SYS 시작] --
show user;
-- USER이(가) "SYS"입니다.

-- 오라클 계정 생성 시 계정명 앞에 c## 붙이지 않고 생성하도록 하겠습니다.
alter session set "_ORACLE_SCRIPT"=true;
-- Session이(가) 변경되었습니다.

-- 오라클 계정명은 final_orauser5 이고 암호는 gclass 인 사용자 계정을 생성합니다.
create user final_orauser5 identified by gclass default tablespace users; 
-- User FINAL_ORAUSER5이(가) 생성되었습니다.

-- 위에서 생성되어진 FINAL_ORAUSER5 이라는 오라클 일반사용자 계정에게 오라클 서버에 접속이 되어지고,
-- 테이블 생성 등등을 할 수 있도록 여러가지 권한을 부여해주겠습니다.
grant connect, resource, create view, unlimited tablespace to final_orauser5;
-- Grant을(를) 성공했습니다.

-- 접속 - 새접속 - Name: remote_final_orauser5 사용자이름: final_orauser5 비밀번호: gclass 비밀번호 저장 - 테스트 - 저장 - 취소

-----------------------------------------------------------------------

show user;
-- USER이(가) "FINAL_ORAUSER5"입니다.

-- 테이블 주석문
comment on table tbl_jikwon 
is '우리회사 사원들의 정보가 들어있는 테이블';

-- 테이블 주석문 확인
select *
from user_tab_comments
where table_name = 'tbl_jikwon'; 

-- 컬럼명 주석문
comment on column tbl_jikwon.saname is '사원명'; 
comment on column tbl_jikwon.salary is '기본급여 기본값은 100'; 
comment on column tbl_jikwon.comm is '수당 null 허락함'; 

-- 컬럼명 주석문 확인
select column_name, comments
from user_col_comments
where table_name = 'tbl_jikwon';

-----------------------------------------------------------------------

-- 부서 테이블
create table tbl_dept
(dept_code  NUMBER(4)     not null
,dept_name  VARCHAR2(30)  not null
,constraint PK_tbl_dept_dept_code primary key(dept_code)
);
-- Table TBL_DEPT이(가) 생성되었습니다.

comment on table tbl_dept 
is '부서 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_dept.dept_code is '부서코드'; 
comment on column tbl_dept.dept_name is '부서명'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_DEPT';

select column_name, comments
from user_col_comments
where table_name = 'TBL_DEPT';

-----------------------------------------------------------------------

-- 직급 테이블
create table tbl_job
(job_code  NUMBER(4)     not null
,job_name  VARCHAR2(30)  not null
,constraint PK_tbl_job_job_code primary key(job_code)
);
-- Table TBL_JOB이(가) 생성되었습니다.

comment on table tbl_job 
is '직급 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_job.job_code is '직급코드'; 
comment on column tbl_job.job_name is '직급명'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_JOB';

select column_name, comments
from user_col_comments
where table_name = 'TBL_JOB';

-----------------------------------------------------------------------

-- 사원 테이블
create table tbl_employees
(empid              VARCHAR2(30)   not null
,pwd                VARCHAR2(200)  not null
,name               VARCHAR2(30)   not null
,nickname           VARCHAR2(30)
,jubun              VARCHAR2(13)   not null
,email              VARCHAR2(200)  not null
,mobile             VARCHAR2(200)  not null
,postcode           VARCHAR2(5)    not null
,address            VARCHAR2(200)  not null
,detailaddress      VARCHAR2(200)
,extraaddress       VARCHAR2(200)
,imgfilename        VARCHAR2(100)
,hire_date          DATE           not null
,salary             NUMBER         not null
,commission_pct     NUMBER(2,2)
,point              NUMBER DEFAULT 0      not null
,fk_dept_code       NUMBER(4)
,fk_job_code        NUMBER(4)         
,dept_tel           VARCHAR2(30)
,lastpwdchangedate  DATE DEFAULT SYSDATE  not null
,status             NUMBER(1) DEFAULT 1   not null 
,sign_img           VARCHAR2(100)
,constraint PK_tbl_employees_empid        primary key(empid)
,constraint FK_tbl_employees_fk_dept_code foreign key(fk_dept_code) references tbl_dept(dept_code)
,constraint FK_tbl_employees_fk_job_code  foreign key(fk_job_code)  references tbl_job(job_code)
,constraint UQ_tbl_employees_email        unique(email)
,constraint CK_tbl_employees_status       check(status in(0,1))
);
-- Table TBL_EMPLOYEES이(가) 생성되었습니다.

comment on table tbl_employees 
is '사원 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_employees.empid is '사원아이디'; 
comment on column tbl_employees.pwd is '비밀번호'; 
comment on column tbl_employees.name is '이름'; 
comment on column tbl_employees.nickname is '닉네임'; 
comment on column tbl_employees.jubun is '주민번호'; 
comment on column tbl_employees.email is '이메일'; 
comment on column tbl_employees.mobile is '연락처'; 
comment on column tbl_employees.postcode is '우편번호'; 
comment on column tbl_employees.address is '주소'; 
comment on column tbl_employees.detailaddress is '상세주소'; 
comment on column tbl_employees.extraaddress is '참고항목'; 
comment on column tbl_employees.imgfilename is '이미지파일명'; 
comment on column tbl_employees.hire_date is '입사일자'; 
comment on column tbl_employees.salary is '기본급여'; 
comment on column tbl_employees.commission_pct is '수당 퍼센티지'; 
comment on column tbl_employees.point is '포인트'; 
comment on column tbl_employees.fk_dept_code is '부서코드'; 
comment on column tbl_employees.fk_job_code is '직급코드'; 
comment on column tbl_employees.dept_tel is '내선번호'; 
comment on column tbl_employees.lastpwdchangedate is '마지막암호변경날짜시각'; 
comment on column tbl_employees.status is '퇴사유무'; 
comment on column tbl_employees.sign_img is '결재서명이미지'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_EMPLOYEES';

select column_name, comments
from user_col_comments
where table_name = 'TBL_EMPLOYEES';

-- 컬럼 추가하기
alter table tbl_employees
add orgimgfilename VARCHAR2(100);
-- Table TBL_EMPLOYEES이(가) 변경되었습니다.

comment on column tbl_employees.imgfilename is 'WAS(톰캣)에저장될이미지파일명'; 
comment on column tbl_employees.orgimgfilename is '실제이미지파일명'; 
-- Comment이(가) 생성되었습니다.

-----------------------------------------------------------------------

-- 로그인 기록 테이블
create table tbl_loginhistory
(history_seq  NUMBER                not null
,fk_empid     VARCHAR2(30)          not null
,logindate    DATE DEFAULT sysdate  not null
,clientip     VARCHAR2(20)          not null
,constraint PK_tbl_loginhistory primary key(history_seq)
,constraint FK_tbl_loginhistory_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);
-- Table TBL_LOGINHISTORY이(가) 생성되었습니다.

create sequence loginhistory_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence LOGINHISTORY_SEQ이(가) 생성되었습니다.

comment on table tbl_loginhistory 
is '로그인기록 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_loginhistory.history_seq is '기록번호'; 
comment on column tbl_loginhistory.fk_empid is '사원아이디'; 
comment on column tbl_loginhistory.logindate is '로그인날짜시각'; 
comment on column tbl_loginhistory.clientip is '접속IP주소'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_LOGINHISTORY';

select column_name, comments
from user_col_comments
where table_name = 'TBL_LOGINHISTORY';

-----------------------------------------------------------------------

-- 로그인 처리하기
desc tbl_employees;
desc tbl_loginhistory;

SELECT empid, name, nickname, jubun, gender, age, email, mobile
     , postcode, address, detailaddress, extraaddress
     , imgfilename, orgimgfilename, hire_date, salary, commission_pct, point
     , fk_dept_code, dept_name, fk_job_code, job_name, dept_tel, sign_img, annual_leave, pwdchangegap
     , NVL(lastlogingap, trunc(months_between(sysdate, hire_date))) AS lastlogingap
FROM 
(
    select empid, name, nickname, jubun
         , func_gender(jubun) AS gender
         , func_age(jubun) AS age
         , email, mobile, postcode, address, detailaddress, extraaddress
         , imgfilename, orgimgfilename, to_char(hire_date, 'yyyy-mm-dd') AS hire_date, salary, commission_pct, point
         , fk_dept_code, nvl(D.dept_name, ' ') AS dept_name
         , fk_job_code, nvl(J.job_name, ' ') AS job_name
         , dept_tel, sign_img, annual_leave
         , trunc(months_between(sysdate, lastpwdchangedate)) AS pwdchangegap
    from tbl_employees E1 
    LEFT JOIN tbl_dept D ON E1.fk_dept_code = D.dept_code
    LEFT JOIN tbl_job J ON E1.fk_job_code = J.job_code
    where status = 1 and empid = '2010001-001' and pwd = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
) E2 
CROSS JOIN 
( 
    select trunc(months_between(sysdate, max(logindate))) AS lastlogingap 
    from tbl_loginhistory 
    where fk_empid = '2010001-001'
) H

insert into tbl_loginhistory(history_seq, fk_empid, logindate, clientip)
values(loginhistory_seq.nextval, #{empid}, default, #{clientip})

select empid 
from tbl_employees
where status = 1 and name = '관리자' and email = 'KmwWd6gn2fheAtIEcHhtdq4ZISt5PKTmXRFHRew2vWc=';

-----------------------------------------------------------------------

-- 아이디 찾기
select empid
from tbl_employees
where status = 1 and name = ? and email = ?;

-- 아이디 중복확인하기
select empid
from tbl_employees
where empid = '2012100-001';

-- 비밀번호 찾기
select pwd
from tbl_employees
where status = 1 and empid = '2014100-004' and name = '이지은' and email = 'gpYWbUyoXF5e21I/zchLYZa5CieVh0uqW9c6k7/niIU=';

-- 비밀번호 변경하기
update tbl_employees set pwd = '9695b88a59a1610320897fa84cb7e144cc51f2984520efb77111d94b402a8382'
where empid = '2012100-001';

commit;
-- 커밋 완료.

-----------------------------------------------------------------------

select *
from tbl_employees
where fk_dept_code = '200'
order by fk_job_code asc;   

delete from tbl_employees
where empid = '2010001-001'

commit;
-- 커밋 완료.

select dept_code, dept_name
from tbl_dept;
/*
    100	인사부
    200	영업지원부
    300	회계부
    400	상품개발부
    500	마케팅부
    600	해외사업부
    700	온라인사업부
*/

select job_code, job_name
from tbl_job;
/*
    1   대표이사
    2   전무
    3   상무
    4   부장
    5	과장
    6	차장
    7	대리
    8	사원
*/

update tbl_job set job_name = '대표이사'
where job_code = 1;

insert into tbl_job(job_code, job_name)
values(8, '사원');

commit;
-- 커밋 완료.

select *
from tbl_employees
where fk_dept_code = '100'
order by fk_job_code;

update tbl_employees set fk_job_code = 1
where empid = '2010001-001';

commit;
-- 커밋 완료.

-----------------------------------------------------------------------

-- 주민번호를 입력받아서 성별을 알려주는 함수 func_gender(주민번호)을 생성 
create or replace function func_gender 
(p_jubun  IN  varchar2) 
return varchar2         
is
    v_result varchar2(6); 
begin
    select case when substr(p_jubun, 7, 1) in('1', '3') then '남' else '여' end
           INTO
           v_result
    from dual;
    return v_result;
end func_gender;
-- Function FUNC_GENDER이(가) 컴파일되었습니다.

-- 주민번호를 입력받아서 나이를 알려주는 함수 func_age(주민번호)을 생성
create or replace function func_age
(p_jubun  IN  varchar2) 
return number         
is
    v_age number(3); 
begin
    select case when to_date(to_char(sysdate, 'yyyy')||substr(p_jubun, 3, 4), 'yyyymmdd') - to_date(to_char(sysdate, 'yyyymmdd'),'yyyymmdd') > 0 
                then extract(year from sysdate) - (to_number(substr(p_jubun, 1, 2)) + case when substr(p_jubun, 7, 1) in('1', '2') then 1900 else 2000 end ) - 1 
                else extract(year from sysdate) - (to_number(substr(p_jubun, 1, 2)) + case when substr(p_jubun, 7, 1) in('1', '2') then 1900 else 2000 end )
           end
           INTO
           v_age
    from dual;
    return v_age;
end func_age;
-- Function FUNC_AGE이(가) 컴파일되었습니다.

select jubun
     , func_gender(jubun) AS gender
     , func_age(jubun) AS age
from tbl_employees;

DROP FUNCTION FUNC_GENDER;
-- Function FUNC_GENDER이(가) 삭제되었습니다.

select line, text
from user_source
where type = 'FUNCTION' and name = 'FUNC_GENDER';

-----------------------------------------------------------------------

-- 카테고리 테이블
create table tbl_category
(category_code  NUMBER(4)      not null
,category_name  VARCHAR2(100)  not null
,constraint PK_tbl_category_category_code primary key(category_code)
);
-- Table TBL_CATEGORY이(가) 생성되었습니다.

comment on table tbl_category 
is '카테고리 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_category.category_code is '카테고리코드'; 
comment on column tbl_category.category_name is '카테고리명'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_CATEGORY';

select column_name, comments
from user_col_comments
where table_name = 'TBL_CATEGORY';

insert into tbl_category(category_code, category_name)
values(1, '사내공지');
-- 1 행 이(가) 삽입되었습니다.

insert into tbl_category(category_code, category_name)
values(2, '팝업일정');
-- 1 행 이(가) 삽입되었습니다.

insert into tbl_category(category_code, category_name)
values(3, '식단표');
-- 1 행 이(가) 삽입되었습니다.

commit;
-- 커밋 완료.

select category_code, category_name
from tbl_category
order by category_code asc;

-----------------------------------------------------------------------

-- 게시판 테이블
create table tbl_board
(board_seq         NUMBER                not null
,fk_category_code  NUMBER(4)             not null
,fk_empid          VARCHAR2(30)          not null
,name              VARCHAR2(30)          not null
,subject           NVARCHAR2(200)        not null
,content           CLOB                  not null
,pwd               VARCHAR2(20)          not null
,read_count        NUMBER DEFAULT 0      not null
,registerday       DATE DEFAULT SYSDATE  not null
,status            NUMBER(1) DEFAULT 1   not null
,groupno           NUMBER                not null
,fk_seq            NUMBER DEFAULT 0      not null
,depthno           NUMBER DEFAULT 0      not null
,orgfilename       VARCHAR2(255)
,filename          VARCHAR2(255)
,filesize          NUMBER
,constraint PK_tbl_board_board_seq        primary key(board_seq)
,constraint FK_tbl_board_fk_category_code foreign key(fk_category_code) references tbl_category(category_code)
,constraint FK_tbl_board_fk_empid         foreign key(fk_empid) references tbl_employees(empid)
,constraint CK_tbl_board_status           check(status in(0,1))
);
-- Table TBL_BOARD이(가) 생성되었습니다.

create sequence board_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence BOARD_SEQ이(가) 생성되었습니다.

comment on table tbl_board
is '게시판 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_board.board_seq is '글번호'; 
comment on column tbl_board.fk_category_code is '카테고리코드'; 
comment on column tbl_board.fk_empid is '사원아이디'; 
comment on column tbl_board.name is '글쓴이'; 
comment on column tbl_board.subject is '글제목'; 
comment on column tbl_board.content is '글내용'; 
comment on column tbl_board.pwd is '글암호'; 
comment on column tbl_board.read_count is '글조회수'; 
comment on column tbl_board.registerday is '작성일자'; 
comment on column tbl_board.status is '글삭제여부'; 
comment on column tbl_board.groupno is '그룹번호'; 
comment on column tbl_board.fk_seq is '원글번호'; 
comment on column tbl_board.depthno is '답변글들여쓰기'; 
comment on column tbl_board.orgfilename is '원본파일명'; 
comment on column tbl_board.filename is '저장파일명'; 
comment on column tbl_board.filesize is '파일크기'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_BOARD';

select column_name, comments
from user_col_comments
where table_name = 'TBL_BOARD';

-----------------------------------------------------------------------

desc tbl_board;

SELECT board_seq, fk_category_code, category_name, fk_empid, name, subject, registerday
     , groupno, fk_seq, depthno, filename
FROM
(
    SELECT rownum AS rno
         , board_seq, fk_category_code, category_name, fk_empid, name, subject, registerday
         , groupno, fk_seq, depthno, filename
    FROM
    (
        select board_seq, fk_category_code, C.category_name, fk_empid, name, subject
             , read_count, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday
             , groupno, fk_seq, depthno
             , filename
        from tbl_board B
        LEFT JOIN tbl_category C ON B.fk_category_code = C.category_code
        where status = 1
        start with fk_seq = 0
        connect by prior board_seq = fk_seq
        order siblings by groupno desc, board_seq asc
    ) V
) T
WHERE RNO between 1 and 10;

-----------------------------------------------------------------------

-- 검색어 입력 시 자동글 완성하기
select *
from tbl_board;

select subject
from tbl_board
where status = 1 and lower(subject) like '%' ||lower('kedai')|| '%'
order by registerday desc;

select distinct name
from tbl_board
where status = 1 and lower(name) like '%' ||lower('관리자')|| '%'
order by name asc;

-----------------------------------------------------------------------

-- 글 1개 조회하기        
SELECT previousseq, previoussubject
     , board_seq, fk_category_code, fk_empid, name, subject, content, read_count, registerday, pwd
     , nextseq, nextsubject
     , groupno, fk_seq, depthno
     , orgfilename, filename, filesize
FROM
(
    select lag(board_seq, 1) over(order by board_seq desc) AS previousseq 
         , lag(subject, 1) over(order by board_seq desc) AS previoussubject
           
         , board_seq, fk_category_code, fk_empid, name, subject, content
         , read_count, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday, pwd
         , groupno, fk_seq, depthno
         , orgfilename, filename, filesize
         
         , lead(board_seq, 1) over(order by board_seq desc) AS nextseq
         , lead(subject, 1) over(order by board_seq desc) AS nextsubject
    from tbl_board
    where status = 1
) V
WHERE V.board_seq = 1;

-----------------------------------------------------------------------

-- 포인트 충전하기
select to_number('100000')*0.01      
from dual;
-- 1000

update tbl_employees set point = point + (to_number('100000')*0.01)
where empid = '2013100-002';
-- 1 행 이(가) 업데이트되었습니다.

commit;
-- 커밋 완료.

select count(*)
from tbl_employees
where status = 1;

select count(*)
from tbl_board;

-----------------------------------------------------------------------

-- 커뮤니티 카테고리 테이블
create table tbl_community_category
(category_code  NUMBER(4)      not null
,category_name  VARCHAR2(100)  not null
,constraint PK_tbl_community_category_code primary key(category_code)
);
-- Table TBL_COMMUNITY_CATEGORY이(가) 생성되었습니다.

comment on table tbl_community_category 
is '커뮤니티 카테고리 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_community_category.category_code is '커뮤니티 카테고리코드'; 
comment on column tbl_community_category.category_name is '커뮤니티 카테고리명'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_COMMUNITY_CATEGORY';

select column_name, comments
from user_col_comments
where table_name = 'TBL_COMMUNITY_CATEGORY';

insert into tbl_community_category(category_code, category_name)
values(1, '동호회');
-- 1 행 이(가) 삽입되었습니다.

insert into tbl_community_category(category_code, category_name)
values(2, '건의함');
-- 1 행 이(가) 삽입되었습니다.

insert into tbl_community_category(category_code, category_name)
values(3, '사내소식');
-- 1 행 이(가) 삽입되었습니다.

commit;
-- 커밋 완료.

select category_code, category_name
from tbl_community_category
order by category_code asc;

-----------------------------------------------------------------------

-- 제약조건 조회
SELECT C.column_name AS "외래키컬럼명"
     , D.table_name AS "부모테이블명"
     , D.column_name AS "참조를당하는컬럼명"
FROM
(
    select B.column_name, A.r_constraint_name
    from user_constraints A JOIN user_cons_columns B
    ON A.constraint_name = B.constraint_name
    where A.table_name = 'TBL_COMMUNITY_LIKE' and A.constraint_type = 'R'
) C JOIN user_cons_columns D
ON C.r_constraint_name = D.constraint_name; 

drop table tbl_community purge;
-- Table TBL_EMPMANAGER_ACCESSTIME이(가) 삭제되었습니다.
drop sequence community_seq;
-- Sequence EMPMANAGER_ACCESSTIME_SEQ이(가) 삭제되었습니다.

-----------------------------------------------------------------------

-- 커뮤니티 테이블
create table tbl_community
(community_seq     NUMBER                not null
,fk_category_code  NUMBER(4)             not null
,fk_empid          VARCHAR2(30)          not null
,name              VARCHAR2(30)          not null
,subject           NVARCHAR2(200)        not null
,content           NVARCHAR2(2000)       not null
,pwd               VARCHAR2(20)          not null
,read_count        NUMBER DEFAULT 0      not null
,registerday       DATE DEFAULT SYSDATE  not null
,status            NUMBER(1) DEFAULT 1   not null
,commentCount      NUMBER DEFAULT 0      not null
,constraint PK_tbl_community_community_seq primary key(community_seq)
,constraint FK_tbl_community_category_code foreign key(fk_category_code) references tbl_community_category(category_code)
,constraint FK_tbl_community_fk_empid      foreign key(fk_empid) references tbl_employees(empid)
,constraint CK_tbl_community_status        check(status in(0,1))
);
-- Table TBL_COMMUNITY이(가) 생성되었습니다.

ALTER TABLE tbl_community RENAME COLUMN commentCount TO comment_count;
-- Table TBL_COMMUNITY이(가) 변경되었습니다.

desc tbl_community;

create sequence community_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence COMMUNITY_SEQ이(가) 생성되었습니다.

comment on table tbl_community
is '커뮤니티 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_community.community_seq is '글번호'; 
comment on column tbl_community.fk_category_code is '카테고리코드';
comment on column tbl_community.fk_empid is '사원아이디';
comment on column tbl_community.name is '글쓴이';
comment on column tbl_community.subject is '글제목';
comment on column tbl_community.content is '글내용';
comment on column tbl_community.pwd is '글암호';
comment on column tbl_community.read_count is '글조회수';
comment on column tbl_community.registerday is '작성일자';
comment on column tbl_community.status is '글삭제여부';
comment on column tbl_community.comment_count is '댓글의개수';
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_COMMUNITY';

select column_name, comments
from user_col_comments
where table_name = 'TBL_COMMUNITY';

-----------------------------------------------------------------------

-- 커뮤니티 첨부파일 테이블
create table tbl_community_file
(file_seq          NUMBER         not null
,fk_community_seq  NUMBER         not null
,orgfilename       VARCHAR2(255)  not null
,filename          VARCHAR2(255)  not null
,filesize          NUMBER         not null
,constraint PK_tbl_community_file_seq     primary key(file_seq)
,constraint FK_tbl_community_file_com_seq foreign key(fk_community_seq) references tbl_community(community_seq)
);
-- Table TBL_COMMUNITY_FILE이(가) 생성되었습니다.

create sequence file_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence FILE_SEQ이(가) 생성되었습니다.

comment on table tbl_community_file
is '커뮤니티 첨부파일 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_community_file.file_seq is '첨부파일번호'; 
comment on column tbl_community_file.fk_community_seq is '글번호';
comment on column tbl_community_file.orgfilename is '원본파일명';
comment on column tbl_community_file.filename is '저장파일명';
comment on column tbl_community_file.filesize is '파일크기';
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_COMMUNITY_FILE';

select column_name, comments
from user_col_comments
where table_name = 'TBL_COMMUNITY_FILE';

drop table tbl_community_file;
-- Table TBL_COMMUNITY_FILE이(가) 삭제되었습니다.

flashback table tbl_community_file to before drop;
-- Flashback을(를) 성공했습니다.

desc tbl_community_file;

ALTER TABLE tbl_community_file DROP PRIMARY KEY;
-- Table TBL_COMMUNITY_FILE이(가) 변경되었습니다.

ALTER TABLE tbl_community_file ADD CONSTRAINT PK_tbl_community_file_seq PRIMARY KEY(file_seq);
-- Table TBL_COMMUNITY_FILE이(가) 변경되었습니다.

ALTER TABLE tbl_community_file
ADD CONSTRAINT FK_tbl_community_file_com_seq FOREIGN KEY(fk_community_seq)
REFERENCES tbl_community(community_seq) ON DELETE CASCADE; 
-- Table TBL_COMMENT이(가) 변경되었습니다.

select *
from user_constraints
where table_name in('TBL_COMMUNITY_FILE');

-----------------------------------------------------------------------

-- 커뮤니티 댓글 테이블
create table tbl_comment
(comment_seq       NUMBER                not null
,fk_community_seq  NUMBER                not null
,fk_empid          VARCHAR2(30)          not null
,name              VARCHAR2(30)          not null
,content           NVARCHAR2(1000)       not null
,registerday       DATE DEFAULT SYSDATE  not null
,status            NUMBER(1) DEFAULT 1   not null
,constraint PK_tbl_comment_comment_seq   primary key(comment_seq)
,constraint FK_tbl_comment_community_seq foreign key(fk_community_seq) references tbl_community(community_seq) 
,constraint FK_tbl_comment_fk_empid      foreign key(fk_empid) references tbl_employees(empid)
,constraint CK_tbl_comment_status        check(status in(0,1))
);
-- Table TBL_COMMENT이(가) 생성되었습니다.

ALTER TABLE tbl_comment 
DROP CONSTRAINT FK_tbl_comment_community_seq;
-- Table TBL_COMMENT이(가) 변경되었습니다.

ALTER TABLE tbl_comment
ADD CONSTRAINT FK_tbl_comment_community_seq FOREIGN KEY(fk_community_seq)
REFERENCES tbl_community(community_seq) ON DELETE CASCADE; 
-- Table TBL_COMMENT이(가) 변경되었습니다.

create sequence comment_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence COMMENT_SEQ이(가) 생성되었습니다.

comment on table tbl_comment
is '커뮤니티 댓글 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_comment.comment_seq is '댓글번호';
comment on column tbl_comment.fk_community_seq is '원글번호';
comment on column tbl_comment.fk_empid is '사원아이디';
comment on column tbl_comment.name is '글쓴이';
comment on column tbl_comment.content is '댓글내용';
comment on column tbl_comment.registerday is '작성일자';
comment on column tbl_comment.status is '글삭제여부';
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_COMMENT';

select column_name, comments
from user_col_comments
where table_name = 'TBL_COMMENT';

-----------------------------------------------------------------------

-- 커뮤니티 좋아요 테이블
create table tbl_community_like
(fk_empid          VARCHAR2(30)  not null 
,fk_community_seq  NUMBER        not null
,constraint PK_tbl_community_like         primary key(fk_empid,fk_community_seq) -- 누가 어떤 글에 대해 좋아요를 누른 경우 => 복합 primary key
,constraint FK_tbl_community_like_empid   foreign key(fk_empid) references tbl_employees(empid)
,constraint FK_tbl_community_like_com_seq foreign key(fk_community_seq) references tbl_community(community_seq) on delete cascade
);
-- Table TBL_COMMUNITY_LIKE이(가) 생성되었습니다.

comment on table tbl_community_like
is '커뮤니티 좋아요 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_community_like.fk_empid is '사원아이디';
comment on column tbl_community_like.fk_community_seq is '글번호';
-- Comment이(가) 생성되었습니다.

-----------------------------------------------------------------------

-- 커뮤니티 글쓰기
desc tbl_community;

insert into tbl_community(community_seq, fk_category_code, fk_empid, name, subject, content, pwd, read_count, registerday, status, commentcount)
values(community_seq.nextval, to_number(#{fk_category_code}), #{fk_empid}, #{name}, #{subject}, #{content}, #{pwd}, default, default, default, default);

-- 첨부파일 등록하기
desc tbl_community_file;

insert into tbl_community_file(file_seq, fk_community_seq, orgfilename, filename, filesize)
values(file_seq.nextval, #{fk_community_seq}, #{orgfilename}, #{filename}, #{filesize});

select *
from tbl_community;

select *
from tbl_community_file;

select count(*)
from tbl_community
where status = 1 and subject like '%' ||'t'||'%';

SELECT community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, orgfilename, read_count, registerday, comment_count
FROM
(
    SELECT rownum AS rno
         , community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, orgfilename, read_count, registerday, comment_count
    FROM 
    (
        select community_seq, fk_category_code, A.category_name, fk_empid, C.name, E.nickname, E.imgfilename, subject, content, F.orgfilename, read_count, registerday, comment_count
        from tbl_community C 
        LEFT JOIN tbl_community_category A ON C.fk_category_code = A.category_code
        LEFT JOIN tbl_community_file F ON C.community_seq = F.fk_community_seq
        LEFT JOIN tbl_employees E ON C.fk_empid = E.empid
        where C.status = 1
        order by community_seq desc
    ) V
) T
WHERE RNO between 1 and 10

SELECT previousseq, previoussubject
     , community_seq, fk_category_code, fk_empid, name, nickname, subject, content, pwd, orgfilename
     , read_count, registerday, comment_count
     , nextseq, nextsubject
FROM
(
    select lag(community_seq, 1) over(order by community_seq desc) AS previousseq
         , lag(subject, 1) over(order by community_seq desc) AS previoussubject

         , community_seq, fk_category_code, fk_empid, C.name, E.nickname, subject, content, C.pwd, F.orgfilename
         , read_count, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday, comment_count

         , lead(community_seq, 1) over(order by community_seq desc) AS nextseq
         , lead(subject, 1) over(order by community_seq desc) AS nextsubject
    from tbl_community C
    LEFT JOIN tbl_community_file F ON C.community_seq = F.fk_community_seq
    LEFT JOIN tbl_employees E ON C.fk_empid = E.empid
    where C.status = 1
) V
WHERE V.community_seq = 3;

desc tbl_community_file;
desc tbl_employees;

update tbl_community set read_count = read_count + 1
where community_seq = 1;

desc tbl_community;
desc tbl_comment;

insert into tbl_comment(comment_seq, fk_community_seq, fk_empid, name, content, registerday, status)
values(comment_seq.nextval, fk_community_seq, fk_empid, name, content, default, default)

update tbl_community set comment_count = comment_count + 1
where community_seq = #{fk_community_seq}

desc tbl_employees;

update tbl_employees set point = point + to_number(#{point}) 
where empid = #{empid}

select *
from tbl_employees
where nickname = 'Liam';

-----------------------------------------------------------------------

select category_code, category_name
from tbl_community_category
order by category_code asc;
s
desc tbl_community;
desc tbl_comment;

insert into tbl_comment(comment_seq, fk_community_seq, fk_empid, name, content, registerday, status)
values(comment_seq.nextval, fk_community_seq, fk_empid, name, content, default, default)

update tbl_community set comment_count = comment_count + 1
where community_seq = #{fk_community_seq}

desc tbl_employees;

update tbl_employees set point = point + to_number(#{point}) 
where empid = #{empid}

select *
from tbl_employees
where nickname = 'Liam';

select comment_seq, fk_empid, C.name, nickname, content, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday
from tbl_comment C
LEFT JOIN tbl_employees E ON C.fk_empid = E.empid
where C.status = 1 and fk_community_seq = 17
order by comment_seq desc;

SELECT community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, read_count, registerday, comment_count, fk_community_seq
FROM
(
    SELECT rownum AS rno
         , community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, read_count, registerday, comment_count
         , fk_community_seq
    FROM 
    (
        select community_seq, fk_category_code, A.category_name, fk_empid, C.name, E.nickname, E.imgfilename, subject, content 
             , read_count, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday, comment_count
             , fk_community_seq
        from tbl_community C 
        LEFT JOIN tbl_community_category A ON C.fk_category_code = A.category_code
        LEFT JOIN (select fk_community_seq from tbl_community_file group by fk_community_seq) F ON C.community_seq = F.fk_community_seq
        LEFT JOIN tbl_employees E ON C.fk_empid = E.empid 
        where C.status = 1
        order by community_seq desc
    ) V
) T
WHERE RNO between 1 and 10

desc tbl_community_file;

select file_seq, fk_community_seq, orgfilename, filename, filesize
from tbl_community_file
where fk_community_seq = 27 and orgfilename = 'LG_싸이킹청소기_사용설명서.pdf'

desc tbl_comment;
desc tbl_community;

update tbl_comment set content = #{content}, registerday = sysdate
where comment_seq = #{comment_seq}

update tbl_community set comment_count = comment_count - 1
where community_seq = #{fk_community_seq}

desc tbl_community_like;

insert into tbl_community_like(fk_empid, fk_community_seq)
values(#{fk_empid}, #{fk_community_seq})

select count(*)
from tbl_community_like
where fk_community_seq = 3

update tbl_community set fk_category_code = #{fk_category_code}, subject = #{subject}, content = #{content}, registerday = sysdate
where community_seq = #{community_seq}

update tbl_community_file set orgfilename = #{orgfilename}, filename = #{filename}, filesize = #{filesize}
where fk_community_seq = #{fk_community_seq}

select *
from tbl_community
where community_seq = 31

select orgfilename, filename, filesize
from tbl_community_file
where fk_community_seq = 30
          
delete from tbl_community_file
where fk_community_seq = #{fk_community_seq}

select orgfilename, filename
from tbl_community_file

select count(*)
from tbl_comment
where fk_community_seq = 30

select *
from tbl_community_like
where fk_empid = '2011300-001' and fk_community_seq = 20

delete from tbl_community_like
where fk_empid = '2010001-001' and fk_community_seq = 28

-- 좋아요 개수가 추가된 경우
SELECT community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, read_count, registerday, comment_count, fk_community_seq, like_count
FROM
(
    SELECT rownum AS rno
         , community_seq, fk_category_code, category_name, fk_empid, name, nickname, imgfilename, subject, content, read_count, registerday, comment_count, fk_community_seq, like_count
    FROM 
    (
        select community_seq, fk_category_code, A.category_name, fk_empid, C.name, E.nickname, E.imgfilename, subject, content 
             , read_count, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday, comment_count, F.fk_community_seq, COALESCE(L.like_count, 0) AS like_count
        from tbl_community C 
        LEFT JOIN tbl_community_category A ON C.fk_category_code = A.category_code
        LEFT JOIN (select fk_community_seq from tbl_community_file group by fk_community_seq) F ON C.community_seq = F.fk_community_seq
        LEFT JOIN (SELECT fk_community_seq, COUNT(*) AS like_count FROM tbl_community_like GROUP BY fk_community_seq) L ON C.community_seq = L.fk_community_seq
        LEFT JOIN tbl_employees E ON C.fk_empid = E.empid 
        where C.status = 1
        order by community_seq desc
    ) V
) T
WHERE RNO between 1 and 10

SELECT fk_community_seq, COUNT(*) AS like_count FROM tbl_community_like GROUP BY fk_community_seq;

SELECT category_name, name, subject, registerday
FROM
(
    SELECT rownum AS rno, category_name, name, subject, registerday
    FROM
    (
        select C.category_name, name, subject, to_char(registerday, 'yyyy-mm-dd hh24:mi:ss') AS registerday
        from tbl_board B
        LEFT JOIN tbl_category C ON B.fk_category_code = C.category_code
        where status = 1
        and B.fk_category_code = 3
        order by board_seq desc
    ) V
) T
WHERE RNO between 1 and 5;

desc tbl_board;

select content, filename
from tbl_board
where fk_category_code = 3
order by board_seq desc;

SELECT subject, content, filename
FROM 
(
    SELECT subject, content, filename
    FROM tbl_board
    WHERE fk_category_code = 3
    ORDER BY board_seq DESC
)
WHERE ROWNUM = 1;

select 
from tbl_employees
where empid = '2010001-001'

-----------------------------------------------------------------------

-- 부서별 인원통계
select count(*) 
from tbl_employees

select NVL(dept_name, '부서없음') AS dept_name
     , count(*) AS cnt
     , round(count(*) / (select count(*) from tbl_employees) * 100, 2) AS percentage
from tbl_employees E LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
group by D.dept_name
order by cnt desc, dept_name asc;

-- 성별 인원통계
select func_gender(jubun) AS gender
from tbl_employees

SELECT gender
     , count(*) AS cnt
     , round(count(*) / (select count(*) from tbl_employees) * 100, 1) AS percentage
FROM 
(
    select func_gender(jubun) AS gender
    from tbl_employees
)
GROUP BY gender
order by cnt desc;

-- 부서별 성별 인원통계
SELECT gender
     , count(*) AS cnt
     , round(count(*) / (select count(*) from tbl_employees) * 100, 2) AS percentage
FROM
(
    select fk_dept_code, func_gender(jubun) AS gender
    from tbl_employees
) E LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
WHERE D.dept_name is null
GROUP BY gender
ORDER BY gender;

-- 입사년도별 성별 인원통계
select hire_date
from tbl_employees;

select decode(EXTRACT(YEAR FROM TO_DATE(hire_date, 'YY/MM/DD')), 2010, 1, 0)
from tbl_employees;

select func_gender(jubun)
from dual

select func_gender(jubun) AS gender
     , sum(decode(EXTRACT(YEAR FROM TO_DATE(hire_date, 'YY/MM/DD')), 2010, 1, 0)) AS Y2010
     , sum(decode(EXTRACT(YEAR FROM TO_DATE(hire_date, 'YY/MM/DD')), 2011, 1, 0)) AS Y2011
from tbl_employees
group by func_gender(jubun)
order by gender;

-----------------------------------------------------------------------

-- 페이지별 사원 접속통계
create table tbl_empManager_accessTime
(accessTime_seq  number
,pageUrl         varchar2(150) not null
,fk_empid        varchar2(30)  not null
,clientIP        varchar2(30)  not null
,accessTime      varchar2(20)  default sysdate not null
,constraint PK_tbl_empManager_accessTime primary key(accessTime_seq)
,constraint FK_tbl_empManager_accessTime foreign key(fk_empid) references tbl_employees(empid)
);
-- Table TBL_EMPMANAGER_ACCESSTIME이(가) 생성되었습니다.

create sequence empManager_accessTime_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence EMPMANAGER_ACCESSTIME_SEQ이(가) 생성되었습니다.

comment on table tbl_empManager_accessTime
is '페이지별 사원 접속통계 정보가 들어있는 테이블';
-- Comment이(가) 생성되었습니다.

comment on column tbl_empManager_accessTime.accessTime_seq is '접속번호'; 
comment on column tbl_empManager_accessTime.pageUrl is '페이지(URL)주소'; 
comment on column tbl_empManager_accessTime.fk_empid is '사원아이디'; 
comment on column tbl_empManager_accessTime.clientIP is '사원IP주소'; 
comment on column tbl_empManager_accessTime.accessTime is '접속시간'; 
-- Comment이(가) 생성되었습니다.

select *
from user_tab_comments
where table_name = 'TBL_EMPMANAGER_ACCESSTIME';

select column_name, comments
from user_col_comments
where table_name = 'TBL_EMPMANAGER_ACCESSTIME';

select * 
from tbl_empManager_accessTime
order by accessTime_seq desc;

SELECT case 
       when instr(PAGEURL, 'approval/main.kedai', 1, 1) > 0 then '전자결재' 
       when instr(PAGEURL, 'pay_stub.kedai', 1, 1) > 0 then '급여명세서'
       when instr(PAGEURL, 'roomResercation.kedai', 1, 1) > 0 then '회의실예약'
       when instr(PAGEURL, 'board/list.kedai', 1, 1) > 0 then '게시판'
       when instr(PAGEURL, 'community/list.kedai', 1, 1) > 0 then '커뮤니티'
       when instr(PAGEURL, 'carShare.kedai', 1, 1) > 0 then '카쉐어'
       when instr(PAGEURL, 'bus.kedai', 1, 1) > 0 then '통근버스'
       when instr(PAGEURL, 'employee.kedai', 1, 1) > 0 then '사내연락망'
       when instr(PAGEURL, 'othercom_list.kedai', 1, 1) > 0 then '거래처정보'
       else '기타'
       end AS PAGENAME
     , name     
     , CNT
FROM 
(
    SELECT E.name, A.pageurl, A.cnt 
    FROM 
    (
        select NVL(substr(pageurl, 1, instr(pageurl, '?', 1, 1)-1), pageurl) AS PAGEURL 
             , fk_empid
             , count(*) AS CNT 
        from tbl_empManager_accessTime
        group by NVL(substr(pageurl, 1, instr(pageurl, '?', 1, 1)-1), pageurl), fk_empid
    ) A JOIN tbl_employees E
    ON A.fk_empid = E.empid
) V
ORDER BY 1, 2;

desc tbl_empManager_accessTime;

insert into tbl_empManager_accessTime(accessTime_seq, pageUrl, fk_empid, clientIP, accessTime)
values(empManager_accessTime_seq.nextval, #{pageUrl}, #{fk_empid}, #{clientIP}, #{accessTime})

drop table tbl_empManager_accessTime purge;
-- Table TBL_EMPMANAGER_ACCESSTIME이(가) 삭제되었습니다.
drop sequence empManager_accessTime_seq;
-- Sequence EMPMANAGER_ACCESSTIME_SEQ이(가) 삭제되었습니다.

rollback;
