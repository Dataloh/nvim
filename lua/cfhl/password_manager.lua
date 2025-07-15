-- lua/cfhl/password_manager.lua
local M = {}

-- Global session-wide table
_G._passwords = _G._passwords or {}

-- Helper to insert password into nested structure
local function insert_path(tbl, path_parts, password)
  local current = tbl
  for i, part in ipairs(path_parts) do
    if i == #path_parts then
      current[part] = { password = password }
    else
      current[part] = current[part] or {}
      current = current[part]
    end
  end
end

-- Set password for current file's directory context
function M.set_password(pass)
  local filepath = vim.fn.expand("%:p")
  local home = vim.fn.expand("~")
  local relpath = filepath:gsub("^" .. home .. "/", "")
  local path_parts = {}

  for dir in relpath:gmatch("([^/]+)/") do
    table.insert(path_parts, dir)
  end

  if #path_parts == 0 then
    print("Could not determine path context")
    return
  end

  insert_path(_G._passwords, path_parts, pass)
  print("Password set for context: " .. table.concat(path_parts, "/"))
end

-- Get password for current file path
function M.get_password()
  local file_path = vim.fn.expand("%:p:h")
  local home = vim.fn.expand("~")
  local relpath = file_path:gsub("^" .. home .. "/", "")

  local parts = {}
  for part in relpath:gmatch("[^/\\]+") do
    table.insert(parts, part)
  end

  local current = _G._passwords
  local found_password = nil

  for _, dir in ipairs(parts) do
    if type(current) ~= "table" then
      break
    end

    if current.password then
      found_password = current.password
    end

    current = current[dir]
  end

  -- Final check: maybe current itself has password
  if type(current) == "table" and current.password then
    found_password = current.password
  end

  return found_password
end

-- Optional: debug helpers
function M.print_passwords()
  print(vim.inspect(_G._passwords))
end

function M.clear_passwords()
  _G._passwords = {}
  print("Passwords cleared.")
end

-- Globally accessible for :lua use
_G.SetPassword = M.set_password

return M

