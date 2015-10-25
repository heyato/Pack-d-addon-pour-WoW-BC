-- Global variables 
TitanSettings = nil;
TitanPlayerSettings = nil;
TitanPluginSettings = nil;
TitanPanelSettings = nil;
TitanOldSettings = nil;

TITAN_LAST_UPDATED = "September 3rd, 2008"
TITAN_VERSION = "3.2.9.20400";
TITAN_FIRST_LOAD = nil;

local _G = getfenv(0);

-- Constants
TITAN_NIL = "Titan Nil";

function TitanVariables_InitTitanSettings()
	if (not TitanSettings) then
		TitanSettings = {};
	end
	
	-- Backup Settings from old version that doesn't support settings per char
	-- if ( not TitanSettings.Version ) then
	--	TitanVariables_BackupOldSettings();
	--end
	
	-- Settings migration from version to version
	--if ( TitanVariables_CompareVersion(TitanSettings.Version, "1.22.1300") < 0 ) then
	--	TitanVariables_MigrateTo_1_22_1300();
	--end

	--TitanOldSettings = TitanSettings.OldSettings;
	TitanSettings.Version = TITAN_VERSION;
	TITAN_PANEL_SELECTED = "Main";
end

function TitanVariables_InitDetailedSettings()
	if (not TitanPlayerSettings) then
		TitanVariables_InitPlayerSettings();
		if (TitanPlayerSettings) then
			-- Migrate old settings
			if (TITAN_FIRST_LOAD) then
				TitanVariables_MigrateOldSettings();	
			end

			-- Syncronize Plugins/Panel settings
			TitanVariables_SyncPluginSettings();
			TitanVariables_SyncPanelSettings();
			TitanVariables_HandleLDB();
		end					
	end	
end

function TitanVariables_HandleLDB()
-- Handle LDB
			 local plugin, index, id;
				for index, id in pairs(TitanPluginsIndex) do
		 		plugin = TitanUtils_GetPlugin(id);
		 		  if plugin.ldb == "launcher" and TitanGetVar(id, "DisplayOnRightSide") then
			    	  local button = TitanUtils_GetButton(id);
			    		local buttonText = getglobal(button:GetName().."Text");
			    		if not TitanGetVar(id, "ShowIcon") then
						  	TitanToggleVar(id, "ShowIcon");	
						  end
			    		TitanPanelButton_UpdateButton(id);
								if buttonText then
										buttonText:SetText("")
										button:SetWidth(16);
								  	TitanPlugins[id].buttonTextFunction = nil;
										_G["TitanPanel"..id.."ButtonText"] = nil;
										local found = nil;
										for index, _ in ipairs(TITAN_PANEL_NONMOVABLE_PLUGINS) do
												if id == TITAN_PANEL_NONMOVABLE_PLUGINS[index] then
									  			found = true;
												end
										end
										if not found then table.insert(TITAN_PANEL_NONMOVABLE_PLUGINS, id); end
											if button:IsVisible() then
												TitanPanel_RemoveButton(id);
												TitanPanel_AddButton(id);
										  end
							  end
					end
		 		end
			-- /Handle LDB
end

function TitanVariables_InitPlayerSettings() 
	-- Titan should not be nil
	if (not TitanSettings) then
		return;
	end
	
	-- Init TitanSettings.Players
	if (not TitanSettings.Players ) then
		TitanSettings.Players = {};
	end
	
	local playerName = UnitName("player");
	local serverName = GetCVar("realmName");
	-- Do nothing if player name is not available
	if (playerName == nil or playerName == UNKNOWNOBJECT or playerName == UKNOWNBEING) then
		return;
	end

	if (TitanSettings.Players[playerName] and not TitanSettings[playerName .. "@" .. serverName]) then
		TitanSettings.Players[playerName.."@"..serverName] = TitanSettings.Players[playerName];
		TitanSettings.Players[playerName]=nil;
	end
	
	-- Init TitanPlayerSettings
	if (not TitanSettings.Players[playerName.."@"..serverName]) then
		TitanSettings.Players[playerName.."@"..serverName] = {};
		TitanSettings.Players[playerName.."@"..serverName].Plugins = {};
		TitanSettings.Players[playerName.."@"..serverName].Panel = {};
		TITAN_FIRST_LOAD = 1;		
	end	
	
	-- Set global variables
	TitanPlayerSettings = TitanSettings.Players[playerName.."@"..serverName];
	TitanPluginSettings = TitanPlayerSettings["Plugins"];
	TitanPanelSettings = TitanPlayerSettings["Panel"];	
end

function TitanVariables_SyncPluginSettings()
	-- Init each and every plugin
	for id, plugin in pairs(TitanPlugins) do
		if (plugin and plugin.savedVariables) then
			-- Init savedVariables table
			if (not TitanPluginSettings[id]) then
				TitanPluginSettings[id] = {};
			end					
			
			-- Synchronize registered and saved variables
			TitanVariables_SyncRegisterSavedVariables(plugin.savedVariables, TitanPluginSettings[id]);			
		else
			-- Remove plugin savedVariables table if there's one
			if (TitanPluginSettings[id]) then
				TitanPluginSettings[id] = nil;
			end								
		end
	end
end

function TitanVariables_SyncPanelSettings() 
	-- Synchronize registered and saved variables
	TitanVariables_SyncRegisterSavedVariables(TITAN_PANEL_SAVED_VARIABLES, TitanPanelSettings);			
end

function TitanVariables_SyncRegisterSavedVariables(registeredVariables, savedVariables)
	if (registeredVariables and savedVariables) then
		-- Init registeredVariables
		for index, value in pairs(registeredVariables) do
			if (not TitanUtils_TableContainsIndex(savedVariables, index)) then
				savedVariables[index] = value;
			end
		end
					
		-- Remove out-of-date savedVariables
		for index, value in pairs(savedVariables) do
			if (not TitanUtils_TableContainsIndex(registeredVariables, index)) then
				savedVariables[index] = nil;
			end
		end
	end
end

function TitanGetVar(id, var)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		return TitanUtils_Ternary(TitanPluginSettings[id][var] == TITAN_NIL, nil, TitanPluginSettings[id][var]);
	end
end

function TitanSetVar(id, var, value)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		TitanPluginSettings[id][var] = TitanUtils_Ternary(value, value, TITAN_NIL);
	end
end

function TitanGetVarTable(id, var, position)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		return TitanUtils_Ternary(TitanPluginSettings[id][var][position] == TITAN_NIL, nil, TitanPluginSettings[id][var][position]);
	end
end

function TitanSetVarTable(id, var, position, value)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		TitanPluginSettings[id][var][position] = TitanUtils_Ternary(value, value, TITAN_NIL);
	end
end

function TitanToggleVar(id, var)
	if (id and var and TitanPluginSettings and TitanPluginSettings[id]) then
		TitanSetVar(id, var, TitanUtils_Toggle(TitanGetVar(id, var)));
	end
end

function TitanPanelGetVar(var)
	if (var and TitanPanelSettings) then
		return TitanUtils_Ternary(TitanPanelSettings[var] == TITAN_NIL, nil, TitanPanelSettings[var]);
	end
end

function TitanPanelSetVar(var, value)
	if (var and TitanPanelSettings) then
		TitanPanelSettings[var] = TitanUtils_Ternary(value, value, TITAN_NIL);
	end
end

function TitanPanelToggleVar(var)
	if (var and TitanPanelSettings) then
		TitanPanelSetVar(var, TitanUtils_Toggle(TitanPanelGetVar(var)));
	end
end

function TitanVariables_BackupOldSettings()
	if (TitanSettings.Players) then
		-- New OldSettings and copy over the existing settings
		TitanSettings.OldSettings = {};
		TitanSettings.OldSettings.Players = TitanSettings.Players;
		TitanSettings.OldSettings.Panel = TitanSettings.Panel;
		
		-- Clear the existing settings
		TitanSettings.Players = nil;
		TitanSettings.Panel = nil;
		TitanSettings.Volume = nil;
		TitanSettings.UIScale = nil;
		TitanSettings.Tooltip = nil;
	end
end

function TitanVariables_MigrateOldSettings()
	local playerName = UnitName("player");
	if (TITAN_FIRST_LOAD and TitanOldSettings) then
		-- Old player settings migration
		if (TitanOldSettings.Players[playerName]) then
			TitanPluginSettings.Clock = TitanOldSettings.Players[playerName].Clock;
		end
		
		-- Old panel settings migration
		if (TitanOldSettings.Panel) then
			-- Transparency
			TitanPanelSettings.Transparency = TitanOldSettings.Panel.Transparency;

			-- AutoHide
			TitanPanelSettings.AutoHide = TitanMigrate(TitanOldSettings.Panel.AutoHide);

			-- Buttons
			TitanPanelSettings.Buttons = TitanVariables_AppendNonMovableButtons(TitanOldSettings.Panel.Buttons);

			-- Bag
			if (TitanPluginSettings.Bag and TitanOldSettings.Panel.Bag) then
				TitanPluginSettings.Bag.CountAmmoPouchSlots = TitanMigrate(TitanOldSettings.Panel.Bag.CountAmmoPouchSlots);
				TitanPluginSettings.Bag.ShowUsedSlots = TitanMigrate(TitanOldSettings.Panel.Bag.ShowUsedSlots);
			end		
			
			-- Coords
			if (TitanPluginSettings.Coords and TitanOldSettings.Panel.Location) then
				TitanPluginSettings.Coords.ShowColoredText = TitanMigrate(TitanOldSettings.Panel.Location.ShowColoredText);
				TitanPluginSettings.Coords.ShowCoordsOnMap = TitanMigrate(TitanOldSettings.Panel.Location.ShowCoordsOnMap);
				TitanPluginSettings.Coords.ShowZoneText = TitanMigrate(TitanOldSettings.Panel.Location.ShowZoneText);
			end		

			-- FPS
			if (TitanPluginSettings.FPS and TitanOldSettings.Panel.FPS) then
				TitanPluginSettings.FPS.ShowColoredText = TitanMigrate(TitanOldSettings.Panel.FPS.ShowColoredText);
			end		

			-- Latency
			if (TitanPluginSettings.Latency and TitanOldSettings.Panel.Latency) then
				TitanPluginSettings.Latency.ShowColoredText = TitanMigrate(TitanOldSettings.Panel.Latency.ShowColoredText);
			end		

			-- XP
			if (TitanPluginSettings.XP and TitanOldSettings.Panel.XP) then
				TitanPluginSettings.XP.ShowXPPerHourSession = TitanMigrate(TitanOldSettings.Panel.XP.ShowXPPerHourSession);
			end		
		end		
	end	
end

function TitanMigrate(value)	
	return TitanUtils_Ternary(value, value, TITAN_NIL);	
end

function TitanVariables_MigrateTo_1_22_1300()
	if ( TitanSettings and TitanSettings.Players and type(TitanSettings.Players) == "table" ) then
		for index, value in TitanSettings.Players do
			if ( value and value.Panel and value.Panel.Buttons ) then
				value.Panel.Buttons = TitanVariables_AppendNonMovableButtons(value.Panel.Buttons);
			end
		end
	end	
end

function TitanVariables_AppendNonMovableButtons(buttons)
	if ( buttons and type(buttons) == "table" ) then		
		for index, id in TITAN_PANEL_NONMOVABLE_PLUGINS do
			if ( not TitanUtils_TableContainsValue(buttons, id) ) then
				table.insert(buttons, id);
			end
		end
	end
	return buttons;
end

function TitanVariables_CompareVersion(version1, version2) 
	local mainVer1, subVer1, uiVer1, betaVer1 = TitanVariables_ParseVersion(version1);
	local mainVer2, subVer2, uiVer2, betaVer2 = TitanVariables_ParseVersion(version2);
	
	if ( mainVer1 == mainVer2 ) then
		if ( subVer1 == subVer2 ) then
			if ( uiVer1 == uiVer2 ) then
				return (betaVer1 - betaVer2);
			else
				return (uiVer1 - uiVer2);
			end
		else
			return (subVer1 - subVer2);
		end
	else
		return (mainVer1 - mainVer2);
	end
end

function TitanVariables_ParseVersion(version) 
	if ( version ) then
		local verInfo = {};		
		for w in string.gmatch(version, "%w+") do
			table.insert(verInfo, w);
		end
		
		local mainVer, subVer, uiVer, betaVer;
		mainVer = tonumber(verInfo[1]);
		subVer = tonumber(verInfo[2]);
		uiVer = tonumber(verInfo[3]);
		if ( not verInfo[4] ) then
			betaVer = 100;
		else			
			betaVer = tonumber(string.sub(verInfo[4], 5, -1));
		end
		return mainVer, subVer, uiVer, betaVer;
	else
		return 0, 0, 0, 0;
	end
end

function TitanVariables_UseSettings()
local i,k,pos;
	TitanCopyPlayerSettings = TitanSettings.Players[this.value];
	TitanCopyPluginSettings = TitanCopyPlayerSettings["Plugins"];
	TitanCopyPanelSettings = TitanCopyPlayerSettings["Panel"];

	for index, id in pairs(TitanPanelSettings["Buttons"]) do
		local currentButton = TitanUtils_GetButton(TitanPanelSettings["Buttons"][index]);
		-- safeguard
		if currentButton ~= nil then
		currentButton:Hide();
		end	
	end

	for index, id in pairs(TitanCopyPanelSettings) do		
	-- we need to check if the imported buttons are actually loaded as addons on this character
	 if index == "Buttons" then	  
	     -- so we traverse through the table that holds them
				for i,_ in ipairs(TitanCopyPanelSettings["Buttons"]) do
				  -- we get the name of the button
					local pluginName = TitanCopyPanelSettings["Buttons"][i];
					  -- we search through our addon list
					  for k = 1, GetNumAddOns() do
					    -- this is the name of the addon to compare our button
					    local addonName = GetAddOnInfo(k);
					     -- we search if the addon name is equal to Titan..(name of our button)
					       -- if it is we check if the addon is loaded
					       if addonName == "Titan"..pluginName and IsAddOnLoaded(k)== nil then
					           -- if it's not
			  		     		 -- do nothing
			  		     	else
			  		     	   -- if it is we allow it to be imported into this character
			  		     	TitanPanelSetVar(index, TitanCopyPanelSettings[index]);
			  		     end
			  		 end    			  
					end
	 else
		TitanPanelSetVar(index, TitanCopyPanelSettings[index]);
		end
	end
	
	for index, id in pairs(TitanCopyPluginSettings) do
		for var, id in pairs(TitanCopyPluginSettings[index]) do
			TitanSetVar(index, var, TitanCopyPluginSettings[index][var])
		end
	end
	
	TitanVariables_HandleLDB();
	TitanPanel_InitPanelBarButton();
	TitanPanel_InitPanelButtons();		

	if (TitanPanelGetVar("AutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelBarButton", TitanPanelGetVar("Position"));
	end
	if (TitanPanelGetVar("AuxAutoHide")) then
		TitanPanelBarButton_Hide("TitanPanelAuxBarButton", TITAN_PANEL_PLACE_BOTTOM);
	end		
	TitanPanelRightClickMenu_Close();
end
