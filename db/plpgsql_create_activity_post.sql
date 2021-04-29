drop function if exists create_activity_post(varchar, int, int, varchar);
create function create_activity_post
  ( travel_str varchar(100), owner_id int, msg_id int, stat_msg varchar(80) )
  returns text as
$body$
declare
  post_id int;
  b_time timestamptz;
  f_time timestamptz;
  exp_time timestamptz;
  res_id int := 0;
  res_stop varchar(254);
  post varchar(254);
  opt_link varchar(254);
  res_final varchar(254);
  
  cur cursor for
    select	(s.s_name || '@' || a.line || ':' || a.id) as res_stop,
		a.id as res_id
    from 	activities a, stations s
    where	a.user_id 	= owner_id
    and		a.message_id 	= msg_id
    and		a.line		= s.line
    and		a.s_stop	= s.s_seq
    and		a.expiry at time zone 'UTC'	> current_timestamp
    order by 	a.s_time desc;
begin
  open cur;
  loop --only header loop, loop once
    fetch cur into res_stop, res_id;
    exit when not found;

    select 	distinct s.s_name into res_final
    from	stations s, activities a
    where 	a.id		= res_id
    and		s.s_code 	= a.final_stop
    limit 1;
    opt_link := res_stop || '-' || res_final ;
    
    <<stop_loop>>
    loop
      fetch cur into res_stop, res_id;
      exit stop_loop when not found;
      opt_link := res_stop || '-' || opt_link ;     
    end loop stop_loop;

    exit;
  end loop;
  
  close cur;
  
  if stat_msg is null then
    post := (E'< No Subj >\n\nEst.Time: ' ||  travel_str ||  E'\n \n-- updated by Trainfinder (click links below for details)' );
  else
    post := (stat_msg ||  E'\n\nEst.Time: ' ||  travel_str || E'\n \n-- updated by Trainfinder (click links below for details)' );
  end if;
  select 	min(a.s_time at time zone 'UTC'),
		max(a.e_time at time zone 'UTC'),
		max(a.expiry at time zone 'UTC')
  into		b_time, f_time, exp_time
  from 		activities a
  where		a.user_id	= owner_id
  and		a.message_id	= msg_id
  limit 1;

  insert into 	microposts (content, user_id, created_at, updated_at, 
			    message_id, s_time, e_time, expire_at, opt_link )
  values( 	substr(post,1,254),
		owner_id, now(), now(),
		msg_id, b_time at time zone 'UTC', f_time at time zone 'UTC', exp_time at time zone 'UTC', opt_link);
	
  
  return post ;
end;
$body$
language plpgsql;