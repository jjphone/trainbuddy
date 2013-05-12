module MicropostsHelper

  def wrap(content)
    # sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    simple_format(raw(content.split(/ /).map{ |s| wrap_long_string(s) }.join(' ')))
  end

  def all_stations
    return  { "<nil>"=>"", "allawah"=>"2allw", "allw"=>"2allw", "arnc"=>"2arnc", "arncliffe"=>"2arnc", "artarmon"=>"2artm", "artm"=>"2artm", "ashf"=>"2ashf", "ashfield"=>"2ashf", "aubn"=>"2aubn", "auburn"=>"2aubn", "banksia"=>"2bans", "bankstown"=>"2bant", "bans"=>"2bans", "bant"=>"2bant", "bardwellpark"=>"2barp", "barp"=>"2barp", "belm"=>"2belm", "belmore"=>"2belm", "berala"=>"2berl", "berl"=>"2berl", "beverlyhill"=>"2bevh", "bevh"=>"2bevh", "bexleynorth"=>"2bexn", "bexn"=>"2bexn", "birr"=>"2birr", "birrong"=>"2birr", "blacktown"=>"2blat", "blat"=>"2blat", "bondijunction"=>"2bonj", "bonj"=>"2bonj", "burw"=>"2burw", "burwood"=>"2burw", "cabm"=>"2cabm", "cabramatta"=>"2cabm", "camellia"=>"2cmla", "campsie"=>"2cams", "cams"=>"2cams", "canb"=>"2canb", "canley vale"=>"2cnlv", "canleyvale"=>"2cnlv", "canterbury"=>"2canb", "carf"=>"2carf", "carlingford"=>"2carf", "carlton"=>"2cart", "carm"=>"2carm", "carramar"=>"2carm", "cart"=>"2cart", "casl"=>"2casl", "casula"=>"2casl", "cent"=>"2cent", "central"=>"2cent", "chatswood"=>"2chaw", "chaw"=>"2chaw", "cheh"=>"2cheh", "chesterhill"=>"2cheh", "circular quay"=>"2cirq", "circularquay"=>"2cirq", "cirq"=>"2cirq", "clyd"=>"2clyd", "clyde"=>"2clyd", "cmla"=>"2cmla", "cnlv"=>"2cnlv", "concordwest"=>"2conw", "conw"=>"2conw", "crod"=>"2crod", "croydon"=>"2crod", "denistone"=>"2dens", "dens"=>"2dens", "dnds"=>"2dnds", "doma"=>"2doma", "domesticairport"=>"2doma", "dulh"=>"2dulh", "dulwishhill"=>"2dulh", "dundas"=>"2dnds", "easthill"=>"2eath", "eastwood"=>"2easw", "easw"=>"2easw", "eath"=>"2eath", "edgc"=>"2edgc", "edgecliff"=>"2edgc", "eppg"=>"2eppg", "epping"=>"2eppg", "erskineville"=>"2ersv", "ersv"=>"2ersv", "faif"=>"2faif", "fairfield"=>"2faif", "flemington"=>"2flet", "flet"=>"2flet", "glef"=>"2glef", "glenfield"=>"2glef", "granville"=>"2grav", "grav"=>"2grav", "greensquare"=>"2gsqu", "gsqu"=>"2gsqu", "guif"=>"2guif", "guildford"=>"2guif", "harp"=>"2harp", "harrispark"=>"2harp", "holsworthy"=>"2holw", "holw"=>"2holw", "homb"=>"2homb", "homebush"=>"2homb", "hurlstonepark"=>"2hurp", "hurp"=>"2hurp", "hurstville"=>"2hurv", "hurv"=>"2hurv", "inta"=>"2inta", "internationalairport"=>"2inta", "kgro"=>"2kgro", "kinc"=>"2kinc", "kingscross"=>"2kinc", "kingsgrove"=>"2kgro", "kogr"=>"2kogr", "kograph"=>"2kogr", "lakb"=>"2lakb", "lakemba"=>"2lakb", "leif"=>"2leif", "leightonfield"=>"2leif", "lewisham"=>"2lews", "lews"=>"2lews", "lidc"=>"2lidc", "lidcombe"=>"2lidc", "liverpool"=>"2livp", "livp"=>"2livp", "macdonaldtown"=>"2mact", "macquariepark"=>"2mqrp", "macquarieuniversity"=>"2maqu", "mact"=>"2mact", "maqu"=>"2maqu", "marp"=>"2marp", "marrickville"=>"2marv", "martinplace"=>"2marp", "marv"=>"2marv", "masc"=>"2masc", "mascot"=>"2masc", "meab"=>"2meab", "meadowbank"=>"2meab", "merl"=>"2merl", "merrylands"=>"2merl", "milp"=>"2milp", "milsonspoint"=>"2milp", "mqrp"=>"2mqrp", "museum"=>"2musm", "musm"=>"2musm", "narw"=>"2narw", "narwee"=>"2narw", "newt"=>"2newt", "newtown"=>"2newt", "northryde"=>"2nryd", "northstrathfield"=>"2nstf", "northsydney"=>"2nsyd", "nryd"=>"2nryd", "nstf"=>"2nstf", "nsyd"=>"2nsyd", "olympicpark"=>"2olyp", "olyp"=>"2olyp", "padstow"=>"2padt", "padt"=>"2padt", "panania"=>"2pann", "pann"=>"2pann", "parm"=>"2parm", "parramatta"=>"2parm", "pendlehill"=>"2penh", "penh"=>"2penh", "petersham"=>"2pets", "pets"=>"2pets", "punb"=>"2punb", "punchbowl"=>"2punb", "rdlm"=>"2rdlm", "redf"=>"2redf", "redfern"=>"2redf", "regentsparks"=>"2regp", "regp"=>"2regp", "revb"=>"2revb", "revesby"=>"2revb", "rhod"=>"2rhod", "rhodes"=>"2rhod", "riverwood"=>"2rivw", "rivw"=>"2rivw", "rocd"=>"2rocd", "rockdale"=>"2rocd", "rosehill"=>"2rosh", "rosh"=>"2rosh", "rydalmere"=>"2rydm", "seft"=>"2seft", "sefton"=>"2seft", "sevenhill"=>"2sevh", "sevh"=>"2sevh", "sjam"=>"2sjam", "sleo"=>"2sleo", "spet"=>"2spet", "st james"=>"2sjam", "stam"=>"2stam", "stanmore"=>"2stam", "stjames"=>"2sjam", "stleonards"=>"2sleo", "stpeter"=>"2spet", "strathfield"=>"2strf", "strf"=>"2strf", "sumh"=>"2sumh", "summerhill"=>"2sumh", "sydenham"=>"2sydn", "sydn"=>"2sydn", "telopea"=>"2telp", "telp"=>"2telp", "temp"=>"2temp", "tempe"=>"2temp", "toob"=>"2toob", "toongabbie"=>"2toob", "towh"=>"2towh", "town hall"=>"2towh", "townhall"=>"2towh", "turl"=>"2turl", "turrella"=>"2turl", "villawood"=>"2vilw", "vilw"=>"2vilw", "warf"=>"2warf", "warwick farm"=>"2warf", "warwickfarm"=>"2warf", "waverton"=>"2wavt", "wavt"=>"2wavt", "wentworthville"=>"2wewv", "wesm"=>"2wesm", "westmead"=>"2wesm", "westryde"=>"2wryd", "wewv"=>"2wewv", "wileypark"=>"2wilp", "wilp"=>"2wilp", "wolc"=>"2wolc", "wollicreek"=>"2wolc", "wollstonecraft"=>"2wscf", "wryd"=>"2wryd", "wscf"=>"2wscf", "wyny"=>"2wyny", "wynyard"=>"2wyny", "yagn"=>"2yagn", "yagoona"=>"2yagn", "yennora"=>"2yenr", "yenr"=>"2yenr"}
  end


  private
    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      res = (text.length < max_width) ? text : text.scan(regex).join(zero_width_space)
      res
    end

    def gen_post_links(user_id, posts_all, post_exp, path)
      if post_exp == "1"
        active_class = "btn btn-mini disabled"
        exp_class = "btn btn-mini"
      else
        active_class = "btn btn-mini"
        exp_class = "btn btn-mini disabled"
      end
      case path
      when /\/users/i
        [ link_to(  'Active only', 
                    microposts_path(u_id: user_id, posts: "#{posts_all}1", mod: "users"), 
                    {remote: true, class: active_class } ) ,
          link_to(  'incl. Expired',
                    microposts_path(u_id: user_id, posts: "#{posts_all}0", mod: "users"), 
                    {remote: true, class: exp_class } )
        ].join.html_safe
      else
        [ link_to(  'Active only', 
                    microposts_path(posts: "#{posts_all}1", mod: "pages"), 
                    {remote: true, class: active_class } ) ,
          link_to(  'incl. Expired',
                    microposts_path(posts: "#{posts_all}0", mod: "pages"), 
                    {remote: true, class: exp_class } )
        ].join.html_safe
      end
    end

    def gen_activity_link(option_data, return_url)
      return "" unless option_data
      link = URI(return_url)
      case return_url
      when /\/users\//i
        params = "mod=users&u_id=" +  link.path[/\d+$/]
      else
        if link.query && link.query[/u_id=\d+/i]
          params = "mod=users&u_id=" + link.query[/u_id=\d+/i][5..-1]
        else
          params = "mod=feeds"
        end
      end
      link.query = link.query ? params + "&" + link.query : params
      option_data.split("-").map { |stop| 
        if stop=~/:/
          data = stop.split(/@|:/)
          link.path = activity_path(data[2])
          %Q{#{data[0]} - (#{ link_to("stops ", link.to_s, class:"line#{data[1]}", remote: true ) })-> }
        else
          stop
        end
      }.join.html_safe
    end



end