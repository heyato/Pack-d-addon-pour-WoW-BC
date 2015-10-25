﻿------------------------------
--      Are you local?      --
------------------------------

local boss = AceLibrary("Babble-Boss-2.2")["Shade of Aran"]
local L = AceLibrary("AceLocale-2.2"):new("BigWigs"..boss)
local drinkannounced = nil
local addsannounced = nil

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	cmd = "Aran",

	engage_trigger1 = "I'll not be tortured again!",
	engage_trigger2 = "Who are you? What do you want? Stay away from me!",
	engage_trigger3 = "Please, no more! My son... he's gone mad!",
	engage_message = "%s Engaged",

	adds = "Elementals",
	adds_desc = "Warn about the water elemental adds spawning.",
	adds_message = "Elementals Incoming!",
	adds_warning = "Elementals Soon",
	adds_trigger = "I'm not finished yet! No, I have a few more tricks up my sleeve...",
	adds_bar = "Elementals despawn",

	drink = "Drinking",
	drink_desc = ("Warn when %s starts to drink."):format(boss),
	drink_trigger = "Surely you wouldn't deny an old man a replenishing drink? No, no, I thought not.",
	drink_warning = "Low Mana - Drinking Soon!",
	drink_message = "Drinking - AoE Polymorph!",
	drink_bar = "Super Pyroblast Incoming",

	blizzard = "Blizzard",
	blizzard_desc = "Warn when Blizzard is being cast.",
	blizzard_trigger1 = "Back to the cold dark with you!",
	blizzard_trigger2 = "I'll freeze you all!",
	blizzard_message = "Blizzard!",

	pull = "Pull/Super AE",
	pull_desc = "Warn for the magnetic pull and Super Arcane Explosion.",
	pull_message = "Arcane Explosion!",
	pull_trigger1 = "Yes, yes my son is quite powerful... but I have powers of my own!",
	pull_trigger2 = "I am not some simple jester! I am Nielas Aran!",
	pull_bar = "Arcane Explosion",

	flame = "Flame Wreath",
	flame_desc = "Warn when Flame Wreath is being cast.",
	flame_warning = "Casting: Flame Wreath!",
	flame_trigger1 = "I'll show you: this beaten dog still has some teeth!",
	flame_trigger2 = "Burn, you hellish fiends!",
	flame_message = "Flame Wreath!",
	flame_bar = "Flame Wreath",
	flame_trigger = "casts Flame Wreath%.$",
} end )

L:RegisterTranslations("deDE", function() return {
	adds = "Wasserelementare",
	adds_desc = "Warnt vor den Wasserelementaren bei 40%.",

	drink = "Trinken",
	drink_desc = ("Warnt, wenn %s zu trinken beginnt."):format(boss),

	blizzard = "Blizzard",
	blizzard_desc = "Warnt vor dem Blizzard.",

	pull = "Magnet/Super-AE",
	pull_desc = "Warnt vor dem Magnetpull und der Arkanen Explosion.",

	flame = "Flammenkranz",
	flame_desc = "Warnt, wenn jemand vom Flammenkranz betroffen ist.",

	adds_message = "Elementare!",
	adds_warning = "Elementare in K\195\188rze!",
	adds_trigger = "Ich bin noch nicht fertig! Nein, ich habe noch ein paar Tricks auf Lager…",
	adds_bar = "Elementare verschwinden",

	drink_trigger = "Ihr w\195\188rdet einem alten Mann doch nicht ein erfrischendes Getr\195\164nk verweigern? Nein nein, das h\195\164tte ich auch nicht gedacht.",
	drink_warning = "Wenig Mana - trinkt gleich!",
	drink_message = "Trinkt - AoE Polymorph!",
	drink_bar = "Super-Pyroblast kommt!",

	engage_trigger1 = "Qu\195\164lt mich nicht l\195\164nger!",
	engage_trigger2 = "Wer seid Ihr? Was wollt Ihr? Bleibt fern von mir!",
	engage_message = "%s angegriffen.",

	blizzard_trigger1 = "Zur\195\188ck in die eisige Finsternis mit Euch!",
	blizzard_trigger2 = "Ich werde Euch alle einfrieren!",
	blizzard_message = "Wirkt Blizzard!",

	pull_message = "Arkane Explosion wird gewirkt!",
	pull_trigger1 = "Ja, ja, mein Sohn ist sehr m\195\164chtig... aber ich habe meine eigenen Kr\195\164fte!",
	pull_trigger2 = "Ich bin kein einfacher Hofnarr! Ich bin Nielas Aran!",
	pull_bar = "Arkane Explosion",

	flame_warning = "Wirkt Flammenkranz!",
	flame_trigger1 = "Ich werde Euch zeigen: dieser gepr\195\188gelte Hund hat immer noch Z\195\164hne!",
	flame_trigger2 = "Brennt, Ihr herzlosen Teufel!",

	flame_message = "Flammenkranz!",
	flame_bar = "Flammenkranz",
	flame_trigger = "wirkt Flammenkranz",
} end )

L:RegisterTranslations("frFR", function() return {
	engage_trigger1 = "Je refuse d'être à nouveau torturé !",
	engage_trigger2 = "Qui êtes-vous ? Qu’est-ce que vous voulez ? Ne m’approchez pas !",
	engage_trigger3 = "Je vous en supplie, arrêtez ! Mon fils… est devenu fou !",
	engage_message = "%s engagé",

	adds = "Elémentaires",
	adds_desc = "Préviens quand les élémentaires d'eau apparaissent.",
	adds_message = "Arrivée des élémentaires !",
	adds_warning = "Elémentaires imminent",
	adds_trigger = "Je ne suis pas encore vaincu ! Non, j’ai encore quelques tours dans mon sac…",
	adds_bar = "Fin des élémentaires",

	drink = "Boisson",
	drink_desc = ("Préviens quand %s commence à boire."):format(boss),
	drink_trigger = "Vous ne refuseriez pas à un vieil homme une boisson revigorante ? Non, c’est bien ce que je pensais.",
	drink_warning = "Mana Faible - Boisson imminente !",
	drink_message = "Boisson - Polymorphisme de zone !",
	drink_bar = "Super Explosion pyro.",

	blizzard = "Blizzard",
	blizzard_desc = "Préviens quand Blizzard est incanté.",
	blizzard_trigger1 = "Retournez dans les ténèbres glaciales !",
	blizzard_trigger2 = "Je vais tous vous congeler !",
	blizzard_message = "Blizzard !",

	pull = "Attraction/Sort de zone",
	pull_desc = "Préviens de l'attraction magnétique et de l'explosion des arcanes.",
	pull_message = "Explosion des Arcanes !",
	pull_trigger1 = "Oui, oui, mon fils est assez puissant… mais moi aussi je possède quelques pouvoirs !",
	pull_trigger2 = "Je ne suis pas un simple bouffon ! Je suis Nielas Aran !",
	pull_bar = "Explosion des Arcanes",

	flame = "Couronne de flammes",
	flame_desc = "Préviens quand Couronne de flammes est incanté.",
	flame_warning = "Incante : Couronne de flammes !",
	flame_trigger1 = "Je vais vous montrer que ce chien battu a encore de bons crocs !",
	flame_trigger2 = "Brûlez, démons de l’enfer !",
	flame_message = "Couronne de flammes !",
	flame_bar = "Couronne de flammes",
	flame_trigger = "lance Couronne de flammes",
} end )

L:RegisterTranslations("koKR", function() return {
	engage_trigger1 = "똑같은 고통을 겪진 않겠다.",
	engage_trigger2 = "너흰 누구냐? 원하는 게 뭐야? 가까이 오지 마!",
	engage_trigger3 = "제발 그만! 내 아들... 그 아이는 미쳤어!",
	engage_message = "%s 전투 개시",

	adds = "물의 정령",
	adds_desc = "물의 정령 소환에 대한 경고입니다.",
	adds_message = "정령 소환!",
	adds_warning = "곧 정령 소환",
	adds_trigger = "아직 끝나지 않았어! 몇 가지 계략을 준비해 두었지...",
	adds_bar = "물의 정령",

	drink = "음료 마시기",
	drink_desc = ("%s의 음료 마시기 시작 시 알립니다."):format(boss),
	drink_trigger = "목 좀 축이게 해달라는 이 늙은이의 청을 뿌리칠 텐가? 아... 별로 기대도 안 했어.",
	drink_warning = "마나 낮음 - 잠시 후 음료 마시기!",
	drink_message = "음료 마시기 - 광역 변이!",
	drink_bar = "불덩이 작열 시전",

	blizzard = "눈보라",
	blizzard_desc = "눈보라 시전 시 경고합니다.",
	blizzard_trigger1 = "차가운 암흑으로 돌아가라!",
	blizzard_trigger2 = "모두 얼려 버리겠다!",
	blizzard_message = "눈보라!",

	pull = "전체 광역",
	pull_desc = "전체 광역 신비한 폭발에 대한 경고입니다.",
	pull_message = "신비한 폭발!",
	pull_trigger1 = "그래, 내 아들은 아주 강하지... 하지만, 내게도 힘은 있다!",
	pull_trigger2 = "난 어릿광대 따위가 아니다! 나는 니엘라스 아란이다!",
	pull_bar = "신비한 폭발",

	flame = "화염의 고리",
	flame_desc = "화염의 고리 시전 시 경고합니다.",
	flame_warning = "시전: 화염의 고리!",
	flame_trigger1 = "너희에게 보여주마! 아무리 지친 개라도 송곳니는 있는 법!",
	flame_trigger2 = "불타라, 지옥의 악마들아!",
	flame_message = "화염의 고리!",
	flame_bar = "화염의 고리",
	flame_trigger = "화염의 고리|1을;를; 시전합니다%.$",
} end )

L:RegisterTranslations("zhTW", function() return {
	engage_trigger1 = "我不會再被折磨了!",
	engage_trigger2 = "你是誰?你想要什麼?離我遠一點!",
	engage_trigger3 = "拜託，不要了!我的兒子……他已經瘋了!",
	engage_message = "%s 戰鬥開始",

	adds = "召喚水元素",
	adds_desc = "當埃蘭之影召喚水元素時發送警告",
	adds_message = "召喚水元素",
	adds_warning = "埃蘭之影即將召喚水元素",
	adds_trigger = "我還沒結束!不，我還有一些小伎倆沒施展出來",
	adds_bar = "召喚水元素",

	drink = "群體變羊",
	drink_desc = ("當 %s 開始回魔時發送警告"):format(boss),
	drink_trigger = "想必你不會拒絕給一個老人補充飲品吧?不，不，我想不會。",
	drink_warning = "埃蘭之影魔力太低",
	drink_message = "群體變羊術 - 埃蘭之影開始回魔",
	drink_bar = "群體變羊術",

	blizzard = "暴風雪警告",
	blizzard_desc = "當埃蘭之影施放暴風雪時發送警告",
	blizzard_trigger1 = "滾回你那冰冷的黑暗之中!",
	blizzard_trigger2 = "我會把你們全都凍死!",
	blizzard_message = "暴風雪 - 順時針方向走避",

	pull = "巨力磁力/魔爆術警告",
	pull_desc = "當埃蘭之影施放巨力磁力及魔爆術時發送警告",
	pull_message = "魔爆術 - 立刻向外圍跑",
	pull_trigger1 = "是的，沒錯，我兒子的力量相當強大……但我有我自己的力量!",
	pull_trigger2 = "我不是什麼普通的的小丑!我是聶拉斯·埃蘭!",
	pull_bar = "魔爆術",

	flame = "烈焰火圈警告",
	flame_desc = "當埃蘭之影施放烈焰火圈時發送警告",
	flame_warning = "烈焰火圈 - 全部都別動",
	flame_trigger1 = "我會讓你們看到：被打的狗也是會反擊的!",
	flame_trigger2 = "燃燒吧，你這地獄的惡魔!",
	flame_message = "埃蘭之影施放烈焰火圈",
	flame_bar = "烈焰火圈",
	flame_trigger = "施放烈焰火圈",
} end )

----------------------------------
--      Module Declaration      --
----------------------------------

local mod = BigWigs:NewModule(boss)
mod.zonename = AceLibrary("Babble-Zone-2.2")["Karazhan"]
mod.enabletrigger = boss
mod.toggleoptions = {"adds", "drink", -1, "blizzard", "pull", "flame", "bosskill"}
mod.revision = tonumber(("$Revision: 43476 $"):sub(12, -3))

------------------------------
--      Initialization      --
------------------------------

function mod:OnEnable()
	self:RegisterEvent("CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE")

	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UNIT_HEALTH")

	self:RegisterEvent("CHAT_MSG_MONSTER_YELL")
	self:RegisterEvent("CHAT_MSG_MONSTER_SAY")

	self:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH", "GenericBossDeath")
end

------------------------------
--      Event Handlers      --
------------------------------

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if self.db.profile.drink and msg == L["drink_trigger"] then
		self:Message(L["drink_message"], "Positive")
		self:Bar(L["drink_bar"], 15, "Spell_Fire_Fireball02")
	elseif self.db.profile.pull and (msg == L["pull_trigger1"] or msg == L["pull_trigger2"]) then
		self:Message(L["pull_message"], "Attention")
		self:Bar(L["pull_bar"], 12, "Spell_Nature_GroundingTotem")
	elseif self.db.profile.flame and (msg == L["flame_trigger1"] or msg == L["flame_trigger2"]) then
		self:Message(L["flame_warning"], "Important", nil, "Alarm")
		self:Bar(L["flame_bar"], 5, "Spell_Fire_Fire")
	elseif self.db.profile.blizzard and (msg == L["blizzard_trigger1"] or msg == L["blizzard_trigger2"]) then
		self:Message(L["blizzard_message"], "Attention")
		self:Bar(L["blizzard_message"], 36, "Spell_Frost_IceStorm")
	elseif msg == L["engage_trigger1"] or msg == L["engage_trigger2"] or msg == L["engage_trigger3"] then
		drinkannounced = nil
		addsannounced = nil
		self:Message(L["engage_message"]:format(boss), "Positive")
	end
end

function mod:CHAT_MSG_MONSTER_SAY(msg)
	if self.db.profile.adds and msg == L["adds_trigger"] then
		self:Message(L["adds_message"], "Important")
		self:Bar(L["adds_bar"], 90, "Spell_Frost_SummonWaterElemental_2")
	end
end

function mod:CHAT_MSG_SPELL_CREATURE_VS_CREATURE_DAMAGE(msg)
	if self.db.profile.flame and msg:find(L["flame_trigger"]) then
		self:Message(L["flame_message"], "Important")
		self:Bar(L["flame_bar"], 21, "Spell_Fire_Fire")
	end
end

function mod:UNIT_MANA(msg)
	if not self.db.profile.drink then return end
	if UnitName(msg) == boss then
		local mana = UnitMana(msg)
		if mana > 33000 and mana <= 37000 and not drinkannounced then
			self:Message(L["drink_warning"], "Urgent", nil, "Alert")
			drinkannounced = true
		elseif mana > 50000 and drinkannounced then
			drinkannounced = nil
		end
	end
end

function mod:UNIT_HEALTH(msg)
	if not self.db.profile.adds then return end
	if UnitName(msg) == boss then
		local health = UnitHealth(msg)
		if health > 43 and health <= 46 and not addsannounced then
			self:Message(L["adds_warning"], "Urgent", nil, "Alert")
			addsannounced = true
		elseif health > 50 and addsannounced then
			addsannounced = false
		end
	end
end
