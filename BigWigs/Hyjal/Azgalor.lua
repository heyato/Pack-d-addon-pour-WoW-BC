﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Azgalor"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Azgalor",

	doom = "Doom",
	doom_desc = "Warn for Doom.",
	doom_other = "Doom on %s",
	doom_you = "Doom on YOU!",

	hoa = "Howl of Azgalor",
	hoa_desc = "Warn for Howl of Azgalor.",
	hoa_bar = "~Howl Cooldown",
	hoa_message = "AOE Silence",
	hoa_warning = "AOE Silence Soon!",

	rof = "Rain of Fire",
	rof_desc = "Warn when Rain of Fire is on you.",
	rof_you = "Rain of Fire on YOU!",

	icon = "Icon",
	icon_desc = "Place a Raid Icon on the player afflicted by Doom (requires promoted or higher).",

	afflict_trigger = "^([^%s]+) ([^%s]+) afflicted by (.*).$",
} end )

L:RegisterTranslations("frFR", function() return {
	doom = "Destin funeste",
	doom_desc = "Préviens quand un joueur subit les effets du Destin funeste.",
	doom_other = "Destin funeste sur %s",
	doom_you = "Destin funeste sur VOUS !",

	hoa = "Hurlement de terreur",
	hoa_desc = "Préviens de l'arrivée des Hurlements de terreur.",
	hoa_bar = "~Cooldown Hurlement",
	hoa_message = "Silence de zone",
	hoa_warning = "Silence de zone imminent !",

	rof = "Pluie de feu",
	rof_desc = "Préviens quand la Pluie de feu est sur vous.",
	rof_you = "Pluie de feu sur VOUS !",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le dernier joueur affecté par le Destin funeste (nécessite d'être promu ou mieux).",

	afflict_trigger = "^([^%s]+) ([^%s]+) les effets .* (.*).$",
} end )

L:RegisterTranslations("koKR", function() return {
	doom = "파멸",
	doom_desc = "파멸에 대한 경고입니다.",
	doom_other = "%s에 파멸",
	doom_you = "당신에 파멸!",

	 hoa = "아즈갈로의 울부짖음",
	 hoa_desc = "아즈갈로의 울부짖음을 경보합니다.",
	 hoa_bar = "~침묵 대기시간",
	 hoa_message = "광역 침묵",
	 hoa_warning = "곧 광역 침묵!",

	 rof = "불의 비",
	 rof_desc = "자신에게 불의 비가 내릴때를 알림니다.",
	 rof_you = "당신에 불의 비!",

	icon = "전술 표시",
	icon_desc = "파멸에 걸린 플레이어에 전술 표시를 지정합니다. (승급자 이상 권한 요구).",

	afflict_trigger =  "^([^|;%s]*)(%s+)(.*)에 걸렸습니다%.$",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Hyjal Summit"]
mod.enabletrigger = boss
mod.toggleoptions = {"doom", "hoa", "rof", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision: 45342 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Event")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Event")

	self:RegisterEvent("PLAYER_REGEN_DISABLED", "CheckForEngage")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "AzDoom", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "AzHOA", 2)

	pName = UnitName("player")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:Event(msg)
	local aPlayer, aType, aSpell = select(3, msg:find(L["afflict_trigger"]))
	if aPlayer and aType then
		if aPlayer == L2["you"] and aType == L2["are"] then
			aPlayer = pName
			if aSpell == L["rof"] and self.db.profile.rof then
				self:Message(L["rof_you"], "Urgent", true, "Alarm")
			end
		end
		if aSpell == L["doom"] then
			self:Sync("AzDoom ".. aPlayer)
		elseif aSpell == L["hoa"] then
			self:Sync("AzHOA ".. aPlayer)
		end
	end
end

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "AzDoom" and rest and self.db.profile.doom then
		local other = L["doom_other"]:format(rest)
		if rest == pName then
			self:Message(L["doom_you"], "Personal", true, "Long")
			self:Message(other, "Attention", nil, nil, true)
			self:Bar(other, 19, "Ability_Creature_Cursed_02")
		else
			self:Message(other, "Attention")
			self:Bar(other, 19, "Ability_Creature_Cursed_02")
		end
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "AzHOA" and rest and self.db.profile.hoa then
		self:Message(L["hoa_message"], "Important")
		self:Bar(L["hoa_bar"], 16, "Spell_Shadow_ImpPhaseShift")
		self:DelayedMessage(15, L["hoa_warning"], "Important")
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
