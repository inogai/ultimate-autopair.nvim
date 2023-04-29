local default=require'ultimate-autopair.configs.default.utils'
local open_pair=require'ultimate-autopair.configs.default.utils.open_pair'
local utils=require'ultimate-autopair.utils'
local M={}
M.fn={
    check_start_pair=open_pair.check_ambiguous_start_pair,
    check_end_pair=open_pair.check_ambiguous_end_pair,
    find_end_pair=open_pair.find_corresponding_ambiguous_end_pair,
}
M.check_start_wrapper=function (m)
    return function(o)
        if o.line:sub(o.col-#m.pair+1,o.col-1)~=m.pair:sub(0,-2) then return end
        if open_pair.open_pair_ambigous(m.pair,o.line,o.col)  then return end
        return '\x1d'..m.pair:sub(-1)..m.pair..utils.moveh(#m.pair)
    end
end
M.check_end_wrapper=function (m)
    return function(o)
        if o.line:sub(o.col,o.col-1+#m.pair)~=m.pair then return end
        local opab=open_pair.open_pair_ambigous_before(m.pair,o.line,o.col)
        local opaa=open_pair.open_pair_ambigous_after(m.pair,o.line,o.col)
        if not opab or not opaa then return end
        return '\x1d'..utils.movel(#m.pair)
    end
end
M.newline_wrapper=function (m)
    return function (o)
        if not m.rule() then return end
        if o.line:sub(o.col-#m.pair,o.col-1)==m.pair and m.pair==o.line:sub(o.col,o.col+#m.pair-1) and m.conf.newline then
            return '\r<end><up><end>\r'
        end
    end
end
M.backspace_wrapper=function (m)
    return function (o)
        if not m.rule() then return end
        if o.line:sub(o.col-#m.pair-#m.pair,o.col-1-#m.pair)==m.pair and m.pair==o.line:sub(o.col-#m.pair,o.col-1) then
            if not open_pair.open_pair_ambigous(m.pair,o.line,o.col) then
                return utils.delete(#m.pair+#m.pair)
            end
        end
        if o.line:sub(o.col-#m.pair,o.col-1)==m.pair and m.pair==o.line:sub(o.col,o.col+#m.pair-1) then
            if not open_pair.open_pair_ambigous(m.pair,o.line,o.col) then
                return utils.delete(#m.pair,#m.pair)
            end
        end
    end
end
function M.init(q)
    local ms={}
    local me={}
    ms.pair=q.start_pair
    me.pair=q.end_pair
    ms.extensions=q.extensions
    me.extensions=q.extensions
    ms.conf=q.conf
    me.conf=q.conf
    ms.key=ms.pair:sub(-1)
    me.key=me.pair:sub(1,1)
    ms._type={[default.type_pair]={'pair','ambigous-start'}}
    me._type={[default.type_pair]={'pair','ambigous-end'}}
    ms.fn=M.fn
    me.fn=M.fn

    ms.check=M.check_start_wrapper(ms)
    me.check=M.check_end_wrapper(me)
    ms.newline=M.newline_wrapper(ms)
    me.newline=M.newline_wrapper(me)
    ms.backspace=M.backspace_wrapper(ms)
    me.backspace=M.backspace_wrapper(me)
    ms.rule=function () return true end
    me.rule=function () return true end
    default.init_extensions(ms,ms.extensions)
    default.init_extensions(me,me.extensions)
    local check1=ms.check
    ms.check=function(...)
        if not ms.rule() then return end
        return check1(...)
    end
    local check2=me.check
    me.check=function(...)
        if not me.rule() then return end
        return check2(...)
    end
    local m={}
    m.get_map=default.get_map_wrapper({q.cmap and 'c',q.map and 'i'},ms.key,me.key)
    m.sort=default.sort
    m.p=q.p or 10
    m.pair=q.start_pair
    m.extensions=q.extensions
    m.conf=q.conf
    m._type={[default.type_pair]={'pair','ambigous'}}
    m.fn=M.fn
    m.check=function (o)
        o.wline=o.line
        o.wcol=o.col
        if default.key_check_cmd(o,me.key,q.map,q.cmap) then
            local ret=me.check(vim.deepcopy(o))
            if ret then return ret end
        end
        if default.key_check_cmd(o,ms.key,q.map,q.cmap) then
            return ms.check(o)
        end
    end
    return m
end
return M
