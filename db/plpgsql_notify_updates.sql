drop function if exists notify_updates(int, varchar);
create function notify_updates
  (owner_id int, travel_plan varchar(80))
  returns void as
$body$
begin
  insert into broadcasts (user_id, ref_msg, status, source, bc_content, created_at, updated_at)
  (  select	distinct b.user_id, /*other user_id been broadcasted with owner's previous_msg*/
		a.message_id,
		2,
		1,
		(	'User (' ||
			case when f.alias_name is null then u.name else f.alias_name end || 
			') has updated travel plan to ' ||
			travel_plan ||
			', contact the user to confirm.'
			) as bc_content,
		current_timestamp at time zone 'UTC',
		current_timestamp at time zone 'UTC'
	from	activities a, broadcasts b, users u, relationships f  
	where	a.status 	= 1
	and 	a.user_id	= owner_id
	and 	a.message_id	= b.ref_msg
	and	b.user_id	<> owner_id
	and 	b.user_id	= f.user_id
	and	f.friend_id	= owner_id
	and	u.id		= owner_id
) ;

	/*mark those processed in activities table  */
	update activities a
	set 	status 	= 2, updated_at = current_timestamp
	where 	a.status 	= 1
	and	a.user_id	= owner_id;
end;
$body$
language plpgsql;