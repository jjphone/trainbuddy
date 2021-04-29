-- public find_travel_path
drop function if exists find_travel_path(char, char, char, char, char);
create function find_travel_path
  (stop1 char(4), stop2 char(4), stop3 char(4) default null, stop4 char(4) default null, stop5 char(4) default null)
  returns text as $body$
declare
  res text; 
  tmp text;
begin
  res := plot_connect_stop_codes(stop1, stop2);

  if length(res) > 4 then
    res := stop1 || res;
  else
    return null;
  end if;

  if stop3 is null then
    return res;
  end if;
    
  res := res || plot_connect_stop_codes(stop2, stop3);
  if stop4 is null then 
    return res ;
  end if;

  res := res || plot_connect_stop_codes(stop3, stop4);
  if stop5 is null then 
    return res ;
  end if;

  return res || plot_connect_stop_codes(stop4, stop5);
end;
$body$ language plpgsql;