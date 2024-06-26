-- source code

local chr = string.char
local df = function() end
local ds = decompile or decompiler
local env = (getgenv or df)() or _ENV or shared or _G
local gsbc = getscriptbytecode or get_script_bytecode
local gsh = getscripthash or get_script_hash
local gsub = string.gsub
local len = string.len
local ord = string.byte

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
	return gsub(a, '.', gsub_sb)
end

local function ss(a)
	return '\'' .. tostring(a) .. '\' (type: ' .. type(a) .. '; accurate type: ' .. typeof(a) .. ');'
end

local function yds(a)
	if type(a) ~= 'userdata' or typeof(a) ~= 'Instance' or not a:IsA('LuaSourceContainer') then return '' end
	local x, y = pcall(ds, a)
	if x then return y or '' end
	local k, l = pcall(gsh, a)
	if not k then k, l = pcall(grsh, a) end
	local gsis, ae, als, arc, ars, as = pcall(gsi, a)
	local si = gsis and ('\n\tEnabled: ' .. ss(ae) ..
		'\n\tLinked source: ' .. ss(als) ..
		'\n\tRun context: ' .. ss(arc) ..
		'\n\tRuntime source: ' .. ss(ars) ..
		'\n\tSource: ' .. ss(as)) or ''
	local m, n = pcall(gsbc, a)
	return '--[[\n\nDecrypted bytecode: ' .. sb(m and n or '') .. '\n' ..
		'Decrypted hash: ' .. (k and l or '') .. '\n' ..
		'Information:' .. si .. '\n\n' ..
		'Library (dlib), \'yds\' function.\n\n]]--\n'
end

-- logic

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
