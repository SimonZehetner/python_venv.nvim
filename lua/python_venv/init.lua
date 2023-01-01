local M = {}

M.venv_names = { ".venv", "venv", ".env", "env" }

local function file_exists(path)
	return os.rename(path, path) and true or false
end

local function build_venv_path(path)
	return path .. "/bin/python"
end

local function verfiy_venv(path)
	return file_exists(build_venv_path(path))
end

local function set_venv(path)
	if not verfiy_venv(path) then
		print("Venv at path '" .. vim.fs.normalize(path) .. "' does not exist")
		return
	end
	print("Set Venv to '" .. vim.fs.normalize(path) .. "'")
end

M.find_venv = function(path)
	if path ~= nil then
		set_venv(path)
		return
	end
	-- No path is provided -> Check the repro root first
	local root = vim.fs.normalize(vim.fn.getcwd())
	for _, name in ipairs(M.venv_names) do
		local venv_path = root .. "/" .. name
		if verfiy_venv(venv_path) then
			set_venv(venv_path)
			return
		end
	end
    -- No venv found in the repo root -> look upwards from the current open file
end

return M
