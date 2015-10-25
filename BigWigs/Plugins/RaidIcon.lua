﻿assert(BigWigs, "BigWigs not found!")

------------------------------
--      Are you local?      --
------------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsRaidIcon")
local lastplayer = nil

local RL = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Raid Icons"] = true,
	["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."] = true,

	["RaidIcon"] = true,

	["Place"] = true,
	["Place Raid Icons"] = true,
	["Toggle placing of Raid Icons on players."] = true,

	["Icon"] = true,
	["Set Icon"] = true,
	["Set which icon to place on players."] = true,

	["Use the %q icon when automatically placing raid icons for boss abilities."] = true,

	["Star"] = true,
	["Circle"] = true,
	["Diamond"] = true,
	["Triangle"] = true,
	["Moon"] = true,
	["Square"] = true,
	["Cross"] = true,
	["Skull"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	["Raid Icons"] = "공격대 아이콘",

	["Place"] = "지정",
	["Place Raid Icons"] = "공격대 아이콘 지정",
	["Toggle placing of Raid Icons on players."] = "플레이어에 공격대 아이콘을 지정합니다.",

	["Icon"] = "아이콘",
	["Set Icon"] = "아이콘 설정",
	["Set which icon to place on players."] = "플레이어에 지정할 아이콘을 설정합니다.",

	["Star"] = "별",
	["Circle"] = "원",
	["Diamond"] = "다이아몬드",
	["Triangle"] = "세모",
	["Moon"] = "달",
	["Square"] = "네모",
	["Cross"] = "가위표",
	["Skull"] = "해골",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["Raid Icons"] = "团队标记",

	["RaidIcon"] = "团队标记",

	["Place"] = "设置",
	["Place Raid Icons"] = "允许团队标记",
	["Toggle placing of Raid Icons on players."] = "选择是否在玩家身上显示团队图标标记 .",

	["Icon"] = "图标",
	["Set Icon"] = "设置标记",
	["Set which icon to place on players."] = "设置玩家身上团队标记.",

	["Star"] = "星形",
	["Circle"] = "圆圈",
	["Diamond"] = "棱形",
	["Triangle"] = "三角",
	["Moon"] = "月亮",
	["Square"] = "方形",
	["Cross"] = "十字",
	["Skull"] = "骷髅",
} end )

L:RegisterTranslations("zhTW", function() return {
	["Raid Icons"] = "團隊圖示",

	["Place"] = "標記",
	["Place Raid Icons"] = "標記團隊圖示",
	["Toggle placing of Raid Icons on players."] = "切換是否在玩家身上標記團隊圖示",

	["Icon"] = "圖標",
	["Set Icon"] = "設置圖示",
	["Set which icon to place on players."] = "設置玩家身上標記的圖示。",

	["Star"] = "星星",
	["Circle"] = "圓圈",
	["Diamond"] = "方塊",
	["Triangle"] = "三角",
	["Moon"] = "月亮",
	["Square"] = "方形",
	["Cross"] = "十字",
	["Skull"] = "骷髏",
} end )

L:RegisterTranslations("deDE", function() return {
	["Raid Icons"] = "Schlachtzug-Symbole",

	["Place"] = "Platzierung",
	["Place Raid Icons"] = "Schlachtzug-Symbole platzieren",
	["Toggle placing of Raid Icons on players."] = "Schlachtzug-Symbole auf Spieler setzen.",

	["Icon"] = "Symbol",
	["Set Icon"] = "Symbol platzieren",
	["Set which icon to place on players."] = "W\195\164hle, welches Symbol auf Spieler gesetzt wird.",

	["Star"] = "Stern",
	["Circle"] = "Kreis",
	["Diamond"] = "Diamant",
	["Triangle"] = "Dreieck",
	["Moon"] = "Mond",
	["Square"] = "Quadrat",
	["Cross"] = "Kreuz",
	["Skull"] = "Totenkopf",
} end )

L:RegisterTranslations("frFR", function() return {
	["Raid Icons"] = "Icônes de raid",

	["Place"] = "Placement",
	["Place Raid Icons"] = "Placer les icônes de raid",
	["Toggle placing of Raid Icons on players."] = "Place ou non les icônes de raid sur les joueurs.",

	["Icon"] = "Icône",
	["Set Icon"] = "Déterminer l'icône",
	["Set which icon to place on players."] = "Détermine quelle icône sera placée sur les joueurs.",

	["Star"] = "étoile",
	["Circle"] = "cercle",
	["Diamond"] = "diamant",
	["Triangle"] = "triangle",
	["Moon"] = "lune",
	["Square"] = "carré",
	["Cross"] = "croix",
	["Skull"] = "crâne",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local plugin = BigWigs:NewModule("Raid Icons")

plugin.revision = tonumber(("$Revision: 46780 $"):sub(12, -3))
plugin.defaultDB = {
	place = true,
	icon = 8,
}

local function get(key)
	return plugin.db.profile.icon == key
end
local function set(key, val)
	plugin.db.profile.icon = key
end
local function disabled()
	return not plugin.db.profile.place
end

plugin.consoleCmd = L["RaidIcon"]
plugin.consoleOptions = {
	type = "group",
	name = L["Raid Icons"],
	desc = L["Configure which icon Big Wigs should use when placing raid target icons on players for important 'bomb'-type boss abilities."],
	args   = {
		place = {
			type = "toggle",
			name = L["Place Raid Icons"],
			desc = L["Toggle placing of Raid Icons on players."],
			get = function() return plugin.db.profile.place end,
			set = function(v) plugin.db.profile.place = v end,
			order = 1,
		},
		spacer = {
			type = "header",
			name = " ",
			order = 50,
		},
		Star = {
			type = "toggle",
			name = L["Star"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Star"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 101,
			passValue = 1,
		},
		Circle = {
			type = "toggle",
			name = L["Circle"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Circle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 102,
			passValue = 2,
		},
		Diamond = {
			type = "toggle",
			name = L["Diamond"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Diamond"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 103,
			passValue = 3,
		},
		Triangle = {
			type = "toggle",
			name = L["Triangle"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Triangle"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 104,
			passValue = 4,
		},
		Moon = {
			type = "toggle",
			name = L["Moon"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Moon"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 105,
			passValue = 5,
		},
		Square = {
			type = "toggle",
			name = L["Square"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Square"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 106,
			passValue = 6,
		},
		Cross = {
			type = "toggle",
			name = L["Cross"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Cross"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 107,
			passValue = 7,
		},
		Skull = {
			type = "toggle",
			name = L["Skull"],
			desc = L["Use the %q icon when automatically placing raid icons for boss abilities."]:format(L["Skull"]),
			isRadio = true,
			get = get,
			set = set,
			disabled = disabled,
			order = 108,
			passValue = 8,
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function plugin:OnEnable()
	self:RegisterEvent("BigWigs_SetRaidIcon")
	self:RegisterEvent("BigWigs_RemoveRaidIcon")

	if type(self.db.profile.icon) ~= "number" then
		self.db.profile.icon = 8
	end

	if AceLibrary:HasInstance("Roster-2.1") then
		RL = AceLibrary("Roster-2.1")
	end
end

function plugin:BigWigs_SetRaidIcon(player)
	if not player or not self.db.profile.place then return end
	local icon = self.db.profile.icon or 8
	if RL then
		local id = RL:GetUnitIDFromName(player)
		if id and not GetRaidTargetIndex(id) then
			SetRaidTargetIcon(id, icon)
			lastplayer = player
		end
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName("raid"..i) == player then
				if not GetRaidTargetIndex("raid"..i) then
					SetRaidTargetIcon("raid"..i, icon)
					lastplayer = player
				end
			end
		end
	end
end

function plugin:BigWigs_RemoveRaidIcon()
	if not lastplayer or not self.db.profile.place then return end
	if RL then
		local id = RL:GetUnitIDFromName(lastplayer)
		if id then
			SetRaidTargetIcon(id, 0)
		end
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName("raid"..i) == lastplayer then
				SetRaidTargetIcon("raid"..i, 0)
			end
		end
	end
	lastplayer = nil
end


