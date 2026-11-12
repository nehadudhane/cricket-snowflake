use role accountadmin;
use warehouse compute_wh;
use schema cricket.clean;

select
    raw.info:match_type_number :: int as match_type_number,
    p.key::text as country,
    team.*
    -----team.value: text as player_name
    from cricket.raw.match_raw_tbl raw,
    lateral flatten (input => raw.info:players) p,
    lateral flatten (input => p.value) team
    where match_type_number = 4667;


-----player clean table
create or replace table player_clean_tbl as 
select 
    rcm.info:match_type_number::int as match_type_number, 
    p.path::text as country,
    team.value:: text as player_name,
    stg_file_name ,
    stg_file_row_number,
    stg_file_hashkey,
    stg_modified_ts
from cricket.raw.match_raw_tbl ram,
lateral flatten (input => rcm.info:players) p,
lateral flatten (input => p.value) team;

desc table cricket.clean.player_clean_tbl;

select get_ddl('table','cricket.clean.player_clean_tbl');

---add not null and fk relationships
alter table cricket.clean.player_clean_tbl
modify column match_type_number set not null;

alter table  cricket.clean.player_clean_tbl
modify column country set not null;

alter table cricket.clean.player_clean_tbl
modify column player_name set not null;

alter table cricket.clean.match_detail_clean
add constraint pk_match_type_number primary key (match_type_number);

alter table cricket.clean.player_clean_tbl
add constraint fk_match_id
foreign key (match_type_number)
references cricket.clean.match_detail_clean (match_type_number);

