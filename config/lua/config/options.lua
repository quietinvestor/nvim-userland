-- Vim options - Need to be set both at the global level
-- and their default scope as per help, e.g. :h cursorline
vim.go.cursorline = true -- Highlight selected line
vim.wo.cursorline = true
vim.go.expandtab = true -- Spaces are used in indents
vim.bo.expandtab = true
vim.go.number = true -- Add line numbers
vim.wo.number = true
vim.go.shiftwidth = 4 -- Use 4 spaces for indentation
vim.bo.shiftwidth = 4
vim.go.tabstop = 4 -- Use 4 spaces when tab is pressed
vim.bo.tabstop = 4

-- Enable true colors
vim.opt.termguicolors = true

-- Sync yanks with the host clipboard
if vim.fn.executable("wl-copy") == 1 and os.getenv("WAYLAND_DISPLAY") then
	vim.g.clipboard = {
		name = "wl-clipboard",
		copy = {
			["+"] = "wl-copy --type text/plain",
			["*"] = "wl-copy --primary --type text/plain",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline --primary",
		},
		cache_enabled = 0,
	}
else
	vim.g.clipboard = "osc52"
end
vim.opt.clipboard = "unnamedplus"
