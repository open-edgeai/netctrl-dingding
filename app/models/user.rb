class User < ApplicationRecord

  serialize :isLeaderInDepts, JSON
  serialize :department, JSON
  
  after_initialize :default_values
  def default_values
    self.isSurfingNet ||= false
    self.isSurfingControll ||= false
  end

  def self.getDD(uriStr, parmas)
    uri = URI(uriStr)
    uri.query = URI.encode_www_form(parmas)
    response = Net::HTTP.get_response(uri)
    res = JSON.parse(response.body)
    if res['errcode'] != 0
      if res[''] == 40001
        return nil,301,"#{res['errmsg']}"
      else
        return nil,300,"#{res['errmsg']}"
      end
    end
    return res, 200, ""
  end

end
