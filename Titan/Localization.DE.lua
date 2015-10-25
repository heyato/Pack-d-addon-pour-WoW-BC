-- Version : German
-- Thanks to Sensity for correcting some Rider and XP translations and to Littlemaxi for providing translations for Profession Bags.

function TitanLocalizeDE() 
	TITAN_DEBUG = "<Titan>";
	TITAN_INFO = "<Titan>";

	TITAN_NA = "N/V";
	TITAN_SECONDS = "Sekunde(n)";
	TITAN_MINUTES = "Minute(n)";
	TITAN_HOURS = "Stunde(n)";
	TITAN_DAYS = "Tag(e)";
	TITAN_SECONDS_ABBR = "s";
	TITAN_MINUTES_ABBR = "m";
	TITAN_HOURS_ABBR = "Std";
	TITAN_DAYS_ABBR = "T";
	TITAN_MILLISECOND = "ms";
	TITAN_KILOBYTES_PER_SECOND = "KB/s";
	TITAN_KILOBITS_PER_SECOND = "Kbps";
	TITAN_MEGABYTE = "MB";

	TITAN_MOVABLE_TOOLTIP = "Ziehen zum verschieben.";

	TITAN_PANEL_ERROR_DUP_PLUGIN = " scheint 2mal registriert zu sein. Aus diesem Grund funktioniert Titan Panel nicht richtig, bitte behebe/melde dieses Problem"
	
	-- slash command help
	TITAN_PANEL_SLASH_STRING2 = LIGHTYELLOW_FONT_COLOR_CODE.."Usage: |cffffffff/tp {reset | reset tipfont/tipalpha/panelscale/spacing}";
	TITAN_PANEL_SLASH_STRING3 = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset: |cffffffffResets Panel to default values/position.";
	TITAN_PANEL_SLASH_STRING4 = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipfont: |cffffffffResets Panel tooltip font scale to default.";
	TITAN_PANEL_SLASH_STRING5 = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset tipalpha: |cffffffffResets Panel tooltip transparency to default.";
	TITAN_PANEL_SLASH_STRING6 = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset panelscale: |cffffffffResets Panel scale to default.";
	TITAN_PANEL_SLASH_STRING7 = " - "..LIGHTYELLOW_FONT_COLOR_CODE.."reset spacing: |cffffffffResets Panel button spacing to default.";
	TITAN_PANEL_SLASH_STRING8 = LIGHTYELLOW_FONT_COLOR_CODE.."For help with BonusScanner, type : |cffffffff/bs"..LIGHTYELLOW_FONT_COLOR_CODE.." or |cffffffff/bscan";
	
	-- slash command responses
	TITAN_PANEL_SLASH_RESP1 = LIGHTYELLOW_FONT_COLOR_CODE.."Titan Panel tooltip font scale has been reset.";
	TITAN_PANEL_SLASH_RESP2 = LIGHTYELLOW_FONT_COLOR_CODE.."Titan Panel tooltip transparency has been reset.";
	TITAN_PANEL_SLASH_RESP3 = LIGHTYELLOW_FONT_COLOR_CODE.."Titan Panel scale has been reset.";
	TITAN_PANEL_SLASH_RESP4 = LIGHTYELLOW_FONT_COLOR_CODE.."Titan Panel button spacing has been reset.";
	
	TITAN_PANEL = "Titan Panel";
	TITAN_PANEL_REVISION = "Rev 799";
	TITAN_PANEL_VERSION_INFO = "|cffffffff by the |cffff8c00Titan Dev Team".." |cffffffff(HonorGoG, joejanko, Lothayer, Tristanian, oXidFoX, urnati & StingerSoft)";
	TITAN_PANEL_MENU_TITLE = "Titan Panel";
	TITAN_PANEL_MENU_HIDE = "Ausblenden";
	TITAN_PANEL_MENU_CUSTOMIZE = "Anpassen";
	TITAN_PANEL_MENU_IN_COMBAT_LOCKDOWN = "(In Combat)";
	TITAN_PANEL_MENU_RELOADUI = "(Reload UI)";
	TITAN_PANEL_MENU_SHOW_COLORED_TEXT = "Farbigen Text anzeigen";
	TITAN_PANEL_MENU_SHOW_ICON = "Icon anzeigen";
	TITAN_PANEL_MENU_SHOW_LABEL_TEXT = "Beschriftungstext anzeigen";
	TITAN_PANEL_MENU_AUTOHIDE = "Titanleiste automatisch ausblenden";
	TITAN_PANEL_MENU_BGMINIMAP = "Schlachtfeld Mini-Map";
	TITAN_PANEL_MENU_CENTER_TEXT = "Text zentrieren";
	TITAN_PANEL_MENU_DISPLAY_ONTOP = "Oben am Bildschirm anzeigen";
	TITAN_PANEL_MENU_DISPLAY_BOTH = "Oben und unten am Bildschirm anzeigen";
	TITAN_PANEL_MENU_DISABLE_PUSH = "Bildschirmjustierung deaktivieren (Gr\195\182\195\159en\195\164nderung)";
	TITAN_PANEL_MENU_DISABLE_MINIMAP_PUSH = "Minimapjustierung deaktivieren"; -- Sensity
	TITAN_PANEL_MENU_DISABLE_LOGS = "Log automatisch justieren";
	TITAN_PANEL_MENU_BUILTINS = "Titan Standardplugins";
	TITAN_PANEL_MENU_LEFT_SIDE = "Linke Seite";
	TITAN_PANEL_MENU_RIGHT_SIDE = "Rechte Seite";
	TITAN_PANEL_MENU_LOAD_SETTINGS = "Settings laden";
	TITAN_PANEL_MENU_DOUBLE_BAR = "Doppeltes Panel";
	TITAN_PANEL_MENU_OPTIONS = "Einstellungen";
	TITAN_PANEL_MENU_OPTIONS_PANEL = "Panel";
	TITAN_PANEL_MENU_OPTIONS_BARS = "Bars";
	TITAN_PANEL_MENU_OPTIONS_TOOLTIPS = "Tooltips";
	TITAN_PANEL_MENU_OPTIONS_FRAMES = "Frames";
	TITAN_PANEL_MENU_PLUGINS = "Plugins";
	TITAN_PANEL_MENU_LOCK_BUTTONS = "Buttons fixieren"; -- Sensity
	TITAN_PANEL_MENU_VERSION_SHOWN = "Pluginversionen anzeigen";
	TITAN_PANEL_MENU_LDB_SHOWN = "Integriere Wechselerweiterung ins Menu"; -- Sensity
    TITAN_PANEL_MENU_LDB_SIDE = "Plugin rechtsseitig"; -- Sensity
    TITAN_PANEL_MENU_LDB_FORCE_LAUNCHER = "Starter rechtsseitig verankern"; -- Sensity
	TITAN_PANEL_MENU_DISABLE_FONT = "Schriftarten skalieren sperren"; 
	TITAN_PANEL_MENU_CATEGORIES = {"Allgemein","Kampf","Informationen","Interface","Beruf"}
	TITAN_PANEL_MENU_TOOLTIPS_SHOWN = "Zeige Tooltips";
	TITAN_PANEL_MENU_TOOLTIPS_SHOWN_IN_COMBAT = "Verberge Tooltips im Kampf"; -- Sensity
	TITAN_PANEL_MENU_CASTINGBAR = "Verschiebe Zauberleiste";
	TITAN_PANEL_MENU_RESET = "Einstellungen zur\195\188cksetzen";
  	TITAN_PANEL_MENU_TEXTURE_SETTINGS = "Skin Einstellungen"; -- Sensity
  	TITAN_PANEL_MENU_SKINS = "Eigene Skins"; -- Sensity
  	TITAN_PANEL_MENU_ENABLED = "Ein"; -- Sensity
	TITAN_PANEL_MENU_DISABLED = "Aus";-- Sensity

	TITAN_AUTOHIDE_TOOLTIP = "Leiste automatisch ausblenden";
	TITAN_AUTOHIDE_MENU_TEXT = "Automatisch ausblenden";

	TITAN_AMMO_FORMAT = "%d";
	TITAN_AMMO_BUTTON_LABEL_AMMO = "Munition: ";
	TITAN_AMMO_BUTTON_LABEL_THROWN = "Geworfen: ";
	TITAN_AMMO_BUTTON_LABEL_AMMO_THROWN = "Munition/Geworfen: ";
	TITAN_AMMO_TOOLTIP = "Angelegte Munition/Geworfen Z\195\164hler";
	TITAN_AMMO_MENU_TEXT = "Munition/Geworfen";
	TITAN_AMMO_THROWN_KEYWORD = "Wurfwaffen";
	
	TITAN_BAG_FORMAT = "%d/%d";
	TITAN_BAG_BUTTON_LABEL = "Taschen: ";
	TITAN_BAG_TOOLTIP = "Taschenbenutzung";
	TITAN_BAG_TOOLTIP_HINTS = "Hinweis: Links-Klick um alle Taschen zu \195\182ffnen.";
	TITAN_BAG_MENU_TEXT = "Taschenbenutzung";
	TITAN_BAG_MENU_SHOW_USED_SLOTS = "Bereits belegte Pl\195\164tze anzeigen";
	TITAN_BAG_MENU_SHOW_AVAILABLE_SLOTS = "Noch verf\195\188gbare Pl\195\164tze anzeigen";
	TITAN_BAG_MENU_IGNORE_AMMO_POUCH_SLOTS = "Pl\195\164tze des Munitionsbeutels ignorieren";
	TITAN_BAG_MENU_IGNORE_SHARD_BAGS_SLOTS = "Ignoriere Splittertaschen";
	TITAN_BAG_MENU_IGNORE_PROF_BAGS_SLOTS = "Ignoriere Berufs-Taschen";
	TITAN_BAG_AMMO_POUCH_NAMES = {"Munition", "K\195\182cher", "Schulterg\195\188rtel", "Geschoss", "Lamina"};
	TITAN_BAG_SHARD_BAG_NAMES = {"Seelenbeutel", "Teufelsstofftasche", "Kernteufelsstofftasche", "Schwarzschattentasche"};
	TITAN_BAG_PROF_BAG_NAMES = {"Verzauberter Magiestoffbeutel", "Verzauberte Runenstofftasche", "Grosse Verzauberertasche", "Verzaubererranzen", "Zauberfeuertasche", "Werkzeugkasten", "Edelsteinbeutel", "Juwelenbeutel", "Verst\195\164rkte Bergbautasche", "Bergbausack", "Ranzen des Lederers", "Balgtasche", "Kr\195\164uterbeutel", "Cenarische Kr\195\164utertasche","Cenarischer Ranzen","Mycah's Botanical Bag"};

	TITAN_BGMINIMAP_MENU_TEXT = "Schlachtfeld Minimap"
	TITAN_BGMINIMAP_TOOLTIP = "wechsle Schlachtfeld Minimap"

	TITAN_CLOCK_TOOLTIP = "Uhr";
	TITAN_CLOCK_TOOLTIP_VALUE = "Momentane Zeitverschiebung: ";
	TITAN_CLOCK_TOOLTIP_HINT1 = "Hinweis: Links-Klick um die Zeitverschiebung festzulegen"
	TITAN_CLOCK_TOOLTIP_HINT2 = "und zwischen dem 12/24 Stundenformat zu wechseln.";
	TITAN_CLOCK_CONTROL_TOOLTIP = "Zeitverschiebung in Stunden: ";
	TITAN_CLOCK_CONTROL_TITLE = "Verschiebung";
	TITAN_CLOCK_CONTROL_HIGH = "+12";
	TITAN_CLOCK_CONTROL_LOW = "-12";
	TITAN_CLOCK_CHECKBUTTON = "24Std Fmt";
	TITAN_CLOCK_CHECKBUTTON_TOOLTIP = "Wechselt die Anzeige zwischen dem 12-Stunden und 24-Stunden Format.";
	TITAN_CLOCK_MENU_TEXT = "Uhr";
	TITAN_CLOCK_MENU_DISPLAY_ON_RIGHT_SIDE = "Ganz rechts anzeigen.";

	TITAN_COORDS_FORMAT = "(%.d, %.d)";
	TITAN_COORDS_FORMAT2 = "(%.1f, %.1f)";
	TITAN_COORDS_FORMAT3 = "(%.2f, %.2f)";
	TITAN_COORDS_FORMAT_LABEL = "(xx , yy)";
	TITAN_COORDS_FORMAT2_LABEL = "(xx.x , yy.y)";
	TITAN_COORDS_FORMAT3_LABEL = "(xx.xx , yy.yy)";
	TITAN_COORDS_FORMAT_COORD_LABEL = "Coordinate Format";
	TITAN_COORDS_BUTTON_LABEL = "Pos: ";
	TITAN_COORDS_TOOLTIP = "Info zur Position";
	TITAN_COORDS_TOOLTIP_HINTS_1 = "Hinweis: Shift + Links-Klick um die";
	TITAN_COORDS_TOOLTIP_HINTS_2 = "momentane Position in den Chat einf\195\188gen.";-- Sensity
	TITAN_COORDS_TOOLTIP_ZONE = "Zone: ";
	TITAN_COORDS_TOOLTIP_SUBZONE = "SubZone: ";
	TITAN_COORDS_TOOLTIP_PVPINFO = "PVP Info: ";
	TITAN_COORDS_TOOLTIP_HOMELOCATION = "Heimatort";
	TITAN_COORDS_TOOLTIP_INN = "Gasthaus: ";
	TITAN_COORDS_MENU_TEXT = "Position";
	TITAN_COORDS_MENU_SHOW_ZONE_ON_PANEL_TEXT = "Zonentext in der Leiste anzeigen";
	TITAN_COORDS_MENU_SHOW_COORDS_ON_MAP_TEXT = "Koordinaten auf der Weltkarte anzeigen";
	TITAN_COORDS_MAP_COORDS_TEXT = "%d, %d";
	TITAN_COORDS_MAP_CURSOR_COORDS_TEXT = "Mauszeiger (X,Y): %s";
	TITAN_COORDS_MAP_PLAYER_COORDS_TEXT = "Spieler (X,Y): %s";

	TITAN_FPS_FORMAT = "%.1f";
	TITAN_FPS_BUTTON_LABEL = "Bps: ";
	TITAN_FPS_MENU_TEXT = "Bilder pro Sekunde (Bps)";
	TITAN_FPS_TOOLTIP_CURRENT_FPS = "Momentan: ";
	TITAN_FPS_TOOLTIP_AVG_FPS = "Durchschnitt: ";
	TITAN_FPS_TOOLTIP_MIN_FPS = "Bisher Minimum: ";
	TITAN_FPS_TOOLTIP_MAX_FPS = "Bisher Maximum: ";
	TITAN_FPS_TOOLTIP = "Bilder pro Sekunde";

	TITAN_LATENCY_FORMAT = "%d"..TITAN_MILLISECOND;
	TITAN_LATENCY_BANDWIDTH_FORMAT = "%.3f "..TITAN_KILOBYTES_PER_SECOND;
	TITAN_LATENCY_BUTTON_LABEL = "Latenz: ";
	TITAN_LATENCY_TOOLTIP = "Netzwerkstatus";
	TITAN_LATENCY_TOOLTIP_LATENCY = "Momentane Latenz: ";
	TITAN_LATENCY_TOOLTIP_BANDWIDTH_IN = "Bandbreite rein: ";
	TITAN_LATENCY_TOOLTIP_BANDWIDTH_OUT = "Bandbreite raus: ";
	TITAN_LATENCY_MENU_TEXT = "Latenz";

	TITAN_LOOTTYPE_BUTTON_LABEL = "Pl\195\188ndern: ";
	TITAN_LOOTTYPE_FREE_FOR_ALL = "Jeder gegen Jeden";
	TITAN_LOOTTYPE_ROUND_ROBIN = "Reihum";
	TITAN_LOOTTYPE_MASTER_LOOTER = "Pl\195\188ndermeister";
	TITAN_LOOTTYPE_GROUP_LOOT = "Pl\195\188ndern als Gruppe";
	TITAN_LOOTTYPE_NEED_BEFORE_GREED = "Bedarf vor Gier";
	TITAN_LOOTTYPE_TOOLTIP = "Pl\195\188ndermethode";
	TITAN_LOOTTYPE_MENU_TEXT = "Pl\195\188ndereinstellungen";
	TITAN_LOOTTYPE_RANDOM_ROLL_LABEL = "W\195\188rfelwurf";
	TITAN_LOOTTYPE_TOOLTIP_HINT1 = "Hinweis: Links-Klick f\195\188r W\195\188rfelwurf.";
	TITAN_LOOTTYPE_TOOLTIP_HINT2 = "Auswahl der W\195\188rfelmethode im Rrechtsklick-Men\195\188.";

	TITAN_MEMORY_FORMAT = "%.3f"..TITAN_MEGABYTE;
	TITAN_MEMORY_RATE_FORMAT = "%.3f"..TITAN_KILOBYTES_PER_SECOND;
	TITAN_MEMORY_BUTTON_LABEL = "Speicher: ";
	TITAN_MEMORY_TOOLTIP = "Script Speichernutzung";
	TITAN_MEMORY_TOOLTIP_CURRENT_MEMORY = "Momentan: ";
	TITAN_MEMORY_TOOLTIP_INITIAL_MEMORY = "Anf\195\164nglich: ";
	TITAN_MEMORY_TOOLTIP_INCREASING_RATE = "Steigerungsrate: ";
	TITAN_MEMORY_TOOLTIP_GC_INFO = "Ausschussdaten Info: "; -- Sensity
	TITAN_MEMORY_TOOLTIP_GC_THRESHOLD = "Schwellwert Ausschussdaten: "; -- Sensity
	TITAN_MEMORY_TOOLTIP_TIME_TO_GC = "Zeit bis n\195\164chste Speicherbereinigung: " -- Sensity
	TITAN_MEMORY_MENU_TEXT = "Script Speichernutzung";
	TITAN_MEMORY_MENU_RESET_SESSION = "Zur\195\188cksetzen";

	TITAN_MONEY_GOLD = "G";
	TITAN_MONEY_SILVER = "S";
	TITAN_MONEY_COPPER = "K";
	TITAN_MONEY_FORMAT = "%d"..TITAN_MONEY_GOLD..", %d"..TITAN_MONEY_SILVER..", %d"..TITAN_MONEY_COPPER;
	

	TITAN_PERFORMANCE_TOOLTIP = "Leistungsinfo";
	TITAN_PERFORMANCE_MENU_TEXT = "Leistung";
	TITAN_PERFORMANCE_ADDONS = "Addon Verbrauch";
	TITAN_PERFORMANCE_ADDON_MEM_USAGE_LABEL = "Addon Speicher Verbrauch";
	TITAN_PERFORMANCE_ADDON_CPU_USAGE_LABEL = "Addon CPU Nutzung"; -- Sensity
	TITAN_PERFORMANCE_ADDON_NAME_LABEL = "Name:";
	TITAN_PERFORMANCE_ADDON_USAGE_LABEL = "Verbrauch";
	TITAN_PERFORMANCE_ADDON_RATE_LABEL = "Rate";
	TITAN_PERFORMANCE_ADDON_TOTAL_MEM_USAGE_LABEL = "Gesamt Addon Speichernutzung:"; -- Sensity
	TITAN_PERFORMANCE_ADDON_TOTAL_CPU_USAGE_LABEL = "Total CPU Time:";
	TITAN_PERFORMANCE_MENU_SHOW_FPS = "Zeige FPS";
	TITAN_PERFORMANCE_MENU_SHOW_LATENCY = "Zeige Latenz";
	TITAN_PERFORMANCE_MENU_SHOW_MEMORY = "Zeige Speicher";
	TITAN_PERFORMANCE_MENU_SHOW_ADDONS = "Zeige Addon Speicher Verbrauch";
	TITAN_PERFORMANCE_MENU_SHOW_ADDON_RATE = "Zeige Addon verbrauchs Rate";
	TITAN_PERFORMANCE_MENU_CPUPROF_LABEL = "CPU Profiling Mode";
	TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_ON = "CPU Profiling Mode ein "; -- Sensity
	TITAN_PERFORMANCE_MENU_CPUPROF_LABEL_OFF = "CPU Profiling Mode aus "; -- Sensity
	TITAN_PERFORMANCE_CONTROL_TOOLTIP = "\195\156berwachte Addons: ";
	TITAN_PERFORMANCE_CONTROL_TITLE = "\195\156berwachte Addons";
	TITAN_PERFORMANCE_CONTROL_HIGH = "40";
	TITAN_PERFORMANCE_CONTROL_LOW = "1";
	TITAN_PERFORMANCE_TOOLTIP_HINT = "Hinweis: Links-Klick f\195\188r eine Speicherbereinigung.";

	TITAN_RIDER_HINT = "Aktueller Status: "; -- Sensity
	TITAN_RIDER_OPTIONS_SHOWSTATE = "Zeige Spieler Status";
     	TITAN_RIDER_OPTIONS_DISMOUNTDELAY = "Absitzen Verzoegerung"; -- Sensity
	TITAN_RIDER_OPTIONS_EQUIP = "Items anlegen";
	TITAN_RIDER_STATES = {"Laufen", "Reiten", "Fliegen", "Reisen", "Schwimmen", "Schaf"}; -- Sensity
	TITAN_RIDER_ITEMS = 6;
	TITAN_RIDER_ITEMS_LABEL = "Reithilfen"; -- Sensity
	TITAN_RIDER_ITEM_NAMES = {"Stiefel mit Mithrilsporen","Verzauberte Reithandschuhe","Karotte am Stiel","Reitgerte","Peitsche der Himmelsteiler","Gl\195\188cksbringer des schnellen Fluges"}; -- Sensity
	TITAN_RIDER_ITEM_DESCS = {"+4%% Reittempo","+2%% Reittempo","Karotte am Stiel","Reitgerte","Peitsche der Himmelsteiler","Gl\195\188cksbringer des schnellen Fluges"}; -- Sensity
	TITAN_RIDER_ITEM_SLOTS = {"FeetSlot","HandsSlot","Trinket0Slot","Trinket0Slot","Trinket0Slot","Trinket0Slot"};
	TITAN_RIDER_DRUID_FLIGHT_FORM = "Fluggestalt";
	TITAN_RIDER_DRUID_SWIFTFLIGHT_FORM = "Schnelle Fluggestalt";

	TITAN_TRANS_TOOLTIP = "Transparenz der Leiste einstellen";
	TITAN_TRANS_TOOLTIP_VALUE = "Hauptleiste Transparenz: "; -- Sensity
	TITAN_AUXTRANS_TOOLTIP_VALUE = "Hilfsleiste Transparenz: "; -- Sensity
	TITAN_TRANS_TOOLTIP_HINT1 = "Hinweis: Links-Klick um die Transparenz";
	TITAN_TRANS_TOOLTIP_HINT2 = "der Leiste anzupassen.";
	TITAN_TRANS_CONTROL_TOOLTIP = "Hauptleiste Transparenz: "; -- Sensity
	TITAN_AUXTRANS_CONTROL_TOOLTIP = "Hilfsleiste Transparenz: "; -- Sensity
	TITAN_TRANS_MAIN_CONTROL_TITLE = "Hauptleiste"; -- Sensity
	TITAN_TRANS_AUX_CONTROL_TITLE = "Hilfsleiste"; -- Sensity
	TITAN_TRANS_CONTROL_HIGH = "100%";
	TITAN_TRANS_CONTROL_LOW = "0%";
	TITAN_TRANS_MENU_TEXT = "Transparenz der Leiste";

	TITAN_UISCALE_TOOLTIP = "Skalierung des Panels einstellen";
	TITAN_UISCALE_TOOLTIP_VALUE_UI = "Skalierung des Interfaces: "; -- Sensity
	TITAN_UISCALE_TOOLTIP_VALUE_PANEL = "Skalierung der Leiste: ";
	TITAN_UISCALE_TOOLTIP_VALUE_BUTTON = "Button Abstand: "; -- Sensity
  	TITAN_UISCALE_TOOLTIP_VALUE_TOOLTIPTRANS = "Tooltip Transparenz: ";
	TITAN_UISCALE_TOOLTIP_VALUE_TOOLTIPFONT = "Skalierung der Tooltip-Schrift: "; -- Sensity
	TITAN_UISCALE_TOOLTIP_DISABLE_TEXT = "Off";
	TITAN_UISCALE_TOOLTIP_DISABLE_TOOLTIP = "Titan's Tooltip-Schriftskalierung abschalten";
	TITAN_UISCALE_TOOLTIP_HINT1 = "Hinweis: Links-Klick um die Skalierung";
	TITAN_UISCALE_TOOLTIP_HINT2 = "der Leiste oder des Spielinterfaces anzupassen."; -- Sensity
	TITAN_UISCALE_CONTROL_TOOLTIP_UI = "Skalierung des Interfaces: ";
	TITAN_UISCALE_CONTROL_TOOLTIP_PANEL = "Skalierung der TitanLeiste: ";
	TITAN_UISCALE_CONTROL_TOOLTIP_BUTTON = "Button Abstand: "; -- Sensity
	TITAN_UISCALE_CONTROL_TOOLTIP_TOOLTIPTRANS = "Tooltip Transparenz: "; -- Sensity
	TITAN_UISCALE_CONTROL_TOOLTIP_TOOLTIPFONT = "Skalierung der Tooltip-Schrift: "; -- Sensity
	TITAN_UISCALE_CONTROL_TITLE_UI = "UI-Skalierung"; -- Sensity
	TITAN_UISCALE_CONTROL_TITLE_PANEL = "Leistenskal."; -- Sensity
	TITAN_UISCALE_CONTROL_TITLE_BUTTON = "Button Abstand"; -- Sensity
	TITAN_UISCALE_CONTROL_TITLE_TOOLTIPTRANS = "Tooltip Transparenz";
	TITAN_UISCALE_CONTROL_TITLE_TOOLTIPFONT = "Tooltip Schrift";
	TITAN_UISCALE_CONTROL_HIGH_UI = "100%";
	TITAN_UISCALE_CONTROL_HIGH_PANEL = "125%";
	TITAN_UISCALE_CONTROL_HIGH_BUTTON = "100%";
	TITAN_UISCALE_CONTROL_HIGH_TOOLTIPTRANS = "100%";
	TITAN_UISCALE_CONTROL_HIGH_TOOLTIPFONT = "130%";
	TITAN_UISCALE_CONTROL_LOW_UI = "64%";
	TITAN_UISCALE_CONTROL_LOW_PANEL = "75%";
	TITAN_UISCALE_CONTROL_LOW_BUTTON = "6%";
	TITAN_UISCALE_CONTROL_LOW_TOOLTIPTRANS = "0%";
	TITAN_UISCALE_CONTROL_LOW_TOOLTIPFONT = "50%";
	TITAN_UISCALE_MENU_TEXT = "UI/Leiste/Schrift Skalierung";

 	TITAN_VOLUME_TOOLTIP = "Lautst\195\164rke einstellen";
  	TITAN_VOLUME_MASTER_TOOLTIP_VALUE = "Gesamtlautst\195\164rke: "; -- Sensity
  	TITAN_VOLUME_SOUND_TOOLTIP_VALUE = "Effektlautst\195\164rke: "; -- Sensity
  	TITAN_VOLUME_AMBIENCE_TOOLTIP_VALUE = "Umgebungslautst\195\164rke: "; -- Sensity
  	TITAN_VOLUME_MUSIC_TOOLTIP_VALUE = "Musiklautst\195\164rke: "; -- Sensity
  	TITAN_VOLUME_MICROPHONE_TOOLTIP_VALUE = "Mikrofonlautst\195\164rke: "; -- Sensity
  	TITAN_VOLUME_SPEAKER_TOOLTIP_VALUE = "Lautsprecherlaust\195\164rke: "; -- Sensity
  	TITAN_VOLUME_TOOLTIP_HINT1 = "Hinweis: Links-Klick um die";
  	TITAN_VOLUME_TOOLTIP_HINT2 = "Lautst\195\164rke anzupassen.";
  	TITAN_VOLUME_CONTROL_TOOLTIP = "Lautst\195\164rke: ";
  	TITAN_VOLUME_CONTROL_TITLE = "Lautst\195\164rke";
  	TITAN_VOLUME_MASTER_CONTROL_TITLE = "Gesamt";
  	TITAN_VOLUME_SOUND_CONTROL_TITLE = "Effekte";
 	TITAN_VOLUME_AMBIENCE_CONTROL_TITLE = "Umgebung";
  	TITAN_VOLUME_MUSIC_CONTROL_TITLE = "Musik";
  	TITAN_VOLUME_MICROPHONE_CONTROL_TITLE = "Mikrofon";
  	TITAN_VOLUME_SPEAKER_CONTROL_TITLE = "Lautsprecher";
  	TITAN_VOLUME_CONTROL_HIGH = "Laut";
  	TITAN_VOLUME_CONTROL_LOW = "Leise";
  	TITAN_VOLUME_MENU_TEXT = "Lautst\195\164rkeregler";

	TITAN_XP_FORMAT = "%d";
	TITAN_XP_PERCENT_FORMAT = TITAN_XP_FORMAT.." (%.1f%%)";
	TITAN_XP_BUTTON_LABEL_XPHR_LEVEL = "XP/Std (Level): ";
	TITAN_XP_BUTTON_LABEL_XPHR_SESSION = "XP/Std (Sitzung): ";
	TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_LEVEL = "Zeit bis Aufstieg (Level): ";
	TITAN_XP_BUTTON_LABEL_TOLEVEL_TIME_SESSION = "Zeit bis Aufstieg (Sitzung): ";
	TITAN_XP_TOOLTIP = "Info XP";
	TITAN_XP_TOOLTIP_TOTAL_TIME = "Spielzeit Gesamt: ";
	TITAN_XP_TOOLTIP_LEVEL_TIME = "Spielzeit dieses Levels: ";
	TITAN_XP_TOOLTIP_SESSION_TIME = "Spielzeit dieser Sitzung: ";
	TITAN_XP_TOOLTIP_TOTAL_XP = "Gesamt XP dieses Levels: ";
	TITAN_XP_TOOLTIP_LEVEL_XP = "XP erhalten dieses Levels: ";
	TITAN_XP_TOOLTIP_TOLEVEL_XP = "XP ben\195\182tigt bis Aufstieg: ";
	TITAN_XP_TOOLTIP_SESSION_XP = "XP erhalten diese Sitzung: ";
	TITAN_XP_TOOLTIP_XPHR_LEVEL = "XP/Std dieses Levels: ";
	TITAN_XP_TOOLTIP_XPHR_SESSION = "XP/Std dieser Sitzung: ";
	TITAN_XP_TOOLTIP_TOLEVEL_LEVEL = "Zeit bis Aufstieg (Levelrate): ";
	TITAN_XP_TOOLTIP_TOLEVEL_SESSION = "Zeit bis Aufstieg (Sitzungsrate): ";
	TITAN_XP_MENU_TEXT = "XP";
	TITAN_XP_MENU_SHOW_XPHR_THIS_LEVEL = "Zeige XP/Std dieses Levels";
	TITAN_XP_MENU_SHOW_XPHR_THIS_SESSION = "Zeige XP/Std dieser Sitzung";
	TITAN_XP_MENU_RESET_SESSION = "Session Zur\195\188cksetzen";
  	TITAN_XP_MENU_REFRESH_PLAYED = "Spielzeit zur\195\188cksetzen"; -- Sensity
  
	TITAN_REGEN_MENU_TEXT 		= "Regeneration"
	TITAN_REGEN_MENU_TOOLTIP_TITLE	= "Regenerationsrate"
	TITAN_REGEN_MENU_SHOW1 		= "Zeigen" -- Sensity
	TITAN_REGEN_MENU_SHOW2 		= "HP"
	TITAN_REGEN_MENU_SHOW3 		= "MP"
	TITAN_REGEN_MENU_SHOW4		= "Prozent" -- Sensity
	TITAN_REGEN_BUTTON_TEXT_HP 		= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_HP_PERCENT 	= "HP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_MP 		= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_BUTTON_TEXT_MP_PERCENT 	= " MP: "..HIGHLIGHT_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP1 		= "Gesundheit: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
	TITAN_REGEN_TOOLTIP2 		= "Mana: \t"..GREEN_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." / " ..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..RED_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE..")";
	TITAN_REGEN_TOOLTIP3 		= "Beste HP Regeneration: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP4 		= "Schlechteste HP Regeneration: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP5 		= "Beste MP Regeneration: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP6 		= "Schlechteste MP Regeneration: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE;
	TITAN_REGEN_TOOLTIP7		= "MP Regeneration letzter Kampf: \t"..HIGHLIGHT_FONT_COLOR_CODE.."%d"..FONT_COLOR_CODE_CLOSE.." ("..GREEN_FONT_COLOR_CODE.."%.2f"..FONT_COLOR_CODE_CLOSE.."%%)";

	TITAN_ITEMBONUSES_TEXT = "Gegenstandsboni";
	TITAN_ITEMBONUSES_DISPLAY_NONE = "Keine Anzeige";
	TITAN_ITEMBONUSES_SHORTDISPLAY = "Kurze Beschriftung";
	TITAN_ITEMBONUSES_BONUSSCANNER_MISSING = "BonusScanner-AddOn erforderlich"; --Sensity
	
	TITAN_ITEMBONUSES_CAT_ATT = "Attribute";
	TITAN_ITEMBONUSES_CAT_RES = "Widerstand";
	TITAN_ITEMBONUSES_CAT_SKILL = "Fertigkeiten";
	TITAN_ITEMBONUSES_CAT_BON = "Nah- und Fernkampf";
	TITAN_ITEMBONUSES_CAT_SBON = "Zauber";
	TITAN_ITEMBONUSES_CAT_OBON = "Leben und Mana";
	TITAN_ITEMBONUSES_CAT_EBON = "Spezielle F\195\164higkeiten"; -- Sensity

	--Titan Repair
	REPAIR_LOCALE = {
		pattern = "^Haltbarkeit (%d+) / (%d+)$",
		menu = "Reparieren",
		tooltip = "Haltbarkeits Info",
		button = "Haltbarkeit: ",
		normal = "Reparaturkosten (Normal): ",
		friendly = "Reparaturkosten (freundlich): ", -- SENSITIY
		honored = "Reparaturkosten (wohlwollend): ", -- SENSITIY
		revered = "Reparaturkosten (respektvoll): ", -- SENSITIY
		exalted = "Reparaturkosten (ehrf\195\188rchtig): ", -- SENSITIY
		buttonNormal = "Zeige normal",
		buttonFriendly = "Zeige freundlich (5%)", -- SENSITIY
		buttonHonored = "Zeige wohlwollend (10%)", -- SENSITIY
		buttonRevered = "Zeige respektvoll (15%)", -- SENSITIY
		buttonExalted = "Zeige ehrf\195\188rchtig (20%)", -- SENSITIY
		percentage = "Prozent anzeigen",
		itemname = "Besch\195\164digte Gegenst\195\164nde anzeigen",
		undamaged = "Unbesch\195\164digte Gegenst\195\164nde anzeigen",
		discount = "Rabatt", -- Sensity
		nothing = "Nichts besch\195\164digt",
		confirmation = "Wollt Ihr alles reparieren lassen?",
		badmerchant = "Dieser H/195/164/ndler kann nicht reparieren. Es werden nur normale Reparaturkosten angezeigt.", -- SENSITIY
		popup = "Zeige Reparieren-Popup", -- SENSITIY
		showinventory  = "Kalkuliere Inventar-Besch\195\164digung",
		WholeScanInProgress  = "Updating...",
		AutoReplabel = "Automatische Reparatur", -- SENSITIY
		AutoRepitemlabel = "Automatische Reparatur aller Gegenst/195/164/nde", -- SENSITIY

	};

	TITAN_PLUGINS_MENU_TITLE = "Plugins";

	CUSTOMIZATION_FEATURE_COMING_SOON = "Funktionen zur Anpassung kommen bald...";
end