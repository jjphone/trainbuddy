
drop function if exists find_friend_locations(int, varchar);

create function find_friend_locations(owner_id int, tm_str varchar(20))
  returns table(  user_id int, name varchar, a_id int, final_stop varchar, 
                  dir int, line int, train_no char(6),
                  s_code char(4), s_name varchar, stop_time char(5), display_pos int) as 
$body$
declare
  tm Timestamptz :=  tm_str::Timestamp at time zone 'Australia/Sydney';
begin

return query
  select        out.u_id,   out.u_name,   out.a_id,       out.final,
                out.dir,    out.line,     out.train_no,
                out.s_code, out.s_name,   out.stop_time,  out.display_pos
from 
(
  select  a.u_id,   a.u_name,     a.a_id,   a.final,
    a.dir,    a.line,     t.train_no,
    t.s_code, s.s_name,   t.stop_time,  s.display_pos,
    rank() over (partition by t.train_no, t.line order by t.stop_time ) as pos
  from 
  ( select      u.u_id      as u_id,
          u.u_name    as u_name,
          a.id      as a_id,
          a.s_stop    as s_stop,
          a.e_stop    as e_stop,
          a.final_stop    as final,
          a.line      as line,
          a.dir     as dir,
          a.train_no    as train_no,
          a.s_time    as s_time,
          rank()
      over (partition by a.user_id order by a.s_time) as rank
    from  (   select  s.id as u_id,
                      s.login as u_name
        from      users s
        where  s.id = owner_id
        union
        select  u.id as u_id,
          case when r.alias_name is null then u.login else r.alias_name end as u_name
        from  relationships r, relationships o, users u
        where r.user_id = owner_id
        and o.friend_id = owner_id
        and   r.status    = 3
        and   o.status    = 3
        and   r.friend_id   = o.user_id
        and     u.id      = o.user_id
      ) as u, 
      activities a
    where     a.status    = 0
    and   a.user_id   = u.u_id
    and     a.e_time at time zone 'UTC' > tm
  ) as a,
  train_time t, stations s
  where     a.rank < 2
  and  t.stop_time >= to_char(tm at time zone 'Australia/Sydney', 'HH24:MI')
  and   t.line      = a.line
  and   t.line      = s.line
  and     t.train_dir   = a.dir
  and   t.train_no    = a.train_no
  and   t.s_code    = s.s_code

  and   case when a.s_stop < a.e_stop then s.s_seq between a.s_stop and a.e_stop 
      else s.s_seq between a.e_stop and a.s_stop end
) as out
where pos < 2;

end;
$body$ language plpgsql