CHAT_HISTORY 		= "history";
CHAT_FILTER_BUTTON	= "filters";
CHAT_INPUT_LINE		= "input_main";
CHAT_INPUT			= "input";

CHAT_MOD = {
	--[[ stores children in CHAT_MOD[value] (by name) ]]--
	children = {
		["HudChatHistory"] 		= "history";
		["ChatFiltersButton"] 	= "filters";
		["ChatInputLine"]		= "input_main";
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
	self.chat = chat;
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
	hook.Call("ChatModInitialize", self);
end

hook.Add("PlayerBindPress", "ObtainChat", function(p, bind, isdown)
	if(bind == "messagemode") then
		timer.Simple(0, function()
			CHAT_MOD:Init(vgui.GetKeyboardFocus():GetParent():GetParent());
		end);
	end
	hook.Remove("PlayerBindPress", "ObtainChat");
end);

--[[
	example:
		
		
hook.Add("ChatModInitialize", "Example", function(chat)
	chat:SetFont("TargetIDSmall");
end);
]]--