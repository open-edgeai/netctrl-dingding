class DdconfigsController < ApplicationController
  skip_before_action :authenticate_request
  before_action :set_ddconfig, only: [:show, :update, :destroy]

  # GET /ddconfigs
  # GET /ddconfigs.json
  def index
    # @ddconfigs = Ddconfig.all
    if Ddconfig.all.size == 0
      render json: {message: "还未配置"}, status: 200 and return
    else
      @ddconfig = Ddconfig.first
      render :show, status: :ok, location: @ddconfig
    end
  end

  # GET /ddconfigs/1
  # GET /ddconfigs/1.json
  def show
  end

  # POST /ddconfigs
  # POST /ddconfigs.json
  def create
    # 验证appkey和appsecret
    parmas = {appkey: params[:AppKey], appsecret: params[:AppSecret]}
    _, status, msg = User.getDD("https://oapi.dingtalk.com/gettoken", parmas)
    render json: {message: msg},status: 300 and return if status != 200

    if Ddconfig.first.present?
      @ddconfig = Ddconfig.first
      if @ddconfig.update(ddconfig_params)
        render :show, status: :ok, location: @ddconfig
      else
        render json: {message: "配置失败", errors: @ddconfig.errors}, status: 300 and return
      end
    else
      @ddconfig = Ddconfig.new(ddconfig_params)
      if @ddconfig.save
        render :show, status: 200, location: @ddconfig
      else
        render json: @ddconfig.errors, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /ddconfigs/1
  # PATCH/PUT /ddconfigs/1.json
  def update
    if @ddconfig.update(ddconfig_params)
      render :show, status: :ok, location: @ddconfig
    else
      render json: @ddconfig.errors, status: :unprocessable_entity
    end
  end

  # DELETE /ddconfigs/1
  # DELETE /ddconfigs/1.json
  def destroy
    @ddconfig.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ddconfig
      @ddconfig = Ddconfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ddconfig_params
      params.permit(:CorpId, :AppKey, :AppSecret, :AgentId, :RailsAddress, :ServiceAddress, :MqttAddress)
    end
end
