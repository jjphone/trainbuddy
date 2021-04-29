drop function if exists find_stop_times(int, int);

create function find_stop_times(owner_id int, activity_id int)
  returns table (s_code char(4), s_name varchar(30), stop_time char(5) ) as
$body$
declare
begin

  return query 
  select 		
			t.s_code, s.s_name, t.stop_time
  from 			activities a, 		
			train_time t,		stations s
  where a.id =  activity_id

  and   a.user_id in 
      ( select owner_id
        union
        select        user_id
        from          relationships
        where friend_id = owner_id
        and           status = 3
        )

  and		t.line			= a.line
  and		t.train_no		= a.train_no
  and		t.line			= s.line
  and		t.s_code		= s.s_code
  and 		(case when a.s_stop < a.e_stop then s.s_seq between a.s_stop and a.e_stop else s.s_seq between a.e_stop and a.s_stop end)
  order by t.stop_time;
  
end;
$body$
language plpgsql;

