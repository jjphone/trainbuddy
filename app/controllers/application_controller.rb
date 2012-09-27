class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def list_errors(err_obj)
    error_msg = ""
    err_obj.errors.full_messages.each { |m| error_msg += "<li>#{m} </li>" }
    error_msg = "#{err_obj.class.to_s} form contains #{err_obj.errors.count} error(s). <br><ul> #{error_msg} </ul>"
    return error_msg
  end

end
