function work()
	-- vim.o.shortmess = vim.o.shortmess .. 'A'
	vim.o.swapfile = false

	pcall(vim.cmd, '%s/^\\s\\+$//')

	while pcall(vim.cmd, '%s/\\n\\n\\n/\\r\\r/') do end

	vim.o.shiftwidth = 4
	vim.o.expandtab = true

	vim.cmd('normal! gg')
	local function ind(i)
		if i>vim.fn.line('$') then
			vim.cmd('wq')
			return
		end

		vim.cmd('normal! ==j')
		-- print('##', i, vim.treesitter.get_parser(buf, "norg"):language_for_range{70,11,70,11}:lang())
		-- print('##', i, vim.treesitter.get_parser(buf, "norg"):language_for_range{i,1,i,1}:lang())
		vim.fn.timer_start(1, vim.schedule_wrap(function() ind(i+1) end))
	end
	ind(1)
	-- require('neorg').modules.get_module('core.esupports.indent').reindent_range(0, vim.fn.line('.')-1, vim.fn.line('$'))

	-- vim.cmd('w')
	-- vim.fn.feedkeys(':wq' .. vim.api.nvim_replace_termcodes("<CR>", true, false, true))
	-- vim.cmd('wq') doesn't work
end

pcall(work)

-- nvim out.norg --headless -c 'luafile all.lua'
