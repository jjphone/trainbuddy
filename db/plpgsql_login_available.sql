drop function if exists login_available(text);
create function login_available(term text)
  returns table (value text  , label text ) as
$body$
begin
  if exists (select 1 from users where login = term limit 1 ) then
    return query select ''::text, 'NOT Available - existing login'::text ;
  else
    return query select term, 'Login available - ' || term ;
  end if;
end;
$body$ language plpgsql;
