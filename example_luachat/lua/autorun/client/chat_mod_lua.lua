local lua_btn;
local net_msg = "change_chat_type";

net.Receive(net_msg, function()
	chat.AddText(Color(255,140,140,255), "Lua:   ", unpack(net.ReadTable()));
end);

local time = CurTime;

hook.Add("ChatModInitialize", "AddLuaButton", function()
	timer.Simple(0, function() -- wait for resize
		lua_btn = vgui.Create("DButton", chat.GetPanel());
		local filter_btn = chat.GetFilterButton();
		lua_btn:SetText("");
		
		local onlua = false;
		
		local texts = {
			[true] = "Lua";
			[false] = "Chat";
		};
		lua_btn.lastclick = 0;
		
		function lua_btn:DoClick()
			if(time() - self.lastclick > 1) then
				onlua = not onlua;
				net.Start(net_msg);
				net.SendToServer();
			end
		end
		
		
		function lua_btn:Paint(w,h)
			local alpha_mod = chat.GetInput():GetAlpha();
			surface.SetTextColor(255,255,255,alpha_mod);
			
			surface.SetFont(filter_btn:GetFont() == "<Unknown font>" and "ChatFont" or filter_btn:GetFont());
			local tw,th = surface.GetTextSize(texts[onlua]);
			surface.SetTextPos(w/2 - tw/2, h/2 - th/2);
			surface.DrawText(texts[onlua]);
			
			surface.SetDrawColor(180,180,180,alpha_mod);
			surface.DrawLine(0, 0, w -1, 0);
			surface.DrawLine(0, 0, 0,  h-1);
			surface.SetDrawColor(40,40,40,alpha_mod);
			surface.DrawLine(w-1, 0, w-1, h-1);
			surface.DrawLine(0, h-1, w-1, h-1);
			return true;
		end
		
		lua_btn:SetSize(filter_btn:GetSize());
		
		lua_btn:SetFont(filter_btn:GetFont());
		local x,y = filter_btn:GetPos();
		lua_btn:SetPos(x - lua_btn:GetWide() - 5, y+1);
	end);
end);