require 'csvigo';

local trainCsv = 'data/train.csv'
local data = {}

function data.getIdx(s)
    local date = "%d+"
    return tonumber(string.sub(s, string.find(s, date)))
end

function data.readY()
    local tbl = csvigo.load{path=trainCsv,mode='raw'}
    local whales = {}
    for i=2,#tbl do
        whales[tbl[i][2]] = true
    end
    local map = {}
    for k,v in pairs(whales) do
        table.insert(map,k)
    end
    local N = #map
    for i=1,N do
        map[map[i]] = i
    end
    tbl[1][3] = 'whaleNum'
    for i=2,#tbl do
        tbl[i][3] = map[tbl[i][2]]
    end
    return tbl,map
end



local function read_file(path)
    local file = io.open(path, "rb") -- r read mode and b binary mode
    if not file then return nil end
    local content = file:read "*a" -- *a or *all reads the whole file
    file:close()
    return content
end

function string:split(sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
end

function data.readAnn()
    local json = require 'dkjson';
    local fileContent = read_file("data/ann.json");
    local obj = json.decode (fileContent, 1, nil);
    local ret = {}
    for i=1,#obj do
        local name = obj[i].filename
        local fname = name:split('/')[4]
        local att = obj[i].annotations[1]
        ret[fname] = att
    end
    return ret
end
    
return data