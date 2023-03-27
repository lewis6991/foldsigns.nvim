local api = vim.api
local fn = vim.fn
local M = {}

local ns = api.nvim_create_namespace('foldsigns')

---@class Foldsigns.Config
---@field include string[]?
---@field exclude string[]?
local config = {}

local function sign_get(buf, lnum)
  return fn.sign_getplaced(buf, { group = '*', lnum = lnum })[1].signs
end

local function on_win(_, _, buf, _, _)
  if not sign_get(buf) then
    return false
  end
end

local function include(name)
  for _, p in ipairs(config.exclude or {}) do
    if name:match(p) then
      return false
    end
  end
  if config.include then
    for _, p in ipairs(config.include) do
      if name:match(p) then
        return true
      end
    end
    return false
  end
  return true
end

local function on_line(_, _, buf, row)
  local lnum = row + 1
  api.nvim_buf_clear_namespace(buf, ns, row, row + 1)

  -- If lnum is at the top of a folded region, see if there is a sign in the
  -- folded region. If there is place a fold sign on lnum.
  if fn.foldclosed(lnum) ~= lnum then
    return
  end

  local placed_names = {} ---@type table<string,integer>

  for i = lnum + 1, fn.foldclosedend(lnum) do
    for _, p in ipairs(sign_get(buf, i)) do
      if include(p.name) and not placed_names[p.name] then
        local sd = fn.sign_getdefined(p.name)[1]
        placed_names[p.name] = api.nvim_buf_set_extmark(buf, ns, row, 0, {
          sign_text = sd.text,
          sign_hl_group = sd.texthl,
          number_hl_group  = sd.numhl,
          line_hl_group = sd.linehl,
        })
      end
    end
  end
end

--- @param config0 Foldsigns.Config
function M.setup(config0)
  config = config0 or {}
  api.nvim_set_decoration_provider(ns, {
    on_win  = on_win,
    on_line = on_line
  })
end

return M
