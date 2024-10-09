-- ����Ŭ ���� ������ ���ؼ��� SYS �Ǵ� SYSTEM ���� �����Ͽ� �۾��� �ؾ� �մϴ�. [SYS ����] --
show user;
-- USER��(��) "SYS"�Դϴ�.

-- ����Ŭ ���� ������ ������ �տ� c## ������ �ʰ� �����ϵ��� �ϰڽ��ϴ�.
alter session set "_ORACLE_SCRIPT"=true;
-- Session��(��) ����Ǿ����ϴ�.

-- ����Ŭ �������� MYMVC_USER �̰� ��ȣ�� gclass �� ����� ������ �����մϴ�.
create user final_orauser5 identified by gclass default tablespace users; 
-- User MYMVC_USER��(��) �����Ǿ����ϴ�.

-- ������ �����Ǿ��� MYMVC_USER �̶�� ����Ŭ �Ϲݻ���� �������� ����Ŭ ������ ������ �Ǿ�����,
-- ���̺� ���� ����� �� �� �ֵ��� �������� ������ �ο����ְڽ��ϴ�.
grant connect, resource, create view, unlimited tablespace to final_orauser5;
-- Grant��(��) �����߽��ϴ�.

-----------------------------------------------------------------------
-- ���� - ������ - Name: remote_final_orauser5 ������̸�: final_orauser5 ��й�ȣ: gclass ��й�ȣ ���� - �׽�Ʈ - ���� - ���

create table tbl_bus
(bus_no                     VARCHAR2(30)  not null               
,pf_station_id              VARCHAR2(30)  not null          --��������̵�
,first_time                 VARCHAR2(5)  not null                  --ù���ð�
,last_time                  VARCHAR2(5)  not null                  --�����ð�
,time_gap                   NUMBER  not null          --��������
,constraint PK_tbl_bus primary key(bus_no,pf_station_id)
,constraint FK_tbl_station_pf_station_id foreign key(pf_station_id) references tbl_station(Pk_station_id)
);
drop table tbl_bus;
create sequence total_seq
start with 1
increment by 1
nomaxvalue
nominvalue
nocycle
nocache; 
-- 101
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','03122','07:00','23:59','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','04021','07:03','23:57','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','04397','07:07','23:53','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','04396','07:11','23:49','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','04019','07:12','23:48','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('101번','03123','07:14','23:46','10');
--102
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03015','07:00','23:59','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03039','07:03','23:57','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03137','07:07','23:53','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03107','07:11','23:49','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03124','07:12','23:48','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03122','07:14','23:46','10');

insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03123','07:17','23:44','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03125','07:19','23:42','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03110','07:20','23:39','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03142','07:23','23:37','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03038','07:25','23:35','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('102번','03017','07:28','23:32','10');
commit;
--103
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03090','07:00','23:59','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03170','07:03','23:57','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03103','07:07','23:53','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03172','07:11','23:49','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03122','07:12','23:48','10');

insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03123','07:17','23:44','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03173','07:19','23:42','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03104','07:20','23:39','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03169','07:23','23:37','10');
insert into tbl_bus(bus_no, pf_station_id, first_time, last_time, time_gap) values('103번','03091','07:25','23:35','10');
commit;

select *
from tbl_bus

		select bus_no, v.pf_station_id, h.pk_station_id, first_time, last_time, h.station_name, time_gap, lat, lng, way, zindex
		from 
		(
		select bus_no, pf_station_id, first_time, last_time, time_gap
		from tbl_bus
		where bus_no = '101��'
		order by first_time asc
		)v cross join
		(
		select pk_station_id, station_name, lat, lng, way, zindex
		from tbl_station
		)h
		where h.pk_station_id = v.pf_station_id
		order by v.first_time asc
        
create table tbl_station
(Pk_station_id                  VARCHAR2(30)                      --��������̵�                   
,station_name                   VARCHAR2(100)  not null           --�������
,lat                            NUMBER  not null                  --����
,lng                            NUMBER  not null                  --�浵
,constraint PK_tbl_station_station_id primary key(Pk_station_id)
);



  alter table tbl_station
  add way varchar2(200) not null;

commit;

--101��
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03122','���������Ű����.�Ƹ��б�','37.28674706537582','127.0402587819467','��⵵������������� ���',1);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('04021','��⵵�������������','37.29079534179728','127.04547963591234','�����߾�.��⵵û.���ִ뿪ȯ�¼��� ���',2);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('04397','�����߾�.��⵵û.���ִ뿪ȯ�¼���','37.288454732776685','127.05138185376052','����',3);


insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('04396','�����߾�.��⵵û.���ִ뿪ȯ�¼���','37.288537908037156','127.05177379426947','��⵵������������� ���',4);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('04019','��⵵�������������','37.291135603390984','127.04516688665875','���������Ű����.�Ƹ��б� ���',5);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03123','���������Ű����.�Ƹ��б�','37.28707375972554','127.0400587889236','����',6);

--102��
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03015','������.�뺸�ڼ���','37.268212757868156','126.99956876164312','������.�ſ�ȸ������ȸ ���',7);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03039','������.�ſ�ȸ������ȸ','37.26734320504059','127.00338785976807','��깮��� ���',8);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03137','��깮���',' 37.27510882921343','127.0181954083477','�ΰ輱�����Ʈ ���',9);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03107','�ΰ輱�����Ʈ','37.27682782145644','127.03656077602773','â����.���ִ��б�.���Ű� ���',10);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03124','â����.���ִ��б�.���Ű�','37.280878404042944','127.04211057329069','���������Ű����.�Ƹ��б� ���',11);

insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03125','â����.���ִ��б�.���Ű�','37.280574302250706','127.04211322287942','�츸�ż�����Ʈ ���',12);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03110','�츸�ż�����Ʈ','37.27707546906844','127.03700627909338','�������� ���',13);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03142','��������','37.275313764757875','127.01852525914751','������.�ſ�ȸ������ȸ ���',14);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03038','������.�ſ�ȸ������ȸ','37.26894689758696','127.00704926536443','������.AK�ö��� ���',15);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03017','������.AK�ö���','37.26745362831417','127.00081455316372','����',16);

COMMIT;
--103��
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03090','������û��9���ⱸ.���ο��ݰ���','37.26296873108508','127.03252946353398','�ΰ跡�̾ȳ��Ŭ���� ���',17);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03170','�ΰ跡�̾ȳ��Ŭ����','37.26879104986174','127.0348629277089','������������Ʈ.�ΰ�Ｚ����Ʈ ���',18);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03103','������������Ʈ.�ΰ�Ｚ����Ʈ','37.270935284162796','127.03568132562151','����޸���� ���',19);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03172','����޸����','37.278291523233456','127.03810907484589','���������Ű����.�Ƹ��б� ���',20);

insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03173','����޸����','37.280127734188476','127.03703032535326','�ΰ�Ｚ����Ʈ.������������Ʈ ���',21);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03104','�ΰ�Ｚ����Ʈ.������������Ʈ','37.27110432574714','127.03536007826766','�ΰ跡�̾ȳ��Ŭ���� ���',22);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03169','�ΰ跡�̾ȳ��Ŭ����','37.26878891362191','127.03446550797491','������û��8���ⱸ.������ũ.�������� ���',23);
insert into tbl_station(Pk_station_id, station_name, lat, lng, way, zindex) values('03091','������û��8���ⱸ.������ũ.��������','37.263757169233','127.03243397754491','����',24);

delete from tbl_bus
delete from tbl_station

  alter table tbl_station
  add zindex number;
  commit;
    update tbl_station set Pk_station_id = '1'
    where station_name between '20240305-9401' and '20240305-9901'
    ;
ROLLBACK;

SELECT *
FROM tbl_station

--����������� ���̺�
create table tbl_car
(car_seq                  NUMBER                     --��������̵�                   
,fk_empid                 VARCHAR2(30)  not null           --�������
,car_num                  VARCHAR2(100)  not null                  --����
,car_kind                 VARCHAR2(100)  not null                  --�浵
,max_num                  NUMBER  not null                  --�浵
,constraint PK_tbl_car_car_seq primary key(car_seq)
,constraint FK_tbl_car_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);


-- �Ϻ������������� ���̺�
create table tbl_day_share
(res_num                  NUMBER                      --��������̵�                   
,fk_car_seq               NUMBER  not null           --�������
,start_date               DATE  not null                  --����
,last_date                DATE  not null                  --�浵
,dp_add                   VARCHAR2(200)  not null                  --�浵
,dp_lat                   NUMBER  not null                  --�浵
,dp_lng                   NUMBER  not null                  --�浵
,ds_add                   VARCHAR2(200)  not null                  --�浵
,ds_lat                   NUMBER  not null                  --�浵
,ds_lng                   NUMBER  not null                  --�浵
,want_max                 NUMBER  not null                  --�浵
,st_fee                   NUMBER  not null                  --�浵
,end_status               NUMBER  not null                  --�浵
,cancel_status            NUMBER  not null                  --�浵
,constraint PK_tbl_day_share_res_num primary key(res_num)
,constraint FK_tbl_day_share_fk_car_seq foreign key(fk_car_seq) references tbl_car(car_seq)
);


-- �Ϻ�ž�½�û���� ���̺�
create table tbl_car_share
(pf_res_num             NUMBER                      --��������̵�                   
,pf_empid               VARCHAR2(30)  not null           --�������
,rshare_date            DATE  not null                  --����
,rdp_add                VARCHAR2(200)  not null                  --�浵
,rdp_lat                NUMBER  not null                  --�浵
,rdp_lng                NUMBER  not null                  --�浵
,rds_add                VARCHAR2(200)  not null                  --�浵
,rds_lat                NUMBER  not null                  --�浵
,rds_lng                NUMBER  not null                  --�浵
,share_fee              NUMBER  not null                  --�浵
,share_status           NUMBER  not null                  --�浵
,start_time             VARCHAR2(200)  not null                  --�浵
,end_time               VARCHAR2(200)                   --�浵
,cancel_status          DATE                   --�浵
,constraint PK_tbl_car primary key(pf_res_num,pf_empid)
,constraint FK_tbl_car_share_pf_res_num foreign key(pf_res_num) references tbl_day_share(res_num)
,constraint FK_tbl_car_share_pf_empid  foreign key(pf_empid) references tbl_employees(empid)
);

-- ��>
--------------- tbl_car
-- ���̺� �ּ���
comment on table tbl_car 
is '����� ���������� ����ִ� ���̺�';

comment on table tbl_day_share 
is '�Ϻ��������������� ����ִ� ���̺�';

comment on table tbl_car_share 
is '�Ϻ�ž�½�û������ ����ִ� ���̺�';

-- ���̺� �ּ��� Ȯ��
select *
from user_tab_comments
where table_name = 'tbl_car';

select *
from user_tab_comments
where table_name = 'tbl_day_share';

select *
from user_tab_comments
where table_name = 'tbl_car_share';
--------------- tbl_car
-- �÷��� �ּ���
comment on column tbl_car.car_seq is '����������ȣ'; 
comment on column tbl_car.fk_empid is '������̵�'; 
comment on column tbl_car.car_num is '����ȣ'; 
comment on column tbl_car.car_kind is '����'; 
comment on column tbl_car.max_num is '�ִ�ž���ο�'; 

--------------- tbl_car_share
-- �÷��� �ּ���
comment on column tbl_car_share.pf_res_num is '�����ȣ'; 
comment on column tbl_car_share.pf_empid is '������̵�'; 
comment on column tbl_car_share.rshare_date is 'ž������'; 
comment on column tbl_car_share.rdp_add is '������ּ�'; 
comment on column tbl_car_share.rdp_lat is '���������'; 
comment on column tbl_car_share.rdp_lng is '������浵'; 
comment on column tbl_car_share.rds_add is '�������ּ�'; 
comment on column tbl_car_share.rds_lat is '����������'; 
comment on column tbl_car_share.rds_lng is '�������浵'; 
comment on column tbl_car_share.share_fee is '���Һ��'; 
comment on column tbl_car_share.share_status is '���ο���'; 
comment on column tbl_car_share.start_time is '�����ð�'; 
comment on column tbl_car_share.end_time is '�����ð�'; 


--------------- tbl_day_share
-- �÷��� �ּ���
comment on column tbl_day_share.res_num is '�����ȣ'; 
comment on column tbl_day_share.fk_car_seq is '����������ȣ'; 
comment on column tbl_day_share.start_date is '������������'; 
comment on column tbl_day_share.last_date is '������������'; 
comment on column tbl_day_share.dp_add is '������ּ�'; 
comment on column tbl_day_share.dp_lat is '���������'; 
comment on column tbl_day_share.dp_lng is '������浵'; 
comment on column tbl_day_share.ds_add is '�������ּ�'; 
comment on column tbl_day_share.ds_lat is '����������'; 
comment on column tbl_day_share.ds_lng is '�������浵'; 
comment on column tbl_day_share.want_max is '����'; 
comment on column tbl_day_share.st_fee is '����'; 
comment on column tbl_day_share.end_status is '��������'; 
comment on column tbl_day_share.cancel_status is '��ҿ���'; 

-- �÷��� �ּ��� Ȯ��
select column_name, comments
from user_col_comments
where table_name = 'tbl_car';

-- �÷��� �ּ��� Ȯ��
select column_name, comments
from user_col_comments
where table_name = 'tbl_car_share';

-- �÷��� �ּ��� Ȯ��
select column_name, comments
from user_col_comments
where table_name = 'tbl_day_share';


select *
from tbl_station;

commit;

select bus_no, v.pf_station_id, h.pk_station_id, first_time, last_time, h.station_name, time_gap, lat, lng, way
from 
(
select bus_no, pf_station_id, first_time, last_time, time_gap
from tbl_bus
where bus_no = '101번'
order by first_time asc
)v cross join
(
select pk_station_id, station_name, lat, lng, way
from tbl_station
)h
where h.pk_station_id = v.pf_station_id
;

SELECT 
    v.bus_no, 
    v.pf_station_id, 
    h.pk_station_id, 
    v.first_time, 
    v.last_time, 
    h.station_name, 
    v.time_gap
FROM 
    (
        SELECT 
            bus_no, 
            pf_station_id, 
            first_time, 
            last_time, 
            time_gap
        FROM 
            tbl_bus
        WHERE 
            bus_no = '101��'
        ORDER BY 
            first_time ASC
    ) v
JOIN
    (
        SELECT 
            pk_station_id, 
            station_name
        FROM 
            tbl_station
    ) h
ON 
    h.pk_station_id = v.pf_station_id;
    
alter table tbl_station
drop column station_icon;
commit;

select bus_no, v.pf_station_id, h.pk_station_id, first_time, last_time, h.station_name, time_gap, lat, lng, way
from 
(
select bus_no, pf_station_id, first_time, last_time, time_gap
from tbl_bus
where bus_no = '103번'
order by first_time asc
)v cross join
(
select pk_station_id, station_name, lat, lng, way
from tbl_station
)h
where h.pk_station_id = v.pf_station_id
order by v.first_time asc

select *
from tbl_day_share

commit;

--사원차량정보 테이블
create table tbl_car
(car_seq                  NUMBER                     --정류장아이디                   
,fk_empid                 VARCHAR2(30)  not null           --정류장명
,car_num                  VARCHAR2(100)  not null                  --위도
,car_kind                 VARCHAR2(100)  not null                  --경도
,max_num                  NUMBER  not null                  --경도
,constraint PK_tbl_car_car_seq primary key(car_seq)
,constraint FK_tbl_car_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);


-- 일별차량공유정보 테이블
create table tbl_day_share
(res_num                  NUMBER                      --정류장아이디                   
,fk_car_seq               NUMBER  not null           --정류장명
,start_date               DATE  not null                  --위도
,last_date                DATE  not null                  --경도
,dp_add                   VARCHAR2(200)  not null                  --경도
,dp_lat                   NUMBER  not null                  --경도
,dp_lng                   NUMBER  not null                  --경도
,ds_add                   VARCHAR2(200)  not null                  --경도
,ds_lat                   NUMBER  not null                  --경도
,ds_lng                   NUMBER  not null                  --경도
,want_max                 NUMBER  not null                  --경도
,st_fee                   NUMBER  not null                  --경도
,end_status               NUMBER  not null                  --경도
,cancel_status            NUMBER  not null                  --경도
,constraint PK_tbl_day_share_res_num primary key(res_num)
,constraint FK_tbl_day_share_fk_car_seq foreign key(fk_car_seq) references tbl_car(car_seq)
);


-- 일별탑승신청정보 테이블
create table tbl_car_share
(pf_res_num             NUMBER                      --정류장아이디                   
,pf_empid               VARCHAR2(30)  not null           --정류장명
,rshare_date            DATE  not null                  --위도
,rdp_add                VARCHAR2(200)  not null                  --경도
,rdp_lat                NUMBER  not null                  --경도
,rdp_lng                NUMBER  not null                  --경도
,rds_add                VARCHAR2(200)  not null                  --경도
,rds_lat                NUMBER  not null                  --경도
,rds_lng                NUMBER  not null                  --경도
,share_fee              NUMBER  not null                  --경도
,share_status           NUMBER  not null                  --경도
,start_time             NUMBER  not null                  --경도
,end_time               DATE                   --경도
,cancel_status          DATE                   --경도
,constraint PK_tbl_car primary key(pf_res_num,pf_empid)
,constraint FK_tbl_car_share_pf_res_num foreign key(pf_res_num) references tbl_day_share(res_num)
,constraint FK_tbl_car_share_pf_empid  foreign key(pf_empid) references tbl_employees(empid)
);

-- 예>
--------------- tbl_car
-- 테이블 주석문
comment on table tbl_car 
is '사원의 차량정보가 들어있는 테이블';

comment on table tbl_day_share 
is '일별차량공유정보가 들어있는 테이블';

comment on table tbl_car_share 
is '일별탑승신청정보가 들어있는 테이블';

-- 테이블 주석문 확인
select *
from user_tab_comments
where table_name = 'TBL_CAR';

select *
from user_tab_comments
where table_name = 'TBL_DAY_SHARE';

select *
from user_tab_comments
where table_name = 'TBL_CAR_SHARE';
--------------- tbl_car
-- 컬럼명 주석문
comment on column tbl_car.car_seq is '차량정보번호'; 
comment on column tbl_car.fk_empid is '사원아이디'; 
comment on column tbl_car.car_num is '차번호'; 
comment on column tbl_car.car_kind is '차종'; 
comment on column tbl_car.max_num is '최대탑승인원'; 

--------------- tbl_car_share
-- 컬럼명 주석문
comment on column tbl_car_share.pf_res_num is '예약번호'; 
comment on column tbl_car_share.pf_empid is '사원아이디'; 
comment on column tbl_car_share.rshare_date is '탑승일자'; 
comment on column tbl_car_share.rdp_add is '출발지주소'; 
comment on column tbl_car_share.rdp_lat is '출발지위도'; 
comment on column tbl_car_share.rdp_lng is '출발지경도'; 
comment on column tbl_car_share.rds_add is '도착지주소'; 
comment on column tbl_car_share.rds_lat is '도착지위도'; 
comment on column tbl_car_share.rds_lng is '도착지경도'; 
comment on column tbl_car_share.share_fee is '지불비용'; 
comment on column tbl_car_share.share_status is '승인여부'; 
comment on column tbl_car_share.start_time is '승차시간'; 
comment on column tbl_car_share.end_time is '하차시간'; 


--------------- tbl_day_share
-- 컬럼명 주석문
comment on column tbl_day_share.res_num is '예약번호'; 
comment on column tbl_day_share.fk_car_seq is '차량정보번호'; 
comment on column tbl_day_share.start_date is '모집시작일자'; 
comment on column tbl_day_share.last_date is '모집마감일자'; 
comment on column tbl_day_share.dp_add is '출발지주소'; 
comment on column tbl_day_share.dp_lat is '출발지위도'; 
comment on column tbl_day_share.dp_lng is '출발지경도'; 
comment on column tbl_day_share.ds_add is '도착지주소'; 
comment on column tbl_day_share.ds_lat is '도착지위도'; 
comment on column tbl_day_share.ds_lng is '도착지경도'; 
comment on column tbl_day_share.want_max is '정원'; 
comment on column tbl_day_share.st_fee is '가격'; 
comment on column tbl_day_share.end_status is '마감상태'; 
comment on column tbl_day_share.cancel_status is '취소여부'; 

-- 컬럼명 주석문 확인
select column_name, comments
from user_col_comments
where table_name = 'TBL_CAR';

-- 테이블 이름이 time_table이고, 컬럼 이름이 time_column이라고 가정합니다.
SELECT
    first_time,
    TO_DATE(first_time, 'HH24:MI:SS') AS time_converted,
    CURRENT_DATE AS current_time,
    (CURRENT_DATE - TO_DATE(first_time, 'HH24:MI:SS')) * 24 * 60 AS minutes_difference
FROM
    tbl_bus;


-- 컬럼명 주석문 확인
select column_name, comments
from user_col_comments
where table_name = 'tbl_car_share';

-- 컬럼명 주석문 확인
select column_name, comments
from user_col_comments
where table_name = 'tbl_day_share';

select *
from tbl_bus;

desc tbl_bus;

SELECT first_time
     , LENGTH(FIRST_TIME)
     , TO_DATE(first_time, 'HH24:MI') AS first_time
  FROM TBL_BUS
;

SELECT TO_DATE('07:00', 'HH24:MI')
  FROM DUAL
;

-- 몇분전 계산하기
WITH current_times
AS (
      select bus_no, v.pf_station_id, h.pk_station_id, first_time, last_time, h.station_name, time_gap, lat, lng, way, current_time, zindex
        from 
        (
            select bus_no, pf_station_id, TO_DATE(first_time, 'HH24:MI') AS first_time
                 , TO_DATE(last_time, 'HH24:MI') AS last_time, time_gap
                 , TO_DATE(TO_CHAR(SYSDATE, 'HH24:MI'), 'HH24:MI') AS current_time
            from tbl_bus
            where pf_station_id = '03090'
            order by first_time asc
        )v cross join
        (
            select pk_station_id, station_name, lat, lng, way, zindex
            from tbl_station
        )h
        where h.pk_station_id = v.pf_station_id
        order by v.first_time asc
    )
SELECT
    bus_no, pf_station_id, station_name, way, lat, lng, zindex,
    CASE
            WHEN current_time < first_time THEN
                ROUND((first_time - current_time) * 24 * 60)
            WHEN current_time > last_time THEN
            NULL
        ELSE
            ROUND(
                (time_gap - MOD(
                    (current_time - first_time) * 24 * 60,
                    time_gap
                ))
            )
    END AS minutes_until_next_bus
FROM
    current_times;
    
select *
from tbl_employees

delete from tbl_employees
where empid = '2010400-001';

update tbl_employees set orgimgfilename = 'DORY.jpg'
where empid = '2010400-001';

commit;

select *
from tbl_loginhistory

drop table tbl_car purge;

commit;


create table tbl_car
(car_seq                  NUMBER                     --��������̵�                   
,fk_empid                 VARCHAR2(30)      not null           --�������
,car_num                  VARCHAR2(100)     not null                  --����
,car_type                 VARCHAR2(100)     not null                  --�浵
,max_num                  NUMBER            not null
,insurance                NUMBER            not null 
,drive_year               VARCHAR2(30)      not null 
,car_imgfilename          VARCHAR2(100)     
,car_orgimgfilename       VARCHAR2(100)     
,constraint PK_tbl_car_car_seq primary key(car_seq)
,constraint FK_tbl_car_fk_empid foreign key(fk_empid) references tbl_employees(empid)
);

create table tbl_day_share
(res_num                  NUMBER                      --��������̵�                   
,fk_car_seq               NUMBER            not null           --�������
,start_date               DATE              not null                  --����
,last_date                DATE              not null                  --�浵
,dp_name                  VARCHAR2(200)     not null                  --�浵
,dp_add                   VARCHAR2(200)     not null                  --�浵
,dp_lat                   NUMBER            not null                  --�浵
,dp_lng                   NUMBER            not null                  --�浵
,ds_name                  VARCHAR2(200)     not null                  --�浵
,ds_add                   VARCHAR2(200)     not null                  --�浵
,ds_lat                   NUMBER            not null                  --�浵
,ds_lng                   NUMBER            not null                  --�浵
,want_max                 NUMBER            not null                  --�浵                 --�浵
,end_status               NUMBER            not null                  --�浵
,cancel_status            NUMBER            not null                  --�浵
,total_calculate          NUMBER  
,total_pay                NUMBER  
,total_nonpay             NUMBER  
,constraint PK_tbl_day_share_res_num primary key(res_num)
,constraint FK_tbl_day_share_fk_car_seq foreign key(fk_car_seq) references tbl_car(car_seq)
);

create table tbl_car_share
(pf_res_num             NUMBER                      --��������̵�                   
,pf_empid               VARCHAR2(30)        not null           --�������
,share_date             DATE                not null                  --����
,share_may_time         DATE                not null                  --����
,accept_yon             NUMBER              not null                  --����
,reason_nonaccept       VARCHAR2(200)                             --����
,rdp_name               VARCHAR2(200)                                  --����
,rdp_add                VARCHAR2(200)                         --�浵
,rdp_lat                NUMBER                              --�浵
,rdp_lng                NUMBER                               --�浵
,rds_name               VARCHAR2(200)                      --�浵
,rds_add                VARCHAR2(200)                     --�浵
,rds_lat                NUMBER                             --�浵
,rds_lng                NUMBER                           --�浵
,getin_time             DATE                          --�浵
,getout_time            DATE
,use_time               DATE
,settled_amount         NUMBER                   --�浵
,payment_amount         DATE                   --�浵
,nonpaymnet_amount      DATE                   --�浵
,constraint PK_tbl_car primary key(pf_res_num,pf_empid,share_date)
,constraint FK_tbl_car_share_pf_res_num foreign key(pf_res_num) references tbl_day_share(res_num)
,constraint FK_tbl_car_share_pf_empid  foreign key(pf_empid) references tbl_employees(empid)
);

commit;

select car_seq, fk_empid, car_num, car_type, max_num, insurance, drive_year
from tbl_car
where fk_empid = '2010400-001';

select res_num, fk_car_seq, start_date,last_date,dp_name,dp_add,dp_lat, dp_lng, ds_name, ds_add, ds_lat, ds_lng, want_max, end_status, cancel_status, start_time
from tbl_day_share
order by res_num;


select res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, nickname, readCount
from
(
select row_number() over(order by res_num desc) AS rno, res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, nickname, readCount
from 
(
select res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, fk_car_seq, readCount
from tbl_day_share
where end_status = 1 and cancel_status = 1 and lower(dp_name) like '%'
)a cross join
(
    select car_seq, fk_empid, car_num, car_type, max_num, nickname
    from 
    (
        select *
        from tbl_car
    ) v cross join
    (
        select *
        from tbl_employees
    ) h
    where fk_empid = h.empid
)b
where fk_car_seq = b.car_seq
)C
where c.rno between 1 and 5


 update tbl_day_share set readCount = 0

commit;

alter table tbl_day_share modify readCount default 0 not null;

select *
from tbl_day_share

desc tbl_day_share

   alter table tbl_day_share
   add readCount number;
   
   commit;
select count(*)
from tbl_day_share
where cancel_status = 1

select *
from tbl_day_share
select distinct nickname
from a.tbl_day_share join b.tbl_employees
 ON A.constraint_name = B.empid
where cancel_status = 1

select distinct nickname
from
(
    select fk_car_seq, dp_name, ds_name, cancel_status, start_date, last_date
    from tbl_day_share
) v 
cross join
(
select empid, car_seq, nickname
from tbl_car a join tbl_employees b
on a.fk_empid = b.empid
)h
where h.car_seq = v.fk_car_seq and cancel_status = 1 and lower(nickname) like '%' ||lower('dory')||'%'


select *
from tbl_car_share

desc tbl_car_share

ALTER TABLE tbl_car_share MODIFY (SHARE_MAY_TIME VARCHAR2(10));
commit;

SELECT COLUMN_NAME, DATA_DEFAULT
FROM USER_TAB_COLUMNS
WHERE TABLE_NAME = 'tbl_car_share';

ALTER TABLE tbl_car_share MODIFY (ACCEPT_YON number DEFAULT 0);

    select res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, nickname, readCount
    from
    (
    select row_number() over(order by res_num desc) AS rno, res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, nickname, readCount
    from 
    (
    select res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, fk_car_seq, readCount
    from tbl_day_share
    where end_status = 1 and cancel_status = 1
                    AND TO_DATE('2024-07-29', 'YYYY-MM-DD') BETWEEN start_date AND last_date
    )a cross join
    (
        select car_seq, fk_empid, car_num, car_type, max_num, nickname
        from 
        (
            select *
            from tbl_car
        ) v cross join
        (
            select *
            from tbl_employees
        ) h
        where fk_empid = h.empid
    )b
    where fk_car_seq = b.car_seq
    )C
WHERE c.rno between 1 and 10

select *
from tbl_day_share

select count(*)
from 
(
select res_num, start_date, last_date, dp_name, ds_name, want_max, end_status, cancel_status, start_time, fk_car_seq
from tbl_day_share
where end_status = 1 and cancel_status = 1
)a cross join
(
    select car_seq, fk_empid, car_num, car_type, max_num, nickname
    from 
    (
        select *
        from tbl_car
    ) v cross join
    (
        select *
        from tbl_employees
        where empid = '2010400-001'
    ) h
    where fk_empid = h.empid
)b
where fk_car_seq = b.car_seq and lower(dp_name) like '%'|| lower('cj')||'%'

select count(*)
from tbl_day_share
where cancel_status = 1

desc tbl_car_share;


ALTER TABLE tbl_car_share
MODIFY (PAYMENT_AMOUNT number);

ALTER TABLE tbl_car_share
RENAME COLUMN NONPAYMNET_AMOUNT TO NONPAYMENT_AMOUNT;

COMMIT;

select pf_res_num, pf_empid, share_date, share_may_time, accept_yon, reason_nonaccept, rdp_name, rdp_add, rdp_lat, rdp_lng, rds_name, rds_add, rds_lat, rds_lng, getin_time, getout_time, use_time, settled_amount, payment_amount, nonpaymnet_amount
from tbl_car_share
where to_date(share_date, 'yyyy-mm-dd') = to_date('24-07-30', 'yyyy-mm-dd')

-- 마이페이지에서 카셰어링현황(차주) 페이지 list 뽑기
select pf_res_num, pf_empid, share_date, share_may_time, accept_yon, reason_nonaccept, rdp_name, rdp_add, rdp_lat, rdp_lng, rds_name, rds_add, rds_lat, rds_lng, getin_time, getout_time, use_time, settled_amount, payment_amount, nonpayment_amount, nickname
from 
(
    select pf_res_num, pf_empid, share_date, share_may_time, accept_yon, reason_nonaccept, rdp_name, rdp_add, rdp_lat, rdp_lng, rds_name, rds_add, rds_lat, rds_lng, getin_time, getout_time, use_time, settled_amount, payment_amount, nonpayment_amount
    from tbl_car_share
)a cross join
(
    select car_seq, fk_empid, car_num, car_type, max_num, nickname
    from 
    (
        select *
        from tbl_car
    ) v cross join
    (
        select *
        from tbl_employees
        where empid = '2010001-001'
    ) h
    where fk_empid = h.empid
)b

select *
from tbl_employees