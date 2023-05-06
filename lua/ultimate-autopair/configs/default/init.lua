--TODO: add map configs to all pairs...
local M={}
local pair_s=require'ultimate-autopair.configs.default.pairs'
local pair_a=require'ultimate-autopair.configs.default.paira'
local pair_e=require'ultimate-autopair.configs.default.paire'
local default=require'ultimate-autopair.configs.default.utils'
local bs=require'ultimate-autopair.configs.default.maps.bs'
local cr=require'ultimate-autopair.configs.default.maps.cr'
local space=require'ultimate-autopair.configs.default.maps.space'
local fastwarp=require'ultimate-autopair.configs.default.maps.fastwarp'
function M.init_multi(q)
    if q.start_pair==q.end_pair then
        return {pair_a.init(q)}
    else
        return {pair_s.init(q),pair_e.init(q)}
    end
end
function M.init_conf(conf,mem)
    local ext=default.prepare_extensions(conf.extensions)
    M.init_pair(conf,mem,conf,ext)
    M.init_pair(conf.internal_pairs,mem,conf,ext)
    M.init_bs(conf.bs,mem,conf,ext)
    M.init_cr(conf.cr,mem,conf,ext)
    M.init_space(conf.space,mem,conf,ext)
    M.init_fastwarp(conf.fastwarp,mem,conf,ext)
end
function M.clear()
end
function M.init_bs(conf,mem,mconf,ext)
    local Ibs=bs.init(conf or {},mconf,ext)
    if Ibs then table.insert(mem,Ibs) end
end
function M.init_cr(conf,mem,mconf,_)
    local Icr=cr.init(conf or {},mconf)
    if Icr then table.insert(mem,Icr) end
end
function M.init_space(conf,mem,mconf,_)
    local Ispace=space.init(conf or {},mconf)
    if Ispace then table.insert(mem,Ispace) end
end
function M.init_fastwarp(conf,mem,mconf,_)
    local Ifastwarp,Idont=fastwarp.init(conf or {},mconf)
    if Ifastwarp then table.insert(mem,Ifastwarp) end
    if Idont then table.insert(mem,Idont) end
end
function M.init_pair(conf,mem,mconf,ext)
    for _,v in ipairs(conf or {}) do
        for _,i in ipairs(M.init_multi({
            start_pair=v[1],
            end_pair=v[2],
            p=v.p or mconf.p,
            conf=v,
            extensions=ext,
            cmap=mconf.cmap~=false and default.select_opt(v.cmap,mconf.pair_cmap,true),
            map=mconf.map~=false and default.select_opt(v.imap,mconf.pair_map,true),
        })) do
            table.insert(mem,i)
        end
    end
end
return M
