/*1. feladat*/
create or replace procedure elsofeladat(myneptunid varchar2) is

teljesnev varchar2(100);

osszeskredit number;

hanytargyat number;

vane number;

begin 

select count(neptunid) into vane from hallgatok where neptunid=myneptunid;

if vane > 0
then

select knev' 'vnev into teljesnev from hallgatok where NEPTUNID=myneptunid;

select sum(kredit) into osszeskredit from leckekonyv natural join kurzusok where neptunid=myneptunid;

select count(erdemjegy) into hanytargyat from leckekonyv where neptunid=myneptunid and erdemjegy >= 4;

dbms_output.put_line(teljesnev);
dbms_output.put_line(osszeskredit);
dbms_output.put_line(hanytargyat);

else
dbms_output.put_line('Nincs ilyen neptun kódú hallgató!');

end if;

end;

execute elsofeladat('OEM4F8'); 

/*2. feladat*/

create table KUrzusokLog (LogTime date,LogEvent varchar2(50));

set define off;
create or replace trigger masodikfeladat
after insert or update or delete on kurzusok
for each row
declare

begin 

if inserting
then
insert into kurzusoklog values(current_timestamp,'Insert data');

elsif deleting
then
insert into kurzusoklog values(current_timestamp,'Delete data');

elsif updating
then
insert into kurzusoklog values(current_timestamp,'Update data');

end if;

end;
insert into kurzusok values(105,'wau',sysdate,12,13,14);
/*3. feladat*/
/*a,*/
select kurzusid,
nev 
from kurzusok k 
where 
(select count(neptunid) from leckekonyv where kurzusid=k.kurzusid)=0;

/*b,*/ 
select knev' 'vnev as name,
(select count(kurzusid) from leckekonyv l where neptunid=h.neptunid) as targyak,
(select round(avg(erdemjegy),1) from leckekonyv where neptunid=h.neptunid) as atlag
from hallgatok h 
order by atlag asc
fetch first row only; 
/*c,*/ 
select nev,
(select round(avg(erdemjegy),1) from leckekonyv where kurzusid=k.kurzusid) as atlag
from kurzusok k
where (select count(oktatoid) from leckekonyv where kurzusid=k.kurzusid)>1
fetch first 5 rows only;
/*d,*/
select 
neptunid,
knev' 'vnev as name,
email,
(select count(kurzusid) from leckekonyv where neptunid=h.neptunid) as tagyakszama,
(select sum(kredit) from leckekonyv natural join kurzusok where neptunid=h.neptunid and erdemjegy>1) as kreditekszama
from hallgatok h
order by name, neptunid;