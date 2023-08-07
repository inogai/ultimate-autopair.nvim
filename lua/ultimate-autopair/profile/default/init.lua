---@class prof.def.module:core.module
---@field check core.check-fn
---@field filter core.filter-fn
---@field conf table
---@class prof.def.m.pair:prof.def.module
---@field pair string
---@field end_pair string
---@field start_pair string
---@field fn table<string,function>
---@field key string
---@field conf prof.def.conf.pair
---@field mconf prof.def.conf
---@class prof.def.m.map:prof.def.module
---@field map string|string[]
---@field cmap string|string[]
---@field iconf table
---@class prof.def.ext
---@field conf table
---@field name string
---@field m table
---@class prof.def.conf:prof.mconf
---@field map? boolean
---@field cmap? boolean
---@field pair_map? boolean
---@field pair_cmap? boolean
---@field extensions? table
---@field internal_pairs? table
---@field config_internal_pairs? table
---@field bs? prof.def.map.bs.conf
---@field cr? table --TODO: create spesific conf
---@field space? table --TODO: create spesific conf
---@field space2? table --TODO: create spesific conf
---@field fastwarp? table --TODO: create spesific conf
---@field close? table --TODO: create spesific conf
---@field [number]? prof.def.conf.pair
---@class prof.def.conf.pair
---@field [1] string
---@field [2] string
---@field p? number
---@field cmap? boolean
---@field imap? boolean
---@class prof.def.q
---@field start_pair string
---@field end_pair string
---@field p number
---@field conf prof.def.conf.pair
---@field extensions prof.def.ext[]
---@field cmap boolean
---@field map boolean
---@field mconf prof.def.conf

local default=require'ultimate-autopair.profile.default.utils'
local pair_s=require'ultimate-autopair.profile.default.pairs'
local pair_as=require'ultimate-autopair.profile.default.pairas'
local pair_ae=require'ultimate-autopair.profile.default.pairae'
local pair_e=require'ultimate-autopair.profile.default.paire'
local M={}
M.maps={
    'bs',
    'close',
    'cr',
    'fastwarp',
    {'rfastwarp','fastwarp'},
    'space',
    'space2',
}
---@param conf prof.def.conf
---@param mem core.module[]
function M.init(conf,mem)
    local ext=M.prepare_extensions(conf.extensions)
    M.init_ext(mem,conf,ext)
    M.init_pairs(mem,conf,ext,conf)
    M.init_pairs(mem,conf,ext,M.prepare_pairs(conf.internal_pairs,conf.config_internal_pairs))
    M.init_maps(mem,conf,ext)
end
---@param mem core.module[]
---@param conf prof.def.conf
---@param ext prof.def.ext[]
---@param somepairs prof.def.conf.pair[]
function M.init_pairs(mem,conf,ext,somepairs)
    for _,pair in ipairs(somepairs or {}) do
        for _,module in ipairs(M.init_pair(conf,ext,pair)) do
            table.insert(mem,module)
        end
    end
end
---@param conf prof.def.conf
---@param ext prof.def.ext[]
---@param pair prof.def.conf.pair
---@return prof.def.m.pair[]
function M.init_pair(conf,ext,pair)
    local q=M.create_q_value(conf,ext,pair)
    if q.start_pair==q.end_pair then
        return {pair_as.init(q),pair_ae.init(q)}
    end
    return {pair_s.init(q),pair_e.init(q)}
end
---@param conf prof.def.conf
---@param ext prof.def.ext[]
---@param pair prof.def.conf.pair
---@return prof.def.q
function M.create_q_value(conf,ext,pair)
    return {
        start_pair=pair[1],
        end_pair=pair[2],
        p=pair.p or conf.p or 10,
        conf=pair,
        extensions=ext,
        cmap=conf.cmap~=false and (pair.cmap or(pair.cmap~=false and conf.pair_cmap~=false)),
        map=conf.map~=false and (pair.imap or (pair.imap~=false and conf.pair_map~=false))
    }
end
---@param somepairs table
---@param configs table
---@return table
function M.prepare_pairs(somepairs,configs)
    if not configs then return somepairs end
    local newpairs=vim.deepcopy(somepairs)
    for _,config in ipairs(configs) do
        for _,pair in ipairs(newpairs) do
            if pair[1]==config[1]
                and pair[2]==config[2] then
                for k,v in pairs(config) do pair[k]=v end
                goto breakit
            end
        end
        error(('internal pair config %s,%s did not match any internal pairs'):format(config[1],config[2]))
        ::breakit::
    end
    return newpairs
end
---@param mem core.module[]
---@param conf prof.def.conf
---@param ext prof.def.ext[]
function M.init_ext(mem,conf,ext)
    for _,v in ipairs(ext) do
        for _,module in ipairs(v.m.init_module and v.m.init_module(v,conf) or {}) do
            table.insert(mem,module)
        end
    end
end
---@param mem core.module[]
---@param conf prof.def.conf
---@param ext prof.def.ext[]
function M.init_maps(mem,conf,ext)
    for _,map in ipairs(M.maps) do
        if type(map)=='string' then
            M.init_map(map,mem,conf[map],conf,ext)
        else
            M.init_map(map[1],mem,conf[map[2]],conf,ext)
        end
    end
end
---@param map_name string
---@param mem core.module[]
---@param confs table
---@param mconf prof.def.conf
---@param ext prof.def.ext[]
function M.init_map(map_name,mem,confs,mconf,ext)
    if confs and not confs.multi then confs={confs} end
    for _,conf in ipairs(confs or {}) do
        local map=require('ultimate-autopair.profile.default.maps.'..map_name)
        conf=vim.tbl_extend('keep',conf,confs)
        for _,module in pairs({map.init and map.init(conf,mconf,ext) or nil}) do
            table.insert(mem,module)
        end
    end
end
---@param extension_confs table
---@return prof.def.ext[]
function M.prepare_extensions(extension_confs)
    local tbl_of_ext_opt={}
    for name,conf in pairs(extension_confs or {}) do
        if conf then
            table.insert(tbl_of_ext_opt,{name=name,conf=conf})
        end
    end
    table.sort(tbl_of_ext_opt,function (a,b) return a.conf.p<b.conf.p end)
    local ret={}
    for _,opt in ipairs(tbl_of_ext_opt) do
        table.insert(ret,{m=default.load_extension(opt.name),name=opt.name,conf=opt.conf})
    end
    return ret
end
return M
