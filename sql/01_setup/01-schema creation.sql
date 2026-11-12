use role accountadmin;
use warehouse compute_wh;

----creating a database called cricket and 4 schemas
create database if not exists cricket;
create or replace schema cricket.land;
create or replace schema cricket.raw;
create or replace schema cricket.clean;
create or replace schema cricket.consumption;

show schemas in database cricket;

use schema cricket.land;

--json file format
 create or replace file format cricket.land.my_json_format
 type = json
 null_if = ('\\n', 'null', '')
 strip_outer_array=true
 comment ='Json File Format with outer stip arrray flag true';

 ---creating internal stage

 create or replace stage cricket.land.my_stg;

 --list internal stage
 list @cricket.land.my_stg;

 --
 list @my_stg/cricket/json;

 -- quick check if data is coming correctly or not
select 
        t.$1:meta::variant as meta, 
        t.$1:info::variant as info, 
        t.$1:innings::array as innings, 
        metadata$filename as file_name,
        metadata$file_row_number int,
        metadata$file_content_key text,
        metadata$file_last_modified stg_modified_ts
     from  @my_stg/cricket/json/1384401.json (file_format => 'my_json_format') t;

SELECT CURRENT_ORGANIZATION_NAME(), CURRENT_ACCOUNT_NAME();

