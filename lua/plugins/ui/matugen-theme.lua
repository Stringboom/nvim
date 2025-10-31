-- ──────────────────────────────────────────────────────────────────────
-- matugen-theme – single-file local colorscheme plugin
-- Location: ~/.config/nvim/lua/plugins/ui/matugen-theme.lua
-- Loaded by lazy.nvim via `import = "plugins"`
-- ──────────────────────────────────────────────────────────────────────

local M = {}

-- =====================================================================
-- 1. Default colors (fallback)
-- =====================================================================
local default_colors = {
	bg = "#1a120d",
	fg = "#f0dfd7",
	accent = "#ffb68a",
	accent_variant = "#6f3810",
	error = "#ffb4ab",
	success = "#e5bfa9",
	warning = "#cbc992",
}

-- =====================================================================
-- 2. Helper: brighten/darken hex color
-- =====================================================================
local function adjust(hex, factor)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	r = math.min(255, math.max(0, math.floor(r * factor)))
	g = math.min(255, math.max(0, math.floor(g * factor)))
	b = math.min(255, math.max(0, math.floor(b * factor)))
	return ("#%02x%02x%02x"):format(r, g, b)
end

-- =====================================================================
-- 3. Luminance helper (sRGB)
-- =====================================================================
local function lum(hex)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255

	r = r <= 0.03928 and r / 12.92 or ((r + 0.055) / 1.055) ^ 2.4
	g = g <= 0.03928 and g / 12.92 or ((g + 0.055) / 1.055) ^ 2.4
	b = b <= 0.03928 and b / 12.92 or ((b + 0.055) / 1.055) ^ 2.4

	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

-- =====================================================================
-- 4. Load external colors from ~/.config/nvim/colors/matugen.lua
-- =====================================================================
local function load_colors()
	local file = vim.fn.expand("~/.config/nvim/colors/matugen.lua")
	local colors = default_colors

	if vim.fn.filereadable(file) == 1 then
		local ok, res = pcall(dofile, file)
		if ok and type(res) == "table" then
			colors = res.colors or res
		else
			vim.notify("matugen-theme: failed to parse colors file", vim.log.levels.WARN)
		end
	end

	-- Extend palette
	return vim.tbl_extend("force", colors, {
		bg_light = adjust(colors.bg, 1.3),
		bg_lighter = adjust(colors.bg, 1.6),
		fg_dim = adjust(colors.fg, 0.7),
		accent_light = adjust(colors.accent, 1.2),
		accent_dark = adjust(colors.accent, 0.8),
		error_light = adjust(colors.error, 1.2),
		success_dark = adjust(colors.success, 0.8),
		warning_light = adjust(colors.warning, 1.2),
		purple = adjust(colors.accent, 0.9),
		blue = adjust(colors.success, 0.85),
		green = adjust(colors.success, 1.1),
		cyan = adjust(colors.warning, 0.9),
		magenta = adjust(colors.error, 0.9),
	})
end

-- =====================================================================
-- 5. Readable Visual background (contrast fix)
-- =====================================================================
local function visual_bg()
	local c = load_colors()
	local accent_lum = lum(c.accent_dark)
	local bg_lum = lum(c.bg)
	local fg_lum = lum(c.fg)

	local contrast = (math.max(fg_lum, accent_lum) + 0.05) / (math.min(fg_lum, accent_lum) + 0.05)

	if contrast >= 3.5 then
		return c.accent_dark
	end

	-- Blend accent with background
	local function blend(fg_hex, bg_hex, alpha)
		local function hex_to_rgb(h)
			h = h:gsub("#", "")
			return tonumber(h:sub(1, 2), 16), tonumber(h:sub(3, 4), 16), tonumber(h:sub(5, 6), 16)
		end

		local fr, fg, fb = hex_to_rgb(fg_hex)
		local br, bg, bb = hex_to_rgb(bg_hex)

		local r = math.floor(fr * alpha + br * (1 - alpha))
		local g = math.floor(fg * alpha + bg * (1 - alpha))
		local b = math.floor(fb * alpha + bb * (1 - alpha))

		return ("#%02x%02x%02x"):format(r, g, b)
	end

	local blend_amount = math.max(0.3, 1 - (contrast / 3.5))
	return blend(c.accent_dark, c.bg, blend_amount)
end

-- =====================================================================
-- 6. Apply full theme
-- =====================================================================
function M.apply()
	local c = load_colors()
	local vbg = visual_bg()

	vim.cmd("hi clear")
	if vim.fn.exists("syntax_on") == 1 then
		vim.cmd("syntax reset")
	end
	vim.g.colors_name = "matugen"

	-- Basic UI
	vim.cmd("hi Normal        guibg=" .. c.bg .. " guifg=" .. c.fg)
	vim.cmd("hi Visual        guibg=" .. vbg)
	vim.cmd("hi CursorLine    guibg=" .. c.bg_light)
	vim.cmd("hi Error         guifg=" .. c.error_light)
	vim.cmd("hi WarningMsg    guifg=" .. c.warning_light)
	vim.cmd("hi DiffAdd       guibg=" .. c.green)
	vim.cmd("hi LineNr        guifg=" .. c.fg_dim)
	vim.cmd("hi CursorLineNr  guifg=" .. c.accent)
	vim.cmd("hi StatusLine    guibg=" .. c.bg_lighter .. " guifg=" .. c.fg)
	vim.cmd("hi VertSplit     guifg=" .. c.accent_variant)

	-- Telescope
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = c.bg, fg = c.fg })
	vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = c.accent_dark, fg = c.fg })
	vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = c.purple })
	vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "TelescopeTitle", { fg = c.accent_light, bold = true })
	vim.api.nvim_set_hl(0, "TelescopePreviewTitle", { fg = c.green })
	vim.api.nvim_set_hl(0, "TelescopeResultsTitle", { fg = c.blue })

	-- Oil.nvim
	vim.api.nvim_set_hl(0, "OilDir", { fg = c.blue, bold = true })
	vim.api.nvim_set_hl(0, "OilFile", { fg = c.fg_dim })
	vim.api.nvim_set_hl(0, "OilLink", { fg = c.cyan, underline = true })
	vim.api.nvim_set_hl(0, "OilCreate", { fg = c.green })
	vim.api.nvim_set_hl(0, "OilDelete", { fg = c.error })
	vim.api.nvim_set_hl(0, "OilMove", { fg = c.warning_light })
	vim.api.nvim_set_hl(0, "OilBackground", { bg = c.bg })

	-- Treesitter
	vim.api.nvim_set_hl(0, "@function", { fg = c.purple })
	vim.api.nvim_set_hl(0, "@function.method", { fg = c.purple, italic = true })
	vim.api.nvim_set_hl(0, "@string", { fg = c.green })
	vim.api.nvim_set_hl(0, "@keyword", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "@type", { fg = c.blue })
	vim.api.nvim_set_hl(0, "@comment", { fg = c.fg_dim, italic = true })
	vim.api.nvim_set_hl(0, "@property", { fg = c.magenta })
	vim.api.nvim_set_hl(0, "@variable", { fg = c.fg })
	vim.api.nvim_set_hl(0, "@variable.builtin", { fg = c.accent, bold = true })
	vim.api.nvim_set_hl(0, "@constant", { fg = c.warning_light })
	vim.api.nvim_set_hl(0, "@number", { fg = c.success_dark })
	vim.api.nvim_set_hl(0, "@operator", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "@punctuation", { fg = c.fg_dim })
	vim.api.nvim_set_hl(0, "@tag", { fg = c.accent_light })
	vim.api.nvim_set_hl(0, "@tag.attribute", { fg = c.magenta })

	-- Diagnostics
	vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.error_light })
	vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.warning_light })
	vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.blue })
	vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.cyan })

	-- UI Enhancements
	vim.api.nvim_set_hl(0, "Pmenu", { bg = c.bg_lighter, fg = c.fg })
	vim.api.nvim_set_hl(0, "PmenuSel", { bg = c.accent, fg = c.bg })
	vim.api.nvim_set_hl(0, "Search", { bg = c.accent_light, fg = c.bg })
	vim.api.nvim_set_hl(0, "IncSearch", { bg = c.warning_light, fg = c.bg })
	vim.api.nvim_set_hl(0, "MatchParen", { bg = c.bg_light, fg = c.magenta, bold = true })

	-- Git
	vim.api.nvim_set_hl(0, "DiffChange", { bg = c.bg_lighter })
	vim.api.nvim_set_hl(0, "DiffText", { bg = c.accent_dark })
	vim.api.nvim_set_hl(0, "DiffDelete", { fg = c.error, bg = c.bg })
	vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = c.green })
	vim.api.nvim_set_hl(0, "GitSignsChange", { fg = c.warning_light })
	vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = c.error_light })

	-- Floats / Tabs
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = c.purple })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = c.bg, fg = c.fg })
	vim.api.nvim_set_hl(0, "NonText", { fg = c.fg_dim })
	vim.api.nvim_set_hl(0, "SpecialKey", { fg = c.cyan })
	vim.api.nvim_set_hl(0, "TabLine", { bg = c.bg_light, fg = c.fg_dim })
	vim.api.nvim_set_hl(0, "TabLineSel", { bg = c.accent, fg = c.bg })
	vim.api.nvim_set_hl(0, "TabLineFill", { bg = c.bg })
end

-- =====================================================================
-- 7. Setup: command + auto-reload
-- =====================================================================
function M.setup()
	vim.api.nvim_create_user_command("MatugenThemeApply", M.apply, {})

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = vim.fn.expand("~/.config/nvim/colors/matugen.lua"),
		callback = function()
			vim.notify("matugen-theme: colors updated", vim.log.levels.INFO)
			M.apply()
		end,
	})
end

-- =====================================================================
-- 8. Lazy.nvim plugin spec
-- =====================================================================
return {
	dir = vim.fn.stdpath("config") .. "/lua/plugins/ui",
	name = "matugen-theme",
	lazy = false,
	priority = 1000,

	config = function()
		M.setup()
		M.apply()
	end,
}
