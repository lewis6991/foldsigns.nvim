local api = vim.api
local fn = vim.fn
local M = {}

local group = 'Foldsigns'

local config = {}

local function sign_get(buf, lnum, opts)
  opts = opts or {}
  opts.group = opts.group or '*'
  local res = fn.sign_getplaced(buf, {group=opts.group, lnum=lnum})[1].signs
  if opts.exclude then
    for i, s in ipairs(res) do
      if s.group == opts.exclude then
        res[i] = nil
      end
    end
  end
  return res
end

local function sign_getdefined(name)
  return fn.sign_getdefined(name)[1]
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
  for _, p in ipairs(sign_get(buf, lnum, {group=group})) do
    fn.sign_unplace(p.group, {buffer = buf, id = p.id})
  end

  -- lnum is at the top of a folded region. See if there is a sign in the
  -- folded region. If there is place a fold sign on lnum.
  if fn.foldclosed(lnum) == lnum then
    local placed_names = {}

    for i = lnum+1, fn.foldclosedend(lnum) do
      for _, p in ipairs(sign_get(buf, i, {exclude=group})) do
        if include(p.name) and not placed_names[p.name] then
          local fold_name = 'Foldsign:'..p.name
          if not sign_getdefined(fold_name) then
            local sd = sign_getdefined(p.name)
            fn.sign_define(fold_name, {
              text   = sd.text,
              texthl = sd.texthl,
              numhl  = sd.numhl,
              linehl = sd.linehl
            })
          end
          placed_names[p.name] = true
          fn.sign_place(0, group, fold_name, buf,
            { lnum = lnum, priority = p.priority })
        end
      end
    end
  end
end

function M.setup(config0)
  config = config0 or {}
  local ns = api.nvim_create_namespace('foldsigns')
  api.nvim_set_decoration_provider(ns, {
    on_win  = on_win,
    on_line = on_line
  })
end

return M
