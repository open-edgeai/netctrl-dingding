require 'bunny'

connection = Bunny.new(hostname: 'rabbitmq', username: 'edgeai',password:'p123456')
connection.start

Thread.new do
    # 通知上网用户变动 rails -- > XX
    ch_s = connection.create_channel
    $rbmq_send = ch_s.default_exchange
    # $rbmq_send = ch_s.fanout("jwk") #发送到交换机端
    # users = [{name: "laixinyi1", password: "123123", enable: true}]
    # 测试 $rbmq_send.publish(users.to_json, :routing_key => "userinfo")  to_json: 转换为json字符串

    # 接收可上网的用户信息并钉钉通知 XX --> rails
    ch_r = connection.create_channel
    $rbmq_recv = ch_r.queue('userinfo') #, exclusive: true
    Rabbitmq.recv
end

# Thread.new do
#     # 网控初始化获取用户信息
#     ch_i = connection.create_channel
#     $rbmq_getuser = ch_i.queue('getuserinfo') #, exclusive: true
#     Rabbitmq.getuserinfo
# end

