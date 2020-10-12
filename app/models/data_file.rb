#encoding: utf-8
class DataFile
  attr_accessor :upload
  RAILS_EXCEL_FILE="public/uploads/"

  # 保存单个文件
  def self.save_file(upload)
    if (upload.original_filename !='')
      file_name = upload.original_filename  
    else
      return "error"
    end
    file_type = file_name.split('.').last 
    new_name_file = file_name #Time.current.to_i
    new_file_name_with_type = "#{new_name_file}." + file_type
    local_uri = "#{RAILS_EXCEL_FILE}" + "#{new_name_file}"
    new_path = local_uri + "/" + new_file_name_with_type
    FileUtils.mkdir_p(local_uri)
    File.open(new_path, "wb")  do |f|  
      f.write(upload.read) 
    end
    return new_path
  end

  # 保存多个文件
  def self.save_files(uploads)
    new_paths = []
    timefolder = Time.current.to_i
    uploads.each_with_index do |upload, index|
      if (upload.original_filename !='')
        file_name = upload.original_filename  
      else
        next
      end
      #file_type = file_name.split('.').last 
      #new_file_name_with_type = "#{timefolder}." + file_type
      local_uri = "#{RAILS_EXCEL_FILE}" + "#{timefolder}"
      new_path = local_uri + "/#{index}_" + file_name
      FileUtils.mkdir_p(local_uri)
      File.open(new_path, "wb")  do |f|  
        f.write(upload.read) 
      end
      new_paths.push(new_path)
    end
    return new_paths
  end

  # 读取上传文件， 校验文件内容
  def self.vehicle_excel(new_path, department_id, user_name)
    doc = SimpleXlsxReader.open(new_path)
    sheet = doc.sheets.first
    return "模板错误" if sheet.rows[2] != [nil, "车辆名称", "车牌号码", "车牌颜色", "SIM卡号", "终端号", "终端标识", "通道数目", "音频编码", "音频码率", "对讲通道", "广播通道"]
    return "单位不存在" if Department.find_by(id: department_id).blank?
    sheet.rows[3..-1].uniq.map do | item |
      next if item[6].blank? || item[2].blank?
      device = Device.find_by(phone: item[6])
      channels = nil
      if item[7].present?
        case item[7]
        when '1'
          channels = [1]
        when '2'
          channels = [1,2]
        when '3'
          channels = [1,2,3]
        when '4'
          channels = [1,2,3,4]
        when '5'
          channels = [1,2,3,4,5]
        end
      end
      if device.blank?
        device = Device.create(department_id: department_id, phone: item[6], iccid: item[4], imei: item[5], channels: channels, user_name: user_name, audio_code: item[8], audio_rate: item[9], talkback_channel: item[10], broadcast_channel: item[11])
      else
        device.update(department_id: department_id, phone: item[6], iccid: item[4], imei: item[5], channels: channels, user_name: user_name, audio_code: item[8], audio_rate: item[9], talkback_channel: item[10], broadcast_channel: item[11])
      end

      vehicle = Vehicle.find_by(plate: item[2])
      if vehicle.blank?
        if device.vehicle.present?
          device.vehicle.destroy
        end
        vehicle = Vehicle.create(department_id: department_id, plate: item[2], name: item[1], plate_color: item[3], device_id: device.id, user_name: user_name)
      else
        if device.vehicle.present?
          if device.vehicle.id != vehicle.id
            device.vehicle.destroy
          end
        end
        vehicle.update(device_id: device.id, department_id: department_id, user_name: user_name)
      end
    end
    return "导入成功" 
  end

  # def self.organization_excel(new_path)
  #   doc = SimpleXlsxReader.open(new_path)
  #   # 0一级组织 1二级组织 2三级组织 3四级组织
  #   sheet = doc.sheets.first
  #   return "模板错误" if sheet.rows[0] != ["一级组织", "二级组织", "三级组织", "四级组织"]
  #   sheet.rows[1..-1].uniq.map do | item |
  #     next if item[0].to_s == "一级组织"
  #     arr = [item[0], item[1], item[2], item[3] ]
  #     if nil.in?(arr) && arr.uniq == [nil]
  #       return "一行没有数据"
  #     elsif nil.in?(arr) && ((arr.length - arr.index(nil)) != arr.grep(nil).length)
  #       return "组织结构不正确"
  #     else
  #       Organization.transaction do
  #         arr.compact.each_with_index do |o, i|
  #           begin
  #             o_id = Organization.find_by_name(item[i-1]).try(:id)
  #             o = Organization.find_or_create_by(name: item[i]).update(parent_id: o_id)
  #           rescue => e 
  #             Rails.logger.error("Organization_excell error: "+ e.message)
  #             return "导入失败，请重新检查数据再次导入"
  #           end
  #         end
  #       end
  #     end
  #   end
  #   return "导入成功"
  # end

end