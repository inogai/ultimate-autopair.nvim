local M={}
local utils=require'ultimate-autopair.utils'
---@param _ prof.cond.conf
---@param mem core.module[]
function M.init(_,mem)
    local m={}
    m.doc='ultimate-autopair backspace map'
    m.p=11
    m.check=function (o)
        if o.mode=='i' and vim.fn.keytrans(o.key)=='<BS>' and
            utils.getsmartft(o)=='lua' and
            ({['(),']=1,['[],']=1,['{},']=1})[o.line:sub(o.col-1,o.col+1)] then
            return utils.create_act{{'delete',1,2}}
        end
    end
    m.get_map=function (mode) if mode=='i' then return {'<bs>'} end end
    table.insert(mem,m)
end
return M
