require 'net/http'
class AuthenticateUser
  prepend SimpleCommand

  def initialize(authcode)
    @authcode = authcode
  end

  def call
    user = userInfo
    if user.present?
      return [JsonWebToken.encode(user_id: user.id), user]
    else
      errors.add :user_authentication, '授权失败'
      return nil
    end
  end

  private

  attr_accessor :authcode

  def userInfo
    if @authcode
      # 测试
      # return Yh.find(5)
      appkey = Ddconfig.first.try(:AppKey)
      appsecret = Ddconfig.first.try(:AppSecret)
      if appkey.blank? || appsecret.blank?
        errors.add :user_authentication, "未配置appKey和AppSecret"
        return nil 
      end
      #获取 access_token
      uri = URI("https://oapi.dingtalk.com/gettoken")
      parmas = {appkey: appkey, appsecret: appsecret}
      uri.query = URI.encode_www_form(parmas)
      response = Net::HTTP.get_response(uri)
      res = JSON.parse(response.body)
      
      if res['errcode'] != 0
        errors.add :user_authentication, "#{res['errmsg']}"
        return nil
      end
      access_token = res['access_token']

      # 获取 userid
      uri = URI("https://oapi.dingtalk.com/user/getuserinfo")
      parmas = {access_token: access_token, code: @authcode}
      uri.query = URI.encode_www_form(parmas)
      response = Net::HTTP.get_response(uri)
      res = JSON.parse(response.body)
      if res['errcode'] != 0
        errors.add :user_authentication, "#{res['errmsg']}"
        return nil
      end
      userid = res['userid']

      # 获取用户详情
      uri = URI("https://oapi.dingtalk.com/user/get")
      parmas = {access_token: access_token, userid: userid}
      uri.query = URI.encode_www_form(parmas)
      response = Net::HTTP.get_response(uri)
      res = JSON.parse(response.body)
      if res['errcode'] != 0
        errors.add :user_authentication, "#{res['errmsg']}"
        return nil
      end

      # 更新本地用户信息
      user = User.find_by(userid: userid)
      if user.blank?
        user = User.new
      end
      user.userid = res['userid']
      user.unionid = res['unionid']
      user.mobile = res['mobile']
      user.tel = res['tel']
      user.workPlace = res['workPlace']
      user.isAdmin = res['isAdmin']
      user.isBoss = res['isBoss']
      user.isLeaderInDepts = res['isLeaderInDepts']
      user.name = res['name']
      user.active = res['active']
      user.department = res['department']
      user.position = res['position']
      user.avatar = res['avatar']
      user.ddtoken = access_token
      user.save
      return user
    end
    return nil
  end
end