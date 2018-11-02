class ApplicationController < ActionController::Base
  protect_from_forgery
  has_mobile_fu  #Mobile_fu for mobile vs. desktop layouts

  before_filter :set_mobile_format

  def set_mobile_format
    if is_mobile_device?
      if ((action_name == 'create' || action_name == 'update') && request.method == ('POST'))
        request.format = :html
      else
        request.format = :mobile
      end
    end
  end
end
