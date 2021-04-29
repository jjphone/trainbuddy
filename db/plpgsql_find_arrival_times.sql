drop function if exists find_arrival_times(varchar , timestamptz, bool, int, int, varchar);
create function find_arrival_times
  (path_str varchar, begin_time timestamptz, isLog_dB bool, user_id int, msg_id int, stat_msg varchar(80) )
  returns table(res varchar, updated_rows int, debug_msg varchar) as $body$ 

declare
  path_len 	int 	:= length(path_str);
  start_pos 	int 	:= 0;
  word_len	int	:= 9;
  step_size	int	:= 5;
  code_len	int	:= 4;
  updated_rows	int;
  e_stop	char(4);
  s_stop	char(4);
  final_dest	char(4)	:= substr(path_str, path_len - code_len +1, code_len);
  depart_tm	char(5);
  arrive_tm	char(5);
  
  train_line int := 0;
  train_no	char(6);
  isWeekend	bool;

  travel_time timestamptz := begin_time;
--  travel_time timestamptz := begin_time at time zone 'Australia/Sydney';
  travel_date timestamptz := date_trunc('day', begin_time at time zone 'Australia/Sydney') at time zone 'Australia/Sydney' ;
  s_time char(5) := to_char(begin_time at time zone 'Australia/Sydney', 'HH24:MI');

  debug_msg varchar;
  res		varchar(254) := '';

begin

  if extract(DOW FROM travel_time) between 1 and 5 then
    isWeekend := false;
  else
    isWeekend := true;
  end if;


  loop
    exit when start_pos + word_len > path_len;
    s_stop := substr(path_str, start_pos+1, code_len);
    start_pos := start_pos + step_size;
    e_stop := substr(path_str, start_pos+1, code_len);  

    select * from fetch_train_time(travel_date , s_stop, e_stop, s_time, isWeekend, train_line, 5, isLog_dB, user_id, msg_id, final_dest, stat_msg)
    into train_line, train_no, depart_tm, arrive_tm;

    if train_no is null then
      res := 'No train match the conditions or time > 11pm';
      updated_rows := -1;
      exit;
    else
      res := res || s_stop || '(' || depart_tm || ')-' ;
      s_time := arrive_tm;   
    end if;

  end loop;
    
  if train_no is null then
    arrive_tm := substr(res, length(res)-6, 5);
    res := 'Error : ' || res || ' - ' || e_stop  ;
    return query 
      select res, updated_rows, debug_msg;
  else
    res := res || e_stop || '(' || arrive_tm || ')' ;
    if isLog_dB then
      depart_tm := substr(res, 6, 5);
      debug_msg := 'update_existing_activity(' || to_char(user_id,'999')  ||  ', ' || depart_tm ||  ', ' || arrive_tm  || ', ' || to_char(msg_id, '9999') || ');'  ;

      select update_existing_activity(user_id,
              travel_date  + depart_tm::TIME, 
              travel_date  + arrive_tm::TIME,
              msg_id) into updated_rows;

      perform create_activity_post(res, user_id, msg_id, stat_msg);
    else
      updated_rows := 0;
    end if;
   
    return query select res, updated_rows, debug_msg;
  end if;




end;
$body$
language plpgsql;
