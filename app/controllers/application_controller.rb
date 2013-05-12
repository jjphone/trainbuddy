class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include BroadcastsHelper
  include RelationshipsHelper

  def list_errors(err_obj)
	error_msg = err_obj.errors.full_messages.join('</li><li>')
	return err_obj.class.to_s + " form contains #{err_obj.errors.count} error(s). <ul><li>" + error_msg + "</li></ul>"
  end

# returns array
  def pgsql_select_all(sql)
    Rails.logger.debug("---- ApplicationController : " + sql) if Rails.env.development?
    ActiveRecord::Base.connection.reconnect! unless ActiveRecord::Base.connection.active?
    res = ActiveRecord::Base.connection.select_all(sql)
    Rails.logger.debug("---- ApplicationController : " + res.to_s)
    res.size > 0 ? res :  nil
  end

  def join_params(extras, posts)
    posts ||= params[:posts]
    posts = posts ? "&posts=#{posts}" : nil
    page = params[:page]? "&page=#{params[:page]}" : nil
    friend_page =  params[:friend_page]? "&friend_page=#{params[:friend_page]}" : nil
    [extras, posts, page, friend_page].join[1..-1]
  end


end
