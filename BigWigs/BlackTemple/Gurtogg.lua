﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Gurtogg Bloodboil"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local UnitName = UnitName
local pName = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Gurtogg",

	engage_trigger = "Horde will... crush you.",

	phase = "Phase Timers",
	phase_desc = "Timers for switching between normal and Fel Rage phases.",
	phase_rage_warning = "Fel Rage Phase in ~5 sec",
	phase_normal_warning = "Fel Rage over in ~5 sec",
	phase_normal = "Fel Rage Phase Over",
	phase_normal_trigger = "Fel Rage fades from Gurtogg Bloodboil.",
	phase_normal_bar = "Next Rage Phase",
	phase_rage_bar = "Next Normal Phase",

	rage = "Fel Rage",
	rage_desc = "Warn who gets Fel Rage.",
	rage_trigger = "^([^%s]+) ([^%s]+) afflicted by Fel Rage%.$",
	rage_you = "You have Fel Rage!!",
	rage_other = "%s has Fel Rage!",

	whisper = "Whisper",
	whisper_desc = "Whisper the player with Fel Rage (requires promoted or higher).",

	acid = "Fel-Acid Breath",
	acid_desc = "Warn who Fel-Acid Breath is being cast on.",
	acid_message = "Fel-Acid Casting on: %s",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on who Fel-Acid Breath is being cast on (requires promoted or higher).",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "호드가... 박살내주마.",

	phase = "단계 타이머",
	phase_desc = "마의 분노 단계와 보통 단계 간의 변경에 대한 타이머입니다.",
	phase_rage_warning = "약 5초 이내 마의 분노 단계",
	phase_normal_warning = "약 5초 이내 마의 분노 종료",
	phase_normal = "마의 분노 단계 종료",
	phase_normal_trigger =  "구르토그 블러드보일의 몸에서 마의 분노 효과가 사라졌습니다.",
	phase_normal_bar = "다음 분노 형상",
	phase_rage_bar = "다음 보통 형상",

	rage = "마의 분노",
	rage_desc = "마의 분노에 걸린 사람을 알립니다.",
	rage_trigger = "^([^|;%s]*)(.*)마의 분노에 걸렸습니다%.$", -- check
	rage_you = "당신은 마의 분노!!",
	rage_other = "%s 마의 분노!",

	whisper = "귓속말",
	whisper_desc = "마의 분노에 걸린 플레이어에게 귓속말을 보냅니다 (승급자 이상 권한 요구).",

	acid = "지옥 산성 숨결",
	acid_desc = "지옥 산성 숨결의 시전 대상을 알립니다.",
	acid_message = "지옥 산성 숨결 시전 중 : %s",

	icon = "전술 표시",
	icon_desc = "지옥 산성 숨결의 시전 대상에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Horde... wird Euch zerschmettern.",

	phase = "Phasen Timer",
	phase_desc = "Timer f\195\164r den Wechsel zwischen normaler und Teufelswut Phase.",
	phase_rage_warning = "Teufelswut Phase in ~5 sec",
	phase_normal_warning = "Teufelswut vorbei in ~5 sec",
	phase_normal = "Teufelswut Phase vorbei",
	phase_normal_trigger = "Teufelswut schwindet von Gurtogg Siedeblut.",
	phase_normal_bar = "N\195\164chste Teufelswut Phase",
	phase_rage_bar = "N\195\164chste Normale Phase",

	rage = "Teufelswut",
	rage_desc = "Warnt, wer Teufelswut bekommt.",
	rage_trigger = "^([^%s]+) ([^%s]+) von Teufelswut betroffen%.$",
	rage_you = "Du hast Teufelswut!!",
	rage_other = "%s hat Teufelswut!",

	whisper = "Fl\195\164stern",
	whisper_desc = "Fl\195\164stert dem Spieler mit Teufelswut (ben\195\182tigt Assistent oder h\195\182her).",

	acid = "Teufelss\195\164ureatem",
	acid_desc = "Warnt auf wen Teufelss\195\164ureatem gezaubert wird.",
	acid_message = "Teufelss\195\164ureatem auf: %s",

	icon = "Raid Icon",
	icon_desc = "Plaziert ein Raid Icon auf dem Spieler, der Teufelss\195\164ureatem abbekommt (ben\195\182tigt Assistent oder h\195\182her).",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "La Horde va… vous écraser.", -- à vérifier

	phase = "Délais entre les phases",
	phase_desc = "Délais entre les phases normales et les phases de Gangrerage.",
	phase_rage_warning = "Phase de Gangrerage dans ~5 sec.",
	phase_normal_warning = "Gangrerage terminée dans ~5 sec.",
	phase_normal = "Fin de la phase de Gangrerage",
	phase_normal_trigger = "Gangrerage sur Gurtogg Fièvresang vient de se dissiper.",
	phase_normal_bar = "Prochaine phase de rage",
	phase_rage_bar = "Prochaine phase normale",

	rage = "Gangrerage",
	rage_desc = "Préviens quand un joueur subit les effets de la Gangrerage.",
	rage_trigger = "^([^%s]+) ([^%s]+) les effets .* Gangrerage%.$",
	rage_you = "Vous avez la Gangrerage !",
	rage_other = "%s a la Gangrerage !",

	whisper = "Chuchoter",
	whisper_desc = "Chuchote au dernier joueur affecté par la Gangrerage (nécessite d'être promu ou mieux).",

	acid = "Souffle d'acide gangrené",
	acid_desc = "Préviens sur qui le Souffle d'acide gangrené est incanté.",
	acid_message = "Souffle d'acide gangrené incanté sur : %s",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur le joueur sur qui le Souffle d'acide gangrené est incanté (nécessite d'être promu ou mieux).",
} end )

--Chinese Translate by 月色狼影@CWDG
--CWDG site: http://Cwowaddon.com
--古尔图格·血沸
L:RegisterTranslations("zhCN", function() return {
	engage_trigger = "Horde will... crush you.",

	phase = "阶段计时",
	phase_desc = "普通或邪能狂怒状态转换阶段计时",
	phase_rage_warning = "邪能狂怒 发动 ~5秒 后",--Fel Rage 邪能狂怒
	phase_normal_warning = "邪能狂怒 结束 ~5秒 后",
	phase_normal = "邪能狂怒 阶段结束",
	phase_normal_trigger = "邪能狂怒的效果从古尔图格·血沸身上消失。",--%s效果从%s身上消失。 check
	phase_normal_bar = "下一 邪能狂怒",
	phase_rage_bar = "下一 普通阶段",

	rage = "邪能狂怒",
	rage_desc = "当获得邪能狂怒时发出警报",
	rage_trigger = "^([^%s]+)受([^%s]+)了邪能狂怒效果的影响。$",
	rage_you = "你中了 邪能狂怒!!",
	rage_other = "%s 中了 邪能狂怒!",

	whisper = "密语",
	whisper_desc = "当完家中了邪能狂怒进行密语提醒(需要助理或更高权限).",

	acid = "邪酸吐息",--Fel-Acid Breath 邪酸吐息
	acid_desc = "当谁受到邪酸吐息攻击时发出警报.",
	acid_message = "邪酸吐息施放在: %s",

	icon = "团队标记",
	icon_desc = "给中了邪酸吐息的队员打上团队标记(需要助理以上的权限).",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Black Temple"]
mod.enabletrigger = boss
mod.toggleoptions = {"phase", -1, "rage", "whisper", -1, "acid", "icon", "enrage", "bosskill"}
mod.revision = tonumber(("$Revision: 45916 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "RageEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "RageEvent")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "RageEvent")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")

	self:RegisterEvent("UNIT_SPELLCAST_START")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "GurRage", 10)
	self:TriggerEvent("BigWigs_ThrottleSync", "GurAcid", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "GurNormal", 10)
	pName = UnitName("player")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:BigWigs_RecvSync(sync, rest, nick)
	if sync == "GurRage" and rest and self.db.profile.rage then
		self:CancelScheduledEvent("rage1")
		self:TriggerEvent("BigWigs_StopBar", self, L["phase_normal_bar"])
		if rest == pName then
			self:Message(L["rage_you"], "Personal", true, "Long")
			self:Message(L["rage_other"]:format(rest), "Attention", nil, nil, true)
		else
			self:Message(L["rage_other"]:format(rest), "Attention")
		end
		if self.db.profile.whisper then
			self:Whisper(rest, L["rage_you"])
		end
		if self.db.profile.phase then
			self:Bar(L["phase_rage_bar"], 28, "Spell_Fire_ElementalDevastation")
			self:DelayedMessage(23, L["phase_normal_warning"], "Important")
		end
	elseif sync == "GurAcid" and self.db.profile.acid then
		self:Bar(L["acid"], 2, "Spell_Nature_Acid_01")
		self:ScheduleEvent("BWAcidToTScan", self.AcidCheck, 0.2, self)
	elseif sync == "GurNormal" and self.db.profile.phase then
		self:Bar(L["phase_normal_bar"], 60, "Spell_Fire_ElementalDevastation")
		self:ScheduleEvent("rage1", "BigWigs_Message", 55, L["phase_rage_warning"], "Important")
		self:Message(L["phase_normal"], "Attention")
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.phase then
			self:Bar(L["phase_normal_bar"], 52, "Spell_Fire_ElementalDevastation")
			self:ScheduleEvent("rage1", "BigWigs_Message", 47, L["phase_rage_warning"], "Important")
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

function mod:RageEvent(msg)
	local rplayer, rtype = select(3, msg:find(L["rage_trigger"]))
	if rplayer and rtype then
		if rplayer == L2["you"] and rtype == L2["are"] then
			rplayer = pName
		end
		self:Sync("GurRage "..rplayer)
	end
end

function mod:UNIT_SPELLCAST_START(msg)
	if UnitName(msg) == boss and (UnitCastingInfo(msg)) == L["acid"] then
		self:Sync("GurAcid")
	end
end

function mod:AcidCheck()
	local target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
	elseif UnitName("focus") == boss then
		target = UnitName("focustarget")
	else
		local num = GetNumRaidMembers()
		for i = 1, num do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				break
			end
		end
	end
	if target then
		self:Message(L["acid_message"]:format(target), "Attention")
		if self.db.profile.icon then
			self:Icon(target)
			self:ScheduleEvent("ClearIcon", "BigWigs_RemoveRaidIcon", 5, self)
		end
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["phase_normal_trigger"] then
		self:Sync("GurNormal")
	end
end
