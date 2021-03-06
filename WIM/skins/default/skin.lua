-- Custom Skin handlers (In this situation, this must be declared before the skin table. If loaded after, it would not have a chance to load and an error would be thrown.)
local function formatDetails(guild, level, race, class)
    if(guild ~= "") then
	guild = "<"..guild.."> ";
    end
    return "|cffffffff"..guild..level.." "..race.." "..class.."|r";
end





--Default window skin
local WIM_ClassicSkin = {
    title = "WIM Classic",
    version = "1.0.0",
    author = "Pazza [Bronzebeard]",
    website = "http://www.wimaddon.com",
    default_style = "default",
    default_font = "ChatFontNormal",
    smart_style = nil, -- acknowledge that this parameter exists although not needed.
    styles = {
        default = "Default",
        blue = "Blue",
        green = "Green",
        red = "Red",
        yellow = "Yellow"
    },
    message_window = {
        file = {
            default = "Interface\\AddOns\\WIM\\skins\\default\\message_window",
            blue = "Interface\\AddOns\\WIM\\skins\\default\\message_window_blue",
            green = "Interface\\AddOns\\WIM\\skins\\default\\message_window_green",
            red = "Interface\\AddOns\\WIM\\skins\\default\\message_window_red",
            yellow = "Interface\\AddOns\\WIM\\skins\\default\\message_window_yellow"
        },
        rect = {
            top_left = {
                size = {
                    x = 64,
                    y = 64,
                },
                offset = {
                    x = 0,
                    y = 0
                },
                texture_coord = {0, 0, 0, .25, .25, 0, .25, .25}
            },
            top_right = {
                size = {
                    x = 64,
                    y = 64,
                },
                offset = {
                    x = 0,
                    y = 0
                },
                texture_coord = {.75, 0, .75, .25, 1, 0, 1, .25}
            },
            bottom_left = {
                size = {
                    x = 64,
                    y = 64,
                },
                offset = {
                    x = 0,
                    y = 0
                },
                texture_coord = {0, .75, 0, 1, .25, .75, .25, 1}
            },
            bottom_right = {
                size = {
                    x = 64,
                    y = 64,
                },
                offset = {
                    x = 0,
                    y = 0
                },
                texture_coord = {.75, .75, .75, 1, 1, .75, 1, 1}
            },
            top = {
                texture_coord = {.25, 0, .25, .25, .75, 0, .75, .25}
            },
            bottom = {
                texture_coord = {.25, .75, .25, 1, .75, .75, .75, 1}
            },
            left = {
                texture_coord = {0, .25, 0, .75, .25, .25, .25, .75}
            },
            right = {
                texture_coord = {.75, .25, .75, .75, 1, .25, 1, .75}
            },
            background = {
                texture_coord = {.25, .25, .25, .75, .75, .25, .75, .75}
            }
        },
        class_icon = {
            file = {
                default = "Interface\\AddOns\\WIM\\skins\\default\\class_icons",
                blue = "Interface\\AddOns\\WIM\\skins\\default\\class_icons",
                green = "Interface\\AddOns\\WIM\\skins\\default\\class_icons",
                red = "Interface\\AddOns\\WIM\\skins\\default\\class_icons",
                yellow = "Interface\\AddOns\\WIM\\skins\\default\\class_icons"
            },
            rect = {
                size = {
                    x = 64,
                    y = 64
                },
                anchor = "TOPLEFT",
                offset = {
                    x = -10,
                    y = 12
                }
            },
            blank = {.5, .5, .5, .75, .75, .5, .75, .75},
            druid = {0, 0, 0, .25, .25, 0, .25, .25},
            hunter = {.25, 0, .25, .25, .5, 0, .5, .25},
            mage = {.5, 0, .5, .25, .75, 0, .75, .25},
            paladin = {.75, 0, .75, .25, 1, 0, 1, .25},
            priest = {0, .25, 0, .5, .25, .25, .25, .5},
            rogue = {.25, .25, .25, .5, .5, .25, .5, .5},
            shaman = {.5, .25, .5, .5, .75, .25, .75, .5},
            warlock = {.75, .25, .75, .5, 1, .25, 1, .5},
            warrior = {0, .5, 0, .75, .25, .5, .25, .75},
            gm = {.25, .5, .25, .75, .5, .5, .5, .75}
        },
        strings = {
            from = {
                rect = {
                    anchor = "TOPLEFT",
                    offset = {
                        x = 50,
                        y = -8
                    }
                },
                inherits_font = "GameFontNormalLarge"
            },
            char_info = {
                format = formatDetails,
                rect = {
                    anchor = "TOP",
                    offset = {
                        x = 0,
                        y = -30
                    }
                },
                inherits_font = "GameFontNormal",
                color = {1, 1, 1}
            }
        },
        buttons = {
            close = {
                NormalTexture = {
                    default = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
                    blue = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
                    green = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
                    red = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up",
                    yellow = "Interface\\Buttons\\UI-Panel-MinimizeButton-Up"
                },
                PushedTexture = {
                    default = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down",
                    blue = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down",
                    green = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down",
                    red = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down",
                    yellow = "Interface\\Buttons\\UI-Panel-MinimizeButton-Down"
                },
                HighlightTexture = {
                    default = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
                    blue = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
                    green = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
                    red = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight",
                    yellow = "Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight"
                },
                HighlightAlphaMode = "ADD",
                rect = {
                    size = {
                        x = 32,
                        y = 32,
                    },
                    anchor = "TOPRIGHT",
                    offset = {
                        x = 4,
                        y = 1
                    }
                }
            },
            history = {
                NormalTexture = {
                    default = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    blue = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    green = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    red = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    yellow = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up"
                },
                PushedTexture = {
                    default = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    blue = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    green = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    red = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    yellow = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up"
                },
                HighlightTexture = {
                    default = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    blue = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    green = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    red = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up",
                    yellow = "Interface\\Buttons\\UI-GuildButton-PublicNote-Up"
                },
                HighlightAlphaMode = "ADD",
                rect = {
                    size = {
                        x = 19,
                        y = 19
                    },
                    anchor = "TOPRIGHT",
                    offset = {
                        x = -28,
                        y = -6
                    }
                }
            },
            w2w = {
                NormalTexture = {
                    default = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    blue = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    green = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    red = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    yellow = "Interface\\AddOns\\WIM\\Images\\w2w.tga"
                },
                PushedTexture = {
                    default = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    blue = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    green = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    red = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    yellow = "Interface\\AddOns\\WIM\\Images\\w2w.tga"
                },
                HighlightTexture = {
                    default = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    blue = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    green = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    red = "Interface\\AddOns\\WIM\\Images\\w2w.tga",
                    yellow = "Interface\\AddOns\\WIM\\Images\\w2w.tga"
                },
                HighlightAlphaMode = "ADD",
                rect = {
                    size = {
                        x = 32,
                        y = 32
                    },
                    anchor = "TOPLEFT",
                    offset = {
                        x = -16,
                        y = 4
                    }
                }
            },
            chatting = {
                NormalTexture = {
                    default = "Interface\\GossipFrame\\PetitionGossipIcon",
                    blue = "Interface\\GossipFrame\\PetitionGossipIcon",
                    green = "Interface\\GossipFrame\\PetitionGossipIcon",
                    red = "Interface\\GossipFrame\\PetitionGossipIcon",
                    yellow = "Interface\\GossipFrame\\PetitionGossipIcon"
                },
                PushedTexture = {
                    default = "Interface\\GossipFrame\\PetitionGossipIcon",
                    blue = "Interface\\GossipFrame\\PetitionGossipIcon",
                    green = "Interface\\GossipFrame\\PetitionGossipIcon",
                    red = "Interface\\GossipFrame\\PetitionGossipIcon",
                    yellow = "Interface\\GossipFrame\\PetitionGossipIcon"
                },
                rect = {
                    size = {
                        x = 16,
                        y = 16
                    },
                    anchor = "TOPLEFT",
                    offset = {
                        x = 40,
                        y = -28
                    }
                }
            },
            scroll_up = {
                NormalTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up"
                },
                PushedTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down"
                },
                HighlightTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight"
                },
                DisabledTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Disabled"
                },
                HighlightAlphaMode = "ADD",
                rect = {
                    size = {
                        x = 32,
                        y = 32
                    },
                    anchor = "TOPRIGHT",
                    offset = {
                        x = -4,
                        y = -39
                    }
                }
            },
            scroll_down = {
                NormalTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up"
                },
                PushedTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down"
                },
                HighlightTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight",
                    green= "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight"
                },
                DisabledTexture = {
                    default = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled",
                    blue = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled",
                    green = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled",
                    red = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled",
                    yellow = "Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Disabled"
                },
                HighlightAlphaMode = "ADD",
                rect = {
                    size = {
                        x = 32,
                        y = 32
                    },
                    anchor = "BOTTOMRIGHT",
                    offset = {
                        x = -4,
                        y = 24
                    }
                }
            }
        },
        chat_display = {
            rect = {
                tl_offset = {
                    x = 24,
                    y = -46
                },
                br_offset = {
                    x = -38,
                    y = 39
                }
            }
        },
        msg_box = {
            font_height = 14,
            font_color = {1,1,1},
            rect = {
                tl_offset = {
                    x = 22,
                    y = 35
                },
                br_offset = {
                    x = -10,
                    y = 0
                }
            }
        },
        shortcuts = {
            verticle = true,
            inverted = false,
            button_size = 28,
            buffer = 132,
            rect = {
                anchor = "TOPRIGHT",
                offset = {
                    x = -30,
                    y = -95
                }
            }
        }
    },
    tab_strip = {
        rect = {
            anchor_points = {
                self = "BOTTOMLEFT",
                relative = "TOPLEFT"
            },
            offsets = {
                top = -4,
                margins = {
                    left = 38,
                    right = 15
                }
            }
        }
    },
    emoticons = {
        rect = {
            height = 0,
            width = 0, -- if left at 0, images will size according to font height.
            xoffset = 0,
            yoffset = 0
        },
        definitions = {
            [":)"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\smile.tga",
            [":-)"] = ":)",
            [":("] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\sad.tga",
            [":-("] = ":(",
            ["{beer}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\beer.tga",
            ["{drink}"] = "{beer}",
            [":D"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\biggrin.tga",
            [":-D"] = ":D",
            ["=D"] = ":D",
            ["=-D"] = ":D",
            [":]"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\blush.tga",
            [":-]"] = ":]",
            ["(u)"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\brokenheart.tga",
            ["</3"] = "(u)",
            ["{broken}"] = "(u)",
            ["{brokenheart}"] = "{broken}",
            ["':."] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\brow.tga",
            ["{brow}"] = "':.",
            ["':-."] = "':.",
            ["{coffee}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\coffee.tga",
            ["8)"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\cool.tga",
            ["8-)"] = "8)",
            [":'("] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\cry.tga",
            [":'-("] = ":'(",
            ["{ouch}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\doh.tga",
            [">:."] = "{ouch}",
            [">:-."] = "{ouch}",
            ["{dull}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\dull.tga",
            [":p"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\dumb.tga",
            [":P"] = ":p",
            [":-p"] = ":p",
            [":P"] = ":p",
            [":-P"] = ":p",
            [";p"] = ":p",
            [";P"] = ":p",
            [";-p"] = ":p",
            [";-P"] = ":p",
            ["O.o"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\speechless.tga",
            ["0.o"] = "O.o",
            ["o.O"] = "O.o",
            ["o.0"] = "O.o",
            [">:("] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\envy.tga",
            [">:-("] = ">:(",
            ["{flip}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\finger.tga",
            ["{finger}"] = "{flip}",
            ["nlm"] = "{flip}",
            ["{rose}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\flower.tga",
            ["{flower}"] = "{rose}",
            ["<-@"] = "{rose}",
            ["8|"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\glass.tga",
            ["8-|"] = "8|",
            ["{hi}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\hihi.tga",
            [":*"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\kiss.tga",
            [":-*"] = ":*",
            ["{kiss}"] = ":*",
            ["{martini}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\martini.tga",
            ["{mmm}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\mmm.tga",
            ["{butt}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\mooning.tga",
            ["{no}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\no.tga",
            ["O.O"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\ohh.tga",
            ["0.0"] = "O.O",
            ["=-o"] = "O.O",
            [":("] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\sad.tga",
            [":-("] = ":(",
            [":$"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\sealed.tga",
            [":-$"] = ":$",
            ["{smoke}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\smoke.tga",
            ["o_o"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\speechless.tga",
            ["0_o"] = "o_o",
            ["O_o"] = "o_o",
            ["O_O"] = "o_o",
            ["0_0"] = "o_o",
            ["{tired}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\tired.tga",
            ["{wasntme}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\wasntme.tga",
            ["{yes}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\yes.tga",
            ["{rock}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\rock.tga",
            ["lml"] = "{rock}",
            ["{drunk}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\drunk.tga",
            ["{ninja}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\ninja.tga",
            ["{angry}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\angry.tga",
            [">:o"] = "{angry}",
            [">:-o"] = "{angry}",
            [">:O"] = "{angry}",
            [">:-O"] = "{angry}",
            ["{heart}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\heart.tga",
            ["<3"] = "{heart}",
            ["{wink}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\wink.tga",
            [";)"] = "{wink}",
            [";-)"] = "{wink}",
            ["{eat}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\eat.tga",
            ["{pizza}"] = "{eat}",
            ["{drunk}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\drunk.tga",
            ["{devil}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\devil.tga",
            ["{callme}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\callme.tga",
            ["{boom}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\boom.tga",
            ["{explode}"] = "{boom}",
            ["{money}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\money.tga",
            ["$"] = "{money}",
            ["{evil}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\evil.tga",
            ["{flex}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\flex.tga",
            ["{strong}"] = "{flex}",
            ["{phone}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\phone.tga",
            ["{cell}"] = "{phone}",
            ["{puke}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\puke.tga",
            ["{barf}"] = "{puke}",
            ["{wait}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\wait.tga",
            ["{rain}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\rain.tga",
            ["{badday}"] = "{rain}",
            ["{zipper}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\zipper.tga",
            ["{zipped}"] = "{zipper}",
            ["{zip}"] = "{zipper}",
            ["{hi}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\hi.tga",
            ["{tired}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\tired.tga",
            ["{nervous}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\nervous.tga",
            ["{scared}"] = "{nervous}",
            ["{smoke}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\smoke.tga",
            ["{cig}"] = "{smoke}",
            ["{angel}"] = "Interface\\AddOns\\WIM\\skins\\default\\Emoticons\\angel.tga",
            ["O:)"] = "{angel}",
        }
    }
};

----------------------------------------------------------
--                  Register Skin                       --
----------------------------------------------------------

WIM_RegisterSkin(WIM_ClassicSkin);