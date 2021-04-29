-- private plot_connect_stop_codes
drop function if exists plot_connect_stop_codes(char, char);
create function plot_connect_stop_codes
  (s_stop char(4), e_stop char(4)) 
  returns text as $$
declare routes text;

begin
  select '1' into routes
  from stations s, stations e
  where s.s_code = s_stop
  and	e.s_code = e_stop
  and 	s.line = e.line
  limit 1;
  if routes is not null then	
    return '-' || e_stop;
  end if;

  select ('-' || i.stops || '-'|| dest.s_code) into routes
  from interchanges as i
  inner join stations as src on src.line = i.from_line
  inner join stations as dest on dest.line = i.to_line
  where	src.s_code = s_stop
  and	dest.s_code = e_stop
  order by 	abs(src.s_seq - i.from_seq) + abs(dest.s_seq-i.to_seq) + i.cost, 
		abs(src.s_seq - i.from_seq)
  limit 1;
  return routes;
end;
$$ language plpgsql;