require 'image';
require 'os';
local data = require 'data'


--use linux convert utility beacause image processing too slow in torch

local convert = {}
function convert.crop(src,dst,att)
    local cmd = 'convert -crop '..att.width..'x'..att.height..'+'..att.x..'+'..att.y..' '.. src ..' '..dst
    return os.execute(cmd)
end

function convert.resize(src,dst,width,height)
    local height = height or width
    local cmd = 'convert  -resize '..width..'x'..height..'! '..src..' '..dst
    return os.execute(cmd)
end

function convert.cropResize(src,dst,att,width,height)
    convert.crop(src,dst,att)
    convert.resize(dst,dst,width,height)
end

--create heads dataset cropping training images using annotations

function convert.heads(width,height)
    local ann = data.readAnn() 
    local dir1 = 'data/imgs/'
    local dir2 = 'data/heads/'
    local cnt = 0
    for k,v in pairs(ann) do
        convert.cropResize(dir1..k,dir2..k,ann[k],width or 200,height or 200)
        cnt = cnt + 1
        if(cnt%100==0) then print(cnt) end
    end
end

return convert

