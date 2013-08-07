# == Schema Information
#
# Table name: activities
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  status      :integer
#  message_id  :integer
#  msg_comment :string(255)
#  train_no    :string(255)
#  line        :integer
#  dir         :integer
#  s_stop      :integer
#  e_stop      :integer
#  final_stop  :string(255)
#  s_time      :datetime
#  e_time      :datetime
#  expiry      :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Activity < ActiveRecord::Base
  attr_accessible :message_id, :status, :user_id, :msg_comment, :expiry
  belongs_to	:user

  MATCH_HEADER = '!tb#'
  KEY_LOC='loc'
  KEY_TIME='time'
  KEY_DEF='def'
  KEY_MGN='mgn'
  KEY_MATE='mate'
  KEY_SUBJ='subj'
  KEY_SYD='syd'
  LOC_DELIMS='&|-|2'
  ERROR_MSG = nil

  
  STATIONS = Hash["allawah"=>"allw", "arncliffe"=>"arnc", "artarmon"=>"artm", "ashfield"=>"ashf", "auburn"=>"aubn",
  					"banksia"=>"bans", "bankstown"=>"bant", "bardwellpark"=>"barp", "belmore"=>"belm", "berala"=>"berl", "beverlyhill"=>"bevh", "bexleynorth"=>"bexn", 
  					"birrong"=>"birr", "blacktown"=>"blat", "bondijunction"=>"bonj", "burwood"=>"burw", 
  					"cabramatta"=>"cabm", "campsie"=>"cams", "canterbury"=>"canb", "carlingford"=>"carf", "carramar"=>"carm", 
  					"carlton"=>"cart", "casula"=>"casl", "central"=>"cent", "chatswood"=>"chaw", "chesterhill"=>"cheh", 
  					"circularquay"=>"cirq", "clyde"=>"clyd", "camellia"=>"cmla", "canleyvale"=>"cnlv", "concordwest"=>"conw", "croydon"=>"crod", 
  					"denistone"=>"dens", "dundas"=>"dnds", "domesticairport"=>"doma", "dulwishhill"=>"dulh", 
  					"eastwood"=>"easw", "easthill"=>"eath", "edgecliff"=>"edgc", "epping"=>"eppg", "erskineville"=>"ersv", 
  					"fairfield"=>"faif", "flemington"=>"flet", 
  					"glenfield"=>"glef", "granville"=>"grav", "greensquare"=>"gsqu", "guildford"=>"guif", 
  					"harrispark"=>"harp", "holsworthy"=>"holw", "homebush"=>"homb", "hurlstonepark"=>"hurp", "hurstville"=>"hurv", 
  					"internationalairport"=>"inta", "kingsgrove"=>"kgrv", "kingscross"=>"kinc", "kograph"=>"kogr", 
  					"lakemba"=>"lakb", "leightonfield"=>"leif", "lewisham"=>"lews", "lidcombe"=>"lidc", "liverpool"=>"livp", 
  					"macdonaldtown"=>"mact", "macquarieuniversity"=>"maqu", "martinplace"=>"marp", "marrickville"=>"marv", 
  					"mascot"=>"masc", "meadowbank"=>"meab", "merrylands"=>"merl", "milsonspoint"=>"milp", "macquariepark"=>"mqrp", "museum"=>"musm",
  					"narwee"=>"narw", "newtown"=>"newt", "northryde"=>"nryd", "northstrathfield"=>"nstf", "northsydney"=>"nsyd", "olympicpark"=>"olyp", 
  					"padstow"=>"padt", "panania"=>"pann", "parramatta"=>"parm", "pendlehill"=>"penh", "petersham"=>"pets", "punchbowl"=>"punb", 
  					"rydalmere"=>"rydm", "redfern"=>"redf", "regentsparks"=>"regp", "revesby"=>"revb", "rhodes"=>"rhod", 
  					"riverwood"=>"rivw", "rockdale"=>"rocd", "rosehill"=>"rosh", 
  					"sefton"=>"seft", "sevenhill"=>"sevh", "stjames"=>"sjam", "stleonards"=>"sleo", 
  					"stpeter"=>"spet", "stanmore"=>"stam", "strathfield"=>"strf", "summerhill"=>"sumh", "sydenham"=>"sydn", 
  					"telopea"=>"telp", "tempe"=>"temp", "toongabbie"=>"toob", "townhall"=>"towh", "turrella"=>"turl", "villawood"=>"vilw", 
  					"warwickfarm"=>"warf", "waverton"=>"wavt", "westmead"=>"wesm", 
  					"wentworthville"=>"wewv", "wileypark"=>"wilp", "wollicreek"=>"wolc", "westryde"=>"wryd", "wollstonecraft"=>"wscf", 
  					"wynyard"=>"wyny", "yagoona"=>"yagn", "yennora"=>"yenr"]

  def self.do_msg(msg_id, user_id, phone, sent_time, content, source)
  	res = parse_content(content)
    unless res
      notify_users(user_id, msg_id, source, "Err: Unable to parse message text - " + content )
      return nil
    end

  	if res[KEY_MGN] && res[KEY_MGN]=="clear"
      #clear all valid activities
      if Activity.update_all("status=1, expiry=now(), updated_at=now()", ["status=0 and user_id=? and expiry>now()", user_id] )
        pgsql_select_all("select * from notify_updates(#{user_id.to_s}, 'clear all active plans' );") \
        if notify_users(user_id, msg_id, source, 'All active plans cleared.')
      end
  		return 0
  	end

    # do #def, load defined route setting
    res = parse_def(user_id, res) if res[KEY_DEF]

    res_time = res[KEY_TIME]? parse_time(res[KEY_TIME], sent_time) : sent_time
    if res_time.in_time_zone('Sydney').hour>22 or res_time.in_time_zone('Sydney').hour<4
      notify_users(user_id, msg_id, source, 'Err: No train info after 11pm')
      return nil
    end

  	res_loc = parse_loc(res[KEY_LOC])
    unless res_loc
      notify_users(user_id, msg_id, source, "Err: Unable to to find the specified locations - #{res[KEY_LOC]}")
      return nil
    end

    res_act = (res["syd"] == "act" )
    res[KEY_SUBJ] = res[KEY_SUBJ]? "\'#{res[KEY_SUBJ]}\'" : 'NULL'
    query_params = "('#{res_loc}', '#{res_time}',  #{res_act}, #{user_id}, #{msg_id}, #{res[KEY_SUBJ]});"
    est_arrivals = pgsql_select_all("select * from find_arrival_times" + query_params)

    if est_arrivals.first["updated_rows"].to_i > 0
      pgsql_select_all("select * from notify_updates(#{user_id.to_s}, '#{est_arrivals.first["res"]}' );")
    elsif est_arrivals.first["updated_rows"].to_i < 0
      notify_users(user_id, msg_id, source, est_arrivals.first["res"] )
      return nil
    end
    if res_act
      if res[KEY_MATE]
        if res[KEY_SUBJ] == 'NULL'
          msg = " is on #{est_arrivals.first['res']}"
        else
          msg = ": #{res[KEY_SUBJ]} is on #{est_arrivals.first['res']}"
        end
        parse_mate(user_id, res[KEY_MATE]).each{ |m| notify_users(m["user_id"].to_i, msg_id, source, [m["aka"][1..-1], msg].join ) }
      end
      sender_msg = est_arrivals.first["res"] + find_matches(user_id, msg_id)
    else
      sender_msg = est_arrivals.first["res"]
    end

    notify_users(user_id, msg_id, source, sender_msg)

    return sender_msg 
  end


  def self.notify_users(user_id, ref_msg_id, source, msg)
    Broadcast.create(user_id: user_id, status: source, source: source, ref_msg: ref_msg_id, bc_content: msg)
  end

  def self.find_matches(user_id, msg_id)

    # determine matching mode and number of included users    
    pf = Profile.find_by_user_id(user_id)
    if pf.search_mode > 0
      query_params = "(#{user_id.to_s}, #{msg_id.to_s}, #{pf.search_mode.to_s}, #{pf.notify_users.to_s});"
      matched_msgs = pgsql_select_all("select * from match_nearby_activity" + query_params)
    else
      # match same train only
      query_params = "(#{user_id.to_s},#{msg_id.to_s}, #{pf.notify_users.to_s});"
      matched_msgs = pgsql_select_all("select * from match_train_activity" + query_params)
    end

    msg_data = matched_msgs.size>0? matched_msgs.map(&:values).join : ''
 
    return msg_data
  end

  def self.station_pairs
    return STATIONS
  end

  def self.parse_content(content)
    content = content.gsub(/[\n\r<>]/,'').downcase
    return nil if (content.size < 12 || !(content=~/^#{MATCH_HEADER}/))
    subj = content[/#\s*subj\s*=[a-z|\s]+(#|$|\z)/]
    tmp = content.gsub(" ",'')[MATCH_HEADER.size..-1].split(/[#=]/)
    res = tmp.size%2 != 0 ? nil : Hash[*tmp]
    # set subj to unremove spacing string
    res[KEY_SUBJ] = subj[(subj =~ /=/)+1..-1] if subj
    return res
  end
  
  def self.parse_mate(user_id, terms)
    t = terms.split(/@/).delete_if(&:empty?)
    return nil if t.size < 1
    pgsql_select_all("select * from check_mate(#{user_id}, Array['#{t.join("','")}']);")
  end

  def self.parse_def(user_id, terms)
  	# load pre-defined user route/time
    plan = Plan.find_by_user_id_and_name(user_id, terms[KEY_DEF])
  	return terms if plan.nil?
    plan.to_hash.merge(terms)
  end

  def self.parse_loc(loc_txt)
    return nil unless loc_txt
    split_loc = loc_txt.split(/#{LOC_DELIMS}/)
    stops = split_loc.map{ |x| STATIONS.values.include?(x)? x : STATIONS[x] }.compact
    #remove consective dulplicates
    stops = stops.chunk{|x| x}.map(&:first)
    return nil if stops.size < 2
    stops = stops[0...4].push(stops.last) if stops.size > 5
    stops = stops.map{ |s| "'#{s}'" }
    res = pgsql_select_all("select * from find_travel_path(" + stops.fill('NULL', stops.size...5).join(",") +  ");")
    return res.first ? res.first["find_travel_path"] : nil
  end

  def self.parse_time(tm_txt, sent_time)
    return sent_time + tm_txt[1..3].to_i.minutes if tm_txt=~/^\+/
    return sent_time unless tm_txt=~/^[0-2]{0,1}[0-9]:[0-5]{1}[0-9]/
    Date.today + tm_txt[0..1].to_i.hours + tm_txt[3..4].to_i.minutes
  end


#returns PGResult
  def self.pgsql_exec(sql)
    Rails.logger.debug sql if Rails.env.development?
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    res = ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.reconnect!
    return res
  end

# returns array
  def self.pgsql_select_all(sql)
    Rails.logger.debug sql if Rails.env.development?
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    res = ActiveRecord::Base.connection.select_all(sql)
    ActiveRecord::Base.connection.reconnect!
    return res
  end


end
