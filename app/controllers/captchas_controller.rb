class CaptchasController < ApplicationController
  skip_before_action :authenticate_request
  include SimpleCaptcha::ViewHelper
  include SimpleCaptcha::ImageHelpers

  def index
    SimpleCaptcha::SimpleCaptchaData.clear_old_data
    key = SimpleCaptcha::Utils.generate_key
    data = SimpleCaptcha::SimpleCaptchaData.create(:key => key)
    value = set_simple_captcha_data(key)
    other = {"data": data.to_json, "value": value.to_s}
    Rails.logger.debug("创建图文验证码==>>" + other.to_s)
    render json: { 
      :url => "http://#{request.host_with_port}#{simple_captcha_image_url(key)}",
    :captcha_key => key
    }
  end
end
