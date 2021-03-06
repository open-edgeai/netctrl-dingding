* 数据库

* 钉钉配置相关 ddconfig

| 域名 | 类型 | 备注 |
| :----| :---- | :---- |
|CorpId|string|企业ID|
|AppKey|string||
|AppSecret|string||
|RailsAddress|string||
|ServiceAddress|string|网控服务地址|
|MqttAddress|string||
|DDToken|string|钉钉token(新增)|
|DDTokenCreatedAt|datetime|钉钉token生成时间2小时有效(新增)|

> rabbitmq 接收到消息后发送需要钉钉token

docker-compose exec app rails g apiblueprint ddconfig CorpId AppKey AppSecret RailsAddress ServiceAddress MqttAddress
docker-compose exec app rails g migration add_DDToken_to_ddconfig DDToken
docker-compose exec app rails g migration add_DDTokenCreatedAt_to_ddconfig DDTokenCreatedAt:datetime

* 用户 user

| 域名 | 类型 | 备注 |
| :----| :---- | :---- |
|userid|string|钉钉员工在当前企业内的唯一标识|
|unionid|string|钉钉员工在当前开发者企业账号范围内的唯一标识|
|mobile|string|手机号|
|tel|string|分机号|
|workPlace|string|办公地点|
|isAdmin|boolean|是否是企业的管理员|
|isBoss|boolean|是否为企业的老板|
|isLeaderInDepts|string|在对应的部门中是否为主管：Map结构的json字符串，key是部门的id，value是人员在这个部门中是否为主管，true表示是，false表示不是|
|isSenior|boolean|是否是高管|
|name|string|成员名称|
|active|boolean|表示该用户是否激活了钉钉|
|department|string|成员所属部门id列表|
|position|string|职位信息|
|avatar|string|头像url|
|ddtoken|string|钉钉token|
|isSurfingNet|boolean|是否能上网|
|isSurfingControll|boolean|是否能控制下属上网|
|pyname|string|(新增)|

docker-compose exec app rails g apiblueprint user userid unionid mobile tel workPlace isAdmin:boolean isBoss:boolean isLeaderInDepts isSenior:boolean name active:boolean department position avatar ddtoken isSurfingNet:boolean isSurfingControll:boolean

> 保存通知rabbitmq的用户名信息
docker-compose exec app rails g migration add_pyname_to_user pyname

* rabbitmq通讯

>初始化账户信息 
查询： 网控  -->  rails  queue : userinfo
msg = {type: "getuserlist"}
应答: rails --> 网控  queue : update_userinfo
msg = {type: "userlist", list: [{name: XX, password: XX, enable: XX}],..}

>用户上网状态更改
rails --> 网控  queue : update_userinfo
msg = {type: "userlist", list: [{name: XX, password: XX, enable: XX}],..}