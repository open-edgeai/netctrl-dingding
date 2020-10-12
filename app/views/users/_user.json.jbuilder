json.extract! user, :id, :userid, :unionid, :isSenior, :mobile, :tel, :workPlace, :isAdmin, :isBoss, :isLeaderInDepts, :name, :active, :department, :position, :avatar, :ddtoken, :isSurfingNet, :isSurfingControll, :created_at, :updated_at
json.url user_url(user, format: :json)
