require "bunny"

class Rabbitmq
    def self.recv
        Rails.logger.debug("Waiting for messages")
        $rbmq_recv.subscribe(block: true) do |_delivery_info, _properties, body|
            Rails.logger.debug(" Received #{body}")
            begin
                # jsonstr 转 json对象
                msg = JSON.parse(body)
                if msg['type'] == "userlist"
                    token = ""
                    ddconfig = Ddconfig.first
                    if ddconfig.present?
                        if ddconfig.DDToken.present? && ddconfig.DDTokenCreatedAt.present? && ddconfig.DDTokenCreatedAt + 7100 >= Time.current
                            # ddtoken有效
                            token = ddconfig.DDToken
                        else
                            # ddtoken已失效
                            p = {appkey: ddconfig.try(:AppKey), appsecret: ddconfig.try(:AppSecret)}
                            res, status, msg = User.getDD("https://oapi.dingtalk.com/gettoken", p)
                            if status == 200
                                token = res['access_token']
                                ddconfig.update(DDToken: token, DDTokenCreatedAt: Time.current)
                            else
                                Rails.logger.debug("rabbitmq 接收信息时获取钉钉token失败:#{msg}")
                            end
                        end
                    end
                    if token.present?
                        userinfo = msg['list']
                        userinfo.each do |user|
                            Rails.logger.debug("---准备用户#{user}------")
                            u = User.find_by(pyname: user['name'])
                            if u.present?
                                # 通知钉钉用户结果
                                content = ""
                                if user['enable']
                                    content = "上网开通\n上网地址: #{user['address']}\n用户名: #{user['name']}\n密码: #{user['password']}"
                                else
                                    content = "停止上网功能\n#{Time.current}"
                                end
                                p = {agent_id: ddconfig.try(:AgentId), userid_list: u.userid, msg: {"msgtype": "text", "text":{"content": content}}.to_json}
                                User.postDD("https://oapi.dingtalk.com/topapi/message/corpconversation/asyncsend_v2?access_token=#{token}", p)
                                Rails.logger.debug("====res: #{res}========")
                            end
                        end
                    end
                elsif msg['type'] == "getuserlist"
                    userinfo = []
                    User.all.each do |user|
                        userinfo << {
                            name: user.pyname,
                            enable: user.isSurfingNet
                        }
                    end
                    send(userinfo)
                end
                
            rescue => e
                Rails.logger.debug("rabbitmq 接收信息出错")
                Rails.logger.debug(e)
            end
        end
    end

    def self.send(users)
        msg = {type: "userlist", list: users}
        $rbmq_send.publish(msg.to_json, :routing_key => "update_userinfo")
    end

    # def self.getuserinfo
    #     $rbmq_getuser.subscribe(block: true) do |_delivery_info, _properties, body|
    #         begin
    #             Rails.logger.debug(" Received #{body} 初始化获取信息")
                
    #         rescue => e
    #             Rails.logger.debug("rabbitmq 初始化信息出错")
    #             Rails.logger.debug(e)
    #         end
    #     end
    # end
    
end