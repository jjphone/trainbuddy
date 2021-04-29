
drop function if exists update_existing_activity(int, timestamptz, timestamptz, int);

create function update_existing_activity
  (owner_id int, beg_time timestamptz, end_time timestamptz, msg_id int)
  returns int as
$body$
declare
  updated int := 0;
begin

  update  activities a
  set     expiry = current_timestamp, updated_at = current_timestamp, status = 1
  where   a.user_id   = owner_id
  and   a.expiry at time zone 'UTC'  > current_timestamp
  and   a.status  = 0
  and   a.message_id  <> msg_id
  and   (beg_time, end_time) overlaps (a.s_time at time zone 'UTC', a.e_time at time zone 'UTC')
/*  ( a.s_time between start_tm and end_tm OR start_tm between a.s_time and a.e_time   ) */
;
  GET DIAGNOSTICS updated := ROW_COUNT;

  update microposts a
  set   expire_at = current_timestamp, 
  content = ('EXPIRED : ' ||  substr(content, 1,216)  || '--  updated by Post Corrector') 
  -- 255 - 39

  where a.user_id = owner_id
  and   a.message_id  is not NULL
  and   a.message_id  <> msg_id 
  and   a.expire_at at time zone 'UTC' > current_timestamp
  and   (beg_time, end_time) overlaps (a.s_time at time zone 'UTC', a.e_time at time zone 'UTC')
/*  and     ( a.s_time between start_tm and end_tm OR start_tm between a.s_time and a.e_time   ) */
  ; 
  return updated;
end;
$body$
language plpgsql;