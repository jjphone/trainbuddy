

select find_arrival_times('cams-cent', current_date + interval '9 hours', false, 1, 2, 'ask only');
- > "("cams(09:09)-cent(09:34)",0,"update_existing_activity(   1, 09:09, 09:34,     2);")"


select find_arrival_times('cams-cent', to_timestamp('2013-04-01 23:00', 'YYYY-MM-DD HH24:MI'  ) , false, 3, 2, 'friend 3');
- > "("cams(09:09)-cent(09:34)",0,"update_existing_activity(   1, 09:09, 09:34,     2);")"

select find_travel_path('cams', 'hurs');

select find_train_times('cams', 'cent', '09:00', false, false, 1, 1, 'cent', null);

select test_train_time()

select find_train_time('cams', 'cent', '09:00', false, true, 1, 1, 'cent', null) 

call find_friend_locations(1, '2013-02-14 05:35')

select match_nearby_activity(1, 2, 10, 5)

select create_activity_post('cams(09:39)-cent(10:15)-strf(10:28)', 1, 5, 'sql inject2')
select update_existing_activity(   1, 09:39, 10:29,     8);
 

str = "find_friend_locations(1, '2013-02-14 05:35')"
res = ActiveRecord::Base.connection.select_all("select " + str).paginate(page: 1, per_page:2)


ActiveRecord::Base.connection.select_all("select " + str)


"!tb#syd=ask#loc=cent2cams"
