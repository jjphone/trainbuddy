module MicropostsHelper

  def wrap(content)
    # sanitize(raw(content.split.map{ |s| wrap_long_string(s) }.join(' ')))
    simple_format(raw(content.split(/ /).map{ |s| wrap_long_string(s) }.join(' ')))
  end

  

    def wrap_long_string(text, max_width = 30)
      zero_width_space = "&#8203;"
      regex = /.{1,#{max_width}}/
      res = (text.length < max_width) ? text : 
                                  text.scan(regex).join(zero_width_space)
      res
    end

    def opt_link_to_html(opt_data)
      ajax_params = params[:u_id] ? "?mod=activity&u_id="+params[:u_id] : "?mod=activity"
      ajax_params += ("&posts=" + params[:posts]) if params[:posts]
      ajax_params += ("&page=" + params[:page]) if params[:page]

      opt_data.split("-").map { |stop| 
        if stop=~/:/
          data = stop.split(/@|:/)
          %Q{#{data[0]} - (<a class="line#{data[1]}" href="/trainbuddy/activities/#{data[2]}#{ajax_params}">stops </a>) -> }
        else
          stop
        end
      }.join
    end


end