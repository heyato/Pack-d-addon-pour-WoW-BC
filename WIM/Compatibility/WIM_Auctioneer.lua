local Auctioneer_AskPriceHooked = false;
local Auctioneer_whisperList = {};
local Advanced_AskPriceHooked = false;
local Advanced_whisperList = {};

function WIM_HookAuctioneer()
    --first lets accomodate the classic Auctioneer.
    if(not Auctioneer_AskPriceHooked and IsAddOnLoaded("Auctioneer")) then
        Auctioneer_AskPriceHooked = true;
        Auctioneer.AskPrice.WIM_SendWhisper_orig = Auctioneer.AskPrice.SendWhisper;
        Auctioneer.AskPrice.SendWhisper = function(message, player)
                                            Auctioneer_whisperList[message] = true;
                                            Auctioneer.AskPrice.WIM_SendWhisper_orig(message, player);
                                        end;
        local WIM_API_Filter_orig = WIM_API_Filter;
        WIM_API_Filter = function(message, player, isInbound, isInternal)
                            if(Auctioneer_whisperList[message]) then
                                if(isInternal and not isInbound) then Auctioneer_whisperList[message] = nil; end
                                if (not isInbound and Auctioneer.Command.GetFilter('askprice-whispers') == false) then
                                    return 1;
                                else
                                    return WIM_API_Filter_orig(message, player, isInbound, isInternal);
                                end
                            else
                                return WIM_API_Filter_orig(message, player, isInbound, isInternal);
                            end
                        end;
    end
    --next let's accomodate Auc-Advanced
    if(not Advanced_AskPriceHooked and IsAddOnLoaded("Auc-Advanced")) then
        Advanced_AskPriceHooked = true;
        local askPrice, lib, private = AucAdvanced.GetModule("Util", "AskPrice");
        askPrice.Private.WIM_sendWhisper_orig = askPrice.Private.sendWhisper;
        askPrice.Private.sendWhisper = function(message, player)
                                            Advanced_whisperList[message] = true;
                                            askPrice.Private.WIM_sendWhisper_orig(message, player);
                                        end;
        local WIM_API_Filter_orig = WIM_API_Filter;
        WIM_API_Filter = function(message, player, isInbound, isInternal)
                            if(Advanced_whisperList[message]) then
                                if(isInternal and not isInbound) then Advanced_whisperList[message] = nil; end
                                if (not isInbound and askPrice.Private.getOption('util.askprice.whispers') == false) then
                                    return 1;
                                else
                                    return WIM_API_Filter_orig(message, player, isInbound, isInternal);
                                end
                            else
                                return WIM_API_Filter_orig(message, player, isInbound, isInternal);
                            end
                        end;
    end
end

--Hook Auctioneer if Auctioneer is loaded already,
--otherwise, WIM_Hooks will handle it when it's loaded.

WIM_HookAuctioneer();