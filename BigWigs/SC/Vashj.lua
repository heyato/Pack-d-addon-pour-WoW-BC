﻿------------------------------
--      Are you local?      --
------------------------------

local BB = AceLibrary("Babble-Boss-2.2")
local boss = BB["Lady Vashj"]
local elite = BB["Coilfang Elite"]
local strider = BB["Coilfang Strider"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local L2 = AceLibrary("AceLocale-2.2"):new("BigWigsCommonWords")
BB = nil

local shieldsFaded = 0
local pName = nil
local phaseTwoAnnounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["Tainted Elemental"] = true,

	cmd = "Vashj",

	engage_trigger1 = "I did not wish to lower myself by engaging your kind, but you leave me little choice...",
	engage_trigger2 = "I spit on you, surface filth!",
	engage_trigger3 = "Victory to Lord Illidan! ",
	engage_trigger4 = "I'll split you from stem to stern!",
	engage_trigger5 = "Death to the outsiders!",
	engage_message = "Entering Phase 1",

	phase = "Phase warnings",
	phase_desc = "Warn when Vashj goes into the different phases.",
	phase2_trigger = "The time is now! Leave none standing! ",
	phase2_soon_message = "Phase 2 soon!",
	phase2_message = "Phase 2, adds incoming!",
	phase3_trigger = "You may want to take cover. ",
	phase3_message = "Phase 3 - Enrage in 4min!",

	static = "Static Charge",
	static_desc = "Warn about Static Charge on players.",
	static_charge_trigger = "^([^%s]+) ([^%s]+) afflicted by Static Charge%.$",
	static_charge_message = "Static Charge on %s!",
	static_fade = "Static Charge fades from you.",

	icon = "Icon",
	icon_desc = "Put an icon on players with Static Charge and those who loot cores.",

	elemental = "Tainted Elemental spawn",
	elemental_desc = "Warn when the Tainted Elementals spawn during phase 2.",
	elemental_bar = "Tainted Elemental Incoming",
	elemental_soon_message = "Tainted Elemental soon!",

	strider = "Coilfang Strider spawn",
	strider_desc = "Warn when the Coilfang Striders spawn during phase 2.",
	strider_bar = "Strider Incoming",
	strider_soon_message = "Strider soon!",

	naga = "Coilfang Elite Naga spawn",
	naga_desc = "Warn when the Coilfang Elite Naga spawn during phase 2.",
	naga_bar = "Naga Incoming",
	naga_soon_message = "Naga soon!",

	barrier = "Barrier down",
	barrier_desc = "Alert when the barriers go down.",
	barrier_down_message = "Barrier %d/4 down!",
	barrier_fades_trigger = "Magic Barrier fades from Lady Vashj.",

	loot = "Tainted Core",
	loot_desc = "Warn who loots the Tainted Cores.",
	loot_message = "%s looted a core!",
} end )

L:RegisterTranslations("koKR", function() return {
	["Tainted Elemental"] = "오염된 정령",

	engage_trigger1 = "천한 놈들을 상대하며 품위를 손상시키고 싶진 않았는데... 제 손으로 무덤을 파는구나.",
	engage_trigger2 = "육지에 사는 더러운 놈들같으니!",
	engage_trigger3 = "일리단 군주님께 승리를!",
	engage_trigger4 = "머리부터 발끝까지 성치 못할 줄 알아라!",
	engage_trigger5 = "침입자들에게 죽음을!",
	engage_message = "1단계 시작",

	phase = "단계 경고",
	phase_desc = "바쉬가 다음 단계로 변경 시 알림니다.",
	phase2_trigger = "때가 왔다! 한 놈도 살려두지 마라!",
 	phase2_soon_message = "잠시 후 2 단계!",
	phase2_message = "2 단계, 애드 주의!",
	phase3_message = "3 단계 - 4분 이내 격노!",

	static = "전하 충전",
	static_desc = "전하 충전에 걸린 플레이어를 알립니다.",
	static_charge_trigger = "^([^|;%s]*)(.*)전하 충전에 걸렸습니다%.$",
	static_charge_message = "%s 전하 충전!",
	static_fade = "당신의 전하 충전 사라짐.",

	icon = "전술 표시",
	icon_desc = "전하 충전에 걸린 플레이어와 핵을 획득한 플레이어에게 전술 표시를 지정합니다 (승급자 이상 권한 요구).",

	elemental = "오염된 정령 등장",
	elemental_desc = "2 단계에서 오염된 정령 등장 시 경고합니다.",
	elemental_bar = "오염된 정령 등장",
	elemental_soon_message = "잠시 후 오염된 정령!",

	strider = "포자손 등장",
	strider_desc = "2 단계에서 포자손 등장 시 경고합니다.",
	strider_bar = "포자손 등장",
	strider_soon_message = "잠시 후 포자손!",

	naga = "정예병 등장",
	naga_desc = "2 단계에서 정예병 등장 시 경고합니다.",
	naga_bar = "정예병 등장",
	naga_soon_message = "잠시 후 정예병!",

	barrier = "보호막 손실",
	barrier_desc = "보호막 손실 시 알립니다.",
	barrier_down_message = "보호막 %d/4 손실!",
	barrier_fades_trigger = "여군주 바쉬의 몸에서 마법 보호막 효과가 사라졌습니다.", -- check

	loot = "오염된 핵",
	loot_desc = "오염된 핵을 획득한 플레이어를 알립니다.",
	loot_message = "%s 핵 획득!",
} end )

L:RegisterTranslations("frFR", function() return {
	["Tainted Elemental"] = "Elémentaire souillé",

	engage_trigger1 = "J'espérais ne pas devoir m'abaisser à affronter des créatures de la surface, mais vous ne me laissez pas le choix…", -- à vérifier
	engage_trigger2 = "Je te crache dessus, racaille de la surface !", -- à vérifier
	engage_trigger3 = "Victoire au seigneur Illidan !",
	engage_trigger4 = "Je vais te déchirer de part en part !", -- à vérifier
	engage_trigger5 = "Mort aux étrangers !", -- à vérifier
	engage_message = "Début de la phase 1",

	phase = "Phases",
	phase_desc = "Préviens quand la rencontre entre dans une nouvelle phase.",
	phase2_trigger = "L'heure est venue ! N'épargnez personne !",
	phase2_soon_message = "Phase 2 imminente !",
	phase2_message = "Phase 2, arrivée des adds !",
	phase3_trigger = "Il faudrait peut-être vous mettre à l'abri.",
	phase3_message = "Phase 3 - Enragée dans 4 min. !",

	static = "Charge statique",
	static_desc = "Préviens quand la Charge statique affecte un joueur.",
	static_charge_trigger = "^([^%s]+) ([^%s]+) les effets .* Charge statique%.$",
	static_charge_message = "Charge statique sur %s !",
	static_fade = "Charge statique vient de se dissiper.",

	icon = "Icône",
	icon_desc = "Place une icône de raid sur les joueurs affectés par la Charge statique et sur ceux qui ramassent les noyaux.",

	elemental = "Elémentaires souillés",
	elemental_desc = "Préviens quand les Elémentaires souillés apparaissent durant la phase 2.",
	elemental_bar = "Prochain élémentaire souillé",
	elemental_soon_message = "Elémentaire souillé imminent !",

	strider = "Trotteurs de Glissecroc",
	strider_desc = "Préviens quans les Trotteurs de Glissecroc apparaissent durant la phase 2.",
	strider_bar = "Prochain trotteur",
	strider_soon_message = "Trotteur imminent !",

	naga = "Nagas élites de Glissecroc",
	naga_desc = "Préviens quand les Nagas élites de Glissecroc apparaissent durant la phase 2.",
	naga_bar = "Prochain naga",
	naga_soon_message = "Naga imminent !",

	barrier = "Dissipation des barrières",
	barrier_desc = "Préviens quand les barrières se dissipent.",
	barrier_down_message = "Barrière %d/4 dissipée !",
	barrier_fades_trigger = "Barrière magique sur Dame Vashj vient de se dissiper.",

	loot = "Noyau contaminé",
	loot_desc = "Préviens quand un joueur ramasse un Noyau contaminé.",
	loot_message = "%s a ramassé un noyau !",
} end )

L:RegisterTranslations("deDE", function() return {
	["Tainted Elemental"] = "Besudelter Elementar",

	engage_trigger1 = "Normalerweise w\195\188rde ich mich nicht herablassen, Euresgleichen pers\195\182nlich gegen\195\188berzutreten, aber ihr lasst mir keine Wahl...",
	engage_trigger2 = "Ich spucke auf Euch, Oberfl�chenbewohner", -- to verify
	engage_trigger3 = "Victory to Lord Illidan! ", -- to translate
	engage_trigger4 = "I'll split you from stem to stern!", -- to translate
	engage_trigger5 = "Tod den Eindringlingen!",
	engage_message = "Phase 1",

	phase = "Phasen Warnung",
	phase_desc = "Warnt, wenn Vashj ihre Phase wechselt.",
	phase2_trigger = "Die Zeit ist gekommen! Lasst keinen am Leben!",
	phase2_soon_message = "Phase 2 bald!",
	phase2_message = "Phase 2, Adds kommen!",
	phase3_message = "Phase 3 - Wutanfall in 4min!",

	static = "Statische Aufladung",
	static_desc = "Warnt vor Statischer Aufladung auf Spielern.",
	static_charge_trigger = "^([^%s]+) ([^%s]+) von Statische Aufladung betroffen%.$",
	static_charge_message = "Statische Aufladung auf %s!",
	static_fade = "'Statische Aufladung' schwindet von Euch.",

	icon = "Icon",
	icon_desc = "Plaziert ein Icon auf Spielern mit Statische Aufladung und denen, die einen Besudelten Kern looten.",

	elemental = "Besudelter Elementar spawn",
	elemental_desc = "Warnt, wenn ein Besudelter Elementar w\195\164rend Phase 2 spawnt.",
	elemental_bar = "Besudelter Elementar kommt",
	elemental_soon_message = "Besudelter Elementar bald!",

	strider = "Schreiter des Echsenkessels spawn",
	strider_desc = "Warnt, wenn ein Schreiter des Echsenkessels w\195\164rend Phase 2 spawnt.",
	strider_bar = "Schreiter kommt",
	strider_soon_message = "Schreiter bald!",

	naga = "Naga Elite spawn",
	naga_desc = "Warnt, wenn ein Naga Elite w\195\164rend Phase 2 spawnt.",
	naga_bar = "Naga Elite kommt",
	naga_soon_message = "Naga Elite bald!",

	barrier = "Barriere zerst\195\182rt",
	barrier_desc = "Alarmiert, wenn die Barrieren in Phase 2 zerst\195\182rt werden.",
	barrier_down_message = "Barriere %d/4 zerst\195\182rt!",
	barrier_fades_trigger = "Magiebarriere schwindet von Lady Vashj.",

	loot = "Besudelter Kern",
	loot_desc = "Warnt wer einen Besudelten Kern lootet.",
	loot_message = "%s hat einen Kern gelootet!",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Serpentshrine Cavern"]
mod.enabletrigger = boss
mod.wipemobs = {elite, strider, L["Tainted Elemental"]}
mod.toggleoptions = {"phase", -1, "static", "icon", -1, "elemental", "strider","naga", "loot", "barrier", "proximity", "bosskill"}
mod.revision = tonumber(("$Revision: 46472 $"):sub(12, -3))
mod.proximityCheck = function( unit ) return CheckInteractDistance( unit, 3 ) end

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	pName = UnitName("player")

	self:RegisterEvent("CHAT_MSG_LOOT")

	self:RegisterEvent("PLAYER_REGEN_ENABLED", "CheckForWipe")
	self:RegisterEvent("UNIT_HEALTH")
	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_DAMAGE", "Charge")
	self:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE", "Charge")

	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
	self:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_SELF")
	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")

	self:RegisterEvent("BigWigs_RecvSync")
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjStatic", 5)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjLoot", 2)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformatCheck", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjDeformat", 0)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjBarrier", 4)
	self:TriggerEvent("BigWigs_ThrottleSync", "VashjElemDied", 5)
end

------------------------------
--      Event Handlers      --
------------------------------

do
	local lootItem = '^' .. LOOT_ITEM:gsub("%%s", "(.-)") .. '$'
	local lootItemSelf = '^' .. LOOT_ITEM_SELF:gsub("%%s", "(.*)") .. '$'
	function mod:CHAT_MSG_LOOT(msg)
		local player, item = select(3, msg:find(lootItem))
		if not player then
			item = select(3, msg:find(lootItemSelf))
			if item then
				player = pName
			end
		end

		if type(item) == "string" and type(player) == "string" then
			local itemLink, itemRarity = select(2, GetItemInfo(item))
			if itemRarity and itemRarity == 1 and itemLink then
				local itemId = select(3, itemLink:find("item:(%d+):"))
				if not itemId then return end
				itemId = tonumber(itemId:trim())
				if type(itemId) ~= "number" or itemId ~= 31088 then return end -- Tainted Core
				self:Sync("VashjLoot " .. player)
			end
		end
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_OTHER(msg)
	if msg == L["barrier_fades_trigger"] then
		self:Sync("VashjBarrier")
	end
end

function mod:CHAT_MSG_SPELL_AURA_GONE_SELF(msg)
	if msg == L["static_fade"] then
		self:CancelScheduledEvent("cancelProx")
		self:TriggerEvent("BigWigs_HideProximity", self)
	end
end

do
	local elemDies = UNITDIESOTHER:format(L["Tainted Elemental"])
	function mod:CHAT_MSG_COMBAT_HOSTILE_DEATH(msg)
		if msg == elemDies then
			self:Sync("VashjElemDied")
		else
			self:GenericBossDeath(msg)
		end
	end
end

function mod:RepeatStrider()
	if self.db.profile.strider then
		self:Bar(L["strider_bar"], 63, "Spell_Nature_AstralRecal")
		self:ScheduleEvent("StriderWarn", "BigWigs_Message", 58, L["strider_soon_message"], "Attention")
	end
	self:ScheduleEvent("Strider", self.RepeatStrider, 63, self)
end

function mod:RepeatNaga()
	if self.db.profile.naga then
		self:Bar(L["naga_bar"], 47.5, "INV_Misc_MonsterHead_02")
		self:ScheduleEvent("NagaWarn", "BigWigs_Message", 42.5, L["naga_soon_message"], "Attention")
	end
	self:ScheduleEvent("Naga", self.RepeatNaga, 47.5, self)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L["phase2_trigger"] then
		self:TriggerEvent("BigWigs_RemoveRaidIcon")
		if self.db.profile.phase then
			self:Message(L["phase2_message"], "Important", nil, "Alarm")
		end
		shieldsFaded = 0
		if self.db.profile.elemental then
			self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
			delayedElementalMessage = self:DelayedMessage(55, L["elemental_soon_message"], "Important")
		end
		self:RepeatStrider()
		self:RepeatNaga()
	elseif msg == L["engage_trigger1"] or msg == L["engage_trigger2"] or msg == L["engage_trigger3"]
		or msg == L["engage_trigger4"] or msg == L["engage_trigger5"] then

		phaseTwoAnnounced = nil
		shieldsFaded = 0
		self:Message(L["engage_message"], "Attention")
	elseif self.db.profile.phase and msg == L["phase3_trigger"] then
		self:Message(L["phase3_message"], "Important", nil, "Alarm")
		self:Bar(L2["enrage"], 240, "Spell_Shadow_UnholyFrenzy")
		self:DelayedMessage(180, L2["enrage_min"]:format(1), "Positive")
		self:DelayedMessage(210, L2["enrage_sec"]:format(30), "Positive")
		self:DelayedMessage(230, L2["enrage_sec"]:format(10), "Urgent")
		self:DelayedMessage(240, L2["enrage_end"]:format(boss), "Attention", nil, "Alarm")

		self:CancelScheduledEvent("ElemWarn")
		self:CancelScheduledEvent("StriderWarn")
		self:CancelScheduledEvent("NagaWarn")
		self:CancelScheduledEvent("Strider")
		self:CancelScheduledEvent("Naga")
		self:TriggerEvent("BigWigs_StopBar", self, L["elemental_bar"])
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.phase then return end
	if UnitName(msg) == boss then
		local hp = UnitHealth(msg)
		if hp > 70 and hp < 75 and not phaseTwoAnnounced then
			self:Message(L["phase2_soon_message"], "Attention")
			phaseTwoAnnounced = true
		elseif hp > 80 and phaseTwoAnnounced then
			phaseTwoAnnounced = nil
		end
	end
end

function mod:Charge(msg)
	local splayer, stype = select(3, msg:find(L["static_charge_trigger"]))
	if splayer and stype then
		if splayer == L2["you"] and stype == L2["are"] then
			splayer = pName
			self:CancelScheduledEvent("cancelProx")
			self:TriggerEvent("BigWigs_ShowProximity", self)
			self:ScheduleEvent("cancelProx", "BigWigs_HideProximity", 20, self)
		end
		self:Sync("VashjStatic " .. splayer)
	end
end

function mod:BigWigs_RecvSync( sync, rest, nick )
	if sync == "VashjStatic" and rest and self.db.profile.static then
		local msg = L["static_charge_message"]:format(rest)
		self:Message(msg, "Important", nil, "Alert")
		self:Bar(msg, 20, "Spell_Nature_LightningOverload")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjElemDied" and self.db.profile.elemental then
		self:Bar(L["elemental_bar"], 60, "Spell_Nature_ElementalShields")
		self:ScheduleEvent("ElemWarn", "BigWigs_Message", 55, L["elemental_soon_message"], "Important")
	elseif sync == "VashjLoot" and rest and self.db.profile.loot then
		self:Message(L["loot_message"]:format(rest), "Positive", nil, "Info")
		if self.db.profile.icon then
			self:Icon(rest)
		end
	elseif sync == "VashjDeformatCheck" then
		self:Sync("VashjDeformat")
	elseif sync == "VashjBarrier" then
		shieldsFaded = shieldsFaded + 1
		if shieldsFaded < 4 and self.db.profile.barrier then
			self:Message(L["barrier_down_message"]:format(shieldsFaded), "Attention")
		end
	end
end

