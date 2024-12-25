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
