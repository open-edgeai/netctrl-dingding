class UsersController < ApplicationController
  # skip_before_action :authenticate_request, only: [:surfingNet]
  before_action :set_user, only: [:show, :update, :destroy]
  
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show

  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      render :show, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.update(user_params)
      render :show, status: :ok, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
  end

  # POST /surfingNet 设置上网开关
  def surfingNet
    # 取消token验证 测试
    # @current_user = User.first

    department_ids = params[:department_ids].present? ? params[:department_ids] : []
    users = params[:users].present? ? params[:users] : []
    notuserids = params[:department_not_userids].present? ? params[:department_not_userids] : []
    notdepartmentids = params[:department_not].present? ? params[:department_not] : []
    render json: {message: "参数错误"}, status: 300 and return if (users.blank? && department_ids.blank?) || params[:enable].nil?

    isAdmin = @current_user.isAdmin
    isSurfingControll = @current_user.isSurfingControll
    ddtoken = @current_user.ddtoken
    render json: {message: "该用户无权限设置上网开关"}, status: 300 and return if !isAdmin && !isSurfingControll

    # 获取所有部门id和名字
    @departmentInfo = {}
    parmas = {access_token: ddtoken}
    res,status, msg = User.getDD("https://oapi.dingtalk.com/department/list", parmas)
    render json:{message: msg}, status: status and return if msg != ""
    res['department'].each do |department|
      @departmentInfo["#{department['id']}"] = {name: department['name'], parentid: department['parentid']}
    end

    # 获取准备设置的部门信息
    zb_department_ids = getSubPathId(department_ids, [])
    not_zb_department_ids = getSubPathId(notdepartmentids, [])
    notdepartmentids.each do |did|
      not_zb_department_ids << did
    end
    Rails.logger.debug("---------需要去掉的部门集合： #{not_zb_department_ids}----------------")
    zb_department_ids = zb_department_ids - not_zb_department_ids
    department_ids.each do |did|
      if @departmentInfo["#{did}"].present?
        zb_department_ids << did
      end
    end
    Rails.logger.debug("------待设置的部门集合:#{zb_department_ids}------------------")
    # 获取用户可控制的下属部门集合
    enable_departmentid = isAdmin ? [1] : @current_user.department
    kz_department_ids = getSubPathId(enable_departmentid, [])
    # 获取用户可控制的所有部门集合
    enable_departmentid.each do |did|
      kz_department_ids << did
    end
    Rails.logger.debug("------用户控制设置的部门集合:#{kz_department_ids}------------------")
    
    departmentids = zb_department_ids & kz_department_ids
    Rails.logger.debug("------设置的部门集合:#{departmentids}------------------")
    # 查找设置部门的所有员工
    userinfo = {}
    users.each do |user|
      if kz_department_ids.include? user[:deparment_id]
        userinfo["#{user[:userid]}"] = user[:name]
      end
    end
    Rails.logger.debug("------添加单独需设置用户:#{userinfo}------------------")
    departmentids.each do |did|
      p = {access_token: ddtoken, department_id: did}
      r, status, msg = User.getDD("https://oapi.dingtalk.com/user/simplelist", p)
      if msg == ""
        r['userlist'].each do |u|
          # 排除已添加的选择用户和在部门中排除的用户
          if !(userinfo.keys.include? u['userid']) && !(notuserids.include? u['userid'])
            userinfo["#{u['userid']}"] = u['name']
          end
        end
      else
        render json:{message: msg},status: status and return if status == 301
        Rails.logger.debug("------查询部门用户出错:#{msg}------------------")
      end
    end
    Rails.logger.debug("------用户可用控制的所有用户集合:#{userinfo}------------------")
    users = []
    userinfo.each do |userid, name|
      u = User.find_by(userid: userid)
      if u.blank?
        u = User.new
      end
      u.update(userid: userid, name: name, isSurfingNet: params[:enable], pyname: User.getPYName(u))
      users << {
        name: u.pyname,
        enable: params[:enable]
      }
    end
    # 通知网控
    Rabbitmq.send(users)
    render json: {message: "设置成功"}, status: 200
  end

  # POST /surfingControll 设置控制上网员工
  def surfingControll
    # 取消token验证 测试
    # @current_user = User.first

    isAdmin = @current_user.isAdmin
    render json: {message: "非管理员不能操作上网控制开关"}, status: 300 and return if !isAdmin 
    userids = params[:userids].present? ? params[:userids] : []
    render json: {message: "参数错误"}, status: 300 and return if userids.blank? || params[:enable].nil?
    userids.each do |userid|
      user = User.find_by(userid: userid)
      if user.blank?
        user = User.new
      end
      user.userid = userid
      user.isSurfingControll = params[:enable]
      user.save
      user.update(pyname: User.getPYName(user))
    end
    render json:{message: "设置成功"},status: :ok
  end

  # GET /departments 获取部门用户列表
  def departments
    # 取消token验证 测试
    # @current_user = User.first

    ddtoken = @current_user.ddtoken
    # 确定查询头部门
    department_id = nil
    if params[:department_id].present? 
      department_id = params[:department_id].to_i
    else
      department_id = 1
    end
    # Rails.logger.debug("--查询首部门id:#{department_id}---------------------")
    # 获取所有部门id和名字
    @departmentInfo = {}
    p = {access_token: ddtoken}
    res,status, msg = User.getDD("https://oapi.dingtalk.com/department/list", p)
    render json:{message: msg}, status: status and return if msg != ""
    res['department'].each do |department|
      @departmentInfo["#{department['id']}"] = {name: department['name'], parentid: department['parentid']}
    end

    departments = []
    # 获取当前部门信息
    Rails.logger.debug("---------@departmentInfo: #{@departmentInfo}----------")
    @departmentInfo.each do |k,v|
      parent_id = v[:parentid]
      if parent_id.to_s == department_id.to_s
        departments << {
          id: k,
          name: v[:name]
        }
      end
    end
    # 获取该部门的用户详情
    offset = params[:offset].present? ? params[:offset] : 0
    size = params[:size].present? ? params[:size] : 10
    
    p = {access_token: ddtoken, department_id: department_id, offset: offset, size: size}
    res, status, msg = User.getDD("https://oapi.dingtalk.com/user/listbypage", p)
    render json:{message: msg}, status: status and return if msg != ""
    
    users = []
    usershasMore = res['hasMore'] # 是否到底
    res['userlist'].each do |u|
      # 更新本地数据库用户
      user = User.find_by(userid: u['userid'])
      if user.blank?
        user = User.new
      end
      user.userid = u['userid']
      user.unionid = u['unionid']
      user.mobile = u['mobile']
      user.isAdmin = u['isAdmin']
      user.isBoss = u['isBoss']
      user.name = u['name']
      user.active = u['active']
      user.department = u['department']
      user.position = u['position']
      user.avatar = u['avatar']
      user.save
      user.update(pyname: User.getPYName(user))
      users << {
        userid: u['userid'],
        isLeader: u['isLeader'],
        active: u['active'],
        isAdmin: u['isAdmin'],
        avatar: u['avatar'],
        isBoss: u['isBoss'],
        name: u['name'],
        position: u['position'],
        isSurfingNet: user.isSurfingNet,
        isSurfingControll: user.isSurfingControll
      }
    end

    # 当前路径
    title = getPath(department_id, [])
    render json: {departments: departments, users: users, usershasMore: usershasMore, title: title}, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:userid, :unionid, :mobile, :tel, :workPlace, :isAdmin, :isBoss, :isLeaderInDepts, :name, :active, :department, :isSenior, :position, :avatar, :ddtoken, :isSurfingNet, :isSurfingControll, :department_id, :offset, :size, :enable, :department_ids=>[], :users=>[], :department_not_userids=>[], :department_not=>[])
    end

    # 获取所有上级部门路径
    def getPath(department_id, paths)
      paths << {
          id: department_id,
          name: @departmentInfo["#{department_id}"][:name]
      }
      if @departmentInfo["#{department_id}"][:parentid] != nil
          getPath(@departmentInfo["#{department_id}"][:parentid], paths)
      else
          return paths
      end
    end

    # 获取所有部门下级路径(不包括本身)
    def getSubPathId(department_ids, paths)
      parentid = []
      @departmentInfo.each do |k, v|
          if (department_ids.include? v[:parentid]) #|| (department_ids.include? k.to_s.to_i)
              paths << k.to_s.to_i
              parentid << k.to_s.to_i
          end
      end
      if parentid.blank?
          return paths
      else
        getSubPathId(parentid, paths)
      end
    end

end
