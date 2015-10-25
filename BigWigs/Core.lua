﻿------------------------------
--      Are you local?      --
------------------------------

local BZ = AceLibrary("Babble-Zone-2.2")
local BB = nil
local L = AceLibrary("AceLocale-2.2"):new("BigWigs")

local customBossOptions = {}

----------------------------
--      Localization      --
----------------------------

L:RegisterTranslations("enUS", function() return {
	["%s mod enabled"] = true,
	["%s has been defeated"] = true,     -- "<boss> has been defeated"
	["%s have been defeated"] = true,    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = true,
	["Debug disabled."] = true,

	-- AceConsole strings
	["Bosses"] = true,
	["Options for bosses in %s."] = true, -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = true,     -- "Options for <boss> (<revision>)"
	["Plugins"] = true,
	["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."] = true,
	["Extras"] = true,
	["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."] = true,
	["Active"] = true,
	["Activate or deactivate this module."] = true,
	["Reboot"] = true,
	["Reboot this module."] = true,
	["Debugging"] = true,
	["Show debug messages."] = true,
	["Options"] = true,
	bosskill = "Boss death",
	bosskill_desc = "Announce when the boss has been defeated.",
	enrage = "Enrage",
	enrage_desc = "Warn when the boss enters an enraged state.",

	["Load"] = true,
	["Load All"] = true,
	["Load all %s modules."] = true,
} end)

L:RegisterTranslations("frFR", function() return {
	["%s mod enabled"] = "Module %s activé",
	["%s has been defeated"] = "%s a été vaincu(e)",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s ont été vaincu(e)s",    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = "Déboguage activé, output dirigé vers %s.",
	["Debug disabled."] = "Déboguage désactivé.",

	-- AceConsole strings
	["Bosses"] = "Boss",
	["Options for bosses in %s."] = "Options concernant les boss dans %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Options concernant %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Extras"] = "Extras",
	["Active"] = "Actif",
	["Activate or deactivate this module."] = "Active ou désactive ce module.",
	["Reboot"] = "Redémarrer",
	["Reboot this module."] = "Redémarre ce module.",
	["Debugging"] = "Déboguage",
	["Show debug messages."] = "Affiche les messages de déboguage.",
	["Options"] = "Options",
	bosskill = "Défaite du boss",
	bosskill_desc = "Préviens quand le boss est vaincu.",
	enrage = "Enrager",
	enrage_desc = "Préviens quand le boss devient enragé.",

	["Load"] = "Charger",
	["Load All"] = "Tout charger",
	["Load all %s modules."] = "Charge tous les modules \"%s\".",
} end)

L:RegisterTranslations("deDE", function() return {
	["%s mod enabled"] = "%s Modul aktiviert",
	["%s has been defeated"] = "%s wurde besiegt",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s wurden besiegt",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "Bosse",
	["Options for bosses in %s."] = "Optionen f\195\188r Bosse in %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Optionen f\195\188r %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Extras"] = "Extras",
	-- ["toggle"] = true,
	["Active"] = "Aktivieren",
	["Activate or deactivate this module."] = "Aktiviert oder deaktiviert dieses Modul.",
	-- ["reboot"] = true,
	["Reboot"] = "Neustarten",
	["Reboot this module."] = "Startet dieses Modul neu.",
	-- ["debug"] = true,
	["Debugging"] = "Debugging",
	["Show debug messages."] = "Zeige Debug Nachrichten.",
	["Options"] = "Optionen",
	bosskill = "Boss besiegt",
	bosskill_desc = "Melde, wenn ein Boss besiegt wurde.",
	enrage = "Wutanfall",
	enrage_desc = "Melde, wenn ein Boss in einen Wutanfall Status geht.",

	["Load"] = "Laden",
	["Load All"] = "Alle Laden",
	["Load all %s modules."] = "Alle %s Module laden.",
} end)

L:RegisterTranslations("koKR", function() return {
	["%s mod enabled"] = "%s 모듈 시작",
	["%s has been defeated"] = "<%s> 물리쳤습니다.",     -- "<boss> has been defeated"
	["%s have been defeated"] = "<%s> 물리쳤습니다.",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "보스",
	["Options for bosses in %s."] = "%s에 보스들을 위한 설정입니다.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s에 대한 설정입니다 (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "플러그인",
	["Extras"] = "기타",
	["Active"] = "활성화",
	["Activate or deactivate this module."] = "해당 모듈을 활성화하거나 비활성화합니다.",
	["Reboot"] = "재시작",
	["Reboot this module."] = "해당 모듈을 재시작합니다.",
	["Debugging"] = "디버깅",
	["Show debug messages."] = "디버그 메세지를 표시합니다.",
	["Options"] = "설정",
	bosskill = "보스 사망",
	bosskill_desc = "보스를 물리쳤을 때 알림니다.",
	enrage = "격노",
	enrage_desc = "보스가 격노 상태로 변경 시 경고합니다.",

	["Load"] = "불러오기",
	["Load All"] = "모두 불러오기",
	["Load all %s modules."] = "모든 %s 모듈들을 불러옵니다.",
} end)

--Chinese Translate by: 月色狼影@CWDG
--CWDG site: http://cwowaddon.com
L:RegisterTranslations("zhCN", function() return {
	["%s mod enabled"] = "%s 模块已启用",
	["%s has been defeated"] = "%s 被击败了!",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s 被击败了!",    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = "调试功能启用,输出到%s.",
	["Debug disabled."] = "调试禁用.",

	-- AceConsole strings
	["Bosses"] = "首领模块",
	["Options for bosses in %s."] = "%s首领模块设置.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s首领模块版本 (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "综合设置",
	["Extras"] = "附加功能",
	["Active"] = "激活",
	["Activate or deactivate this module."] = "激活或关闭此模块",
	["Reboot"] = "重置",
	["Reboot this module."] = "重置此模块",
	["Debugging"] = "调试",
	["Show debug messages."] = "显示调试信息",
	["Options"] = "设置",
	bosskill = "首领死亡",
	bosskill_desc = "首领被击杀时显示提示信息",
	enrage = "狂暴",
	enrage_desc = "首领进入狂暴状态时发出警报.",

	["Load"] = "加载",
	["Load All"] = "加载所有",
	["Load all %s modules."] = "加载所有%s模块.",
} end)

L:RegisterTranslations("zhTW", function() return {
	["%s mod enabled"] = "%s模組已開啟",
	["%s has been defeated"] = "%s被擊敗了！",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s被擊敗了！",    -- "<bosses> have been defeated"

	-- AceConsole strings
	["Bosses"] = "首領",
	["Options for bosses in %s."] = "%s首領模組選項。", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "%s模組選項 版本(r%d).",     -- "Options for <boss> (<revision>)"
	["Extras"] = "其他",
	["Plugins"] = "插件",
	["Active"] = "啟動",
	["Activate or deactivate this module."] = "開啟或關閉此模組。",
	["Reboot"] = "重啟",
	["Reboot this module."] = "重啟此模組",
	["Debugging"] = "除錯",
	["Show debug messages."] = "顯示除錯訊息。",

	bosskill = "首領死亡",
	bosskill_desc = "首領被擊敗時發出提示。",
	enrage = "狂暴",
	enrage_desc = "首領進入狂暴狀態時發出提示",

	["Load"] = "載入",
	["Load All"] = "載入全部",
	["Load all %s modules."] = "載入全部%s模組",
} end)

L:RegisterTranslations("esES", function() return {
	["%s mod enabled"] = "Modulo %s activado",
	["%s has been defeated"] = "%s Ha sido derrotado",     -- "<boss> has been defeated"
	["%s have been defeated"] = "%s Han sido derrotados",    -- "<bosses> have been defeated"

	["Debug enabled, output routed to %s."] = "Depuracion activa, salida redirigida a %s.",
	["Debug disabled."] = "Depuracion desactivado.",

	-- AceConsole strings
	["Bosses"] = "Boss",
	["Options for bosses in %s."] = "Opciones relacionadas con el boss %s.", -- "Options for bosses in <zone>"
	["Options for %s (r%d)."] = "Opciones para %s (r%d).",     -- "Options for <boss> (<revision>)"
	["Plugins"] = "Plugins",
	["Extras"] = "Extras",
	["Active"] = "Activo",
	["Activate or deactivate this module."] = "Activa o desactiva este modulo.",
	["Reboot"] = "Reiniciar",
	["Reboot this module."] = "Reiniciar el modulo.",
	["Debugging"] = "Depuracion",
	["Show debug messages."] = "Mostrar mensajes de depuracion.",
	["Options"] = "Opciones",
	bosskill = "Derrota del boss",
	bosskill_desc = "Avisa de la derrota del boss.",
	enrage = "Enfurecimiento",
	enrage_desc = "Avisa cuando el boss gana enfurecimiento.",

	["Load"] = "Cargar",
	["Load All"] = "Cargar todo",
	["Load all %s modules."] = "Cargar todos los modulos \"%s\".",
} end)

---------------------------------
--      Addon Declaration      --
---------------------------------

BigWigs = AceLibrary("AceAddon-2.0"):new(
	"AceEvent-2.0",
	"AceDebug-2.0",
	"AceModuleCore-2.0",
	"AceConsole-2.0",
	"AceDB-2.0"
)

BigWigs:SetModuleMixins("AceEvent-2.0")

local options = {
	type = "group",
	handler = BigWigs,
	args = {
		[L["Bosses"]] = {
			type = "header",
			name = L["Bosses"],
			order = 1,
		},
		["spacer"] = {
			type = "header",
			name = " ",
			order = 200,
		},
		[L["Options"]] = {
			type = "header",
			name = L["Options"],
			order = 201,
		},
		[L["Plugins"]] = {
			type = "group",
			name = L["Plugins"],
			desc = L["Plugins handle the core features of Big Wigs - like displaying messages, timer bars, and other essential features."],
			args = {},
			disabled = "~IsActive",
			order = 202,
		},
		[L["Extras"]] = {
			type = "group",
			name = L["Extras"],
			desc = L["Extras are 3rd party and bundled plugins that Big Wigs will function properly without."],
			args = {},
			disabled = "~IsActive",
			order = 203,
		},
	},
}

BigWigs.revision = tonumber(("$Revision: 46793 $"):sub(12, -3))
BigWigs.cmdtable = options

------------------------------
--      Initialization      --
------------------------------

function BigWigs:OnInitialize()
	self:RegisterDB("BigWigsDB", "BigWigsDBPerChar")

	self:RegisterChatCommand("/bw", "/BigWigs", options, "BIGWIGS")

	if not self.version then self.version = GetAddOnMetadata("BigWigs", "Version") end
	self.version = (self.version or "2.0") .. " |cffff8888r" .. self.revision .. "|r"

	self:RegisterBossOption("bosskill", L["bosskill"], L["bosskill_desc"])
	self:RegisterBossOption("enrage", L["enrage"], L["enrage_desc"])
end

function BigWigs:OnEnable(first)
	-- We only really enable ourselves if we are told to do so by BigWigsLoD.
	if not first then
		-- this will trigger the LoadWithCore to load
		self:TriggerEvent("BigWigs_CoreEnabled")

		-- Enable all disabled modules that are not boss modules.
		for name, module in self:IterateModules() do
			if type(module.IsBossModule) ~= "function" or not module:IsBossModule() then
				self:ToggleModuleActive(module, true)
			end
		end

		self:RegisterEvent("BigWigs_TargetSeen")
		self:RegisterEvent("BigWigs_RebootModule")
		self:RegisterEvent("BigWigs_RecvSync")
	else
		self:ToggleActive(false)
	end
end

function BigWigs:OnDisable()
	-- Disable all modules
	for name, module in self:IterateModules() do
		self:ToggleModuleActive(module, false)
	end

	self:TriggerEvent("BigWigs_CoreDisabled")
end

function BigWigs:OnDebugEnable() self:ToggleModuleDebugging(true) end
function BigWigs:OnDebugDisable() self:ToggleModuleDebugging(false) end

-------------------------------
--      API                  --
-------------------------------

function BigWigs:ToggleModuleDebugging(enable)
	local frame = self.debugFrame or ChatFrame5
	if enable then
		self:Print(L["Debug enabled, output routed to %s."]:format(frame:GetName()))
	else
		self:Print(L["Debug disabled."])
	end
	for name, module in self:IterateModules() do
		if type(module.SetDebugging) == "function" then
			module:SetDebugging( enable )
			module.debugFrame = frame
		end
	end
end

function BigWigs:RegisterBossOption(key, name, desc, func)
	if customBossOptions[key] then
		error("The custom boss option %q has already been registered."):format(key)
	end
	customBossOptions[key] = { name, desc, func }
end

-------------------------------
--      Module Handling      --
-------------------------------

do
	local opts = {}
	local active = {
		type = "toggle",
		name = L["Active"],
		order = 1,
		desc = L["Activate or deactivate this module."],
	}
	local headerSpacer = {
		type = "header",
		order = 50,
		name = " ",
	}

	-- We can't use the AceModuleCore :OnModuleCreated, since the properties on the
	-- module has not been set when it's triggered.
	function BigWigs:RegisterModule(module)
		if type(module.revision) ~= "number" then
			error("%q does not have a valid revision field."):format(name)
		end
		local name = module.name

		if module:IsBossModule() then
			self:ToggleModuleActive(module, false)
			for i,v in ipairs(module.toggleoptions) do
				if type(v) == "string" then
					opts[v] = true
				end
			end
			self:RegisterDefaults(name, "profile", opts)
			for i in ipairs(opts) do opts[i] = nil end
			module.db = self:AcquireDBNamespace(name)
		elseif type(module.defaultDB) == "table" then
			self:RegisterDefaults(name, "profile", module.defaultDB)
			module.db = self:AcquireDBNamespace(name)
		end

		-- Set up AceConsole
		if module:IsBossModule() then
			local cons = module.consoleOptions
			local ML = AceLibrary("AceLocale-2.2"):new("BigWigs"..name)
			if module.toggleoptions then
				cons = {
					type = "group",
					name = name,
					desc = L["Options for %s (r%d)."]:format(name, module.revision),
					pass = true,
					get = function(key)
						if key == "active" then
							return self:IsModuleActive(module)
						else
							return module.db.profile[key]
						end
					end,
					set = function(key, value)
						if key == "active" then
							self:ToggleModuleActive(module)
						else
							module.db.profile[key] = value

							-- Invoke any custom boss option function handlers.
							if customBossOptions[key] and type(customBossOptions[key][3]) == "function" then
								customBossOptions[key][3](module)
							end
						end
					end,
					args = {
						active = active,
						reboot = {
							type = "execute",
							name = L["Reboot"],
							order = 2,
							desc = L["Reboot this module."],
							func = "BigWigs_RebootModule",
							passValue = module,
							disabled = "~IsModuleActive",
						},
						headerSpacer = headerSpacer,
					},
				}
				local customBossOptionOrder = -100
				for i, v in ipairs(module.toggleoptions) do
					local x = i + 100
					if type(v) == "number" then
						cons.args[i] = {
							type = "header",
							order = x,
							name = " ",
						}
					elseif type(v) == "string" then
						local optName, optDesc, optOrder
						if customBossOptions[v] then
							optName = customBossOptions[v][1]
							optDesc = customBossOptions[v][2]
							optOrder = customBossOptionOrder
							customBossOptionOrder = customBossOptionOrder + 1
						else
							optName = ML:HasTranslation(v) and ML[v]
							local descKey = v.."_desc" -- String concatenation ftl! Not sure how we can get rid of this.
							optDesc = ML:HasTranslation(descKey) and ML[descKey] or v
							optOrder = x
						end
						if optName then
							cons.args[v] = {
								type = "toggle",
								order = optOrder,
								name = optName,
								desc = optDesc,
							}
							if optOrder > 0 and ML:HasTranslation(v.."_validate") then
								cons.args[v].type = "text"
								cons.args[v].validate = ML[v.."_validate"]
							end
						end
					end
				end
			end

			if cons then
				if module.external then
					options.args[L["Extras"]].args[ML["cmd"]] = cons
				else
					local zone = nil
					if module.otherMenu then
						zone = BZ[module.otherMenu]
					else
						zone = type(module.zonename) == "table" and module.zonename[1] or module.zonename
					end
					if not options.args[zone] then
						options.args[zone] = {
							type = "group",
							name = zone,
							desc = L["Options for bosses in %s."]:format(zone),
							args = {},
							disabled = "~IsActive",
						}
					end
					options.args[zone].args[ML["cmd"]] = cons
				end
			end
		elseif module.consoleOptions then
			if module.external then
				options.args[L["Extras"]].args[module.consoleCmd or name] = module.consoleOptions
			else
				options.args[L["Plugins"]].args[module.consoleCmd or name] = module.consoleOptions
			end
		end

		if type(module.OnRegister) == "function" then
			module:OnRegister()
		end

		self:TriggerEvent("BigWigs_ModuleRegistered", name)
	end
end

function BigWigs:EnableModule(moduleName, noSync)
	local m = self:GetModule(moduleName)
	if m and m:IsBossModule() and not self:IsModuleActive(m) then
		self:ToggleModuleActive(m, true)
		m:Message(L["%s mod enabled"]:format(moduleName or "??"), "Core", true)
		if not noSync then
			if not BB then BB = AceLibrary("Babble-Boss-2.2") end
			m:Sync((m.external and "EnableExternal " or "EnableModule ") .. (m.synctoken or BB:GetReverseTranslation(moduleName)))
		end
	end
end

function BigWigs:BigWigs_RebootModule(module)
	self:ToggleModuleActive(module, false)
	self:ToggleModuleActive(module, true)
end

function BigWigs:BigWigs_RecvSync(sync, module)
	if not module then return end
	if sync == "EnableModule" or sync == "EnableExternal" then
		if not BB then BB = AceLibrary("Babble-Boss-2.2") end
		local name = BB:HasTranslation(module) and BB[module] or module
		if self:HasModule(name) then
			self:EnableModule(name, true)
		end
	elseif sync == "BossDeath" and self:HasModule(module) then
		local mod = self:GetModule(module)
		if mod.db.profile.bosskill then
			mod:Message(L["%s has been defeated"]:format(module), "Bosskill", nil, "Victory")
		end
		mod:TriggerEvent("BigWigs_RemoveRaidIcon")
		if self:IsDebugging() then
			self:Debug(mod, "Boss dead, disabling.")
		end
		self:ToggleModuleActive(mod, false)
	end
end

do
	local function mobIsTrigger(module, name)
		local t = module.enabletrigger
		if type(t) == "string" then return name == t
		elseif type(t) == "table" then
			for i,mob in ipairs(t) do if mob == name then return true end end
		end
	end

	function BigWigs:BigWigs_TargetSeen(mobname, unit)
		for name, module in self:IterateModules() do
			if not self:IsModuleActive(module) and (name == mobname or (module:IsBossModule() and mobIsTrigger(module, mobname)
				and (not module.VerifyEnable or module:VerifyEnable(unit)))) then
				self:EnableModule(name)
			end
		end
	end
end

