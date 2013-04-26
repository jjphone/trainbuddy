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
    ActiveRecord::Base.connection.reconnect!
    return res
  end

end
