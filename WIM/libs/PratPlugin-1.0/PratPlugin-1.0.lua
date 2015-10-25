--[[
Name: PratPlugin-1.0
Revision: $Rev: 50356 $
Author(s): Sylvanaar
Website: http://www.wowace.com/files/index.php?path=Prat/
Documentation: http://www.wowace.com/wiki/Prat/
SVN: http://svn.wowace.com/wowace/trunk/Prat/
Description: Library mixin for addons to support and use Prat
Dependencies: Prat, (implies AceLibrary, AceOO-2.0, AceEvent-2.0)
]]

local MAJOR_VERSION = "PratPlugin-1.0"
local MINOR_VERSION = "$Revision: 50356 $"

if not AceLibrary then error(MAJOR_VERSION .. " requires AceLibrary.") end
if not AceLibrary:IsNewVersion(MAJOR_VERSION, MINOR_VERSION) then return end
if not AceLibrary:HasInstance("AceOO-2.0") then error(MAJOR_VERSION .. " requires AceOO-2.0.") end

local AceEvent = AceLibrary:HasInstance("AceEvent-2.0") and AceLibrary("AceEvent-2.0")
local AceOO = AceLibrary("AceOO-2.0")

local PratPlugin = AceOO.Mixin {
    "RegisterPratModule",
    "GetPratModuleName",
    "GetPratModule",

    "RegisterMessageItem",   
    "UnregisterMessageItem",

    "RegisterExternalFrame",
    "GetExternalMessageTable",
    "FormatTextForFrame",
    "BuildExternalMessage",   
    
    "GetPratFormatProvider",
}
 


--[[ 
Prat.Events = Prat.Events or {
    MODULE_ENABLED = "Prat_ModuleEnabled",
    MODULE_DISABLED = "Prat_ModuleDisabled",
    DISABLED = "Prat_Disabled",
    ENABLING = "Prat_Starting",
    ENABLED = "Prat_Ready",   
    STARTUP = "Prat_Initialized",
    DEBUG_UPDATE = "Prat_DebugModeChanged",
    PRE_OUTBOUND = "Prat_PreOutboundChat",
    OUTBOUND = "Prat_OutboundChat",
    PRE_ADDMESSAGE = "Prat_PreAddMessage",
    POST_ADDMESSAGE = "Prat_PostAddMessage",
    FRAME_MESSAGE = "Prat_FrameMessage",
}  

self:TriggerEvent(Prat.Events.STARTUP)
self:TriggerEvent(Prat.Events.ENABLING)
self:TriggerEvent(Prat.Events.DISABLED)
self:TriggerEvent(Prat.Events.ENABLED)
self:TriggerEvent(Prat.Events.PRE_OUTBOUND, m)
self:TriggerEvent(Prat.Events.OUTBOUND, m)
self:TriggerEvent(Prat.Events.FRAME_MESSAGE, message, this)
self:TriggerEvent(Prat.Events.PRE_ADDMESSAGE, message, this, self:BuildChatText(message), r,g,b,id )
self:TriggerEvent(Prat.Events.POST_ADDMESSAGE,  m, this, m.OUTPUT, r,g,b,id)
self:TriggerEvent(Prat.Events.FRAME_MESSAGE, message, frame)
self:TriggerEvent(Prat.Events.PRE_ADDMESSAGE, message, frame, self:BuildChatText(message), r,g,b,id)
self:TriggerEvent(Prat.Events.POST_ADDMESSAGE,  message, frame, message.OUTPUT, r,g,b,id)
self:TriggerEvent(Prat.Events.FRAME_MESSAGE, message, frame)
self:TriggerEvent(Prat.Events.PRE_ADDMESSAGE, message, frame, self:BuildChatText(message), r,g,b,id)
self:TriggerEvent(Prat.Events.POST_ADDMESSAGE,  message, frame, message.OUTPUT, r,g,b,id)
self:TriggerEvent(Prat.Events.DEBUG_UPDATE)
self:TriggerEvent(Prat.Events.DEBUG_UPDATE)
self:TriggerEvent(Prat.Events.MODULE_ENABLED, module)
self:TriggerEvent(Prat.Events.MODULE_DISABLED, module)
--]]
 
--[[

Prat.Categories = {
    CHANNEL = L["Channel"],
    FRAME = L["Chatframe"],
    BUTTON = L["Buttons"],
    ACTION = L["Actions"],
    TEXT = L["Text"],
    NAME = L["Names"],
    LINK = L["Links"],
    FILTER = L["Filtering"],
    DEV = L["Developer"],
    INFO = L["Info"],
    BEHAVIOR = L["Behavior"],
    FORMATTING = L["Formatting"],
    COLORS = L["Colors"],
    SOUNDS = L["Sounds"],
}
--]]
    
local PRAT_MODULE = nil
local module = nil
local DEFAULT_DB = {
	on	= false, 
}

local EXTERNAL_MESSAGE = {}
local EXTERNAL_INFO = {r = 1.0, g = 1.0, b = 1.0, id = 0 }


local function AddHandlers(addon)
    local addon = addon
    function module:GetModuleOptions()
        if type(addon.OnPratGetModuleOptions) == "function" then
            return addon:OnPratGetModuleOptions()
        end
    
    	self.moduleOptions = {
    		name	= self.moduleName,
    		desc	= self.moduleDesc,
    		type	= "group",
    		args = {
    	    }
    	}
    	
    	return self.moduleOptions
    end
    
    function module:OnModuleEnable()
        if type(addon.OnPratModuleEnable) == "function" then
           addon:OnPratModuleEnable()
        end
    end
    
    function module:OnModuleDisable()
        if type(addon.OnPratModuleDisable) == "function" then
           addon:OnPratModuleEnable()
        end
    end
    
    function module:OnModuleInit()
        if type(addon.OnPratModuleInit) == "function" then
           addon:OnPratModuleInit()
        end
    end
    
end


function PratPlugin:RegisterPratModule(name, desc, console, gui, categories, 
                                    options, templates, defaults, revision) 
    
    DEFAULT_CHAT_FRAME:AddMessage("RegisterPratModule "..name)
    
    if IsAddOnLoaded("Prat") and  Prat then 
        PRAT_MODULE = Prat:RequestModuleName(name)  
        
        if PRAT_MODULE ~= nil then     
            module = Prat:NewModule(PRAT_MODULE)
            
            AddHandlers(self)
            
            -- set up the instance data
            module.moduleName = name
            module.moduleDesc = desc
            module.consoleName = console or string.lower(name)
            module.guiName = gui or name
            
            module.Categories = { Prat.Categories.EXTERNAL }
            if type(categories) == "table" then 
                for _,v in pairs(categories) do 
                    if v ~= Prat.Categories.EXTERNAL then 
                        table.insert(module.Categories, v)
                    end
                end
            end
            
            module.moduleOptions = options or {}
            module.toggleOptions = templates or {}
            module.defaultDB = defaults or DEFAULT_DB
            module.revision = revision or 0            
                        
            -- The horror!
            module:OnInitialize()
            module:OnEnable()
        end
    end
        
    return PRAT_MODULE
end
    
function PratPlugin:GetPratModuleName()
    return PRAT_MODULE
end

function PratPlugin:GetPratModule()
    return module
end



local FORMAT_PROVIDERS = { TIMESTAMPS = "PratTimestamps" }


function PratPlugin:GetPratFormatProvider(format_type, frame)
    if IsAddOnLoaded("Prat") and  Prat then 
        local m = Prat:GetModule(FORMAT_PROVIDERS[format_type])
        
        return m and (type(m.Provide) == "function") and m:Provide(frame)
    end
    
    return nil
end



function PratPlugin:RegisterExternalFrame(frame)
    if IsAddOnLoaded("Prat") and  Prat then 
        return Prat:RegisterExternalFrame(frame)
    end
    
    return nil
end



-- pass the frame so the correct options are used (ignored currently)
-- the message table should be in prats internal format
function PratPlugin:FormatTextForFrame(frame, message, event)
    if IsAddOnLoaded("Prat") and  Prat then 
        return Prat:PluginRenderAsChatString(frame, message, event)
    end
end

-- get a message object for use when calling FormatTextForFrame
function PratPlugin:GetExternalMessageTable()
    Prat:ClearChatSections(EXTERNAL_MESSAGE)
    
    EXTERNAL_MESSAGE.LANGUAGE_NOSHOW = "Common"
    EXTERNAL_MESSAGE.INFO = EXTERNAL_INFO

    EXTERNAL_MESSAGE.TYPEPREFIX = nil
    EXTERNAL_MESSAGE.TYPEPOSTFIX = nil
    
    return EXTERNAL_MESSAGE
end

local function safestr(s) return s or "" end

-- message is a table (from GetExternalMessageTable)
-- type is CHAT_MSG_(type), eg GUILD
function PratPlugin:BuildExternalMessage(message, msgtype, channelnum, channelname, player, server, msgid, text, r, g, b, output)
    message.INFO.r, message.INFO.g, message.INFO.b, message.INFO.id = r, g, b, 1
    
    message.CHATTYPE = msgtype
    
    if msgtype == "CHANNEL" then 
        message.cC = "["
        message.Cc = "] "
        if type(channelnum) == "number" then 
            message.CHANNELNUM = tostring(channelnum)
            message.CC = ". "
        end
        message.CHANNEL = channelname
    end  

    -- set the player
    if type(player) == "string" and strlen(player)>0 then
        local plr, svr = strsplit("-", player)
        message.pP = "["
        message.lL = "|Hplayer:"
        message.PLAYERLINK = player
        message.LL = "|h"
        message.PLAYER = plr
        
        if server and strlen(server) > 0 then 
            svr = server
            message.PLAYERLINK = plr.."-"..svr
        end
      
        if msgid then
            message.PLAYERLINKDATA = ":"..msgid
        end       
         
        if svr and strlen(svr) > 0 then
            message.sS = "-"
            message.SERVER = svr
        end        
        
        message.Ll = "|h"
        message.Pp = "]"
    end
            
    -- set the message text
    if type(text) == "string" then
        message.MESSAGE = text
    end

    if (message.TYPEPREFIX == nil or message.TYPEPOSTFIX == nil) and type(msgtype) == "string" then
       local chatget = getglobal("CHAT_"..msgtype.."_GET")
 
        if chatget then
            message.TYPEPREFIX, message.TYPEPOSTFIX = string.match(TEXT(chatget), "(.*)%%s(.*)")
            message.TYPEPOSTFIX = safestr(message.TYPEPOSTFIX)
            message.TYPEPREFIX = safestr(message.TYPEPREFIX)            
        end
    end
    
    if type(output) == "string" then
        message.OUTPUT = output
    end
    
    return message
end


function PratPlugin:RegisterMessageItem(itemname, aftervar)
    Prat:RegisterMessageItem(itemname, aftervar)
end

function PratPlugin:UnregisterMessageItem(itemname)
    Prat:UnregisterMessageItem(itemname)
end



local function activate(self, oldLib, oldDeactivate)
	PratPlugin = self

	PratPlugin.activate(self, oldLib, oldDeactivate)

	if oldDeactivate then
		oldDeactivate(oldLib)
	end
end

local function external(self, major, instance)
	if major == "AceEvent-2.0" then
		AceEvent = instance
		AceEvent:embed(self)
	end
end

AceLibrary:Register(PratPlugin, MAJOR_VERSION, MINOR_VERSION, activate, nil, external)
PratPlugin = nil