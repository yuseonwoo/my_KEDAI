

-- 설문 테이블
create table tbl_survey
(survey_no     number               not null  -- 설문번호
,fk_empid      varchar2(30)         not null  -- 사원아이디
,subject       varchar2(200)        not null  -- 설문제목
,desc          nvarchar2(1000)                -- 상세설명
,attachment    varchar2(200)                  -- 첨부파일
,startday      date default sysdate not null  -- 설문시작일
,duedate       date                 not null  -- 설문마감일
,name          varchar2(50)         not null  -- 설문자 이름
,job_name      varchar2(50)                   -- 설문자 직급명
                                               
,constraint PK_tbl_survey_survey_no primary key(survey_no)
,constraint FK_tbl_survey_empid foreign key(fk_empid) references tbl_employees(empid)
,constraint FK_tbl_comment_parentSeq foreign key(parentSeq) references tbl_board(seq) on delete cascade
,constraint CK_tbl_comment_status check( status in(1,0) ) 
);
-- 설문 테이블의 설문번호 시퀀스
create sequence survey_no
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

-- 설문테이블 코멘트
COMMENT ON COLUMN tbl_survey.survey_no IS '설문에 대한 번호(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.fk_empid IS '설문을 작성한 사원 아이디 references tbl_employees(empid)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.subject IS '설문제목'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.desc IS '설문에 대한 상세 설명'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.attachment IS '첨부파일'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.startday IS '설문시작일(default sysdate)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.duedate IS '설문마감일'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.name IS '설문을 작성한 사원 이름'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey.job_name IS '설문을 작성한 사원의 직급명'; --Comment이(가) 생성되었습니다.


--설문대상
create table tbl_survey_target
(target_code    number      not null  -- 설문대상코드 
,fk_survey_no   number      not null  -- 설문번호 
,fk_dept_code   number(4)   not null  -- 부서코드 

,constraint PK_tbl_survey_target_target_code primary key(q_code)
,constraint FK_tbl_survey_target_fk_survey_no foreign key(fk_survey_no) references tbl_survey(survey_no)
,constraint FK_tbl_survey_target_fk_dept_code foreign key(fk_dept_code) references tbl_dept(dept_code)
);

-- 설문대상 코멘트
COMMENT ON COLUMN tbl_survey_target.target_code IS '설문 대상에 대한 시퀀스(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_target.fk_survey_no IS '설문 번호 references tbl_survey(survey_no)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_target.fk_dept_code IS '설문 대상으로 선택한 부서의 코드 references tbl_dept(dept_code)'; --Comment이(가) 생성되었습니다.


--설문문항타입
create table tbl_q_type
(q_type_code    number          not null  -- 문항타입코드 
,q_type         VARCHAR(50)     not null  -- 문항타입 

,constraint PK_tbl_q_type_q_type_code primary key(q_type_code)
);


-- 설문문항타입 코멘트
COMMENT ON COLUMN tbl_q_type.q_type_code IS '설문 문항 질문 타입에 따른 코드(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_q_type.q_type IS '설문 문항 타입에 대한 설명 '; --Comment이(가) 생성되었습니다.



--설문문항
create table tbl_survey_q
(q_code           VARCHAR(200)      not null    -- 설문문항코드
,fk_survey_no     NUMBER            not null    -- 설문번호
,q_number         NUMBER            not null    -- 설문문항번호 
,q_content        VARCHAR2(200)     not null    -- 문항별 질문
,q_num_option     VARCHAR2(200)                 -- 문항질문별선택옵션
,q_type_code      NUMBER            not null    -- 문항타입코드

,constraint PK_tbl_survey_q_q_code primary key(q_code)
,constraint FK_tbl_survey_q_fk_survey_no foreign key(fk_survey_no) references tbl_survey(survey_no)
);

-- 설문문항 코멘트
COMMENT ON COLUMN tbl_survey_q.q_code IS '설문 문항 코드(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.fk_survey_no IS '설문번호  references tbl_survey(survey_no) '; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.q_number IS '설문 문항 번호'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.q_code IS '설문 문항 코드'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.q_content IS '문항별 질문 내용'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.q_num_option IS '문항 질문에 선택지가 있는 경우 '; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_q.q_type_code IS '설문 문항타입코드 references tbl_survey(survey_no)'; --Comment이(가) 생성되었습니다.


--설문답변
create table tbl_survey_a
(a_code             NUMBER            not null    -- 설문답변코드
,fk_survey_no       NUMBER            not null    -- 설문번호
,fk_q_code   VARCHAR(200)      not null    -- 설문문항코드
,survey_a_content   VARCHAR2(200)     not null    -- 답변
,fk_q_type_code     NUMBER            not null    -- 문항타입코드
,fk_empid           VARCHAR2(30)      not null    -- 답변자 사원아이디

,constraint PK_tbl_survey_a_a_code primary key(a_code)
,constraint FK_tbl_survey_a_fk_survey_no foreign key(fk_survey_no) references tbl_survey(survey_no)
,constraint FK_tbl_survey_a_fk_q_code foreign key(fk_q_code) references tbl_survey_q(q_code)
,constraint FK_tbl_survey_a_fk_q_type_code foreign key(fk_q_type_code) references tbl_survey(tbl_q_type)
,constraint FK_tbl_survey_a_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);

-- 설문문항 코멘트
COMMENT ON COLUMN tbl_survey_a.a_code IS '설문 답변 코드(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_a.fk_survey_no IS '설문번호 references tbl_survey(survey_no)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_a.fk_survey_q_code IS '설문문항코드 tbl_survey_q(q_code)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_a.survey_a_content IS '설문에 대한 답변'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_a.fk_q_type_code IS '설문 문항에 대한 타입 코드 tbl_survey(tbl_q_type)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_survey_a.fk_empid IS '설문 답변자의 사원 아이디 tbl_employees(empid)'; --Comment이(가) 생성되었습니다.




--- *** 테이블명에 달려진 주석문 조회하기 *** --
select *
from user_tab_comments; 

 ---- !!!! 테이블을 생성한 이후에 웬만하면 컬럼명에 대한 주석문을 달아주도록 합시다.!!!! ----
    --     COMMENT ON COLUMN 테이블명.컬럼명 IS '주석문'
COMMENT ON COLUMN tbl_jikwon.sano IS '사원번호 primary key'; --Comment이(가) 생성되었습니다.


show user;


---------------------------결재 관련 테이블------------------------------
-- 기안종류(24.07.03 생성완료)
create table tbl_doctype
(doctype_code       NUMBER            not null    -- 기안종류코드
,doctype_name       VARCHAR2(30)      not null    -- 기안종류명

,constraint PK_tbl_doctype_doctype_code primary key(doctype_code)
);
-- 기안종류 코멘트
COMMENT ON COLUMN tbl_doctype.doctype_code IS '기안 종류 코드(primary key) 100:연차신청서 101:회의록 102:추가근무비용신청'; --Comment이(가) 생성되었습니다.

insert into tbl_doctype(doctype_code, doctype_name) values(100, '연차신청서');
insert into tbl_doctype(doctype_code, doctype_name) values(101, '회의록');
insert into tbl_doctype(doctype_code, doctype_name) values(102, '추가근무비용신청');
      
commit;

--기안문서(24.07.03 생성완료)
create table tbl_doc
(doc_no             VARCHAR2(30)         not null    -- 기안문서번호(EX. KD-100-2407)
,fk_doctype_code    NUMBER               not null    -- 기안종류코드 100:연차신청서 101:회의록 102:야간근무신청
,fk_empid           VARCHAR2(30)         not null    -- 기안자사원아이디
,doc_subject        NVARCHAR2(50)        not null    -- 기안문서제목
,doc_content        NVARCHAR2(2000)      not null    -- 기안문서내용
,created_date       date default sysdate not null    -- 서류작성일자
,doc_comment            NVARCHAR2(100)                   -- 기안의견
,doc_status         NUMBER  default 0    not null    -- 기안상태  0:기안 1:반려  
,constraint PK_tbl_doc_doc_no primary key(doc_no)
,constraint FK_tbl_doc_fk_doctype_code foreign key(fk_doctype_code) references tbl_doctype(doctype_code)
,constraint FK_tbl_doc_fk_empid foreign key(fk_empid) references tbl_employees(EMPID)
-- ,constraint ck_tbl_doc_doc_status CHECK (doc_status IN(0, 1))
);

ALTER TABLE tbl_doc RENAME COLUMN content TO doc_content;

ALTER TABLE tbl_doc DROP COLUMN doc_org_filename;
ALTER TABLE tbl_doc DROP COLUMN doc_filename; -- 첨부 파일명
ALTER TABLE tbl_doc DROP COLUMN doc_filesize;--파일크기
commit;

create sequence doc_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT column_name, comments
FROM user_col_comments
WHERE table_name = 'TBL_DOC' ;

commit;

-- 기안종류 코멘트
COMMENT ON COLUMN tbl_doc.doc_no IS '기안 문서 번호(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_doc.fk_doctype_code IS '기안 종류 코드 references tbl_doctype(doctype_code) 100:연차신청서 101:회의록 102:야간근무신청';
COMMENT ON COLUMN tbl_doc.fk_empid IS '기안을 올린 사원 아이디 references tbl_employees(empid)';
COMMENT ON COLUMN tbl_doc.subject IS '기안 문서 제목';
COMMENT ON COLUMN tbl_doc.content IS '기안 문서 내용';
COMMENT ON COLUMN tbl_doc.created_date IS '서류 작성 일자 default sysdate';
COMMENT ON COLUMN tbl_doc.doc_comment IS '기안 의견';
COMMENT ON COLUMN tbl_doc.doc_status IS '기안상태  0:기안 1:반려';
COMMENT ON COLUMN tbl_doc.doc_org_filename IS '기안자가 올린 첨부 파일명';
COMMENT ON COLUMN tbl_doc.doc_filename IS 'WAS에 저장하는 첨부 파일명';
COMMENT ON COLUMN tbl_doc.doc_filesize IS '파일 사이즈';

--연차 신청서
create table tbl_dayoff
(dayoff_no        NUMBER         not null    -- 신청서시퀀스
,fk_doc_no        VARCHAR2(30)   not null    -- 기안문서번호
,dayoff_type      NUMBER         not null    -- 연차종류 
,startdate        DATE           not null    -- 휴가시작일
,findate          DATE           not null    -- 휴가종료일
,reason           VARCHAR2(50)   not null    -- 연차사유

,constraint PK_tbl_dayoff_dayoff_no primary key(doc_no)
,constraint FK_tbl_dayoff_fk_doc_no foreign key(fk_doc_no) references tbl_doc(doc_no)
);

-- 연차 신청서 코멘트
COMMENT ON COLUMN tbl_dayoff.dayoff_no IS '연차 신청서 시퀀스(primary key)'; --Comment이(가) 생성되었습니다.
COMMENT ON COLUMN tbl_doc.fk_doc_no IS '기안 문서 번호  references tbl_doc(doc_no)';
COMMENT ON COLUMN tbl_doc.dayoff_type IS '연차종류 '; -- 번호는 아직 미정..
COMMENT ON COLUMN tbl_doc.startdate IS '휴가시작일 '; 
COMMENT ON COLUMN tbl_doc.findate IS '휴가종료일 '; 
COMMENT ON COLUMN tbl_doc.reason IS '연차사유 '; 

--회의록(24.07.03 생성완료)
create table tbl_minutes
(minutes_no    NUMBER             not null    -- 회의록시퀀스
,fk_doc_no       VARCHAR2(30)       not null    -- 기안문서번호
,meeting_date    DATE               not null    -- 회의일자 
,attendees       NVARCHAR2(50)      not null    -- 회의 참석자
,host_dept       NVARCHAR2(50)      not null    -- 회의 주관부서
,constraint PK_tbl_minutes_minutes_code primary key(minutes_code)
,constraint FK_tbl_minutes_fk_doc_no foreign key(fk_doc_no) references tbl_doc(doc_no)
);             
ALTER TABLE tbl_minutes RENAME COLUMN minutes_code TO minutes_no;
ALTER TABLE tbl_minutes ADD host_dept NVARCHAR2(50) not null;
ALTER TABLE tbl_minutes DROP COLUMN content; -- content테이블 삭제

select *
from tbl_minutes;

create sequence minutes_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
--Sequence MINUTES_NOSEQ이(가) 생성되었습니다.

DROP SEQUENCE minutes_noSeq;

commit;

select *
from  tbl_minutes;

SELECT *
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_MINUTES';

--회의록 코멘트(24.07.03 생성완료)
COMMENT ON COLUMN tbl_mom.mom_code IS '회의록 시퀀스(primary key) '; 
COMMENT ON COLUMN tbl_mom.fk_doc_no IS ' 기안 문서 번호 references tbl_doc(doc_no) '; 
COMMENT ON COLUMN tbl_mom.meeting_date IS '회의 일자 '; 
COMMENT ON COLUMN tbl_mom.content IS '회의록 내용 '; 
COMMENT ON COLUMN tbl_mom.attendees IS '회의 참석자 '; 

commit;

--결재 테이블(24.07.03 생성완료)
create table tbl_approval
(approval_no        NUMBER           not null    -- 결재번호
,fk_doc_no          VARCHAR2(30)     not null    -- 기안문서번호
,fk_empid           VARCHAR2(30)     not null    -- 결재자사원아이디 
,status             NUMBER           not null    -- 결재상태
,approval_comment   NVARCHAR2(100)               -- 결재의견
,approval_date      DATE                         -- 결재일자
,level_no           NUMBER           not null    -- 결재단계
,constraint PK_tbl_approval_approval_no primary key(approval_no)
,constraint FK_tbl_approval_fk_doc_no foreign key(fk_doc_no) references tbl_doc(doc_no)
,constraint FK_tbl_approval_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);

ALTER TABLE tbl_approval DROP CONSTRAINT PK_tbl_approval_new;
 -- pk를 2개 설정한다.
ALTER TABLE tbl_approval 
ADD CONSTRAINT PK_tbl_approval_no_empid PRIMARY KEY (approval_no, fk_empid); 

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME
FROM USER_CONSTRAINTS
WHERE TABLE_NAME = 'TBL_APPROVAL';

ALTER TABLE tbl_approval
MODIFY level_no DEFAULT NULL;

create sequence approval_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

DROP SEQUENCE approval_noSeq;

SELECT sequence_name
FROM user_sequences
WHERE sequence_name = 'APPROVAL_NOSEQ';

commit;

-- 결재 코멘트(24.07.03 생성완료)

COMMENT ON COLUMN tbl_approval.approval_no IS '결재번호(primary key) '; 
COMMENT ON COLUMN tbl_approval.fk_doc_no IS '기안 문서 번호 '; 
COMMENT ON COLUMN tbl_approval.fk_empid IS ' 결재자 사원 아이디 '; 
COMMENT ON COLUMN tbl_approval.status IS '결재상태 0:미결재 1:결재 3:반려'; 
COMMENT ON COLUMN tbl_approval.approval_comment IS '결재의견 '; 
COMMENT ON COLUMN tbl_approval.approval_date IS '결재일자 '; 


-- 첨부파일 테이블
create table tbl_doc_file
(doc_file_no        NUMBER           not null    -- 결재번호
,fk_doc_no          VARCHAR2(30)     not null    -- 기안문서번호
,doc_org_filename   VARCHAR2(100)    not null    -- 원래파일명 
,doc_filename       varchar2(100)    not null    -- 첨부파일명 
,doc_filesize       NUMBER           not null    -- 파일크기
,constraint PK_tbl_doc_file_doc_file_no primary key(doc_file_no)
,constraint FK_tbl_doc_file_fk_doc_no foreign key(fk_doc_no) references tbl_doc(doc_no)
);

alter table tbl_doc_file MODIFY (doc_filename VARCHAR2(100)); 

create sequence doc_file_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

DROP SEQUENCE doc_file_noSeq;

commit;

COMMENT ON COLUMN tbl_doc_file.doc_file_no IS '결재번호(primary key) '; 
COMMENT ON COLUMN tbl_doc_file.fk_doc_no IS '기안 문서 번호'; 
COMMENT ON COLUMN tbl_doc_file.doc_org_filename IS '원래 파일명'; 
COMMENT ON COLUMN tbl_doc_file.doc_file_no IS '결재번호(primary key) '; 
COMMENT ON COLUMN tbl_doc_file.doc_filename IS '첨부 파일명 '; 
COMMENT ON COLUMN tbl_doc_file.doc_filesize IS '파일크기'; 


--- 문서번호 추가하기

desc tbl_job

select *
from tbl_job

SELECT *
FROM tbl_employees

select E.empid, E.name, J.job_code, J.job_name, CASE WHEN D.dept_code IS NULL THEN ' ' ELSE TO_CHAR(D.dept_code) END AS dept_code,
       nvl(D.dept_name, ' ') as dept_name
from tbl_employees E
JOIN tbl_job J
ON E.fk_job_code = J.job_code
LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
order by dept_name asc, job_code desc


    
SELECT D.dept_name, COUNT(E.empid) AS employee_count
FROM tbl_employees E
LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
GROUP BY E.fk_dept_code, D.dept_name
ORDER BY D.dept_name DESC;


SELECT E.empid, E.name, E.fk_dept_code, J.job_code, J.job_name, D.dept_name
FROM  tbl_employees E
JOIN tbl_job J
ON  E.fk_job_code = J.job_code
LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
where empid !='2018100-007' and fk_dept_code = '100'
ORDER BY D.dept_code DESC, J.job_code ASC;   

SELECT E.empid, E.name, E.fk_dept_code, J.job_code, J.job_name, D.dept_name
FROM  tbl_employees E
JOIN tbl_job J
ON  E.fk_job_code = J.job_code
LEFT JOIN tbl_dept D
ON E.fk_dept_code = D.dept_code
ORDER BY D.dept_code DESC, J.job_code ASC;

where fk_dept_code = (null)

select *
from tbl_dept;


SELECT NVL(to_char(D.dept_code, ' ')) AS dept_code, D.dept_name
FROM tbl_dept D
RIGHT JOIN tbl_employees E ON E.fk_dept_code = D.dept_code
GROUP BY D.dept_code, D.dept_name
ORDER BY D.dept_code ASC;

--ORA-00909: invalid number of arguments

SELECT CASE WHEN D.dept_code IS NULL THEN '0' ELSE TO_CHAR(D.dept_code) END AS dept_code,
       nvl(D.dept_name, ' ')
FROM tbl_dept D
RIGHT JOIN tbl_employees E ON E.fk_dept_code = D.dept_code
GROUP BY D.dept_code, D.dept_name
ORDER BY D.dept_code desc;

select *
from tbl_minutes;

select *
from tbl_approval;

select *
from tbl_doc;

select *
from tbl_doc_file;


select minutes_no.nextval
from dual;


insert insert into tbl_doc(doc_no, fk_doctype_code, fk_empid, doc_subject, doc_content, created_date)
values(103, '변우석', default);

select *
from tbl_doc;

desc tbl_doc;

DELETE FROM tbl_doc;

commit;




----------- 연습용 데이터 모두 삭제하기
--1. tbl_doc_file 삭제 
DELETE FROM tbl_doc_file;

select *
from tbl_doc_file;

--2. tbl_minutes 삭제
DELETE FROM tbl_minutes;

select *
from tbl_minutes;

--3. tbl_approval 삭제
DELETE FROM tbl_approval;

select *
from tbl_approval;

--4. tbl_dayoff 삭제
DELETE FROM tbl_dayoff;

select *
from tbl_dayoff;

--4. tbl_doc 삭제
DELETE FROM tbl_doc;

select *
from tbl_doc;



-- seq 삭제 및 재생성
--1. doc_noSeq

DROP SEQUENCE doc_noSeq;

create sequence doc_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT *
FROM all_sequences
WHERE sequence_name = 'doc_noSeq';

--SELECT doc_noSeq.NEXTVAL, doc_noSeq.CURRVAL
--FROM dual;

--2.doc_file_noSeq

DROP SEQUENCE doc_file_noSeq;

create sequence doc_file_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT sequence_name
FROM all_sequences
WHERE sequence_name = 'doc_file_noSeq';

--3. minutes_noSeq

DROP SEQUENCE minutes_noSeq;

create sequence minutes_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT sequence_name
FROM all_sequences
WHERE sequence_name = 'minutes_noSeq';

--4. approval_noSeq

DROP SEQUENCE approval_noSeq;

create sequence approval_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT sequence_name
FROM all_sequences
WHERE sequence_name = 'approval_noSeq';

--5. dayoff_noSeq 


DROP SEQUENCE dayoff_noSeq;

create sequence dayoff_noSeq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

SELECT sequence_name
FROM all_sequences
WHERE sequence_name = 'dayoff_noSeq';

commit;

select *
from tbl_approval
order by approval_no, level_no;

select *
from tbl_doc_file;

select *
FROM tbl_doc;

select *
from tbl_approval

/*
select D.doc_no, D.fk_empid, D.doc_subject, D.created_date
    , T.doctype_name, A.approval_no, A.status, A.level_no, A.fk_empid AS APPROVAL_EMPID
    , F.doc_file_no
from tbl_doc D
JOIN tbl_doctype T
ON T.doctype_code = D.fk_doctype_code
JOIN tbl_approval A
ON A.fk_doc_no = D.doc_no
LEFT JOIN tbl_doc_file F
ON F.fk_doc_no = D.doc_no
where D.fk_empid = '2020200-006' */

SELECT fk_doc_no, MAX(level_no) AS max_level_no
FROM tbl_approval
GROUP BY fk_doc_no

-- 내가 작성한 서류 찾는 sql
SELECT  D.doc_no, D.fk_empid, D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date
    , T.doctype_name, AP.status, AP.level_no, AP.APPROVAL_EMPID
    , CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
FROM tbl_doc D
JOIN tbl_doctype T ON T.doctype_code = D.fk_doctype_code
JOIN ( 
    SELECT A1.fk_doc_no, A2.status, A1.level_no, A2.fk_empid AS APPROVAL_EMPID
    FROM (
        SELECT fk_doc_no, MIN(level_no) AS level_no
        FROM tbl_approval 
        GROUP BY fk_doc_no
    ) A1
    JOIN tbl_approval A2 
    ON A1.fk_doc_no = A2.fk_doc_no AND A1.level_no = A2.level_no
) AP
ON AP.fk_doc_no = D.doc_no
LEFT JOIN ( 
    SELECT fk_doc_no
    FROM tbl_doc_file
    GROUP BY fk_doc_no
) F ON F.fk_doc_no = D.doc_no
WHERE D.fk_empid = '2020200-006'
ORDER BY D.created_date DESC, D.DOC_NO DESC;

SELECT *
FROM tbl_approval

SELECT D.doc_no, D.fk_empid, D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date
    		, T.doctype_name, A.status, A.level_no, A.fk_empid AS APPROVAL_EMPID
    		, CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
		from tbl_doc D
		JOIN tbl_doctype T
		ON T.doctype_code = D.fk_doctype_code
		JOIN tbl_approval A
		ON A.fk_doc_no = D.doc_no
		LEFT JOIN (
		        SELECT fk_doc_no
		        FROM tbl_doc_file
		        GROUP BY fk_doc_no
		) F ON F.fk_doc_no = D.doc_no
		where A.fk_empid = #{loginEmpId}
        
        

from tbl_doc D
JOIN tbl_doctype T



SELECT A.fk_doc_no, A.status, A.level_no
FROM (
    SELECT fk_doc_no, status, level_no
    FROM tbl_approval
    WHERE fk_empid = '2011300-001'
) A
CROSS JOIN tbl_approval B 
ON A.fk_doc_no = B.fk_doc_no

SELECT A.fk_doc_no, A.status, A.level_no
FROM tbl_approval A
WHERE A.fk_doc_no IN (
    SELECT B.fk_doc_no
    FROM tbl_approval B
    WHERE B.fk_empid = '2013100-002' AND STATUS = 0 
);

update tbl_approval set STATUS = 1 WHERE FK_DOC_NO ='KD24-101-1' AND fk_empid = '2013100-002'

update tbl_approval set STATUS = 0 WHERE FK_DOC_NO ='KD24-101-1' AND fk_empid = '2012100-001'
COMMIT;

SELECT *
FROM tbl_approval
WHERE fK_DOC_NO IN  ('KD24-101-4', 'KD24-101-6') 
ORDER BY APPROVAL_NO, LEVEL_NO

DESC tbl_approval

select *
FROM tbl_doc

SELECT *
FROM tbl_employees
WHERE EMPID='2011300-001'

SELECT *
FROM TBL_APPROVAL 

COMMIT;

SELECT *
FROM TBL_DOC

insert into tbl_doc(doc_no, fk_doctype_code, fk_empid, doc_subject, doc_content, created_date)
values(doc_noSeq.nextval, '101', '2020200-006', 'test5 - 첨부파일 무', 'test5 - 첨부파일 무', sysdate);

insert into tbl_doc(doc_no, fk_doctype_code, fk_empid, doc_subject, doc_content, created_date)
values(doc_noSeq.nextval, '101', '2020200-006', 'test6 - 첨부파일 무', 'test6 - 첨부파일 무', sysdate);

insert into tbl_doc(doc_no, fk_doctype_code, fk_empid, doc_subject, doc_content, created_date)
values(doc_noSeq.nextval, '101', '2020200-006', 'test7 - 첨부파일 무', 'test7 - 첨부파일 무', sysdate);

commit;


select *
from tbl_approval
ORDER BY APPROVAL_NO

update tbl_doc set doc_no = 'KD24-101-8' WHERE doc_no = '8'
update tbl_doc set doc_no = 'KD24-101-7' WHERE doc_no = '7'
update tbl_doc set doc_no = 'KD24-101-9' WHERE doc_no = '9'

INSERT

SELECT *
FROM tbl_minutes

insert into tbl_minutes(minutes_no, fk_doc_no, meeting_date, attendees, host_dept)
values( minutes_noSeq.nextval, 'KD24-101-7', '24/07/22','이주빈, 서강준' , '상품개발부')

insert into tbl_minutes(minutes_no, fk_doc_no, meeting_date, attendees, host_dept)
values( minutes_noSeq.nextval, 'KD24-101-8', '24/07/22','이주빈, 서강준' , '상품개발부')

insert into tbl_minutes(minutes_no, fk_doc_no, meeting_date, attendees, host_dept)
values( minutes_noSeq.nextval, 'KD24-101-9', '24/07/22','이주빈, 서강준' , '상품개발부')


insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(approval_noSeq.nextval , 'KD24-101-7', '2012100-001', 0, 1)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(7 , 'KD24-101-7', '2013100-002', 0, 2)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(7 , 'KD24-101-7', '2014100-003', 0, 3)	

insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(approval_noSeq.nextval , 'KD24-101-8', '2012100-001', 0, 1)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(8 , 'KD24-101-7', '2013100-002', 0, 2)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(8 , 'KD24-101-7', '2014100-003', 0, 3)

insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(approval_noSeq.nextval , 'KD24-101-9', '2012100-001', 0, 1)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(9 , 'KD24-101-7', '2013100-002', 0, 2)	
insert into tbl_approval(approval_no, fk_doc_no, fk_empid, status, level_no)
values(9 , 'KD24-101-7', '2014100-003', 0, 3)


select *
from tbl_approval
order by approval_no;

update tbl_approval set fk_doc_no = 'KD24-101-9' WHERE approval_no=9


SELECT A.fk_doc_no, A.status, A.level_no, fk_empid
FROM tbl_approval A
WHERE A.fk_doc_no IN (
    SELECT B.fk_doc_no
    FROM tbl_approval B
    WHERE B.fk_empid = '2013200-001' AND STATUS = 0
) 
JOIN TBL_DOC D ON D.doc_no = A.fk_doc_no

SELECT A.fk_doc_no, A.fk_empid, A.status, A.level_no, D.doc_subject, D.doc_content, D.created_date,
        CASE WHEN F.doc_org_filename IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, T.doctype_name
FROM tbl_approval A
JOIN tbl_doc D ON D.doc_no = A.fk_doc_no
LEFT JOIN tbl_doc_file F ON F.fk_doc_no = A.fk_doc_no
JOIN tbl_doctype T ON T.doctype_code = D.fk_doctype_code
WHERE A.fk_doc_no IN (
    SELECT B.fk_doc_no
    FROM tbl_approval B
    WHERE B.fk_empid = '2013200-001' AND B.STATUS = 0
) and 


(select fk_doc_no, fk_empid, status, level_no 
from tbl_approval a
where A.fk_empid = '2013200-001' AND A.STATUS = 0)

SELECT A.fk_doc_no, A.fk_empid, A.status, A.level_no
FROM tbl_approval A
WHERE A.fk_empid = '2013200-001' 
  AND A.STATUS = 0
  AND EXISTS (
    SELECT 1
    FROM tbl_approval B
    WHERE B.fk_doc_no = A.fk_doc_no
      AND B.level_no = A.level_no + 1
)

select *
FROM tbl_approval A

DESC tbl_approval A
 
WITH 
V AS
(SELECT A.fk_doc_no, 
FROM tbl_approval A
WHERE A.fk_empid = '2013200-001' AND STATUS = 0
)

SELECT t1.APPROVAL_NO, t1.FK_DOC_NO, t1.FK_EMPID, t1.STATUS, t1.LEVEL_NO, t2.LEVEL_NO AS NEXT_LEVEL_NO
FROM tbl_approval t1
JOIN tbl_approval t2 ON t1.FK_DOC_NO = t2.FK_DOC_NO
WHERE t1.FK_EMPID = '2012100-001'
  AND t2.LEVEL_NO = t1.LEVEL_NO + 1;
  

SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
        D.doc_subject, D.doc_content, D.created_date,T.doctype_name,
        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
        CASE WHEN F.doc_org_filename IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
FROM tbl_approval A1
JOIN tbl_doc D 
ON D.doc_no = A1.fk_doc_no
JOIN tbl_doctype T 
ON T.doctype_code = D.fk_doctype_code
LEFT JOIN tbl_doc_file F 
ON F.fk_doc_no = A1.fk_doc_no
LEFT JOIN tbl_approval A2 
ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
WHERE A1.FK_EMPID = '2010001-001' AND A1.STATUS = 0 

select *
from tbl_approval A
join tbl_doc_file D
on A.fk_doc_no = D.fk_doc_no
order by approval_no, LEVEL_NO







SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
        D.doc_subject, D.doc_content, D.created_date,T.doctype_name,
        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
        CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
FROM tbl_approval A1
JOIN tbl_doc D 
ON D.doc_no = A1.fk_doc_no
JOIN tbl_doctype T 
ON T.doctype_code = D.fk_doctype_code
LEFT JOIN tbl_approval A2 
ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
LEFT JOIN (
    SELECT fk_doc_no
    FROM tbl_doc_file
    GROUP BY fk_doc_no
) F ON F.fk_doc_no = D.doc_no
WHERE A1.FK_EMPID = '2013200-001' AND A1.STATUS = 0 



SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
		        D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
		        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
		        CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
		FROM tbl_approval A1
		JOIN tbl_doc D 
		ON D.doc_no = A1.fk_doc_no
		JOIN tbl_doctype T 
		ON T.doctype_code = D.fk_doctype_code
		LEFT JOIN tbl_approval A2 
		ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
		LEFT JOIN (
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F ON F.fk_doc_no = D.doc_no
		WHERE A1.FK_EMPID = '2014100-003' AND A1.STATUS = 0 
		ORDER BY D.created_date DESC, D.DOC_NO DESC;
        
        


SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
		        D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
		        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
		        CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
FROM tbl_approval A1
JOIN tbl_doc D 
ON D.doc_no = A1.fk_doc_no
		JOIN tbl_doctype T 
		ON T.doctype_code = D.fk_doctype_code
		LEFT JOIN tbl_approval A2 
		ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
		LEFT JOIN (
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F ON F.fk_doc_no = D.doc_no
		WHERE A1.FK_EMPID = #{loginEmpId} AND A1.STATUS = 0 
		ORDER BY D.created_date DESC, D.DOC_NO DESC;
        
        
        
SELECT COUNT(*)
FROM tbl_doc D
join tbl_doctype T
on D.fk_doctype_code = T.doctype_code
WHERE lower(doctype_name) LIKE '%' || lower('회의') || '%';     


select *
from tbl_doc D


SELECT rno, doc_no, fk_empid, name, doc_subject, doc_content, created_date, doctype_name
         , doc_status, isAttachment
FROM(
    SELECT rownum AS rno
         , doc_no, fk_empid, name, doc_subject, doc_content, created_date, doctype_name
         , doc_status, isAttachment
    FROM 
        (select D.doc_no, D.fk_empid, E.name, D.doc_subject, D.doc_content,
                to_char(created_date, 'yyyy-mm-dd hh24:mi:ss') AS created_date, T.doctype_name, D.doc_status,
                CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
        from tbl_doc D
        join tbl_doctype T
        on D.fk_doctype_code = T.doctype_code  
        join tbl_employees E
        on D.fk_empid = E.empid
        LEFT JOIN (
                SELECT fk_doc_no
                FROM tbl_doc_file
                GROUP BY fk_doc_no
        ) F ON F.fk_doc_no = D.doc_no
        <choose>
            <when test='searchType == "doctype_name" and searchWord != "" '>
                where lower(doctype_name) like '%'|| lower(#{searchWord}) || '%'
            </when>
            <when test='searchType == "doc_subject" and searchWord != ""'>
                where lower(doc_subject) like '%'|| lower(#{searchWord}) || '%' 
            </when>
            <when test='searchType == "doc_content" and searchWord != ""'>
                where lower(doc_content) like '%'|| lower(#{searchWord}) || '%'
            </when>
            <when test='searchType == "doc_no" and searchWord != ""'>
                where lower(doc_no) like '%'|| lower(#{searchWord}) || '%'
            </when>
            <when test='searchType == "doc_subject_content" and searchWord != ""'>
                where (lower(doc_subject) like '%'|| lower(#{searchWord}) || '%' or lower(doc_content) like '%'|| lower(#{searchWord}) || '%')
            </when>
            <otherwise></otherwise>
        </choose> 
        order by doc_no desc
    ) V
) T     
WHERE rno between #{startRno} and #{endRno}






SELECT  D.doc_no, D.fk_empid, D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date
    		, T.doctype_name
    		, CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
		FROM tbl_doc D
		JOIN tbl_doctype T ON T.doctype_code = D.fk_doctype_code
		LEFT JOIN ( 
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F 
		ON F.fk_doc_no = D.doc_no
		WHERE D.fk_empid = '2020200-006' and doc_status =0
		ORDER BY D.created_date DESC, D.DOC_NO DESC

-- 메인화면에서 글목록 가져오기 예전 sql문
SELECT  D.doc_no, D.fk_empid, D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date
    		, T.doctype_name, AP.status, AP.level_no, AP.approval_empid
    		, CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
		FROM tbl_doc D
		JOIN tbl_doctype T ON T.doctype_code = D.fk_doctype_code
		JOIN ( 
		    SELECT A1.fk_doc_no, A2.status, A1.level_no, A2.fk_empid AS APPROVAL_EMPID
		    FROM (
		        SELECT fk_doc_no, MIN(level_no) AS level_no
		        FROM tbl_approval 
		        GROUP BY fk_doc_no
		    ) A1
		    JOIN tbl_approval A2 
		    ON A1.fk_doc_no = A2.fk_doc_no AND A1.level_no = A2.level_no
		) AP
		ON AP.fk_doc_no = D.doc_no
		LEFT JOIN ( 
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F 
		ON F.fk_doc_no = D.doc_no
		WHERE D.fk_empid = #{loginEmpId}
		ORDER BY D.created_date DESC, D.DOC_NO DESC;
        
        
SELECT doc_no, fk_doctype_code, fk_empid, doc_subject, doc_content, created_date, doc_comment, doc_status, doctype_name, name, dept_name
    , CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment
FROM tbl_doc D
JOIN tbl_doctype T
ON T.doctype_code = D.fk_doctype_code
JOIN (
    SELECT empid, name, fk_dept_code
	FROM tbl_employees
) E
ON E.empid = D.fk_empid
JOIN tbl_dept P
ON P.dept_code = E.fk_dept_code
LEFT JOIN ( 
    SELECT fk_doc_no
    FROM tbl_doc_file
    GROUP BY fk_doc_no
) F 
ON F.fk_doc_no = D.doc_no
WHERE D.doc_no = 'KD24-101-7'


ON 

JOIN tbl_minutes M
ON D.doc_no = M.

select *
from tbl_minutes
where fk_doc_no = 'KD24-101-7'



select *
from tbl_approval 
order by fk_doc_no, level_no, fk_empid

2012100-001

select count(*)
from tbl_doc D
join tbl_approval A
on d.doc_no = a.fk_doc_no
where A.fk_empid = '2012100-001' and status = 0 

        SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
		        D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
		        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
		        CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
		FROM tbl_approval A1
		JOIN tbl_doc D 
		ON D.doc_no = A1.fk_doc_no
		JOIN tbl_doctype T 
		ON T.doctype_code = D.fk_doctype_code
		LEFT JOIN tbl_approval A2 
		ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
		LEFT JOIN (
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F ON F.fk_doc_no = D.doc_no
		WHERE ((D.doc_status = 0 AND A2.status = 1) OR A2.status IS NULL) AND A1.FK_EMPID = '2012100-001' 
		ORDER BY D.created_date DESC, D.DOC_NO DESC


    SELECT rno, approval_no, fk_doc_no, fk_empid, status, level_no, doc_subject, created_date, doctype_name,
                pre_status, pre_level_no, pre_empid, isAttachment, doc_status
		FROM(
    		SELECT rownum AS rno
         		, approval_no, fk_doc_no, fk_empid, status, level_no, doc_subject, created_date, doctype_name,
                pre_status, pre_level_no, pre_empid, isAttachment, doc_status
        FROM (
        SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
		        D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
		        A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
		        CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, doc_status
		FROM tbl_approval A1
		JOIN tbl_doc D 
		ON D.doc_no = A1.fk_doc_no
		JOIN tbl_doctype T 
		ON T.doctype_code = D.fk_doctype_code
		LEFT JOIN tbl_approval A2 
		ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
		LEFT JOIN (
		    SELECT fk_doc_no
		    FROM tbl_doc_file
		    GROUP BY fk_doc_no
		) F ON F.fk_doc_no = D.doc_no
		WHERE ((D.doc_status = 0 AND A2.status = 1) OR A2.status IS NULL) AND A1.FK_EMPID = '2012100-001' 
            and lower(doc_no) like '%'|| lower('KD') || '%'
		ORDER BY D.created_date DESC, D.DOC_NO DESC
        ) V
        	) T     



SELECT rno, doc_no, fk_empid, name, doc_subject, doc_content, created_date, doctype_name
        	 , doc_status, isAttachment, fk_doctype_code
		FROM(
    		SELECT rownum AS rno
         		, doc_no, fk_empid, name, doc_subject, doc_content, created_date, doctype_name
         		, doc_status, isAttachment, fk_doctype_code
    		FROM (
    			SELECT D.doc_no, D.fk_empid, E.name, D.doc_subject, D.doc_content,
                	to_char(created_date, 'yyyy-mm-dd') AS created_date, T.doctype_name, D.doc_status,
                	CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, fk_doctype_code
		        FROM tbl_doc D
		        JOIN tbl_doctype T
		        ON D.fk_doctype_code = T.doctype_code  
		        JOIN tbl_employees E
		        ON D.fk_empid = E.empid
		        LEFT JOIN (
		                SELECT fk_doc_no
		                FROM tbl_doc_file
		                GROUP BY fk_doc_no
		        ) F ON F.fk_doc_no = D.doc_no
		        where fk_empid = #{loginEmpId}
                		and lower(doctype_name) like '%'|| lower(#{searchWord}) || '%'
	
        		ORDER BY D.created_date DESC, D.DOC_NO DESC
    		) V
		) T     
		WHERE rno between #{startRno} and #{endRno}


        
        
        
        
        
        
        
        
        
        
        
        SELECT rno, approval_no, fk_doc_no, fk_empid, status, level_no, doc_subject, created_date, doctype_name,
       pre_status, pre_level_no, pre_empid, isAttachment, doc_status, NAME, writer, dept_name
FROM (
    SELECT rownum AS rno,
           approval_no, fk_doc_no, fk_empid, status, level_no, doc_subject, created_date, doctype_name,
           pre_status, pre_level_no, pre_empid, isAttachment, doc_status, NAME, writer, dept_name
    FROM (
        SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
               D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
               A2.status AS pre_status, A2.level_no AS pre_level_no, A2.fk_empid as pre_empid,
               CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, D.doc_status, NAME, dept_name, D.fk_empid AS writer
        FROM tbl_approval A1
        JOIN tbl_doc D 
        ON D.doc_no = A1.fk_doc_no
        JOIN tbl_doctype T 
        ON T.doctype_code = D.fk_doctype_code
        LEFT JOIN tbl_approval A2 ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
        LEFT JOIN (
            SELECT fk_doc_no
            FROM tbl_doc_file
            GROUP BY fk_doc_no
        ) F ON F.fk_doc_no = D.doc_no
        JOIN tbl_employees E
        ON E.empid = D.fk_empid
        JOIN tbl_dept DP
        ON E.fk_dept_code = DP.dept_code
        WHERE ((D.doc_status = 0 AND A2.status = 1) OR A2.status IS NULL)
          AND A1.FK_EMPID = '2012100-001'
          AND LOWER(D.doc_no) LIKE '%' || LOWER('KD') || '%'
        ORDER BY D.created_date DESC, D.doc_no DESC
    ) V
)T2

desc tbl_approval


select A.FK_DOC_NO, A.STATUS, A.APPROVAL_COMMENT, A.APPROVAL_DATE, A.LEVEL_NO, E.name, J.job_name
from tbl_approval A
join tbl_employees E
on E.empid = A.FK_EMPID
join tbl_job J
ON J.job_code = E.fk_job_code
where fk_doc_no = 'KD24-101-8'
order by level_no   

SELECT
    col.column_name,
    cons.constraint_name,
    cons.constraint_type
FROM
    all_cons_columns col
JOIN
    all_constraints cons
    ON col.constraint_name = cons.constraint_name
WHERE
    cons.constraint_type = 'P' -- P indicates Primary Key
    AND col.table_name = 'TBL_APPROVAL'

select *
from TBL_APPROVAL


select A1.fk_doc_no, A1.status, A1.approval_comment, A1.approval_date, A1.level_no, E.name, J.job_name, E.sign_img,
A2.status AS pre_status, A2.level_no AS pre_level_no
from tbl_approval A1
join tbl_employees E
on E.empid = A1.FK_EMPID
join tbl_job J
ON J.job_code = E.fk_job_code
LEFT JOIN tbl_approval A2 
ON A1.FK_DOC_NO = A2.FK_DOC_NO AND A2.LEVEL_NO = A1.LEVEL_NO + 1
where A1.fk_doc_no = 'KD24-101-3'
order by A1.level_no 


select A.approval_no, A.fk_doc_no, A.fk_empid, A.status, A.approval_comment, 
 				A.approval_date, A.level_no, E.name, E.sign_img, J.job_name, D.doc_status
from tbl_approval A
join tbl_employees E
on E.empid = A.FK_EMPID
join tbl_job J
ON J.job_code = E.fk_job_code
JOIN tbl_doc D
ON D.doc_no = A.fk_doc_no
where fk_doc_no = 'KD24-101-3'
order by level_no 





------------- >>>>>>>> 일정관리(풀캘린더) 시작 <<<<<<<< -------------

-- *** 캘린더 대분류(내캘린더, 사내캘린더  분류) ***
create table tbl_calendar_large_category 
(lgcatgono   number(3) not null      -- 캘린더 대분류 번호
,lgcatgoname varchar2(50) not null   -- 캘린더 대분류 명
,constraint PK_tbl_calendar_large_category primary key(lgcatgono)
);
-- Table TBL_CALENDAR_LARGE_CATEGORY이(가) 생성되었습니다.

insert into tbl_calendar_large_category(lgcatgono, lgcatgoname)
values(1, '내캘린더');

insert into tbl_calendar_large_category(lgcatgono, lgcatgoname)
values(2, '사내캘린더');

commit;
-- 커밋 완료.

select * 
from tbl_calendar_large_category;

-- *** 캘린더 소분류 *** 
-- (예: 내캘린더 중 점심약속, 내캘린더 중 저녁약속, 내캘린더 중 운동, 내캘린더 중 휴가, 내캘린더 중 여행, 내캘린더 중 출장 등등) 
-- (예: 사내캘린더 중 플젝주제선정, 사내캘린더 중 플젝요구사항, 사내캘린더 중 DB모델링, 사내캘린더 중 플젝코딩, 사내캘린더 중 PPT작성, 사내캘린더 중 플젝발표 등등) 
create table tbl_calendar_small_category 
(smcatgono    number(8) not null      -- 캘린더 소분류 번호
,fk_lgcatgono number(3) not null      -- 캘린더 대분류 번호
,smcatgoname  varchar2(400) not null  -- 캘린더 소분류 명
,fk_empid    varchar2(40) not null   -- 캘린더 소분류 작성자 유저아이디
,constraint PK_tbl_calendar_small_category primary key(smcatgono)
,constraint FK_small_category_fk_lgcatgono foreign key(fk_lgcatgono) 
            references tbl_calendar_large_category(lgcatgono) on delete cascade
,constraint FK_small_category_fk_userid foreign key(fk_empid) references tbl_employees(empid)            
);
-- Table TBL_CALENDAR_SMALL_CATEGORY이(가) 생성되었습니다.

insert 

create sequence seq_smcatgono
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_SMCATGONO이(가) 생성되었습니다.

select *
from tbl_calendar_small_category
order by smcatgono desc;

-- *** 캘린더 상세일정 *** 
create table tbl_calendar_schedule 
(scheduleno    number                 -- 일정관리 번호
,cal_startdate     date                   -- 시작일자
,cal_enddate       date                   -- 종료일자
,cal_subject       varchar2(400)          -- 제목
,cal_color         varchar2(50)           -- 색상
,cal_place         varchar2(200)          -- 장소
,cal_joinuser      varchar2(4000)         -- 공유자   
,cal_content       varchar2(4000)         -- 내용   
,fk_smcatgono  number(8)              -- 캘린더 소분류 번호
,fk_lgcatgono  number(3)              -- 캘린더 대분류 번호
,fk_empid     varchar2(40) not null  -- 캘린더 일정 작성자 유저아이디
,constraint PK_schedule_scheduleno primary key(scheduleno)
,constraint FK_schedule_fk_smcatgono foreign key(fk_smcatgono) 
            references tbl_calendar_small_category(smcatgono) on delete cascade
,constraint FK_schedule_fk_lgcatgono foreign key(fk_lgcatgono) 
            references tbl_calendar_large_category(lgcatgono) on delete cascade   
,constraint FK_schedule_fk_userid foreign key(fk_empid) references tbl_employees(empid) 
);
-- Table TBL_CALENDAR_SCHEDULE이(가) 생성되었습니다.

create sequence seq_scheduleno
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
-- Sequence SEQ_SCHEDULENO이(가) 생성되었습니다.

select *
from tbl_calendar_schedule 
order by scheduleno desc;

-- 일정 상세 보기
select SD.scheduleno
     , to_char(SD.cal_startdate,'yyyy-mm-dd hh24:mi') as cal_startdate
     , to_char(SD.cal_enddate,'yyyy-mm-dd hh24:mi') as cal_enddate  
     , SD.cal_subject
     , SD.cal_color
     , nvl(SD.cal_place,'-') as cal_place
     , nvl(SD.cal_joinuser,'공유자가 없습니다.') as cal_joinuser
     , nvl(SD.cal_content,'') as cal_content
     , SD.fk_smcatgono
     , SD.fk_lgcatgono
     , SD.fk_empid
     , E.name
     , SC.smcatgoname
from tbl_calendar_schedule SD 
JOIN tbl_employees E
ON SD.fk_empid = E.empid
JOIN tbl_calendar_small_category SC
ON SD.fk_smcatgono = SC.smcatgono
where SD.scheduleno = 21;

commit;
-- 커밋 완료.

select *
from tbl_member
where name = '이순신';

------------- >>>>>>>> 일정관리(풀캘린더) 끝 <<<<<<<< -------------

-----------------------------------------------------------------------

select *
from tbl_employees

select scheduleno, cal_startdate, cal_enddate, cal_subject, cal_color, cal_place, cal_joinuser, cal_content, fk_smcatgono, fk_lgcatgono, fk_empid 
		from tbl_calendar_schedule
		where fk_empid = '2' OR
		fk_lgcatgono = 2 OR
		(fk_lgcatgono != 2 AND lower(cal_joinuser) like '%'|| lower('2') ||'%')
		order by scheduleno asc
        
select smcatgono, fk_lgcatgono, smcatgoname
		from tbl_calendar_small_category
		where fk_lgcatgono = 1
		and fk_empid = '2011300-001'
		order by smcatgono asc


desc tbl_calendar_schedule;

scheduleno    NOT NULL NUMBER         
cal_startdate          DATE           
cal_enddate            DATE           
cal_subject            VARCHAR2(400)  
cal_color              VARCHAR2(50)   
cal_place              VARCHAR2(200)  
cal_joinuser           VARCHAR2(4000) 
cal_content            VARCHAR2(4000) 
fk_smcatgono           NUMBER(8)      
fk_lgcatgono           NUMBER(3)      
fk_empid      NOT NULL VARCHAR2(40)   

select *
from tbl_calendar_small_category;

insert into tbl_calendar_schedule(scheduleno, cal_startdate, cal_enddate, cal_subject, cal_color, cal_place, cal_joinuser, cal_content, fk_smcatgono, fk_lgcatgono, fk_empid) 
values(seq_scheduleno.nextval, to_date('20240801100000', 'yyyymmddhh24miss'), to_date('20240801105000', 'yyyymmddhh24miss'), '제목', '#000', '장소', '2015200-002', '내용', '4', '1', '2020200-006')  

rollback;


select *
from tbl_employees
where empid='2010001-001'

desc tbl_employees

select *
from tbl_dayoff
where fk_doc_no='KD24-101-13'
order by dayoff_no desc;

desc tbl_dayoff


ALTER TABLE TBL_DAYOFF
ADD OFFDAYS NUMBER(10, 0) DEFAULT 0 NOT NULL;

<<<<<<< HEAD
	select dayoff_no, fk_doc_no, to_char(startdate, 'yyyy-mm-dd') as startdate, to_char(enddate, 'yyyy-mm-dd') as enddate, start_half, end_half, offdays
		from tbl_dayoff
		where fk_doc_no = #{doc_no}

commit;
=======
SELECT rno, doc_no, fk_empid, doc_status, doc_subject, doc_content, created_date, doctype_name,
       		isAttachment, NAME, dept_name, fk_doctype_code
		FROM (
    		SELECT rownum AS rno,
           		approval_no, fk_doc_no as doc_no, fk_empid, status, level_no, doc_subject, created_date, doctype_name,
           		isAttachment, doc_status, NAME, writer, dept_name, doc_content, fk_doctype_code
    		FROM (
        		SELECT A1.approval_no, A1.fk_doc_no, A1.fk_empid, A1.status, A1.level_no, 
               		D.doc_subject, to_char(D.created_date, 'yyyy-mm-dd') as created_date, T.doctype_name,
               		CASE WHEN F.fk_doc_no IS NOT NULL THEN '1' ELSE '0' END AS isAttachment, D.doc_status, NAME, dept_name, D.fk_empid AS writer
               		, doc_content, fk_doctype_code
        		FROM tbl_approval A1
        		JOIN tbl_doc D 
        		ON D.doc_no = A1.fk_doc_no
        		JOIN tbl_doctype T 
        		ON T.doctype_code = D.fk_doctype_code
        		LEFT JOIN (
            		SELECT fk_doc_no
            		FROM tbl_doc_file
            		GROUP BY fk_doc_no
        		) F ON F.fk_doc_no = D.doc_no
        		JOIN tbl_employees E
        		ON E.empid = D.fk_empid
        		JOIN tbl_dept DP
        		ON E.fk_dept_code = DP.dept_code
        		WHERE A1.FK_EMPID = '2012100-001'
                
                	ORDER BY D.created_date DESC, D.doc_no DESC
			) V
		)T2
		WHERE rno between #{startRno} and #{endRno}
                
        
        select *
        from tbl_approval
        where fk_empid = '2012100-001'
        
        

    
DECLARE
    v_smcatgono NUMBER;  -- 소분류 번호를 저장할 변수
BEGIN
    FOR emp_rec IN (
        SELECT empid
        FROM tbl_employees
    ) LOOP
        -- 새로운 smcatgono 값을 생성
        SELECT SEQ_SMCATGONO.NEXTVAL INTO v_smcatgono FROM dual;
        
        -- 각 empid에 대해 데이터 삽입
        INSERT INTO tbl_calendar_small_category (
            smcatgono,
            fk_lgcatgono,
            smcatgoname,
            fk_empid
        ) VALUES (
            v_smcatgono,      -- 생성된 소분류 번호
            1,                -- 대분류 번호 (고정값)
            '예약',           -- 소분류 명 (고정값)
            emp_rec.empid     -- 현재 직원의 empid
        );
    END LOOP;
END;

commit;

>>>>>>> branch 'dohyeon' of https://github.com/yerin9195/KEDAI.git
