require 'net/http'
class AuthenticateUser
  prepend SimpleCommand

  def initialize(name, password)
    @name = name
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :name, :password

  def user
    user = User.find_by_name(name)
    if user.blank?
      errors.add :user_authentication, '用户未授权'
    elsif user.authenticate(password)
      return user 
    else
      errors.add :user_authentication, '密码错误'
    end
    nil
  end
end