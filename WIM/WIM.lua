--[[
	WIM (WoW Instant Messenger)
	Author: John Langone (Pazza - Bronzebeard)
	Website: http://www.wimaddon.com

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn`s source code is specifically designed to work with
		World of Warcraft`s interpreted AddOn system.
		You have an implicit licence to use this AddOn with these facilities
		since that is it`s designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]

WIM_VERSION     = "2.4.15";
WIM_W2W_VERSION = "1.1.0";
WIM_SKINNER_VERSION = "1.0.0";
WIM_IS_BETA = false; -- this is added so people aren't annoyed with version update messages during beta periods.


WIM_Windows = {};
WIM_EditBoxInFocus = nil;
WIM_NewMessageFlag = false;
WIM_NewMessageCount = 0;
WIM_Icon_TheMenu = nil;
WIM_Icon_UpdateInterval = .5;
WIM_CascadeStep = 0;
WIM_MaxMenuCount = 20;
WIM_ClassIcons = {};
WIM_ClassColors = {};
WIM_MSGBOX_MENU_CUR_USER = "";
WIM_MSGBOX_MENU_EMOTES_PER_PAGE = 10;


WIM_Plugins = {};
--version
--optionsFrame
--interceptInboundFunction
--interceptOutboundFunction

WIM_SpamCheck_LastMSG = "";

WIM_SHORTCUTBAR_COUNT = 0;

WIM_OptionsIsLoaded = false;

WIM_WhoLookUp_Elapsed = 0;

WIM_AddonWhoCheck = {
	waiting = false,
	cache = {},
	stamp = 0,
	count = 0;
}

WIM_Astrolabe = DongleStub("Astrolabe-0.4");
WIM_Deformat = AceLibrary("Deformat-2.0");

local BT =  AceLibrary:HasInstance("Babble-SpellTree-2.2") and AceLibrary("Babble-SpellTree-2.2")
WIM_SpellTree = {};

-- Data structure for storing WIM-2-WIM data
WIM_W2W = {};
WIM_W2W_Commands = {};

-- Data structure for update check management
WIM_UpdateCheck = {
	newVersion = false,
	guild = false,
	party = false,
	raid = false
}

WIM_CronJobs = {};
--[[format
	cronName = {
		inverval = seconds,
		theFunction = function(),
		elapsed = 0
	};
]]

-- Data structure for window fading
WIM_FadeQueue = {
	fadeIn = {},
	fadeOut = {},
	fadeOutDelayed = {}
};

-- Data structure for tab management.
WIM_Tabs = {
	enabled = true,
	minWidth = 75,
	lastParent = nil,
	anchorSelf = "BOTTOMLEFT",
	anchorRelative = "TOPLEFT",
	topOffset = -4,
	marginLeft = 38,
	marginRight = 15,
	x = -1,
	y = -1,
	tabs = {},
	selectedUser = "";
	offset = 0,
	visibleCount = 0,
	lastShown = nil,
	sortBy = 0, -- 0-> default (order received); 1-> Alphabetical; 2-> Activity;
}

WIM_AlreadyCheckedGuildRoster = false;

WIM_GM_Cache = {};

WIM_GuildList = {};  --[Linked to WIM_Cache
WIM_FriendList = {}; --[Linked to WIM_Cache

WIM_Alias = {};
WIM_Filters = nil;
	
WIM_ToggleWindow_Timer = 0;
WIM_ToggleWindow_Index = 1;

WIM_RecentList = {}; --[Not saved between sessions: Store's list of recent conversations.

WIM_URL_MATCHED_PATTERNS = {};
WIM_URL_Patterns = {
	-- X@X.Y url (---> email)
	"^(www%.[%w_-]+%.%S+[^%p%s])",
	"%s(www%.[%w_-]+%.%S+[^%p%s])",
	-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU url
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?/%S+[^%p%s])",
	-- XXX.YYY.ZZZ.WWW:VVVV url (IP of ts server for example)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?:%d%d?%d?%d?%d?)", 
	-- XXX.YYY.ZZZ.WWW/VVVVV url (---> IP)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?/%S+[^%p%s])", 
	-- XXX.YYY.ZZZ.WWW url (---> IP)
	"^(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)", 
	"%s(%d%d?%d?%.%d%d?%d?%.%d%d?%d?%.%d%d?%d?)",
	-- X.Y.Z:WWWW/VVVVV url
	"^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])", 
	"%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?/%S+[^%p%s])", 
	-- X.Y.Z:WWWW url  (ts server for example)
	"^([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)", 
	"%s([%w_.-]+[%w_-]%.%a%a+:%d%d?%d?%d?%d?)", 
	-- X.Y.Z/WWWWW url
	"^([%w_.-]+[%w_-]%.%a%a+/%S+[^%p%s])", 
	"%s([%w_.-]+[%w_-]%.%a%a+/%S+[^%p%s])", 
	-- X.Y.Z url
	"^([%w_.-]+[%w_-]%.%a%a+)", 
	"%s([%w_.-]+[%w_-]%.%a%a+)", 
	-- X://Y url
	"(%a+://[%d%w_-%.]+[%.%d%w_%-%/%?%%%=%;%:%+%&]*)", 
};	
	
WIM_History = {};

WIM_TimeStamp_Formats = {
	t01 = "%I:%M",		-- HH:MM (12hr)
	t02 = "%I:%M %p",	-- HH:MM AM/PM (12hr)
	t03 = "%H:%M",		-- HH:MM (24hr)
	t04 = "%I:%M:%S",	-- HH:MM:SS (12hr)
	t05 = "%I:%M:%S %p",	-- HH:MM:SS AM/PM (12hr)
	t06 = "%H:%M:%S"	-- HH:MM:SS (24hr)
};

WIM_TimeOuts = {
	to1 = 300 * 1, -- 5m
	to2 = 300 * 2, -- 10m
	to3 = 300 * 3, -- 15m
	to4 = 300 * 6, -- 30m
	to5 = 300 * 12 -- 60m
};

WIM_Data_DEFAULTS = {
	versionLastLoaded = "",
	tabMode = false,
	tabSortType = 0,
	showChangeLogOnNewVersion = true,
	enableWIM = true,
	iconPosition=337,
	showMiniMap=true,
	displayColors = {
		wispIn = {
				r=0.5607843137254902, 
				g=0.03137254901960784, 
				b=0.7607843137254902
			},
		wispOut = {
				r=1, 
				g=0.07843137254901961, 
				b=0.9882352941176471
			},
		sysMsg = {
				r=1, 
				g=0.6627450980392157, 
				b=0
			},
		errorMsg = {
				r=1, 
				g=0, 
				b=0
			},
		webAddress = {
				r=0, 
				g=0, 
				b=1
			},
	},
	fontSize = 12,
	windowSize = 1,
	windowAlpha = .8,
	windowOnTop = true,
	windowFade = false,
	supressWisps = true,
	suppressExceptInCombat = true,
	keepFocus = true,
	keepFocusRested = true,
	popNew = true,
	popUpdate = true,
	popOnSend = true,
	popCombat = true,
	autoFocus = false,
	playSoundWisp = true,
	showToolTips = true,
	sortAlpha = false,
	winSize = {
		width = 384,
		height = 256
	},
	winLoc = {
		left =242 ,
		top =775
	},
	winCascade = {
		enabled = true,
		direction = "downright"
	},
	miniFreeMoving = {
		enabled = false;
		left = 0,
		top = 0
	},
	characterInfo = {
		show = true,
		classIcon = true,
		details = true,
		classColor = true
	},
	showTimeStamps = true,
	timeStampFormat = "t03",
	showShortcutBar = true,
	showShortcutBarButton = {
		target = true,
		invite = true,
		trade = true,
		inspect = true,
		follow = true,
		duel = true,
		friend = true,
		location = true,
		ignore = true
	},
	enableAlias = true,
	enableFilter = true,
	aliasAsComment = true,
	enableHistory = true,
	historySettings = {
		recordEveryone = false,
		recordFriends = true,
		recordGuild = true,
		colorIn = {
				r=0.4705882352941176,
				g=0.4705882352941176,
				b=0.4705882352941176
		},
		colorOut = {
				r=0.7058823529411764,
				g=0.7058823529411764,
				b=0.7058823529411764
		},
		popWin = {
			enabled = true,
			count = 25
		},
		maxMsg = {
			enabled = true,
			count = 200
		},
		autoDelete = {
			enabled = true,
			days = 7
		}
	},
	showAFK = true,
	useEscape = true,
	hookWispParse = true,
	msgTimeOut = {
		friends = false,
		fTO = "to4",
		other = false,
		oTO = "to3"
	},
	ignoreArrowKeys = true,
	menuOnRightClick = true,
	updateCheck = true,
	w2w = {
		enabled = true,
		typing = true
	},
	skin = {
		selected = "WIM Classic",
		style = "default",
		font = "ChatFontNormal",
		font_outline = ""
	},
	prat_compat = true,
	emoticons = true,
	hover_links = false
};
--[initialize defualt values
WIM_Data = WIM_Data_DEFAULTS;

WIM_CascadeDirection = {
	up = {
		left = 0,
		top = 25
	},
	down = {
		left = 0,
		top = -25
	},
	left = {
		left = -50,
		top = 0
	},
	right = {
		left = 50,
		top = 0
	},
	upleft = {
		left = -50,
		top = 25
	},
	upright = {
		left = 50,
		top = 25
	},
	downleft = {
		left = -50,
		top = -25
	},
	downright = {
		left = 50,
		top = -25
	}
};

WIM_IconItems = { };

function WIM_OnLoad()
	SlashCmdList["WIM"] = WIM_SlashCommand;
	SLASH_WIM1 = "/wim";
end


------------------------------------------------------------
--               Core Functions  & Events
------------------------------------------------------------

function WIM_InitiateCache()
	local realm = GetCVar("realmName");
	local char = UnitName("player");
	
	if(type(WIM_Cache) ~= "table") then
		WIM_Cache = {};
	end
	if(not WIM_Cache[realm]) then
		WIM_Cache[realm] = {};
	end
	if(not WIM_Cache[realm][char]) then
		WIM_Cache[realm][char] = {};
	end
	
	if(WIM_Cache[realm][char].friendList) then
		WIM_FriendList = WIM_Cache[realm][char].friendList;
	end
	if(WIM_Cache[realm][char].guildList) then
		WIM_GuildList = WIM_Cache[realm][char].guildList;
	end
end

function WIM_Incoming(event)
	--[Events
	if(event == "VARIABLES_LOADED") then
		WIM_InitiateCache();
	
		if(WIM_Data.enableWIM == nil) then WIM_Data.enableWIM = WIM_Data_DEFAULTS.enableWIM; end;
		if(WIM_Data.versionLastLoaded == nil) then WIM_Data.versionLastLoaded = ""; end;
		if(WIM_Data.showChangeLogOnNewVersion == nil) then WIM_Data.showChangeLogOnNewVersion = WIM_Data_DEFAULTS.showChangeLogOnNewVersion; end;
		if(WIM_Data.displayColors == nil) then WIM_Data.displayColors = WIM_Data_DEFAULTS.displayColors; end;
		if(WIM_Data.displayColors.sysMsg == nil) then WIM_Data.displayColors.sysMsg = WIM_Data_DEFAULTS.displayColors.sysMsg; end;
		if(WIM_Data.displayColors.errorMsg == nil) then WIM_Data.displayColors.errorMsg = WIM_Data_DEFAULTS.displayColors.errorMsg; end;
		if(WIM_Data.fontSize == nil) then WIM_Data.fontSize = WIM_Data_DEFAULTS.fontSize; end;
		if(WIM_Data.windowSize == nil) then WIM_Data.windowSize = WIM_Data_DEFAULTS.windowSize; end;
		if(WIM_Data.windowAlpha == nil) then WIM_Data.windowAlpha = WIM_Data_DEFAULTS.windowAlpha; end;
		if(WIM_Data.supressWisps == nil) then WIM_Data.supressWisps = WIM_Data_DEFAULTS.supressWisps; end;
		if(WIM_Data.keepFocus == nil) then WIM_Data.keepFocus = WIM_Data_DEFAULTS.keepFocus; end;
		if(WIM_Data.keepFocusRested == nil) then WIM_Data.keepFocusRested = WIM_Data_DEFAULTS.keepFocusRested; end;
		if(WIM_Data.popNew == nil) then WIM_Data.popNew = WIM_Data_DEFAULTS.popNew; end;
		if(WIM_Data.popUpdate == nil) then WIM_Data.popNew = WIM_Data_DEFAULTS.popUpdate; end;
		if(WIM_Data.autoFocus == nil) then WIM_Data.autoFocus = WIM_Data_DEFAULTS.autoFocus; end;
		if(WIM_Data.playSoundWisp == nil) then WIM_Data.playSoundWisp = WIM_Data_DEFAULTS.playSoundWisp; end;
		if(WIM_Data.showToolTips == nil) then WIM_Data.showToolTips = WIM_Data_DEFAULTS.showToolTips; end;
		if(WIM_Data.sortAlpha == nil) then WIM_Data.sortAlpha = WIM_Data_DEFAULTS.sortAlpha; end;
		if(WIM_Data.winSize == nil) then WIM_Data.winSize = WIM_Data_DEFAULTS.winSize; end;
		if(WIM_Data.miniFreeMoving == nil) then WIM_Data.miniFreeMoving = WIM_Data_DEFAULTS.miniFreeMoving; end;
		if(WIM_Data.popCombat == nil) then WIM_Data.popCombat = WIM_Data_DEFAULTS.popCombat; end;
		if(WIM_Data.characterInfo == nil) then WIM_Data.characterInfo = WIM_Data_DEFAULTS.characterInfo; end;
		if(WIM_Data.showTimeStamps == nil) then WIM_Data.showTimeStamps = WIM_Data_DEFAULTS.showTimeStamps; end;
		if(WIM_Data.showShortcutBar == nil) then WIM_Data.showShortcutBar = WIM_Data_DEFAULTS.showShortcutBar; end;
		if(WIM_Data.enableAlias == nil) then WIM_Data.enableAlias = WIM_Data_DEFAULTS.enableAlias; end;
		if(WIM_Data.enableFilter == nil) then WIM_Data.enableFilter = WIM_Data_DEFAULTS.enableFilter; end;
		if(WIM_Data.aliasAsComment == nil) then WIM_Data.aliasAsComment = WIM_Data_DEFAULTS.aliasAsComment; end;
		if(WIM_Data.enableHistory == nil) then WIM_Data.enableHistory = WIM_Data_DEFAULTS.enableHistory; end;
		if(WIM_Data.historySettings == nil) then WIM_Data.historySettings = WIM_Data_DEFAULTS.historySettings; end;
		if(WIM_Data.winLoc == nil) then WIM_Data.winLoc = WIM_Data_DEFAULTS.winLoc; end;
		if(WIM_Data.winCascade == nil) then WIM_Data.winCascade = WIM_Data_DEFAULTS.winCascade; end;
		if(WIM_Data.popOnSend == nil) then WIM_Data.popOnSend = WIM_Data_DEFAULTS.popOnSend; end;
		if(WIM_Data.versionLastLoaded == nil) then WIM_Data.versionLastLoaded = WIM_Data_DEFAULTS.versionLastLoaded; end;
		if(WIM_Data.showAFK == nil) then WIM_Data.showAFK = WIM_Data_DEFAULTS.showAFK; end;
		if(WIM_Data.useEscape == nil) then WIM_Data.useEscape = WIM_Data_DEFAULTS.useEscape; end;
		if(WIM_Data.hookWispParse == nil) then WIM_Data.hookWispParse = WIM_Data_DEFAULTS.hookWispParse; end;
		if(WIM_Data.showShortcutBarButton == nil) then WIM_Data.showShortcutBarButton = WIM_Data_DEFAULTS.showShortcutBarButton; end;
		if(WIM_Data.showShortcutBarButton.friend == nil) then WIM_Data.showShortcutBarButton.friend = WIM_Data_DEFAULTS.showShortcutBarButton.friend; end;
		if(WIM_Data.showShortcutBarButton.location == nil) then WIM_Data.showShortcutBarButton.location = WIM_Data_DEFAULTS.showShortcutBarButton.location; end;
		if(WIM_Data.timeStampFormat == nil) then WIM_Data.timeStampFormat = WIM_Data_DEFAULTS.timeStampFormat; end;
		if(WIM_Data.msgTimeOut == nil) then WIM_Data.msgTimeOut = WIM_Data_DEFAULTS.msgTimeOut; end;
		if(WIM_Data.ignoreArrowKeys == nil) then WIM_Data.ignoreArrowKeys = WIM_Data_DEFAULTS.ignoreArrowKeys; end;
		if(WIM_Data.menuOnRightClick == nil) then WIM_Data.menuOnRightClick = WIM_Data_DEFAULTS.menuOnRightClick; end;
		if(WIM_Data.tabMode == nil) then WIM_Data.tabMode = WIM_Data_DEFAULTS.tabMode; end;
		if(WIM_Data.updateCheck == nil) then WIM_Data.updateCheck = WIM_Data_DEFAULTS.updateCheck; end;
		if(WIM_Data.tabSortType == nil) then WIM_Data.tabSortType = WIM_Data_DEFAULTS.tabSortType; end;
		if(WIM_Data.windowOnTop == nil) then WIM_Data.windowOnTop = WIM_Data_DEFAULTS.windowOnTop; end;
		if(WIM_Data.suppressExceptInCombat == nil) then WIM_Data.suppressExceptInCombat = WIM_Data_DEFAULTS.suppressExceptInCombat; end;
		if(WIM_Data.windowFade == nil) then WIM_Data.windowFade = WIM_Data_DEFAULTS.windowFade; end;
		if(WIM_Data.w2w == nil) then WIM_Data.w2w = WIM_Data_DEFAULTS.w2w; end;
		if(WIM_Data.w2w.typing == nil) then WIM_Data.w2w.typing = WIM_Data_DEFAULTS.w2w.typing; end;
		if(WIM_Data.skin == nil) then WIM_Data.skin = WIM_Data_DEFAULTS.skin; end;
		if(WIM_Data.skin.font_outline == nil) then WIM_Data.skin.font_outline = WIM_Data_DEFAULTS.skin.font_outline; end
		if(WIM_Data.prat_compat == nil) then WIM_Data.prat_compat = WIM_Data_DEFAULTS.prat_compat; end
		if(WIM_Data.emoticons == nil) then WIM_Data.emoticons = WIM_Data_DEFAULTS.emoticons; end
		if(WIM_Data.hover_links == nil) then WIM_Data.hover_links = WIM_Data_DEFAULTS.hover_links; end
		
		if(WIM_Filters == nil) then
			WIM_LoadDefaultFilters();
		end
		
		WIM_TabStrip:SetWidth(WIM_Data.winSize.width);
		WIM_Tabs.sortType = WIM_Data.tabSortType;
		
		WIM_API_AddCronJob("wimTimeOutCleanUp", WIM_TimeOutCleanUp, 10);
		WIM_API_AddCronJob("wimSendAddonUpdateChecks", WIM_SendAddonUpdateChecks, 10);
		WIM_API_AddCronJob("wimAutoWhoCheck", WIM_AutoWhoCheck, 10);
		WIM_API_AddCronJob("wimW2WPositionCheck", WIM_W2W_CronJob_POSITION, 5);
		WIM_API_AddCronJob("wimW2WCleanUp", WIM_W2W_CronJob_CleanUp, 10);
		
		--ShowFriends(); --[update friend list
		if(IsInGuild()) then 
			GuildRoster(); --[update guild roster
		end;
		
		WIM_W2W_Initialize();
		WIM_Skinner_Initialize();
		
		ItemRefTooltip:SetFrameStrata("TOOLTIP");
		
		WIM_HistoryPurge();
		
		WIM_InitClassProps();
		
		WIM_SetWIM_Enabled(WIM_Data.enableWIM);
		
		WIM_ToggleTabMode(WIM_Data.tabMode);
		
		WIM_W2W_LoadCommandList();
		
		if(WIM_VERSION ~= WIM_Data.versionLastLoaded) then
			WIM_LoadDefaultFilters();
			WIM_HelpShow();
		end
		WIM_Data.versionLastLoaded = WIM_VERSION;
		
		
		
		
		if(WIM_Data.showMiniMap == false) then
				WIM_IconFrame:Hide();
		else
			if(WIM_Data.miniFreeMoving.enabled) then
				WIM_IconFrame:SetParent(UIParent);
				WIM_IconFrame:Show();
				WIM_IconFrame:SetFrameStrata("HIGH");
				WIM_IconFrame:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT",WIM_Data.miniFreeMoving.left,WIM_Data.miniFreeMoving.top);
			else
				WIM_Icon_UpdatePosition();
			end
		end
		
	elseif(event == "GUILD_ROSTER_UPDATE") then
		WIM_LoadGuildList();
		WIM_AlreadyCheckedGuildRoster = true;
	elseif(event == "FRIENDLIST_SHOW" or event == "FRIENDLIST_UPDATE") then
		WIM_LoadFriendList();
		WIM_SetAllWindowProps();
	elseif(event == "ADDON_LOADED") then
		WIM_AddonDetectToHook(arg1);
	else
		if(WIM_AlreadyCheckedGuildRoster == false) then
			if(IsInGuild()) then GuildRoster(); end; --[update guild roster
		end
	end
end

-- This chunk of code utilized ChatFrame_MessageEventFilter API's in order to suppress whispers to the chat frame.
function WIM_ChatFrame_MessageEventFilter_WHISPERS(msg)
	local filterResult = 0; -- initially, all messages may pass.
	if(arg6 ~= "GM") then
		filterResult = WIM_FilterResult_Interface(arg1, arg2, event == "CHAT_MSG_WHISPER", false, arg11);
	end
	if(filterResult == 2) then
		--filter says to block
		return true, msg;
	elseif(filterResult == 1) then
		--WIM is ignoring, let message pass as normal.
		return false, msg;
	end
	if(WIM_Data.supressWisps) then
		if(WIM_Data.suppressExceptInCombat) then
			local isNew = true;
			if(WIM_Windows[arg2]) then isNew = false; end
			if(WIM_PopOrNot(isNew) == false and UnitAffectingCombat("player")) then
				if(isNew) then
					-- message is new, we already know it isn't visible. don't suppress.
					return false, msg;
				elseif(getglobal(WIM_Windows[arg2].frame):IsVisible()) then
					-- window is visible, suppress as normal.
					return true, msg;
				else
					-- do not suppress, user wishes to see messages at this junction.
					return false, msg;
				end
			else
				-- not in combat, suppress as usual.
				return true, msg;
			end
		else
			-- suppress always. no exceptions
			return true, msg;
		end
	end
end

function WIM_ChatFrame_MessageEventFilter_AFK_DND(msg)
	if(WIM_Windows[arg2] and WIM_Data.supressWisps and WIM_Windows[arg2].is_visible == true and WIM_Data.showAFK) then
		return true, msg;
	else
		return false, msg;
	end
end

function WIM_ChatFrame_MessageEventFilter_SYSTEM(msg)
	if(WIM_Data.supressWisps) then
		local theUser = "";
		-- detect player not online message
		local pattern = ERR_CHAT_PLAYER_NOT_FOUND_S;
		theUser = WIM_ExtractNameFromPattern(arg1, ERR_CHAT_PLAYER_NOT_FOUND_S);
		if(theUser ~= "" and WIM_Windows[theUser] ~= nil) then
			if(getglobal(WIM_Windows[theUser].frame):IsVisible()) then
				return true, msg;
			end
		else
			pattern = CHAT_IGNORED;
			theUser = WIM_ExtractNameFromPattern(arg1, CHAT_IGNORED);
			if(theUser ~= "" and WIM_Windows[theUser] ~= nil) then
				if(getglobal(WIM_Windows[theUser].frame):IsVisible()) then
					return true, msg;
				end
			end
		end
		return false, msg;
	else
		return false, msg;
	end
end

function WIM_HonorChatFrameEventFilter(event, msg)
	local chatFilters = ChatFrame_GetMessageEventFilters(event);
	if chatFilters then 
		local filter, newmsg = false;
		for _, filterFunc in next, chatFilters do
			-- first make sure, we aren't doubling up on events. We don't need WIM to do its own twice.
			if(filterFunc ~= WIM_ChatFrame_MessageEventFilter_WHISPERS) then
				filter, newmsg = filterFunc(msg);
				if filter then 
					return true; 
				end 
			end
		end 
	end 
	return false;
end

--------------------------------------


function WIM_MessageEventHandler(event)
	local msg = "";
	local filterResult;
	
	if((event == "CHAT_MSG_AFK" or event == "CHAT_MSG_DND") and WIM_Data.showAFK) then
		local afkType;
		if( event == "CHAT_MSG_AFK" ) then
			afkType = WIM_LOCALIZED_AFK;
		else
			afkType = WIM_LOCALIZED_DND;
		end
		msg = "<"..afkType.."> |Hplayer:"..arg2.."|h"..arg2.."|h: "..arg1;
		WIM_PostMessage(arg2, msg, 3);
		if(WIM_Windows[arg2] and WIM_Data.supressWisps and WIM_Windows[arg2].is_visible == true) then
			ChatEdit_SetLastTellTarget(arg2);
		end	
	elseif(event == "CHAT_MSG_WHISPER") then
		if(arg6 ~= "GM") then filterResult = WIM_FilterResult_Interface(arg1, arg2, true, true, arg11); end
		if(filterResult ~= 1 and filterResult ~= 2) then
			msg = "[|Hplayer:"..arg2..":"..arg11.."|h"..WIM_GetAlias(arg2, true).."|h]: "..arg1;
			if(arg6 == "GM") then
				WIM_GM_Cache[arg2] = 1;
				ChatEdit_SetLastTellTarget(arg2);
				WIM_PostMessage("<GM> "..arg2, msg, 1, arg2, arg1);
			else
				if(not WIM_HonorChatFrameEventFilter("CHAT_MSG_WHISPER" ,arg1)) then
					ChatEdit_SetLastTellTarget(arg2);
					WIM_PostMessage(arg2, msg, 1, arg2, arg1, false, arg11);
				end
			end
		end
	elseif(event == "CHAT_MSG_WHISPER_INFORM") then
		filterResult = WIM_FilterResult_Interface(arg1, arg2, false, true);
		if(filterResult ~= 1 and filterResult ~= 2) then
			if(not WIM_HonorChatFrameEventFilter("CHAT_MSG_WHISPER_INFORM" ,arg1)) then
				msg = "[|Hplayer:"..UnitName("player").."|h"..WIM_GetAlias(UnitName("player"), true).."|h]: "..arg1;
				ChatEdit_SetLastToldTarget(arg2);
				WIM_PostMessage(arg2, msg, 2, UnitName("player") ,arg1);
			end
			WIM_Windows[WIM_FormatName(arg2)].isOnline = true;
		end
	elseif(event == "CHAT_MSG_SYSTEM") then
                WIM_CatchOnlineOffline(arg1);
		local theUser = "";
		-- detect player not online message
		local pattern = ERR_CHAT_PLAYER_NOT_FOUND_S;
		theUser = WIM_ExtractNameFromPattern(arg1, ERR_CHAT_PLAYER_NOT_FOUND_S);
		if(theUser ~= "" and WIM_Windows[theUser] ~= nil) then
			WIM_Windows[theUser].isOnline = false;
			--if(WIM_Windows[theUser].sent_tell == false) then return false; end
			WIM_PostMessage(theUser, arg1, 4);
		end
		pattern = CHAT_IGNORED;
		theUser = WIM_ExtractNameFromPattern(arg1, CHAT_IGNORED);
		if(theUser ~= "" and WIM_Windows[theUser] ~= nil) then
			WIM_Windows[theUser].isOnline = false;
			--if(WIM_Windows[theUser].sent_tell == false) then return false; end
			WIM_PostMessage(theUser, arg1, 4);
		end
	elseif(event == "CHAT_MSG_ADDON" and arg1 == "WIM") then
		WIM_AddonMessageHandler(arg2, arg3, arg4);
	elseif(event == "CHAT_MSG_ADDON" and arg1 == "WIM_W2W") then	
		WIM_W2W_AddonMessageHandler(arg2, arg4);
	end
end

function WIM_ExtractNameFromPattern(theString, thePattern)
	local var1, _ = WIM_Deformat(theString, thePattern)
	if(var1) then
		return WIM_FormatName(var1);
	else
		return "";
	end
end


function WIM_SlashCommand(msg)
	if(msg == "reset") then
		WIM_Data = WIM_Data_DEFAULTS;
	elseif(msg == "clear history") then
		WIM_History = {};
	elseif(msg == "reset filters") then
		WIM_LoadDefaultFilters();
	elseif(msg == "history") then
		WIM_HistoryFrame:Show();
	elseif(msg == "help") then
		WIM_HelpShow();
	elseif(msg == "who") then
		WIM_AddonWhoCheck.waiting = true;
		WIM_AddonWhoCheck.stamp = time();
		WIM_AddonWhoCheck.count = 0;
		WIM_SendAddonMessage("WHO#HAS WIM?");
	elseif(msg == "ontop") then
		WIM_Data.windowOnTop = not WIM_Data.windowOnTop;
		WIM_SetAllWindowProps();
		if(WIM_Data.windowOnTop) then
			DEFAULT_CHAT_FRAME:AddMessage("WIM: ONTOP -> ON");
		else
			DEFAULT_CHAT_FRAME:AddMessage("WIM: ONTOP -> OFF");
		end
	elseif(msg == "rl") then
		ReloadUI();
	elseif(msg == "memory_usage") then
		UpdateAddOnMemoryUsage();
		DEFAULT_CHAT_FRAME:AddMessage("WIM Memory Usage: "..GetAddOnMemoryUsage("WIM").."k");
	elseif(msg == "debug_skin") then
		WIM_ShowSkinDebug();
	elseif(msg == "prat") then
		WIM_Data.prat_compat = not WIM_Data.prat_compat;
		if(WIM_Data.prat_compat) then
			DEFAULT_CHAT_FRAME:AddMessage("WIM: PRAT COMPATIBILITY -> ON");
		else
			DEFAULT_CHAT_FRAME:AddMessage("WIM: PRAT COMPATIBILITY -> OFF");
		end
	else
		WIM_OptionsShow();
	end
end

function WIM_TimeOutCleanUp()
	-- first see if any work is being asked to be done.
	if( WIM_Data.msgTimeOut.friends == false and WIM_Data.msgTimeOut.other == false ) then return; end
	
	-- scan through each message that is currently loaded.
	for key,_ in pairs(WIM_Windows) do
		-- never close a GM's window!
		if(WIM_isGM(key) == false) then
                    if((time() - WIM_Windows[key].last_msg) > 4) then
                        WIM_Windows[key].sent_tell = false;
                    end
                    
                    if( WIM_Data.msgTimeOut.friends == true or WIM_Data.msgTimeOut.other == true ) then
			-- if AFK, reset timeouts so messages are kept until read.
			if(UnitIsAFK("player") == true) then
				WIM_Windows[key].last_msg = time();
			end
			-- check if friend, guildie or self and apply timeout if necessary
			if(WIM_Data.msgTimeOut.friends == true and (key == UnitName("player") or WIM_FriendList[key] ~= nil or WIM_GuildList[key] ~= nil)) then
				if( (time() - WIM_Windows[key].last_msg) > WIM_TimeOuts[WIM_Data.msgTimeOut.fTO] ) then WIM_CloseConvo(key); end
			elseif(WIM_Data.msgTimeOut.other == true and (key ~= UnitName("player") and WIM_FriendList[key] == nil and WIM_GuildList[key] == nil)) then
				if( (time() - WIM_Windows[key].last_msg) > WIM_TimeOuts[WIM_Data.msgTimeOut.oTO] ) then WIM_CloseConvo(key); end
			end
                    end
		end
	end
end

function WIM_AutoWhoCheck()
	if(WIM_AddonWhoCheck.waiting == true and (time() - WIM_AddonWhoCheck.stamp) > 10) then
		WIM_AddonWhoCheck.waiting = false;
		WIM_AddonWhoCheck.cache = {};
		WIM_AddonWhoCheck.stamp = 0;
		DEFAULT_CHAT_FRAME:AddMessage("Total found using WIM: "..WIM_AddonWhoCheck.count);
	end
end

function WIM_CronTab(elapsedTime)
	this.TimeSinceLastUpdate = this.TimeSinceLastUpdate + elapsedTime; 	
	
	while (this.TimeSinceLastUpdate > 1) do
		
		for job,_ in pairs(WIM_CronJobs) do
			WIM_CronJobs[job].elapsed = WIM_CronJobs[job].elapsed + 1;
			if(WIM_CronJobs[job].interval <= WIM_CronJobs[job].elapsed) then
				local theFun = WIM_CronJobs[job].theFunction;
				theFun();
				WIM_CronJobs[job].elapsed = 0;
			end
		end
		
		this.TimeSinceLastUpdate = 0;
	end
end

function WIM_FadeUpdate(elapsedTime)
	this.FadeTimeSinceLastUpdate = this.FadeTimeSinceLastUpdate + elapsedTime; 	
	
	while (this.FadeTimeSinceLastUpdate > .01) do
		
		for i=table.getn(WIM_FadeQueue.fadeIn), 1, -1 do
			local theFrame = WIM_FadeQueue.fadeIn[i];
			if(theFrame) then
				local curAlpha = theFrame:GetAlpha();
				if(curAlpha < 1) then
					theFrame:SetAlpha(curAlpha + .1);
				else
					table.remove(WIM_FadeQueue.fadeIn, i);
					theFrame:SetAlpha(1);
				end
			end
		end
		for i=table.getn(WIM_FadeQueue.fadeOut), 1, -1 do
			local theFrame = WIM_FadeQueue.fadeOut[i];
			if(theFrame and WIM_IsInTable(WIM_FadeQueue.fadeIn, theFrame) == 0) then
				local curAlpha = theFrame:GetAlpha();
				if(curAlpha > .5) then
					theFrame:SetAlpha(curAlpha - .1);
				else
					table.remove(WIM_FadeQueue.fadeOut, i);
					theFrame:SetAlpha(.5);
				end			
			end
		end
		for i=table.getn(WIM_FadeQueue.fadeOutDelayed), 1, -1 do
			WIM_FadeQueue.fadeOutDelayed[i].elapsed = WIM_FadeQueue.fadeOutDelayed[i].elapsed + elapsedTime;
			if(WIM_FadeQueue.fadeOutDelayed[i].elapsed > 5) then
				if(WIM_EditBoxInFocus ~= getglobal(WIM_FadeQueue.fadeOutDelayed[i].frame:GetName().."MsgBox") and WIM_FadeQueue.fadeOutDelayed[i].frame.isMouseOver == false) then
					WIM_FadeOut(WIM_FadeQueue.fadeOutDelayed[i].frame);
				end
				table.remove(WIM_FadeQueue.fadeOutDelayed, i);
			end
		end
		
		this.FadeTimeSinceLastUpdate = 0;
	end
end

function WIM_IsInTable(theTable, theItem)
	local i;
	for i=1,table.getn(theTable) do
		if(theTable[i] == theItem) then
			return i;
		end
	end
	return 0;
end

function WIM_API_AddCronJob(jobName, jobFunction, theInterval)
	--some checks
	if(jobName == nil) then return false; end
	if(jobName == "") then return false; end
	if(WIM_CronJobs[jobName]) then return false; end
	if(type(jobFunction) ~= "function") then return false; end
	if(theInterval == nil) then theInterval = 10; end
	if(type(theInterval) ~= "number")	then theInterval = 10; end
	if(theInterval == 0) then theInterval = 10; end
	WIM_CronJobs[jobName] = {
		interval = theInterval,
		theFunction = jobFunction,
		elapsed = 0
	};
	return true;
end

function WIM_HelpShow()
	WIM_Help:Show();
end

function WIM_OptionsShow()
	if (not IsAddOnLoaded("WIM_Options")) then
		UIParentLoadAddOn("WIM_Options");
	else
		WIM_Options:Show();
	end
end


function WIM_CatchOnlineOffline(theMSG)
	local patOnline  = string.gsub(ERR_FRIEND_ONLINE_SS, "%|Hplayer%:%%s%|h%[%%s%]%|h", "(.+)"); --localized online message with %s as user name.
	local patOffline = string.gsub(ERR_FRIEND_OFFLINE_S, "%%s", "(.+)"); --localized offline message with %s as user name.
	local _,_,tWho = string.find(theMSG, patOnline);
	
	if(tWho) then
		--if player online
		_,_,tWho = string.find(tWho, "%|Hplayer%:(.+)%|h%[.+%]%|h");
		if(WIM_Windows[tWho]) then
			theMSG = string.gsub(patOnline, "%(%.%+%)", tWho);
			WIM_PostMessage(tWho, theMSG, 3);
			WIM_Windows[tWho].isOnline = true;
		end
	else
		--check if it is a player offline event
		_,_,tWho = string.find(theMSG, patOffline);
		if(tWho) then
				--if player offline
				if(WIM_Windows[tWho]) then
					theMSG = string.gsub(patOffline, "%(%.%+%)", tWho);
					WIM_PostMessage(tWho, theMSG, 3);
					WIM_Windows[tWho].w2w = false;
					WIM_W2W[tWho] = nil;
					WIM_SetWhoInfo(tWho);
					WIM_Windows[tWho].isOnline = false;
                                        WIM_Windows[tWho].sent_tell = false;
				end
		end
	end
end

function WIM_PassIncomingMessage(theUser, theMSG, skipWhoQuery, msgID)
	--if(WIM_FilterResult(theUser, theMSG) == 1) then
	--	local message = string.format("%s %s: %s", "|Hplayer:"..theUser.."|h["..theUser.."]|h", L["whispers"], theMSG)
	--else
		if(skipWhoQuery == nil) then skipWhoQuery = false; end
		if(msgID == nil) then msgID = 0; end
		msg = "[|Hplayer:"..theUser..":"..msgID.."|h"..WIM_GetAlias(theUser, true).."|h]: "..theMSG;
		WIM_PostMessage(theUser, msg, 1, theUser, theMSG, skipWhoQuery, msgID);
	--end
end

function WIM_PassOutgoingMessage(theUser, theMSG, skipWhoQuery)
	--if(WIM_FilterResult(theUser, theMSG) ~= 0) then
		if(skipWhoQuery == nil) then skipWhoQuery = false; end
		msg = "[|Hplayer:"..UnitName("player").."|h"..WIM_GetAlias(UnitName("player"), true).."|h]: "..theMSG;
		WIM_PostMessage(theUser, msg, 2, UnitName("player") ,theMSG, skipWhoQuery);
	--end
end


------------------------------------------------------------
--               Window Functions & Handling
------------------------------------------------------------

function WIM_PostMessage(user, msg, ttype, from, raw_msg, skipWhoQuery, msgID)
		--[[
			ttype:
				1 - Wisper from someone
				2 - Wisper sent
				3 - System Message
				4 - Error Message
				5 - Show window... Do nothing else...
		]]--
		
		-- if called without user identified, close.
		if(user == nil) then return; end
		if(user == "") then return; end
		
		
		user = WIM_FormatName(user);
		
		if(skipWhoQuery == nil) then skipWhoQuery = false; end
		if(msgID == nil) then msgID = 0; end
		
		local f,chatBox;
		local isNew = false;
		if(WIM_Windows[user] == nil) then
			_, fName = WIM_CreateMessageWindow(user);
			f = getglobal(fName);
			--f = CreateFrame("Frame", "WIM_msgFrame"..user, UIParent, "WIM_msgFrameTemplate");
			--f.theUser = user;
			--fName = f:GetName();
			WIM_SetWindowProps(f);
			WIM_Windows[user] = {
						frame = fName,
						obj = nil,
						newMSG = true, 
						is_visible = false, 
						last_msg=time(), 
						waiting_who=false,
						class="",
						level="",
						race="",
						guild="",
						msg_id=0,
						location=WIM_LOCALIZED_UNKNOWN,
						w2w = false,
						w2w_proc = 0,
						isOnline = true,
						sent_tell = true,
						sent_history = {}
					};
			getglobal(fName.."BackdropFrom"):SetText(WIM_GetAlias(user));
			WIM_Icon_AddUser(user);
			WIM_AddTab(user);
			if(WIM_Data.windowFade) then
				f:SetAlpha(.5);
			else
				f:SetAlpha(1);
			end
			isNew = true;
			WIM_SetWindowLocation(f);
			 WIM_W2W_SendAddonMessage(user, "PING");
			if(WIM_Data.characterInfo.show and skipWhoQuery == false) then
				local tParts = {string.split("-", user)};
				if(table.getn(tParts) > 1) then
					WIM_GetBattleWhoInfo(user);
				else
					WIM_SendWho(user); 
				end
			end
			WIM_UpdateCascadeStep();
			WIM_DisplayHistory(user);
			if(WIM_History[user]) then
				getglobal(f:GetName().."HistoryButton"):Show();
			end
		end
		f = getglobal(WIM_Windows[user].frame);
		chatBox = getglobal(WIM_Windows[user].frame.."ScrollingMessageFrame");
		local PRendered = WIM_PratRenderText_Wrapper(chatBox, ttype, from, msgID, WIM_FilterEmoticons(raw_msg));
		if(PRendered == "") then
			msg = WIM_ConvertURLtoLinks(WIM_FilterEmoticons(msg));
		else
			msg = PRendered;
		end
		if(not f:IsVisible() and ttype ~= 3) then WIM_Windows[user].newMSG = true; end
		if(ttype == 1) then
			WIM_Windows[user].last_msg = time();
			WIM_Windows[user].msg_id = msgID;
			WIM_Windows[user].isOnline = true;
			WIM_PlaySoundWisp();
			WIM_AddToHistory(user, from, raw_msg, false);
			WIM_RecentListAdd(user);
			getglobal(WIM_Windows[user].frame.."IsChattingButton"):Hide();
			chatBox:AddMessage(WIM_getTimeStamp(chatBox)..msg, WIM_Data.displayColors.wispIn.r, WIM_Data.displayColors.wispIn.g, WIM_Data.displayColors.wispIn.b);
			WIM_API_WhisperReceived(user, raw_msg);
			if(WIM_Data.windowFade) then WIM_FadeIn(f); WIM_FadeOutDelayed(f); end
		elseif(ttype == 2) then
			WIM_Windows[user].sent_tell = false;
			WIM_Windows[user].last_msg = time();
			WIM_AddToHistory(user, from, raw_msg, true);
			WIM_RecentListAdd(user);
			if(raw_msg ~= "") then
				table.insert(WIM_Windows[user].sent_history, 1, raw_msg);
			        if(table.getn(WIM_Windows[user].sent_history) > 10) then table.remove(WIM_Windows[user].sent_history , 11); end
			end
			if(isNew == false and WIM_Windows[user].w2w == false) then WIM_W2W_SendAddonMessage(user, "PING"); end
			chatBox:AddMessage(WIM_getTimeStamp(chatBox)..msg, WIM_Data.displayColors.wispOut.r, WIM_Data.displayColors.wispOut.g, WIM_Data.displayColors.wispOut.b, msgID);
			if(WIM_Data.windowFade) then WIM_FadeIn(f); WIM_FadeOutDelayed(f); end
		elseif(ttype == 3) then
			chatBox:AddMessage(WIM_getTimeStamp(chatBox)..msg, WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b);
			WIM_Windows[user].newMSG = false;
			return;
		elseif(ttype == 4) then
			chatBox:AddMessage(msg, WIM_Data.displayColors.errorMsg.r, WIM_Data.displayColors.errorMsg.g, WIM_Data.displayColors.errorMsg.b);
			WIM_Windows[user].newMSG = false;
			return;
		end
		if( WIM_PopOrNot(isNew) or (ttype==2) or (ttype==5) ) then
			WIM_Windows[user].newMSG = false;
			if(ttype == 2 and WIM_Data.popOnSend == false) then
				--[ do nothing, user prefers not to pop on send
				WIM_WindowOnShow(WIM_Tabs.lastParent);
			elseif(ttype == 2 and WIM_Data.popOnSend == true and (WIM_Data.popCombat and UnitAffectingCombat("player"))) then
				--[ do nothing, user is in combat, don't send
				WIM_WindowOnShow(WIM_Tabs.lastParent);
			else
				if(WIM_Tabs.enabled == true and WIM_Tabs.x > -1 and WIM_Tabs.y > -1) then
					f:ClearAllPoints();
					f:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", WIM_Tabs.x, WIM_Tabs.y);
					if(WIM_EditBoxInFocus ~= nil and ttype ~= 5) then
						-- don't change tab. Do not interupt current convo.
						if(WIM_EditBoxInFocus:GetParent().theUser ~= user) then
							WIM_Windows[user].is_visible = false;
							if(ttype ~= 3 and ttype ~= 4) then WIM_Windows[user].newMSG = true; end
						end
						WIM_WindowOnShow(WIM_EditBoxInFocus:GetParent());
					else
						WIM_JumpToUserTab(user);
					end
				else
					WIM_Tabs.selectedUser = user;
					f:Show();
					if(WIM_Data.windowFade) then WIM_FadeIn(f); WIM_FadeOutDelayed(f); end
				end
				if(ttype ==5 and raw_msg ~= "*NOFOCUS*") then
					f:Raise();
					getglobal(f:GetName().."MsgBox"):SetFocus();
					if(WIM_Data.windowFade) then WIM_FadeIn(f); WIM_FadeOutDelayed(f); end
					if(raw_msg == "*CLEAR*") then 
						getglobal(f:GetName().."MsgBox").setText = 1;
						getglobal(f:GetName().."MsgBox").text = "";
					end
				end
			end
		else
			WIM_WindowOnShow(WIM_Tabs.lastParent);
		end
		WIM_UpdateScrollBars(chatBox);
		WIM_Icon_DropDown_Update();
		if(WIM_HistoryFrame:IsVisible()) then
			WIM_HistoryViewNameScrollBar_Update();
			WIM_HistoryViewFiltersScrollBar_Update();
		end
end

function WIM_SetWindowLocation(theWin)
	local CascadeOffset_Left = 0;
	local CascadeOffset_Top = 0;

	if(WIM_Data.winCascade.enabled) then
		CascadeOffset_Left = WIM_CascadeDirection[WIM_Data.winCascade.direction].left;
		CascadeOffset_Top = WIM_CascadeDirection[WIM_Data.winCascade.direction].top;
	end
	
	theWin:ClearAllPoints();
	if(WIM_Tabs.enabled == true and WIM_Tabs.x > -1 and WIM_Tabs.y > -1) then
		theWin:SetPoint("TOPLEFT", "UIParent", "BOTTOMLEFT", WIM_Tabs.x, WIM_Tabs.y);
	else
		theWin:SetPoint(
			"TOPLEFT",
			"UIParent",
			"BOTTOMLEFT",
			(WIM_Data.winLoc.left + WIM_CascadeStep*CascadeOffset_Left), 
			(WIM_Data.winLoc.top + WIM_CascadeStep*CascadeOffset_Top)
		);
	end
end

function WIM_PopOrNot(isNew)
	if(isNew == true and WIM_Data.popNew == true) then
		if(WIM_Data.popCombat and UnitAffectingCombat("player")) then
			return false;
		else
			return true;
		end
	elseif(WIM_Data.popNew == true and WIM_Data.popUpdate == true) then
		if(WIM_Data.popCombat and UnitAffectingCombat("player")) then
			return false;
		else
			return true;
		end
	else
		return false;
	end
end


function WIM_UpdateScrollBars(smf)
	local parentName = smf:GetParent():GetName();
	if(smf:AtTop()) then
		getglobal(parentName.."ScrollUp"):Disable();
	else
		getglobal(parentName.."ScrollUp"):Enable();
	end
	if(smf:AtBottom()) then
		getglobal(parentName.."ScrollDown"):Disable();
	else
		getglobal(parentName.."ScrollDown"):Enable();
	end
end


function WIM_DisplayURL(link)
	local theLink = "";
	if (string.len(link) > 4) and (string.sub(link,1,8) == "wim_url:") then
		theLink = string.sub(link,9, string.len(link));
	end

	-- The following code was written by the creator of Prat.
  StaticPopupDialogs["WIM_SHOW_URL"] = {
  			text = "URL : %s",
 				button2 = TEXT(ACCEPT),
  			hasEditBox = 1,
  			hasWideEditBox = 1,
  			showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(

        OnShow = function()
            local editBox = getglobal(this:GetName().."WideEditBox");
            editBox:SetText(format(theLink));
            editBox:SetFocus();
            editBox:HighlightText(0);

            local button = getglobal(this:GetName().."Button2");
            button:ClearAllPoints();
            button:SetWidth(200);
            button:SetPoint("CENTER", editBox, "CENTER", 0, -30);

            getglobal(this:GetName().."AlertIcon"):Hide();  -- HACK : we hide the false AlertIcon
        end,

        OnHide = function() end,
        OnAccept = function() end,
        OnCancel = function() end,
        EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1
	};

	StaticPopup_Show ("WIM_SHOW_URL", theLink);
end

function WIM_SetWindowProps(theWin)
	if(theWin == nil) then return; end
	
	-- calculate and set limits to window's height and width in respect to the skin.
	local min_width, min_height = WIM_GetXYLimits();
	local the_width = WIM_Data.winSize.width;
	local the_height = WIM_Data.winSize.height;
	if(the_width < min_width) then the_width = min_width; end
	if(the_height < min_height) then the_height = min_height; end
	
	
	if(WIM_Data.showShortcutBar) then
		WIM_LoadShortcutFrame(theWin);
		getglobal(theWin:GetName().."ShortcutFrame"):Show();
		local tHeight = the_height;
		local tMinHeight = WIM_SHORTCUTBAR_COUNT * (28*.75) + 132;
		if(tHeight < tMinHeight and WIM_SHORTCUTBAR_COUNT > 0) then
			tHeight = tMinHeight;
		end
		theWin:SetHeight(tHeight);
	else
		getglobal(theWin:GetName().."ShortcutFrame"):Hide();
		theWin:SetHeight(the_height);
	end
	
	theWin:SetWidth(the_width);
	theWin:SetScale(WIM_Data.windowSize);
	
	getglobal(theWin:GetName().."Backdrop"):SetAlpha(WIM_Data.windowAlpha);
	local Path,_,Flags = getglobal(theWin:GetName().."ScrollingMessageFrame"):GetFont();
	getglobal(theWin:GetName().."ScrollingMessageFrame"):SetFont(Path,WIM_Data.fontSize+2,Flags);
	getglobal(theWin:GetName().."ScrollingMessageFrame"):SetAlpha(1);
	getglobal(theWin:GetName().."MsgBox"):SetAlpha(1);
	getglobal(theWin:GetName().."ShortcutFrame"):SetAlpha(1);
	getglobal(theWin:GetName().."MsgBox"):SetAltArrowKeyMode(WIM_Data.ignoreArrowKeys);
	
	getglobal(theWin:GetName().."BackdropFrom"):SetAlpha(1);
	getglobal(theWin:GetName().."BackdropCharacterDetails"):SetAlpha(1);
	getglobal(theWin:GetName().."ExitButton"):SetAlpha(WIM_Data.windowAlpha);
	getglobal(theWin:GetName().."HistoryButton"):SetAlpha(WIM_Data.windowAlpha);
	getglobal(theWin:GetName().."W2WButton"):SetAlpha(1);
	getglobal(theWin:GetName().."ScrollUp"):SetAlpha(WIM_Data.windowAlpha);
	getglobal(theWin:GetName().."ScrollDown"):SetAlpha(WIM_Data.windowAlpha);
	
	WIM_TabStrip:SetAlpha(1);
	WIM_TabStrip:SetScale(WIM_Data.windowSize);
	
	if(WIM_W2W[theWin.theUser]) then
		getglobal(theWin:GetName().."W2WButton"):Show();
	else
		getglobal(theWin:GetName().."W2WButton"):Hide();
	end
	
	if(WIM_Data.useEscape) then
		WIM_AddEscapeWindow(theWin);
	else
		WIM_RemoveEscapeWindow(theWin);
	end
	
	if(WIM_Data.windowOnTop) then
		theWin:SetFrameStrata("DIALOG");
		WIM_TabStrip:SetFrameStrata("DIALOG");
	else
		theWin:SetFrameStrata("LOW");
		WIM_TabStrip:SetFrameStrata("LOW");
	end
end

function WIM_FadeIn(theWin)
	if(type(theWin) == "string") then
		theWin = getglobal(WIM_Windows[theWin].frame);
	end
	local OutIndex = WIM_IsInTable(WIM_FadeQueue.fadeOut, theWin);
	if(OutIndex > 0) then
		table.remove(WIM_FadeQueue.fadeOut, OutIndex);
	end
	if(WIM_IsInTable(WIM_FadeQueue.fadeIn, theWin) > 0) then return; end
	table.insert(WIM_FadeQueue.fadeIn, theWin);
end

function WIM_FadeOut(theWin)
	if(type(theWin) == "string") then
		theWin = getglobal(WIM_Windows[theWin].frame);
	end
	if(WIM_IsInTable(WIM_FadeQueue.fadeOut, theWin) > 0) then return; end
	table.insert(WIM_FadeQueue.fadeOut, theWin);
end

function WIM_FadeOutDelayed(theWin)
	if(type(theWin) == "string") then
		theWin = getglobal(WIM_Windows[theWin].frame);
	end
	table.insert(WIM_FadeQueue.fadeOutDelayed, {
		frame = theWin,
		elapsed = 0
	});
end


function WIM_AddEscapeWindow(theWin)
	for i=1, table.getn(UISpecialFrames) do 
		if(UISpecialFrames[i] == theWin:GetName()) then
			return;
		end
	end
	tinsert(UISpecialFrames,theWin:GetName());
end

function WIM_RemoveEscapeWindow(theWin)
	for i=1, table.getn(UISpecialFrames) do 
		if(UISpecialFrames[i] == theWin:GetName()) then
			table.remove(UISpecialFrames, i);
			return;
		end
	end
end

function WIM_SetAllWindowProps()
	for key,_ in pairs(WIM_Windows) do
		WIM_SetWindowProps(getglobal(WIM_Windows[key].frame));
	end
	if(WIM_Tabs.enabled and WIM_Tabs.lastParent ~= nil) then
		WIM_WindowOnShow(WIM_Tabs.lastParent);
	end
end

function WIM_UpdateCascadeStep()
		WIM_CascadeStep = WIM_CascadeStep + 1;
		if(WIM_CascadeStep > 10) then
			WIM_CascadeStep = 0;
		end
end

function WIM_ShowNewMessages()
	for key,_ in pairs(WIM_Windows) do
		if(WIM_Windows[key].newMSG == true) then
			if(WIM_Tabs.enabled == true) then
				WIM_PostMessage(key, "*NONE*", 5, nil,"*NOFOCUS*");
				return;
			else
				getglobal(WIM_Windows[key].frame):Show();
				WIM_Windows[key].newMSG = false;
			end
		end
	end
	WIM_Icon_DropDown_Update();
end

function WIM_ShowAll()
	if(WIM_Tabs.enabled == true and WIM_Tabs.selectedUser ~= "") then
		WIM_PostMessage(WIM_Tabs.selectedUser, "*NONE*", 5, nil,"*NOFOCUS*");
	else
		for key in pairs(WIM_Windows) do
			if(WIM_Tabs.enabled == true) then
				WIM_PostMessage(key, "*NONE*", 5, nil,"*NOFOCUS*");
				return;
			else
				getglobal(WIM_Windows[key].frame):Show();
			end
		end
	end
end

function WIM_HideAll()
	for key in pairs(WIM_Windows) do
		getglobal(WIM_Windows[key].frame):Hide();
	end
end

function WIM_ToggleVisibility()
	local isShown = false;
	for key, _ in pairs(WIM_Windows) do
		if(getglobal(WIM_Windows[key].frame):IsVisible()) then
			isShown = true;
			break;
		end
	end
	if(isShown) then
		WIM_HideAll();
	else
		WIM_ShowAll();
	end
end

function WIM_CloseAllConvos()
	for key in pairs(WIM_Windows) do
		WIM_CloseConvo(key);
	end
end

function WIM_MarkAllAsRead()
	for key, _ in pairs(WIM_Windows) do
		WIM_Windows[key].newMSG = false;
	end
	WIM_NewMessageFlag = false;
end

function WIM_CloseConvo(theUser)
	if(WIM_Windows[theUser] == nil) then return; end; --[ fail silently
	local wasVisible = getglobal(WIM_Windows[theUser].frame):IsVisible();
	getglobal(WIM_Windows[theUser].frame):Hide();
	WIM_Windows[theUser] = nil;
	WIM_IconItems[theUser] = nil;
	WIM_NewMessageFlag = false;
	WIM_W2W[theUser] = nil;
	WIM_RemoveTab(theUser, wasVisible);
	WIM_Icon_DropDown_Update();
	WIM_DestroyMessageWindow(theUser);
end








------------------------------------------------------------
--                  Formatting Functions
------------------------------------------------------------

function WIM_FormatName(theUser)
	local user = theUser;
	if(user ~= nil) then
		if(WIM_isGM(user)) then
			if(WIM_GM_Cache[user]) then
				return "<GM> "..user;
			else
				return user;
			end
		else
			user = string.gsub(user, "[A-Z]", string.lower);
			user = string.gsub(user, "^[a-z]", string.upper);
			user = string.gsub(user, "-[a-z]", string.upper); -- accomodate for cross server...
			if(WIM_Windows["<GM> "..user]) then
				return "<GM> "..user;
			end
		end
	end
	return user;
end

function WIM_isLinkURL(link)
	if (strsub(link, 1, 7) == "wim_url") then
		return true;
	else
		return false;
	end
end



function WIM_FormatRawURL(theURL)
	if(type(theURL) ~= "string" or theURL == "") then return ""; end
	local color;
	color = WIM_RGBtoHex(WIM_Data.displayColors.webAddress.r, WIM_Data.displayColors.webAddress.g, WIM_Data.displayColors.webAddress.b);
	theURL = theURL:gsub('%%', '%%%%'); --make sure any %'s are escaped in order to preserve them.
	return "|cff"..color.."|Hwim_url:"..theURL.."|h".."["..theURL.."]".."|h|r";
end

function WIM_ConvertURLtoLinks(text)
	WIM_URL_MATCHED_PATTERNS = {};
	for i=1, table.getn(WIM_URL_Patterns) do
		text = string.gsub(text, WIM_URL_Patterns[i], WIM_FormatRawURL);
	end
	
	return text;
end


function WIM_RGBtoHex(r,g,b)
	return string.format ("%.2x%.2x%.2x",r*255,g*255,b*255);
end

function WIM_UserWithClassColor(theUser)
	if(WIM_Windows[theUser].class == "") then
		return theUser;
	else
		if(WIM_ClassColors[WIM_Windows[theUser].class]) then
			return "|cff"..WIM_ClassColors[WIM_Windows[theUser].class]..WIM_GetAlias(theUser);
		else
			return WIM_GetAlias(theUser);
		end
	end
end

function WIM_SetWhoInfo(theUser)
	if(WIM_Data.characterInfo.classIcon) then
		WIM_SetMessageWindowClass(getglobal(WIM_Windows[theUser].frame), WIM_Windows[theUser].class);
	end
	if(WIM_Data.characterInfo.classColor) then	
		getglobal(WIM_Windows[theUser].frame.."BackdropFrom"):SetText(WIM_UserWithClassColor(theUser));
	end
	if(WIM_Data.characterInfo.details) then	
		WIM_SetMessageWindowCharacterDetails(getglobal(WIM_Windows[theUser].frame), WIM_Windows[theUser].guild, WIM_Windows[theUser].level, WIM_Windows[theUser].race, WIM_Windows[theUser].class);
	end
	--WIM_SetWindowProps(getglobal(WIM_Windows[theUser].frame));
	if(WIM_W2W[theUser]) then
		getglobal(WIM_Windows[theUser].frame.."W2WButton"):Show();
	else
		getglobal(WIM_Windows[theUser].frame.."W2WButton"):Hide();
	end
	WIM_SetMessageWindow_SmartStyle(getglobal(WIM_Windows[theUser].frame), theUser, WIM_Windows[theUser].guild, WIM_Windows[theUser].level, WIM_Windows[theUser].race, WIM_Windows[theUser].class);
end

function WIM_getTimeStamp(frame)
	if(WIM_Data.showTimeStamps) then
		if(WIM_Prat_Plugin_Loaded) then
			local pts = WIM_Prat_getTimeStamp(frame)
			if pts:len()>0 then
				return pts;
			else
				return "|cff"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b)..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat]).."|r ";
			end
		else
			return "|cff"..WIM_RGBtoHex(WIM_Data.displayColors.sysMsg.r, WIM_Data.displayColors.sysMsg.g, WIM_Data.displayColors.sysMsg.b)..date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat]).."|r ";
		end
	else
		return "";
	end
end

function WIM_GetAlias(theUser, nameOnly)
	if(WIM_Data.enableAlias and WIM_Alias[theUser] ~= nil) then
		if(WIM_Data.aliasAsComment) then
			if(nameOnly) then
				return theUser;
			else
				return theUser.." |cffffffff- "..WIM_Alias[theUser].."|r";
			end
		else
			return WIM_Alias[theUser];
		end
	else
		return theUser;
	end
end







------------------------------------------------------------
--               Minimap Icon & Menu Functions
------------------------------------------------------------

function WIM_Icon_Move(toDegree)
	WIM_Data.iconPosition = toDegree;
	WIM_Icon_UpdatePosition();
end

function WIM_Icon_UpdatePosition()
	if(WIM_Data.showMiniMap == false) then
		WIM_IconFrame:Hide();
	else
		if(WIM_Data.miniFreeMoving.enabled == false) then
			if (not IsAddOnLoaded("MBB")) then
				WIM_IconFrame:SetParent(Minimap);
			end
			WIM_IconFrame:SetPoint(
				"TOPLEFT",
				"Minimap",
				"TOPLEFT",
				54 - (78 * cos(WIM_Data.iconPosition)),
				(78 * sin(WIM_Data.iconPosition)) - 55
			);
			if(Minimap:IsVisible()) then
				WIM_IconFrame:Show();
			else
				WIM_IconFrame:Hide();
			end
		else
			WIM_IconFrame:SetParent(UIParent);
			WIM_IconFrame:Show();
		end
	end
end

function WIM_Icon_ToggleDropDown()
	if(WIM_ConversationMenu:IsVisible()) then
		WIM_ConversationMenu:Hide();
	else
		WIM_ConversationMenu:ClearAllPoints();
		WIM_ConversationMenu:Show();
		WIM_ConversationMenu:SetPoint("TOPRIGHT", WIM_IconFrame, "BOTTOMLEFT", 5, 5);
	end
end

function WIM_Icon_DropDown_Update()
	
	local tList = { };
	local tListActivity = { };
	local tCount = 0;
	for key,_ in pairs(WIM_IconItems) do
		table.insert(tListActivity, key);
		tCount = tCount + 1;
	end
	
	--[first get a sorted list of users by most frequent activity
	table.sort(tListActivity, WIM_Icon_SortByActivity);
	--[account for only the allowable amount of active users
	for i=1,table.getn(tListActivity) do
		if(i <= WIM_MaxMenuCount) then
			table.insert(tList, tListActivity[i]);
		end
	end
	
	--Initialize Menu
	for i=1,20 do 
		getglobal("WIM_ConversationMenuTellButton"..i.."Close"):Show();
		getglobal("WIM_ConversationMenuTellButton"..i):Enable();
		getglobal("WIM_ConversationMenuTellButton"..i):Hide();
	end
	
	
	WIM_NewMessageCount = 0;
	
	if(tCount == 0) then
		getglobal("WIM_ConversationMenuTellButton1Close"):Hide();
		getglobal("WIM_ConversationMenuTellButton1"):Disable();
		getglobal("WIM_ConversationMenuTellButton1"):SetText("|cffffffff - "..WIM_LOCALIZED_NONE.." -");
		getglobal("WIM_ConversationMenuTellButton1"):Show();
	else
		if(WIM_Data.sortAlpha) then
			table.sort(tList);
		end
		WIM_NewMessageFlag = false;
		for i=1, table.getn(tList) do
			if( WIM_Windows[tList[i]].newMSG and WIM_Windows[tList[i]].is_visible == false) then
				WIM_IconItems[tList[i]].color = "|cff"..WIM_RGBtoHex(77/255, 135/233, 224/255);
				WIM_NewMessageFlag = true;
				WIM_NewMessageCount = WIM_NewMessageCount + 1;
			else
				WIM_IconItems[tList[i]].color = "|cffffffff";
			end
			getglobal("WIM_ConversationMenuTellButton"..i):SetText(WIM_IconItems[tList[i]].color..WIM_GetAlias(WIM_IconItems[tList[i]].text, true));
			getglobal("WIM_ConversationMenuTellButton"..i).theUser = WIM_IconItems[tList[i]].text;
			getglobal("WIM_ConversationMenuTellButton"..i).value = WIM_IconItems[tList[i]].value;
			getglobal("WIM_ConversationMenuTellButton"..i):Show();
		end
	end
	
	--Set Height of Conversation Menu depending on message count
	local ConvoMenuHeight = 60;
	local CMH_Delta = 16 * (table.getn(tList)-1);
	if(CMH_Delta < 0) then CMH_Delta = 0; end
	ConvoMenuHeight = ConvoMenuHeight + CMH_Delta;
	WIM_ConversationMenu:SetHeight(ConvoMenuHeight);
	
	--Minimap icon
	if(WIM_Data.enableWIM == true) then
		if(WIM_NewMessageFlag == true) then
			WIM_IconFrameButton:SetNormalTexture("Interface\\AddOns\\WIM\\Images\\miniEnabled");
		else
			WIM_IconFrameButton:SetNormalTexture("Interface\\AddOns\\WIM\\Images\\miniDisabled");
		end
	else
		--show wim disabled icon
		WIM_IconFrameButton:SetNormalTexture("Interface\\AddOns\\WIM\\Images\\miniOff");
	end
end


function WIM_ConversationMenu_OnUpdate(elapsed)
	if(this.isCounting) then
		this.timeElapsed = this.timeElapsed + elapsed;
		if(this.timeElapsed > 1) then
			this:Hide();
			this.timeElapsed = 0;
			this.isCounting = false;
		end
	end
end

function WIM_Icon_AddUser(theUser)
	local info = {};
	info.text = theUser;
	info.justifyH = "LEFT"
	info.isTitle = nil;
	info.notCheckable = 1;
	info.value = WIM_Windows[theUser].frame;
	info.func = WIM_Icon_PlayerClick;
	WIM_IconItems[theUser] = info;
	table.sort(WIM_IconItems);
	WIM_Icon_DropDown_Update();
end

function WIM_Icon_PlayerClick()
	if(this.value ~= nil) then
		local user = getglobal(this.value).theUser;
		WIM_PostMessage(user, "", 5);
		WIM_Windows[user].newMSG = false;
		WIM_Windows[user].is_visible = true;
		WIM_Icon_DropDown_Update();
	end
end

function WIM_Icon_OnUpdate(elapsedTime)
	if(WIM_NewMessageFlag == false) then
		this.TimeSinceLastUpdate = 0;
		if(WIM_Icon_NewMessageFlash:IsVisible()) then
			WIM_Icon_NewMessageFlash:Hide();
		end
		return;
	end

	this.TimeSinceLastUpdate = this.TimeSinceLastUpdate + elapsedTime; 	

	while (this.TimeSinceLastUpdate > WIM_Icon_UpdateInterval) do
		if(WIM_Icon_NewMessageFlash:IsVisible()) then
			WIM_Icon_NewMessageFlash:Hide();
		else
			WIM_Icon_NewMessageFlash:Show();
		end
		this.TimeSinceLastUpdate = this.TimeSinceLastUpdate - WIM_Icon_UpdateInterval;
	end
end

function WIM_Icon_SortByActivity(user1, user2)
	if(WIM_Windows[user1] and WIM_Windows[user2]) then
		if(WIM_Windows[user1].last_msg > WIM_Windows[user2].last_msg) then
			return true;
		else
			return false;
		end
	else
		return false;
	end
end

function WIM_Icon_OnEnter()
	GameTooltip:SetOwner(this, "ANCHOR_LEFT");
	GameTooltip:SetText("WIM v"..WIM_VERSION.."              ");
	GameTooltip:AddDoubleLine("Conversation Menu", "Left-Click", 1,1,1,1,1,1);
	GameTooltip:AddDoubleLine("Show New Messages", "Right-Click", 1,1,1,1,1,1);
	GameTooltip:AddDoubleLine("WIM Options", "/wim", 1,1,1,1,1,1);
end

function WIM_IconNavMenu_Initialize()
	local info;
	
	info = UIDropDownMenu_CreateInfo();
	info.text = "WIM Tools";
	info.isTitle = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = BINDING_NAME_WIMSHOWNEW;
	info.func = WIM_ShowNewMessages;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = "";
	info.notClickable  = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = BINDING_NAME_WIMSHOWALL;
	info.func = WIM_ShowAll;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = BINDING_NAME_WIMHIDEALL;
	info.func = WIM_HideAll;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = BINDING_NAME_WIMMARKREAD;
	info.func = WIM_MarkAllAsRead;
	info.notCheckable = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = "";
	info.notClickable  = 1;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = BINDING_NAME_WIMHISTORY.."...";
	info.notCheckable = true;
	info.func = function() WIM_HistoryFrame:Show(); end;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = WIM_LOCALIZED_ICON_OPTIONS.."...";
	info.notCheckable = true;
	info.func = function() WIM_OptionsShow(); end;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
end

function WIM_IconNavMenu_Toggle()
	ToggleDropDownMenu(1, nil, WIM_IconNavMenu, this, -130, -1);
end






------------------------------------------------------------
--               Shortcut Frame Functions
------------------------------------------------------------

function WIM_ShortcutFrame_Default_OnEnter()
	if(WIM_Data.showToolTips == true or this.cmd == "update") then
		GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
		GameTooltip:SetText(this.tooltip);
	end
	if(WIM_Data.windowFade) then
		WIM_FadeIn(this:GetParent():GetParent().theUser);
	end
	this:GetParent():GetParent().isMouseOver = true;
	this:GetParent():GetParent().QueuedToHide = false;
end

function WIM_ShortcutFrame_Location_OnEnter(user)
	local theLocation = WIM_LOCALIZED_UNKNOWN;
	local tmp, zoneInfo, x , y, spec;
	local userPassed = true;
	
	if(not WIM_Windows[user]) then
		user = this:GetParent():GetParent().theUser;
		userPassed = false;
	end
	
	if(WIM_Windows[user]) then 
		theLocation = WIM_Windows[user].location; 
	end
	
	if(WIM_W2W[user] and WIM_W2W[user].location) then 
		theLocation = WIM_W2W[user].location; 
		zoneInfo = WIM_W2W[user].zoneInfo;
		spec = WIM_W2W[user].spec;
		x = zoneInfo.x;
		y = zoneInfo.y;
	end
	
	tmp = "";
	
	if(userPassed)then
		tmp = "|cff"..WIM_ClassColors[WIM_Windows[user].class]..user.."|r\n";
	end
	tmp = tmp..WIM_LOCALIZED_LOCATION..": |cffffffff"..theLocation;
	
	if(zoneInfo) then
		tmp = tmp.."|r\n"..WIM_LOCALIZED_COORD..": |cffffffff";
		x = math.floor(x*100);
		y = math.floor(y*100);
		tmp = tmp..x..","..y;
	end
	
	if(spec) then
		tmp = tmp.."|r\n"..WIM_LOCALIZED_TALENTSPEC..": |cffffffff";
		tmp = tmp..WIM_TalentsToString(spec, user);
	end
	
	if(not WIM_W2W[user]) then 
		tmp = tmp.."|r\n"..WIM_LOCALIZED_CLICK_TO_UPDATE;
	end
	
	GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
	
	GameTooltip:SetText(tmp);
	
	if(not userPassed) then
		if(WIM_Data.windowFade) then
			WIM_FadeIn(user);
		end
		this:GetParent():GetParent().isMouseOver = true;
		this:GetParent():GetParent().QueuedToHide = false;
	end
end

function WIM_LoadShortcutFrame(theWin)
	local tButtons = {};

	if(WIM_Data.characterInfo.show and WIM_Data.showShortcutBarButton.location) then
		local tmp = {
			--icon = "Interface\\Icons\\INV_Misc_GroupLooking",Ability_Spy
			icon = "Interface\\Icons\\Ability_TownWatch",
			cmd		= "update",
			tooltip = "#LOCATION#"
		};
		table.insert(tButtons, tmp);
	end
	
	if(WIM_Data.showShortcutBarButton.invite) then
		local tmp = {
			icon = "Interface\\Icons\\Spell_Holy_BlessingOfStrength",
			cmd		= "invite",
			tooltip = WIM_LOCALIZED_INVITE
		};
		table.insert(tButtons, tmp);
	end

	if(WIM_Data.showShortcutBarButton.friend and WIM_FriendList[theWin.theUser] == nil and theWin.theUser ~= UnitName("player") and WIM_isGM(theWin.theUser) == false) then
		local tmp = {
			icon = "Interface\\Icons\\INV_Misc_GroupNeedMore",
			cmd		= "friend",
			tooltip = WIM_LOCALIZED_FRIEND
		};
		table.insert(tButtons, tmp);
	end
	
	if(WIM_Data.showShortcutBarButton.ignore) then
		local tmp = {
			icon = "Interface\\Icons\\Ability_Physical_Taunt",
			cmd		= "ignore",
			tooltip = WIM_LOCALIZED_IGNORE
		};
		table.insert(tButtons, tmp);
	end
	
	WIM_SHORTCUTBAR_COUNT = 0;
	for i=1,5 do
		if(tButtons[i]) then
			getglobal(theWin:GetName().."ShortcutFrameButton"..i.."Icon"):SetTexture(tButtons[i].icon);
			getglobal(theWin:GetName().."ShortcutFrameButton"..i).cmd = tButtons[i].cmd;
			getglobal(theWin:GetName().."ShortcutFrameButton"..i).tooltip = tButtons[i].tooltip;
			getglobal(theWin:GetName().."ShortcutFrameButton"..i):Show();

			if(tButtons[i].tooltip == "#LOCATION#") then
				getglobal(theWin:GetName().."ShortcutFrameButton"..i):SetScript("OnEnter", WIM_ShortcutFrame_Location_OnEnter);
			else
				getglobal(theWin:GetName().."ShortcutFrameButton"..i):SetScript("OnEnter", WIM_ShortcutFrame_Default_OnEnter);
			end

			WIM_SHORTCUTBAR_COUNT = WIM_SHORTCUTBAR_COUNT + 1;
		else
			getglobal(theWin:GetName().."ShortcutFrameButton"..i):Hide();
		end
	end
	getglobal(theWin:GetName().."ShortcutFrame"):SetScale(.75);
end

function WIM_ShorcutButton_Clicked()
	local cmd = this.cmd;
	local theUser = this:GetParent():GetParent().theUser;
	if(cmd == "target") then
		--WIM_TargetByName(theUser);
	elseif(cmd == "invite") then
		InviteUnit(theUser);
	elseif(cmd == "friend") then
		AddFriend(theUser);
	elseif(cmd == "update") then
		WIM_SendWho(theUser);
		GameTooltip:Hide();
	elseif(cmd == "trade") then
		--WIM_TargetByName(theUser);
		InitiateTrade("target");
	elseif(cmd == "inspect") then
		--WIM_TargetByName(theUser);
		InspectUnit("target");
	elseif(cmd == "ignore") then
		--getglobal(this:GetParent():GetParent():GetName().."IgnoreConfirm"):Show();
		StaticPopupDialogs["WIM_IGNORE"] = {
			text = WIM_LOCALIZED_IGNORE_CONFIRM,
			button1 = WIM_LOCALIZED_YES,
			button2 = WIM_LOCALIZED_NO,
			OnAccept = function()
				AddIgnore(theUser);
			end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1
		};
		StaticPopup_Show("WIM_IGNORE");
	end
end









------------------------------------------------------------
--                 Filtering Functions
------------------------------------------------------------

function WIM_FilterResult_Interface(theMSG, theUser, isInbound, isInternal, msgID)
	if(isInbound == true and WIM_IgnoreMore(theUser) == 2) then return 2; end --account for addon IgnoreMore
	
	local result = WIM_FilterResult(theMSG, theUser, isInbound, isInternal);
	
	if(isInternal and result == 0) then
		for key, _ in pairs(WIM_Plugins) do
			if(WIM_Plugins[key].interceptInboundFunction and isInbound) then
				local theFun = getglobal(WIM_Plugins[key].interceptInboundFunction);
				if(theFun(theUser, theMSG, msgID)) then return 2; end
			elseif(WIM_Plugins[key].interceptOutboundFunction and not isInbound) then
				local theFun = getglobal(WIM_Plugins[key].interceptOutboundFunction);
				if(theFun(theUser, theMSG)) then return 2; end
			end
		end
	end

	return result;
end


function WIM_FilterResult(theMSG, theUser, isInbound, isInternal)
	-- before we execute WIM's filtering, we want to accomodate SpamSentry.
	if( type(WIM_SpamSentry_IsMsgSpam) == "function" ) then
		if( WIM_SpamSentry_IsMsgSpam(theUser, theMSG) == true ) then
			return 2;
		end
	end
	
	local preFilter = 0;
	preFilter = WIM_API_Filter(theMSG, theUser, isInbound, isInternal);
	if(preFilter > 1) then
		return preFilter;
	end

	if(WIM_Data.enableFilter) then
		local key, a, b;
		for key,_ in pairs(WIM_Filters) do
			if(strfind(strlower(theMSG), strlower(key)) ~= nil) then
				if(WIM_Filters[key] == "Ignore") then
					return 1;
				elseif(WIM_Filters[key] == "Block") then
					return 2;
				end
			end
		end
		if(preFilter > 0) then
			return preFilter;
		else
			return 0;
		end
	else
		return 0;
	end
end

function WIM_LoadDefaultFilters()
	if( WIM_Filters == nil ) then WIM_Filters = {}; end -- only wipe the filters array if it doesn't exist.
	WIM_Filters[WIM_LOCALIZED_FILTER_1] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_2] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_3] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_4] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_5] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_6] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_7] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_8] 	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_9]	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_10]	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_11]	= "Ignore";
	WIM_Filters[WIM_LOCALIZED_FILTER_12]	= "Ignore";
	WIM_Filters["^<T>PartyQuests[^A-Z]+"] 	= "Ignore";
	WIM_Filters["^<M_N>"]			= "Ignore";
	WIM_Filters["^ItemDB-Request:"]		= "Ignore";
	
	if(WIM_OptionsIsLoaded == true) then WIM_FilteringScrollBar_Update(); end
end


function WIM_API_Filter(theMsg, theUser)
	return 0;
end



------------------------------------------------------------
--               History Functions & Handlers
------------------------------------------------------------

function WIM_CanRecordUser(theUser)
	if(WIM_Data.historySettings.recordEveryone) then
		return true;
	else
		if(WIM_Data.historySettings.recordFriends and WIM_FriendList[theUser]) then
			return true;
		elseif(WIM_Data.historySettings.recordGuild and WIM_GuildList[theUser]) then
			return true;
		end
	end
	return false;
end

function WIM_AddToHistory(theUser, userFrom, theMessage, isMsgIn)
	local tmpEntry = {};
	if(WIM_Data.enableHistory or WIM_isGM(theUser)) then --[if history is enabled
		if(WIM_CanRecordUser(theUser) or WIM_isGM(theUser)) then --[if record user
			getglobal(WIM_Windows[theUser].frame.."HistoryButton"):Show();
			tmpEntry["stamp"] = time();
			tmpEntry["date"] = date("%m/%d/%y");
			tmpEntry["time"] = date("%H:%M"); -- no longer used, but stored for backwards compatibilty
			tmpEntry["msg"] = WIM_ConvertURLtoLinks(theMessage);
			tmpEntry["from"] = userFrom;
			tmpEntry["character"] = UnitName("player");
			if(isMsgIn) then
				tmpEntry["type"] = 2;
			else
				tmpEntry["type"] = 1;
			end
			if(WIM_History[theUser] == nil) then
				WIM_History[theUser] = {};
			end
			table.insert(WIM_History[theUser], tmpEntry);
			
			if(WIM_Data.historySettings.maxMsg.enabled) then
				local tOver = table.getn(WIM_History[theUser]) - WIM_Data.historySettings.maxMsg.count;
				if(tOver > 0) then
					for i = 1, tOver do 
						table.remove(WIM_History[theUser], 1);
					end
				end
			end
			if(WIM_OptionsIsLoaded) then
				if(WIM_Options:IsVisible()) then
					WIM_HistoryScrollBar_Update();
				end
			end
		end
	end
end

function WIM_SortHistory(a, b)
	if(a.stamp < b.stamp) then
		return true;
	else
		return false;
	end
end

function WIM_DisplayHistory(theUser)
	if(WIM_History[theUser] and WIM_Data.enableHistory and WIM_Data.historySettings.popWin.enabled) then
		table.sort(WIM_History[theUser], WIM_SortHistory);
		local prevDate = "";
		local curDate = "";
		for i=table.getn(WIM_History[theUser])-WIM_Data.historySettings.popWin.count-1, table.getn(WIM_History[theUser]) do 
			if(WIM_History[theUser][i]) then
				--WIM_GetAlias
				msg = "|Hplayer:"..WIM_History[theUser][i].from.."|h["..WIM_GetAlias(WIM_History[theUser][i].from, true).."]|h: "..WIM_FilterEmoticons(WIM_History[theUser][i].msg);
				if(WIM_Data.showTimeStamps) then
					--msg = WIM_History[theUser][i].time.." "..msg;
					curDate = date("%m-%d-%Y", WIM_History[theUser][i].stamp);
					msg = date(WIM_TimeStamp_Formats[WIM_Data.timeStampFormat], WIM_History[theUser][i].stamp).." "..msg;
				end
				if(curDate ~= prevDate) then
					getglobal(WIM_Windows[theUser].frame.."ScrollingMessageFrame"):AddMessage(" ");
					getglobal(WIM_Windows[theUser].frame.."ScrollingMessageFrame"):AddMessage(curDate);
					prevDate = curDate;
				end
				if(WIM_History[theUser][i].type == 1) then
					getglobal(WIM_Windows[theUser].frame.."ScrollingMessageFrame"):AddMessage(msg, WIM_Data.historySettings.colorIn.r, WIM_Data.historySettings.colorIn.g, WIM_Data.historySettings.colorIn.b);
				elseif(WIM_History[theUser][i].type == 2) then
					getglobal(WIM_Windows[theUser].frame.."ScrollingMessageFrame"):AddMessage(msg, WIM_Data.historySettings.colorOut.r, WIM_Data.historySettings.colorOut.g, WIM_Data.historySettings.colorOut.b);
				end
			end
		end
		if(curDate ~= "") then
			getglobal(WIM_Windows[theUser].frame.."ScrollingMessageFrame"):AddMessage(" ");
		end
	end
end

function WIM_HistoryPurge()
	if(WIM_Data.historySettings.autoDelete.enabled) then
		local delCount = 0;
		local eldestTime = time() - (60 * 60 * 24 * WIM_Data.historySettings.autoDelete.days);
		for key,_ in pairs(WIM_History) do
			if(WIM_History[key][1]) then
				while(WIM_History[key][1].stamp < eldestTime) do
					table.remove(WIM_History[key], 1);
					delCount = delCount + 1;
					if(table.getn(WIM_History[key]) == 0) then
						WIM_History[key] = nil;
						break;
					end
				end
			end
		end
		if(delCount > 0) then
			local tmpMsg, tmp = string.gsub(WIM_LOCALIZED_PURGED_HISTORY, "{n}", delCount);
			DEFAULT_CHAT_FRAME:AddMessage("[WIM]: "..tmpMsg);
		end
	end
end








------------------------------------------------------------
--            Toggle Frame Functions & Handlers
------------------------------------------------------------

function WIM_ToggleWindow_OnUpdate(elapsedTime)

	WIM_ToggleWindow_Timer = WIM_ToggleWindow_Timer + elapsedTime; 	

	while (WIM_ToggleWindow_Timer > 1) do
		WIM_ToggleWindow:Hide();
		WIM_ToggleWindow_Timer = 0;
	end
end

function WIM_RecentListAdd(theUser)
	for i=1, table.getn(WIM_RecentList) do 
		if(string.upper(WIM_RecentList[i]) == string.upper(theUser)) then
			table.remove(WIM_RecentList, i);
			break;
		end
	end
	table.insert(WIM_RecentList, 1, theUser);
end

function WIM_ToggleWindow_Toggle()
	if(table.getn(WIM_RecentList) == 0) then
		return;
	end
	
	if(WIM_RecentList[WIM_ToggleWindow_Index] == nil) then
		WIM_ToggleWindow_Index = 1;
	end
	
	WIM_ToggleWindowUser:SetText(WIM_GetAlias(WIM_RecentList[WIM_ToggleWindow_Index], true));
	WIM_ToggleWindow.theUser = WIM_RecentList[WIM_ToggleWindow_Index];
	local tmpStr, t = string.gsub(WIM_LOCALIZED_RECENT_CONVO_COUNT,  "{n1}", WIM_ToggleWindow_Index);
		  tmpStr, t = string.gsub(tmpStr,							 "{n2}", table.getn(WIM_RecentList));
	WIM_ToggleWindowCount:SetText(tmpStr);
	if(WIM_Windows[WIM_RecentList[WIM_ToggleWindow_Index]]) then
		if(WIM_Windows[WIM_RecentList[WIM_ToggleWindow_Index]].newMSG) then
			WIM_ToggleWindowStatus:SetText(WIM_LOCALIZED_NEW_MESSAGE);
			WIM_ToggleWindowIconNew:Show();
			WIM_ToggleWindowIconRead:Hide();
		else
			WIM_ToggleWindowStatus:SetText(WIM_LOCALIZED_NO_NEW_MESSAGES);
			WIM_ToggleWindowIconRead:Show();
			WIM_ToggleWindowIconNew:Hide();
		end
	else
		WIM_ToggleWindowStatus:SetText(WIM_LOCALIZED_CONVO_CLOSED);
		WIM_ToggleWindowIconRead:Show();
		WIM_ToggleWindowIconNew:Hide();
	end
	WIM_ToggleWindow_Timer = 0;
	WIM_ToggleWindow:Show();
	WIM_ToggleWindow_Index = WIM_ToggleWindow_Index + 1;
end









------------------------------------------------------------
--               Tab System Functions & Handlers
------------------------------------------------------------

function WIM_SetTabWidth(theWidth)
	for i=1,10 do 
		PanelTemplates_TabResize(10, getglobal("WIM_Tab"..i), theWidth);
	end
end

function WIM_WindowOnShow(theWin)
	if(theWin and theWin.theUser == nil) then return; end
	if(WIM_Tabs.enabled == true and table.getn(WIM_Tabs.tabs) > 1 and theWin ~= nil) then
		WIM_Tabs.lastParent = theWin;
		if(WIM_Tabs.lastParent:IsVisible()) then
			WIM_TabStrip:ClearAllPoints();
			WIM_TabStrip:SetPoint(WIM_Tabs.anchorSelf, theWin, WIM_Tabs.anchorRelative, WIM_Tabs.marginLeft, WIM_Tabs.topOffset);
			WIM_TabStrip:SetWidth(theWin:GetWidth() - WIM_Tabs.marginLeft - WIM_Tabs.marginRight);
			WIM_ResizeTabs();
			WIM_TabStrip:Show();
		else
			WIM_TabStrip:Hide();
		end
	else
		WIM_TabStrip:Hide();
		WIM_Tabs.lastParent = theWin;
	end
	WIM_TabFlashRefresh();
end

function WIM_SetTabOffset(PlusOrMinus)
	if(PlusOrMinus > 0) then
		if(WIM_Tabs.offset + WIM_Tabs.visibleCount >= table.getn(WIM_Tabs.tabs)) then
			WIM_Tabs.offset = table.getn(WIM_Tabs.tabs) - WIM_Tabs.visibleCount;
			if(WIM_Tabs.offset < 0) then WIM_Tabs.offset = 0; end
		else
			WIM_Tabs.offset = WIM_Tabs.offset + 1;
		end
	elseif(PlusOrMinus < 0) then
		if(WIM_Tabs.offset <= 0) then 
			WIM_Tabs.offset = 0;
		else
			WIM_Tabs.offset = WIM_Tabs.offset - 1;
		end
	end
	WIM_ResizeTabs();
end

function WIM_ResizeTabs()
	local w = WIM_TabStrip:GetWidth();
	local count = math.floor(w / (WIM_Tabs.minWidth));
	local tabList = WIM_TabTableSorted();
	if(count >= table.getn(tabList)) then
		count = table.getn(tabList)
		WIM_TabNext:Hide();
		WIM_TabPrev:Hide();
	else
		WIM_TabNext:Show();
		WIM_TabPrev:Show();
		if(WIM_Tabs.offset <= 0) then
			WIM_TabPrev:Disable();
		else
			WIM_TabPrev:Enable();
		end
		if(WIM_Tabs.offset >= table.getn(tabList) - count) then
			WIM_TabNext:Disable();
		else
			WIM_TabNext:Enable();
		end
	end
	WIM_Tabs.visibleCount = count;
	WIM_SetTabWidth((w / count) + (count));
	for i=1,10 do 
		if(i <= count) then
			getglobal("WIM_Tab"..i):Show();
			getglobal("WIM_Tab"..i):SetText(tabList[i+WIM_Tabs.offset]);
			getglobal("WIM_Tab"..i).theUser = tabList[i+WIM_Tabs.offset];
			if(WIM_Tabs.selectedUser == tabList[i+WIM_Tabs.offset]) then 
				WIM_TabSetSelected(tabList[i+WIM_Tabs.offset]);
			else
				getglobal("WIM_Tab"..i):SetAlpha(.7);
				WIM_SetTabTexture(getglobal("WIM_Tab"..i), "Interface\\AddOns\\WIM\\Images\\WIMTab");
			end
		else
			getglobal("WIM_Tab"..i):Hide();
			getglobal("WIM_Tab"..i):SetText("");
			getglobal("WIM_Tab"..i).theUser = "";
		end
	end
	WIM_TabFlashRefresh();
end

function WIM_GetTabByUser(theUser)
	for i=1,10 do 
		if(getglobal("WIM_Tab"..i).theUser) then
			if(getglobal("WIM_Tab"..i).theUser == theUser) then
				return getglobal("WIM_Tab"..i);
			end
		end
	end
	return nil;
end

function WIM_FocusSelectedTab()
	local user = WIM_Tabs.selectedUser;
	if(WIM_Tabs.enabled and WIM_Windows[user]) then
		WIM_PostMessage(user, "", 5, "", "*CLEAR*");
	end
end

function WIM_TabSetSelected(theUser)
	for i=1,10 do 
		if(getglobal("WIM_Tab"..i).theUser) then
			if(getglobal("WIM_Tab"..i).theUser == theUser) then
				getglobal("WIM_Tab"..i):SetAlpha(1);
				WIM_Tabs.selectedUser = theUser;
				WIM_SetTabTexture(getglobal("WIM_Tab"..i), "Interface\\AddOns\\WIM\\Images\\WIMTabSelected");
			else
				getglobal("WIM_Tab"..i):SetAlpha(.7);
				WIM_SetTabTexture(getglobal("WIM_Tab"..i), "Interface\\AddOns\\WIM\\Images\\WIMTab");
			end
		else
			getglobal("WIM_Tab"..i):SetAlpha(.7);
			WIM_SetTabTexture(getglobal("WIM_Tab"..i), "Interface\\AddOns\\WIM\\Images\\WIMTab");
		end
	end
end

function WIM_SetTabTexture(theTab, theTexture)
	local tabName = theTab:GetName();
	getglobal(tabName.."Left"):SetTexture(theTexture);
	getglobal(tabName.."Middle"):SetTexture(theTexture);
	getglobal(tabName.."Right"):SetTexture(theTexture);
end

function WIM_TabFlashRefresh()
	local lower = WIM_Tabs.offset + 1;
	local upper = WIM_Tabs.offset + WIM_Tabs.visibleCount;
	local tIndex = 0;
	local flashTab;
	
	WIM_TabNextFlash:Hide();
	UIFrameFlashRemoveFrame(WIM_TabNextFlash);
	WIM_TabPrevFlash:Hide();
	UIFrameFlashRemoveFrame(WIM_TabPrevFlash);
	
	for key,_ in pairs(WIM_Windows) do
		tIndex = WIM_GetUserTabIndex(key);
		if(tIndex >= lower and tIndex <= upper) then
			flashTab = getglobal("WIM_Tab"..(tIndex - WIM_Tabs.offset).."Flash");
			if(WIM_Windows[key].newMSG == true and key ~= WIM_Tabs.selectedUser) then
				flashTab:Show();
				UIFrameFlash(flashTab, 0.10, 0.10, 999999, nil, 0.5, 0.5);
			else
				flashTab:Hide();
				UIFrameFlashRemoveFrame(flashTab);
			end
		elseif(tIndex < lower) then
			if(WIM_Windows[key].newMSG == true) then
				WIM_TabPrevFlash:Show();
				UIFrameFlash(WIM_TabPrevFlash, 0.10, 0.10, 999999, nil, 0.5, 0.5);
			end
		elseif(tIndex > upper) then
			if(WIM_Windows[key].newMSG == true) then
				WIM_TabNextFlash:Show();
				UIFrameFlash(WIM_TabNextFlash, 0.10, 0.10, 999999, nil, 0.5, 0.5);
			end
		end
	end
end

function WIM_JumpToUserTab(theUser)
	if(WIM_Tabs.enabled == true) then
		local tindex = WIM_GetUserTabIndex(theUser);
		local lower = WIM_Tabs.offset;
		local upper = lower + WIM_Tabs.visibleCount;
		local prevOffset = lower;
	
		if(tindex == 0) then
			return;
		elseif(tindex <= lower) then
			WIM_Tabs.offset = WIM_Tabs.offset - (WIM_Tabs.offset - tindex) - 1;
		elseif(tindex > upper) then
			WIM_Tabs.offset = tindex - WIM_Tabs.visibleCount;
		end
		if(WIM_Tabs.offset ~= prevOffset) then WIM_ResizeTabs(); end
		WIM_TabSetSelected(theUser);
		
		for key in pairs(WIM_Windows) do
			if(key ~= theUser) then
				getglobal(WIM_Windows[key].frame):Hide();
			end
		end
		getglobal(WIM_Windows[theUser].frame):Show();
		if(WIM_TabStrip:IsVisible() or not WIM_Data.windowFade) then 
			getglobal(WIM_Windows[theUser].frame):SetAlpha(1); 
		else
			if(getglobal(WIM_Windows[theUser].frame):GetAlpha() < 1) then
				getglobal(WIM_Windows[theUser].frame):SetAlpha(.5); 
			end
			WIM_FadeIn(getglobal(WIM_Windows[theUser].frame));
		end
		WIM_WindowOnShow(getglobal(WIM_Windows[theUser].frame));
	end
end

function WIM_GetUserTabIndex(theUser)
	local tabList = WIM_TabTableSorted();
	
	for i=1,table.getn(tabList) do 
		if(tabList[i] == theUser) then
			return i;
		end
	end
	return 0;
end

function WIM_AddTab(theUser)
	table.insert(WIM_Tabs.tabs, theUser);
	WIM_ResizeTabs();
end

function WIM_RemoveTab(theUser, wasVisible)
	local tabList = WIM_TabTableSorted();
	local tabListIndex;
	for i=1, table.getn(WIM_Tabs.tabs) do 
		if(theUser == WIM_Tabs.tabs[i]) then
			tabListIndex = WIM_GetUserTabIndex(theUser);
			if(theUser == WIM_Tabs.selectedUser) then
				--get next tab
				if(table.getn(WIM_Tabs.tabs) > 1) then
					if(tabListIndex == 1) then
						WIM_Tabs.selectedUser = tabList[tabListIndex+1];
					elseif(tabListIndex == table.getn(tabList)) then
						WIM_Tabs.selectedUser = tabList[tabListIndex-1];
					else
						WIM_Tabs.selectedUser = tabList[tabListIndex+1];
					end
				end
			end
			--adjust offsets
			local lower = WIM_Tabs.offset + 1;
			local upper = WIM_Tabs.offset + WIM_Tabs.visibleCount;
			if (upper == table.getn(WIM_Tabs.tabs) and lower > 1) then
				WIM_Tabs.offset = WIM_Tabs.offset - 1;
			end
			
			table.remove(WIM_Tabs.tabs, i);
			if(table.getn(WIM_Tabs.tabs) < 2) then WIM_TabStrip:Hide(); end
			if(wasVisible and table.getn(WIM_Tabs.tabs) > 0 and WIM_Tabs.enabled) then
				WIM_PostMessage(WIM_Tabs.selectedUser, "*NONE*", 5, nil,"*NOFOCUS*");
			end
			if(WIM_Tabs.enabled) then WIM_ResizeTabs(); end
			return;
		end
	end
end


function WIM_ToggleTabMode(OnOrOff)
	WIM_Data.tabMode = OnOrOff;
	WIM_Tabs.enabled = OnOrOff;
	WIM_HideAll();
	WIM_CascadeStep = 0;
	for theUser in pairs(WIM_Windows) do
		WIM_SetWindowLocation(getglobal(WIM_Windows[theUser].frame));
		WIM_UpdateCascadeStep();
	end
	WIM_ShowAll();
end


function WIM_TabStep(UpOrDown)
	if(table.getn(WIM_Tabs.tabs) < 2) then return; end
	
	local tIndex = WIM_GetUserTabIndex(WIM_Tabs.selectedUser);
	local tabList = WIM_TabTableSorted();
	
	if(UpOrDown > 0) then
		if(tIndex == table.getn(tabList)) then
			tIndex = 1;
		else
			tIndex = tIndex + 1;
		end
		WIM_PostMessage(tabList[tIndex], "*NONE*", 5, nil);
	elseif(UpOrDown < 0) then
		if(tIndex == 1) then 
			tIndex = table.getn(tabList);
		else
			tIndex = tIndex - 1;
		end
		WIM_PostMessage(tabList[tIndex], "*NONE*", 5, nil);
	end
end


function WIM_TabTableSorted()
	if(WIM_Tabs.sortType == 0) then
		--default tablist do nothing.
		return WIM_Tabs.tabs;
	else
		-- to preserve list, we will copy then run sorts
		local tabList = {};
		for i=1, table.getn(WIM_Tabs.tabs) do
			table.insert(tabList, WIM_Tabs.tabs[i]);
		end
		
		if(WIM_Tabs.sortType == 1) then
			-- alphabetical sort
			table.sort(tabList);
			return tabList;
		elseif(WIM_Tabs.sortType == 2) then
			-- activity sort
			table.sort(tabList, WIM_Icon_SortByActivity);
			return tabList;
		else
			return WIM_Tabs.tabs;
		end
	end
end


function WIM_TabsSetSortType(theType)
	WIM_Tabs.sortType = theType;
	WIM_Data.tabSortType = theType;
	if(WIM_Tabs.lastParent ~= nil and WIM_Tabs.lastParent:IsVisible()) then
		WIM_JumpToUserTab(WIM_Tabs.selectedUser);
	end
end



------------------------------------------------------------
--               Help Frame Functions
------------------------------------------------------------

function WIM_Help_Description_Click()
	PanelTemplates_SelectTab(WIM_HelpTab1);
	PanelTemplates_DeselectTab(WIM_HelpTab2);
	PanelTemplates_DeselectTab(WIM_HelpTab3);
	PanelTemplates_DeselectTab(WIM_HelpTabCredits);
	
	WIM_HelpScrollFrameScrollChildText:SetText(WIM_DESCRIPTION);
	WIM_HelpScrollFrameScrollBar:SetValue(0);
	WIM_HelpScrollFrame:UpdateScrollChildRect();
end

function WIM_Help_ChangeLog_Click()
	PanelTemplates_SelectTab(WIM_HelpTab2);
	PanelTemplates_DeselectTab(WIM_HelpTab1);
	PanelTemplates_DeselectTab(WIM_HelpTab3);
	PanelTemplates_DeselectTab(WIM_HelpTabCredits);
	
	WIM_HelpScrollFrameScrollChildText:SetText(WIM_CHANGE_LOG);
	WIM_HelpScrollFrameScrollBar:SetValue(0);
	WIM_HelpScrollFrame:UpdateScrollChildRect();
end

function WIM_Help_DidYouKnow_Click()
	PanelTemplates_SelectTab(WIM_HelpTab3);
	PanelTemplates_DeselectTab(WIM_HelpTab1);
	PanelTemplates_DeselectTab(WIM_HelpTab2);
	PanelTemplates_DeselectTab(WIM_HelpTabCredits);
	
	WIM_HelpScrollFrameScrollChildText:SetText(WIM_DIDYOUKNOW);
	WIM_HelpScrollFrameScrollBar:SetValue(0);
	WIM_HelpScrollFrame:UpdateScrollChildRect();
end

function WIM_Help_Credits_Click()
	PanelTemplates_SelectTab(WIM_HelpTabCredits);
	PanelTemplates_DeselectTab(WIM_HelpTab1);
	PanelTemplates_DeselectTab(WIM_HelpTab2);
	PanelTemplates_DeselectTab(WIM_HelpTab3);
	
	WIM_HelpScrollFrameScrollChildText:SetText(WIM_CREDITS);
	WIM_HelpScrollFrameScrollBar:SetValue(0);
	WIM_HelpScrollFrame:UpdateScrollChildRect();
end



------------------------------------------------------------
--            Addon Message Functions & Handlers
------------------------------------------------------------

function WIM_AddonMessageHandler(message, ttype, from)
	local PASSED = {string.split("#", message)};
	if(table.getn(PASSED) == 2) then
		local cmd = string.upper(PASSED[1]);
		local arg = PASSED[2];
		
		if(cmd == "WHO") then
			WIM_SendAddonMessage("ME#"..WIM_VERSION);
		elseif(cmd == "ME") then
			WIM_AddonShowWhoResult(from, "WIM User: "..from.." ("..arg..") - "..ttype);
		elseif(cmd == "VERSION_CHECK") then
			if(WIM_CompareVersion(arg) > 0) then
				if(WIM_UpdateCheck.newVersion == false and WIM_Data.updateCheck == true) then
					WIM_UpdateCheck.newVersion = true;
					StaticPopupDialogs["WIM_NEW_VERSION"] = {
						text = WIM_LOCALIZED_NEW_VERSION,
						button1 = "OK",
						timeout = 0,
						whileDead = 1,
						hideOnEscape = 1
					};
					StaticPopup_Show ("WIM_NEW_VERSION");
				end
			elseif(WIM_CompareVersion(arg) < 0) then
				--if(WIM_IS_BETA == false) then WIM_SendAddonMessage("VERSION_CHECK#"..WIM_VERSION); end
			end
		end
		
		
	end
end

function WIM_SendAddonMessage(theMSG)
	SendAddonMessage("WIM", theMSG, "GUILD");
	if(GetNumRaidMembers() > 0) then
		SendAddonMessage("WIM", theMSG, "RAID");
	else
		SendAddonMessage("WIM", theMSG, "PARTY");
	end
end

function WIM_SendAddonUpdateChecks()
	if(WIM_IS_BETA == false and WIM_UpdateCheck.newVersion == false) then
		-- check with guild
		if(IsInGuild() and WIM_UpdateCheck.guild == false) then
			WIM_UpdateCheck.guild = true;
			--WIM_SendAddonMessage("VERSION_CHECK#"..WIM_VERSION);
		end
	
		-- check with raid
		if(WIM_UpdateCheck.raid == false and GetNumRaidMembers() > 0) then
			WIM_UpdateCheck.raid = true;
			--WIM_SendAddonMessage("VERSION_CHECK#"..WIM_VERSION);
		elseif(GetNumRaidMembers() == 0) then
			WIM_UpdateCheck.raid = false;
		end
		
		
		--check with party
		if(WIM_UpdateCheck.party == false and WIM_UpdateCheck.raid == false and GetNumPartyMembers() > 0) then
			WIM_UpdateCheck.party = true;
			--WIM_SendAddonMessage("VERSION_CHECK#"..WIM_VERSION);
		elseif(GetNumPartyMembers() == 0) then
			WIM_UpdateCheck.party = false;
		end
	end
end

function WIM_AddonShowWhoResult(theUser, theMessage)
	if(WIM_AddonWhoCheck.waiting) then
		if(WIM_AddonWhoCheck.cache[theUser] == nil) then
			DEFAULT_CHAT_FRAME:AddMessage(theMessage);
			WIM_AddonWhoCheck.cache[theUser] = 1;
			WIM_AddonWhoCheck.count = WIM_AddonWhoCheck.count + 1;
		end
	end
end



function WIM_W2W_Initialize()
	local pluginInfo = {
		version = WIM_W2W_VERSION,
		description = WIM_W2W_LOCALIZED_OPTIONS_DESC,
		optionsFrame = WIM_W2WOptions
	};
	WIM_RegisterPlugin("(W2W) WIM-2-WIM", pluginInfo, "2.2.0");
end


function WIM_W2W_AddonMessageHandler(message, from)
	if(WIM_Data.w2w.enabled == false) then return; end -- w2w is disabled, do not process any inbound requests.
	
	local cmdList = {string.split(";", message)};
	
	if(not WIM_W2W[from]) then WIM_W2W[from] = {}; end
	WIM_W2W[from].stamp = time(); -- recorded for cron cleanup.
	
	if(WIM_Windows[from]) then WIM_Windows[from].isOnline = true; end
	
	for i=1, table.getn(cmdList) do
		local cmd, args, PARTS;
		PARTS = {string.split("#", cmdList[i])};
		cmd = string.upper(PARTS[1]);
		args = "";  -- passed params will go here if sent
		if(table.getn(PARTS) > 1) then args = PARTS[2]; end
		
		if(WIM_DebugW2W == true) then
			DEFAULT_CHAT_FRAME:AddMessage("W2W: RECEIVED FROM "..from.."->"..cmd.."("..args..")"); -- for debugging
		end
		
		if(WIM_W2W_Commands[cmd]) then
			local theFun = WIM_W2W_Commands[cmd];
			theFun(from, args);
		end
	end
end

function WIM_W2W_SendAddonMessage(user, message)
	-- start off by filtering out those of which we do not W2W.
	if(WIM_Data.w2w.enabled == false or WIM_isGM(user)) then return; end -- w2w is disabled, do not process any outbound requests.
	if(user == nil or user == "") then return; end -- do not send message if user is not passed.
	local tParts = {string.split("-", user)};
	if(table.getn(tParts) > 1) then return; end -- do not W2W cross realm users.
	
	SendAddonMessage("WIM_W2W", message, "WHISPER", user);
	if(WIM_DebugW2W == true) then
		DEFAULT_CHAT_FRAME:AddMessage("W2W: SENT TO "..user.."->"..message); -- for debugging
	end
end

function WIM_W2W_LoadCommandList()
	WIM_W2W_Commands["PING"] = WIM_W2W_Command_PING;
	WIM_W2W_Commands["PONG"] = WIM_W2W_Command_PONG;
	WIM_W2W_Commands["PROFILE"] = WIM_W2W_Command_PROFILE;
	WIM_W2W_Commands["ZONEINFO"] = WIM_W2W_Command_ZONEINFO;
	WIM_W2W_Commands["ZONEINFO_UPDATE"] = WIM_W2W_Command_ZONEINFO_UPDATE;
	WIM_W2W_Commands["IS_TYPING"] = WIM_W2W_Command_IS_TYPING;
	WIM_W2W_Commands["POST_MSG_IN"] = WIM_W2W_Command_POST_MSG_IN;
	WIM_W2W_Commands["POST_MSG_OUT"] = WIM_W2W_Command_POST_MSG_OUT;
	WIM_W2W_Commands["SPECINFO"] = WIM_W2W_Command_SPECINFO;
end

function WIM_W2W_CronJob_CleanUp()
	local user;
	for user,_ in pairs(WIM_W2W) do
		if(WIM_W2W[user]) then -- double check incase convo is already closed
			if(WIM_Windows[user]) then
				if((time() - WIM_W2W[user].stamp) > 10) then
					WIM_Windows[user].w2w = false;
					WIM_W2W[user] = nil;
					WIM_SetWhoInfo(user);
				end
			else
				WIM_W2W[user] = nil;
			end
		end
	end
end


function WIM_W2W_CronJob_POSITION()
	local user
	for user,_ in pairs(WIM_Windows) do
		if(WIM_Windows[user].isOnline) then-- if(WIM_W2W[user]) then
			if(WIM_Windows[user].w2w_proc == 5) then
				WIM_W2W_SendAddonMessage(user, "PING");
				WIM_Windows[user].w2w_proc = 0;
			else
				if(WIM_W2W[user]) then
					WIM_W2W_SendAddonMessage(user, "ZONEINFO_UPDATE");
				end
			end
			WIM_Windows[user].w2w_proc = WIM_Windows[user].w2w_proc + 1;
		end
	end
end

function WIM_W2W_Command_PING(from)
	local tmp;
	
	tmp = "PONG#"..WIM_VERSION..";";
	tmp = tmp.."PROFILE#"..WIM_W2W_GetProfileStr()..";";
	tmp = tmp.."SPECINFO#"..WIM_W2W_GetTalentSpec();
	WIM_W2W_SendAddonMessage(from, tmp);
end

function WIM_W2W_Command_PONG(from, tVersion)
	if(WIM_Windows[from]) then
		WIM_W2W[from].version = tVersion;
		WIM_Windows[from].w2w = true;
	end
end

function WIM_W2W_Command_PROFILE(from, args)
	if(WIM_Windows[from]) then
		local tArg = {string.split(",", args)};
		WIM_Windows[from].waiting_who = false;
		WIM_Windows[from].class = tArg[3];
		WIM_Windows[from].level = tArg[1];
		WIM_Windows[from].race = tArg[2];
		WIM_Windows[from].guild = tArg[4];
		WIM_Windows[from].location = tArg[5];
		WIM_W2W[from].location = tArg[5];
		WIM_W2W[from].zoneInfo = {
			C = tonumber(tArg[6]);
			Z = tonumber(tArg[7]);
			x = tonumber(tArg[8]);
			y = tonumber(tArg[9]);
		}
		WIM_SetWhoInfo(from);
	end
end

function WIM_W2W_Command_SPECINFO(from, args)
	if(WIM_Windows[from]) then
		WIM_W2W[from].spec = args;
	end
end

function WIM_W2W_Command_ZONEINFO(from, args)
	if(WIM_Windows[from]) then
		local tArg = {string.split(",", args)};
		WIM_Windows[from].waiting_who = false;
		WIM_Windows[from].location = tArg[1];
		WIM_W2W[from].location = tArg[1];
		WIM_W2W[from].zoneInfo = {
			C = tonumber(tArg[2]);
			Z = tonumber(tArg[3]);
			x = tonumber(tArg[4]);
			y = tonumber(tArg[5]);
		}
		getglobal(WIM_Windows[from].frame).icon:Show(); -- used for minimap tracking.
	end
end

function WIM_W2W_Command_ZONEINFO_UPDATE(from)
	WIM_W2W_SendAddonMessage(from, "ZONEINFO#"..WIM_W2W_GetPositionStr());
end

function WIM_W2W_Command_IS_TYPING(from, status)
	if(WIM_Windows[from]) then
		local theButton = getglobal(WIM_Windows[from].frame.."IsChattingButton");
		theButton.time_elapsed = 0;
		theButton.typing_stamp = time();
		if(status == "TRUE") then
			theButton:Show();
		else
			theButton:Hide();
		end
	end
end

function WIM_W2W_Command_POST_MSG_IN(from, msgInfo)
	local parts = {string.split("^", msgInfo)};
	if(table.getn(parts) < 2) then return; end
	WIM_PassIncomingMessage(parts[1], parts[2])
end

function WIM_W2W_Command_POST_MSG_OUT(from, msgInfo)
	local parts = {string.split("^", msgInfo)};
	if(table.getn(parts) < 2) then return; end
	WIM_PassOutgoingMessage(parts[1], parts[2])
end

function WIM_W2W_GetTalentSpec()
	local talents = {};
	local i=1;
	while i <= GetNumTalentTabs() do
		local name, iconTexture, pointsSpent, background = GetTalentTabInfo(i);
		table.insert(talents, pointsSpent);
		i = i + 1;
	end
	return table.concat(talents, "/");
end

function WIM_W2W_GetProfileStr()
	local guildName, guildRankName, guildRankIndex = GetGuildInfo("player");
	if(not guildName) then guildName = ""; end
	
	return UnitLevel("player")..","..UnitRace("player")..","..UnitClass("player")..","..guildName..","..WIM_W2W_GetPositionStr();
end

function WIM_W2W_GetPositionStr()
	local C, Z, x, y = WIM_Astrolabe:GetCurrentPlayerPosition();
	local zoneInfo, subZoneInfo;
	zoneInfo = GetRealZoneText();
	subZoneInfo = GetSubZoneText();
	if(not C) then C = 0; end
	if(not Z) then Z = 0; end
	if(not x) then x = 0; end
	if(not y) then y = 0; end
	if(subZoneInfo and subZoneInfo ~= zoneInfo and subZoneInfo ~= "") then zoneInfo = "("..zoneInfo..") "..GetSubZoneText(); end
	return zoneInfo..","..C..","..Z..","..x..","..y;
end

------------------------------------------------------------
--               Misc Functions
------------------------------------------------------------

function WIM_PlaySoundWisp()
	if(WIM_Data.playSoundWisp == true) then
		PlaySoundFile("Interface\\AddOns\\WIM\\Sounds\\wisp.wav");
	end
end

function WIM_SendWho(name)
	if(WIM_isGM(name)) then
		WIM_Windows[name].waiting_who = false;
		WIM_Windows[name].guild = "Blizzard";
		WIM_Windows[name].class = WIM_LOCALIZED_GM;
		WIM_SetWhoInfo(name);
	else
		if(WIM_W2W[name]) then return; end
		if(WIM_WhoLib_isLoaded()) then
			WIM_WhoLib_SendWho(name);
		else
			WIM_Windows[name].waiting_who = true;
			SetWhoToUI(1);
			SendWho("\""..name.."\"");
		end
	end
end

function WIM_InitClassProps()
	WIM_ClassColors[WIM_LOCALIZED_DRUID]	= "ff7d0a";
	WIM_ClassColors[WIM_LOCALIZED_HUNTER]	= "abd473";
	WIM_ClassColors[WIM_LOCALIZED_MAGE]	= "69ccf0";
	WIM_ClassColors[WIM_LOCALIZED_PALADIN]	= "f58cba";
	WIM_ClassColors[WIM_LOCALIZED_PRIEST]	= "ffffff";
	WIM_ClassColors[WIM_LOCALIZED_ROGUE]	= "fff569";
	WIM_ClassColors[WIM_LOCALIZED_SHAMAN]	= "00dbba";
	WIM_ClassColors[WIM_LOCALIZED_WARLOCK]	= "9482ca";
	WIM_ClassColors[WIM_LOCALIZED_WARRIOR]	= "c79c6e";
	WIM_ClassColors[WIM_LOCALIZED_GM]	= "00c0ff";
	
	-- accomodate female class names by inherriting data from males.
	WIM_ClassColors[WIM_LOCALIZED_DRUID_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_DRUID];
	WIM_ClassColors[WIM_LOCALIZED_HUNTER_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_HUNTER];
	WIM_ClassColors[WIM_LOCALIZED_MAGE_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_MAGE];
	WIM_ClassColors[WIM_LOCALIZED_PALADIN_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_PALADIN];
	WIM_ClassColors[WIM_LOCALIZED_PRIEST_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_PRIEST];
	WIM_ClassColors[WIM_LOCALIZED_ROGUE_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_ROGUE];
	WIM_ClassColors[WIM_LOCALIZED_SHAMAN_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_SHAMAN];
	WIM_ClassColors[WIM_LOCALIZED_WARLOCK_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_WARLOCK];
	WIM_ClassColors[WIM_LOCALIZED_WARRIOR_FEMALE]	= WIM_ClassColors[WIM_LOCALIZED_WARRIOR];
	
	
	WIM_SpellTree[WIM_LOCALIZED_DRUID] = {
		["1"] = BT and BT["Balance"] or "Balance",
		["2"] = BT and BT["Feral Combat"] or "Feral Combat",
		["3"] = BT and BT["Restoration"] or "Restoration",
	};
	WIM_SpellTree[WIM_LOCALIZED_HUNTER] = {
		["1"] = BT and BT["Beast Mastery"] or "Beast Mastery",
		["2"] = BT and BT["Marksmanship"] or "Marksmanship",
		["3"] = BT and BT["Survival"] or "Survival",
	};
	WIM_SpellTree[WIM_LOCALIZED_MAGE] = {
		["1"] = BT and BT["Arcane"] or "Arcane",
		["2"] = BT and BT["Fire"] or "Fire",
		["3"] = BT and BT["Frost"] or "Frost",
	};
	WIM_SpellTree[WIM_LOCALIZED_PALADIN] = {
		["1"] = BT and BT["Holy"] or "Holy",
		["2"] = BT and BT["Protection"] or "Protection",
		["3"] = BT and BT["Retribution"] or "Retribution",
	};
	WIM_SpellTree[WIM_LOCALIZED_PRIEST] = {
		["1"] = BT and BT["Discipline"] or "Discipline",
		["2"] = BT and BT["Holy"] or "Holy",
		["3"] = BT and BT["Shadow"] or "Shadow",
	};
	WIM_SpellTree[WIM_LOCALIZED_ROGUE] = {
		["1"] = BT and BT["Assassination"] or "Assassination",
		["2"] = BT and BT["Combat"] or "Combat",
		["3"] = BT and BT["Subtlety"] or "Subtlety",
	};
	WIM_SpellTree[WIM_LOCALIZED_SHAMAN] = {
		["1"] = BT and BT["Elemental"] or "Elemental",
		["2"] = BT and BT["Enhancement"] or "Enhancement",
		["3"] = BT and BT["Restoration"] or "Restoration",
	};
	WIM_SpellTree[WIM_LOCALIZED_WARLOCK] = {
		["1"] = BT and BT["Affliction"] or "Affliction",
		["2"] = BT and BT["Demonology"] or "Demonology",
		["3"] = BT and BT["Destruction"] or "Destruction"
	};
	WIM_SpellTree[WIM_LOCALIZED_WARRIOR] = {
		["1"] = BT and BT["Arms"] or "Arms",
		["2"] = BT and BT["Fury"] or "Fury",
		["3"] = BT and BT["Protection"] or "Protection",
	};
	WIM_SpellTree["Hybrid"] = BT and BT["Hybrid"] or "Hybrid";
	
	
	-- accomodate female class names by inherriting data from males.
	WIM_SpellTree[WIM_LOCALIZED_DRUID_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_DRUID];
	WIM_SpellTree[WIM_LOCALIZED_HUNTER_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_HUNTER];
	WIM_SpellTree[WIM_LOCALIZED_MAGE_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_MAGE];
	WIM_SpellTree[WIM_LOCALIZED_PALADIN_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_PALADIN];
	WIM_SpellTree[WIM_LOCALIZED_PRIEST_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_PRIEST];
	WIM_SpellTree[WIM_LOCALIZED_ROGUE_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_ROGUE];
	WIM_SpellTree[WIM_LOCALIZED_SHAMAN_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_SHAMAN];
	WIM_SpellTree[WIM_LOCALIZED_WARLOCK_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_WARLOCK];
	WIM_SpellTree[WIM_LOCALIZED_WARRIOR_FEMALE]	= WIM_SpellTree[WIM_LOCALIZED_WARRIOR];
	
end

function WIM_Bindings_EnableWIM()
	WIM_SetWIM_Enabled(not WIM_Data.enableWIM);
end

function WIM_SetWIM_Enabled(YesOrNo)

	if(YesOrNo) then
		WIM_Core:RegisterEvent("CHAT_MSG_WHISPER");
		WIM_Core:RegisterEvent("CHAT_MSG_WHISPER_INFORM");
		WIM_Core:RegisterEvent("CHAT_MSG_AFK");
		WIM_Core:RegisterEvent("CHAT_MSG_DND");
		WIM_Core:RegisterEvent("CHAT_MSG_SYSTEM");
		WIM_Core:RegisterEvent("CHAT_MSG_ADDON");
		
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", WIM_ChatFrame_MessageEventFilter_WHISPERS);
		ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", WIM_ChatFrame_MessageEventFilter_WHISPERS);
		ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", WIM_ChatFrame_MessageEventFilter_AFK_DND);
		ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", WIM_ChatFrame_MessageEventFilter_AFK_DND);
		ChatFrame_AddMessageEventFilter("CHAT_MSG_SYSTEM", WIM_ChatFrame_MessageEventFilter_SYSTEM);
	else
		WIM_Core:UnregisterEvent("CHAT_MSG_WHISPER");
		WIM_Core:UnregisterEvent("CHAT_MSG_WHISPER_INFORM");
		WIM_Core:UnregisterEvent("CHAT_MSG_AFK");
		WIM_Core:UnregisterEvent("CHAT_MSG_DND");
		WIM_Core:UnregisterEvent("CHAT_MSG_SYSTEM");
		WIM_Core:UnregisterEvent("CHAT_MSG_ADDON");
		
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER", WIM_ChatFrame_MessageEventFilter_WHISPERS);
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_WHISPER_INFORM", WIM_ChatFrame_MessageEventFilter_WHISPERS);
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_AFK", WIM_ChatFrame_MessageEventFilter_AFK_DND);
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_DND", WIM_ChatFrame_MessageEventFilter_AFK_DND);
		ChatFrame_RemoveMessageEventFilter("CHAT_MSG_SYSTEM", WIM_ChatFrame_MessageEventFilter_SYSTEM);
	end

	WIM_Data.enableWIM = YesOrNo
	WIM_Icon_DropDown_Update();
end

function WIM_LoadGuildList()
	local realm = GetCVar("realmName");
	local char = UnitName("player");
	WIM_Cache[realm][char].guildList = {};
	if(IsInGuild()) then
		for i=1, GetNumGuildMembers(true) do 
			local name, junk = GetGuildRosterInfo(i);
			if(name) then
				WIM_Cache[realm][char].guildList[name] = "1"; --[set place holder for quick lookup
			end
		end
	end
	WIM_GuildList = WIM_Cache[realm][char].guildList;
end

function WIM_LoadFriendList()
	local realm = GetCVar("realmName");
	local char = UnitName("player");
	WIM_Cache[realm][char].friendList = {};
	for i=1, GetNumFriends() do 
		local name, junk = GetFriendInfo(i);
		if(name) then
			WIM_Cache[realm][char].friendList[name] = "1"; --[set place holder for quick lookup
		end
	end
	WIM_FriendList = WIM_Cache[realm][char].friendList;
end

function WIM_Split(theString, thePattern)
	local t = {n = 0}
	local fpat = "(.-)"..thePattern
	local last_end = 1
	local s,e,cap = string.find(theString, fpat, 1)
	while s ~= nil do
		if s~=1 or cap~="" then
		table.insert(t,cap)
		end
		last_end = e+1
		s,e,cap = string.find(theString, fpat, last_end)
	end
	if last_end<=string.len(theString) then
		cap = string.sub(theString,last_end)
		table.insert(t,cap)
	end
	return t
end

function WIM_GetBattleWhoInfo(theUser)

	for i=1, GetNumRaidMembers() do 
		local name, rank, subgroup, level, class, fileName, zone, online, isDead = GetRaidRosterInfo(i);
		local race, raceEng = UnitRace("raid"..i);
		local guildName, guildRankName, guildRankIndex = GetGuildInfo("raid"..i);
		if(not guildName) then guildName=""; end
		if(string.lower(name) == string.lower(theUser)) then
			WIM_Windows[theUser].waiting_who = false;
			WIM_Windows[theUser].class = class;
			WIM_Windows[theUser].race = race;
			WIM_Windows[theUser].guild = guildName;
			WIM_Windows[theUser].level = level;
			WIM_Windows[theUser].location = zone;
			WIM_SetWhoInfo(theUser);
			return;
		end
	end
end

function WIM_CompareVersion(newVersion)
	local curVersion = {string.split(".", WIM_VERSION)};
	local newVersion = {string.split(".", newVersion)};
	for i = 1,3 do 
		if(tonumber(newVersion[i]) > tonumber(curVersion[i])) then
			return 1;
		elseif(tonumber(newVersion[i]) < tonumber(curVersion[i])) then
			return -1;
		end
	end
	-- passed version is the same as current version
	return 0;
end

function WIM_API_InsertText(theText)
	if( WIM_EditBoxInFocus ) then
		WIM_EditBoxInFocus:Insert(theText);
	end
end

function WIM_API_WhisperReceived(user, msg)
	--user: WIM user definition, clean no formatting; used to load WIM_Windows[user];\
	--msg: raw, unformatted message.
	--[[
		usage:
			You would want to hook this function and always conclude your hook with a pass to the origional function.
	]]
end

function WIM_isGM(name)
	if(name == nil or name == "") then
		return false;
	end
	if(string.len(name) < 4) then return false; end
	if(string.sub(name, 1, 4) == "<GM>") then
		local tmp = string.gsub(name, "<GM> ", "");
		WIM_GM_Cache[tmp] = 1;
		return true;
	else
		if(WIM_GM_Cache[user]) then
			return true;
		else
			return false;
		end
	end
end

function WIM_ParseNameTag(name)
	if(WIM_isGM(name)) then
		return string.gsub(name, "<GM> ", "");
	end
	
	return name;
end

function WIM_RegisterPlugin(pluginName, pluginInfo, versionRequirement)
	if(type(pluginName) ~= "string" or type(pluginInfo) ~= "table" or type(versionRequirement) ~= "string") then
		message("WIM Plugin Error: Invalid parameters passed to WIM_RegisterPlugin");
		return;
	end
	
	local versionCheck = WIM_CompareVersion(versionRequirement);
	if(versionCheck > 0) then
		message("WIM Plugin Error: "..pluginName.." requires a newer version of WIM.");
		return;		
	end
	
	if(not pluginInfo.version) then
		message("WIM Plugin Error: You must provide a version number.");
		return;
	end
	
	if(WIM_Plugins[pluginName]) then
		message("WIM Plugin Error: A plugin named '"..pluginName.."' has already been loaded!");
		return;		
	end
	
	WIM_Plugins[pluginName] = pluginInfo;
end


function WIM_EditBox_OnChanged()
	-- Added compatability for third-party addons.
	if(IsAddOnLoaded("ItemSync")) then ItemSync:TextChange(); end
end


function WIM_Skinner_Initialize()
	local pluginInfo = {
		version = WIM_SKINNER_VERSION,
		description = WIM_SKINNER_LOCALIZED_OPTIONS_DESC,
		optionsFrame = WIM_SkinnerOptions
	};
	WIM_RegisterPlugin("WIM Skinner", pluginInfo, "2.3.0");
end

function WIM_TalentsToString(theTalents, theUser)
	--passed theTalents in format of "#/#/#";
	local nums = {string.split("/", theTalents)};
	if(table.getn(nums) ~= 3) then return theTalents; end
	
	if(not WIM_SpellTree[WIM_Windows[theUser].class]) then return theTalents; end
	
	local classTree = WIM_SpellTree[WIM_Windows[theUser].class];
	
	if(theTalents == "0/0/0") then return _G.NONE or "None"; end
	
	--calculate which order the tabs should be in; in relation to spec.
	local order = {};
	local num = "";
	for i=1,3 do
		nums[i] = tonumber(nums[i]);
		num = nums[i];
		if(string.len(num) == 1) then num = "0"..num; end
		table.insert(order, num..i);
	end
	table.sort(order);
	
	local first, second, third = tonumber(string.sub(order[3],-1)), tonumber(string.sub(order[2],-1)), tonumber(string.sub(order[1],-1));
	
	if(nums[first]*.75 <= nums[second]) then
		if(nums[first]*.75 <= nums[third]) then
			return WIM_SpellTree["Hybrid"]..": "..theTalents;
		else
			return classTree[tostring(first)].."/"..classTree[tostring(second)]..": "..theTalents;
		end
	else
		return classTree[tostring(first)]..": "..theTalents;
	end
end

function WIM_MsgBoxMenu_Initialize()
	if(not WIM_Windows[WIM_MSGBOX_MENU_CUR_USER]) then
		-- lets avoid any errors. if no user is selected, don't show the menu...
		return;
	end

	local info;
	
	if ( UIDROPDOWNMENU_MENU_LEVEL == 2 ) then
		-- If this is the font size menu then create dropdown
		if ( UIDROPDOWNMENU_MENU_VALUE == WIM_MSGBOX_MENU_HISTORY ) then
			if(table.getn(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].sent_history) > 0) then
				for i=1, table.getn(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].sent_history) do
					info = UIDropDownMenu_CreateInfo();
					info.text = WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].sent_history[i];
					info.func = function()
							if( not IsShiftKeyDown() ) then
								getglobal(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].frame.."MsgBox"):SetText(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].sent_history[i]);
							else
								getglobal(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].frame.."MsgBox"):Insert(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].sent_history[i]);
							end
						end;
					info.tooltipTitle = WIM_MSGBOX_MENU_HISTORY;
				        info.tooltipText = WIM_MSGBOX_MENU_HISTORY_TIP;
					UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
				end
			else
				info = UIDropDownMenu_CreateInfo();
				info.text = WIM_MSGBOX_MENU_HISTORY_NONE;
				info.isTitle = true;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;
		end
		if ( UIDROPDOWNMENU_MENU_VALUE == WIM_MSGBOX_MENU_EMOTICONS ) then
			local emoteDefs = WIM_GetEmoteTable();
			local emoteList = WIM_GetTableOfKeys(emoteDefs);
			for i=1, math.ceil(table.getn(emoteList)/WIM_MSGBOX_MENU_EMOTES_PER_PAGE) do
				info = UIDropDownMenu_CreateInfo();
				info.text = WIM_MSGBOX_MENU_EMOTICONS_PAGE.." "..i;
				info.hasArrow = 1;
				info.func = nil;
				info.notCheckable = 1;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;
		end
		return;
	elseif( UIDROPDOWNMENU_MENU_LEVEL == 3 ) then
		local title, page = strsplit(" ", UIDROPDOWNMENU_MENU_VALUE);
		if(title == WIM_MSGBOX_MENU_EMOTICONS_PAGE) then
			local emoteDefs = WIM_GetEmoteTable();
			local emoteList = WIM_GetTableOfKeys(emoteDefs);
			local min = ((page - 1) * WIM_MSGBOX_MENU_EMOTES_PER_PAGE) + 1;
			local max = min + WIM_MSGBOX_MENU_EMOTES_PER_PAGE - 1;
			if(max > table.getn(emoteList)) then max = table.getn(emoteList); end
			for i=min, max do
				info = UIDropDownMenu_CreateInfo();
				info.icon = emoteList[i];
				info.text = WIM_EmoteListToString(emoteDefs[emoteList[i]].triggers);
				info.func = function()
						getglobal(WIM_Windows[WIM_MSGBOX_MENU_CUR_USER].frame.."MsgBox"):Insert(emoteDefs[emoteList[i]].triggers[1]);
					end;
				UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
			end
			return;
		end
		return;
	end
	
	
	info = UIDropDownMenu_CreateInfo();
	info.text = WIM_MSGBOX_MENU_HISTORY;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
	
	info = UIDropDownMenu_CreateInfo();
	info.text = WIM_MSGBOX_MENU_EMOTICONS;
	info.hasArrow = 1;
	info.func = nil;
	info.notCheckable = 1;
	UIDropDownMenu_AddButton(info);
end

function WIM_EmoteListToString(theTable)
	local tmp = "";
	local j;
	for j=1, table.getn(theTable) do
		if(j > 1) then tmp = tmp.."   "; end
		if((j % 2) == 0) then
			tmp = tmp.."|cff9fd0e9"..theTable[j].."|r";
		else
			tmp = tmp..theTable[j];
		end
	end
	return tmp;
end

function WIM_GetTableOfKeys(theTable)
	local tmp = {};
	for key,_ in pairs(theTable) do
		table.insert(tmp, key);
	end
	return tmp;
end

function WIM_ClearKeyTable(theTable)
	local key;
	for key, _ in pairs(theTable) do
		theTable[key] = nil;
	end
end

------------------------------------------------------------
--               Debugging Functions
------------------------------------------------------------
function WIM_DumpVar(theVar)
	WIM_Help:Show();
	WIM_HelpScrollFrameScrollChildText:SetText(WIM_DumpVarRecursive(theVar));
end

function WIM_DumpVarRecursive(theVar, indent)
	if(indent == nil) then indent = 0; end
	
	local strIndent = "";
	for i = 1, indent do
		strIndent = strIndent.."    ";
	end
	
	if(type(theVar) == "nil") then 
			return "|cffffffffnil|r"; 
	end
	
		if(type(theVar) == "boolean") then 
			return "|cffffffffboolean("..tostring(theVar)..")|r"; 
	end
	
	if(type(theVar) == "string") then 
		return "|cffffffff\""..theVar.."\"|r"; 
	end
	
	if(type(theVar) == "table") then
		local str = "|cffffffff{|r\n";
		for key,val in pairs(theVar) do
			str = str..strIndent.."    "..key.." = "..WIM_DumpVarRecursive(val, (indent + 1))..",\n";
		end
		return str..strIndent.."|cffffffff}|r";
	end
	
	return "|cffffffff"..tostring(theVar).."|r";
end






