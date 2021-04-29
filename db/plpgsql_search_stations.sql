drop function if exists search_stations(varchar, int, varchar);
create function search_stations(term varchar, limits int, from_name varchar)
  returns table ( value varchar, label varchar, pos int, length int) as
$body$
begin
  return query 

  select 
    s.value,
    s.label,
    position(term in s.key),
    length(term)
    
  from station_keys s
  where
    s.key like ('%' || term || '%')
  
  and   (from_name is null OR s.key not ilike '%' || from_name || '%' )
  order by 3
  limit limits;


end;
$body$ language plpgsql;