--[Adds Prat Compatibility to WIM]
--[written by Sylvanaar]

WIM_Prat_Plugin_Loaded = false;

function WIM_PratRenderText_Wrapper(frame, ttype, sender, msgid, text)
    if(Prat and WIM_Data.prat_compat and Prat:IsActive()) then
        local PP = PP or AceLibrary:HasInstance("PratPlugin-1.0") and AceLibrary("PratPlugin-1.0");
        if(PP) then
            local c, type
            if ttype == 1 then
                c =  WIM_Data.displayColors.wispIn
                type = "WHISPER"
            elseif ttype == 2 then 
                c =  WIM_Data.displayColors.wispOut
                type = "WHISPER_INFORM"
            end
            	
            if c and type then
                WIM_Prat_Plugin_Loaded = true;
                return WIM_PratRenderText(frame, type, nil, nil, sender, nil, msgid, text, c.r, c.g, c.b)
            else
                return "";
            end
        else
            return "";
        end
    else
        return "";
    end
end


function WIM_PratRenderText(frame, type, channel, channelName, sender, server, msgid, text, r, g, b)
    local PP = PP or AceLibrary:HasInstance("PratPlugin-1.0") and AceLibrary("PratPlugin-1.0")
    
    if not PP then return "" end
    
    local str = ""
    
    if not frame.pratFrame then 
        -- Register the frame with Prat
        frame.pratFrame = PP:RegisterExternalFrame(frame)
    end	   

    local m = PP:GetExternalMessageTable()
    
    if type and frame.pratFrame then
        local event = "CHAT_MSG_"..type
        m = PP:BuildExternalMessage(m, type, 
                    channel, channelName,
                    sender, server, msgid, 
                    text, 
                    r, g, b,
                    text)
                 
    	PP:FormatTextForFrame(frame.pratFrame, m, event)
	m.TYPEPREFIX, m.nN, m.CHANLINK, m.NN, m.Nn, m.TYPEPOSTFIX = "", "", "", "", "", ": "
        
	str = Prat:BuildChatText(m)
    end
    
    return str
end

function WIM_Prat_getTimeStamp(frame)
    -- there is no need for this. WIM has it's own time stamp formatting.
    return "";

    --local PP = PP or AceLibrary:HasInstance("PratPlugin-1.0") and AceLibrary("PratPlugin-1.0")
    --if not PP then return ""; end
    --if not WIM_Data.prat_compat then return ""; end
    
    --if not frame.pratFrame then 
        -- Register the frame with Prat
    --    frame.pratFrame = PP:RegisterExternalFrame(frame)
    --end	       
    
    --return PP:GetPratFormatProvider("TIMESTAMPS", frame.pratFrame) or ""	
end

