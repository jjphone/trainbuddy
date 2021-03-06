# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# trainbuddy


###   Metadata   ###
files = [	'db/level_settings_insert.sql',
			'db/train_lines_insert.sql', 
			'db/train_stations_insert.sql', 
			'db/train_interchanges_insert.sql',
			'db/train_seq_insert.sql',
			'db/train_stations_insert.sql',
			'db/train_station_keys_insert.sql',
			'db/train_time_table_create.sql',
			'db/train_time_insert.sql'
		]

files.each{ |file|
	puts "Running - #{file} : ----"	
  	res = ActiveRecord::Base.connection.execute(File.open(file, 'r').read)
  	puts "done !  ---- "
}



###   Stored Prod   ###
prods = [	'db/plpgsql_plot_connect_stop_codes.sql',
			'db/plpgsql_find_travel_path.sql',
			'db/plpgsql_find_friend_locations.sql',
			'db/plpgsql_add_activity.sql',
			'db/plpgsql_fetch_train_time.sql',
			'db/plpgsql_update_existing_activity.sql',
			'db/plpgsql_create_activity_post.sql',
			'db/plpgsql_find_arrival_times.sql',
			'db/plpgsql_find_stop_times.sql',
			'db/plpgsql_notify_updates.sql',
			'db/plpgsql_match_train_activity.sql',
			'db/plpgsql_match_nearby_activity.sql',
			"db/plpgsql_search_users.sql",
			"db/plpgsql_search_stations.sql",
			"db/plpgsql_login_available.sql",
			'db/plpgsql_select_feeds.sql'
		  ]
prods.each{ |file|
	puts "Running - #{file} : ----"	
	res = ActiveRecord::Base.connection.execute(File.open(file, 'r').read)
  	puts "done !  ---- "

}



