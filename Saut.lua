-- ============================================================
--  Levels/Saut.lua  –  Salle parkour aquatique
--  Mini-game 4 : Hydro-Acrobatics
-- ============================================================

LevelVars.ParkourFinished = LevelVars.ParkourFinished or false

-- ── Titre affiché en jeu ───────────────────────────────────
function MiniGameJump()
    if LevelVars.CurrentRoom ~= "saut" then return end
    if LevelVars.ParkourFinished then return end
    local titleStr = DisplayString(
        "Mini-game 3 : Hydro-Acrobatics", 
        Vec2(235, 25),
        1,
        Color(112, 227, 255),
        false,
        { TEN.Strings.DisplayStringOption.SHADOW,
          TEN.Strings.DisplayStringOption.CENTER }
    )
    ShowString(titleStr, 0.1)
end

-- ── Vérification de victoire (ramassage de la clé) ─────────
function CheckParkourVictory()
    if LevelVars.ParkourFinished then return end

    if TEN.Inventory.GetItemCount(TEN.Objects.ObjID.KEY_ITEM5) > 0 then
        local bravoStr = DisplayString(
            "Bravo! You've completed the parkour\nand found the important item!",
            Vec2(512, 400),
            1.2,
            Color(255, 215, 0),
            false,
            { TEN.Strings.DisplayStringOption.CENTER,
              TEN.Strings.DisplayStringOption.SHADOW }
        )
        ShowString(bravoStr, 5.0)

        AddMinigameSuccess()
        LevelFuncs.Engine.Node.PlayAudioTrack("069", 0)
        LevelVars.ParkourFinished = true
    end
end

-- ══════════════════════════════════════════════════════════
--  Points d'entrée appelés par Water_Engine_v0.lua
-- ══════════════════════════════════════════════════════════
function Saut_Init()
    -- rien à initialiser de spécifique pour cette salle pour l'instant
end

function Saut_Loop()
    MiniGameJump()
    CheckParkourVictory()
end