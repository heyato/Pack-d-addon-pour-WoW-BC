WIM_CHANGE_LOG = [[
Version 2.4.15 (05-13-2008)|cffffffff
[*] - Fixed bug causing error after 2.4.2 patch.
[*] - Fixed bug relating to MBB.

|rVersion 2.4.14 (04-22-2008)|cffffffff
[+] - Added compatibility for female class names.
[*] - Modified pattern matching for emoticons.
[*] - Removed hooks from chat frame. Using event filters.
[*] - Optimized code relating to UI Dropdowns. (gc friendly).
[*] - Minimap icon now inherrits Minimap props when attached.
[*] - Fixed bug when opening history before a skin is loaded.
[+] - WIM now respects the MessageEventFilters from other addons.
[+] - New Keybinding: Respond to selected tab.
[*] - Modified how skins are loaded.
[*] - Fix bug with lost first message(rare) and ghost messages.
[+] - Upgraded library to LibSharedMedia-3.0. (requires restart).
[+] - Added option to show tooltip when hovering over item links.

|rVersion 2.4.9 (04-01-2008)|cffffffff
[!] - Updated toc file to reflect the new 2.4 interface.
[+] - WIM message windows now support emoticons (over 50).
[+] - Added option in general tab to enable/disable emoticons.
[+] - WIM's message windows now support WoW's raid icons.
[*] - Corrected an issue with UI widget layer ordering.
[+] - Added menu to right click of message box.
[+] - Menu now has access to sent history as well as emoticons.
[*] - Updated library Astrolabe to WoW 2.4 compatible version.
[*] - Updated all attached libraries to latest versions.
[+] - WIM now respects Skin width and height restrictions.
[*] - WIM Titan Panel support has been fixed.

|rVersion 2.3.65 (03-11-2008)|cffffffff
[+] - Added menu for W2W actions on WIM icon on message window.
[+] - You can now track W2W users on your Minimap.
[+] - Added compatibility for Auctioneer AskPrice.
[+] - Added compatibility for AucAdvanced AskPrice.
[*] - Fixed various bugs and tweaked WIM's Skinner (Thanks Stewart).

|rVersion 2.3.56 (02-26-2008)|cffffffff
[*] - Fixed Titan plugin. (*Restart required for titan support only*).
[*] - Fixed bug where some Prat message where mal-formed.
[*] - Packaging the most recent version of WhoLib.
[*] - Fixed bug which cause 'ghost' message to appear on new windows.
[+] - W2W Talent Spec now shows official spec names as well as build.
[*] - Fixed bug where tabs would disapear when receiving new message.

|rVersion 2.3.49 (02-19-2008)|cffffffff
[*] - Updated Skinning Engine (added smart styling).
[*] - Changed 'url' link type to 'wim_url' to avoid addon confusion.
[+] - Added W2W API for POST_MSG_IN and POST_MSG_OUT. (Plugin Usage).
[*] - Fixed bug which cause 'ghost' message to appear on new windows.
[+] - Added keybinding (through WoW's UI) to toggle show/hide all.
[+] - Added keybinding (through WoW's UI) to mark all as read.
[+] - Added 'mark all as read' to right click menu.
[+] - WIM's fonts are now managed by SharedMediaLib. (*requires restart*).
[+] - WIM now comes packaged with PratPlugin-1.0 (*requires restart*).
[+] - WIM is now fully compatible with Prat. Thank you Sylvanaar.
[+] - Added X-Embeds tag in toc for WhoLib for people having trouble.
[*] - Correct issue where /w (user) would sometimes appear in WIM's edit boxes.
[*] - Modified hooks. Should resolve any tainting of the chat frame.
[+] - WIM now intercepts /r commands as well.
[+] - Time stamps are added to system messages as well now.
[+] - W2W can now share talent tree information.
[+] - Added new font selection/settings window.
[+] - Added font options to set font outline.
[*] - Updated translations for zhTW.
[*] - Updated translations for zhCN.
[+] - Added history viewer to right click of players. (chat & unit frames.)

|rVersion 2.3.19 (01-15-2008)|cffffffff
[*] - Updated TOC for WoW 2.3 interface.
[*] - Some minor bug fixes.
[+] - Introduced new window management engine. (Soup Bowl)
[+] - UI is now created through code instead of XML.
[+] - Added skinning engine. (See Options->Plugins)
[*] - Modified package file structure (Delete Old & Game Restart).
[*] - Location coordinates now uses floor() instead of rounding.
[*] - Modified caching of GM names. Should fix W2W & GM Issues.
[+] - Added "ItemDB-Request:" as a default filter.
[+] - Added spoofing for IsShown() for those addons not linking.
[+] - Added date display for history preview.
[*] - While AFK, windows will not honor auto close timeout option.
[*] - Fixed bug which caused window sizing problems.
[+] - Added W2W Plugin Options. (Enable & Show typing...).
[+] - Updated attached libraries with current versions.
[+] - Fonts can be changed from skin customization.
[+] - Added support for ClearFont2.
[-] - Removed custom ignore ui. Now uses WoW's StaticPopup.

|rVersion 2.2.28 (10-02-2007)|cffffffff
[*] - Fixed error caused by WIM_HookInspect.
[*] - Added cache of friend and guild list for latency issues.
[*] - Updated tooltip behavior -- fixes conflicts with Gymnist.
[*] - W2W commands are no longer sent to GM's.
[*] - W2W has been disabled between cross realm players.
[*] - Fixed error received when whispering GM.
[*] - The auto-closing of windows should now work correctly.
[*] - W2W now double checks validity of user before sending requests.
[*] - W2W no longer causes player not playing spam.

|rVersion 2.2.19 (09-25-2007)|cffffffff
[*] - Slight change to the execution of filtering.
[*] - The re-whisper (<Shift-R>) now works as intended.
[*] - Adjusted UI on Plugin Note window.
[*] - Minimap icon now inherits minimap visibility when attached.
[+] - Added 'BB Code' formatting for history viewer.
[+] - GM Messages will no longer auto close due to time out.
[+] - Added MapNotes whisper tag to default filters.
[+] - Adopted WhoLib into WIM as well as its dependencies.
[+] - Added a new 'universal' linking system. (Conventionally)
[+] - Now using new 'Prat' style URL onClick display.
[*] - WIM should no longer break Prat's URL linking.
[+] - Significantly improved URL Linking & changed format.
[+] - Added new WIM-2-WIM (W2W) System.
[+] - W2W - added advanced information for player location.
[*] - Updated cross-realm battleground who lookup.
[+] - W2W - shows when player is typing.

|rVersion 2.1.26 (06-05-2007)|cffffffff
[*] - Corrected issue with transparency and WoW 2.1 patch.
[+] - Added option to enable fading in display options.
[-] - Removed depricated ATSW hooks.
[+] - Control-Scroll jumps to top and bottom (thanks dracula).
[+] - Player right click menu now includes report spam feature.
[*] - Modified WIM's default settings. (They were out dated.)
[+] - Added support for ItemSync's Fetch Link feature.
[-] - Removed hooks on LootLink. Telo's update is native to WIM.
[-] - Removed hooks from AtlasLoot. No longer needed.
[+] - Added support for IgnoreMore.
[*] - Correct issue with reply intercept.
[+] - Updated Korean localization (thanks Bitz).

|rVersion 2.1.15 (05-22-2007)|cffffffff
[*] - Updated TOC for WoW 2.1 interface.
[+] - GM whispers are now caught and are uniquely displayed.
[+] - GM conversations are now automatically logged in history.
[+] - Default filter added for ParyQuest. (Thanks Jasperau).
[*] - Corrected logic of auto closing conversations.
[+] - Added mouse scroll wheel support to tabs.
[+] - Focus is now inheritted when changing tabs.
[*] - Fixed friends list bug which switching characters.
[+] - Friend convos now show user online/offline messages.
[+] - You can now link player names from the default chat frame.
[*] - Fixed bug that cause split when inserting link to chat frame.
[+] - Added option to set whether windows are on top or not.
[*] - Fixed bug that caused error when closing non-selected tabs.
[+] - Added option to select how tabs are sorted.
[+] - Right-Clicking a tab now closes the conversation.
[+] - Updated TOC for myAddon support. (Thanks Maziel).
[+] - Added sub-option to suppressions while in combat.
[*] - Modified WIM's CronTab execution.
[+] - Updated layout to accomodate plugins on option screen. 
[+] - Added plugin interface.
[*] - History preview now formats time stamps as intended.
[*] - ChatEdit_SetLastTellTarget is no longer called if blocked.
[+] - Whisper interception now applies to replying tells as well.
[*] - Fixed bug when ending convos in multiple window mode.

|rVersion 2.0.9 (03-20-2007)|cffffffff
[!] - Initial 2.x Series Release!
[*] - Updated class color for Shamans.
[*] - Cleaned the Bindings.xml as per Drizzd's suggestion.
[*] - Updated FuBar plugin code as per Rhidon's suggestion.
[*] - Filters are no longer cleared between updates.
[+] - Added Tabbed Window Mode - built WIM tab engine.
[*] - Reorganized Template XML. (Requires Restart).
[*] - WIM_Options is now a LoD Addon. (Reduces ~1mb memory).
[+] - Added update detection for newer versions of WIM.
[+] - Added function WIM_API_InsertText.
[*] - WIM is now independent of chat frame msg events.
[*] - Corrected issue with duplicate messages.
[*] - Linking from AtlasLoot no longer causes disconnect.
[+] - Tabbed Mode: <Tab> & <Shift Tab> scroll through tabs.

|rVersion 1.5.10 (03-07-2007)|cffffffff
[*] - Revised event handler. Should correct whisper catching issue.
[*] - Now validates window data before creating. Prevents errors.
[*] - Fixed Ace/WIM compatibilty issue with linking items.

|rVersion 1.5.6 (03-06-2007)|cffffffff
[*] - Linking stackable items will no longer show split dialogue.
[+] - Added "Add Friend" shortcut to shortcut bar. (Only if not a friend).
[+] - Added an icon to the shortcut bar where you can see the users location.
[*] - Defined filters to catch GuildAds, Ace, CT and Metamap messages.
[+] - Added option to select different time stamp formats.
[+] - Added interface for SpamSentry.
[*] - Recoded event hooks by using ChatFrame_MessageEventHandler.
[*] - Modified filter checking to use less resources.
[+] - Added options to auto close idle messages (friends and non-friends).
[+] - Added "(Show All)" to user list in history viewer.
[+] - Added ability to export history. (raw text & html).
[+] - Added flood control. (10 second cool down on duplicate messages).
[+] - Right-Clicking minimap icon now shows "WIM Tools" menu.
[+] - Added option to turn off "WIM Tools" menu from minimap.
[*] - LootLink (Standard) now works with WIM.
[+] - WIM is now functional with AdvancedTradeSkillWindow.
[+] - Added option to ignore arrow keys while typing messages.

|rVersion 1.4.66 (01-09-2007)|cffffffff
[*] - Updated to work with 2.0.3 patch.

|rVersion 1.4.58 (12-30-2006)|cffffffff
[*] - Fixed error when showing all and hiding all message windows.
[*] - Fixed error with linking from auction house.
[*] - Updated Korean translations.
[+] - 'Enter' with no message to be sent will now drop focus.
[*] - Fixed problem with whispering users with special characters.
[*] - Modified slash command handler as suggested by 'egingell'.
[+] - Updated default filters to include GuildAds 2.0.
[+] - On version upgrades, default filters are automatically reloaded.

|rVersion 1.4.50 (12-08-2006)|cffffffff
[!] - WIM is now updated to work with WoW 2.0 Interface.
[-] - Removed incompatible buttons from shortcut bar. Ideas for new ones?
[*] - Hooking structure revamped due to new blizz function ChatEdit_InsertLink().

|rVersion 1.4.16 (11-14-2006)|cffffffff
[+] - Added Traditional Chinese Translations (Thanks Junxian).
[+] - Added new option interface for "Show Shortcutbar"
[+] - You can now choose which buttons to show on shortcut bar.
[+] - Added options for FuBar plugin.
[*] - FuBar plugin should now retain settings.
[*] - Users are now case insensitive, preventing mulitple windows per user.
[*] - Intercepting /whisper commands now follows popup combat rules.
[*] - Corrected issue where outbound popups still popped while in combat.
[*] - Corrected possible bug preventing linking to party/guild/raid chat.

|rVersion 1.4.5 (10-31-2006)|cffffffff
[*] - FuBar plugin fix. (Added SetFontSize() method).

|rVersion 1.4.4 (10-31-2006)|cffffffff
[+] - Added German Translations (Thanks Corrilian).
[*] - Made changes to the way FuBar2 Plugin loads (Hopefully a fix).
[*] - Fixed bug that caused error message when linking from ItemSync.
[*] - Fixed bug that caused EngInventory to open split when linking.
[+] - Added Spanish Translations (Thanks AlbertQ).
[+] - Added Simplified Chinese Translations (Thanks Annie).
[+] - Added French Translations (Thanks Khellendros).
[*] - Removed some depricated minimap menu code. (Thanks Soin).
[*] - Attempt to correct issue with Polish and Russian fonts.
[*] - Tweaked chat fonts to be as backward compatible as possible.
[*] - Reworked SuperInspect, compatibilty. Corrected linking issues.

|rVersion 1.4.3 (10-24-2006)|cffffffff
[+] - All english text can now be localized!
[*] - All WIM strings now use system font declarations. (For localizing).
[+] - Added some problematic addons to Optional Dependency List. (Fix?).
[-] - Removed some depricated code and objects from Titan plugin.
[*] - Fixed bug where slash commands were intercepted when WIM was disabled.
[*] - Changed intercept option position to be more intuitive.
[+] - You can now link items from the vendor window.
[+] - You can now link quests from your quest log.
[+] - You can now link quest items from a quest giver.
[+] - You can now link quest rewards from your quest log.
[+] - You can now link items from the auction house.
[+] - Added FuBar 2.0 Plugin support.
[+] - Added Korean Translations (Thanks Bitz).
[+] - Added support for ItemSync.

|rVersion 1.3.1 (10-17-2006)|cffffffff
[+] - Created new minimap icon menu. No longer using Blizzards Drop Down Menu.
[+] - You can now close conversations from the minimap icon menu.
[*] - Made required code changes for titan plugin and new minimap icon menu.
[*] - Who window no longer pops up when speaking with GM or offline user.
[+] - WIM replaces "Send Message" button in the Friends Frame.
[+] - Now interecepts /w and /whisper commands and opens a message window.
[+] - Added option to enable/disable whisper slash command intercepting.
[+] - Added support for LootLink.
[+] - Added support for EngInventory.
[+] - You can now execute slash commands inside a message window.

|rVersion 1.2.13 (10-03-2006)|cffffffff
[*] - Fixed bug that causes error if titan is not loaded.

|rVersion 1.2.12 (10-03-2006)|cffffffff
[+] - Added support for AtlasLoot.
[+] - Added option to only keep focus while in a major city.
[+] - Added option to not show AFK and DND messages.
[+] - Added option to Enable/Disable use of 'Escape Key' to close windows.
[+] - Added 'Show' and 'Hide All Messages' key bindings.
[+] - Added scroll bar to general options tab. (out of room!).
[*] - Fixed nil error in function WIM_LoadGuildList(). (thanks Misschief).
[+] - You can now link items from the loot window.
[+] - Added support for AllInOneInventory.
[*] - Who window should no longer pop up when finding similar names.
[*] - Titan is now listed as an optional dependency.

|rVersion 1.2.11 (09-29-2006)|cffffffff
[*] - Fixed spelling mistake on Windows tab.
[*] - No longer run /who request on cross-realm users.
[+] - Get information on cross-realm users from raid info.
[*] - Message toggle window only shows unique users as intended.
[+] - Toggling window now brings it to front if behind another window.
[+] - Toggling windows now auto focuses when message selected.
[+] - The TAB key now toggles windows while already focused in another window.
[+] - You can now link items from the inspect screen.
[+] - You can now link items in SuperInspect.
[+] - Added "Did you know?" tab in help.
[+] - Added "Credits" tab in help.
[+] - Added button to option screen to access help.

|rVersion 1.2.10 (09-26-2006)|cffffffff
[*] - Made a minor adjustment to window focusing behavior.
[+] - Modified options window to include aliasing, filtering & History options
[+] - Added Alias Filtering: (1: replace name; 2: show as comment);
[+] - Added Keyword/Phrase Filtering: (1: Ignore (by WIM); 2: Block (all together))
[+] - Added default CT_RABM filter rules.
[+] - Added history engine and options.
[+] - Added history viewer.   ( /wim history )
[*] - Shortcut bar now retains its transparency of 100%.
[+] - Added button to message window to access history if history exists.
[+] - Added options to set default window position.
[+] - Added option to Enable/Disable window cascading.
[+] - Added option to change the direction if window cascading.
[+] - Added key bindings.
[+] - Added a key binding to toggle through recent conversations.
[+] - Added a help screen. ( /wim help )

|rVersion 1.1.15 (09-19-2006)|cffffffff
[+] - Added option to show character info (/who requests).
[+] - Added option to show class icon. (updated default icon).
[*] - Minimap icon no longer shows on top of all other windows unless its in free moving mode.
[+] - You can now link items in your character frame.
[+] - You can now link items from trade skill windows.
[+] - You can now link items from crafting windows (ex: Enchanting)
[+] - Added option to set class color to title bar text.
[+] - Added option to display timestamps.
[+] - Added option to Enable/Disable WIM.
[+] - Added shortcut bar (and appropriate options).
[+] - Added detailed character info. (Guild, level, race, class).

|rVersion 1.1.4 (09-15-2006)|cffffffff
[+] - Added built-in Titan plugin.
[*] - Transparency no longer affects chat text.
[*] - Minimap menu now opens to the left the way intended.
[+] - Created new graphics for message window.
[+] - Recreated message window frame - now sizable!
[+] - Reorganized option window & created tab for window options
[-] - Removed option 'Show minimap tooltip'.
[+] - Added options 'Show tooltips'.
[*] - Reworded option to pop up when receiving replies (worked as intended).
[*] - Windows can no longer positioned outside of the interface.
[+] - Added option to sort conversation list alphabetically (otherwise sort by order received).
[+] - Added options to change height and width of message windows.
[+] - Message windows can now be dragged by the chat frame.
[+] - Clicking chat frame will now set focus to message box.
[+] - Added the ability to close a conversation.
[+] - Added freely movable minimap icon. (Move anywhere on your screen).
[+] - Shift-Click scroll button now pages up & down.
[+] - Shift-ScrollWheel now pages up and down.
[+] - Added option to disable popups when in combat.
[+] - Added class icons to message window.

|rVersion 1.0.19 (09-12-2006) |cffffffff
[*] - Fixed the problem with in game languages (Common/Orcish). This should also resolve problems with other lingual wow interfaces as well. 
[*] - Recoded some function hooks to avoid receiving duplicate messages due to addon conflicts. 

|rVersion 1.0.18 (09-12-2006) |cffffffff
[!] - Initial public release.

]]
