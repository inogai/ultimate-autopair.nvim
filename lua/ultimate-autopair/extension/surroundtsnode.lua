---@class ext.surroundtsnode.pconf:prof.def.conf.pair
---@field dosuround? boolean|fun(...:prof.def.optfn):boolean?

local M = {}
local default = require 'ultimate-autopair.profile.default.utils'
local open_pair = require 'ultimate-autopair.profile.default.utils.open_pair'
local utils = require 'ultimate-autopair.utils'
local ts_utils = require 'nvim-treesitter.ts_utils'

---True if the node begins at the specified row and column.
---@param ts_node TSNode
---@param row integer a 0-based row index of the cursor
---@param col integer a 0-based column index of the cursor
---@return boolean
local function ts_node_begins_at(ts_node, row, col)
  local start_row, start_col, _, _ = ts_node:range()
  return start_row == row and start_col == col
end

---@param o core.o
---@param m prof.def.m.end_pair
function M.check(o, m)
  local pconf = m.conf
  ---@cast pconf ext.surroundtsnode.pconf
  if not default.orof(pconf.dosuround, o, m, true) then
    return
  end

  -- Get the current node
  local node = ts_utils.get_node_at_cursor()
  if not node then
    return
  end

  -- Get the current cursor position
  local r, c = unpack(vim.api.nvim_win_get_cursor(0))

  r = r - 1 -- convert from (1, 0) to (0, 0)-based

  if not ts_node_begins_at(node, r, c) then
    return
  end

  local parent = node:parent()

  -- find the topmost node that starts at the cursor position
  while parent and ts_node_begins_at(parent, r, c) do
    node = parent
    parent = parent:parent()
  end

  local start_row, start_col, end_row, end_col = node:range()
  local row_shift = end_row - start_row

  -- move down `row_shift` rows and then to the end of the node, put the end pair
  -- then move up `row_shift` rows and then to the start of the node, put the start pair
  return utils.create_act({
    { 'j', row_shift },
    { 'home' },
    { 'l', end_col },
    m.end_pair,
    { 'k', row_shift },
    { 'home' },
    { 'l', start_col },
    m.pair:sub(-1),
  })
end
---@param m prof.def.module
---@param _ prof.def.ext
function M.call(m, _)
  if not default.get_type_opt(m, { 'start' }) then
    return
  end
  ---@cast m prof.def.m.end_pair
  local check = m.check
  m.check = function(o)
    local ret = M.check(o, m)
    if ret then
      return ret
    end
    return check(o)
  end
end
return M
