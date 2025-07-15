local M = {}

local password_cache = nil

local function load_password_file()
  local json_path = vim.fn.expand("~/.config/nvim/password.json")
  local file = io.open(json_path, "r")
  if not file then return {} end
  local content = file:read("*a")
  file:close()
  local ok, decoded = pcall(vim.fn.json_decode, content)
  return ok and decoded or {}
end

local function get_password_from_path(path, cache)
  local parts = {}
  for part in path:gmatch("[^/\\]+") do
    table.insert(parts, part)
  end

  local current = cache
  local found_password = nil

  for _, dir in ipairs(parts) do
    if type(current) ~= "table" then break end
    if current["password"] then
      found_password = current["password"]
    end
    if current[dir] then
      current = current[dir]
    else
      break
    end
  end

  return found_password
end

function M.get_password()
  if not password_cache then
    password_cache = load_password_file()
  end
  local file_path = vim.fn.expand("%:p:h")
  return get_password_from_path(file_path, password_cache)
end

function M.clear_cache()
  password_cache = nil
end

return M

