﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Void Reaver"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
local previous

local UnitName = UnitName
local GetNumRaidMembers = GetNumRaidMembers
local UnitExists = UnitExists
local UnitPowerType = UnitPowerType

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Reaver",

	engage_trigger = "Alert! You are marked for extermination.",

	orbyou = "Arcane Orb on You",
	orbyou_desc = "Warn for Arcane Orb on you.",
	orb_you = "Arcane Orb on YOU!",

	orbsay = "Arcane Orb Say",
	orbsay_desc = "Print in say when you are targeted for arcane orb, can help nearby members with speech bubbles on.",
	orb_say = "Orb on Me!",

	orbother = "Arcane Orb on Others",
	orbother_desc = "Warn for Arcane Orb on others",
	orb_other = "Orb(%s)",

	icon = "Raid Icon",
	icon_desc = "Place a Raid Icon on the player targeted for Arcane Orb(requires promoted or higher).",

	pounding = "Pounding",
	pounding_desc = "Show Pounding timer bars.",
	pounding_trigger1 = "Alternative measure commencing...",
	pounding_trigger2 = "Calculating force parameters...",
	pounding_nextbar = "~Pounding Cooldown",
	pounding_bar = "<Pounding>",

	knock = "Knock Away",
	knock_desc = "Knock Away cooldown bar.",
	knock_trigger = "^Void Reaver 's Knock Away",
	knock_bar = "~Knock Away Cooldown",
} end )

L:RegisterTranslations("deDE", function() return {
	engage_trigger = "Alarm! Eliminierung eingeleitet!",

	orbyou = "Arkane Kugel auf dir",
	orbyou_desc = "Warnt vor Arkane Kugel auf dir",
	orb_you = "Arkane Kugel auf DIR!",

	orbsay = "Arkane Kugel Ansage",
	orbsay_desc = "Schreibt im Say, wenn eine Arkane Kugel auf deine Position fliegt, kann nahen Partymember mit aktivierten Sprechblasen helfen",
	orb_say = "Kugel auf Mir!",

	orbother = "Arkane Kugel auf Anderen",
	orbother_desc = "Warn for Arcane Orb on others",
	orb_other = "Kugel(%s)",

	icon = "Raid Icon",
	icon_desc = "Plaziert ein Raid Icon auf dem Spieler auf den Arkane Kugel zufliegt (ben\195\182tigt Anf\195\188hrer oder Assistent)",

	pounding = "H\195\164mmern",
	pounding_desc = "Timer Balken f\195\188r H\195\164mmern",
	pounding_trigger1 = "Alternative Ma\195\159nahmen werden eingeleitet...",
	pounding_trigger2 = "Angriffsvektor wird berechnet...",
	pounding_nextbar = "~H\195\164mmern Cooldown",
	pounding_bar = "<H\195\164mmern>",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger = "Alerte ! Vous êtes désigné pour extermination.",

	orbyou = "Orbe des arcanes sur vous",
	orbyou_desc = "Préviens quand vous êtes ciblé par l'Orbe des arcanes.",
	orb_you = "Orbe des arcanes sur VOUS !",

	orbsay = "Dire - Orbe des arcanes",
	orbsay_desc = "Fais dire à votre personnage qu'il est ciblé par l'Orbe des arcanes quand c'est le cas, afin d'aider les membres proches ayant les bulles de dialogue d'activés.",
	orb_say = "Orbe sur moi !",

	orbother = "Orbe des arcanes sur les autres",
	orbother_desc = "Préviens quand les autres sont ciblés par l'Orbe des arcanes.",
	orb_other = "Orbe (%s)",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur la personne ciblée par l'Orbe des arcanes (nécessite d'être promu ou mieux).",

	pounding = "Martèlement",
	pounding_desc = "Affiche des barres temporelles pour les Martèlements.",
	pounding_trigger1 = "Lancement des mesures alternatives...",
	pounding_trigger2 = "Calcul des paramètres de puissance...",
	pounding_nextbar = "~Cooldown Martèlement",
	pounding_bar = "<Martèlement>",

	knock = "Repousser au loin",
	knock_desc = "Affiche une barre temporelle indiquant quand le Saccageur du Vide est suceptible d'utiliser son Repousser au loin.",
	knock_trigger = "Repousser au loin de Saccageur du Vide",
	knock_bar = "~Cooldown Repousser au loin",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger = "경고! 제거 대상 발견!",

	orbyou = "자신의 비전 보주",
	orbyou_desc = "자신의 비전 보주를 알립니다.",
	orb_you = "당신에 비전 보주!",

	orbsay = "비전 보주 대화",
	orbsay_desc = "당신이 비전 보주의 대상이 되었을 때 대화를 출력합니다.",
	orb_say = "나에게 보주!",

	orbother = "타인의 비전 보주",
	orbother_desc = "타인의 비전 보주를 알립니다.",
	orb_other = "보주(%s)",

	icon = "전술 표시",
	icon_desc = "비전 보주 대상이된 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 필요).",

	pounding = "울림",
	pounding_desc = "울림에 대한 타이머 바를 표시합니다.",
	pounding_trigger1 = "대체 공격 실행 중...",
	pounding_trigger2 = "파괴력 변수 계산 중...",
	pounding_nextbar = "~울림 대기 시간",
	pounding_bar = "<울림>",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger = "警告!你被標記要消滅。",

	orbyou = "秘法寶珠瞄準你",
	orbyou_desc = "當秘法寶珠目標為你時警告",
	orb_you = "秘法寶珠在你身上！",

	orbsay = "以 Say 通知秘法寶珠",
	orbsay_desc = "當秘法寶珠目標為你時，以 Say 通知周圍隊員。",
	orb_say = "秘法寶珠瞄準我！請避開！",

	orbother = "秘法寶珠瞄準其他人",
	orbother_desc = "當秘法寶珠在團員身上時警示。",
	orb_other = "寶珠目標：%s",

	icon = "團隊標記",
	icon_desc = "當團員為秘法寶珠目標時，設置團隊標記（需要權限）",

	pounding = "猛擊",
	pounding_desc = "顯示猛擊計時條。",
	pounding_trigger1 = "選擇性測量開始....",
	pounding_trigger2 = "計算力量參數...",
	pounding_nextbar = "猛擊冷卻",
	pounding_bar = "<猛擊>",

	knock = "擊退",
	knock_desc = "擊退冷卻計時條。",
	knock_trigger = "虛無劫掠者的擊退",
	knock_bar = "~擊退冷卻計時",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Tempest Keep"]
mod.otherMenu = "The Eye"
mod.enabletrigger = boss
mod.toggleoptions = {"enrage", "pounding", "knock", -1, "orbyou", "orbsay", "orbother", "icon", "bosskill"}
mod.revision = tonumber(("$Revision: 45717 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")

	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE", "KnockAway")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_SELF_DAMAGE", "KnockAway")
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_PARTY_DAMAGE", "KnockAway")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "ReavKA2", 7)

	previous = nil
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["engage_trigger"] then
		if self.db.profile.orbyou or self.db.profile.orbother then
			self:ScheduleRepeatingEvent("BWReaverToTScan", self.OrbCheck, 0.2, self) --how often to scan the target, 0.2 seconds
		end
		if self.db.profile.enrage then
			self:Message(L2["enrage_start"]:format(boss, 10), "Important")
			self:DelayedMessage(300, L2["enrage_min"]:format(5), "Positive")
			self:DelayedMessage(420, L2["enrage_min"]:format(3), "Positive")
			self:DelayedMessage(540, L2["enrage_min"]:format(1), "Positive")
			self:DelayedMessage(570, L2["enrage_sec"]:format(30), "Positive")
			self:DelayedMessage(590, L2["enrage_sec"]:format(10), "Urgent")
			self:DelayedMessage(600, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")
			self:Bar(L2["enrage"], 600, "Spell_Shadow_UnholyFrenzy")
		end
	elseif self.db.profile.pounding and (msg == L["pounding_trigger1"] or msg == L["pounding_trigger2"]) then
		self:Bar(L["pounding_nextbar"], 13, "Ability_ThunderClap")
	end
end

function mod:KnockAway(msg)
	if msg:find(L["knock_trigger"]) then
		self:Sync("ReavKA2")
	end
end

function mod:BigWigs_RecvSync(sync)
	if sync == "ReavKA2" and self.db.profile.knock then
		self:Bar(L["knock_bar"], 20, "INV_Gauntlets_05")
	end
end

function mod:OrbCheck()
	local id, target
	--if Void reaver is your target, scan hes target
	if UnitName("target") == boss then
		target = UnitName("targettarget")
		id = "targettarget"
	else
		--if Void Reaver isn't your target, scan raid members targets, hopefully one of them has him targeted and we can get hes target from there
		for i = 1, GetNumRaidMembers() do
			if UnitName("raid"..i.."target") == boss then
				target = UnitName("raid"..i.."targettarget")
				id = "raid"..i.."targettarget"
				break
			end
		end
	end
	if target ~= previous and UnitExists(id) then --spam protection & wierdness protection
		if target and id then
			if UnitPowerType(id) == 0 then --if the player has mana it is most likely ranged, we don't want other units(energy/rage would be melee)
				self:Result(target) --pass the unit with mana through
			end
			previous = target --create spam protection filter
		else
			previous = nil
		end
	end
end

function mod:Result(target)
	if target == UnitName("player") and self.db.profile.orbyou then
		self:Message(L["orb_you"], "Personal", true, "Long")
		self:Message(L["orb_other"]:format(target), "Attention", nil, nil, true)

		--this is handy for player with speech bubbles enabled to see if nearby players are being hit and run away from them
		if self.db.profile.orbsay then
			SendChatMessage(L["orb_say"], "SAY")
		end
	elseif self.db.profile.orbother then
		self:Message(L["orb_other"]:format(target), "Attention")
	end
	if self.db.profile.icon then 
		self:Icon(target)
	end
end
