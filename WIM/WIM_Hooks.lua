WIM_ButtonsHooked = false;


function WIM_ToggleMinimap()
		WIM_Icon_UpdatePosition();
end

function WIM_ChatFrame_ReplyTell(chatFrame)
	if(WIM_Data.hookWispParse and WIM_Data.enableWIM and WIM_Data.popOnSend and not (WIM_Data.popCombat and UnitAffectingCombat("player"))) then
		if ( not chatFrame ) then
			chatFrame = DEFAULT_CHAT_FRAME;
		end

		local lastTell = ChatEdit_GetLastTellTarget();
		if ( lastTell ~= "" ) then
			WIM_PostMessage(lastTell, "", 5, "", "*CLEAR*");
			ChatEdit_OnEscapePressed(ChatFrameEditBox);
		end
	end
end

function WIM_ChatFrame_ReplyTell2(chatFrame)
	if(WIM_Data.hookWispParse and WIM_Data.enableWIM and WIM_Data.popOnSend and not (WIM_Data.popCombat and UnitAffectingCombat("player"))) then
		if ( not chatFrame ) then
			chatFrame = DEFAULT_CHAT_FRAME;
		end

		local lastTell = ChatEdit_GetLastToldTarget();
		if ( lastTell ~= "" ) then
			WIM_PostMessage(lastTell, "", 5, "", "*CLEAR*");
			ChatEdit_OnEscapePressed(ChatFrameEditBox);
		end
	end
end

function WIM_ChatEdit_HandleChatType(editBox, msg, command, send)
	for index, value in pairs(ChatTypeInfo) do
		local i = 1;
		local cmdString = getglobal("SLASH_"..index..i);
		while ( cmdString ) do
			cmdString = strupper(cmdString);
			if ( cmdString == command ) then
				-- index is the entered command
				if(index == "REPLY") then WIM_ChatFrame_ReplyTell(); end
				return;
			end
			i = i + 1;
			cmdString = getglobal("SLASH_"..index..i);
		end
	end
end

function WIM_FriendsFrame_SendMessage()
	if(WIM_Data.enableWIM) then
		if(WIM_EditBoxInFocus) then
			WIM_EditBoxInFocus:SetText("");
		end
		local name = GetFriendInfo(FriendsFrame.selectedFriend);
		WIM_PostMessage(name, "", 5, "", "");
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end
end

function WIM_ChatEdit_ExtractTellTarget(editBox, msg)
	-- Grab the first "word" in the string
	local target = gsub(msg, "(%s*)([^%s]+)(.*)", "%2", 1);
	if ( (strlen(target) <= 0) or (strsub(target, 1, 1) == "|") ) then
		return;
	end
	
	if(WIM_Data.hookWispParse and WIM_Data.enableWIM and WIM_Data.popOnSend and not (WIM_Data.popCombat and UnitAffectingCombat("player"))) then
		target = string.gsub(target, "^%l", string.upper)
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
		WIM_PostMessage(target, "", 5, "", "");
	end
end


function WIM_SendChatMessage(a, b, c, user)
    user = WIM_FormatName(user);
    if(WIM_Windows[user]) then
        WIM_Windows[user].sent_tell = true;
    end
end

function WIM_FriendsFrame_OnEvent(event)
  if(event == "WHO_LIST_UPDATE") then
		local numWhos, totalCount = GetNumWhoResults();
		if(numWhos > 0) then
			for i=1, numWhos do 
				local name, guild, level, race, class, zone = GetWhoInfo(i);
				if(WIM_Windows[name] and name ~= "" and name ~= nil) then
					if(WIM_Windows[name].waiting_who) then
						WIM_Windows[name].waiting_who = false;
						WIM_Windows[name].class = class;
						WIM_Windows[name].level = level;
						WIM_Windows[name].race = race;
						WIM_Windows[name].guild = guild;
						WIM_Windows[name].location = zone;
						WIM_SetWhoInfo(name);
						SetWhoToUI(0);
						return;
					end
				end
			end
		else
			SetWhoToUI(0);
			return;
		end
  end
end


function WIM_SetItemRef (link, text, button)
	if (WIM_isLinkURL(link)) then
		WIM_DisplayURL(link);
		return;
	end
	
	WIM_SetItemRef_orig(link, text, button);
end


function WIM_IgnoreMore(theUser)
	if(IsAddOnLoaded("IgnoreMore")) then
		local realm = GetRealmName() .. "-" .. UnitFactionGroup("player");
		if(IgM_SV.enabled and type(IgM_SV.list) == "table" and type(IgM_SV.list[realm]) == "table" and type(IgM_SV.list[realm][theUser]) == "table") then
			return 2;
		else
			return 0;
		end
	else
		return 0;
	end
end

-- needed in order to UnitPopups to work with whispers.
function WIM_ChatFrame_SendTell(name)
	if(WIM_Data.hookWispParse and WIM_Data.enableWIM and WIM_Data.popOnSend and not (WIM_Data.popCombat and UnitAffectingCombat("player"))) then
		local tmp = WIM_EditBoxInFocus;
		WIM_EditBoxInFocus = nil;

		if ( ChatFrameEditBox.setText == 1) then
			WIM_EditBoxInFocus = nil;
			ChatFrameEditBox:SetText(ChatFrameEditBox.text);
			ChatFrameEditBox.setText = 0;
			ChatEdit_ParseText(ChatFrameEditBox, 0);
		end
		ChatEdit_OnEscapePressed(ChatFrameEditBox);
	end
end


function WIM_UnitPopup_HideButtons()
	local dropdownMenu = getglobal(UIDROPDOWNMENU_INIT_MENU);
	for index, value in ipairs(UnitPopupMenus[dropdownMenu.which]) do
		if(value == "WIM_HISTORY") then
			if(WIM_History[dropdownMenu.name] == nil) then
				UnitPopupShown[UIDROPDOWNMENU_MENU_LEVEL][index] = 0;
			end
		end
	end
end

function WIM_UnitPopup_OnClick()
	local dropdownFrame = getglobal(UIDROPDOWNMENU_INIT_MENU);
	local button = this.value;
	if(button == "WIM_HISTORY") then
		WIM_HistoryView_Name_Selected = dropdownFrame.name;
		WIM_HistoryView_Filter_Selected = "";
		if(WIM_HistoryFrame:IsVisible()) then
			WIM_HistoryViewNameScrollBar_Update();
			WIM_HistoryViewFiltersScrollBar_Update();
		else
			WIM_HistoryFrame:Show();
		end
	end
end

function WIM_SetUpHooks()
	if(WIM_ButtonsHooked) then
		return;
	end

	-------------------------------------------------------------------------------------------
	-- The following hooks will account for anything that is being inserted into default chat frame and
	-- spoofs other callers into thinking that they are actually linking into the chat frame.
	--DEFAULT_CHAT_FRAME.editBox
	
	hooksecurefunc(ChatFrameEditBox, "Insert", function(self,theText)
					if(WIM_EditBoxInFocus) then
						WIM_API_InsertText(theText)
					end
				end )
	ChatFrameEditBox.WIM_IsVisible = ChatFrameEditBox.IsVisible;
	ChatFrameEditBox.IsVisible = function(self)
					if(WIM_EditBoxInFocus) then
						return true;
					else
						return ChatFrameEditBox:WIM_IsVisible();
					end
				end
	ChatFrameEditBox.WIM_IsShown = ChatFrameEditBox.IsShown;
	ChatFrameEditBox.IsShown = function(self)
					if(WIM_EditBoxInFocus) then
						return true;
					else
						return ChatFrameEditBox:WIM_IsShown();
					end
				end
	-- can not hook GetText() because it taints the chat bar. Breaks /tar
	hooksecurefunc(ChatFrameEditBox, "SetText", function(self,theText)
					local firstChar = "";
					--if a slash command is being set, ignore it. Let WoW take control of it.
					if(string.len(theText) > 0) then firstChar = string.sub(theText, 1, 1); end
					if(WIM_EditBoxInFocus and firstChar ~= "/") then
						WIM_EditBoxInFocus:SetText(theText);
					end
				end );
	ChatFrameEditBox.WIM_HighlightText = ChatFrameEditBox.HighlightText;
	ChatFrameEditBox.HighlightText = function(self, theStart, theEnd)
					if(WIM_EditBoxInFocus) then
						WIM_EditBoxInFocus:HighlightText(theStart, theEnd);
					else
						ChatFrameEditBox:WIM_HighlightText(theStart, theEnd);
					end
				end

   
	hooksecurefunc("ChatFrame_SendTell", WIM_ChatFrame_SendTell);
	hooksecurefunc("FriendsFrame_SendMessage", WIM_FriendsFrame_SendMessage);
	hooksecurefunc("ToggleMinimap", WIM_ToggleMinimap);
	hooksecurefunc("ChatEdit_ExtractTellTarget", WIM_ChatEdit_ExtractTellTarget);
	hooksecurefunc("SendChatMessage", WIM_SendChatMessage);
	hooksecurefunc("ChatEdit_HandleChatType", WIM_ChatEdit_HandleChatType);
	hooksecurefunc("UnitPopup_HideButtons", WIM_UnitPopup_HideButtons);
	hooksecurefunc("UnitPopup_OnClick", WIM_UnitPopup_OnClick);
	-------------------------------------------------------------------------------------------


	--Hook ChatFrame_ReplyTell & ChatFrame_ReplyTell2
	hooksecurefunc("ChatFrame_ReplyTell", WIM_ChatFrame_ReplyTell);
	hooksecurefunc("ChatFrame_ReplyTell2", WIM_ChatFrame_ReplyTell2);
	
	--Hook SetItemRef
	WIM_SetItemRef_orig = SetItemRef;
	SetItemRef = WIM_SetItemRef;

	WIM_ButtonsHooked = true;
end


function WIM_AddonDetectToHook(theAddon)
	-- import new addon's media from SharedMediaLib
	WIM_Skinner_Import_SharedMedia();
	
	if(theAddon == "Auctioneer" or theAddon == "Auc-Advanced") then
		WIM_HookAuctioneer();
	end
end


---------------------------------------------------------------------
-- WhoLib Interface
---------------------------------------------------------------------

WIM_WhoLib_Object = nil;

function WIM_WhoLib_Init()
	if(not WIM_WhoLib_Object) then
		WIM_WhoLib_Object = AceLibrary and AceLibrary('WhoLib-1.0')
	end
end

function WIM_WhoLib_isLoaded()
	if(AceLibrary) then
		if AceLibrary:HasInstance('WhoLib-1.0') then
			WIM_WhoLib_Init();
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function WIM_WhoLib_SendWho(theUser)
	local result = WIM_WhoLib_Object:UserInfo(theUser, 
					{
						queue = WIM_WhoLib_Object.WHOLIB_QUEUE_QUIET, 
						timeout = 0,
						flags = WIM_WhoLib_Object.WHOLIB_FLAG_ALLWAYS_CALLBACK,
						callback = WIM_WhoLib_CallBack
					});
end

function WIM_WhoLib_CallBack(result)
	if( result.Online and WIM_Windows[result.Name]) then
		WIM_Windows[result.Name].waiting_who = false;
		WIM_Windows[result.Name].class = result.Class;
		WIM_Windows[result.Name].level = result.Level;
		WIM_Windows[result.Name].race = result.Race;
		WIM_Windows[result.Name].guild = result.Guild;
		WIM_Windows[result.Name].location = result.Zone;
		WIM_SetWhoInfo(result.Name);
	end
end


-- declare menu object for right click on player names in chat
UnitPopupButtons["WIM_HISTORY"] = { text = "WIM"..WIM_LOCALIZED_OPTIONS_TAB_HISTORY, dist = 0, tooltipText = WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY };
table.insert(UnitPopupMenus["FRIEND"], 2, "WIM_HISTORY");
table.insert(UnitPopupMenus["PLAYER"], 2, "WIM_HISTORY");
table.insert(UnitPopupMenus["TEAM"], 2, "WIM_HISTORY");
table.insert(UnitPopupMenus["RAID_PLAYER"], 8, "WIM_HISTORY");
table.insert(UnitPopupMenus["PARTY"], 10, "WIM_HISTORY");