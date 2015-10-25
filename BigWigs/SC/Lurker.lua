﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["The Lurker Below"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local started
local occured = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Lurker",

	engage_warning = "%s Engaged - Possible Dive in 90sec",

	dive = "Dive",
	dive_desc = ("Timers for when %s dives."):format(boss),
	dive_warning = "Possible Dive in %dsec!",
	dive_bar = "~Dives in",
	dive_message = "Dives - Back in 60sec",

	spout = "Spout",
	spout_desc = "Timers for Spout, may not always be accurate.",
	spout_trigger = "%s takes a deep breath!",
	spout_message = "Casting Spout!",
	spout_warning = "Possible Spout in ~3sec!",
	spout_bar = "Possible Spout",

	whirl = "Whirl",
	whirl_desc = "Whirl Timers.",
	whirl_bar = "Possible Whirl",

	emerge_warning = "Back in %dsec",
	emerge_message = "Back - Possible Dive in 90sec",
	emerge_bar = "Back in",

	["Coilfang Guardian"] = true,
	["Coilfang Ambusher"] = true,
} end )

L:RegisterTranslations("koKR", function() return {
	engage_warning = "%s 전투 시작 - 90초 이내 잠수",

	dive = "잠수",
	dive_desc = ("%s 잠수 시 타이머입니다."):format(boss),

	dive_warning = "%d초 이내 잠수!",
	dive_bar = "~잠수",
	dive_message = "잠수 - 60초 이내 출현",

	spout = "분출",
	spout_desc = "분출에 대한 타이머입니다. 항상 정확하지 않을 수 있습니다.",
	spout_trigger = "%s|1이;가; 깊은 숨을 쉽니다!", -- check
	spout_message = "분출 시전 중!",
	spout_warning = "약 3초 이내 분출!",
	spout_bar = "분출 가능",

	whirl = "소용돌이",
	whirl_desc = "소용돌이에 대한 타이머입니다.",
	whirl_bar = "소용돌이 주의",

	emerge_warning = "%d초 이내 출현",
	emerge_message = "출현 - 90초 이내 잠수",
	emerge_bar = "출현",

	["Coilfang Guardian"] = "갈퀴송곳니 수호자",
	["Coilfang Ambusher"] = "갈퀴송곳니 복병",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_warning = "%s engagé - Plongée probable dans 90 sec.",

	dive = "Plongées",
	dive_desc = ("Délais avant que %s ne plonge."):format(boss),
	dive_warning = "Plongée probable dans %d sec. !",
	dive_bar = "~Plongée",
	dive_message = "Plongée - De retour dans 60 sec.",

	spout = "Jet",
	spout_desc = "Délais concernant les Jets. Pas toujours précis.",
	spout_trigger = "%s inspire profondément !",
	spout_message = "Incante un Jet !",
	spout_warning = "Jet probable dans ~3 sec. !",
	spout_bar = "Jet probable",

	whirl = "Tourbillonnement",
	whirl_desc = "Délais concernant les Tourbillonnements.",
	whirl_bar = "Tourbillonnement probable",

	emerge_warning = "De retour dans %d sec.",
	emerge_message = "De retour - Plongée probable dans 90 sec.",
	emerge_bar = "De retour dans",

	["Coilfang Guardian"] = "Gardien de Glisseroc",
	["Coilfang Ambusher"] = "Embusqué de Glisseroc",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_warning = "%s Engaged - M\195\182gliches abtauchen in 90sek",

	dive = "Tauchen",
	dive_desc = ("Zeitanzeige wann %s taucht."):format(boss),
	dive_warning = "M\195\182gliches abtauchen in %dsek!",
	dive_bar = "~Tauchen",
	dive_message = "Abgetaucht - Zur\195\188ck in 60sek",

	spout = "Schwall",
	spout_desc = "Zeitanzeige f\195\188r Schwall, m\195\182glicherweise nicht sehr akkurat.",
	spout_trigger = "%s atmet tief ein!",
	spout_message = "Wirkt Schwall!",
	spout_warning = "M\195\182glicher Schwall in ~3sek!",
	spout_bar = "M\195\182glicher Schwall",

	whirl = "Wirbel",
	whirl_desc = "Zeitanzeige f\195\188r Wirbel.",
	whirl_bar = "M\195\182glicher wirbel",

	emerge_warning = "Zur\195\188ck in %dsek",
	emerge_message = "Aufgetaucht - M\195\182glicher Schwall in 90sek",
	emerge_bar = "Auftauchen",

	["Coilfang Guardian"] = "W\195\164chter des Echsenkessels",
	["Coilfang Ambusher"] = "Wegelagerer des Echsenkessels",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_warning = "%s 開始攻擊 - 約90秒後下潛",

	dive = "潛水",
	dive_desc = ("%s下潛計時器"):format(boss),
	dive_warning = "大約%d秒後下潛!",
	dive_bar = "~下潛",
	dive_message = "潛水! 請就位打小兵 (60秒後王再次出現)",

	spout = "噴射",
	spout_desc = "噴射計時器, 僅供參考, 不一定準確。",
	spout_trigger = "%s深深的吸了一口氣!",
	spout_message = "噴水了!!被噴到是小白",
	spout_warning = "約3秒後噴水!",
	spout_bar = "噴射",

	whirl = "旋風",
	whirl_desc = "旋風計時器",
	whirl_bar = "旋風",

	emerge_warning = "%d秒後浮現",
	emerge_message = "浮現 - 近戰請等旋風結束上前 (再約90秒後下潛)",
	emerge_bar = "浮現",

	["Coilfang Guardian"] = "盤牙護衛",
	["Coilfang Ambusher"] = "盤牙伏擊者",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.wipemobs = {L["Coilfang Guardian"], L["Coilfang Ambusher"]}
mod.toggleoptions = {"dive", "spout", "whirl", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision: 46652 $"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end
mod.proximitySilent = true

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")
	self:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "LurkWhirl", 10)
	started = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync( sync, rest, nick )
	if self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.dive then
			self:Message(L["engage_warning"]:format(boss), "Attention")
			self:DelayedMessage(30, L["dive_warning"]:format(60), "Positive")
			self:DelayedMessage(60, L["dive_warning"]:format(30), "Positive")
			self:DelayedMessage(80, L["dive_warning"]:format(10), "Positive")
			self:DelayedMessage(85, L["dive_warning"]:format(5), "Urgent", nil, "Alarm")
			self:Bar(L["dive_bar"], 90, "Spell_Frost_ArcticWinds")
		end
		if self.db.profile.whirl then
			self:Bar(L["whirl_bar"], 17, "Ability_Whirlwind")
		end
		if self.db.profile.spout then
			self:DelayedMessage(34, L["spout_warning"], "Attention")
			self:Bar(L["spout_bar"], 37, "INV_Weapon_Rifle_02")
		end
		self:TriggerEvent("BigWigs_ShowProximity", self)
		self:ScheduleRepeatingEvent("BWLurkerTargetSeek", self.DiveCheck, 1, self)
	elseif sync == "LurkWhirl" and self.db.profile.whirl then
		self:Bar(L["whirl_bar"], 17, "Ability_Whirlwind")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if msg:find(L["whirl"]) then
		self:Sync("LurkWhirl")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L["spout_trigger"] then
		if self.db.profile.spout then
			self:Bar(L["spout_message"], 20, "Spell_Frost_ChillingBlast")
			self:Bar(L["spout_bar"], 50, "Spell_Frost_ChillingBlast")
			self:Message(L["spout_message"], "Important", nil, "Alert")
			self:ScheduleEvent("spout1", "BigWigs_Message", 47, L["spout_warning"], "Attention")
			self:TriggerEvent("BigWigs_StopBar", self, L["whirl_bar"])
		end
		occured = nil
	end
end

function mod:DiveCheck()
	if not self:Scan() and not occured then
		occured = true
		self:ScheduleEvent("BWLurkerUp", self.LurkerUP, 60, self)

		if self.db.profile.dive then
			local ewarn = L["emerge_warning"]
			self:Message(L["dive_message"], "Attention")
			self:DelayedMessage(30, ewarn:format(30), "Positive")
			self:DelayedMessage(50, ewarn:format(10), "Positive")
			self:DelayedMessage(55, ewarn:format(5), "Urgent", nil, "Alert")
			self:DelayedMessage(60, L["emerge_message"], "Attention")
			self:Bar(L["emerge_bar"], 60, "Spell_Frost_Stun")
		end

		self:TriggerEvent("BigWigs_HideProximity", self)
		self:CancelScheduledEvent("spout1")
		self:TriggerEvent("BigWigs_StopBar", self, L["spout_bar"])
		self:TriggerEvent("BigWigs_StopBar", self, L["whirl_bar"])

		if self.db.profile.spout then
			self:Bar(L["spout_bar"], 63, "Spell_Frost_ChillingBlast")
			self:DelayedMessage(60, L["spout_warning"], "Attention")
		end
	end
end

function mod:LurkerUP()
	if self.db.profile.dive then
		local dwarn = L["dive_warning"]
		self:DelayedMessage(30, dwarn:format(60), "Positive")
		self:DelayedMessage(60, dwarn:format(30), "Positive")
		self:DelayedMessage(80, dwarn:format(10), "Positive")
		self:DelayedMessage(85, dwarn:format(5), "Urgent", nil, "Alarm")
		self:Bar(L["dive_bar"], 90, "Spell_Frost_ArcticWinds")
	end

	self:TriggerEvent("BigWigs_ShowProximity", self)
end
