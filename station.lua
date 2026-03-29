-- ============================================================
--  Levels/station.lua  –  Salle de réorientation des eaux usées
--  Mini-game 5 : Redirect the used waters
-- ============================================================

function MiniGameStation()
    if LevelVars.CurrentRoom ~= "station" then return end
    local titleStr = DisplayString(
        "Mini-game 5 : Redirect the used waters",
        Vec2(255, 25),
        1,
        Color(112, 227, 255),
        false,
        { TEN.Strings.DisplayStringOption.SHADOW,
          TEN.Strings.DisplayStringOption.CENTER }
    )
    ShowString(titleStr, 0.1)
end

-- ══════════════════════════════════════════════════════════
--  Points d'entrée appelés par Water_Engine_v0.lua
-- ══════════════════════════════════════════════════════════
function Station_Init()
    -- rien à initialiser de spécifique pour cette salle pour l'instant
end

function Station_Loop()
    MiniGameStation()
end