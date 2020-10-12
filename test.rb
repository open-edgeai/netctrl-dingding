@a = {"1": {name: "一级", parentid: nil}, "11": {name: "技术中心", parentid: 1}, "12": {name: "财务部", parentid: 1}, "13": {name: "采购部", parentid: 1}, "21": {name: "上海技术中心", parentid: 11}, "22": {name: "重庆技术中心", parentid: 11}}


def getPath(department_ids, paths)
    parentid = []
    @a.each do |k, v|
        if (department_ids.include? v[:parentid]) #|| (department_ids.include? k.to_s.to_i)
            paths << k.to_s.to_i
            parentid << k.to_s.to_i
        end
    end
    # puts parentid
    if parentid.empty?
        return paths
    else
        getPath(parentid, paths)
    end
end

s = getPath([1],[])
puts s