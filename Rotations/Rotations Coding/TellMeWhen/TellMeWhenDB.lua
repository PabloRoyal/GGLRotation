TellMeWhenDB = {
    ["Version"] = 11002,  -- TellMeWhen Version 11.0.2
    ["global"] = {
        ["TextLayouts"] = {
            ["bar2"] = {},
            ["TMW:textlayout:1TMvg5InaYOw"] = {},
            ["TMW:textlayout:1RkGJEN4L5o_"] = {},
            ["icon1"] = {},
            ["TMW:textlayout:1RFt2HZe_Cbk"] = {},
            ["TMW:textlayout:1S6ieoFev4r0"] = {},
            ["TMW:textlayout:1FYkfpegTiCv"] = {},
            ["TMW:textlayout:1ubsdH6epahK"] = {},
            ["TMW:textlayout:1Rh4g1a95U6F"] = {},
        },
        ["CodeSnippets"] = {
            ["Paladin Protection Rotation"] = [[
                -- Dein spezifisches Lua-Rotationsskript hier einfügen
                -- Dieser Abschnitt enthält die Funktionen und Logiken, die zur Steuerung der Paladin-Rotation verwendet werden.
            ]],
        },
    },
    ["profiles"] = {
        ["[ZakLL] Paladin"] = {
            ["Locked"] = true,
            ["Version"] = 11002,
            ["Groups"] = {
                {
                    ["GUID"] = "TMW:group:ProtPaladin", -- Ersetzen mit einer eindeutigen ID für diese Gruppe
                    ["Point"] = {
                        ["y"] = -20,
                        ["x"] = 0,
                        ["point"] = "CENTER",
                        ["relativePoint"] = "CENTER",
                    },
                    ["Icons"] = {
                        {
                            ["Type"] = "cooldown",
                            ["Name"] = "Shield of the Righteous",
                            ["GUID"] = "TMW:icon:1JNYe6jYziVL1", -- Einzigartige ID für das Icon
                            ["SettingsPerView"] = {
                                ["icon"] = {
                                    ["TextLayout"] = "TMW:textlayout:Icon1",
                                },
                            },
                            ["Enabled"] = true,
                            ["Conditions"] = {
                                -- Bedingungen für das Anzeigen dieses Icons
                                {
                                    ["Type"] = "BUFFDURATION",
                                    ["Name"] = "Avenging Wrath",
                                    ["Operator"] = ">",
                                    ["Level"] = 0,
                                    ["Unit"] = "player",
                                },
                            },
                        },
                        {
                            ["Type"] = "cooldown",
                            ["Name"] = "Avenging Wrath",
                            ["GUID"] = "TMW:icon:1ABCDExample", -- Einzigartige ID für das Icon
                            ["SettingsPerView"] = {
                                ["icon"] = {
                                    ["TextLayout"] = "TMW:textlayout:Icon2",
                                },
                            },
                            ["Enabled"] = true,
                            ["Conditions"] = {
                                -- Bedingungen für das Anzeigen dieses Icons
                                {
                                    ["Type"] = "HEALTH",
                                    ["Operator"] = "<",
                                    ["Level"] = 70,
                                    ["Unit"] = "player",
                                },
                            },
                        },
                        -- Füge weitere Icons hinzu, basierend auf deiner Paladin-Rotation und den spezifischen Fähigkeiten
                    },
                },
            },
        },
    },
}
