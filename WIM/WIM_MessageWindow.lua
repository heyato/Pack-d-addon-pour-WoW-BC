-- This file contains all message window creation, deletion, and recycling. 

local SelectedSkin;
local SelectedStyle = "default";

local ShortcutCount = 5;

local skinLoaded = false;

local SKIN_DEBUG = "";

local SkinTable = {};
local fontTable = {};

local LinkRepository = {}; -- used for emotes and link parsing.

local ofs = 0.000723339 * (GetScreenHeight()/GetScreenWidth() + 1/3) * 70.4;
local radius = ofs / 1.166666666666667;

local SML = LibStub:GetLibrary("LibSharedMedia-3.0"); -- used for font sharing

-- Window Soup Bowl Table: Used to keep track and recycle old windows.
local WindowSoupBowl = {
    windowToken = 0,
    available = 0,
    used = 0,
    windows = {
    }
}

--Create (recycle if available) message window. Returns object, frameName.
function WIM_CreateMessageWindow(userName)
    if(type(userName) ~= "string") then
        return;
    end
    if(type(SelectedSkin) ~= "table") then
        WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
    end
    local obj, index = WIM_GetAvailableMessageWindow();
    if(obj) then
        --object available...
        WindowSoupBowl.available = WindowSoupBowl.available - 1;
        WindowSoupBowl.used = WindowSoupBowl.used + 1;
        WindowSoupBowl.windows[index].inUse = true;
        WindowSoupBowl.windows[index].user = userName;
        obj.theUser = userName;
        obj.icon.theUser = userName;
        WIM_LoadMessageWindowDefaults(obj);
        return obj, WindowSoupBowl.windows[index].frameName;
    else
        -- must create new object
        WindowSoupBowl.used = WindowSoupBowl.used + 1;
        WindowSoupBowl.windowToken = WindowSoupBowl.windowToken + 1; --increment token for propper frame name creation.
        local fName = "WIM_msgFrame"..WindowSoupBowl.windowToken;
        local f = CreateFrame("Frame",fName, UIParent);
        local winTable = {
            user = userName,
            frameName = fName,
            inUse = true,
            obj = f
        };
        table.insert(WindowSoupBowl.windows, winTable);
        f.theUser = userName;
        f.isParent = true;
        WIM_InstantiateMessageWindowObj(f);
        f.icon.theUser = userName;
        WIM_LoadMessageWindowDefaults(f);
    
        return obj, winTable.frameName;
    end
end


--Deletes message window and makes it available in the Soup Bowl.
function WIM_DestroyMessageWindow(userName)
    local obj, index = WIM_GetMessageWindow(userName);
    if(obj) then
        WindowSoupBowl.windows[index].inUse = false;
        WindowSoupBowl.windows[index].user = "";
        WindowSoupBowl.available = WindowSoupBowl.available + 1;
        WindowSoupBowl.used = WindowSoupBowl.used - 1;
        WIM_Astrolabe:RemoveIconFromMinimap(obj.icon);
        obj.icon:Hide();
        obj.icon.track = false;
        obj.theUser = nil;
        obj:Show();
        local chatBox = getglobal(obj:GetName().."ScrollingMessageFrame");
        chatBox:Clear();
        obj:Hide();
    end
end


--Returns object, SoupBowl_windows_index or nil if window can not be found.
function WIM_GetMessageWindow(userName)
    if(type(userName) ~= "string") then
        return nil;
    end
    for i=1,table.getn(WindowSoupBowl.windows) do
        if(WindowSoupBowl.windows[i].user == userName) then
            return WindowSoupBowl.windows[i].obj, i;
        end
    end
end


--Returns object, SoupBowl_windows_index or nil of none are available.
function WIM_GetAvailableMessageWindow()
    if(WindowSoupBowl.available > 0) then
        for i=1,table.getn(WindowSoupBowl.windows) do
            if(WindowSoupBowl.windows[i].inUse == false) then
                return WindowSoupBowl.windows[i].obj, i;
            end
        end
    else
        return nil;
    end
end


-- create all of MessageWindow's object children
function WIM_InstantiateMessageWindowObj(obj)
    local fName = obj:GetName();
    -- set frame's initial properties
    obj:SetClampedToScreen(true);
    obj:SetFrameStrata("DIALOG");
    obj:SetMovable(true);
    obj:SetToplevel(true);
    obj:SetWidth(384);
    obj:SetHeight(256);
    obj:EnableMouse(true);
    obj:SetPoint("TOPLEFT", "UIParent", "TOPLEFT", 25, -125);
    obj:RegisterForDrag("LeftButton");
    obj:SetScript("OnDragStart", function() WIM_MessageWindow_MovementControler_OnDragStart(); end);
    obj:SetScript("OnDragStop", function() WIM_MessageWindow_MovementControler_OnDragStop(); end);
    obj:SetScript("OnEnter", WIM_MessageWindow_FadeControler_OnEnter);
    obj:SetScript("OnLeave", WIM_MessageWindow_FadeControler_OnLeave);
    obj:SetScript("OnShow", WIM_MessageWindow_Frame_OnShow);
    obj:SetScript("OnHide", WIM_MessageWindow_Frame_OnHide);
    obj:SetScript("OnUpdate", WIM_MessageWindow_Frame_OnUpdate);
    
    obj.icon = WIM_CreateMipmapDodad(fName);
    
    obj.w2w_menu = CreateFrame("Frame", fName.."W2WMenu", obj, "UIDropDownMenuTemplate");
    obj.w2w_menu:SetClampedToScreen(true);
    
    
    -- add window backdrop frame
    local Backdrop = CreateFrame("Frame", fName.."Backdrop", obj);
    Backdrop:SetToplevel(false);
    Backdrop:SetAllPoints(obj);
    local class_icon = Backdrop:CreateTexture(fName.."BackdropClassIcon", "BACKGROUND");
    local tl = Backdrop:CreateTexture(fName.."Backdrop_TL", "BORDER");
    local tr = Backdrop:CreateTexture(fName.."Backdrop_TR", "BORDER");
    local bl = Backdrop:CreateTexture(fName.."Backdrop_BL", "BORDER");
    local br = Backdrop:CreateTexture(fName.."Backdrop_BR", "BORDER");
    local t  = Backdrop:CreateTexture(fName.."Backdrop_T" , "BORDER");
    local b  = Backdrop:CreateTexture(fName.."Backdrop_B" , "BORDER");
    local l  = Backdrop:CreateTexture(fName.."Backdrop_L" , "BORDER");
    local r  = Backdrop:CreateTexture(fName.."Backdrop_R" , "BORDER");
    local bg = Backdrop:CreateTexture(fName.."Backdrop_BG", "BORDER");
    local from = Backdrop:CreateFontString(fName.."BackdropFrom", "OVERLAY", "GameFontNormalLarge");
    local char_info = Backdrop:CreateFontString(fName.."BackdropCharacterDetails", "OVERLAY", "GameFontNormal");
    
    -- create window objects
    local close = CreateFrame("Button", fName.."ExitButton", obj);
    close:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    close:SetScript("OnEnter", WIM_MessageWindow_ExitButton_OnEnter);
    close:SetScript("OnLeave", WIM_MessageWindow_ExitButton_OnLeave);
    close:SetScript("OnClick", WIM_MessageWindow_ExitButton_OnClick);
    local history = CreateFrame("Button", fName.."HistoryButton", obj);
    history:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    history:SetScript("OnEnter", WIM_MessageWindow_HistoryButton_OnEnter);
    history:SetScript("OnLeave", WIM_MessageWindow_HistoryButton_OnLeave);
    history:SetScript("OnClick", WIM_MessageWindow_HistoryButton_OnClick);
    local w2w = CreateFrame("Button", fName.."W2WButton", obj);
    w2w:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    w2w:SetScript("OnEnter", WIM_MessageWindow_W2WButton_OnEnter);
    w2w:SetScript("OnLeave", WIM_MessageWindow_W2WButton_OnLeave);
    w2w:SetScript("OnClick", WIM_MessageWindow_W2WButton_OnClick);
    local chatting = CreateFrame("Button", fName.."IsChattingButton", obj);
    chatting:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    chatting:SetScript("OnEnter", WIM_MessageWindow_IsChattingButton_OnEnter);
    chatting:SetScript("OnLeave", WIM_MessageWindow_IsChattingButton_OnLeave);
    chatting:SetScript("OnUpdate", WIM_MessageWindow_IsChattingButton_OnUpdate);
    chatting.time_elapsed = 0;
    chatting.typing_stamp = 0;
    local scroll_up = CreateFrame("Button", fName.."ScrollUp", obj);
    scroll_up:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    scroll_up:SetScript("OnEnter", WIM_MessageWindow_FadeControler_OnEnter);
    scroll_up:SetScript("OnLeave", WIM_MessageWindow_FadeControler_OnLeave);
    scroll_up:SetScript("OnClick", WIM_MessageWindow_ScrollUp_OnClick);
    local scroll_down = CreateFrame("Button", fName.."ScrollDown", obj);
    scroll_down:RegisterForClicks("LeftButtonUp", "RightButtonUp");
    scroll_down:SetScript("OnEnter", WIM_MessageWindow_FadeControler_OnEnter);
    scroll_down:SetScript("OnLeave", WIM_MessageWindow_FadeControler_OnLeave);
    scroll_down:SetScript("OnClick", WIM_MessageWindow_ScrollDown_OnClick);
    local chat_display = CreateFrame("ScrollingMessageFrame", fName.."ScrollingMessageFrame", obj);
    chat_display:RegisterForDrag("LeftButton");
    chat_display:SetFading(false);
    chat_display:SetMaxLines(128);
    chat_display:SetMovable(true);
    chat_display:SetScript("OnDragStart", function() WIM_MessageWindow_MovementControler_OnDragStart(); end);
    chat_display:SetScript("OnDragStop", function() WIM_MessageWindow_MovementControler_OnDragStop(); end);
    chat_display:SetScript("OnMouseWheel", WIM_MessageWindow_ScrollingMessageFrame_OnMouseWheel);
    chat_display:SetScript("OnHyperlinkClick", function() ChatFrame_OnHyperlinkShow(arg1, arg2, arg3); end);
    chat_display:SetScript("OnMessageScrollChanged", function() WIM_UpdateScrollBars(this); end);
    chat_display:SetScript("OnMouseDown", WIM_MessageWindow_ScrollingMessageFrame_OnMouseDown);
    chat_display:SetScript("OnMouseUp", WIM_MessageWindow_ScrollingMessageFrame_OnMouseUp);
    chat_display:SetScript("OnEnter", WIM_MessageWindow_FadeControler_OnEnter);
    chat_display:SetScript("OnLeave", WIM_MessageWindow_FadeControler_OnLeave);
    chat_display:SetScript("OnHyperlinkEnter", WIM_MessageWindow_Hyperlink_OnEnter);
    chat_display:SetScript("OnHyperlinkLeave", WIM_MessageWindow_Hyperlink_OnLeave);
    chat_display:SetJustifyH("LEFT");
    chat_display:EnableMouse(true);
    chat_display:EnableMouseWheel(1);
    local msg_box = CreateFrame("EditBox", fName.."MsgBox", obj);
    msg_box:SetAutoFocus(false);
    msg_box:SetHistoryLines(32);
    msg_box:SetMaxLetters(255);
    msg_box:SetAltArrowKeyMode(true);
    msg_box:EnableMouse(true);
    msg_box:SetScript("OnEnterPressed", WIM_MessageWindow_MsgBox_OnEnterPressed);
    msg_box:SetScript("OnEscapePressed", WIM_MessageWindow_MsgBox_OnEscapePressed);
    msg_box:SetScript("OnTabPressed", WIM_MessageWindow_MsgBox_OnTabPressed);
    msg_box:SetScript("OnEditFocusGained", function() WIM_EditBoxInFocus = this; end);
    msg_box:SetScript("OnEditFocusLost", function() WIM_EditBoxInFocus = nil; end);
    msg_box:SetScript("OnEnter", WIM_MessageWindow_FadeControler_OnEnter);
    msg_box:SetScript("OnLeave", WIM_MessageWindow_FadeControler_OnLeave);
    msg_box:SetScript("OnTextChanged", WIM_MessageWindow_MsgBox_OnTextChanged);
    msg_box:SetScript("OnUpdate", WIM_MessageWindow_MsgBox_OnUpdate);
    msg_box:SetScript("OnMouseUp", WIM_MessageWindow_MsgBox_OnMouseUp);
    
    
    local shortcuts = CreateFrame("Frame", fName.."ShortcutFrame", obj);
    shortcuts:SetToplevel(true);
    shortcuts:SetFrameStrata("DIALOG");
    for i=1,ShortcutCount do
        CreateFrame("Button", fName.."ShortcutFrameButton"..i, shortcuts, "WIM_ShortcutButtonTemplate");
    end

end


-- load selected skin
function WIM_LoadMessageWindowSkin(obj)
    local fName = obj:GetName();
    
    if(getglobal(WIM_Data.skin.font) == nil) then
        DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Selected skin object not found! Loading default font instead.");
        WIM_Data.skin.font = SkinTable["WIM Classic"].default_font;
    end
    
    local isSmartStyle = false;
    local prevStyle = SelectedStyle;
    if(type(SelectedSkin.smart_style) == "function" and SelectedStyle == "#SMART#") then
        isSmartStyle = true;
        local smartStyleFunction = SelectedSkin.smart_style;
        SelectedStyle = smartStyleFunction(obj.theUser, obj.theGuild, obj.theLevel, obj.theRace, obj.theClass);
    end
    
    --set backdrop edges and background textures.
    local tl = getglobal(fName.."Backdrop_TL");
    tl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tl:SetTexCoord(SelectedSkin.message_window.rect.top_left.texture_coord[1], SelectedSkin.message_window.rect.top_left.texture_coord[2],
                    SelectedSkin.message_window.rect.top_left.texture_coord[3], SelectedSkin.message_window.rect.top_left.texture_coord[4],
                    SelectedSkin.message_window.rect.top_left.texture_coord[5], SelectedSkin.message_window.rect.top_left.texture_coord[6],
                    SelectedSkin.message_window.rect.top_left.texture_coord[7], SelectedSkin.message_window.rect.top_left.texture_coord[8]);
    tl:ClearAllPoints();
    tl:SetPoint("TOPLEFT", fName.."Backdrop", "TOPLEFT", SelectedSkin.message_window.rect.top_left.offset.x, SelectedSkin.message_window.rect.top_left.offset.y);
    tl:SetWidth(SelectedSkin.message_window.rect.top_left.size.x);
    tl:SetHeight(SelectedSkin.message_window.rect.top_left.size.y);
    local tr = getglobal(fName.."Backdrop_TR");
    tr:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    tr:SetTexCoord(SelectedSkin.message_window.rect.top_right.texture_coord[1], SelectedSkin.message_window.rect.top_right.texture_coord[2],
                    SelectedSkin.message_window.rect.top_right.texture_coord[3], SelectedSkin.message_window.rect.top_right.texture_coord[4],
                    SelectedSkin.message_window.rect.top_right.texture_coord[5], SelectedSkin.message_window.rect.top_right.texture_coord[6],
                    SelectedSkin.message_window.rect.top_right.texture_coord[7], SelectedSkin.message_window.rect.top_right.texture_coord[8]);
    tr:ClearAllPoints();
    tr:SetPoint("TOPRIGHT", fName.."Backdrop", "TOPRIGHT", SelectedSkin.message_window.rect.top_right.offset.x, SelectedSkin.message_window.rect.top_right.offset.y);
    tr:SetWidth(SelectedSkin.message_window.rect.top_right.size.x);
    tr:SetHeight(SelectedSkin.message_window.rect.top_right.size.y);
    local bl = getglobal(fName.."Backdrop_BL");
    bl:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    bl:SetTexCoord(SelectedSkin.message_window.rect.bottom_left.texture_coord[1], SelectedSkin.message_window.rect.bottom_left.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[3], SelectedSkin.message_window.rect.bottom_left.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[5], SelectedSkin.message_window.rect.bottom_left.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom_left.texture_coord[7], SelectedSkin.message_window.rect.bottom_left.texture_coord[8]);
    bl:ClearAllPoints();
    bl:SetPoint("BOTTOMLEFT", fName.."Backdrop", "BOTTOMLEFT", SelectedSkin.message_window.rect.bottom_left.offset.x, SelectedSkin.message_window.rect.bottom_left.offset.y);
    bl:SetWidth(SelectedSkin.message_window.rect.bottom_left.size.x);
    bl:SetHeight(SelectedSkin.message_window.rect.bottom_left.size.y);
    local br = getglobal(fName.."Backdrop_BR");
    br:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    br:SetTexCoord(SelectedSkin.message_window.rect.bottom_right.texture_coord[1], SelectedSkin.message_window.rect.bottom_right.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[3], SelectedSkin.message_window.rect.bottom_right.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[5], SelectedSkin.message_window.rect.bottom_right.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom_right.texture_coord[7], SelectedSkin.message_window.rect.bottom_right.texture_coord[8]);
    br:ClearAllPoints();
    br:SetPoint("BOTTOMRIGHT", fName.."Backdrop", "BOTTOMRIGHT", SelectedSkin.message_window.rect.bottom_right.offset.x, SelectedSkin.message_window.rect.bottom_right.offset.y);
    br:SetWidth(SelectedSkin.message_window.rect.bottom_right.size.x);
    br:SetHeight(SelectedSkin.message_window.rect.bottom_right.size.y);
    local t = getglobal(fName.."Backdrop_T");
    t:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    t:SetTexCoord(SelectedSkin.message_window.rect.top.texture_coord[1], SelectedSkin.message_window.rect.top.texture_coord[2],
                    SelectedSkin.message_window.rect.top.texture_coord[3], SelectedSkin.message_window.rect.top.texture_coord[4],
                    SelectedSkin.message_window.rect.top.texture_coord[5], SelectedSkin.message_window.rect.top.texture_coord[6],
                    SelectedSkin.message_window.rect.top.texture_coord[7], SelectedSkin.message_window.rect.top.texture_coord[8]);
    t:ClearAllPoints();
    t:SetPoint("TOPLEFT", fName.."Backdrop_TL", "TOPRIGHT", 0, 0);
    t:SetPoint("BOTTOMRIGHT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    local b = getglobal(fName.."Backdrop_B");
    b:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    b:SetTexCoord(SelectedSkin.message_window.rect.bottom.texture_coord[1], SelectedSkin.message_window.rect.bottom.texture_coord[2],
                    SelectedSkin.message_window.rect.bottom.texture_coord[3], SelectedSkin.message_window.rect.bottom.texture_coord[4],
                    SelectedSkin.message_window.rect.bottom.texture_coord[5], SelectedSkin.message_window.rect.bottom.texture_coord[6],
                    SelectedSkin.message_window.rect.bottom.texture_coord[7], SelectedSkin.message_window.rect.bottom.texture_coord[8]);
    b:ClearAllPoints();
    b:SetPoint("TOPLEFT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    b:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "BOTTOMLEFT", 0, 0);
    local l = getglobal(fName.."Backdrop_L");
    l:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    l:SetTexCoord(SelectedSkin.message_window.rect.left.texture_coord[1], SelectedSkin.message_window.rect.left.texture_coord[2],
                    SelectedSkin.message_window.rect.left.texture_coord[3], SelectedSkin.message_window.rect.left.texture_coord[4],
                    SelectedSkin.message_window.rect.left.texture_coord[5], SelectedSkin.message_window.rect.left.texture_coord[6],
                    SelectedSkin.message_window.rect.left.texture_coord[7], SelectedSkin.message_window.rect.left.texture_coord[8]);
    l:ClearAllPoints();
    l:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMLEFT", 0, 0);
    l:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BL", "TOPRIGHT", 0, 0);
    local r = getglobal(fName.."Backdrop_R");
    r:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    r:SetTexCoord(SelectedSkin.message_window.rect.right.texture_coord[1], SelectedSkin.message_window.rect.right.texture_coord[2],
                    SelectedSkin.message_window.rect.right.texture_coord[3], SelectedSkin.message_window.rect.right.texture_coord[4],
                    SelectedSkin.message_window.rect.right.texture_coord[5], SelectedSkin.message_window.rect.right.texture_coord[6],
                    SelectedSkin.message_window.rect.right.texture_coord[7], SelectedSkin.message_window.rect.right.texture_coord[8]);
    r:ClearAllPoints();
    r:SetPoint("TOPLEFT", fName.."Backdrop_TR", "BOTTOMLEFT", 0, 0);
    r:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPRIGHT", 0, 0);
    local bg = getglobal(fName.."Backdrop_BG");
    bg:SetTexture(SelectedSkin.message_window.file[SelectedStyle]);
    bg:SetTexCoord(SelectedSkin.message_window.rect.background.texture_coord[1], SelectedSkin.message_window.rect.background.texture_coord[2],
                    SelectedSkin.message_window.rect.background.texture_coord[3], SelectedSkin.message_window.rect.background.texture_coord[4],
                    SelectedSkin.message_window.rect.background.texture_coord[5], SelectedSkin.message_window.rect.background.texture_coord[6],
                    SelectedSkin.message_window.rect.background.texture_coord[7], SelectedSkin.message_window.rect.background.texture_coord[8]);
    bg:ClearAllPoints();
    bg:SetPoint("TOPLEFT", fName.."Backdrop_TL", "BOTTOMRIGHT", 0, 0);
    bg:SetPoint("BOTTOMRIGHT", fName.."Backdrop_BR", "TOPLEFT", 0, 0);
    
    --set class icon
    local class_icon = getglobal(fName.."BackdropClassIcon");
    class_icon:SetTexture(SelectedSkin.message_window.class_icon.file[SelectedStyle]);
    class_icon:ClearAllPoints();
    class_icon:SetPoint(SelectedSkin.message_window.class_icon.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.class_icon.rect.anchor, SelectedSkin.message_window.class_icon.rect.offset.x, SelectedSkin.message_window.class_icon.rect.offset.y);
    class_icon:SetWidth(SelectedSkin.message_window.class_icon.rect.size.x);
    class_icon:SetHeight(SelectedSkin.message_window.class_icon.rect.size.y);
    WIM_UpdateMessageWindowClassIcon(obj);
    
    --set from font
    local from = getglobal(fName.."BackdropFrom");
    from:ClearAllPoints();
    from:SetPoint(SelectedSkin.message_window.strings.from.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.strings.from.rect.anchor, SelectedSkin.message_window.strings.from.rect.offset.x, SelectedSkin.message_window.strings.from.rect.offset.y);
    from:SetFontObject(getglobal(SelectedSkin.message_window.strings.from.inherits_font));
    
    --set character details font
    local char_info = getglobal(fName.."BackdropCharacterDetails");
    char_info:ClearAllPoints();
    char_info:SetPoint(SelectedSkin.message_window.strings.char_info.rect.anchor, fName.."Backdrop", SelectedSkin.message_window.strings.char_info.rect.anchor, SelectedSkin.message_window.strings.char_info.rect.offset.x, SelectedSkin.message_window.strings.char_info.rect.offset.y);
    char_info:SetFontObject(getglobal(SelectedSkin.message_window.strings.char_info.inherits_font));
    char_info:SetTextColor(SelectedSkin.message_window.strings.char_info.color[1], SelectedSkin.message_window.strings.char_info.color[2], SelectedSkin.message_window.strings.char_info.color[3]);
    WIM_MessageWindow_RefreshCharacterDetails(obj);

    --close button
    local close = getglobal(fName.."ExitButton");
    close:ClearAllPoints();
    close:SetPoint(SelectedSkin.message_window.buttons.close.rect.anchor, fName, SelectedSkin.message_window.buttons.close.rect.anchor, SelectedSkin.message_window.buttons.close.rect.offset.x, SelectedSkin.message_window.buttons.close.rect.offset.y);
    close:SetWidth(SelectedSkin.message_window.buttons.close.rect.size.x);
    close:SetHeight(SelectedSkin.message_window.buttons.close.rect.size.y);
    close:SetNormalTexture(SelectedSkin.message_window.buttons.close.NormalTexture[SelectedStyle]);
    close:SetPushedTexture(SelectedSkin.message_window.buttons.close.PushedTexture[SelectedStyle]);
    close:SetHighlightTexture(SelectedSkin.message_window.buttons.close.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.close.HighlightAlphaMode);
    
    --history button
    local history = getglobal(fName.."HistoryButton");
    history:ClearAllPoints();
    history:SetPoint(SelectedSkin.message_window.buttons.history.rect.anchor, fName, SelectedSkin.message_window.buttons.history.rect.anchor, SelectedSkin.message_window.buttons.history.rect.offset.x, SelectedSkin.message_window.buttons.history.rect.offset.y);
    history:SetWidth(SelectedSkin.message_window.buttons.history.rect.size.x);
    history:SetHeight(SelectedSkin.message_window.buttons.history.rect.size.y);
    history:SetNormalTexture(SelectedSkin.message_window.buttons.history.NormalTexture[SelectedStyle]);
    history:SetPushedTexture(SelectedSkin.message_window.buttons.history.PushedTexture[SelectedStyle]);
    history:SetHighlightTexture(SelectedSkin.message_window.buttons.history.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.history.HighlightAlphaMode);
    
    --w2w button
    local w2w = getglobal(fName.."W2WButton");
    w2w:ClearAllPoints();
    w2w:SetPoint(SelectedSkin.message_window.buttons.w2w.rect.anchor, fName, SelectedSkin.message_window.buttons.w2w.rect.anchor, SelectedSkin.message_window.buttons.w2w.rect.offset.x, SelectedSkin.message_window.buttons.w2w.rect.offset.y);
    w2w:SetWidth(SelectedSkin.message_window.buttons.w2w.rect.size.x);
    w2w:SetHeight(SelectedSkin.message_window.buttons.w2w.rect.size.y);
    w2w:SetNormalTexture(SelectedSkin.message_window.buttons.w2w.NormalTexture[SelectedStyle]);
    w2w:SetPushedTexture(SelectedSkin.message_window.buttons.w2w.PushedTexture[SelectedStyle]);
    w2w:SetHighlightTexture(SelectedSkin.message_window.buttons.w2w.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.w2w.HighlightAlphaMode);
    
    --chatting button
    local chatting = getglobal(fName.."IsChattingButton");
    chatting:ClearAllPoints();
    chatting:SetPoint(SelectedSkin.message_window.buttons.chatting.rect.anchor, fName, SelectedSkin.message_window.buttons.chatting.rect.anchor, SelectedSkin.message_window.buttons.chatting.rect.offset.x, SelectedSkin.message_window.buttons.chatting.rect.offset.y);
    chatting:SetWidth(SelectedSkin.message_window.buttons.chatting.rect.size.x);
    chatting:SetHeight(SelectedSkin.message_window.buttons.chatting.rect.size.y);
    chatting:SetNormalTexture(SelectedSkin.message_window.buttons.chatting.NormalTexture[SelectedStyle]);
    chatting:SetPushedTexture(SelectedSkin.message_window.buttons.chatting.PushedTexture[SelectedStyle]);
    
    --scroll_up button
    local scroll_up = getglobal(fName.."ScrollUp");
    scroll_up:ClearAllPoints();
    scroll_up:SetPoint(SelectedSkin.message_window.buttons.scroll_up.rect.anchor, fName, SelectedSkin.message_window.buttons.scroll_up.rect.anchor, SelectedSkin.message_window.buttons.scroll_up.rect.offset.x, SelectedSkin.message_window.buttons.scroll_up.rect.offset.y);
    scroll_up:SetWidth(SelectedSkin.message_window.buttons.scroll_up.rect.size.x);
    scroll_up:SetHeight(SelectedSkin.message_window.buttons.scroll_up.rect.size.y);
    scroll_up:SetNormalTexture(SelectedSkin.message_window.buttons.scroll_up.NormalTexture[SelectedStyle]);
    scroll_up:SetPushedTexture(SelectedSkin.message_window.buttons.scroll_up.PushedTexture[SelectedStyle]);
    scroll_up:SetDisabledTexture(SelectedSkin.message_window.buttons.scroll_up.DisabledTexture[SelectedStyle]);
    scroll_up:SetHighlightTexture(SelectedSkin.message_window.buttons.scroll_up.HighlightTexture[SelectedStyle], SelectedSkin.message_window.buttons.scroll_up.HighlightAlphaMode);
    
    --scroll_down button
    local scroll_down = getglobal(fName.."ScrollDown");
    scroll_down:ClearAllPoints();
    scroll_down:SetPoint(SelectedSkin.message_window.buttons.scroll_down.rect.anchor, fName, SelectedSkin.message_window.buttons.scroll_down.rect.anchor, SelectedSkin.message_window.buttons.scroll_down.rect.offset.x, SelectedSkin.message_window.buttons.scroll_down.rect.offset.y);
    scroll_down:SetWidth(SelectedSkin.message_window.buttons.scroll_down.rect.size.x);
    scroll_down:SetHeight(SelectedSkin.message_window.buttons.scroll_down.rect.size.y);
    scroll_down:SetNormalTexture(SelectedSkin.message_window.buttons.scroll_down.NormalTexture[SelectedStyle]);
    scroll_down:SetPushedTexture(SelectedSkin.message_window.buttons.scroll_down.PushedTexture[SelectedStyle]);
    scroll_down:SetDisabledTexture(SelectedSkin.message_window.buttons.scroll_down.DisabledTexture[SelectedStyle]);
    scroll_down:SetHighlightTexture(SelectedSkin.message_window.buttons.scroll_down.HighlightTexture[SelectedStyle],  SelectedSkin.message_window.buttons.scroll_down.HighlightAlphaMode);
    
    --chat display
    local chat_display = getglobal(fName.."ScrollingMessageFrame");
    chat_display:ClearAllPoints();
    chat_display:SetPoint("TOPLEFT", fName, "TOPLEFT", SelectedSkin.message_window.chat_display.rect.tl_offset.x, SelectedSkin.message_window.chat_display.rect.tl_offset.y);
    chat_display:SetPoint("BOTTOMRIGHT", fName, "BOTTOMRIGHT", SelectedSkin.message_window.chat_display.rect.br_offset.x, SelectedSkin.message_window.chat_display.rect.br_offset.y);
    local font, height, flags = getglobal(WIM_Data.skin.font):GetFont();
    chat_display:SetFont(font, WIM_Data.fontSize+2, WIM_Data.skin.font_outline);

    --msg_box
    local msg_box = getglobal(fName.."MsgBox");
    msg_box:ClearAllPoints();
    msg_box:SetPoint("TOPLEFT", fName, "BOTTOMLEFT", SelectedSkin.message_window.msg_box.rect.tl_offset.x, SelectedSkin.message_window.msg_box.rect.tl_offset.y);
    msg_box:SetPoint("BOTTOMRIGHT", fName, "BOTTOMRIGHT", SelectedSkin.message_window.msg_box.rect.br_offset.x, SelectedSkin.message_window.msg_box.rect.br_offset.y);
    local font, height, flags = getglobal(WIM_Data.skin.font):GetFont();
    msg_box:SetFont(font, SelectedSkin.message_window.msg_box.font_height, WIM_Data.skin.font_outline);
    msg_box:SetTextColor(SelectedSkin.message_window.msg_box.font_color[1], SelectedSkin.message_window.msg_box.font_color[2], SelectedSkin.message_window.msg_box.font_color[3]);
    
    --shorcuts
    local shortcuts = getglobal(fName.."ShortcutFrame");
    shortcuts:ClearAllPoints();
    shortcuts:SetPoint(SelectedSkin.message_window.shortcuts.rect.anchor, fName, SelectedSkin.message_window.shortcuts.rect.anchor, SelectedSkin.message_window.shortcuts.rect.offset.x, SelectedSkin.message_window.shortcuts.rect.offset.y);
    shortcuts:SetWidth(10);
    shortcuts:SetHeight(10);
    WIM_MessageWindow_ArrangeShortcutBar(shortcuts);
    
    WIM_SetWindowProps(obj);
    
    if(isSmartStyle) then
        SelectedStyle = prevStyle;
    end
end

function WIM_MessageWindow_ArrangeShortcutBar(ParentFrame)
    for i=1,ShortcutCount do
        local shortcut = getglobal(ParentFrame:GetName().."Button"..i);
        if(i == 1) then
            shortcut:SetPoint("TOPLEFT", ParentFrame:GetName(), "TOPLEFT", 0, 0);
        else
            if(SelectedSkin.message_window.shortcuts.verticle) then
                if(SelectedSkin.message_window.shortcuts.inverted) then
                    shortcut:SetPoint("BOTTOMLEFT", ParentFrame:GetName().."Button"..(i-1), "TOPLEFT", 0, 2);
                else
                    shortcut:SetPoint("TOPLEFT", ParentFrame:GetName().."Button"..(i-1), "BOTTOMLEFT", 0, -2);
                end
            else
                if(SelectedSkin.message_window.shortcuts.inverted) then
                    shortcut:SetPoint("TOPRIGHT", ParentFrame:GetName().."Button"..(i-1), "TOPLEFT", -2, 0);
                else
                    shortcut:SetPoint("TOPLEFT", ParentFrame:GetName().."Button"..(i-1), "TOPRIGHT", 2, 0);
                end
            end
        end
        shortcut:SetWidth(SelectedSkin.message_window.shortcuts.button_size);
        shortcut:SetHeight(SelectedSkin.message_window.shortcuts.button_size);
    end
    
end

-- load object into it's default state.
function WIM_LoadMessageWindowDefaults(obj)
    obj:Hide();

    obj.theGuild = "";
    obj.theLevel = "";
    obj.theRace = "";
    obj.theClass = "";
    
    obj.icon.track = false;

    local fName = obj:GetName();
    obj:SetScale(1);
    obj:SetAlpha(1);
    
    local backdrop = getglobal(fName.."Backdrop");
    backdrop:SetAlpha(1);
    
    local class_icon = getglobal(fName.."BackdropClassIcon");
    class_icon.class = "blank";
    
    local from = getglobal(fName.."BackdropFrom");
    from:SetText(obj.theUser);
    
    local char_info = getglobal(fName.."BackdropCharacterDetails");
    char_info:SetText("");
    
    local history = getglobal(fName.."HistoryButton");
    history:Hide();
    
    local w2w = getglobal(fName.."W2WButton");
    w2w:Hide();
    
    local chatting = getglobal(fName.."IsChattingButton");
    chatting:Hide();
    
    local msg_box = getglobal(fName.."MsgBox");
    msg_box.setText = 0;
    msg_box:SetText("");
    
    local scroll_up = CreateFrame("Button", fName.."ScrollUp", obj);
    scroll_up:Disable();
    
    local scroll_down = CreateFrame("Button", fName.."ScrollDown", obj);
    scroll_down:Disable();
    
    WIM_LoadMessageWindowSkin(obj);
end

function WIM_UpdateMessageWindowClassIcon(obj)
    local fName = obj:GetName();
    local class_icon = getglobal(fName.."BackdropClassIcon");
    local coord = SelectedSkin.message_window.class_icon[class_icon.class];
    class_icon:SetTexCoord(coord[1], coord[2], coord[3], coord[4], coord[5], coord[6], coord[7], coord[8]);
end

function WIM_SetMessageWindowClass(obj, class)
    local fName = obj:GetName();
    local class_icon = getglobal(fName.."BackdropClassIcon");
    
    local classes = {};
    classes[WIM_LOCALIZED_DRUID]    = "druid";
    classes[WIM_LOCALIZED_HUNTER]   = "hunter";
    classes[WIM_LOCALIZED_MAGE]	    = "mage";
    classes[WIM_LOCALIZED_PALADIN]  = "paladin";
    classes[WIM_LOCALIZED_PRIEST]   = "priest";
    classes[WIM_LOCALIZED_ROGUE]    = "rogue";
    classes[WIM_LOCALIZED_SHAMAN]   = "shaman";
    classes[WIM_LOCALIZED_WARLOCK]  = "warlock";
    classes[WIM_LOCALIZED_WARRIOR]  = "warrior";
    
    classes[WIM_LOCALIZED_DRUID_FEMALE]    = classes[WIM_LOCALIZED_DRUID];
    classes[WIM_LOCALIZED_HUNTER_FEMALE]   = classes[WIM_LOCALIZED_HUNTER];
    classes[WIM_LOCALIZED_MAGE_FEMALE]	   = classes[WIM_LOCALIZED_MAGE];
    classes[WIM_LOCALIZED_PALADIN_FEMALE]  = classes[WIM_LOCALIZED_PALADIN];
    classes[WIM_LOCALIZED_PRIEST_FEMALE]   = classes[WIM_LOCALIZED_PRIEST];
    classes[WIM_LOCALIZED_ROGUE_FEMALE]    = classes[WIM_LOCALIZED_ROGUE];
    classes[WIM_LOCALIZED_SHAMAN_FEMALE]   = classes[WIM_LOCALIZED_SHAMAN];
    classes[WIM_LOCALIZED_WARLOCK_FEMALE]  = classes[WIM_LOCALIZED_WARLOCK];
    classes[WIM_LOCALIZED_WARRIOR_FEMALE]  = classes[WIM_LOCALIZED_WARRIOR];
    
    classes[WIM_LOCALIZED_GM] 	    = "gm";
    
    if(classes[class]) then
        class_icon.class = classes[class];
    else
        class_icon.class = "blank";
    end
    WIM_UpdateMessageWindowClassIcon(obj);
end

function WIM_SetMessageWindowCharacterDetails(obj, guild, level, race, class)
    obj.theGuild = guild;
    obj.theLevel = level;
    obj.theRace = race;
    obj.theClass = class;
    WIM_MessageWindow_RefreshCharacterDetails(obj);
end

function WIM_MessageWindow_RefreshCharacterDetails(obj)
    local fName = obj:GetName();
    local char_info = getglobal(fName.."BackdropCharacterDetails");
    local formatDetails = SelectedSkin.message_window.strings.char_info.format;
    char_info:SetText(formatDetails(obj.theGuild, obj.theLevel, obj.theRace, obj.theClass));
end

function WIM_SetMessageWindow_SmartStyle(obj, name, guild, level, race, class)
    obj.theGuild = guild;
    obj.theLevel = level;
    obj.theRace = race;
    obj.theClass = class;
    if(type(SelectedSkin.smart_style) == "function" and SelectedStyle == "#SMART#") then
        WIM_LoadMessageWindowSkin(obj);
    end
end

function WIM_GetParentMessageWindow(obj)
    if(obj.isParent) then
        return obj;
    elseif(obj:GetName() == "UIParent") then
        return nil;
    else
        return WIM_GetParentMessageWindow(obj:GetParent())
    end
end

----------------------------------------------------------
--          MessageWindow Controling Functions          --
----------------------------------------------------------

function WIM_MessageWindow_Hyperlink_OnEnter(f, link)
    WIM_MessageWindow_FadeControler_OnEnter();
    if(WIM_Data.hover_links) then
        local t = strmatch(link, "^(.-):")
	if(t == "item" or t == "enchant" or t == "spell" or t == "quest") then
		ShowUIPanel(GameTooltip)
		GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end
    end
end

function WIM_MessageWindow_Hyperlink_OnLeave(f, link)
    WIM_MessageWindow_FadeControler_OnLeave();
    if(WIM_Data.hover_links) then
        local t = strmatch(link, "^(.-):")
	if(t == "item" or t == "enchant" or t == "spell" or t == "quest") then
		HideUIPanel(GameTooltip)
	end
    end
end

function WIM_MessageWindow_FadeControler_OnEnter()
    local window = WIM_GetParentMessageWindow(this);
    if(window) then
        if(WIM_Data.windowFade) then
            WIM_FadeIn(window.theUser);
        end
        window.isMouseOver = true;
        window.QueuedToHide = false;
    end
end

function WIM_MessageWindow_FadeControler_OnLeave()
    local window = WIM_GetParentMessageWindow(this);
    if(window) then
        if(WIM_Data.windowFade) then
            if(getglobal(window:GetName().."MsgBox") ~= WIM_EditBoxInFocus) then
                WIM_FadeOut(window.theUser);
            else
                window.QueuedToHide = true;
            end
        end
        window.isMouseOver = false;
    end
end

function WIM_MessageWindow_MovementControler_OnDragStart()
    local window = WIM_GetParentMessageWindow(this);
    if(window) then
        window:StartMoving();
        window.isMoving = true;
    end
end

function WIM_MessageWindow_MovementControler_OnDragStop()
    local window = WIM_GetParentMessageWindow(this);
    if(window) then
        window:StopMovingOrSizing();
        window.isMoving = false;
    end
end

function WIM_RegisterFont(objName, title)
    if(objName == nil or objName == "") then
        return;
    end
    if(title == nil or title == "") then
        title = objName
    end
    if(getglobal(objName)) then
        fontTable[objName] = title;
    else
        DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Registered font object does not exist!");
    end
end

function WIM_RegisterSkin(skinTable)
    local required = {"title", "author", "version"};
    local error_list = "";
    local addonName;
    local styles = {};
    
    local stack = {string.split("\n", debugstack())};
    if(table.getn(stack) >= 2) then
        local paths = {string.split("\\", stack[2])};
        addonName = paths[3];
    else
        addonName = "Unknown";
    end
    
    for i=1,table.getn(required) do
        if(skinTable[required[i]] == nil or skinTable[required[i]] == "") then error_list = error_list.."- Required field '"..required[i].."' was not defined.\n"; end
    end

    if(skinTable.styles == nil) then
        error_list = error_list.."- Skin must have at least one style defined!\n";
    else
        local style, title;
        for style,title in pairs(skinTable.styles) do
            if(style and title and title ~= "") then
                if(not skinTable.default_style) then skinTable.default_style = style; end
                table.insert(styles, style);
            end
        end
        if(table.getn(styles) == 0) then error_list = error_list.."- Skin must have at least one style defined!\n"; end
    end
    
    if(not skinTable.default_font) then skinTable.default_font = SkinTable["WIM Classic"].default_font; end
    
    if(error_list ~= "") then
        SKIN_DEBUG = SKIN_DEBUG.."\n\n---------------------------------------------------------\nSKIN ERROR FROM: "..addonName.."\n---------------------------------------------------------\n";
        SKIN_DEBUG = SKIN_DEBUG.."Skin was not loaded for the following reason(s):\n\n"..error_list.."\n\n";
        return;
    end
    
    if(skinTable.title == "WIM Classic") then
        SkinTable[skinTable.title] = skinTable;
        if(skinTable.title == WIM_Data.skin.selected) then
            WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
        end
        return;
    end
    
    -- now we make sure any empty data is inherrited correctly from the default "WIM Classic" skin...
    if(not skinTable.message_window) then skinTable.message_window = {}; end
    if(not skinTable.message_window.file) then skinTable.message_window.file = {}; end
    if(not skinTable.message_window.rect) then skinTable.message_window.rect = {}; end
        if(not skinTable.message_window.rect.top_left) then skinTable.message_window.rect.top_left = {}; end
            if(not skinTable.message_window.rect.top_left.size) then skinTable.message_window.rect.top_left.size = {}; end
                if(not skinTable.message_window.rect.top_left.size.x) then skinTable.message_window.rect.top_left.size.x = SkinTable["WIM Classic"].message_window.rect.top_left.size.x; end
                if(not skinTable.message_window.rect.top_left.size.y) then skinTable.message_window.rect.top_left.size.y = SkinTable["WIM Classic"].message_window.rect.top_left.size.y; end
            if(not skinTable.message_window.rect.top_left.offset) then skinTable.message_window.rect.top_left.offset = {}; end
                if(not skinTable.message_window.rect.top_left.offset.x) then skinTable.message_window.rect.top_left.offset.x = SkinTable["WIM Classic"].message_window.rect.top_left.offset.x; end
                if(not skinTable.message_window.rect.top_left.offset.y) then skinTable.message_window.rect.top_left.offset.y = SkinTable["WIM Classic"].message_window.rect.top_left.offset.y; end
            if(not skinTable.message_window.rect.top_left.texture_coord) then skinTable.message_window.rect.top_left.texture_coord = SkinTable["WIM Classic"].message_window.rect.top_left.texture_coord; end
        if(not skinTable.message_window.rect.top_right) then skinTable.message_window.rect.top_right = {}; end
            if(not skinTable.message_window.rect.top_right.size) then skinTable.message_window.rect.top_right.size = {}; end
                if(not skinTable.message_window.rect.top_right.size.x) then skinTable.message_window.rect.top_right.size.x = SkinTable["WIM Classic"].message_window.rect.top_right.size.x; end
                if(not skinTable.message_window.rect.top_right.size.y) then skinTable.message_window.rect.top_right.size.y = SkinTable["WIM Classic"].message_window.rect.top_right.size.y; end
            if(not skinTable.message_window.rect.top_right.offset) then skinTable.message_window.rect.top_right.offset = {}; end
                if(not skinTable.message_window.rect.top_right.offset.x) then skinTable.message_window.rect.top_right.offset.x = SkinTable["WIM Classic"].message_window.rect.top_right.offset.x; end
                if(not skinTable.message_window.rect.top_right.offset.y) then skinTable.message_window.rect.top_right.offset.y = SkinTable["WIM Classic"].message_window.rect.top_right.offset.y; end
            if(not skinTable.message_window.rect.top_right.texture_coord) then skinTable.message_window.rect.top_right.texture_coord = SkinTable["WIM Classic"].message_window.rect.top_right.texture_coord; end
        if(not skinTable.message_window.rect.bottom_left) then skinTable.message_window.rect.bottom_left = {}; end
            if(not skinTable.message_window.rect.bottom_left.size) then skinTable.message_window.rect.bottom_left.size = {}; end
                if(not skinTable.message_window.rect.bottom_left.size.x) then skinTable.message_window.rect.bottom_left.size.x = SkinTable["WIM Classic"].message_window.rect.bottom_left.size.x; end
                if(not skinTable.message_window.rect.bottom_left.size.y) then skinTable.message_window.rect.bottom_left.size.y = SkinTable["WIM Classic"].message_window.rect.bottom_left.size.y; end
            if(not skinTable.message_window.rect.bottom_left.offset) then skinTable.message_window.rect.bottom_left.offset = {}; end
                if(not skinTable.message_window.rect.bottom_left.offset.x) then skinTable.message_window.rect.bottom_left.offset.x = SkinTable["WIM Classic"].message_window.rect.bottom_left.offset.x; end
                if(not skinTable.message_window.rect.bottom_left.offset.y) then skinTable.message_window.rect.bottom_left.offset.y = SkinTable["WIM Classic"].message_window.rect.bottom_left.offset.y; end
            if(not skinTable.message_window.rect.bottom_left.texture_coord) then skinTable.message_window.rect.bottom_left.texture_coord = SkinTable["WIM Classic"].message_window.rect.bottom_left.texture_coord; end
        if(not skinTable.message_window.rect.bottom_right) then skinTable.message_window.rect.bottom_right = {}; end
            if(not skinTable.message_window.rect.bottom_right.size) then skinTable.message_window.rect.bottom_right.size = {}; end
                if(not skinTable.message_window.rect.bottom_right.size.x) then skinTable.message_window.rect.bottom_right.size.x = SkinTable["WIM Classic"].message_window.rect.bottom_right.size.x; end
                if(not skinTable.message_window.rect.bottom_right.size.y) then skinTable.message_window.rect.bottom_right.size.y = SkinTable["WIM Classic"].message_window.rect.bottom_right.size.y; end
            if(not skinTable.message_window.rect.bottom_right.offset) then skinTable.message_window.rect.bottom_right.offset = {}; end
                if(not skinTable.message_window.rect.bottom_right.offset.x) then skinTable.message_window.rect.bottom_right.offset.x = SkinTable["WIM Classic"].message_window.rect.bottom_right.offset.x; end
                if(not skinTable.message_window.rect.bottom_right.offset.y) then skinTable.message_window.rect.bottom_right.offset.y = SkinTable["WIM Classic"].message_window.rect.bottom_right.offset.y; end
            if(not skinTable.message_window.rect.bottom_right.texture_coord) then skinTable.message_window.rect.bottom_right.texture_coord = SkinTable["WIM Classic"].message_window.rect.bottom_right.texture_coord; end
        if(not skinTable.message_window.rect.top) then skinTable.message_window.rect.top = {}; end
            if(not skinTable.message_window.rect.top.texture_coord) then skinTable.message_window.rect.top.texture_coord = SkinTable["WIM Classic"].message_window.rect.top.texture_coord; end
        if(not skinTable.message_window.rect.bottom) then skinTable.message_window.rect.bottom = {}; end
            if(not skinTable.message_window.rect.bottom.texture_coord) then skinTable.message_window.rect.bottom.texture_coord = SkinTable["WIM Classic"].message_window.rect.bottom.texture_coord; end
        if(not skinTable.message_window.rect.left) then skinTable.message_window.rect.left = {}; end
            if(not skinTable.message_window.rect.left.texture_coord) then skinTable.message_window.rect.left.texture_coord = SkinTable["WIM Classic"].message_window.rect.left.texture_coord; end
        if(not skinTable.message_window.rect.right) then skinTable.message_window.rect.right = {}; end
            if(not skinTable.message_window.rect.right.texture_coord) then skinTable.message_window.rect.right.texture_coord = SkinTable["WIM Classic"].message_window.rect.right.texture_coord; end
        if(not skinTable.message_window.rect.background) then skinTable.message_window.rect.background = {}; end
            if(not skinTable.message_window.rect.background.texture_coord) then skinTable.message_window.rect.background.texture_coord = SkinTable["WIM Classic"].message_window.rect.background.texture_coord; end
    if(not skinTable.message_window.class_icon) then skinTable.message_window.class_icon = {}; end
        if(not skinTable.message_window.class_icon.file) then skinTable.message_window.class_icon.file = {}; end
        if(not skinTable.message_window.class_icon.rect) then skinTable.message_window.class_icon.rect = {}; end
            if(not skinTable.message_window.class_icon.rect.size) then skinTable.message_window.class_icon.rect.size = {}; end
                if(not skinTable.message_window.class_icon.rect.size.x) then skinTable.message_window.class_icon.rect.size.x = SkinTable["WIM Classic"].message_window.class_icon.rect.size.x; end
                if(not skinTable.message_window.class_icon.rect.size.y) then skinTable.message_window.class_icon.rect.size.y = SkinTable["WIM Classic"].message_window.class_icon.rect.size.y; end
            if(not skinTable.message_window.class_icon.rect.offset) then skinTable.message_window.class_icon.rect.offset = {}; end
                if(not skinTable.message_window.class_icon.rect.offset.x) then skinTable.message_window.class_icon.rect.offset.x = SkinTable["WIM Classic"].message_window.class_icon.rect.offset.x; end
                if(not skinTable.message_window.class_icon.rect.offset.y) then skinTable.message_window.class_icon.rect.offset.y = SkinTable["WIM Classic"].message_window.class_icon.rect.offset.y; end
            if(not skinTable.message_window.class_icon.rect.anchor) then skinTable.message_window.class_icon.rect.anchor = SkinTable["WIM Classic"].message_window.class_icon.rect.anchor; end
        if(not skinTable.message_window.class_icon.blank) then skinTable.message_window.class_icon.blank = SkinTable["WIM Classic"].message_window.class_icon.blank; end
        if(not skinTable.message_window.class_icon.druid) then skinTable.message_window.class_icon.druid = SkinTable["WIM Classic"].message_window.class_icon.druid; end
        if(not skinTable.message_window.class_icon.hunter) then skinTable.message_window.class_icon.hunter = SkinTable["WIM Classic"].message_window.class_icon.hunter; end
        if(not skinTable.message_window.class_icon.mage) then skinTable.message_window.class_icon.mage = SkinTable["WIM Classic"].message_window.class_icon.mage; end
        if(not skinTable.message_window.class_icon.paladin) then skinTable.message_window.class_icon.paladin = SkinTable["WIM Classic"].message_window.class_icon.paladin; end
        if(not skinTable.message_window.class_icon.priest) then skinTable.message_window.class_icon.priest = SkinTable["WIM Classic"].message_window.class_icon.priest; end
        if(not skinTable.message_window.class_icon.rogue) then skinTable.message_window.class_icon.rogue = SkinTable["WIM Classic"].message_window.class_icon.rogue; end
        if(not skinTable.message_window.class_icon.shaman) then skinTable.message_window.class_icon.shaman = SkinTable["WIM Classic"].message_window.class_icon.shaman; end
        if(not skinTable.message_window.class_icon.warlock) then skinTable.message_window.class_icon.warlock = SkinTable["WIM Classic"].message_window.class_icon.warlock; end
        if(not skinTable.message_window.class_icon.warrior) then skinTable.message_window.class_icon.warrior = SkinTable["WIM Classic"].message_window.class_icon.warrior; end
        if(not skinTable.message_window.class_icon.gm) then skinTable.message_window.class_icon.gm = SkinTable["WIM Classic"].message_window.class_icon.gm; end
    if(not skinTable.message_window.strings) then skinTable.message_window.strings = {}; end
        if(not skinTable.message_window.strings.from) then skinTable.message_window.strings.from = {}; end
            if(not skinTable.message_window.strings.from.rect) then skinTable.message_window.strings.from.rect = {}; end
                if(not skinTable.message_window.strings.from.rect.offset) then skinTable.message_window.strings.from.rect.offset = {}; end
                    if(not skinTable.message_window.strings.from.rect.offset.x) then skinTable.message_window.strings.from.rect.offset.x = SkinTable["WIM Classic"].message_window.strings.from.rect.offset.x; end
                    if(not skinTable.message_window.strings.from.rect.offset.y) then skinTable.message_window.strings.from.rect.offset.y = SkinTable["WIM Classic"].message_window.strings.from.rect.offset.y; end
                if(not skinTable.message_window.strings.from.rect.anchor) then skinTable.message_window.strings.from.rect.anchor = SkinTable["WIM Classic"].message_window.strings.from.rect.anchor; end
        if(not skinTable.message_window.strings.char_info) then skinTable.message_window.strings.char_info = {}; end
            if(not skinTable.message_window.strings.char_info.format) then skinTable.message_window.strings.char_info.format = SkinTable["WIM Classic"].message_window.strings.char_info.format; end
            if(not skinTable.message_window.strings.char_info.rect) then skinTable.message_window.strings.char_info.rect = {}; end
                if(not skinTable.message_window.strings.char_info.rect.offset) then skinTable.message_window.strings.char_info.rect.offset = {}; end
                    if(not skinTable.message_window.strings.char_info.rect.offset.x) then skinTable.message_window.strings.char_info.rect.offset.x = SkinTable["WIM Classic"].message_window.strings.char_info.rect.offset.x; end
                    if(not skinTable.message_window.strings.char_info.rect.offset.y) then skinTable.message_window.strings.char_info.rect.offset.y = SkinTable["WIM Classic"].message_window.strings.char_info.rect.offset.y; end
                if(not skinTable.message_window.strings.char_info.rect.anchor) then skinTable.message_window.strings.char_info.rect.anchor = SkinTable["WIM Classic"].message_window.strings.char_info.rect.anchor; end
            if(not skinTable.message_window.strings.char_info.color) then skinTable.message_window.strings.char_info.color = SkinTable["WIM Classic"].message_window.strings.char_info.color; end
    if(not skinTable.message_window.buttons) then skinTable.message_window.buttons = {}; end
        if(not skinTable.message_window.buttons.close) then skinTable.message_window.buttons.close = {}; end
            if(not skinTable.message_window.buttons.close.NormalTexture) then skinTable.message_window.buttons.close.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.close.PushedTexture) then skinTable.message_window.buttons.close.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.close.HighlightTexture) then skinTable.message_window.buttons.close.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.close.HighlightAlphaMode) then skinTable.message_window.buttons.close.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.close.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.close.rect) then skinTable.message_window.buttons.close.rect = {}; end
                if(not skinTable.message_window.buttons.close.rect.offset) then skinTable.message_window.buttons.close.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.close.rect.offset.x) then skinTable.message_window.buttons.close.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.close.rect.offset.x; end
                    if(not skinTable.message_window.buttons.close.rect.offset.y) then skinTable.message_window.buttons.close.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.close.rect.offset.y; end
                if(not skinTable.message_window.buttons.close.rect.size) then skinTable.message_window.buttons.close.rect.size = {}; end
                    if(not skinTable.message_window.buttons.close.rect.size.x) then skinTable.message_window.buttons.close.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.close.rect.size.x; end
                    if(not skinTable.message_window.buttons.close.rect.size.y) then skinTable.message_window.buttons.close.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.close.rect.size.y; end
                if(not skinTable.message_window.buttons.close.rect.anchor) then skinTable.message_window.buttons.close.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.close.rect.anchor; end
        if(not skinTable.message_window.buttons.history) then skinTable.message_window.buttons.history = {}; end
            if(not skinTable.message_window.buttons.history.NormalTexture) then skinTable.message_window.buttons.history.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.history.PushedTexture) then skinTable.message_window.buttons.history.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.history.HighlightTexture) then skinTable.message_window.buttons.history.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.history.HighlightAlphaMode) then skinTable.message_window.buttons.history.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.history.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.history.rect) then skinTable.message_window.buttons.history.rect = {}; end
                if(not skinTable.message_window.buttons.history.rect.offset) then skinTable.message_window.buttons.history.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.history.rect.offset.x) then skinTable.message_window.buttons.history.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.history.rect.offset.x; end
                    if(not skinTable.message_window.buttons.history.rect.offset.y) then skinTable.message_window.buttons.history.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.history.rect.offset.y; end
                if(not skinTable.message_window.buttons.history.rect.size) then skinTable.message_window.buttons.history.rect.size = {}; end
                    if(not skinTable.message_window.buttons.history.rect.size.x) then skinTable.message_window.buttons.history.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.history.rect.size.x; end
                    if(not skinTable.message_window.buttons.history.rect.size.y) then skinTable.message_window.buttons.history.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.history.rect.size.y; end
                if(not skinTable.message_window.buttons.history.rect.anchor) then skinTable.message_window.buttons.history.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.history.rect.anchor; end
        if(not skinTable.message_window.buttons.w2w) then skinTable.message_window.buttons.w2w = {}; end
            if(not skinTable.message_window.buttons.w2w.NormalTexture) then skinTable.message_window.buttons.w2w.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.w2w.PushedTexture) then skinTable.message_window.buttons.w2w.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.w2w.HighlightTexture) then skinTable.message_window.buttons.w2w.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.w2w.HighlightAlphaMode) then skinTable.message_window.buttons.w2w.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.w2w.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.w2w.rect) then skinTable.message_window.buttons.w2w.rect = {}; end
                if(not skinTable.message_window.buttons.w2w.rect.offset) then skinTable.message_window.buttons.w2w.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.w2w.rect.offset.x) then skinTable.message_window.buttons.w2w.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.w2w.rect.offset.x; end
                    if(not skinTable.message_window.buttons.w2w.rect.offset.y) then skinTable.message_window.buttons.w2w.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.w2w.rect.offset.y; end
                if(not skinTable.message_window.buttons.w2w.rect.size) then skinTable.message_window.buttons.w2w.rect.size = {}; end
                    if(not skinTable.message_window.buttons.w2w.rect.size.x) then skinTable.message_window.buttons.w2w.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.w2w.rect.size.x; end
                    if(not skinTable.message_window.buttons.w2w.rect.size.y) then skinTable.message_window.buttons.w2w.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.w2w.rect.size.y; end
                if(not skinTable.message_window.buttons.w2w.rect.anchor) then skinTable.message_window.buttons.w2w.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.w2w.rect.anchor; end
        if(not skinTable.message_window.buttons.chatting) then skinTable.message_window.buttons.chatting = {}; end
            if(not skinTable.message_window.buttons.chatting.NormalTexture) then skinTable.message_window.buttons.chatting.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.chatting.PushedTexture) then skinTable.message_window.buttons.chatting.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.chatting.HighlightTexture) then skinTable.message_window.buttons.chatting.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.chatting.HighlightAlphaMode) then skinTable.message_window.buttons.chatting.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.chatting.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.chatting.rect) then skinTable.message_window.buttons.chatting.rect = {}; end
                if(not skinTable.message_window.buttons.chatting.rect.offset) then skinTable.message_window.buttons.chatting.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.chatting.rect.offset.x) then skinTable.message_window.buttons.chatting.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.chatting.rect.offset.x; end
                    if(not skinTable.message_window.buttons.chatting.rect.offset.y) then skinTable.message_window.buttons.chatting.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.chatting.rect.offset.y; end
                if(not skinTable.message_window.buttons.chatting.rect.size) then skinTable.message_window.buttons.chatting.rect.size = {}; end
                    if(not skinTable.message_window.buttons.chatting.rect.size.x) then skinTable.message_window.buttons.chatting.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.chatting.rect.size.x; end
                    if(not skinTable.message_window.buttons.chatting.rect.size.y) then skinTable.message_window.buttons.chatting.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.chatting.rect.size.y; end
                if(not skinTable.message_window.buttons.chatting.rect.anchor) then skinTable.message_window.buttons.chatting.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.chatting.rect.anchor; end
        if(not skinTable.message_window.buttons.scroll_up) then skinTable.message_window.buttons.scroll_up = {}; end
            if(not skinTable.message_window.buttons.scroll_up.NormalTexture) then skinTable.message_window.buttons.scroll_up.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_up.PushedTexture) then skinTable.message_window.buttons.scroll_up.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_up.HighlightTexture) then skinTable.message_window.buttons.scroll_up.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_up.HighlightAlphaMode) then skinTable.message_window.buttons.scroll_up.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.scroll_up.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.scroll_up.DisabledTexture) then skinTable.message_window.buttons.scroll_up.DisabledTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_up.rect) then skinTable.message_window.buttons.scroll_up.rect = {}; end
                if(not skinTable.message_window.buttons.scroll_up.rect.offset) then skinTable.message_window.buttons.scroll_up.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.scroll_up.rect.offset.x) then skinTable.message_window.buttons.scroll_up.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.scroll_up.rect.offset.x; end
                    if(not skinTable.message_window.buttons.scroll_up.rect.offset.y) then skinTable.message_window.buttons.scroll_up.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.scroll_up.rect.offset.y; end
                if(not skinTable.message_window.buttons.scroll_up.rect.size) then skinTable.message_window.buttons.scroll_up.rect.size = {}; end
                    if(not skinTable.message_window.buttons.scroll_up.rect.size.x) then skinTable.message_window.buttons.scroll_up.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.scroll_up.rect.size.x; end
                    if(not skinTable.message_window.buttons.scroll_up.rect.size.y) then skinTable.message_window.buttons.scroll_up.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.scroll_up.rect.size.y; end
                if(not skinTable.message_window.buttons.scroll_up.rect.anchor) then skinTable.message_window.buttons.scroll_up.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.scroll_up.rect.anchor; end
        if(not skinTable.message_window.buttons.scroll_down) then skinTable.message_window.buttons.scroll_down = {}; end
            if(not skinTable.message_window.buttons.scroll_down.NormalTexture) then skinTable.message_window.buttons.scroll_down.NormalTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_down.PushedTexture) then skinTable.message_window.buttons.scroll_down.PushedTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_down.HighlightTexture) then skinTable.message_window.buttons.scroll_down.HighlightTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_down.HighlightAlphaMode) then skinTable.message_window.buttons.scroll_down.HighlightAlphaMode = SkinTable["WIM Classic"].message_window.buttons.scroll_down.HighlightAlphaMode; end
            if(not skinTable.message_window.buttons.scroll_down.DisabledTexture) then skinTable.message_window.buttons.scroll_down.DisabledTexture = {}; end
            if(not skinTable.message_window.buttons.scroll_down.rect) then skinTable.message_window.buttons.scroll_down.rect = {}; end
                if(not skinTable.message_window.buttons.scroll_down.rect.offset) then skinTable.message_window.buttons.scroll_down.rect.offset = {}; end
                    if(not skinTable.message_window.buttons.scroll_down.rect.offset.x) then skinTable.message_window.buttons.scroll_down.rect.offset.x = SkinTable["WIM Classic"].message_window.buttons.scroll_down.rect.offset.x; end
                    if(not skinTable.message_window.buttons.scroll_down.rect.offset.y) then skinTable.message_window.buttons.scroll_down.rect.offset.y = SkinTable["WIM Classic"].message_window.buttons.scroll_down.rect.offset.y; end
                if(not skinTable.message_window.buttons.scroll_down.rect.size) then skinTable.message_window.buttons.scroll_down.rect.size = {}; end
                    if(not skinTable.message_window.buttons.scroll_down.rect.size.x) then skinTable.message_window.buttons.scroll_down.rect.size.x = SkinTable["WIM Classic"].message_window.buttons.scroll_down.rect.size.x; end
                    if(not skinTable.message_window.buttons.scroll_down.rect.size.y) then skinTable.message_window.buttons.scroll_down.rect.size.y = SkinTable["WIM Classic"].message_window.buttons.scroll_down.rect.size.y; end
                if(not skinTable.message_window.buttons.scroll_down.rect.anchor) then skinTable.message_window.buttons.scroll_down.rect.anchor = SkinTable["WIM Classic"].message_window.buttons.scroll_down.rect.anchor; end
    if(not skinTable.message_window.chat_display) then skinTable.message_window.chat_display = {}; end
        if(not skinTable.message_window.chat_display.rect) then skinTable.message_window.chat_display.rect = {}; end
            if(not skinTable.message_window.chat_display.rect.tl_offset) then skinTable.message_window.chat_display.rect.tl_offset = {}; end
                if(not skinTable.message_window.chat_display.rect.tl_offset.x) then skinTable.message_window.chat_display.rect.tl_offset.x = SkinTable["WIM Classic"].message_window.chat_display.rect.tl_offset.x; end
                if(not skinTable.message_window.chat_display.rect.tl_offset.y) then skinTable.message_window.chat_display.rect.tl_offset.y = SkinTable["WIM Classic"].message_window.chat_display.rect.tl_offset.y; end
            if(not skinTable.message_window.chat_display.rect.br_offset) then skinTable.message_window.chat_display.rect.br_offset = {}; end
                if(not skinTable.message_window.chat_display.rect.br_offset.x) then skinTable.message_window.chat_display.rect.br_offset.x = SkinTable["WIM Classic"].message_window.chat_display.rect.br_offset.x; end
                if(not skinTable.message_window.chat_display.rect.br_offset.y) then skinTable.message_window.chat_display.rect.br_offset.y = SkinTable["WIM Classic"].message_window.chat_display.rect.br_offset.y; end
    if(not skinTable.message_window.msg_box) then skinTable.message_window.msg_box = {}; end
        if(not skinTable.message_window.msg_box.rect) then skinTable.message_window.msg_box.rect = {}; end
            if(not skinTable.message_window.msg_box.rect.tl_offset) then skinTable.message_window.msg_box.rect.tl_offset = {}; end
                if(not skinTable.message_window.msg_box.rect.tl_offset.x) then skinTable.message_window.msg_box.rect.tl_offset.x = SkinTable["WIM Classic"].message_window.msg_box.rect.tl_offset.x; end
                if(not skinTable.message_window.msg_box.rect.tl_offset.y) then skinTable.message_window.msg_box.rect.tl_offset.y = SkinTable["WIM Classic"].message_window.msg_box.rect.tl_offset.y; end
            if(not skinTable.message_window.msg_box.rect.br_offset) then skinTable.message_window.msg_box.rect.br_offset = {}; end
                if(not skinTable.message_window.msg_box.rect.br_offset.x) then skinTable.message_window.msg_box.rect.br_offset.x = SkinTable["WIM Classic"].message_window.msg_box.rect.br_offset.x; end
                if(not skinTable.message_window.msg_box.rect.br_offset.y) then skinTable.message_window.msg_box.rect.br_offset.y = SkinTable["WIM Classic"].message_window.msg_box.rect.br_offset.y; end
            if(not skinTable.message_window.msg_box.font_height) then skinTable.message_window.msg_box.font_height = SkinTable["WIM Classic"].message_window.msg_box.font_height; end    
            if(not skinTable.message_window.msg_box.font_color) then skinTable.message_window.msg_box.font_color = SkinTable["WIM Classic"].message_window.msg_box.font_color; end   
    if(not skinTable.message_window.shortcuts) then skinTable.message_window.shortcuts = {}; end
        if(not skinTable.message_window.shortcuts.rect) then skinTable.message_window.shortcuts.rect = {}; end
            if(not skinTable.message_window.shortcuts.rect.offset) then skinTable.message_window.shortcuts.rect.offset = {}; end
                if(not skinTable.message_window.shortcuts.rect.offset.x) then skinTable.message_window.shortcuts.rect.offset.x = SkinTable["WIM Classic"].message_window.shortcuts.rect.offset.x; end
                if(not skinTable.message_window.shortcuts.rect.offset.y) then skinTable.message_window.shortcuts.rect.offset.y = SkinTable["WIM Classic"].message_window.shortcuts.rect.offset.y; end
            if(not skinTable.message_window.shortcuts.rect.anchor) then skinTable.message_window.shortcuts.rect.anchor = SkinTable["WIM Classic"].message_window.shortcuts.rect.anchor; end
        if(skinTable.message_window.shortcuts.verticle == nil) then skinTable.message_window.shortcuts.verticle = SkinTable["WIM Classic"].message_window.shortcuts.verticle; end
        if(skinTable.message_window.shortcuts.inverted == nil) then skinTable.message_window.shortcuts.inverted = SkinTable["WIM Classic"].message_window.shortcuts.inverted; end
        if(not skinTable.message_window.shortcuts.button_size) then skinTable.message_window.shortcuts.button_size = SkinTable["WIM Classic"].message_window.shortcuts.button_size; end
        if(not skinTable.message_window.shortcuts.buffer) then skinTable.message_window.shortcuts.buffer = SkinTable["WIM Classic"].message_window.shortcuts.buffer; end
        
    if(not skinTable.tab_strip) then skinTable.tab_strip = {}; end
        if(not skinTable.tab_strip.rect) then skinTable.tab_strip.rect = {}; end
            if(not skinTable.tab_strip.rect.anchor_points) then skinTable.tab_strip.rect.anchor_points = {}; end
                if(not skinTable.tab_strip.rect.anchor_points.self) then skinTable.tab_strip.rect.anchor_points.self = SkinTable["WIM Classic"].tab_strip.rect.anchor_points.self; end
                if(not skinTable.tab_strip.rect.anchor_points.relative) then skinTable.tab_strip.rect.anchor_points.relative = SkinTable["WIM Classic"].tab_strip.rect.anchor_points.relative; end
            if(not skinTable.tab_strip.rect.offsets) then skinTable.tab_strip.rect.offsets = {}; end
                if(not skinTable.tab_strip.rect.offsets.top) then skinTable.tab_strip.rect.offsets.top = SkinTable["WIM Classic"].tab_strip.rect.offsets.top; end
                if(not skinTable.tab_strip.rect.offsets.margins) then skinTable.tab_strip.rect.offsets.margins = {}; end
                    if(not skinTable.tab_strip.rect.offsets.margins.left) then skinTable.tab_strip.rect.offsets.margins.left = SkinTable["WIM Classic"].tab_strip.rect.offsets.margins.left; end
                    if(not skinTable.tab_strip.rect.offsets.margins.right) then skinTable.tab_strip.rect.offsets.margins.right = SkinTable["WIM Classic"].tab_strip.rect.offsets.margins.right; end
    
    if(not skinTable.emoticons) then skinTable.emoticons = {}; end
        if(not skinTable.emoticons.rect) then skinTable.emoticons.rect = {}; end
            if(not skinTable.emoticons.rect.height) then skinTable.emoticons.rect.height = SkinTable["WIM Classic"].emoticons.rect.height; end
            if(not skinTable.emoticons.rect.width) then skinTable.emoticons.rect.width = SkinTable["WIM Classic"].emoticons.rect.width; end
            if(not skinTable.emoticons.rect.xoffset) then skinTable.emoticons.rect.xoffset= SkinTable["WIM Classic"].emoticons.rect.xoffset; end
            if(not skinTable.emoticons.rect.yoffset) then skinTable.emoticons.rect.yoffset = SkinTable["WIM Classic"].emoticons.rect.yoffset; end
        if(not skinTable.emoticons.definitions) then skinTable.emoticons.definitions = {}; end
        
    --inherrit emoticon database from default skin.
    local def, val;
    for def, val in pairs(SkinTable["WIM Classic"].emoticons.definitions) do
        if(not skinTable.emoticons.definitions[def]) then
            skinTable.emoticons.definitions[def] = val;
        end
    end
        
    --check if default style images exist. if not, inherrit from 'WIM Classic'
    if(not skinTable.message_window.file[skinTable.default_style]) then skinTable.message_window.file[skinTable.default_style] = SkinTable["WIM Classic"].message_window.file.default; end
    if(not skinTable.message_window.class_icon.file[skinTable.default_style]) then skinTable.message_window.class_icon.file[skinTable.default_style] = SkinTable["WIM Classic"].message_window.class_icon.file.default; end
    if(not skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.NormalTexture.default; end
    if(not skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.PushedTexture.default; end
    if(not skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.close.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.NormalTexture.default; end
    if(not skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.PushedTexture.default; end
    if(not skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.history.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.NormalTexture.default; end
    if(not skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.PushedTexture.default; end
    if(not skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.w2w.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.chatting.NormalTexture.default; end
    if(not skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.chatting.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.NormalTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_up.DisabledTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.NormalTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.PushedTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.HighlightTexture.default; end
    if(not skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style]) then skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style] = SkinTable["WIM Classic"].message_window.buttons.scroll_down.DisabledTexture.default; end
    
    
    -- enforce the existance of style file declarations.
    for i=1,table.getn(styles) do
        if(not skinTable.message_window.file[styles[i]]) then skinTable.message_window.file[styles[i]] = skinTable.message_window.file[skinTable.default_style]; end
        if(not skinTable.message_window.class_icon.file[styles[i]]) then skinTable.message_window.class_icon.file[styles[i]] = skinTable.message_window.class_icon.file[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.NormalTexture[styles[i]]) then skinTable.message_window.buttons.close.NormalTexture[styles[i]] = skinTable.message_window.buttons.close.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.PushedTexture[styles[i]]) then skinTable.message_window.buttons.close.PushedTexture[styles[i]] = skinTable.message_window.buttons.close.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.close.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.close.HighlightTexture[styles[i]] = skinTable.message_window.buttons.close.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.NormalTexture[styles[i]]) then skinTable.message_window.buttons.history.NormalTexture[styles[i]] = skinTable.message_window.buttons.history.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.PushedTexture[styles[i]]) then skinTable.message_window.buttons.history.PushedTexture[styles[i]] = skinTable.message_window.buttons.history.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.history.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.history.HighlightTexture[styles[i]] = skinTable.message_window.buttons.history.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.NormalTexture[styles[i]]) then skinTable.message_window.buttons.w2w.NormalTexture[styles[i]] = skinTable.message_window.buttons.w2w.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.PushedTexture[styles[i]]) then skinTable.message_window.buttons.w2w.PushedTexture[styles[i]] = skinTable.message_window.buttons.w2w.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.w2w.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.w2w.HighlightTexture[styles[i]] = skinTable.message_window.buttons.w2w.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.chatting.NormalTexture[styles[i]]) then skinTable.message_window.buttons.chatting.NormalTexture[styles[i]] = skinTable.message_window.buttons.chatting.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.chatting.PushedTexture[styles[i]]) then skinTable.message_window.buttons.chatting.PushedTexture[styles[i]] = skinTable.message_window.buttons.chatting.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.NormalTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.NormalTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.PushedTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.PushedTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.HighlightTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_up.DisabledTexture[styles[i]]) then skinTable.message_window.buttons.scroll_up.DisabledTexture[styles[i]] = skinTable.message_window.buttons.scroll_up.DisabledTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.NormalTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.NormalTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.NormalTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.PushedTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.PushedTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.PushedTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.HighlightTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.HighlightTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.HighlightTexture[skinTable.default_style]; end
        if(not skinTable.message_window.buttons.scroll_down.DisabledTexture[styles[i]]) then skinTable.message_window.buttons.scroll_down.DisabledTexture[styles[i]] = skinTable.message_window.buttons.scroll_down.DisabledTexture[skinTable.default_style]; end
    end
    
    
    -- finalize registration
    SkinTable[skinTable.title] = skinTable;
    
    -- if this is the selected skin, load it now
    if(skinTable.title == WIM_Data.skin.selected) then
        WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
    end
end

function WIM_ShowSkinDebug()
    WIM_Help:Show();
    WIM_HelpScrollFrameScrollChildText:SetText(SKIN_DEBUG);
end

function WIM_LoadSkin(skinName, style)
    if(skinName == nil or (not SkinTable[skinName])) then
        skinName = "WIM Classic";
        style = SkinTable[skinName].default_style;
    end
    if(style == nil or (not SkinTable[skinName].styles[style])) then
        if(style == "#SMART#" and SkinTable[skinName].smart_style) then
            -- do nothing here. we want the #SMART# style to pass...
        else
            style = SkinTable[skinName].default_style;
        end
    end
    SelectedSkin = SkinTable[skinName];
    SelectedStyle = style;
    
    WIM_Data.skin.selected = skinName;
    WIM_Data.skin.style = style;
    
    -- apply skin to tabs
    WIM_Tabs.anchorSelf = SkinTable[skinName].tab_strip.rect.anchor_points.self;
    WIM_Tabs.anchorRelative = SkinTable[skinName].tab_strip.rect.anchor_points.relative;
    WIM_Tabs.topOffset = SkinTable[skinName].tab_strip.rect.offsets.top;
    WIM_Tabs.marginLeft = SkinTable[skinName].tab_strip.rect.offsets.margins.left;
    WIM_Tabs.marginRight = SkinTable[skinName].tab_strip.rect.offsets.margins.right;
    if(WIM_Windows[WIM_Tabs.selectedUser]) then
        WIM_JumpToUserTab(WIM_Tabs.selectedUser);
    end
    
    skinLoaded = true; -- used for quicker refrence for checking if skins are loaded yet...
    SKIN_DEBUG = SKIN_DEBUG..skinName.." loaded..\n";
    -- apply skin to window objects
    local window_objects = WindowSoupBowl.windows;
    for i=1, table.getn(window_objects) do
        WIM_LoadMessageWindowSkin(window_objects[i].obj);
    end
end

function WIM_SkinnerList_Click()
    if(WIM_Data.skin.selected ~= this.theName) then
        WIM_Data.skin.style = SkinTable[this.theName].default_style;
        WIM_Data.skin.font = SkinTable[this.theName].default_font;
    end
    WIM_Data.skin.selected = this.theName;
    WIM_SkinnerOptionsStyles:Hide();
    WIM_SkinnerOptionsStyles:Show();
    WIM_SkinnerOptionsFonts:Hide();
    WIM_SkinnerOptionsFonts:Show();
    WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
end

function WIM_SkinnerList_Update()
	local line;
	local lineplusoffset;
	local ListNames = {};
	
	if(SkinTable == nil) then return; end
	if(SkinTable["WIM Classic"] == nil) then WIM_LoadSkin(); end
	
	for key,_ in pairs(SkinTable) do
		table.insert(ListNames, key);
	end
	
	FauxScrollFrame_Update(WIM_SkinnerOptionsListScrollBar,table.getn(ListNames),4,16);
	for line=1,4 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(WIM_SkinnerOptionsListScrollBar);
		if (lineplusoffset <= table.getn(ListNames)) then
			getglobal("WIM_SkinnerOptionsListButton"..line.."Name"):SetText(ListNames[lineplusoffset]);
			getglobal("WIM_SkinnerOptionsListButton"..line).theName = ListNames[lineplusoffset];
			if ( WIM_Data.skin.selected == ListNames[lineplusoffset] ) then
				getglobal("WIM_SkinnerOptionsListButton"..line):LockHighlight();
			else
				getglobal("WIM_SkinnerOptionsListButton"..line):UnlockHighlight();
			end
			getglobal("WIM_SkinnerOptionsListButton"..line):Show();
		else
			getglobal("WIM_SkinnerOptionsListButton"..line):Hide();
		end
	end
end

function WIM_Skinner_Styles_OnShow()
	UIDropDownMenu_Initialize(this, WIM_Skinner_Styles_Initialize);
	UIDropDownMenu_SetSelectedValue(this, WIM_Data.skin.style);
	UIDropDownMenu_SetWidth(150, WIM_SkinnerOptionsStyles);
end

function WIM_Skinner_Styles_Click()
        WIM_Data.skin.style = this.value
	UIDropDownMenu_SetSelectedValue(WIM_SkinnerOptionsStyles, this.value);
	WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
end

function WIM_Skinner_Styles_Initialize()
	local info = {};
        if(SkinTable[WIM_Data.skin.selected].smart_style) then
            info.text = "*"..WIM_SKINNER_LOCALIZED_OPTIONS_SMART_STYLE.."*";
            info.value = "#SMART#";
            info.justifyH = "LEFT";
            info.func = WIM_Skinner_Styles_Click;
            UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
        end
        
        
        for key,title in pairs(SkinTable[WIM_Data.skin.selected].styles) do
            info = { };
            info.text = title;
            info.value = key;
            info.justifyH = "LEFT";
            info.func = WIM_Skinner_Styles_Click;
            UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
        end
end

function WIM_Skinner_Font_OnShow()
        if(getglobal(WIM_Data.skin.font) == nil) then
            DEFAULT_CHAT_FRAME:AddMessage("WIM SKIN ERROR: Selected skin object not found! Loading default font instead.");
            WIM_Data.skin.font = SkinTable["WIM Classic"].default_font;
        end
	UIDropDownMenu_Initialize(this, WIM_Skinner_Font_Initialize);
	UIDropDownMenu_SetSelectedValue(this, WIM_Data.skin.font);
	UIDropDownMenu_SetWidth(150, WIM_SkinnerOptionsFonts);
end

function WIM_Skinner_Font_Click()
        -- do nothing. No longer needed since Font Selection Window was created.
end

function WIM_Skinner_Font_Initialize()
	local info = {};
        local sorted = {};
        for key,title in pairs(fontTable) do
            table.insert(sorted, key);
        end
        table.sort(sorted);
        
        for i=1,table.getn(sorted) do
            info = { };
            info.text = fontTable[sorted[i]];
            info.value = sorted[i];
            info.justifyH = "LEFT";
            info.func = WIM_Skinner_Font_Click;
            UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
        end
end

function WIM_Skinner_Default_font()
    WIM_Data.skin.font = SkinTable[WIM_Data.skin.selected].default_font;
    WIM_SkinnerOptionsFonts:Hide();
    WIM_SkinnerOptionsFonts:Show();
    WIM_LoadSkin(WIM_Data.skin.selected, WIM_Data.skin.style);
end

function WIM_Skinner_Import_SharedMedia()
    local key, path;
    for key, path in pairs(SML:HashTable("font")) do
        fname = key;
        CreateFont(fname);
        getglobal(fname):SetFont(path, 12);
        WIM_RegisterFont(fname, key);
    end
end

function WIM_GetXYLimits()
    local width, height;
    
    width = SelectedSkin.message_window.rect.top_left.size.x + SelectedSkin.message_window.rect.bottom_right.size.x;
    height = SelectedSkin.message_window.rect.top_left.size.y + SelectedSkin.message_window.rect.bottom_right.size.y;
    
    return width, height;
end

----------------------------------------------------------
--          MessageWindow OnEvent Functions             --
----------------------------------------------------------

function WIM_MessageWindow_ExitButton_OnEnter()
    if(WIM_Data.showToolTips == true) then
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
	GameTooltip:SetText(WIM_LOCALIZED_TOOLTIP_SHIFT_CLICK_TO_CLOSE);
    end
    WIM_MessageWindow_FadeControler_OnEnter();
end

function WIM_MessageWindow_ExitButton_OnLeave()
    GameTooltip:Hide();
    WIM_MessageWindow_FadeControler_OnLeave();
end

function WIM_MessageWindow_ExitButton_OnClick()
    if(IsShiftKeyDown()) then
	WIM_CloseConvo(this:GetParent().theUser);
	-- do some check if tabs are loaded and show next available.
    else
        this:GetParent():Hide();
    end
end

function WIM_MessageWindow_HistoryButton_OnEnter()
    if(WIM_Data.showToolTips == true) then
	GameTooltip:SetOwner(this, "ANCHOR_TOPRIGHT");
	GameTooltip:SetText(WIM_LOCALIZED_TOOLTIP_VIEW_HISTORY);
    end
    WIM_MessageWindow_FadeControler_OnEnter();
end

function WIM_MessageWindow_HistoryButton_OnLeave()
    GameTooltip:Hide();
    WIM_MessageWindow_FadeControler_OnLeave();
end

function WIM_MessageWindow_HistoryButton_OnClick()
    WIM_HistoryView_Name_Selected = this:GetParent().theUser;
    WIM_HistoryView_Filter_Selected = "";
    if(WIM_HistoryFrame:IsVisible()) then
	WIM_HistoryViewNameScrollBar_Update();
	WIM_HistoryViewFiltersScrollBar_Update();
    else
	WIM_HistoryFrame:Show();
    end
end

function WIM_MessageWindow_W2WButton_OnEnter()
    local user = this:GetParent().theUser;
    local theTip = "WIM Version: |cffffffff"..WIM_W2W[user].version.."|r";
    theTip = theTip.."\n"..WIM_W2W_CAPABILITIES..": |cffffffffCoordinates|r";
    if(WIM_W2W[user].spec) then theTip = theTip..",\n|cffffffffTalent Spec|r"; end
    GameTooltip:SetOwner(this, "ANCHOR_RIGHT");
    GameTooltip:SetText(theTip);
    WIM_MessageWindow_FadeControler_OnEnter();
end

function WIM_MessageWindow_W2WButton_OnLeave()
    GameTooltip:Hide();
    WIM_MessageWindow_FadeControler_OnLeave();
end

function WIM_MessageWindow_W2WButton_Initialize()
	local info = {};
	
	info = { };
	info.text = "W2W - WIM To WIM";
	info.isTitle = true;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
	
	info = { };
	info.text = WIM_W2W_TRACKMINIMAP;
	info.func = WIM_MessageWindow_W2WButtomMenu_OnClick;
        info.value = this:GetParent().theUser;
        info.checked = this:GetParent().icon.track;
        info.tooltipTitle = WIM_W2W_TRACKMINIMAP;
        info.tooltipText = WIM_W2W_TRACKMINIMAP_INFO;
	UIDropDownMenu_AddButton(info, UIDROPDOWNMENU_MENU_LEVEL);
end

function WIM_MessageWindow_W2WButtomMenu_OnClick()
    local icon = getglobal(WIM_Windows[this.value].frame).icon;
    icon.track = not icon.track;
    if(icon.track) then
        icon:Show();
    else
        icon:Hide();
    end
end

function WIM_MessageWindow_W2WButton_OnClick()
    UIDropDownMenu_Initialize(this:GetParent().w2w_menu, WIM_MessageWindow_W2WButton_Initialize, "MENU");
    ToggleDropDownMenu(1, nil, this:GetParent().w2w_menu, this, -130, -1);
end

function WIM_MessageWindow_IsChattingButton_OnEnter()
    if(WIM_Data.showToolTips == true) then
	local user = this:GetParent().theUser;
	local theTip = user.." "..WIM_W2W_IS_TYPING;
	GameTooltip:SetOwner(this, "ANCHOR_TOPLEFT");
	GameTooltip:SetText(theTip);
    end
    WIM_MessageWindow_FadeControler_OnEnter();
end

function WIM_MessageWindow_IsChattingButton_OnLeave()
    GameTooltip:Hide();
    WIM_MessageWindow_FadeControler_OnLeave();
end

function WIM_MessageWindow_IsChattingButton_OnUpdate()
    this.time_elapsed = this.time_elapsed + arg1;
    while(this.time_elapsed > 2) do
	if((time() - this.typing_stamp) > 5) then
	    this:Hide();
	end
	this.time_elapsed = 0;
    end
end

function WIM_MessageWindow_ScrollUp_OnClick()
    if( IsControlKeyDown() ) then
	getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):ScrollToTop();
    else
	if( IsShiftKeyDown() ) then
	    getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):PageUp();
	else
	    getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):ScrollUp();
	end
    end
    WIM_UpdateScrollBars(getglobal(this:GetParent():GetName().."ScrollingMessageFrame"));
end

function WIM_MessageWindow_ScrollDown_OnClick()
    if( IsControlKeyDown() ) then
	getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):ScrollToBottom();
    else
	if( IsShiftKeyDown() ) then
	    getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):PageDown();
	else
	    getglobal(this:GetParent():GetName().."ScrollingMessageFrame"):ScrollDown();
	end
    end
    WIM_UpdateScrollBars(getglobal(this:GetParent():GetName().."ScrollingMessageFrame"));
end

function WIM_MessageWindow_ScrollingMessageFrame_OnMouseWheel()
    if(arg1 > 0) then
	if( IsControlKeyDown() ) then
	    this:ScrollToTop();
	else
	    if( IsShiftKeyDown() ) then
		this:PageUp();
	    else
		this:ScrollUp();
	    end
	end
    else
	if( IsControlKeyDown() ) then
	    this:ScrollToBottom();
	else
	    if( IsShiftKeyDown() ) then
                this:PageDown();
	    else
		this:ScrollDown();
	    end
	end
    end
end

function WIM_MessageWindow_ScrollingMessageFrame_OnMouseDown()
    this:GetParent().prevLeft = this:GetParent():GetLeft();
    this:GetParent().prevTop = this:GetParent():GetTop();
end

function WIM_MessageWindow_ScrollingMessageFrame_OnMouseUp()
    if(this:GetParent().prevLeft == this:GetParent():GetLeft() and this:GetParent().prevTop == this:GetParent():GetTop()) then
	--[ Frame was clicked not dragged
	if(WIM_EditBoxInFocus == nil) then
	    getglobal(this:GetParent():GetName().."MsgBox"):SetFocus();
	else
	    if(WIM_EditBoxInFocus:GetName() == this:GetParent():GetName().."MsgBox") then
		getglobal(this:GetParent():GetName().."MsgBox"):Hide();
		getglobal(this:GetParent():GetName().."MsgBox"):Show();
	    else
		getglobal(this:GetParent():GetName().."MsgBox"):SetFocus();
	    end
	end
    end
end

function WIM_MessageWindow_MsgBox_OnMouseUp()
    CloseDropDownMenus();
    if(arg1 == "RightButton") then
        WIM_MSGBOX_MENU_CUR_USER = this:GetParent().theUser;
        UIDropDownMenu_Initialize(WIM_MsgBoxMenu, WIM_MsgBoxMenu_Initialize, "MENU");
        ToggleDropDownMenu(1, nil, WIM_MsgBoxMenu, this, 0, 0);
    end
end

function WIM_MessageWindow_MsgBox_OnEnterPressed()
    local _, tParent = this:GetParent();
						
    if(this:GetText() == "") then
	if(WIM_Data.windowFade and this:GetParent().QueuedToHide) then
            WIM_FadeOut(this:GetParent().theUser);
        end
        this:Hide();
        this:Show();
        return;
    else
        if(WIM_Data.windowFade) then
            WIM_FadeOutDelayed(this:GetParent().theUser);
        end
    end
						
    if(strsub(this:GetText(), 1, 1) == "/") then
        WIM_EditBoxInFocus = nil;
        ChatFrameEditBox:SetText(this:GetText());
        ChatEdit_SendText(ChatFrameEditBox, 1);
        WIM_EditBoxInFocus = this;
    else
        SendChatMessage(this:GetText(), "WHISPER", nil, WIM_ParseNameTag(this:GetParent().theUser));
        this:AddHistoryLine(this:GetText());
    end
    this:SetText("");
    if(not WIM_Data.keepFocus) then
        this:Hide();
        this:Show();
    elseif(not IsResting() and WIM_Data.keepFocusRested) then
        this:Hide();
        this:Show();
    end
end

function WIM_MessageWindow_MsgBox_OnEscapePressed()
    this:SetText("");
    this:Hide();
    this:Show();
    if(WIM_Data.windowFade) then
        WIM_FadeOut(this:GetParent().theUser);
    end
end

function WIM_MessageWindow_MsgBox_OnTabPressed()
    --cycle through windows
    if(WIM_Tabs.enabled == true) then
        if(IsShiftKeyDown()) then
            WIM_TabStep(-1);
        else
            WIM_TabStep(1);
        end
    else
        WIM_ToggleWindow_Toggle();
    end
end

function WIM_MessageWindow_MsgBox_OnTextChanged()
    if(WIM_W2W[this:GetParent().theUser]) then
	if(not this.w2w_typing) then 
	    this.w2w_typing = 0;
	end
	if(this:GetText() ~= "") then
	    if(time() - this.w2w_typing > 2) then
		this.w2w_typing = time();
                if(WIM_Data.w2w.typing) then
        	    WIM_W2W_SendAddonMessage(this:GetParent().theUser , "IS_TYPING#TRUE");
                end
	    end
	else
	    this.w2w_typing = 0;
            if(WIM_Data.w2w.typing) then
                WIM_W2W_SendAddonMessage(this:GetParent().theUser , "IS_TYPING#FALSE");
            end
	end
    end
    WIM_EditBox_OnChanged();
end

function WIM_MessageWindow_MsgBox_OnUpdate()
    if(this.setText == 1) then
	this.setText = 0;
	this:SetText("");
    end
end

function WIM_MessageWindow_Frame_OnShow()
    local user = this.theUser;
    if(user ~= nil and WIM_Windows[user]) then
        WIM_Windows[user].newMSG = false;
        WIM_Windows[user].is_visible = true;
        if(WIM_Data.autoFocus == true) then
    	getglobal(this:GetName().."MsgBox"):SetFocus();
        end
        WIM_WindowOnShow(this);
        this.QueuedToHide = false;
        WIM_UpdateScrollBars(getglobal(this:GetName().."ScrollingMessageFrame"));
    end
end

function WIM_MessageWindow_Frame_OnHide()
    local user = this.theUser;
    if(user ~= nil and WIM_Windows[user]) then
        WIM_Tabs.lastParent = nil;
        WIM_TabStrip:Hide();
        this.isMouseOver = false;
        if(WIM_Windows[user]) then
            WIM_Windows[user].is_visible = false;
        end
        if ( this.isMoving ) then
    	this:StopMovingOrSizing();
    	this.isMoving = false;
        end
    end
end

function WIM_MessageWindow_Frame_OnUpdate()
    if(WIM_Tabs.enabled == true) then
	WIM_Tabs.x = this:GetLeft();
	WIM_Tabs.y = this:GetTop();
    end
end


-----------------------------------------------------
--          Functions for Font Options             --
-----------------------------------------------------
function WIM_GetFontKeyByName(fontName)
	for key, val in pairs(fontTable) do
		if(val == fontName) then
			return key;
		end
	end
	return nil;
end

function WIM_FontList_Update()
	local line;
	local lineplusoffset;
	local ListNames = {};
	
	for key,val in pairs(fontTable) do
		table.insert(ListNames, val);
	end
        table.sort(ListNames);
	
	FauxScrollFrame_Update(WIM_Options_FontSelectorListFrameScrollBar,table.getn(ListNames),9,25);
	for line=1,9 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(WIM_Options_FontSelectorListFrameScrollBar);
		if (lineplusoffset <= table.getn(ListNames)) then
			getglobal("WIM_Options_FontSelectorListFrameButton"..line.."Name"):SetText(ListNames[lineplusoffset]);
			getglobal("WIM_Options_FontSelectorListFrameButton"..line).theFont = WIM_GetFontKeyByName(ListNames[lineplusoffset]);
			if ( WIM_OPTIONS_SELECTED_FONT == WIM_GetFontKeyByName(ListNames[lineplusoffset]) ) then
				getglobal("WIM_Options_FontSelectorListFrameButton"..line):LockHighlight();
			else
				getglobal("WIM_Options_FontSelectorListFrameButton"..line):UnlockHighlight();
			end
                        local font, height, flags = getglobal(getglobal("WIM_Options_FontSelectorListFrameButton"..line).theFont):GetFont();
                        getglobal("WIM_Options_FontSelectorListFrameButton"..line.."Name"):SetFont(font, 14);
			getglobal("WIM_Options_FontSelectorListFrameButton"..line):Show();
		else
			getglobal("WIM_Options_FontSelectorListFrameButton"..line):Hide();
		end
	end
end

function WIM_FontList_Preview(theFont)
    local font, height, flags = getglobal(theFont):GetFont();
    getglobal("WIM_Options_FontSelectorPreviewFrameText"):SetFont(font, 14, WIM_OPTIONS_FONT_OUTLINE);
    getglobal("WIM_Options_FontSelectorPreviewFrameText"):SetText(fontTable[theFont]);
end



-----------------------------------------------------
--        Minimap Position Icon Functions          --
-----------------------------------------------------

function WIM_CreateMipmapDodad()
    local icon = CreateFrame("Button", nil, UIParent);
    icon:SetWidth(16);
    icon:SetHeight(16);
    icon.bg = icon:CreateTexture();
    icon.bg:SetTexture("Interface\\AddOns\\WIM\\Images\\miniEnabled");
    icon.bg:SetDrawLayer("BACKGROUND");
    icon.bg:SetAllPoints();
    icon.bg:Hide();
    icon:SetPoint("CENTER", Minimap, "CENTER", 0, 0);
    
    icon.track = false;
    
    icon.recalc_timeout = 0;
    icon.phase = 0;
    
    icon.arrow = CreateFrame("Model", nil, icon)
    icon.arrow:SetHeight(140.8)
    icon.arrow:SetWidth(140.8)
    icon.arrow:SetPoint("CENTER", Minimap, "CENTER", 0, 0)
    icon.arrow:SetModel("Interface\\Minimap\\Rotating-MinimapArrow.mdx")
    icon.arrow:Hide();
    
    function icon:OnUpdate(elapsed)
      if (icon.track and WIM_ShouldTrackUser(self.theUser)) then
        
        self:Show()
        
        if self.recalc_timeout <= 0 then
          self.recalc_timeout = 50
          
          WIM_Astrolabe:PlaceIconOnMinimap(self, tonumber(WIM_W2W[this.theUser].zoneInfo.C), tonumber(WIM_W2W[this.theUser].zoneInfo.Z), tonumber(WIM_W2W[this.theUser].zoneInfo.x), tonumber(WIM_W2W[this.theUser].zoneInfo.y))
        else
          self.recalc_timeout = self.recalc_timeout - 1
        end
        
        local edge = WIM_Astrolabe:IsIconOnEdge(self)
        
        if edge then
          self.arrow:Show()
          self.bg:Hide()
        else
          self.arrow:Hide()
          self.bg:Show()
        end
        
        if edge then
          local angle = WIM_Astrolabe:GetDirectionToIcon(self)
          if GetCVar("rotateMinimap") == "1" then
            angle = angle + MiniMapCompassRing:GetFacing()
          end
          
          self.arrow:SetFacing(angle)
          self.arrow:SetPosition(ofs * (137 / 140) - radius * math.sin(angle),
                                 ofs               + radius * math.cos(angle), 0);
          
          if self.phase > 6.283185307179586476925 then
            self.phase = self.phase-6.283185307179586476925+elapsed*3.5
          else
            self.phase = self.phase+elapsed*3.5
          end
          self.arrow:SetModelScale(0.600000023841879+0.1*math.sin(self.phase))
        end
      else
        self:Hide()
      end
    end
    
    function icon:OnEnter()
        WIM_ShortcutFrame_Location_OnEnter(icon.theUser);
    end
    
    function icon:OnLeave()
      GameTooltip:Hide()
    end
    
    function icon:OnClick()
        WIM_PostMessage(this.theUser, "", 5);
    end
    
    icon:SetScript("OnUpdate", icon.OnUpdate)
    icon:SetScript("OnEnter", icon.OnEnter)
    icon:SetScript("OnLeave", icon.OnLeave)
    icon:SetScript("OnClick", icon.OnClick)
    
    icon:RegisterForClicks("LeftButtonUp")
    
    return icon;
end

function WIM_ShouldTrackUser(theUser)
    if(WIM_W2W[theUser]) then
        if(WIM_W2W[theUser].zoneInfo) then
            local tmp = WIM_W2W[theUser].zoneInfo;
            local C, Z, x, y = WIM_Astrolabe:GetCurrentPlayerPosition();
            if((tonumber(tmp.x) == 0 and tonumber(tmp.y == 0)) or (tonumber(x) == 0 or tonumber(y) == 0)) then
                -- do not show on minimap if either the player or myself are in a non-valid instance.
                return false
            else
                -- only show if we are on the same continent.
                if(tonumber(C) == tonumber(tmp.C)) then
                    return true;
                else
                    return false;
                end
            end
        else
            return false;
        end
    else
        return false;
    end
end

-----------------------------------------------------
--                Emoticon Functions               --
-----------------------------------------------------

function WIM_FilterEmoticons(theMsg)

    --saftey check...
    if(not theMsg or theMsg == "") then
        return "";
    end

    --accomodate WoW's built in symbols and inherrit WoW's options whether to display them or not.
    if ( 1 ) then
	local term;
	for tag in string.gmatch(theMsg, "%b{}") do
	    term = strlower(string.gsub(tag, "[{}]", ""));
	    if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
		theMsg = string.gsub(theMsg, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
	    end
	end
    end


    if(WIM_Data.emoticons) then
        local emoteTable = SkinTable["WIM Classic"].emoticons;
        if(type(SelectedSkin) == "table") then
            emoteTable = SelectedSkin.emoticons;
        end
        -- first as to not disrupt any links, lets remove them and put them back later.
        local results, orig;
        orig = theMsg;
        LinkRepository[orig] = {};
        local msgRepository = LinkRepository[orig];
        repeat
            theMsg, results = string.gsub(theMsg, "(|H[^|]+|h[^|]+|h)", function(theLink)
                table.insert(msgRepository, theLink);
                return "#LINK"..table.getn(msgRepository).."#";
            end, 1);
        until results == 0;
    
        -- lets exchange emotes...
        local emote, img;
        for emote,_ in pairs(emoteTable.definitions) do
            img = WIM_getEmoteFilePath(emote);
            if(img and img ~= "") then
                theMsg = string.gsub(theMsg, WIM_ConvertEmoteToPattern(emote), "|T"..img..":"..emoteTable.rect.width..":"..emoteTable.rect.height..":"..emoteTable.rect.xoffset..":"..emoteTable.rect.yoffset.."|t");
            end
        end
        
        -- put all the links back into the string...
        for i=1, table.getn(msgRepository) do
            theMsg = string.gsub(theMsg, "#LINK"..i.."#", msgRepository[i]);
        end
        
        LinkRepository[orig] = nil;
    end
    
    return theMsg;
end

function WIM_ConvertEmoteToPattern(theEmote)
    local special = {"%", ":", "-", "^", "$", ")", "(", "]", "]", "~", "@", "#", "&", "*", "_", "+", "=", ",", ".", "?", "/", "\\", "{", "}", "|", "`", ";", "\"", "'"};
    local i;
    for i=1, table.getn(special) do
        theEmote = string.gsub(theEmote, "%"..special[i], "%%"..special[i]);
    end
    return theEmote;
end

function WIM_getEmoteFilePath(theEmote)
    local emoteTable = SkinTable["WIM Classic"].emoticons;
    if(type(SelectedSkin) == "table") then
        emoteTable = SelectedSkin.emoticons;
    end

    local tmp;
    tmp = emoteTable.definitions[theEmote];
    -- if emote not found or if mal formed/linked emote, prevent infinate loop.
    if(not tmp or tmp == theEmote) then
        return "";
    else
        if(emoteTable.definitions[tmp]) then
            return WIM_getEmoteFilePath(tmp);
        else
            return tmp;
        end
    end
end

function WIM_GetEmoteTable()
    local list = {};
    local tmp;
    for key,_ in pairs(SelectedSkin.emoticons.definitions) do
        tmp = WIM_getEmoteFilePath(key);
        if(tmp ~= "") then
            if(not list[tmp]) then
                list[tmp] = {
                    triggers = {}
                };
            end
            table.insert(list[tmp].triggers, key)
        end
    end
    return list;
end

-----------------------------------------------------
--              Register Default Fonts             --
-----------------------------------------------------

-- register wow's 3 main font types.
WIM_RegisterFont("GameFontNormal", "(WoW) Game Font");
WIM_RegisterFont("ChatFontNormal", "(WoW) Chat Font");
WIM_RegisterFont("QuestTitleFont", "(WoW) Quest Font");

-- initial import from SharedMediaLib
WIM_Skinner_Import_SharedMedia();
