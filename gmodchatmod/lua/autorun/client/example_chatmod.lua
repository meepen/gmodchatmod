surface.CreateFont("new_chatfont", {
	font = "Tahoma";
	weight = 800;
	shadow = true;
});

local function PaintMain(self)
	if(not chat.IsOpen()) then return true; end
	
	local alpha_mod = chat.GetInput():GetAlpha() / 255;
	
	surface.SetDrawColor(50,50,50,175 * alpha_mod);
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
	
	
	surface.SetDrawColor(50,50,50,255 * alpha_mod);
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall());
	
	return true;
end

hook.Add("ChatModInitialize", "Example", function(pnl)
	chat.SetFont("new_chatfont");
	
	chat.Resize(ScrW() / 4 * 3, pnl:GetTall());
	pnl:SetPos(ScrW() / 8, pnl:GetTall() - 50);
	
	pnl.Paint = PaintMain;
end);