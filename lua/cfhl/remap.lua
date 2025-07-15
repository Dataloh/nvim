vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set('v', '<leader>y', function()
  -- Save visual selection to temporary register
  vim.cmd('normal! "+y')
  -- Send contents of register + to Windows clipboard
  local text = vim.fn.getreg('+')
  vim.fn.system('clip.exe', text)
end, { desc = "Yank to Windows clipboard", noremap = true, silent = true })
