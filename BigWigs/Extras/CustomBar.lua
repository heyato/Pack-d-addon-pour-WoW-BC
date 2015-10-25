﻿assert(BigWigs, "BigWigs not found!")

----------------------------
--      Localization      --
----------------------------

local L = AceLibrary("AceLocale-2.2"):new("BigWigsCustomBar")

local times = nil

L:RegisterTranslations("enUS", function() return {
	["bwcb"] = true,
	["bwlcb"] = true,
	["CustomBars"] = true,
	["Custom Bars"] = true,
	["Start a custom bar, either local or global."] = true,
	["Local"] = true,
	["Global"] = true,
	["<seconds> <bar text>"] = true,
	["Starts a custom bar with the given parameters."] = true,
	["%s: %s"] = true,
	["%s: Timer [%s] finished."] = true,
} end)

L:RegisterTranslations("koKR", function() return {
	["Custom Bars"] = "사용자 바",
	["Start a custom bar, either local or global."] = "글로벌 혹은 로컬 사용자 바를 시작합니다.",
	["Local"] = "로컬",
	["Global"] = "글로벌",
	["<seconds> <bar text>"] = "<초> <바 텍스트>",
	["Starts a custom bar with the given parameters."] = "입력한 매개변수로 사용자 바를 시작합니다.",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: [%s] 타이머가 종료되었습니다.",
} end)

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["bwcb"] = "bwcb",
	["bwlcb"] = "bwcb",
	["CustomBars"] = "自定义计时条",
	["Custom Bars"] = "自定义计时条",
	["Start a custom bar, either local or global."] = "启动自定义时间条,本地或全局",
	["Local"] = "本地",
	["Global"] = "全局",
	["<seconds> <bar text>"] = "<秒> <计时条名字>",
	["Starts a custom bar with the given parameters."] = "启动自定义时间条",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: 计时器 [%s] 到时间.",
} end)

L:RegisterTranslations("zhTW", function() return {
	["bwcb"] = "bwcb",
	["bwlcb"] = "bwlcb",
	["CustomBars"] = "自定時間條",
	["Custom Bars"] = "自定時間條",
	["Start a custom bar, either local or global."] = "開始一個自定時間條，區域或者全域",
	["Local"] = "區域",
	["Global"] = "全域",
	["<seconds> <bar text>"] = "<秒> <列文字>",
	["Starts a custom bar with the given parameters."] = "開始一個包含參數的自定時間條",
	["%s: %s"] = "%s: %s",
	["%s: Timer [%s] finished."] = "%s: 計時器 [%s] 終了。",
} end)

L:RegisterTranslations("deDE", function() return {
	-- ["bwcb"] = true,
	-- ["bwlcb"] = true,
	-- ["CustomBars"] = true,
	["Custom Bars"] = "Individuelle Anzeigebalken",
	["Start a custom bar, either local or global."] = "Einen individuellen Anzeigebalken starten (entweder lokal oder global).",
	["Local"] = "Lokal",
	["Global"] = "Global",
	["<seconds> <bar text>"] = "<Sekunden> <Balkentext>",
	["Starts a custom bar with the given parameters."] = "Einen individuellen Anzeigebalken mit den gegebenen Parametern starten. \n<Sekunden> <Balkentext>",
	-- ["%s: %s"] = true,
	["%s: Timer [%s] finished."] = "%s: Timer [%s] beendet.",
} end)

L:RegisterTranslations("frFR", function() return {
	["Custom Bars"] = "Barres personnalisées",
	["Start a custom bar, either local or global."] = "Démarre une barre personnalisée, soit personnelle, soit globale.",
	["Local"] = "Personnelle",
	["Global"] = "Globale",
	["<seconds> <bar text>"] = "<secondes> <texte de la barre>",
	["Starts a custom bar with the given parameters."] = "Démarre une barre personnalisée avec les paramètres indiqués.",
	["%s: %s"] = "%s : %s",
	["%s: Timer [%s] finished."] = "%s: Délai [%s] terminé.",
} end)

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(L["Custom Bars"])
mod.revision = tonumber(("$Revision: 46713 $"):sub(12, -3))
mod.external = true
mod.consoleCmd = L["CustomBars"]
mod.consoleOptions = {
	type = "group",
	name = L["Custom Bars"],
	desc = L["Start a custom bar, either local or global."],
	args = {
		[L["Global"]] = {
			type = "text",
			name = L["Global"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) mod:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..v) end,
			usage = L["<seconds> <bar text>"],
			disabled = function() return (not IsRaidLeader() and not IsRaidOfficer()) and UnitInRaid("player") end,
		},
		[L["Local"]] = {
			type = "text",
			name = L["Local"],
			desc = L["Starts a custom bar with the given parameters."],
			get = false,
			set = function(v) mod:StartBar(v, nil, true) end,
			usage = L["<seconds> <bar text>"],
		},
	},
}

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self.enabled = true
	times = {}

	self:RegisterShortHand()

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "BWCustomBar", 0)
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync ~= "BWCustomBar" or not rest or not nick or not self.enabled then return end

	if UnitInRaid("player") then
		for i = 1, GetNumRaidMembers() do
			local name, rank = GetRaidRosterInfo(i)
			if name == nick then
				if rank == 0 then
					return
				else
					break
				end
			end
		end
	end

	self:StartBar(rest, nick, false)
end

------------------------------
--      Utility             --
------------------------------

function mod:StartBar(bar, nick, localOnly)
	local seconds, barText = select(3, bar:find("(%d+) (.*)"))
	if not seconds or not barText then return end
	seconds = tonumber(seconds)
	if seconds == nil then return end

	if not nick then nick = L["Local"] end
	if seconds == 0 then
		self:CancelScheduledEvent("bwcb"..nick..barText)
		self:TriggerEvent("BigWigs_StopBar", self, L["%s: %s"]:format(nick, barText))
	else
		self:ScheduleEvent("bwcb"..nick..barText, "BigWigs_Message", seconds, L["%s: Timer [%s] finished."]:format(nick, barText), "Attention", localOnly)
		self:TriggerEvent("BigWigs_StartBar", self, L["%s: %s"]:format(nick, barText), seconds, "Interface\\Icons\\INV_Misc_PocketWatch_01")
	end
end

-- For easy use in macros.
function BWCB(seconds, message)
	if message then seconds = tostring(seconds) .. " " .. message end
	local t = GetTime()
	if ( not times[seconds] ) or ( times[seconds] and ( times[seconds] + 2 ) < t) then
		times[seconds] = t
		mod:TriggerEvent("BigWigs_SendSync", "BWCustomBar "..seconds)
	end
end

function BWLCB(seconds, message)
	if message then seconds = tostring(seconds) .. " " .. message end
	mod:StartBar(seconds, nil, true)
end

-- Shorthand slashcommand
function mod:RegisterShortHand()
	if SlashCmdList then
		SlashCmdList["BWCB_SHORTHAND"] = BWCB
		setglobal("SLASH_BWCB_SHORTHAND1", "/"..L["bwcb"])
		SlashCmdList["BWLCB_SHORTHAND"] = BWLCB
		setglobal("SLASH_BWLCB_SHORTHAND1", "/"..L["bwlcb"])
	end
end

