local M = {}

local function ensure_npm_deps(server_path)
	local node_modules = server_path .. "/node_modules"
	if vim.fn.isdirectory(node_modules) == 0 then
		vim.notify("[epitechlsp] Installing npm dependencies...", vim.log.levels.INFO)
		vim.fn.jobstart("npm install", {
			cwd = server_path,
			on_exit = function(_, code)
				if code == 0 then
					vim.notify("[epitechlsp] Dependencies installed!", vim.log.levels.INFO)
				else
					vim.notify("[epitechlsp] Failed to install deps", vim.log.levels.ERROR)
				end
			end,
		})
	end
end

function M.setup()
	local lspconfig = require("lspconfig")
	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	local plugin_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
	local server_path = plugin_path .. "../../server"
	local server_script = server_path .. "/epitechlsp.js"

	ensure_npm_deps(server_path)

	if not configs.epitechlsp then
		configs.epitechlsp = {
			default_config = {
				cmd = { "node", server_script },
				filetypes = { "c", "h", "make" },
				root_dir = util.root_pattern(".git", "."),
				name = "epitechlsp",
			},
		}
	end

	vim.api.nvim_set_hl(0, "DiagnosticCategoryLayout", { fg = "#fab387" }) -- orange
	vim.api.nvim_set_hl(0, "DiagnosticCategoryFunction", { fg = "#94e2d5" }) -- teal
	vim.api.nvim_set_hl(0, "DiagnosticCategoryHeader", { fg = "#f9e2af" }) -- yellow
	vim.api.nvim_set_hl(0, "DiagnosticCategoryVariable", { fg = "#cba6f7" }) -- purple
	vim.api.nvim_set_hl(0, "DiagnosticCategoryControl", { fg = "#89b4fa" }) -- blue
	vim.api.nvim_set_hl(0, "DiagnosticCategoryAdvanced", { fg = "#f38ba8" }) -- red
	vim.api.nvim_set_hl(0, "DiagnosticCategoryFile", { fg = "#a6e3a1" }) -- green
	vim.api.nvim_set_hl(0, "DiagnosticCategoryDefault", { fg = "#cdd6f4" }) -- default/gray

	lspconfig.epitechlsp.setup({})

	vim.diagnostic.config({
		virtual_text = {
			prefix = "■",
			format = function(diagnostic)
				local cat = diagnostic.user_data
					and diagnostic.user_data.lsp
					and diagnostic.user_data.lsp.data
					and diagnostic.user_data.lsp.data.category
				local color_map = {
					Layout = "DiagnosticCategoryLayout",
					Function = "DiagnosticCategoryFunction",
					Header = "DiagnosticCategoryHeader",
					Variable = "DiagnosticCategoryVariable",
					Control = "DiagnosticCategoryControl",
					Advanced = "DiagnosticCategoryAdvanced",
					File = "DiagnosticCategoryFile",
				}

				if cat and color_map[cat] then
					vim.api.nvim_set_hl(0, "DiagnosticVirtualText", { link = color_map[cat] })
				else
					vim.api.nvim_set_hl(0, "DiagnosticVirtualText", { link = "DiagnosticCategoryDefault" })
				end

				return diagnostic.message or ""
			end,
		},
		float = {
			source = "always",
		},
		severity_sort = true,
		signs = true,
		underline = true,
		update_in_insert = false,
	})
end

return M
