-- ============================================================
--  Levels/salle_vannes.lua  –  Mini-game 2 : Capture the water
--  Réseau de vannes (A → C/E → B/D/F)
-- ============================================================

-- ── État des vannes (0 = fermée, 1 = ouverte) ─────────────
LevelVars.VanneA_faite = LevelVars.VanneA_faite or 0
LevelVars.VanneB_faite = LevelVars.VanneB_faite or 0
LevelVars.VanneC_faite = LevelVars.VanneC_faite or 0
LevelVars.VanneD_faite = LevelVars.VanneD_faite or 0
LevelVars.VanneE_faite = LevelVars.VanneE_faite or 0
LevelVars.VanneF_faite = LevelVars.VanneF_faite or 0
LevelVars.MessageSuccessAffiche = LevelVars.MessageSuccessAffiche or false

-- ── Fonction générique ─────────────────────────────────────
-- nom        : label affiché ("Valve A", etc.)
-- varName    : clé dans LevelVars ("VanneA_faite", etc.)
-- conditionOK: booléen – la vanne en amont est-elle ouverte ?
-- flipID     : index du FlipMap à basculer
-- msgSuccess : texte optionnel de succès
function ActualiserVanne(nom, varName, conditionOK, flipID, msgSuccess)
    local estOuverte = (LevelVars[varName] == 1)

    if not estOuverte then
        -- Ouverture
        LevelVars[varName] = 1
        if conditionOK then
            LevelFuncs.Engine.Node.ToggleFlipMap(flipID)
            LevelFuncs.Engine.Node.DrawTextForTimespan(
                3, msgSuccess or (nom .. " : Water flowing"),
                50, 90, 1, 3, TEN.Color(0, 187, 94), 1, 1)
        else
            LevelFuncs.Engine.Node.DrawTextForTimespan(
                3, nom .. " : Open (But no pressure...)",
                50, 90, 1, 3, TEN.Color(255, 165, 0), 1, 1)
        end
    else
        -- Fermeture
        LevelVars[varName] = 0
        if conditionOK then
            LevelFuncs.Engine.Node.ToggleFlipMap(flipID)
        end
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, nom .. " : Closed",
            50, 90, 1, 3, TEN.Color(255, 85, 85), 1, 1)
    end
end

-- ── Titre affiché en jeu ───────────────────────────────────
function MiniGameCaptureWater()
    if LevelVars.CurrentRoom ~= "salle_vannes" then return end
    local titleStr = DisplayString(
        "Mini-game 2 : Capture the water\n(step 1 of the water network)",
        Vec2(240, 25),
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
function SalleVannes_Init() end

function SalleVannes_Loop()
    MiniGameCaptureWater()
end
