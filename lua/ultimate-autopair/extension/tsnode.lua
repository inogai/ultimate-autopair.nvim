---FI
---@class ext.tsnode.conf:prof.def.ext.conf
---@field separate string[]|fun(...:prof.def.optfn):string[]
---@class ext.tsnode.save
---@field _skip? string[]|false
---@field in_node? TSNode
---@field srow? number
---@field erow? number
---@field scol? number
---@field ecol? number
---@field in_tree? boolean
----@field prev_node_ecol? number
----@field prev_node_erow? number

local utils=require'ultimate-autopair.utils'
local default=require'ultimate-autopair.profile.default.utils'
local M={}
M.savetype={}
---@param o core.o
---@param nodetypes string[]
---@param incheck? boolean
---@return TSNode?
function M._in_tsnode(o,nodetypes,incheck)
    --TODO fix: if incheck don't for one char after node
    ---PROBLEM: there are exceptions: comment #|
    ---SULUTION: make option to add exceptions
    local ssave=o.save[M._in_tsnode] or {} o.save[M._in_tsnode]=ssave
    local save=ssave[nodetypes] or {} ssave[nodetypes]=save
    if incheck then save={} end
    local node=utils.gettsnode(o)
    if not node then return end
    if node and save[node:id()] then return unpack(save[node:id()]) end
    local ql={}
    local cache={}
    local nsave=M.get_save(o)
    for _,v in ipairs(nodetypes) do
        if not nsave._skip or not vim.tbl_contains(nsave._skip,v) then
            ql[v]=true
        end
    end
    ---https://github.com/altermo/ultimate-autopair.nvim/issues/44
    --local root=node:tree():root()
    while node:parent() and (not ql[node:type()] or (
        incheck and ({node:start()})[2]==o.col+o._coloffset(o.col,o.row)-1
        and ({node:start()})[1]==o.row+o._offset(o.row)-1)) do
    --while node~root and (not ql[node:type()] or (incheck and ({node:start()})[2]==o.col-1)) do
        save[node:id()]=cache
        node=node:parent() --[[@as TSNode]]
        --TODO fix: TSNode:id() doesn't differ between trees
        if node and save[node:id()] then cache[1]=save[node:id()][1] return unpack(save[node:id()]) end
    end
    save[node:id()]=cache
    cache[1]=node
    return node
end
---@param o core.o
---@return ext.tsnode.save
function M.get_save(o)
    local save=o.save[M.savetype]
    if not save then
        save={}
        o.save[M.savetype]=save
    end
    return save
end
---@param o core.o
---@param conf ext.tsnode.conf
---@param save ext.tsnode.save
---@param m prof.def.module
function M.set_in_node(o,conf,save,m)
    local node=M._in_tsnode(o,default.orof(conf.separate,o,m,true),true)
    if node then
        local srow,scol,erow,ecol=utils.gettsnodepos(node,o)
        save.scol=scol
        save.srow=srow
        save.ecol=ecol
        save.erow=erow
        save.in_node=node
    end
end
---@param o core.o
---@param save ext.tsnode.save
---@param conf ext.tsnode.conf
---@param m prof.def.module
---@return boolean?
function M.filter(o,save,conf,m)
    --TODO: isn't save.in_node always set?
    if save.in_node then
        if o.row<save.srow then return end
        if o.row>save.erow then return end
        if o.row==save.srow and o.col<save.scol then return end
        if o.row==save.erow and o.col>save.ecol then return end
    end
    --TODO: fix
    --if save.prev_node_ecol and ((o.col<save.prev_node_ecol and o.row==save.prev_node_erow) or o.row<save.prev_node_erow) then
        --return
    --end
    local node=M._in_tsnode(o,default.orof(conf.separate,o,m))
    local root
    if node and not save.in_node then
        local s=save[M.filter] or {} save[M.filter]=s
        if s[node:id()] then
            root=unpack(s[node:id()])
        else
            root=node
            local sa={}
            s[node:id()]=sa
            while root:parent() do
                root=root:parent() --[[@as TSNode]]
                s[root:id()]=sa
            end
            sa[1]=root
        end
    end
    ---https://github.com/altermo/ultimate-autopair.nvim/issues/44
    --if node and node~=(save.in_node or node:tree():root()) then
    if node and node~=(save.in_node or root) then
        local srow,scol,erow,ecol=utils.gettsnodepos(node,o)
        if vim.tbl_contains({'string','raw_string'},node:type()) and erow==o.row and ecol==o.col then return true end --HACK
        if vim.tbl_contains({'string','raw_string'},node:type()) and srow==o.row and scol==o.col then return true end --HACK
        --save.prev_node_ecol=ecol
        --save.prev_node_erow=erow
        return
    end
    return true
end
---@param m prof.def.module
---@param ext prof.def.ext
function M.call(m,ext)
    local check=m.check
    local conf=ext.conf
    ---@cast conf ext.tsnode.conf
    m.check=function (o)
        local save=M.get_save(o)
        M.set_in_node(o,conf,save,m)
        return check(o)
    end
    local filter=m.filter
    m.filter=function(o)
        local save=M.get_save(o)
        if save._skip==false or M.filter(o,save,conf,m) then
            return filter(o)
        end
    end
end
return M
--[[
function M._get_trees(o)
    --TODO: move to utils
    local linenr,col=o.row+o._offset(o.row)-1,o.col+o._coloffset(o.col,o.row)-1
    if not o.save[M._get_trees] then o.save[M._get_trees]={} end
    local cache=o.sav[M._get_trees]
    if cache.no_parser then return end
    if cache[tostring(linenr)..';'..tostring(col)] then
        return cache[tostring(linenr)..';'..tostring(col)]
    end
    local stat,parser=pcall(vim.treesitter.get_parser)
    if not stat then
        (cache or {}).no_parser=true
        return
    end
    local pos={linenr,col,linenr,col}
    local langs=M._langauges_for_range(parser,pos)
    return langs
end
---@overload fun(self:LanguageTree,range:Range4):LanguageTree[]
function M._langauges_for_range(self,range,_s)
    _s=_s or {}
    table.insert(_s,1,self)
    for _, child in pairs(self._children) do
        if child:contains(range) then
            return M._langauges_for_range(child,range,_s)
        end
    end
    return _s
end
--]]
