drop function if exists select_posts(int, int, bool, int);
create function select_posts(owner_id int, target_id int, all_posts bool, max_limit int)
  returns table (post_id int) as 
$body$
begin
  return query
  select 	id
  from 		microposts
  where	
		user_id in 
		( 		select 	distinct user_id
				from 	relationships 
				where 	status = 3
				and		friend_id = owner_id
				union
				select 	owner_id
		)
  and	(target_id is null OR user_id = target_id )
  and 	(all_posts OR expire_at > current_timestamp)
  order by updated_at DESC
  limit max_limit
  ;
end;
$body$ language plpgsql;