require 'nn';

local data = require 'data'

local sub = {}

function sub.priorProb(Y)
    local N = Y:nElement()
    local cnt = {}
    for i=1,N do
        cnt[Y[i]] = (cnt[Y[i]] or 0) + 1
    end
    cnt = torch.Tensor(cnt)/N
    return cnt
end

function sub.priorProbs(Y)
    local N = Y:nElement()
    local cnt = sub.priorProb(Y)
    local K = cnt:nElement()
    local y = cnt:clone():resize(1,K):expand(N,K):clone()
    return y
end

function sub.getPriorLoss()
    local Y = data.readYTensor()
    local y = sub.priorProbs(Y)
    require 'nn'
    local ct=nn.ClassNLLCriterion()
    return ct:forward(y:log(),Y)
end

function sub.submit(counts)
    local subFile = 'data/sample_submission.csv'
    local stbl = csvigo.load{path = subFile, mode = 'raw'}
    local tbl,map = data.readY()
    local Y = data.readYTensor(tbl)
    local counts = sub.priorProb(Y)
    for n=2,#stbl do
        for i=2,#stbl[1] do
            local wid = stbl[1][i]
            stbl[n][i] = counts[map[wid]]
        end
    end
    csvigo.save{path = 'data/sub.csv', data = stbl}
end


return sub