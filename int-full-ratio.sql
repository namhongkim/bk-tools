/*
 * int-full-ratio
 *
 * For all tables, report how "full" the integer columns are.
 * I.e. how close the maximum value is to overflowing the int data type.
 *
 * WARNING: the query below generates SQL queries that do full table
 * scans against all tables in the specified database(s).
 *
 * NOTE: the query below only reports against the 'test' schema.
 * You should use this query only as an example, and customize it.
 *
 * Copyright 2013 Bill Karwin
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

use test;
drop table if exists ti;
drop table if exists uti;
drop table if exists si;
drop table if exists usi;
drop table if exists mi;
drop table if exists umi;
drop table if exists i;
drop table if exists ui;
drop table if exists bi;
drop table if exists ubi;

create table ti (id tinyint auto_increment primary key) auto_increment=100;
insert into ti () values ();
create table uti (id tinyint unsigned auto_increment primary key) auto_increment=100;
insert into uti () values ();
create table si (id smallint auto_increment primary key) auto_increment=10000;
insert into si () values ();
create table usi (id smallint unsigned auto_increment primary key) auto_increment=10000;
insert into usi () values ();
create table mi (id mediumint auto_increment primary key) auto_increment=1000000;
insert into mi () values ();
create table umi (id mediumint unsigned auto_increment primary key) auto_increment=1000000;
insert into umi () values ();
create table i (id int auto_increment primary key) auto_increment=1000000000;
insert into i () values ();
create table ui (id int unsigned auto_increment primary key) auto_increment=1000000000;
insert into ui () values ();
create table bi (id bigint auto_increment primary key) auto_increment=10000000000000000;
insert into ti () values ();
create table ubi (id bigint unsigned auto_increment primary key) auto_increment=10000000000000000;
insert into ubi () values ();

select concat('select ',
  group_concat(concat('round(max(`', column_name, '`)*100/', max_int, ', 2)', ' as pct_', column_name)),
  ' from `', table_schema, '`.`', table_name, '`;') as _sql
from
(select c.table_schema, c.table_name, c.column_name, c.ordinal_position,
case 
when c.column_type like 'tinyint% unsigned' then pow(2,8)-1
when c.column_type like 'tinyint%' then pow(2,7)-1
when c.column_type like 'smallint% unsigned' then pow(2,16)-1
when c.column_type like 'smallint%' then pow(2,15)-1
when c.column_type like 'mediumint% unsigned' then pow(2,24)-1
when c.column_type like 'mediumint%' then pow(2,23)-1
when c.column_type like 'int% unsigned' then pow(2,32)-1
when c.column_type like 'int%' then pow(2,31)-1
when c.column_type like 'bigint% unsigned' then pow(2,64)-1
when c.column_type like 'bigint%' then pow(2,63)-1
else null
end as max_int
from information_schema.columns c
where c.table_schema in ('test') and c.column_type like '%int%') dt
group by table_schema, table_name;
