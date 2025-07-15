require("cfhl.password_manager")

vim.keymap.set("n", "<leader>r", function()
  local line = vim.api.nvim_get_current_line()
  local eq_pos = string.find(line, "=")
  if not eq_pos then
    print("No '=' found on this line.")
    return
  end

  local password = require("cfhl.password_manager").get_password()
  if not password then
    print("No password found for current file path.")
    return
  end

  local command = "go-ob-encryption generate-password -p " .. vim.fn.shellescape(password)
  local output = vim.fn.trim(vim.fn.system(command))

  if output == "" then
    print("Command returned no output")
    return
  end

  local new_line = string.sub(line, 1, eq_pos) .. output
  vim.api.nvim_set_current_line(new_line)
  print("Encrypted password inserted.")
end, { desc = "Generate encrypted password", noremap = true, silent = true })

vim.keymap.set("n", "<leader>c", function()
  local line = vim.api.nvim_get_current_line()
  local eq_pos = string.find(line, "=")

  if not eq_pos then
    print("No '=' found on this line.")
    return
  end

  local value = vim.fn.trim(string.sub(line, eq_pos + 1))

  if vim.startswith(value, "{ENC}") then
    local password = require("cfhl.password_manager").get_password()
    if not password then
      print("No password found for current path.")
      return
    end

    local decrypted = vim.fn.trim(vim.fn.system(
      "go-ob-encryption decrypt string -i " .. vim.fn.shellescape(value) .. " -p " .. vim.fn.shellescape(password)
    ))

    if decrypted == "" then
      print("Decryption failed or returned no output.")
      return
    end

    vim.fn.setreg('"', decrypted)
    vim.fn.system("clip.exe", decrypted)
    print("Decrypted value copied to clipboard.")

  else
    vim.fn.setreg('"', value)
    vim.fn.system("clip.exe", value)
    print("Value copied to clipboard.")
  end
end, {
  desc = "Copy right side of '=' to Windows clipboard, decrypting if needed",
  noremap = true,
  silent = true
})

vim.keymap.set("n", "<leader>d", function()
  local line = vim.api.nvim_get_current_line()
  local eq_pos = string.find(line, "=")

  if not eq_pos then
    print("No '=' found on this line.")
    return
  end

  local encrypted = vim.fn.trim(string.sub(line, eq_pos + 1))
  if not vim.startswith(encrypted, "{ENC}") then
    print("Not an encrypted value.")
    return
  end

  local password = require("cfhl.password_manager").get_password()
  if not password then
    print("No password found for current file path.")
    return
  end

  local escaped = vim.fn.shellescape(encrypted)
  local command = "go-ob-encryption decrypt string -i " .. escaped .. " -p " .. vim.fn.shellescape(password)
  local output = vim.fn.trim(vim.fn.system(command))

  if output == "" then
    print("Command returned no output")
    return
  end

  local lines = vim.fn.split(output, "\n")
  lines[1] = string.sub(line, 1, eq_pos) .. lines[1]
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, lines)
  print("Decrypted value inserted.")
end, { desc = "Decrypt encrypted value", noremap = true, silent = true })

vim.keymap.set("n", "<leader>e", function()
  local line = vim.api.nvim_get_current_line()
  local eq_pos = string.find(line, "=")

  if not eq_pos then
    print("No '=' found on this line.")
    return
  end

  -- Get string to the left of '='
  local key_to_encrypt = vim.fn.trim(string.sub(line, 1, eq_pos - 1))

  if key_to_encrypt == "" then
    print("Nothing to encrypt.")
    return
  end

  -- Get password for current path
  local password = require("cfhl.password_manager").get_password()
  if not password then
    print("No password found for current file path.")
    return
  end

  -- Run encryption command
  local escaped_key = vim.fn.shellescape(key_to_encrypt)
  local escaped_pass = vim.fn.shellescape(password)
  local cmd = "go-ob-encryption encrypt string -i " .. escaped_key .. " -p " .. escaped_pass
  local output = vim.fn.trim(vim.fn.system(cmd))

  if output == "" then
    print("Encryption command returned no output.")
    return
  end

  -- Replace the line with: key=ENCRYPTED_OUTPUT
  local new_line = key_to_encrypt .. "=" .. output
  vim.api.nvim_set_current_line(new_line)
  print("Encrypted key inserted.")
end, { desc = "Encrypt left side of '='", noremap = true, silent = true })

