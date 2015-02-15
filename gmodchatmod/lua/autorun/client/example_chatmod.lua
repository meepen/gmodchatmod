surface.CreateFont("new_chatfont", {
	font = "Tahoma";
	weight = 800;
	shadow = true;
});

local function PaintMain(self)
	if(not chat.IsActive()) then return true; end
	surface.SetDrawColor(50,50,50,175);
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall());
	
	
	surface.SetDrawColor(50,50,50,255);
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall());
	
	return true;
end

hook.Add("ChatModInitialize", "Example", function(chtmd)
	chtmd:SetFont("new_chatfont");

	local pnl = chat.GetPanel();
	chat.Resize(ScrW() / 4 * 3, pnl:GetTall());
	pnl:SetPos(ScrW() / 8, pnl:GetTall() - 50);
	
	pnl.Paint = PaintMain;
end);