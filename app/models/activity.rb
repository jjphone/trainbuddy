class Activity < ActiveRecord::Base
  attr_accessible :message_id, :status, :user_id, :msg_comment
  belongs_to	:user

  MATCH_HEADER = '#tb@'
  KEY_LOC='loc'
  KEY_TIME='time'
  KEY_DEF='def'
  KEY_MGN='mgn'
  KEY_MATE='mate'
  KEY_STAT='comm'
  KEY_SYD='syd'
  LOC_DELIMS='&|-|2'
  ERROR_MSG = nil
  
  STATIONS = Hash["allawah"=>"allw", "arncliffe"=> "arnc", "artarmon"=> "artm", "ashfield"=> "ashf", "auburn"=> "aubn",
  					"banksia"=> "bans", "bankstown"=> "bant", "bardwellpark"=> "barp", "belmore"=> "belm", "berala"=> "berl", "beverlyhill"=> "bevh", "bexleynorth"=> "bexn", 
  					"birrong"=> "birr", "blacktown"=> "blat", "bondijunction"=> "bonj", "burwood"=> "burw", 
  					"cabramatta"=> "cabm", "campsie"=> "cams", "canterbury"=> "canb", "carlingford"=> "carf", "carramar"=> "carm", 
  					"carlton"=> "cart", "casula"=> "casl", "central"=> "cent", "chatswood"=> "chaw", "chesterhill"=> "cheh", 
  					"circular quay"=> "cirq", "circularquay"=> "cirq", "clyde"=> "clyd", "camellia"=> "cmla", "canley vale"=> "cnlv", 
  					"canleyvale"=> "cnlv", "concordwest"=> "conw", "croydon"=> "crod", 
  					"denistone"=> "dens", "dundas"=> "dnds", "domesticairport"=> "doma", "dulwishhill"=> "dulh", 
  					"eastwood"=> "easw", "easthill"=> "eath", "edgecliff"=> "edgc", "epping"=> "eppg", "erskineville"=> "ersv", 
  					"fairfield"=> "faif", "flemington"=> "flet", 
  					"glenfield"=> "glef", "granville"=> "grav", "greensquare"=> "gsqu", "guildford"=> "guif", 
  					"harrispark"=> "harp", "holsworthy"=> "holw", "homebush"=> "homb", "hurlstonepark"=> "hurp", "hurstville"=> "hurv", 
  					"internationalairport"=> "inta", "kingsgrove"=> "kgro", "kingscross"=> "kinc", "kograph"=> "kogr", 
  					"lakemba"=> "lakb", "leightonfield"=> "leif", "lewisham"=> "lews", "lidcombe"=> "lidc", "liverpool"=> "livp", 
  					"macdonaldtown"=> "mact", "macquarieuniversity"=> "maqu", "martinplace"=> "marp", "marrickville"=> "marv", 
  					"mascot"=> "masc", "meadowbank"=> "meab", "merrylands"=> "merl", 
  					"milsonspoint"=> "milp", "macquariepark"=> "mqrp", "museum"=> "musm", 
  					"narwee"=> "narw", "newtown"=> "newt", "northryde"=> "nryd", "northstrathfield"=> "nstf", "northsydney"=> "nsyd", "olympicpark"=> "olyp", 
  					"padstow"=> "padt", "panania"=> "pann", "parramatta"=> "parm", "pendlehill"=> "penh", "petersham"=> "pets", "punchbowl"=> "punb", 
  					"rydalmere"=> "rdlm", "redfern"=> "redf", "regentsparks"=> "regp", "revesby"=> "revb", "rhodes"=> "rhod", 
  					"riverwood"=> "rivw", "rockdale"=> "rocd", "rosehill"=> "rosh", 
  					"sefton"=> "seft", "sevenhill"=> "sevh", "st james"=> "sjam", "stjames"=> "sjam", "stleonards"=> "sleo", 
  					"stpeter"=> "spet", "stanmore"=> "stam", "strathfield"=> "strf", "summerhill"=> "sumh", "sydenham"=> "sydn", 
  					"telopea"=> "telp", "tempe"=> "temp", "toongabbie"=> "toob", "town hall"=> "towh", "townhall"=> "towh", "turrella"=> "turl", "villawood"=> "vilw", 
  					"warwick farm"=> "warf", "warwickfarm"=> "warf", "waverton"=> "wavt", "westmead"=> "wesm", 
  					"wentworthville"=> "wewv", "wileypark"=> "wilp", "wollicreek"=> "wolc", "westryde"=> "wryd", "wollstonecraft"=> "wscf", 
  					"wynyard"=> "wyny", "yagoona"=> "yagn", "yennora"=> "yenr"]

  def self.do_msg(msg_id, user_id, phone, sent_time, content, source)
  	res = parse_content(content)
  	if res[KEY_MGN]
  		# do acct @mgn function
  		# stop parse reset of codes
  		return 0
  	end
    # do @def, load defined route setting
    parse_def(user_id, res[KEY_DEF]) if res[KEY_DEF]

  	res_time = parse_time(res[KEY_TIME], sent_time)

  	res_loc = parse_loc(res[KEY_LOC])
    unless res_loc
      notify_users(user_id, msg_id, source, "Err: Unable to to find the specified locations - #{res[KEY_LOC]}")
      return nil
    end
    res_act = (res["syd"] == "act" )
    res[KEY_STAT] = res[KEY_STAT]? "\'#{res[KEY_STAT]}\'" : 'NULL'

    query_params = "('#{res_loc}', '#{res_time}',  #{res_act}, #{user_id}, #{msg_id}, #{res[KEY_STAT]});"
    est_arrivals = exec_db_prod('find_arrival_times'+query_params, true)
    if est_arrivals.first["updated_rows"] < 0
      notify_user(user_id, msg_id, source, "Err: Unable to find trains on #{res_loc}")
      return nil
    end
    exec_db_prod("notify_updates(#{user_id.to_s}, '#{est_arrivals.first["res"]}' ); ", false) if est_arrivals.first["updated_rows"] > 0

    sender_msg = res_act ? find_matches(user_id, msg_id, est_arrivals.first["res"]) : est_arrivals.first["res"]
    notify_user(user_id, msg_id, source, sender_msg)
    # return sender_msg 
  end


  def self.notify_users(user_id, ref_msg_id, source, msg)
#    sql="add_broadcast(#{user_id}, #{source}, #{ref_msg_id}, '#{msg}')"
#    exec_db_prod(sql, false)
    Broadcast.create(user_id: user_id, status: 0, source: source, ref_msg: ref_msg_id, bc_content: msg)
  end

  def self.find_matches(user_id, msg_data)
    msg_data += ' >> '
      
    # determine match_nearby or match_train
    # user.profile ???
    
    # match_train
    query_params = "(#{user_id.to_s}, #{msg_id.to_s}, 3 )"
    others = exec_db_prod('match_train_activity2'+query_params, true) 
    
#     # match_nearby
#     query_params = "(#{user_id.to_s}, #{msg_id.to_s}, 3, 3)"
#     others = exec_db_prod('match_nearby_activity2'+query_params, true)
      
    others.each{|o| msg_data += o["recipient_msg"]+'; ' }
    msg_data[0...140]
  end





  def self.parse_content(content)
    content = content.gsub(/[\n\r\t ]/,'').downcase
    return nil if (content.length < 12 || !(content=~/#{MATCH_HEADER}/))
    tmp = content[MATCH_HEADER.length..-1].split(/[@=]/)
    tmp.length%2 != 0 ? nil : Hash[*tmp]
  end

  def self.parse_def(user_id, terms)
  	# load pre-defined user route/time
  	return nil
  end

  def self.parse_loc(loc_txt)
    split_loc = loc_txt.split(/#{LOC_DELIMS}/)
    stops = split_loc.map { |x| STATIONS.values.include?(x)? x : STATIONS[x]  }.compact
    return nil if stops.size < 2
    stops = stops[0...4].push(stops.last) if stops.size > 5
    stops = stops.map{ |s| "'#{s}'" }
    exec_db_prod("find_travel_path (" + stops.fill('NULL', stops.size...5).join(",") + ");" , false)
  end

  def self.parse_time(tm_txt, sent_time)
    return sent_time + tm_txt[1..3].to_i.minutes if tm_txt=~/^\+/
    return sent_time unless tm_txt=~/^[0-2]{0,1}[0-9]:[0-5]{1}[0-9]/
    tmp_hr,tmp_min = tm_txt.split(':')
    res = Date.today + tmp_hr[0..1].to_i.hours + tmp_min[0..1].to_i.minutes
  end



  def self.exec_db_prod(prod_name_with_parm, multi_records)
    puts "exec_db_prod(#{prod_name_with_parm} , #{multi_records})" if Rails.env.development?
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    return ActiveRecord::Base.connection.select_all("call #{prod_name_with_parm}") if multi_records
    return  ActiveRecord::Base.connection.select_value( "call #{prod_name_with_parm}" )  
  end

end
