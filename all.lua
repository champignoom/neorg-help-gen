pcall(vim.cmd, '%s/^\\s\\+$//')

while pcall(vim.cmd, '%s/\\n\\n\\n/\\r\\r/') do end
vim.cmd('normal! gg=G')

vim.cmd('wq')

-- nvim out.norg --headless -c 'luafile all.lua'

