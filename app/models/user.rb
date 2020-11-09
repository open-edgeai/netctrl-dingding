class User < ApplicationRecord

  serialize :isLeaderInDepts, JSON
  serialize :department, JSON
  validates_uniqueness_of :userid

  after_initialize :default_values
  def default_values
    self.isSurfingNet ||= false
    self.isSurfingControll ||= false
    self.isExamine ||= false
  end

  def self.getDD(uriStr, parmas)
    uri = URI(uriStr)
    uri.query = URI.encode_www_form(parmas)
    response = Net::HTTP.get_response(uri)
    res = JSON.parse(response.body)
    if res['errcode'] != 0
      if res['errcode'] == 40001 || res['errcode'] == 40014
        return nil,210,"#{res['errmsg']}"
      else
        return nil,403,"#{res['errmsg']}"
      end
    end
    return res, 200, ""
  end

  def self.postDD(uriStr, data)
    uri = URI(uriStr)
    response = Net::HTTP.post_form(uri, data)
    res = JSON.parse(response.body)
    if res['errcode'] != 0
      if res['errcode'] == 40001 || res['errcode'] == 40014
        return nil,210,"#{res['errmsg']}"
      else
        return nil,403,"#{res['errmsg']}"
      end
    end
    return res, 200, ""
  end

  def self.getPYName(user)
    py = PinYin.abbr(user.name) # 简拼
    return "dd-"+py+"#{user.id}"
  end

end
