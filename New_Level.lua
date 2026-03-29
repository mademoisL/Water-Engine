-- ============================================================
--  Levels/New_Level.lua  –  Salle ramassage des déchets
--  Mini-game 1 : Collect the trash
-- ============================================================

LevelVars.CollectorActive   = LevelVars.CollectorActive   or false
LevelVars.CollectorWin      = LevelVars.CollectorWin      or false
LevelVars.CollectorWinTimer = LevelVars.CollectorWinTimer or 0

-- ── Titre affiché en jeu ───────────────────────────────────
function MiniGameTrash()
    if LevelVars.CurrentRoom ~= "new_level" then return end
    if not LevelVars.CollectorActive or LevelVars.CollectorWinTimer > 150 then return end
    local titleStr = DisplayString(
        "Mini-game 1 : Collect the trash",
        Vec2(220, 25),
        1,
        Color(112, 227, 255),
        false,
        { TEN.Strings.DisplayStringOption.SHADOW,
          TEN.Strings.DisplayStringOption.CENTER }
    )
    ShowString(titleStr, 0.1)
end

-- ── HUD + logique de victoire ─────────────────────────────
local function UpdateCollectorHUD()
    if LevelVars.CurrentRoom ~= "new_level" then return end
    if not LevelVars.CollectorActive or LevelVars.CollectorWinTimer > 150 then return end

    local r = math.floor(TEN.Inventory.GetItemCount(TEN.Objects.ObjID.SHOTGUN_AMMO1_ITEM) / 6)
    local b = math.floor(TEN.Inventory.GetItemCount(TEN.Objects.ObjID.SHOTGUN_AMMO2_ITEM) / 6)
    local v = math.floor(TEN.Inventory.GetItemCount(TEN.Objects.ObjID.REVOLVER_AMMO_ITEM) / 6)
    local u = math.floor(TEN.Inventory.GetItemCount(TEN.Objects.ObjID.UZI_AMMO_ITEM)      / 30)

    local basePos = Vec2(20, 80)
    local items = {
        { name = "Deteriorating box", cur = r, max = 5 },
        { name = "Dirty tin cans",    cur = b, max = 5 },
        { name = "Garbage bags",      cur = v, max = 7 },
        { name = "Toxic barrels",     cur = u, max = 2 },
    }

    for i, item in ipairs(items) do
        local textColor = (item.cur >= item.max) and Color(0, 255, 0) or Color(255, 255, 255)
        local str = DisplayString(
            string.format("%s : %d/%d", item.name, item.cur, item.max),
            basePos + Vec2(0, (i - 1) * 35),
            1.0,
            textColor,
            false,
            { TEN.Strings.DisplayStringOption.SHADOW }
        )
        ShowString(str, 0.05)
    end

    -- Victoire : tous les objectifs atteints
    if r >= 5 and b >= 5 and v >= 7 and u >= 2 then
        local winMsg = DisplayString(
            "CLEANING COMPLETE - ACCESS GRANTED",
            Vec2(640, 500),
            1.2,
            Color(0, 255, 0),
            false,
            { TEN.Strings.DisplayStringOption.CENTER,
              TEN.Strings.DisplayStringOption.SHADOW }
        )
        ShowString(winMsg, 0.05)

        if not LevelVars.CollectorWin then
            LevelVars.CollectorWin = true
            AddMinigameSuccess()
            LevelFuncs.Engine.Node.PlayAudioTrack("069", 0)
            local porte = GetMoveableByName("door_type6_355")
            if porte then porte:Enable() end
        end

        LevelVars.CollectorWinTimer = LevelVars.CollectorWinTimer + 1
    end
end

-- ══════════════════════════════════════════════════════════
--  Points d'entrée appelés par Water_Engine_v0.lua
-- ══════════════════════════════════════════════════════════
function NewLevel_Init() end

function NewLevel_Loop()
    UpdateCollectorHUD()
    MiniGameTrash()
end