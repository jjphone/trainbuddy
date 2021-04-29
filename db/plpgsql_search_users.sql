drop function if exists search_users(int, varchar, varchar, varchar, int);
create function search_users(owner_id int, keyword varchar(254), phone_no varchar(254), email_add varchar(254), max_limit int )
  returns table(id int, name text) as 
$body$
begin
  return query 
  select    u.id, 
            u.name || ' ( @'  || u.login || src.name || ' )'
  from 
  (
    select u.id as id, '' as name
    from  users u
    where   (email_add is null OR u.email like ('%' || email_add || '%') )
    and   (phone_no is null OR u.phone like ('%' || phone_no || '%') )
    and   (keyword is null OR (u.name ilike ('%' || keyword || '%') or u.login ilike ('%' ||  keyword || '%') )  )    AND   (phone_no is null OR u.phone like ('%' || phone_no || '%') )
    union
    select  r.friend_id as id, ' - '|| r.alias_name as name
    from  relationships r
    where r.user_id = owner_id
    and   r.alias_name ilike ('%' || keyword || '%')
    and   r.alias_name is not null
    ) as src, users u
    where src.id = u.id
    limit max_limit
  ;
end;
$body$ language plpgsql;
