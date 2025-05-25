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
	local util = require("lspconfig.util")

	local plugin_path = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
	local server_path = plugin_path .. "../../server"
	local server_script = server_path .. "/epitechlsp.js"

	ensure_npm_deps(server_path)

	lspconfig.epitechlsp = {
		default_config = {
			cmd = { "node", server_script },
			filetypes = { "c", "h", "make" },
			root_dir = lspconfig.util.root_pattern(".git", "."),
			name = "epitechlsp",
		},
	}

	lspconfig.epitechlsp.setup({})

	vim.diagnostic.config({
		virtual_text = {
			format = function(diagnostic)
				local icon = "●"
				local cat = diagnostic.user_data
					and diagnostic.user_data.lsp
					and diagnostic.user_data.lsp.data
					and diagnostic.user_data.lsp.data.category

				if cat == "Layout" then
					icon = "🧱"
				elseif cat == "Functions" then
					icon = "🔧"
				elseif cat == "Header" then
					icon = "📄"
				elseif cat == "Variables" then
					icon = "🔣"
				elseif cat == "Control" then
					icon = "🎛️"
				elseif cat == "Advanced" then
					icon = "🧠"
				elseif cat == "Organization" then
					icon = "📁"
				elseif cat == "Global" then
					icon = "🌐"
				end
				return string.format("%s %s", icon, diagnostic.message)
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
