surface.CreateFont("NewChatFont", {
	--[[ if this is wrong and you know it, please correct it! ]]--
	font = system.IsOSX() and "Geneva" or "Tahoma";
	
	weight = 800;
	
	size = 14;
	
	blursize = 0;
	
	antialias = true;
	shadow = true;
});


local speed = 500;

local max_y;
local min_y = ScrH();

local MAIN = {};

function MAIN:Think()
	local x, y = self:GetPos()
	
	y = math.min(min_y, math.max(max_y, y + (chat.IsOpen() and -1 or 1) * RealFrameTime() * speed));
	self:SetPos(x,y);
end

function MAIN:Paint()
	local alpha_mod = chat.GetInput():GetAlpha() / 255;
	
	surface.SetDrawColor(50,50,50,175 * alpha_mod);
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
	
	
	surface.SetDrawColor(50,50,50,255 * alpha_mod);
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall());
	
	return true;
end

hook.Add("ChatModInitialize", "Example", function(pnl)	
	chat.SetFont("NewChatFont");
	
	chat.Resize(ScrW() / 4 * 3, pnl:GetTall());
	
	pnl:SetPos(ScrW() / 8, ScrH() - pnl:GetTall() - 50);
	
	
	local x,y = pnl:GetPos();
	max_y = y;
	
	local hx, hy = chat.GetHistory():GetPos();
	y = y + hy;
	local endy = y + chat.GetHistory():GetTall();
	y = y + ScrH() - endy;
	min_y = y;
	
	for k,v in pairs(MAIN) do pnl[k] = v; end
end);