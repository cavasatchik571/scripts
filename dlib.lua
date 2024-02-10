-- variables

local chr = utf8.char
local df = function() end
local ds = decompile or decompiler or df
local env = (getgenv or df) or _ENV or shared or _G
local gsbc = getscriptbytecode or get_script_bytecode or df
local gsh = getscripthash or get_script_hash or df
local gsub = string.gsub
local len = utf8.len
local ord = utf8.codepoint

-- functions

local function grsh(a)
	return a:GetHash()
end

local function gsi(a)
	return a.Enabled, a.LinkedSource, a.RunContext, a.RuntimeSource, a.Source
end

local function gsub_sb(a)
	return '\\' .. ord(a)
end

local function sb(a)
	return gsub(a, '.', sb)
end

local function ss(a)
	return 'Value: \'' .. tostring(a) .. '\'; Type: ' .. type(a) .. '; Type (accurate): ' .. typeof(a) .. '\n'
end

local function yds(a)
	if type(a) ~= 'userdata' or typeof(a) ~= 'Instance' or not a:IsA('LuaSourceContainer') then return '' end
	local x, y = pcall(ds, a)
	if x then return y or '' end
	local k, l = pcall(gsh, a)
	if not k then k, l = pcall(grsh, a) end
	local gsis, ae, als, arc, ars, as = pcall(gsi, a)
	local si = gsis and ('\n--\tEnabled: ' .. ae ..
		'\n--\tLinked source: ' .. als ..
		'\n--\tRun context: ' ..
		'\n--\tRuntime source: ' .. ars ..
		'\n--\tSource: ' .. as) or ''
	local m, n = pcall(gsbc, a)
	return '-- Decrypted bytecode: ' .. sb(k and l or '') .. '\n\n' ..
		'-- Decrypted hash: ' .. (m and n or '') .. '\n\n' ..
		'-- Information: ' .. si .. '\n\n' ..
		'-- Library (dlib), \'yds\' function.\n'
end

-- code

env.dlib = {
	chr = chr,
	df = df,
	ds = ds,
	grsh = grsh,
	gsbc = gsbc,
	gsh = gsh,
	gsi = gsi,
	len = len,
	ord = ord,
	sb = sb,
	ss = ss,
	yds = yds
}

print('Loaded the \'dlib\' library.')
