# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# 1525c01df014330db1494a926002bde9
user = User.create(userid: "4125654029066621", unionid: "gVBQbUItG9iSVuiP5iiLf5iSjAiEiE", mobile: "15310084880", tel: nil, workPlace: nil, isAdmin: true, isBoss: true, isLeaderInDepts: nil, isSenior: false, name: "王东华", active: true, department: [1], position: "CEO", avatar: "", ddtoken: "1525c01df014330db1494a926002bde9")
user.update(pyname: User.getPYName(user))