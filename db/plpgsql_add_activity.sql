drop function if exists add_activity(int, int, int, int, int, char, timestamptz, timestamptz, int, char, varchar);


create function add_activity
  (user_id int, line int, dir int, s_stop int, e_stop int, final_stop char(4),
   s_time timestamptz, e_time timestamptz, msg_id int, train_no char(6), stat_msg varchar(60) )
   returns void as
$body$

begin
  insert into activities
    (user_id, line, dir, s_stop, e_stop, final_stop,
     s_time, e_time, expiry, 
     status, created_at, updated_at,
     train_no, message_id, msg_comment
    ) values (
      user_id,line, dir, s_stop, e_stop, final_stop,

      s_time, e_time, e_time + interval '1 hour',
      0, current_timestamp, current_timestamp,
      train_no, msg_id, stat_msg   
    )
  ;
end;
$body$
language plpgsql;