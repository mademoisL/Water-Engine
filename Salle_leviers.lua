-- ============================================================
--  Levels/salle_leviers.lua  –  Mini-game 3 : Water filtration
--  Séquence de leviers : Jaune → Vert → Rouge → Bleu
-- ============================================================

LevelVars.FilterProgress = LevelVars.FilterProgress or 0
LevelVars.FilterComplete  = LevelVars.FilterComplete  or false

-- ── Titre affiché en jeu ───────────────────────────────────
function MiniGameFiltration()
    if LevelVars.CurrentRoom ~= "salle_leviers" then return end
    local titleStr = DisplayString(
        "Mini-game 4 : Water filtration & treatment\n(step 2 of the water network)",
        Vec2(330, 25),
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
function SalleLeviers_Init() end

function SalleLeviers_Loop()
    MiniGameFiltration()
end