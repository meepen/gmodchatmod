--[[
	This file is complete shit right now, I am pretty much throwing random shit
	wherever I want.. I will fix it up sometime.. maybe
]]--

local net_msg = "change_chat_type"

local PlayerRunLua;
local current_player;

local function maxn(tbl) -- replicate table.maxn which is outdated
	local ret = 0;
	for i in next, tbl do
		if(i > ret) then ret = i; end
	end
	return ret;
end

FindMetaTable"Player".SendLuaChat = function(self, tbl)
	net.Start(net_msg);
		net.WriteTable(tbl); -- lazy ok
	net.Send(self);
end

local time = CurTime;

util.AddNetworkString(net_msg);

--[[ key = players, value = table env ]]--
sv_envs = sv_envs or {};

net.Receive(net_msg, function(l,p)
	p.LastLuaChange = p.LastLuaChange or 0;
	p.LuaOn = p.LuaOn or false;
	if(time() - p.LastLuaChange < .3) then
		p:Kick("Net message overflow"); 
		return;
	end
	p.LuaOn = not p.LuaOn;
end);

local function getmetafunc(which, self, name)
	local meta = FindMetaTable(which);
	if(type(meta) == "function") then return meta(self, name); end
	if(type(meta) == "table") then return meta[name]; end
	return nil;
end

local players = {};
local rplayers = {};
chat_metas = chat_metas or {};
local metas = chat_metas;


metas.Player = {};
metas.Player.__index = metas.Player;
metas.Player.__newindex = function() end
local getself = function(fake_self) return rplayers[fake_self]; end
function metas.Player.Nick(fake_self)
	local self = getself(fake_self);
	return getmetafunc("Player", self, "Nick")(self)
end
function metas.Player.Name(fake_self)
	local self = getself(fake_self);
	return getmetafunc("Player", self, "Name")(self)
end
function metas.Player.Connect(fake_self)
	local self = current_player;
	local other = getself(fake_self);
	if(not IsValid(other)) then error("other is NULL"); end
	if(self.Connections[fake_self] == "pending") then
		other.Connections[players[self]] = "connected";
		self.Connections[fake_self] = "connected";
	elseif(not self.Connections[fake_self]) then
		other.Connections[players[self]] = "pending";
		self.Connections[fake_self] = "sent";
	end
end
function metas.Player.Send(fake_self, str)
	local self = getself(fake_self);
	if(self.Connections[players[current_player]] == "connected") then
		local p = players[current_player];
		PlayerRunLua(self, function()
			incoming(p, tostring(str or ""));
		end);
		return
	end
	error("not connected to player");
end

function metas.Player.Connection(fake_self)
	local self = getself(fake_self);
	return current_player.Connections[self] or "not connected";
end

setmetatable(rplayers, {__mode = "v"});
setmetatable(players, {__mode = "k", 
	__newindex = function(self,k,v)
		setmetatable(v, metas.Player);
		rawset(self,k,v);
	end,
});

hook.Add("PlayerInitialSpawn", "LuaChat", function(p)
	p.Connections = {};
	local env = {};
	env._G = env;
	env.next 	= next;
	env.pairs	= pairs;
	env.ipairs	= ipairs;
	function env.print(...)
		local args = {...};
		for i = 1, maxn(args) do
			args[i] = tostring(args[i]);
		end
		local toprint = table.concat(args, "\t");
		if(toprint:len() > 512) then
			toprint = toprint:sub(1,512);
		end
		toprint = {toprint};
		table.insert(toprint, 1, Color(255,255,255,255));
		p:SendLuaChat(toprint);
	end
	env.math = {};
	for k,v in next, math do
		if(k:lower() == k) then
			env.math[k] = v;
		end
	end
	env.math.randomseed = nil;
	env.string = {
		rep = function(str, amt)
			local amt = math.max(0, amt);
			if(amt == 0) then return ""; end
			assert(amt * string.len(str) < 1024,
				"string too long in rep ("..(amt * string.len(str))..")");
			return str:rep(amt);
		end;
		len = string.len;
		sub = string.sub;
		__len = string.len;
		__index = function(self,s) if(string[s]) then return string[s]; end return self:sub(s,s); end;
		byte = string.byte;
		char = string.char;
		lower = string.lower;
		upper = string.upper;
	};
	function env.incoming(p, s)
		env.receivers[p](p, s);
	end
	env.receivers = {};
	function env.onrecv(p, fn)
		env.receivers[p] = fn;
	end
	function env.players()
		local plys = player.GetAll();
		local ret = {};
		for i,v in next, plys do
			local tbl = players[v];
			if(not tbl) then
				tbl = {};
				players[v] = tbl;
				rplayers[tbl] = v;
			end
			ret[i] = tbl;
		end
		return ret;
	end
	function env.connections()
		return table.Copy(p.Connections);
	end
	function env.loadstring(str)
		assert(string.sub(str,1,4) ~= "\x1BLJ\x01",
			"cannot load incompatible lua code");
		return setfenv(CompileString(str,"loadstring"), env);
	end
	sv_envs[p] = env;
end);

function PlayerRunLua(ply, str)
	local old_ply = current_player;
	current_player = ply;
	local fn = type(str) == "function" and str or CompileString(str, "chatlua", false);
	local rets = {fn};
	if(type(fn) == "function") then
		local time = SysTime;
		setfenv(fn, sv_envs[ply]);
		local time = SysTime;
		local max_exec = 0.05;
		local begin = time();
		debug.sethook(function()
			if(time() - begin > max_exec) then
				debug.sethook();
				error("execution was too long!");
			end
		end, "", 1);


		local before = debug.getmetatable"";
		debug.setmetatable("", {__index = sv_envs[ply].string});
		local s,c = pcall(function()
			begin = time();
			rets = {fn()};
		end);
		debug.setmetatable("", before);
		
		if(not s) then
			rets = {c};
		end
		
		debug.sethook();
	end
	if(maxn(rets) > 0) then
		for i = 1, maxn(rets) do
			rets[i] = tostring(rets[i]);
		end
		table.insert(rets, 1, Color(255,255,255,255));
		ply:SendLuaChat(rets);
	end
	current_player = old_ply;
end

hook.Add("PlayerDisconnected", "LuaChat", function(p)
	sv_envs[p] = nil;
end);

hook.Add("PlayerSay", "LuaChat", function(p,s)
	p.LastLua = p.LastLua or 0;
	local islua = p.LuaOn;
	if(not islua) then
		islua = s:sub(1,5) == "~lua ";
		if(islua) then
			s = s:sub(6);
		end
	end
	if(islua) then
		if(time() - p.LastLua > 2) then
			PlayerRunLua(p,s);
		end
		return "";
	end
end);

