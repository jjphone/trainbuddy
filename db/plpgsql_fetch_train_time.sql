drop function if exists fetch_train_time (timestamp with time zone , char, char, char, bool, int, int,  bool, int, int, char, varchar);
create function fetch_train_time
  (travel_date timestamp with time zone , s_stop char, e_stop char, begin_time char, weekend bool, prefer_line int default null, same_line_bonus int default 5,
     islog_db bool default false, user_id int default 0, msg_id int default 0, final_dest char default null, stat_msg varchar default null)
--  returns table (line int, dir int, train_no char(6), beg_seq int, b_code char(4), depart_tm char(5), end_seq int, e_code char(4), arrive_tm char(5), pos bigint ) as
  --returns record as
  returns table(train_line int, train_no char(6), depart_tm char(5), arrive_tm char(5) ) as 
$body$
declare
  train_line int;
  dir int;
  s_seq int;
  e_seq int;
  
  train_no char(6);
  depart_tm char(5);
  arrive_tm char(5);

  res record;
begin



  select    t.line, t.train_dir, t.train_no, 
            t.beg_seq,  t.depart_tm,
            t.end_seq,  t.arrive_tm
  into    train_line, dir, train_no,
    s_seq,  depart_tm, 
    e_seq,  arrive_tm
  from (
    select      b.line, a.train_dir, b.train_no,

                a.beg_seq, b.s_code as b_code, b.stop_time as depart_tm,
      
                a.end_seq, e.s_code as e_code, e.stop_time as arrive_tm,
                rank() over (partition by b.line, b.train_dir order by b.stop_time ) as pos
    from 
    (  select   b.line                                      as train_line,
                case when b.s_seq<e.s_seq then case when weekend then 6 else 1 end
                else case when weekend then 5 else 0 end  end       as train_dir,
                b.s_seq                                     as beg_seq,
                e.s_seq                                     as end_seq
     from             stations b, stations e
     where    b.s_code        = s_stop
     and      e.s_code        = e_stop
     and      b.line          = e.line
    )   as a,   train_time b, train_time e
    where     b.s_code        = s_stop
    and       e.s_code        = e_stop
    and       b.stop_time     >= begin_time
    and       b.line          = e.line
    and       b.train_dir     = e.train_dir
    and       b.train_no      = e.train_no
    and       b.line          = a.train_line
    and       b.train_dir     = a.train_dir
  ) as t
  where t.pos < 2
  order by  case when t.line = prefer_line then to_timestamp(t.arrive_tm, 'HH24:MI') - same_line_bonus * interval '1 minute'
    else to_timestamp(t.arrive_tm, 'HH24:MI') end
  ;

  if (islog_db and train_no is not null) then
    perform add_activity(user_id, train_line, dir, s_seq, e_seq, final_dest,
      travel_date + depart_tm::Time, 
      travel_date  + arrive_tm::Time,
      msg_id, train_no,stat_msg );
  end if;

  
  return query select  train_line, train_no, depart_tm, arrive_tm;
  
end;
$body$ language plpgsql;
