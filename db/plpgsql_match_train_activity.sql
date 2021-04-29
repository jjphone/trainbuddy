drop function if exists match_train_activity(int, int, int);
create function match_train_activity(owner_id int,msg_id int, max_limit int )
  returns table(msg text) as 
$body$
begin
  drop table if exists matches;
  create temp table matches
    (a_name varchar, a_comment varchar, o_user_id int, o_name varchar, o_comment varchar, cast_msg varchar);


  insert into matches
  	select 
		case when source.a_alias is null then ('@' || ua.name || '#=0 ') else ('@' || source.a_alias || '#=0 ') end as a_name,
		case when source.a_comment is null then ('-' || source.a_final ) else ('-' || source.a_final || ' <' || source.a_comment || '>') end as a_comment,
		
		source.o_user_id as o_user_id,
		case when source.o_alias is null then ('@' || uo.name || '#=0 ') else ('@' || source.o_alias || '#=0 ') end as o_name,
		case when source.o_comment is null then ('-' || source.o_final ) else ('-' || source.o_final || ' <' || source.o_comment || '>') end as o_comment,

		case when	( source.o_s_stop < source.o_e_stop and source.a_s_stop < source.o_s_stop ) 
		or 		( source.o_s_stop >=source.o_e_stop and source.a_s_stop >=source.o_s_stop ) then

		( so.s_code || '(' || to_char( (source.o_s_time at time zone 'UTC') at time zone 'Australia/Sydney', 'HH24:MI') || ')' )
		else
		( sa.s_code || '(' || to_char( (source.a_s_time at time zone 'UTC') at time zone 'Australia/Sydney', 'HH24:MI') || ')' )
		end 		as cast_msg
	
	from
	(	select 
			a.id 		as a_id,
			a.user_id 	as a_user_id,
			of.alias_name	as a_alias,
			a.msg_comment 	as a_comment,
			a.line 		as a_line,
			a.s_stop 	as a_s_stop,
			a.e_stop 	as a_e_stop,
			a.final_stop	as a_final,
			a.s_time	as a_s_time,
			
			o.id 		as o_id,
			o.user_id 	as o_user_id,
			af.alias_name	as o_alias,
			o.msg_comment 	as o_comment,
			o.line		as o_line,
			o.s_stop 	as o_s_stop,
			o.e_stop 	as o_e_stop,
			o.final_stop	as o_final,
			o.s_time	as o_s_time,
			rank()
		over 	(partition by o.user_id order by o.s_time) as pos
		from		activities a, 		activities o,
				relationships af,	relationships of

		where	a.user_id = owner_id
		and	a.message_id = msg_id
		and		a.status	= 0
		and		o.status	= 0
--		and		(o.expiry::Timestamp at time zone 'UTC')	> current_timestamp 
		and		a.line		= o.line
		and		a.dir		= o.dir
		and		a.train_no	= o.train_no
		and	( 		(o.s_stop <= a.s_stop and a.s_stop <= o.e_stop) 
				or 	(o.e_stop <= a.s_stop and a.s_stop <= o.s_stop)
				or 	(a.s_stop <= o.s_stop and o.s_stop <= a.e_stop)
				or 	(a.e_stop <= o.s_stop and o.s_stop <= a.s_stop)
			)
		and 	af.user_id = owner_id
		and	of.friend_id = owner_id
		and		af.status 	= 3
		and		of.status	= 3
		and		af.friend_id	= of.user_id
		and		of.user_id	= o.user_id

	) as source, 			stations sa, 			stations so,
							users ua,			users uo
	where 
	 		sa.line		= source.a_line
	and		so.line		= source.o_line
	and		sa.s_seq	= source.a_s_stop
	and		so.s_seq	= source.o_s_stop

	and		ua.id		= source.a_user_id
	and		uo.id		= source.o_user_id
	and	source.pos < 2
  ;

  insert into broadcasts(user_id, ref_msg, status, source, bc_content, created_at, updated_at)
	select		m.o_user_id,
			msg_id,
			2,
			1,
			(m.a_name || m.cast_msg || m.a_comment ),
			current_timestamp at time zone 'UTC',
			current_timestamp at time zone 'UTC'
	from 		matches m
 ;
	
 
  return query
    select 	(m.o_name || m.cast_msg || m.o_comment)
    from 	matches m;
end;
$body$
language plpgsql