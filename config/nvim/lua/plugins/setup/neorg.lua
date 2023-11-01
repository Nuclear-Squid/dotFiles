require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {}, -- Adds pretty icons to your documents
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    polytech = "~/Work/PolyCours",
                    -- notes = "~/Code/lang-initiation/Norg",
                    -- microcontroleurs = "~/Code/Polytech/S5/MicroControleurs",
                    -- communication_profesionelle = "~/Work/PolyCours/3A/CommPro"
                },
            },
        },
        ["core.export"] = {},
        ["core.export.markdown"] = {
            config = {
                extensions = "all",
            },
        },
    }
}
