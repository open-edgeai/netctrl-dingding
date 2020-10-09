class AuthenticationController < ApplicationController
  skip_before_action :authenticate_request
    
  def authenticate
    # # 验证码验证
    # begin
    #   unless SimpleCaptcha::Utils.verify!(params[:captcha_key], params[:captcha])
    #     render json: { error: "图文验证码有误,请核对" }, status: 200 and return
    #   end
    # rescue TypeError
    #   render json: { error: "一个图文验证码只能验证一次" }, status: 200 and return
    # end
    # 账号密码验证
    command = AuthenticateUser.call(params[:name], params[:password])
    if command.success?
      render json: { auth_token: command.result}
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end

  def version
    render json: { version: '1.1', message: "多态"}, status: 200
  end
      
end