--[Functions: GUI Interface for WIM_History.xml

WIM_HistoryView_Name_Selected = "";
WIM_HistoryView_Filter_Selected = "";

WIM_History_ExportFormatVal = 1;

WIM_String_ShowAll = " |cffffffff( Show All )|r";

WIM_History_Filters = {};

function WIM_HistoryView_NameClick()
	if(WIM_HistoryView_Name_Selected ~= this.Name) then
		WIM_HistoryView_Filter_Selected = "";
	end
	WIM_HistoryView_Name_Selected = this.theName;
	if(WIM_HistoryView_Name_Selected == WIM_String_ShowAll) then WIM_HistoryView_Name_Selected = "*all*"; end
	WIM_HistoryViewFiltersScrollBar_Update();
end

function WIM_HistoryView_FilterClick()
	WIM_HistoryView_Filter_Selected = this.theName;
end

function WIM_HistoryViewNameScrollBar_Update()
	local line;
	local lineplusoffset;
	local HistoryNames = {};
	
	table.insert(HistoryNames, WIM_String_ShowAll);
	
	for key,_ in pairs(WIM_History) do
		table.insert(HistoryNames, key);
	end
	table.sort(HistoryNames);
	
	FauxScrollFrame_Update(WIM_HistoryFrameNameListScrollBar,table.getn(HistoryNames),15,16);
	for line=1,15 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(WIM_HistoryFrameNameListScrollBar);
		if lineplusoffset <= table.getn(HistoryNames) then
			getglobal("WIM_HistoryFrameNameListButton"..line.."Name"):SetText(HistoryNames[lineplusoffset]);
			getglobal("WIM_HistoryFrameNameListButton"..line).theName = HistoryNames[lineplusoffset];
			if ( WIM_HistoryView_Name_Selected == HistoryNames[lineplusoffset] ) then
				getglobal("WIM_HistoryFrameNameListButton"..line):LockHighlight();
			else
				getglobal("WIM_HistoryFrameNameListButton"..line):UnlockHighlight();
			end
			getglobal("WIM_HistoryFrameNameListButton"..line):Show();
		else
			getglobal("WIM_HistoryFrameNameListButton"..line):Hide();
		end
	end
end


function WIM_History_LoadFiltersByUser(theUser)
	local tDate = "";
	local lDate = "";

	for i=1,table.getn(WIM_History[theUser]) do
		tDate = WIM_History[theUser][i].date;
		if(tDate ~= lDate) then
			if(WIM_History_AlreadyInTable(WIM_History_Filters, tDate) == false) then
				table.insert(WIM_History_Filters, tDate);
			end
			lDate = tDate;
		end
	end
end

function WIM_HistoryViewFiltersScrollBar_Update()
	local line;
	local lineplusoffset;
	
	WIM_History_Filters = {};
	
	if(WIM_History[WIM_HistoryView_Name_Selected] or WIM_HistoryView_Name_Selected == "*all*") then
		if(WIM_HistoryView_Name_Selected == "*all*") then
			for key, _ in pairs(WIM_History) do
				WIM_History_LoadFiltersByUser(key);
			end
		else
			WIM_History_LoadFiltersByUser(WIM_HistoryView_Name_Selected);
		end
	end
	table.sort(WIM_History_Filters);
	table.insert(WIM_History_Filters, 1, WIM_LOCALIZED_HISTORY_NO_FILTER);
	if(WIM_HistoryView_Filter_Selected == "") then
		--[WIM_HistoryView_Filter_Selected = Filters[1];
	end
	
	FauxScrollFrame_Update(WIM_HistoryFrameFilterListScrollBar,table.getn(WIM_History_Filters),7,16);
	for line=1,7 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(WIM_HistoryFrameFilterListScrollBar);
		if lineplusoffset <= table.getn(WIM_History_Filters) then
			getglobal("WIM_HistoryFrameFilterListButton"..line.."Name"):SetText(WIM_History_Filters[lineplusoffset]);
			if(lineplusoffset == 1) then
				getglobal("WIM_HistoryFrameFilterListButton"..line).theName = "";
			else
				getglobal("WIM_HistoryFrameFilterListButton"..line).theName = WIM_History_Filters[lineplusoffset];
			end
			if ( WIM_HistoryView_Filter_Selected == WIM_History_Filters[lineplusoffset] ) then
				getglobal("WIM_HistoryFrameFilterListButton"..line):LockHighlight();
			else
				getglobal("WIM_HistoryFrameFilterListButton"..line):UnlockHighlight();
			end
			getglobal("WIM_HistoryFrameFilterListButton"..line):Show();
		else
			getglobal("WIM_HistoryFrameFilterListButton"..line):Hide();
		end
	end
	WIM_HistoryView_ShowMessages();
end


function WIM_HistoryView_ProcMsgFormat(theUser, theFormat)
	--[[
		1: Normal
		2: Text
		3: HTML
		4: BB Code
	]]
	
	local outDump = "";
	local prevDate = "";
	

	for i = 1, table.getn(WIM_History[theUser]) do
		if(WIM_HistoryView_Filter_Selected == "" or WIM_HistoryView_Filter_Selected == WIM_History[theUser][i].date) then
			if(WIM_HistoryView_Filter_Selected == "") then
				if(prevDate ~= WIM_History[theUser][i].date) then
					prevDate = WIM_History[theUser][i].date
					if(theFormat == 1) then
						WIM_HistoryFrameMessageListScrollingMessageFrame:AddMessage(" ");
						WIM_HistoryFrameMessageListScrollingMessageFrame:AddMessage("|cffffffff["..prevDate.."]|r");
					elseif(theFormat == 2) then
						outDump = outDump.."\r\n["..prevDate.."]\r\n";
					elseif(theFormat == 3) then
						outDump = outDump.."<br /><span class=\"WIMmsgSys\">["..prevDate.."]</span><br /><br />\n";
					elseif(theFormat == 4) then	
						outDump = outDump.."\r\n[color=#"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b).."]["..prevDate.."][/color]\n\n";
					end
				end
			end
			
			if(WIM_History[theUser][i].type == 1) then
				if(theFormat == 1) then
					tStamp = "|cff"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b)..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."|r ";
					tFrom = "[|Hplayer:"..WIM_History[theUser][i].from.."|h"..WIM_GetAlias(WIM_History[theUser][i].from, true).."|h]: ";
					tMsg = tStamp..tFrom..WIM_FilterEmoticons(WIM_History[theUser][i].msg);
					WIM_HistoryFrameMessageListScrollingMessageFrame:AddMessage(tMsg, WIM_Data.displayColors.wispIn.r, WIM_Data.displayColors.wispIn.g, WIM_Data.displayColors.wispIn.b);
				elseif(theFormat == 2) then
					outDump = outDump..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."["..WIM_History[theUser][i].from.."]: "..WIM_History[theUser][i].msg.."\r\n";
				elseif(theFormat == 3) then
					outDump = outDump.."<span class=\"WIMmsgSys\">"..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."</span>&nbsp;<span class=\"WIMmsgIn\">["..WIM_History[theUser][i].from.."]:&nbsp;"..WIM_History_ExportLinkHTML(WIM_History[theUser][i].msg).."</span><br />\n";
				elseif(theFormat == 4) then
					outDump = outDump.."[color=#"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b).."]"..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."[/color] [color=#"..WIM_RGBtoHex(WIM_Data.displayColors.wispIn.r, WIM_Data.displayColors.wispIn.g, WIM_Data.displayColors.wispIn.b).."]["..WIM_History[theUser][i].from.."]: "..WIM_History_ExportLinkBBCode(WIM_History[theUser][i].msg).."[/color]\n";
				end
			elseif(WIM_History[theUser][i].type == 2) then
				if(theFormat == 1) then
					tStamp = "|cff"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b)..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."|r ";
					tFrom = "[|Hplayer:"..WIM_History[theUser][i].from.."|h"..WIM_GetAlias(WIM_History[theUser][i].from, true).."|h]: ";
					tMsg = tStamp..tFrom..WIM_FilterEmoticons(WIM_History[theUser][i].msg);
					WIM_HistoryFrameMessageListScrollingMessageFrame:AddMessage(tMsg, WIM_Data.displayColors.wispOut.r, WIM_Data.displayColors.wispOut.g, WIM_Data.displayColors.wispOut.b);
				elseif(theFormat == 2) then
					outDump = outDump..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."["..WIM_History[theUser][i].from.."]: "..WIM_History[theUser][i].msg.."\r\n";
				elseif(theFormat == 3) then
					outDump = outDump.."<span class=\"WIMmsgSys\">"..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."</span>&nbsp;<span class=\"WIMmsgOut\">["..WIM_History[theUser][i].from.."]:&nbsp;"..WIM_History_ExportLinkHTML(WIM_History[theUser][i].msg).."</span><br />\n";
				elseif(theFormat == 4) then
					outDump = outDump.."[color=#"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b).."]"..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).."[/color] [color=#"..WIM_RGBtoHex(WIM_Data.displayColors.wispOut.r, WIM_Data.displayColors.wispOut.g, WIM_Data.displayColors.wispOut.b).."]["..WIM_History[theUser][i].from.."]: "..WIM_History_ExportLinkBBCode(WIM_History[theUser][i].msg).."[/color]\n";
				end
			end
		end
	end
	if(theFormat ~= 1) then WIM_HistoryViewerExportFormatText:SetText(WIM_HistoryViewerExportFormatText:GetText()..outDump); end
end

function WIM_HistoryView_ShowMessages()
	local tStamp = "";
	local tFrom = "";
	local tMsg = "";
	local prevDate = "";
	local outDump = "";
	
	if( WIM_History_ExportFormatVal == 3 ) then
		outDump = outDump.."<style type=\"text/css\">\n";
		outDump = outDump.."<!--\n";
		outDump = outDump..".WIMmsgIn {\n";
		outDump = outDump.."	color: #"..WIM_RGBtoHex(WIM_Data.displayColors.wispIn.r, WIM_Data.displayColors.wispIn.g, WIM_Data.displayColors.wispIn.b)..";\n";
		outDump = outDump.."}\n";
		outDump = outDump..".WIMmsgOut {\n";
		outDump = outDump.."	color: #"..WIM_RGBtoHex(WIM_Data.displayColors.wispOut.r, WIM_Data.displayColors.wispOut.g, WIM_Data.displayColors.wispOut.b)..";\n";
		outDump = outDump.."}\n";
		outDump = outDump..".WIMmsgSys {\n";
		outDump = outDump.."	color: #"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b)..";\n";
		outDump = outDump.."}\n";
		outDump = outDump.."-->\n";
		outDump = outDump.."</style>\n\n";
	end
	
	WIM_HistoryViewerExportFormatText:SetText(outDump);
	
	WIM_HistoryFrameMessageListScrollingMessageFrame:Clear();
	if(WIM_History[WIM_HistoryView_Name_Selected] or WIM_HistoryView_Name_Selected == "*all*") then
		if(WIM_HistoryView_Name_Selected == "*all*") then
			for key, _ in pairs(WIM_History) do
				WIM_HistoryView_ProcMsgFormat(key, WIM_History_ExportFormatVal);
			end
		else
			WIM_HistoryView_ProcMsgFormat(WIM_HistoryView_Name_Selected, WIM_History_ExportFormatVal);
		end
	end
	WIM_UpdateScrollBars(WIM_HistoryFrameMessageListScrollingMessageFrame);
	
	-- Autoselect text
	if(WIM_History_ExportFormatVal ~= 1) then
		WIM_HistoryViewerExportFormatText:HighlightText(0);
	end
end


function WIM_History_AlreadyInTable(theTable, theItem)
	for i = 1, table.getn(theTable) do
		if(theTable[i] == theItem) then
			return true;
		end
	end
	return false;
end


function WIM_History_ExportFormat_OnShow()
	UIDropDownMenu_Initialize(this, WIM_History_ExportFormat_Initialize);
	UIDropDownMenu_SetSelectedValue(this, WIM_History_ExportFormatVal);
	UIDropDownMenu_SetWidth(100, WIM_HistoryExportFormatMenu);
end

function WIM_History_ExportFormat_Initialize()
	local info = {};
	info = { };
	info.text = "Normal View";
	info.value = 1;
	info.justifyH = "LEFT";
	info.func = WIM_History_ExportFormatClick;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = { };
	info.text = "Raw Text";
	info.value = 2;
	info.justifyH = "LEFT";
	info.func = WIM_History_ExportFormatClick;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = { };
	info.text = "HTML";
	info.value = 3;
	info.justifyH = "LEFT";
	info.func = WIM_History_ExportFormatClick;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = { };
	info.text = "BB Code";
	info.value = 4;
	info.justifyH = "LEFT";
	info.func = WIM_History_ExportFormatClick;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
end

function WIM_History_ExportFormatClick()
	WIM_History_ExportFormatVal = this.value;
	UIDropDownMenu_SetSelectedValue(WIM_HistoryExportFormatMenu, WIM_History_ExportFormatVal);
	WIM_HistoryView_ShowMessages();
	if(this.value == 1) then
		WIM_HistoryViewerExportFormat:Hide();
		WIM_HistoryFrameMessageListScrollingMessageFrame:Show();
		WIM_HistoryFrameMessageListScrollUp:Show();
		WIM_HistoryFrameMessageListScrollDown:Show();
	else
		WIM_HistoryViewerExportFormat:Show();
		WIM_HistoryFrameMessageListScrollingMessageFrame:Hide();
		WIM_HistoryFrameMessageListScrollUp:Hide();
		WIM_HistoryFrameMessageListScrollDown:Hide();
	end
end


function WIM_History_ExportLinkHTML(theLine)
	theLine = string.gsub(theLine, "|cff(%w+)|Hitem:(%d+):[%d:%-]+|h%[([%w %-':]+)%]|h|r", "<a href=\"http://www.wowhead.com/?item=%2\" style=\"color:#%1; text-decoration: none; font-weight: bold;\" target=\"top_\">[%3]</a>");
	return theLine;
end

function WIM_History_ExportLinkBBCode(theLine)
	theLine = string.gsub(theLine, "|cff(%w+)|Hitem:(%d+):[%d:%-]+|h%[([%w %-':]+)%]|h|r", "[url=http://www.wowhead.com/?item=%2][color=#%1][b][%3][/b][/color][/url]");
	return theLine;
end