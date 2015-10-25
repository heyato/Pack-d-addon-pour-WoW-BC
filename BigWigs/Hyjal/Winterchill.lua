﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Rage Winterchill"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Winterchill",

	decay = "Death & Decay on You",
	decay_desc = "Warn for Death & Decay on You.",
	decay_trigger = "You are afflicted by Death & Decay.",
	decay_message = "Death & Decay on YOU!",

--[[
	decaycast = "Death & Decay Cast",
	decaycast_desc = "Warn when Death % Decay is being cast.",
	decaycast_trigger = "",
	decaycast_bar = "~Possible Death & Decay /// Next Death & Decay",
	decasycast_message = "Casting Death & Decay!",
]]

	icebolt = "Icebolt",
	icebolt_desc = "Icebolt warnings.",
	icebolt_trigger = "^([^%s]+) ([^%s]+) afflicted by Icebolt%.$",
	icebolt_message = "Icebolt on %s!",

	icon = "Raid Target Icon",
	icon_desc = "Place a Raid Target Icon on the player afflicted by Icebolt (requires promoted or higher).",
} end )

L:RegisterTranslations("frFR", function() return {
	decay = "Mort & décomposition sur vous",
	decay_desc = "Préviens quand la Mort & décomposition est sur vous.",
	decay_trigger = "Vous subissez les effets de Mort & décomposition.",
	decay_message = "Mort & décomposition sur VOUS !",

	icebolt = "Eclair de glace",
	icebolt_desc = "Avertissements concernant l'Eclair de glace.",
	icebolt_trigger = "^([^%s]+) ([^%s]+) les effets .* Eclair de glace%.$",
	icebolt_message = "Eclair de glace sur %s !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par l'Eclair de glace (nécessite d'être promu ou mieux).",
} end )

L:RegisterTranslations("koKR", function() return {
	decay = "당신에 죽음과 부패",
	decay_desc = "당신에 걸린 죽음과 부패를 알립니다.",
	decay_trigger = "당신은 죽음과 부패에 걸렸습니다.",
	decay_message = "당신에 죽음과 부패!",

	icebolt = "얼음 화살",
	icebolt_desc = "얼음 화살 경고.",
	icebolt_trigger = "^([^|;%s]*)(.*)얼음 화살에 걸렸습니다%.$", -- check
	icebolt_message = "%s에 얼음 화살!",

	icon = "전술 표시",
	icon_desc = "얼음 화살에 걸린 플레이어에 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("deDE", function() return {
	decay = "Tod & Verfall auf dir",
	decay_desc = "Warnt vor Tod & Verfall auf dir.",
	decay_trigger = "Ihr seid von Tod & Verfall betroffen.",
	decay_message = "Tod & Verfall auf DIR!",

	icebolt = "Eisblitz",
	icebolt_desc = "Eisblitz Warnung.",
	--icebolt_trigger = "Eisblitz trifft ([^%s]+)", --enUS changed
	icebolt_message = "Eisblitz on %s!",

	icon = "Icon",
	icon_desc = "Plaziert ein Raid Icon auf dem Spieler, der von Eisblitz betroffen ist (ben\195\182tigt Anf\195\188hrer oder Assistent).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"decay", -1, "icebolt", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision: 44564 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "AfflictEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "AfflictEvent")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "WCBolt", 5)

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "WCBolt" and rest and self.db.profile.icebolt then
		self:Message(L["icebolt_message"]:format(rest), "Important", nil, "Alert")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif self:ValidateEngageSync(sync, rest) and not started then
		started = true
		if self:IsEventRegistered("PLAYER_REGEN_DISABLED") then
			self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Attention")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(595, L2["enrage_sec"]:format(5), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	end
end

function mod:AfflictEvent(msg)
	if self.db.profile.decay and msg == L["decay_trigger"] then
		self:Message(L["decay_message"], "Personal", true, "Alarm")
	end

	local iplayer, itype = select(3, msg:find(L["icebolt_trigger"]))
	if iplayer and itype then
		if iplayer == L2["you"] and itype == L2["are"] then
			iplayer = UnitName("player")
		end
		self:Sync("WCBolt "..iplayer)
	end
end
