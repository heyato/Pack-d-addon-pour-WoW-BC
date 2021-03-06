﻿assert(BigWigs, "BigWigs not found!")

local BZ = nil
local L = AceLibrary("AceLocale-2.2"):new("BigWigsVersionQuery")
local tablet = nil
local dewdrop = AceLibrary("Dewdrop-2.0")

local COLOR_GREEN = "00ff00"
local COLOR_RED = "ff0000"
local COLOR_WHITE = "ffffff"

local queryRunning = nil

local responseTable = nil

local zoneRevisions = nil
local currentZone = ""

local new, del
do
	local cache = setmetatable({},{__mode='k'})
	function new(...)
		local t = next(cache)
		if t then
			cache[t] = nil
			for i = 1, select("#", ...) do
				t[i] = select(i, ...)
			end
			return t
		else
			return { ... }
		end
	end
	function del(t)
		for k in pairs(t) do
			t[k] = nil
		end
		cache[t] = true
		return nil
	end
end

---------------------------------
--      Localization           --
---------------------------------

L:RegisterTranslations("enUS", function() return {
	["Version Query"] = true,
	["Commands for querying the raid for Big Wigs versions."] = true,
	["Query already running, please wait 5 seconds before trying again."] = true,
	["Querying versions for "] = true,
	["Big Wigs Version Query"] = true,
	["Close window"] = true, -- I know, it's really a Tablet.
	["Showing version for "] = true,
	["Green versions are newer than yours, red are older, and white are the same."] = true,
	["Player"] = true,
	["Version"] = true,
	["Current zone"] = true,
	["<zone>"] = true,
	["Version query done."] = true,
	["Runs a version query on your current zone."] = true,
	["Closes the version query window."] = true,
	["current"] = true,
	["Runs a version query on the given zone."] = true,
	["Zone"] = true,
	["zone"] = true,
	["N/A"] = true,
	["Not loaded"] = true,
	["BigWigs"] = true,
	["Runs a version query on the BigWigs core."] = true,
	["Replies"] = true,
	["Ancient"] = true,
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = true,
	["Notify people with older versions that there is a new version available."] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	["Version Query"] = "버전 요청",
	["Commands for querying the raid for Big Wigs versions."] = "BigQigs 버전에 대한 공격대 요청 관련 명령어입니다.",
	["Query already running, please wait 5 seconds before trying again."] = "이미 요청 중, 5초후 다시 시도하세요.",
	["Querying versions for "] = "버전 요청 중 : ",
	["Big Wigs Version Query"] = "BigWigs 버전 요청",
	["Close window"] = "창 닫기", -- I know, it's really a Tablet.
	["Showing version for "] = "버전 표시 중 ",
	["Green versions are newer than yours, red are older, and white are the same."] = "녹색 : 최신, 붉은색 : 이전, 흰색 : 같음(자신 기준)",
	["Player"] = "플레이어",
	["Version"] = "버전",
	["Current zone"] = "현재 지역",
	["<zone>"] = "<지역>",
	["Version query done."] = "버전 요청 완료.",
	["Runs a version query on your current zone."] = "현재 지역내 동작 모듈의 버전 요청을 수행합니다.",
	["Closes the version query window."] = "버전 확인 창을 닫습니다.",
	["Runs a version query on the given zone."] = "주어진 지역내 동작 모듈의 버전 요청을 수행합니다.",
	["Zone"] = "지역",
	["N/A"] = "N/A",
	["Not loaded"] = "로드되지 않았습니다",
} end )

L:RegisterTranslations("deDE", function() return {
	["Version Query"] = "Versionsabfrage",
	["Commands for querying the raid for Big Wigs versions."] = "Kommandos um den Schlachtzug nach verwendeten BigWigs Versionen abzufragen.",
	["Query already running, please wait 5 seconds before trying again."] = "Abfrage l\195\164uft bereits, bitte 5 Sekunden warten bis zum n\195\164chsten Versuch.",
	["Querying versions for "] = "Frage Versionen ab f\195\188r ",
	["Big Wigs Version Query"] = "BigWigs Versionsabfrage",
	["Close window"] = "Fenster Schlie\195\159en", -- I know, it's really a Tablet.
	["Showing version for "] = "Zeige Version f\195\188r ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Gr\195\188ne Versionen sind neuer, rote sind \195\164lter, wei\195\159e sind gleich.",
	["Player"] = "Spieler",
	["Version"] = "Version",
	["Current zone"] = "Momentane Zone",
	-- ["<zone>"] = true,
	["Version query done."] = "Versionsabfrage beendet.",
	["Runs a version query on your current zone."] = "Versionsabfrage f\195\188r die momentane Zone durchf\195\188hren.",
	["Closes the version query window."] = "Schlie\195\159t das Versionsabfrage-Fenster.",
	-- ["current"] = true,
	["Runs a version query on the given zone."] = "Versionsabfrage in f\195\188r eine gegebene Zone durchf\195\188hren.",
	["Zone"] = "Zone",
	-- ["zone"] = true,
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Versionsabfrage f\195\188r die BigWigs Kernkomponente durchf\195\188hren.",
	["Replies"] = "Anzahl der Antworten",
	["Ancient"] = "Alt",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "Es scheint eine neuere Version von BigWigs bereit zu stehen, bitte upgraden.",
	["Notify people with older versions that there is a new version available."] = "Personen mit einer \195\164lteren BigWigs Version benachrichtigen, dass eine neue Version bereit steht.",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://cwowaddon.com

L:RegisterTranslations("zhCN", function() return {
	["Version Query"] = "版本检测",
	["Commands for querying the raid for Big Wigs versions."] = "bigwigs版本检测参数",
	["Query already running, please wait 5 seconds before trying again."] = "正在查询中,请等待5秒后再次尝试.",
	["Querying versions for "] = "正在检测版本 ",
	["Big Wigs Version Query"] = "BigWigs版本检测",
	["Close window"] = "关闭窗口", -- I know, it's really a Tablet.
	["Showing version for "] = "显示版本: ",
	["Green versions are newer than yours, red are older, and white are the same."] = "绿色版本比您的新,红色比您的低,白色与您的版本相同.",
	["Player"] = "玩家",
	["Version"] = "版本",
	["Current zone"] = "当前区域",
	["<zone>"] = "<区域>",
	["Version query done."] = "版本检测已完成",
	["Runs a version query on your current zone."] = "对当前区域进行版本检测.",
	["Closes the version query window."] = "关闭版本查询窗口.",
	["current"] = "当前",
	["Runs a version query on the given zone."] = "在给指定的区域进行版本查询.",
	["Zone"] = "区域",
	["zone"] = "区域",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "在BigWigs核心部分运行版本查询",
	["Replies"] = "回应人数",
	["Ancient"] = "旧版本",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "发现Big Wigs新版本，请升级！",
	["Notify people with older versions that there is a new version available."] = "通知使用旧版本的用户请升级到最新。",
} end )

L:RegisterTranslations("zhTW", function() return {
	["Version Query"] = "檢查版本",
	["Commands for querying the raid for Big Wigs versions."] = "用於檢查BigWigs的版本",
	["Query already running, please wait 5 seconds before trying again."] = "檢查中，若要再次檢查，請稍後5秒",
	["Querying versions for "] = "檢查版本 ",
	["Big Wigs Version Query"] = "Big Wigs版本檢查",
	["Close window"] = "關閉窗口", -- I know, it's really a Tablet.
	["Showing version for "] = "顯示版本 ",
	["Green versions are newer than yours, red are older, and white are the same."] = "綠色的版本比你的新，紅色的比較舊，白色則表示版本相同",
	["Player"] = "玩家",
	["Version"] = "版本",
	["Current zone"] = "目前區域",
	["<zone>"] = "<區域>",
	["Version query done."] = "完成檢查版本",
	["Runs a version query on your current zone."] = "檢查目前區域的版本",
	["Closes the version query window."] = "關掉目前的檢查版本視窗",
	["current"] = "目前",
	["Runs a version query on the given zone."] = "檢查指定區域的版本",
	["Zone"] = "區域",
	["zone"] = "區域",
	["N/A"] = "N/A",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "檢查BigWigs核心的版本",
	["Replies"] = "回應人數",
	["Ancient"] = "舊版本",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "發現 BigWigs 新版本，可以考慮升級！",
	["Notify people with older versions that there is a new version available."] = "通知使用舊版本使用者升級到最新版本。",

} end )

L:RegisterTranslations("frFR", function() return {
	["Version Query"] = "Vérification des versions",
	["Commands for querying the raid for Big Wigs versions."] = "Commandes de vérification des version de BigWigs du raid.",
	["Query already running, please wait 5 seconds before trying again."] = "Une vérification est déjà en cours, veuillez réessayer dans 5 secondes.",
	["Querying versions for "] = "Vérification des versions pour ",
	["Big Wigs Version Query"] = "Vérification des versions de BigWigs",
	["Close window"] = "Fermer la fenêtre", -- I know, it's really a Tablet.
	["Showing version for "] = "Affichage des versions pour ",
	["Green versions are newer than yours, red are older, and white are the same."] = "Les versions en vert sont plus récentes que la votre, celles en rouge plus anciennes, et celles en blanc les mêmes.",
	["Player"] = "Joueur",
	["Version"] = "Version",
	["Current zone"] = "Zone actuelle",
	["<zone>"] = "<zone>",
	["Version query done."] = "Vérification des versions terminée.",
	["Runs a version query on your current zone."] = "Effectue une vérification des versions dans votre zone.",
	["Closes the version query window."] = "Ferme la fenêtre de vérification des versions.",
	["Runs a version query on the given zone."] = "Effectue une vérification des versions dans la zone donnée.",
	["Zone"] = "Zone",
	["N/A"] = "N/A",
	["Not loaded"] = "Non chargé",
	["BigWigs"] = "BigWigs",
	["Runs a version query on the BigWigs core."] = "Effectue une vérification des versions du noyau de BigWigs.",
	["Replies"] = "Nbre de réponses",
	["Ancient"] = "Ancien",
	["There seems to be a newer version of Big Wigs available for you, please upgrade."] = "Une nouvelle version de Big Wigs est disponible. Mise à jour conseillée !",
	["Notify people with older versions that there is a new version available."] = "Préviens les personnes possédant des versions anciennes qu'une nouvelle version est disponible.",
} end )

---------------------------------
--      Addon Declaration      --
---------------------------------

local plugin = BigWigs:NewModule("Version Query")

plugin.revision = tonumber(("$Revision: 42823 $"):sub(12, -3))
plugin.external = true

local function disabled()
	return not BigWigs:HasModule("Comm")
end

plugin.consoleCmd = L["Version"]
plugin.consoleOptions = {
	type = "group",
	name = L["Version Query"],
	desc = L["Commands for querying the raid for Big Wigs versions."],
	handler = plugin,
	args = {
		[L["BigWigs"]] = {
			type = "execute",
			name = L["BigWigs"],
			desc = L["Runs a version query on the BigWigs core."],
			passValue = "BigWigs",
			func = "QueryVersion",
			disabled = disabled,
		},
		[L["current"]] = {
			type = "execute",
			name = L["Current zone"],
			desc = L["Runs a version query on your current zone."],
			func = "QueryVersion",
			disabled = disabled,
		},
		[L["zone"]] = {
			type = "text",
			name = L["Zone"],
			desc = L["Runs a version query on the given zone."],
			usage = L["<zone>"],
			get = false,
			set = "QueryVersion",
			disabled = disabled,
		},
	}
}

------------------------------
--      Initialization      --
------------------------------

local function addZone(zone, rev)
-- Make sure to get the enUS zone name.
	local z = BZ:HasReverseTranslation(zone) and BZ:GetReverseTranslation(zone) or zone
	if not zoneRevisions[z] or rev > zoneRevisions[z] then
		zoneRevisions[z] = rev
	end
end

local function populateRevisions()
	if not zoneRevisions then zoneRevisions = {} end

	if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
	for name, module in BigWigs:IterateModules() do
		if module:IsBossModule() then
			if type(module.zonename) == "table" then
				for i, v in ipairs(module.zonename) do
					addZone(v, module.revision)
				end
			elseif type(module.zonename) == "string" then
				addZone(module.zonename, module.revision)
			end
		end
	end
	zoneRevisions["BigWigs"] = BigWigs.revision
end

function plugin:OnEnable()
	self:RegisterEvent("CHAT_MSG_ADDON")
	self:RegisterEvent("BigWigs_ModulePackLoaded", populateRevisions)
end

------------------------------
--      Event Handlers      --
------------------------------

local function sortResponses(a, b)
	-- a should be before b if the version is higher, or if the version is the
	-- same and the name is alphabetically before b.
	if a[2] > b[2] or (a[2] == b[2] and a[1] > b[1]) then
		return false
	else
		return true
	end
end

local function getFormattedVersionText(info)
	local name = info[1]
	local version = info[2]
	if version == -1 then
		return name, "|cff"..COLOR_RED..L["N/A"].."|r"
	elseif version == -2 then
		return name, "|cff"..COLOR_RED..L["Not loaded"].."|r"
	else
		if not zoneRevisions then populateRevisions() end
		local color = COLOR_WHITE
		if zoneRevisions[currentZone] and version > zoneRevisions[currentZone] then
			color = COLOR_GREEN
		elseif zoneRevisions[currentZone] and version < zoneRevisions[currentZone] then
			hasOld = true
			color = COLOR_RED
		end
		return name, "|cff" .. color .. version .. "|r"
	end
end

local function updateTabletDisplay()
	if not responseTable then return end

	local infoCat = tablet:AddCategory(
		"columns", 2,
		"child_textR", 1,
		"child_textG", 1,
		"child_textB", 0,
		"child_text2R", 1,
		"child_text2G", 1,
		"child_text2B", 1
	)
	infoCat:AddLine("text", L["Zone"], "text2", currentZone)
	infoCat:AddLine("text", L["Replies"], "text2", #responseTable)
	local cat = tablet:AddCategory(
		"columns", 2,
		"text", L["Player"],
		"text2", L["Version"]
	)

	table.sort(responseTable, sortResponses)

	for i, info in ipairs(responseTable) do
		local t1, t2 = getFormattedVersionText(info)
		cat:AddLine("text", t1, "text2", t2)
	end

	if responseTable and (IsRaidLeader() or IsRaidOfficer()) then
		local alertCat = tablet:AddCategory("columns", 1)
		alertCat:AddLine(
			"text", L["Notify people with older versions that there is a new version available."],
			"wrap", true,
			"func", plugin.AlertOldRevisions,
			"arg1", plugin
		)
	end

	tablet:SetHint(L["Green versions are newer than yours, red are older, and white are the same."])
end

function plugin:UpdateDisplay()
	if tablet then
		if not tablet:IsRegistered("BigWigs_VersionQuery") then
			tablet:Register("BigWigs_VersionQuery",
				"children", function()
					tablet:SetTitle(L["Big Wigs Version Query"])
					updateTabletDisplay()
				end,
				"clickable", true,
				"showTitleWhenDetached", true,
				"showHintWhenDetached", true,
				"cantAttach", true,
				"menu", function()
					dewdrop:AddLine(
						"text", L["BigWigs"],
						"tooltipTitle", L["BigWigs"],
						"tooltipText", L["Runs a version query on the BigWigs core."],
						"func", function() self:QueryVersion("BigWigs") end)
					dewdrop:AddLine(
						"text", L["Current zone"],
						"tooltipTitle", L["Current zone"],
						"tooltipText", L["Runs a version query on your current zone."],
						"func", function() self:QueryVersion() end)
					dewdrop:AddLine(
						"text", L["Close window"],
						"tooltipTitle", L["Close window"],
						"tooltipText", L["Closes the version query window."],
						"func", function()
							tablet:Attach("BigWigs_VersionQuery")
							dewdrop:Close()
						end)
				end
			)
		end
		if tablet:IsAttached("BigWigs_VersionQuery") then
			tablet:Detach("BigWigs_VersionQuery")
		else
			tablet:Refresh("BigWigs_VersionQuery")
		end
	end
end

function plugin:AlertOldRevisions()
	if not responseTable or (not IsRaidLeader() and not IsRaidOfficer()) then return end
	local myVersion = zoneRevisions[currentZone]
	if not myVersion then return end
	for i, info in ipairs(responseTable) do
		local name = info[1]
		local version = info[2]
		if version < myVersion and version > 0 then
			self:TriggerEvent("BigWigs_SendTell", name, L["There seems to be a newer version of Big Wigs available for you, please upgrade."])
		end
	end
end

local function resetQueryRunning()
	queryRunning = nil

	-- If the user doesn't have Tablet-2.0, just print everything to chat.
	if not tablet and responseTable then
		table.sort(responseTable, sortResponses)
		for i, info in ipairs(responseTable) do
			local t1, t2 = getFormattedVersionText(info)
			DEFAULT_CHAT_FRAME:AddMessage(t1 .. ": " .. t2 .. ".")
		end
	end
	BigWigs:Print(L["Version query done."])
end

function plugin:QueryVersion(zone)
	if queryRunning then
		BigWigs:Print(L["Query already running, please wait 5 seconds before trying again."])
		return
	end

	if not tablet then
		tablet = AceLibrary:HasInstance("Tablet-2.0") and AceLibrary("Tablet-2.0") or nil
		if not tablet then
			error("You need a copy of the Tablet-2.0 library to be able to *run* a version check right now. This should be fixed shortly.")
			return
		end
	end

	if type(zone) ~= "string" or zone == "" then zone = GetRealZoneText() end
	-- If this is a shorthand zone, convert it to enUS full.
	-- Also, if this is a shorthand, we can't really know if the user is enUS or not.

	if not zone then
		error("The given zone is invalid.")
		return
	end

	-- ZZZ |zone| should be translated here.
	BigWigs:Print(L["Querying versions for "].."|cff"..COLOR_GREEN..zone.."|r.")

	-- If this is a non-enUS zone, convert it to enUS.
	if not BZ then BZ = AceLibrary("Babble-Zone-2.2") end
	if BZ:HasReverseTranslation(zone) then zone = BZ:GetReverseTranslation(zone) end

	currentZone = zone

	queryRunning = true
	self:ScheduleEvent(resetQueryRunning, 5)

	if responseTable then
		for i in ipairs(responseTable) do
			responseTable[i] = del(responseTable[i])
		end
		responseTable = del(responseTable)
	end
	responseTable = new()

	if not zoneRevisions then populateRevisions() end
	table.insert(responseTable, new(UnitName("player"), self:GetVersion(zone)))

	self:UpdateDisplay()

	SendAddonMessage("BWVQ", zone, "RAID")
end

function plugin:GetVersion(zone)
	if not zoneRevisions then populateRevisions() end
	local rev = -1
	if zoneRevisions[zone] then
		rev = zoneRevisions[zone]
	elseif BigWigs:HasModule(zone) then
		rev = BigWigs:GetModule(zone).revision
	elseif BigWigsLoD and BigWigsLoD:HasAddOnsForZone(zone) then
		rev = -2
	end
	if type(rev) ~= "number" then rev = -1 end
	return rev
end

function plugin:CHAT_MSG_ADDON(prefix, message, distribution, sender)
	if prefix == "BWVQ" and sender ~= UnitName("player") then
		SendAddonMessage("BWVR", self:GetVersion(message), "WHISPER", sender)
	elseif prefix == "BWVR" and queryRunning then
		table.insert(responseTable, new(sender, tonumber(message)))
		self:UpdateDisplay()
	end
end

--[[
-- Version reply syntax history:
--  Old Style:            MC:REV BWL:REV ZG:REV
--  First Working Style:  REV
--  New Style:            REV QuereeNick
--  CHAT_MSG_ADDON style: REV
--]]

