drop table if exists connection;
create table connection  (status varchar(5));
insert into connection values ('alive');
drop function if exists test_connection(timestamptz);
create function test_connection( test_time timestamptz)
	 returns table( status varchar(5), UTC_date timestamp) as 
$body$ 

begin
  return query 
    select c.status, test_time at time zone 'UTC'
    from connection c
    limit 1;
end;

$body$
language plpgsql;


