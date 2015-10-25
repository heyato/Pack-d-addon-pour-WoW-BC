----------------------------------
-- Fubar 2.0 Plugin - Interface --
----------------------------------

if((not IsAddOnLoaded("FuBar")) or (not AceLibrary) or (not FuBar2DB)) then
	-- don't bother loading plugin data, FuBarPlugin2.0 isn't loaded successfully
	return;
end

WIM_FUBAR_TEXT = WIM_LOCALIZED_TITAN_MESSAGES.."|cffffffff"..WIM_NewMessageCount;


-- Variables
WIM_FuBarTimeElapsed = 1;

-- Load FuBar Plugin Data
WIM_FuBar = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0", "AceDB-2.0");


--Set initial values
WIM_FuBar.title = "WIM (WoW Instant Messenger)";
WIM_FuBar.category = "Chat/Communication";
WIM_FuBar.cannotDetachTooltip  = true;
--WIM_FuBar.independentProfile  = true;
WIM_FuBar.tooltipHiddenWhenEmpty  = true;

WIM_FuBar.frame = WIM_FuBar:CreateBasicPluginFrame("WIM_FuBarFrame");


WIM_FuBar.OnMenuRequest = {
    type = 'group',
    args = {
        shownew = {
            type = 'execute',
            name = "Show New Messages",
            desc = "Show all new messages.",
            func = function() WIM_ShowNewMessages(); end
        }
    }
};

WIM_FuBar:UpdateTooltip();

function WIM_FuBar:OnInitialize()
	self.hasIcon = true;
	--self.canHideText = true;
	self.cannotAttachToMinimap = true;
	local frame = self.frame;
	local icon = frame:CreateTexture("WIM_FuBarFrameIcon", "ARTWORK");
	icon:SetWidth(20);
	icon:SetHeight(20);
	icon:SetPoint("LEFT", frame, "LEFT");
	self.iconFrame = icon;
	
	local icon2 = frame:CreateTexture("WIM_FuBarFrameIconFlash", "OVERLAY");
	icon2:SetWidth(20);
	icon2:SetHeight(20);
	icon2:SetPoint("LEFT", frame, "LEFT");
	icon2:SetBlendMode("ADD");
	icon2:SetTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight");
	icon2:Hide();
	
	local text = frame:CreateFontString("WIM_FuBarFrameText", "OVERLAY");
	text:SetJustifyH("RIGHT");
	text:SetPoint("RIGHT", frame, "RIGHT", 0, 1);
	text:SetFontObject(GameFontNormal);
	self.textFrame = text;
	
	self:SetIcon(true);
	
	self.iconFrame:SetTexture("Interface\\AddOns\\WIM\\Images\\miniDisabled");
	self.frame:SetScript("OnEnter", WIM_FuBarOnEnter);
	self.frame:SetScript("OnLeave", function() WIM_Icon_ToolTip:Hide(); end);
	self.frame:SetScript("OnUpdate", function() WIM_FuBarOnUpdate(arg1); end);
	WIM_FuBar:UpdateTooltip();
	
	self:RegisterDB("WIM_FuBarDB");
	self:RegisterDefaults('profile', {
		showText = true,
		showIcon = true
	});
end

function WIM_FuBar:OnClick(button)
	-- Left button is the only button being sent so no use checking it.
	WIM_ConversationMenu:ClearAllPoints();
	WIM_ConversationMenu:Show();
	WIM_ConversationMenu:SetPoint("TOPLEFT", WIM_FuBar.frame, "BOTTOMLEFT");
	WIM_Icon_ToolTip:Hide();
end

function WIM_FuBar:OnTooltipUpdate()
	local tablet = AceLibrary("Tablet-2.0");
	if(tablet:IsRegistered(self.frame)) then
		tablet:Unregister(self.frame);
	end
end

function WIM_FuBarOnEnter()
	if(WIM_Data.showToolTips == true) then
		WIM_Icon_ToolTip:Show();
		WIM_Icon_ToolTip:ClearAllPoints();
		WIM_Icon_ToolTip:SetPoint("TOPLEFT", getglobal("WIM_FuBarFrame"), "BOTTOMLEFT", 0 , 0);
	end
end

function WIM_FuBarOnUpdate(elapsed)
	WIM_FuBarTimeElapsed = WIM_FuBarTimeElapsed + elapsed;
	while(WIM_FuBarTimeElapsed > .5) do
		local msgColor = "|cffedc300";
		local flash = getglobal("WIM_FuBarFrameIconFlash");
		if(WIM_NewMessageFlag) then
			if(flash:IsVisible()) then
				flash:Hide();
				WIM_FuBar.iconFrame:SetTexture("Interface\\AddOns\\WIM\\Images\\miniDisabled");
			else
				flash:Show();
				msgColor = "|cffffffff";
				WIM_FuBar.iconFrame:SetTexture("Interface\\AddOns\\WIM\\Images\\miniEnabled");
			end
		else
			flash:Hide();
			WIM_FuBar.iconFrame:SetTexture("Interface\\AddOns\\WIM\\Images\\miniDisabled");
		end
		WIM_FUBAR_TEXT = msgColor..WIM_LOCALIZED_TITAN_MESSAGES.."|cffffffff"..WIM_NewMessageCount;
		--WIM_FuBar.textFrame:SetText(msgColor..WIM_LOCALIZED_TITAN_MESSAGES.."|cffffffff"..WIM_NewMessageCount);
		WIM_FuBar:UpdateText();
		WIM_FuBarTimeElapsed = 0;
	end
end

function WIM_FuBar:SetFontSize(size)
	local font,_,flags = self.textFrame:GetFont()
	if font ~= nil then
		self.textFrame:SetFont(font, size)
	end
	self:UpdateText()
end

function WIM_FuBar:UpdateText()
	if (self:IsTextShown()) then 
		self:SetText(WIM_FUBAR_TEXT) 
	else 
		self:HideText()
	end
end