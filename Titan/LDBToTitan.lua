
-----------------------------------------------------------------
--   LibDataBrokerToTitan, a "bridge" module to ensure proper  -- 
--   registration and communication of LDB plugins with        --
--   Titan Panel (work in progress);                           --
--                                                             --
--   By Tristanian aka "TristTitan" (bandit@planetcnc.com)     --
--   Created and initially commited on : July 29th, 2008       --
--   Latest version: 1.8 Beta August 27th, 2008                 --
-----------------------------------------------------------------

-- Refined Ace2 table for matching addon metadata stuff

local xcategories = {
	["Action Bars"] = "Interface",
	["Auction"] = "Information",
	["Audio"] = "Interface",
	["Battlegrounds/PvP"] = "Information",
	["Buffs"] = "Information",
	["Chat/Communication"] = "Interface",
	["Druid"] = "Information",
	["Hunter"] = "Information",
	["Mage"] = "Information",
	["Paladin"] = "Information",
	["Priest"] = "Information",
	["Rogue"] = "Information",
	["Shaman"] = "Information",
	["Warlock"] = "Information",
	["Warrior"] = "Information",
	["Healer"] = "Information",
	["Tank"] = "Information",
	["Caster"] = "Information",
	["Combat"] = "Combat",
	["Compilations"] = "General",
	["Data Export"] = "General",
	["Development Tools "] = "General",
	["Guild"] = "Information",
	["Frame Modification"] = "Interface",
	["Interface Enhancements"] = "Interface",
	["Inventory"] = "Information",
	["Library"] = "General",
	["Map"] = "Interface",
	["Mail"] = "Information",
	["Miscellaneous"] = "General",
	["Misc"] = "General",
	["Quest"] = "Information",
	["Raid"] = "Information",
	["Tradeskill"] = "Profession",
	["UnitFrame"] = "Interface",
}

local _G = getfenv(0);
local LDBToTitan = CreateFrame("Frame", "LDBTitan")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local Tablet = AceLibrary("Tablet-2.0")
local LDBAttrs = {};

LDBToTitan:RegisterEvent("PLAYER_LOGIN")

-- Couple of functions to properly anchor tooltips for Titan (LDB) objects with a generic frame and function as args

function TitanLDBSetOwnerPosition(parent, anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset, frame)

 if frame:GetName() == "GameTooltip" then
 	frame:SetOwner(parent, "ANCHOR_NONE");
  -- set alpha (transparency) for the Game Tooltip
	local red, green, blue, _ = GameTooltip:GetBackdropColor();
	local red2, green2, blue2, _ = GameTooltip:GetBackdropBorderColor();
	frame:SetBackdropColor(red,green,blue,TitanPanelGetVar("TooltipTrans"));
	frame:SetBackdropBorderColor(red2,green2,blue2,TitanPanelGetVar("TooltipTrans"));
	
	-- set font size for the Game Tooltip
	if not TitanPanelGetVar("DisableTooltipFont") then
		if TitanTooltipScaleSet < 1 then
		TitanTooltipOrigScale = GameTooltip:GetScale();
		TitanTooltipScaleSet = TitanTooltipScaleSet + 1;
		end
		frame:SetScale(TitanPanelGetVar("TooltipFont"));
	end
  
 end
  frame:ClearAllPoints();
  frame:SetPoint(anchorPoint, relativeToFrame, relativePoint, xOffset, yOffset);
end



function LDBToTitan:TitanLDBSetTooltip(name, frame, func)
-- Check to see if we allow tooltips to be shown
  if not TitanPanelGetVar("ToolTipsShown") or (TitanPanelGetVar("HideTipsInCombat") and InCombatLockdown()) then
		return;
	end
	-- Set custom DO tooltip
	local button = TitanUtils_GetButton(name);
	local position = TitanPanelGetVar("Position");
	local scale = TitanPanelGetVar("Scale");	
	local offscreenX, offscreenY;
	local i = TitanPanel_GetButtonNumber(name);

	if (TitanPanelSettings.Location[i] == "Bar") then 
		if position == TITAN_PANEL_PLACE_TOP then
			TitanLDBSetOwnerPosition(button, "TOPLEFT", button:GetName(), "BOTTOMLEFT", -10, -4 * scale, frame);
			
			-- Adjust frame position if it's off the screen
			offscreenX, offscreenY = TitanUtils_GetOffscreen(frame);
			if ( offscreenX == -1 ) then
				TitanLDBSetOwnerPosition(button, "TOPLEFT", "TitanPanelBarButton", "BOTTOMLEFT", 0, 0, frame);
			elseif ( offscreenX == 1 ) then
				TitanLDBSetOwnerPosition(button, "TOPRIGHT", "TitanPanelBarButton", "BOTTOMRIGHT", 0, 0, frame);
			end
				
		else
			TitanLDBSetOwnerPosition(button, "BOTTOMLEFT", button:GetName(), "TOPLEFT", -10, 4 * scale, frame);	
			-- Adjust frame position if it's off the screen
			offscreenX, offscreenY = TitanUtils_GetOffscreen(frame);
			if ( offscreenX == -1 ) then
				TitanLDBSetOwnerPosition(button, "BOTTOMLEFT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "TOPLEFT", 0, 0, frame);
			elseif ( offscreenX == 1 ) then
				TitanLDBSetOwnerPosition(button, "BOTTOMRIGHT", "TitanPanel" .. TitanPanelSettings.Location[i] .."Button", "TOPRIGHT", 0, 0, frame);
			end
		end
	else
		TitanLDBSetOwnerPosition(button, "BOTTOMLEFT", button:GetName(), "TOPLEFT", -10, 4 * scale, frame);
		-- Adjust frame position if it's off the screen
		offscreenX, offscreenY = TitanUtils_GetOffscreen(frame);
		if ( offscreenX == -1 ) then
			TitanLDBSetOwnerPosition(button, "BOTTOMLEFT", "TitanPanelAuxBarButton", "TOPLEFT", 0, 0, frame);
		elseif ( offscreenX == 1 ) then
			TitanLDBSetOwnerPosition(button, "BOTTOMRIGHT", "TitanPanelAuxBarButton", "TOPRIGHT", 0, 0, frame);
		end
	end
	
	if func then func(frame) end;
	frame:Show();
end


-- Script Handler goes here

function LDBToTitan:TitanLDBHandleScripts(event, name, _, func, obj)
--DEFAULT_CHAT_FRAME:AddMessage("LDB:"..name..".".. event.. " is fired.")
local TitanPluginframe = getglobal("TitanPanel".."LDBT_"..name.."Button");

	if event:find("OnTooltipShow") then
	
	TitanPluginframe:SetScript("OnEnter", function(this)
		if TITAN_PANEL_MOVING == 0 and func then				
			self:TitanLDBSetTooltip("LDBT_"..name, GameTooltip, func);
		end
			TitanPanelButton_OnEnter();
		end)
	TitanPluginframe:SetScript("OnLeave", function(this) 
		GameTooltip:Hide();
		TitanPanelButton_OnLeave();
		end)
		
		
	elseif event:find("Click") then
	TitanPluginframe:SetScript("OnClick", function(this, button)
	  	if TITAN_PANEL_MOVING == 0 then
	  	func(this, button) 
	  	end
	  	TitanPanelButton_OnClick(button);
	  	end)	  
	else
	
	TitanPluginframe:SetScript("OnEnter", function(this)	
	-- Check to see if we allow tooltips to be shown
		if not TitanPanelGetVar("ToolTipsShown") or (TitanPanelGetVar("HideTipsInCombat") and InCombatLockdown()) then
		-- if a plugin is using tablet, then detach and close the tooltip
			if Tablet:IsRegistered(TitanPluginframe) and Tablet:IsAttached(TitanPluginframe) then
				Tablet:Detach(TitanPluginframe);
				Tablet:Close(TitanPluginframe);
			end
			return;
		else
		-- if a plugin is using tablet, then re-attach the tooltip (it will auto-open on mouseover)
		  if Tablet:IsRegistered(TitanPluginframe) and not Tablet:IsAttached(TitanPluginframe) then
		  	Tablet:Attach(TitanPluginframe);
		  end
		end
		-- if a plugin is using tablet then set its transparency and font size accordingly
			if Tablet:IsRegistered(TitanPluginframe) then
				Tablet:SetTransparency(TitanPluginframe, TitanPanelGetVar("TooltipTrans"))
				if not TitanPanelGetVar("DisableTooltipFont") then
					Tablet:SetFontSizePercent(TitanPluginframe, TitanPanelGetVar("TooltipFont"))
				elseif TitanPanelGetVar("DisableTooltipFont") and Tablet:GetFontSizePercent(TitanPluginframe)~=1 then
					Tablet:SetFontSizePercent(TitanPluginframe, 1)
				end
			end	
			if TITAN_PANEL_MOVING == 0 and func then
				func(this)
			end
			TitanPanelButton_OnEnter();
		end)
		TitanPluginframe:SetScript("OnLeave", function(this)
			if obj.OnLeave then 
			obj.OnLeave(this) 
			end
			TitanPanelButton_OnLeave();
		end)
	end
end


-- Text Update Handlers go here

function LDBToTitan:TitanLDBTextUpdate(_, name,  attr, value, dataobj)
  --if attr and value then
  --DEFAULT_CHAT_FRAME:AddMessage("LDB:"..name..".".. attr.. " was changed to ".. tostring(value))
  --end
  if attr == "value" then
  LDBAttrs[name].value = value;
  end
  if attr == "suffix" then
  LDBAttrs[name].suffix = value;
  end
  if attr == "text" then
  LDBAttrs[name].text = value;
  end
  TitanPanelButton_UpdateButton("LDBT_"..name)
end


function TitanLDBShowText(name)
  local nametrim = string.gsub (name, "LDBT_", "");
  
  local fontstring = _G["TitanPanelLDBT_"..nametrim.."ButtonText"];
  
  -- Fix color text issues
  if TitanGetVar(name, "ShowColoredText") then
	 	fontstring:SetTextColor(0,255,0); -- Green
	 else
	  fontstring:SetTextColor(255,255,255); -- Highlight
	 end
  
   if LDBAttrs[nametrim].suffix and LDBAttrs[nametrim].suffix ~="" then
   	if LDBAttrs[nametrim].label~="" then
   			if TitanGetVar(name, "ShowColoredText") then
   			return TitanUtils_GetNormalText(LDBAttrs[nametrim].label)..": ", TitanUtils_GetGreenText(LDBAttrs[nametrim].value.." "..LDBAttrs[nametrim].suffix);
   			else
   			return TitanUtils_GetNormalText(LDBAttrs[nametrim].label)..": ", TitanUtils_GetHighlightText(LDBAttrs[nametrim].value.." "..LDBAttrs[nametrim].suffix);
   			end
   	else
   			if TitanGetVar(name, "ShowColoredText") then
   			return TitanUtils_GetGreenText(LDBAttrs[nametrim].value.." "..LDBAttrs[nametrim].suffix);
   			else
   			return TitanUtils_GetHighlightText(LDBAttrs[nametrim].value.." "..LDBAttrs[nametrim].suffix);
   			end
   	end
   elseif LDBAttrs[nametrim].label == LDBAttrs[nametrim].text then
   			if TitanGetVar(name, "ShowColoredText") then
   			return TitanUtils_GetGreenText(LDBAttrs[nametrim].text);
   			else
   			return TitanUtils_GetNormalText(LDBAttrs[nametrim].text);
   			end
   else
    if LDBAttrs[nametrim].label~="" then
        if TitanGetVar(name, "ShowColoredText") then
        	return TitanUtils_GetNormalText(LDBAttrs[nametrim].label)..": " , TitanUtils_GetGreenText(LDBAttrs[nametrim].text);
        else
   				return TitanUtils_GetNormalText(LDBAttrs[nametrim].label)..": " , TitanUtils_GetHighlightText(LDBAttrs[nametrim].text);
   			end
    else
   			if TitanGetVar(name, "ShowColoredText") then
   				return TitanUtils_GetGreenText(LDBAttrs[nametrim].text);
   			else
   				return TitanUtils_GetHighlightText(LDBAttrs[nametrim].text);
      	end
    end
   end
 
end

-- Icon Handler goes here

function LDBToTitan:TitanLDBIconUpdate(_, name,  attr, value, dataobj)
 if attr == "icon" then
 TitanPlugins["LDBT_"..name].icon = value;
 TitanPanelButton_SetButtonIcon("LDBT_"..name);
 end
end


-- New DO gets created here

function LDBToTitan:TitanLDBCreateObject(_, name, obj)
   -- phear the custom obj.type !
   -- Regular DO's should be fine 
   -- Launchers are being treated as a DO but may change behavior from within Titan core (right-side plugins with only an icon and a tooltip/Click)
		
   --DEFAULT_CHAT_FRAME:AddMessage("Attempting to register "..name..".");
		
    local idTitan, menuTextTitan, iconTitan, categoryTitan;
   
   -- Create the Titan Frame as a Combo (for now)
   
   
    local newTitanFrame = CreateFrame("Button","TitanPanel".."LDBT_"..name.."Button", UIParent, "TitanPanelComboTemplate")  
    newTitanFrame:SetFrameStrata("FULLSCREEN");
    newTitanFrame:SetToplevel(true);
    newTitanFrame:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    LDBAttrs[name] = {};
    
    -- Handle the attributes of the DO and register the appropriate callbacks (where applicable)
    
       if obj.type then
       LDBAttrs[name].type = obj.type;
       end
    
       idTitan = "LDBT_"..name;
       menuTextTitan = obj.label or name; -- this may change
       
       if obj.label and obj.label~="" then
       	LDBAttrs[name].label = obj.label;
       else
       	LDBAttrs[name].label = "";
       end
       
       if obj.suffix then
       	LDBAttrs[name].suffix = obj.suffix;
       	LDBAttrs[name].value = obj.value or "?";
       	ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_value", "TitanLDBTextUpdate")
       	ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_suffix", "TitanLDBTextUpdate")
       elseif obj.text then
       	LDBAttrs[name].text = obj.text;
       	ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_text", "TitanLDBTextUpdate")
       else
       	if obj.type == "launcher" and obj.label then -- this is kind of a "hack" to avoid using a bad formatted addon name as text (needs testing)
       		LDBAttrs[name].text = obj.label;
       	else
       		LDBAttrs[name].text = name;
       	end
       	 ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_text", "TitanLDBTextUpdate") -- register the callback anyhow in case a plugin changes text via a timed update
       end
         
       
       if obj.icon then
       iconTitan = obj.icon;
       else
       iconTitan = "Interface\\PVPFrame\\\PVP-ArenaPoints-Icon"; -- generic icon in case the DO does not provide one
       end
       ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_icon", "TitanLDBIconUpdate")
       
       if obj.tooltip then
       local pluginframe = getglobal(obj.tooltip);
			-- What we ideally want to do with the "tooltip" attribute
			 -- is to set the DO's OnEnter to anchor the frame and show it
			 -- and also set an OnShow on the frame itself for refreshing purposes
			 -- as dictated by the LDB spec, assuming an OnShow is not provided on
			 -- the frame by the DO.
			 -- For now we'll just assume that this frame is NOT the GameTooltip
			   if pluginframe then		
			 		newTitanFrame:SetScript("OnEnter", function(this)
			 		  TitanPanelButton_OnEnter();
			 		  -- we may need this for the future
			 		  --if obj.OnEnter then
			    	--obj.OnEnter(this)
			 			--end
			 		  self:TitanLDBSetTooltip("LDBT_"..name, pluginframe, nil)						
			 		end)
			 		
			 		newTitanFrame:SetScript("OnMouseDown", function(this)
			 		  pluginframe:Hide();			 		  
			 		end)
					
					-- It's far from a perfect solution (work in progress)
			
			 		if pluginframe:GetScript("OnLeave") then
			 		-- do nothing
			 		else
			 		newTitanFrame:SetScript("OnLeave", function(this)
			 		if obj.OnLeave then
			    	obj.OnLeave(this)
			 		end
			 		pluginframe:Hide();
			 		TitanPanelButton_OnLeave();
			 		end)
			 		end
					
					
			 		if pluginframe:GetName()~="GameTooltip" then
			 			if pluginframe:GetScript("OnShow") then
							-- do nothing
						else
						pluginframe:SetScript("OnShow", function(this)
						self:TitanLDBSetTooltip("LDBT_"..name, pluginframe, nil)
						end)
						end
			 	 end			 		       			        			 	
       end			 	
       elseif obj.OnEnter then       
			 self:TitanLDBHandleScripts("OnEnter", name, nil, obj.OnEnter, obj)
			 elseif obj.OnTooltipShow then
			 self:TitanLDBHandleScripts("OnTooltipShow", name, nil, obj.OnTooltipShow, obj)
			 else
			 self:TitanLDBHandleScripts("OnEnter", name, nil, nil, obj)
			 ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_OnEnter", "TitanLDBHandleScripts")
			 ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_OnTooltipShow", "TitanLDBHandleScripts")
			 end

			 
			 if obj.OnClick then
			 self:TitanLDBHandleScripts("OnClick", name, nil, obj.OnClick)
			 else
			 ldb.RegisterCallback(self, "LibDataBroker_AttributeChanged_"..name.."_OnClick", "TitanLDBHandleScripts")
			 end
       
       
       -- Set the plugin category, if it exists else default to "General"
       -- We check for a tocname attrib first, if found we use it, if not...
       -- ..we assume that the DO "name" attribute is the same with the actual
       -- addon name, which might not always be the case.
       -- Even if it isn't though, Titan defaults again to "General"
       -- via a check in the menu implementation, later on.
       local addoncategory, addonversion;
       local tempname = obj.tocname or name;
       
       	if IsAddOnLoaded(tempname) then
       		addoncategory = GetAddOnMetadata(tempname, "X-Category");
       		addonversion = GetAddOnMetadata(tempname, "Version");
       	end
              
       if xcategories[addoncategory] then
       	categoryTitan = xcategories[addoncategory];
       end
       
       
   -- Compile the appropriate Titan registry for the DO
   
   local ldbtype = tostring(obj.type);
   local ldblabelvalue = tostring (obj.label);
   
   -- Apparently some launchers are using a malformed spec by setting a "launcher" attribute to true
   -- so...(sigh) we need to compensate for this by...guessing that it MAY happen
   
   if obj.launcher and obj.type~="data source" and (obj.launcher == true or obj.launcher == yes or obj.launcher == "yes") then
   	ldbtype = "launcher";
   end
   
    this.registry = {
          id = idTitan,
          ldb = ldbtype,
          ldblabel = ldblabelvalue,
          menuText = menuTextTitan,
          buttonTextFunction = "TitanLDBShowText", 
          icon = iconTitan,     
          iconWidth = 16,          
          savedVariables = {
               ShowIcon = 1,
               ShowLabelText = 1,
               ShowColoredText = TITAN_NIL,
               DisplayOnRightSide = TITAN_NIL
          }
     };
          
     if categoryTitan~="" then
      this.registry["category"]= categoryTitan;
     end
     
     if addonversion ~="" then
      this.registry["version"]= addonversion;
     end
     
    TitanPanelButton_OnLoad(nil, "LDBT_"..name);
end


LDBToTitan:SetScript("OnEvent", function(self, event, ...)
	 if (event == "PLAYER_LOGIN") then	 
	  self:SetScript("OnEvent", nil) 
	  self:UnregisterEvent("PLAYER_LOGIN")
		ldb.RegisterCallback(self, "LibDataBroker_DataObjectCreated", "TitanLDBCreateObject")
    	  	for name, obj in ldb:DataObjectIterator() do
			self:TitanLDBCreateObject(nil, name, obj)
		--DEFAULT_CHAT_FRAME:AddMessage("Registered "..name..".");			
	  	end
    	 end
end)