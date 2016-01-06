require 'image';
require 'os';
local data = require 'data'

local convert = {}

function convert.crop(src,dst,att)
    local cmd = 'convert -crop '..att.width..'x'..att.height..'+'..att.x..'+'..att.y..' '.. src ..' '..dst
    print(cmd)
    return os.execute(cmd)
end

function convert.resize(src,dst,width,height)
    local height = height or width
    local cmd = 'convert  -resize '..width..'x'..height..'! '..src..' '..dst
    print(cmd)
    return os.execute(cmd)
end

function convert.cropResize(src,dst,att,width,height)
    convert.crop(src,dst,att)
    convert.resize(dst,dst,width,height)
end

function convert.heads()
    local ann = data.readAnn() 
    local dir1 = 'data/imgs/'
    local dir2 = 'data/heads/'
    local cnt = 0
    for k,v in pairs(ann) do
        convert.cropResize(dir1..k,dir2..k,ann[k],200,200)
        cnt = cnt + 1
        print(cnt)
    end
end

return convert

