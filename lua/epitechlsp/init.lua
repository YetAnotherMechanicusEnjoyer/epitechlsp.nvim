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

	lspconfig.epitechlsp.setup({
		on_attach = function(client, bufnr)
			vim.api.nvim_create_autocmd("BufWritePost", {
				buffer = bufnr,
				callback = function()
					-- Re-demande les diagnostics sur le buffer
					client.request(
						"textDocument/diagnostic",
						{ textDocument = { uri = vim.uri_from_bufnr(bufnr) } },
						function(err, result, ctx, config)
							if err then
								vim.notify("Erreur rechargement diagnostics : " .. err.message, vim.log.levels.ERROR)
								return
							end
							-- Envoie les diagnostics reçus (si besoin, sinon le serveur devrait le faire automatiquement)
							if result then
								vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, config)
							end
						end
					)
				end,
			})
		end,
	})

	vim.diagnostic.config({
		signs = true,
		underline = true,
		severity_sort = true,
		update_in_insert = false,
	})
end

return M
