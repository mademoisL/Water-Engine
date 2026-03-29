-- ============================================================
--  Levels/HUD.lua  –  HUD partagé entre toutes les salles
--  Chargé UNE SEULE fois par Water_Engine_v0.lua (require cache).
-- ============================================================

-- Valeurs globales sauvegardées entre sessions
LevelVars.minigamesDone  = LevelVars.minigamesDone  or 0
LevelVars.minigamesTotal = LevelVars.minigamesTotal or 5
LevelVars.villageHealth  = LevelVars.villageHealth  or 25

local hudActive = false

function InitHUD()
    hudActive = true
end

function StopHUD()
    hudActive = false
end

function AddMinigameSuccess()
    LevelVars.minigamesDone = math.min(
        LevelVars.minigamesDone + 1,
        LevelVars.minigamesTotal
    )
    SetVillageHealth(LevelVars.villageHealth + 15)
end

function SetVillageHealth(percent)
    LevelVars.villageHealth = math.max(0, math.min(100, percent))
end

function UpdateHUD()
    if not hudActive then return end

    local basePos = Vec2(1250, 40)

    -- 1) Compteur de mini-jeux
    local done  = LevelVars.minigamesDone  or 0
    local total = LevelVars.minigamesTotal or 5
    local miniStr = DisplayString(
        string.format("Mini-games : %d/%d", done, total),
        basePos + Vec2(0, 0),
        1.1,
        Color(255, 220, 100),
        false,
        { TEN.Strings.DisplayStringOption.RIGHT,
          TEN.Strings.DisplayStringOption.SHADOW }
    )
    ShowString(miniStr, 0.05)

    -- 2) Santé du village
    local health = LevelVars.villageHealth or 25
    local healthColor
    if health >= 70 then
        healthColor = Color(0, 200, 0)
    elseif health >= 50 then
        healthColor = Color(230, 200, 0)
    else
        healthColor = Color(220, 60, 60)
    end

    local healthStr = DisplayString(
        string.format("Village's Health : %d%%", health),
        basePos + Vec2(0, 37),
        1.1,
        healthColor,
        false,
        { TEN.Strings.DisplayStringOption.RIGHT,
          TEN.Strings.DisplayStringOption.SHADOW }
    )
    ShowString(healthStr, 0.05)
end