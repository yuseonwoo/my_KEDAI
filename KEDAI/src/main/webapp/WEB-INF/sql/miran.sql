show user;
-- USER이(가) "FINAL_ORAUSER5"입니다

-- 급여 테이블 
create table tbl_sal
(salary_seq NUMBER not null --  급여번호
, fk_empid VARCHAR2(30) not null -- 사원아이디
, payment_date DATE not null    --  지급일자
, work_day NUMBER not null  --  근무일수
, work_day_plus NUMBER  --  초과근무일수
, base_salary NUMBER not null   --  기본급
, meal_pay NUMBER   --  식대
, annual_pay NUMBER     --  연차수당
, overtime_pay NUMBER   --  초과근무수당
, income_tax NUMBER     --  소득세
, local_income_tax NUMBER   --  지방소득세
, national_pen NUMBER   --  국민연금
, health_ins NUMBER     --  건강보험
, employment_ins NUMBER     --  고용보험
, constraint PK_tbl_sal primary key(salary_seq) 
, constraint FK_tbl_sal_fk_empid FOREIGN key(fk_empid) references tbl_employees(empid)
);
--  Table TBL_SAL이(가) 생성되었습니다.

comment on table tbl_sal 
is '급여 테이블';
--  Comment이(가) 생성되었습니다.

create sequence salary_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;
--  Sequence SALARY_SEQ이(가) 생성되었습니다.

comment on column tbl_sal.salary_seq is '급여번호'; 
comment on column tbl_sal.FK_EMPID is '사원아이디'; 
comment on column tbl_sal.PAYMENT_DATE is '지급일자'; 
comment on column tbl_sal.WORK_DAY is '근무일수'; 
comment on column tbl_sal.WORK_DAY_PLUS is '초과근무일수'; 
comment on column tbl_sal.BASE_SALARY is '기본급'; 
comment on column tbl_sal.MEAL_PAY is '식대'; 
comment on column tbl_sal.ANNUAL_PAY is '연차수당'; 
comment on column tbl_sal.OVERTIME_PAY is '초과근무수당'; 
comment on column tbl_sal.INCOME_TAX is '소득세'; 
comment on column tbl_sal.LOCAL_INCOME_TAX is '지방소득세'; 
comment on column tbl_sal.NATIONAL_PEN is '국민연금'; 
comment on column tbl_sal.HEALTH_INS is '건강보험'; 
comment on column tbl_sal.EMPLOYMENT_INS is '고용보험'; 
-- Comment이(가) 생성되었습니다.

select *
from user_col_comments
where table_name = 'TBL_SAL';



create table tbl_room
(reservation_seq NUMBER not null --  예약번호
, fk_empid VARCHAR2(30) not null -- 사원아이디
, fk_room_name VARCHAR2(30) not null    --  회의실명
, content VARCHAR2(100)  --  목적
, start_time DATE not null  --  시작시간
, end_time DATE not null   --  종료시간
, registerday DATE not null   --  예약일자
, reservation_status NUMBER default 0 not null   --  예약가능상태
, constraint PK_tbl_room primary key(reservation_seq) 
, constraint FK_tbl_room_fk_empid FOREIGN key(fk_empid) references tbl_employees(empid)
, constraint FK_tbl_room_fk_room_name FOREIGN key(fk_room_name) references tbl_room_detail(room_name)
);

create sequence reservation_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

comment on table tbl_room is '회의실예약 테이블';

comment on column tbl_room.reservation_seq is '예약번호'; 
comment on column tbl_room.fk_empid is '사원아이디'; 
comment on column tbl_room.fk_room_name is '회의실명'; 
comment on column tbl_room.content is '목적'; 
comment on column tbl_room.start_time is '시작시간'; 
comment on column tbl_room.end_time is '종료시간'; 
comment on column tbl_room.registerday is '예약일자'; 
comment on column tbl_room.reservation_status is '예약가능상태'; 



create table tbl_room_detail
(room_name VARCHAR2(30) not null    --  회의실명
, usable_num NUMBER not null    --  수용인원
, assets VARCHAR2(50) -- 보유자산
, usable_status NUMBER default 0 not null  --   자산사용상태
, constraint PK_tbl_room_detail primary key(room_name)
)


comment on table tbl_room_detail
is '회의실 상세 테이블';

comment on column tbl_room_detail.room_name is '회의실명'; 
comment on column tbl_room_detail.usable_num is '수용인원'; 
comment on column tbl_room_detail.assets is '보유자산'; 
comment on column tbl_room_detail.usable_status is '자산사용상태'; 


select * from tbl_room_detail

create table tbl_room_main
(pk_roomMain_seq NUMBER not null    --  
, roomMain_name varchar2(30) not null
, roomMain_detail varchar2(300) not null
, constraint PK_tbl_room_main primary key(pk_roomMain_seq)
)

ALTER TABLE tbl_room_main MODIFY roomMain_detail NULL;

create sequence room_main_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

comment on table tbl_room_main is '회의실대분류 테이블';

comment on column tbl_room_main.pk_roomMain_seq is '대분류번호';
comment on column tbl_room_main.roomMain_name is '대분류이름';
comment on column tbl_room_main.roomMain_detail is '대분류설명';

insert into tbl_room_main(pk_roomMain_seq, roomMain_name) 
values(room_main_seq.nextval, '3층')

commit

select * from tbl_room_main

create table tbl_room_sub
(pk_roomSub_seq NUMBER not null
, roomSub_name VARCHAR2(30) not null
, roomSub_detail VARCHAR2(300) null
, room_status NUMBER default 0
, fk_roomMin_seq NUMBER null
, constraint PK_tbl_room_sub primary key(pk_roomSub_seq)
, constraint FK_tbl_room_sub_fk_roomMin_seq FOREIGN key(fk_roomMin_seq) references tbl_room_main(pk_roomMain_seq)
)

create sequence roomSub_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache;

comment on table tbl_room_sub is '회의실소분류 테이블';

comment on column tbl_room_sub.pk_roomSub_seq is '소분류번호';
comment on column tbl_room_sub.roomSub_name is '소분류이름';
comment on column tbl_room_sub.roomSub_detail is '소분류설명';
comment on column tbl_room_sub.room_status is '자산이용상태';
comment on column tbl_room_sub.fk_roomMin_seq is '대분류번호';

insert into tbl_room_sub(pk_roomSub_seq, roomSub_name, room_status, fk_roomMin_seq)
values(roomSub_seq.nextval, '302호', '0', '4')

commit