if(CHAT_MOD) then return; end
CHAT_HISTORY 		= "history";
CHAT_FILTER_BUTTON	= "filters";
CHAT_INPUT_LINE		= "input_main";
CHAT_INPUT			= "input";
CHAT_MAIN			= "main";

CHAT_MOD = {
	--[[ stores children in CHAT_MOD[value] (by name) ]]--
	children = {
		["HudChatHistory"] 		= CHAT_HISTORY;
		["ChatFiltersButton"] 	= CHAT_FILTER_BUTTON;
		["ChatInputLine"]		= CHAT_INPUT_LINE;
	};
	panels = {};
};

function CHAT_MOD:SetFont(font)
	if(not IsValid(self:Get(CHAT_INPUT))) then 
		return false;
	end
	if(not IsValid(self:Get(CHAT_FILTER_BUTTON))) then
		return false;
	end
	if(not IsValid(self:Get(CHAT_HISTORY))) then
		return false;
	end
	
	self:Get(CHAT_FILTER_BUTTON):SetFontInternal(font);
	self:Get(CHAT_INPUT):SetFontInternal(font);
	self:Get(CHAT_HISTORY):SetFontInternal(font);
	return true;
end

function CHAT_MOD:Get(name)
	return self.panels[name];
end

function CHAT_MOD:Init(chat)
	self.panels[CHAT_MAIN] = chat;
	local children = chat:GetChildren();
	local searching = self.children;
	for i = 1, #children do
		local v = children[i];
		local index = searching[v:GetName()];
		if(index) then
			self.panels[index] = v;
		end
	end
	local input_main = self.panels[CHAT_INPUT_LINE];
	if(IsValid(input_main)) then
		children = input_main:GetChildren();
		for i = 1, #children do
			if(children[i]:GetName() == "ChatInput") then
				self.panels[CHAT_INPUT] = children[i];
			end
		end
	end
	hook.Run("ChatModInitialize", self);
end

hook.Add("PlayerBindPress", "ObtainChat", function(p, bind, isdown)
	if(isdown) then
		if(bind == "messagemode" or bind == "messagemode2") then
			timer.Simple(0.2, function()
				if(not IsValid(vgui.GetKeyboardFocus())) then return; end
				CHAT_MOD:Init(vgui.GetKeyboardFocus():GetParent():GetParent());
				hook.Remove("PlayerBindPress", "ObtainChat");
			end);
		end
	end
end);

--[[
	example:
		

local old = {
};

local function setup(pnl)
	local x, y = pnl:GetPos();
	old[pnl] = old[pnl] or {
		x = x;
		y = y;
		w = pnl:GetWide();
		h = pnl:GetTall();
	};
end

local width = ScrW() / 4 * 3;
hook.Add("ChatModInitialize", "Example", function(chat)
	chat:SetFont("TargetIDSmall");
	local function background(self)
		surface.SetDrawColor(0,100,0,100);	
		surface.DrawRect(0,0,self:GetSize());
	end
	
	local main = chat:Get(CHAT_MAIN);
	local history = chat:Get(CHAT_HISTORY);
	local input = chat:Get(CHAT_INPUT);
	local input_main = chat:Get(CHAT_INPUT_LINE);
	local filters = chat:Get(CHAT_FILTER_BUTTON);
	
	setup(main);
	setup(history);
	setup(input);
	setup(input_main);
	setup(filters);
	
	local wdif = width - main:GetWide();
	
	input.Paint = background;
	history.Paint = background;
	
	local x,y = main:GetPos();
	main:SetPos(ScrW() / 2 - width / 2, y);
	local difference = width - main:GetWide();
	main:SetWide(width);
	
	history:SetWide(history:GetWide() + wdif);
	input_main:SetWide(input_main:GetWide() + wdif);
	input:SetWide(input:GetWide() + wdif);
	x,y = filters:GetPos();
	filters:SetPos(filters:GetParent():GetWide() - filters:GetWide() - 2, y);
	
	local btn = vgui.Create("DButton", chat:Get(CHAT_MAIN));
end);

hook.Add("Shutdown", "Example", function()
	for k,v in pairs(old) do
		k:SetWide(v.w);
		k:SetTall(v.h);
		k:SetPos(v.x, v.y);
	end
end);
]]--