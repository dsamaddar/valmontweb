
-- drop table tbl_job_card_rpt_dt_range
create table tbl_job_card_rpt_dt_range(
rpt_year int not null,
rpt_month int not null,
rpt_dt_starts datetime not null,
rpt_dt_ends datetime not null,
constraint pk_job_card_rpt_dt_range primary key (rpt_year,rpt_month)
);

GO

insert into tbl_job_card_rpt_dt_range(rpt_year,rpt_month,rpt_dt_starts,rpt_dt_ends)
values(2022,4,'04/01/2022 00:00:01 AM','04/25/2022 11:59:59 PM'),
(2022,5,'04/26/2022 00:00:01 AM','05/31/2022 11:59:59 PM');

GO

select * from tbl_job_card_rpt_dt_range;