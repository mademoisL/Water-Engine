-- ============================================================
--  Water_Engine_v0.lua  –  Script principal du niveau fusionné
--  Charge tous les modules et orchestre les callbacks uniques.
-- ============================================================

require("Levels\\HUD")
require("Levels\\New_Level")
require("Levels\\Salle_vannes")
require("Levels\\Salle_leviers")
require("Levels\\Saut")
require("Levels\\station")

-- ── Tracking de salle ─────────────────────────────────────
LevelVars.CurrentRoom = LevelVars.CurrentRoom or ""

-- CORRECTION : EnterRoom_NewLevel active aussi le collector
LevelFuncs.EnterRoom_NewLevel = function()
    LevelVars.CurrentRoom = "new_level"
    LevelVars.CollectorActive = true
end
LevelFuncs.EnterRoom_SalleVannes  = function() LevelVars.CurrentRoom = "salle_vannes"  end
LevelFuncs.EnterRoom_SalleLeviers = function() LevelVars.CurrentRoom = "salle_leviers" end
LevelFuncs.EnterRoom_Saut         = function() LevelVars.CurrentRoom = "saut"          end
LevelFuncs.EnterRoom_Station      = function() LevelVars.CurrentRoom = "station"       end
LevelFuncs.LeaveRoom              = function() LevelVars.CurrentRoom = ""              end

LevelFuncs.OnStart = function()
    InitHUD()
    NewLevel_Init()
    SalleVannes_Init()
    SalleLeviers_Init()
    Saut_Init()
    Station_Init()
end

LevelFuncs.OnLoop = function()
    UpdateHUD()
    NewLevel_Loop()
    SalleVannes_Loop()
    SalleLeviers_Loop()
    Saut_Loop()
    Station_Loop()
end


-- ── Vanne A : Source principale (pas de condition) ─────────
LevelFuncs.VanneA = function()
    LevelFuncs.Engine.Node.DrawText("Valve A", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve A", "VanneA_faite", true, 0)
    end
end

-- ── Vanne C : Dépend de A ──────────────────────────────────
LevelFuncs.VanneC = function()
    LevelFuncs.Engine.Node.DrawText("Valve C", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve C", "VanneC_faite",
            (LevelVars.VanneA_faite == 1), 2, "Water flowing : continuous circuit")
    end
end

-- ── Vanne E : Dépend de A ──────────────────────────────────
LevelFuncs.VanneE = function()
    LevelFuncs.Engine.Node.DrawText("Valve E", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve E", "VanneE_faite",
            (LevelVars.VanneA_faite == 1), 1)
    end
end

-- ── Vanne B : Dépend de C ──────────────────────────────────
LevelFuncs.VanneB = function()
    LevelFuncs.Engine.Node.DrawText("Valve B", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve B", "VanneB_faite",
            (LevelVars.VanneC_faite == 1), 3)
    end
end

-- ── Vanne D : Dépend de C ──────────────────────────────────
LevelFuncs.VanneD = function()
    LevelFuncs.Engine.Node.DrawText("Valve D", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve D", "VanneD_faite",
            (LevelVars.VanneC_faite == 1), 4)
    end
end

-- ── Vanne F : Dépend de C ──────────────────────────────────
LevelFuncs.VanneF = function()
    LevelFuncs.Engine.Node.DrawText("Valve F", 50, 80, 1, 3, TEN.Color(255, 255, 255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve F", "VanneF_faite",
            (LevelVars.VanneC_faite == 1), 5, "Water flowing : continuous circuit")
    end
end

-- ── Journal / carnet ──────────────────────────────────────
LevelFuncs.LireJournalSalleLeviers = function(activator)
    if LevelFuncs.Engine.Node.TestInventoryItem(TEN.Objects.ObjID.DIARY_ITEM) then
        LevelFuncs.Engine.Node.DisplaySprite(
            TEN.Objects.ObjID.DIARY_SPRITES, 0,
            TEN.Color(255, 255, 255), 50, 50, 0, 100, 100, 0, 0, 0, 0)
        LevelFuncs.Engine.Node.DrawText(
            "MAINTENANCE LOG: FILTRATION\n\n" ..
            "The raw water is ready. To engage the\n" ..
            "filters, pull the levers to deploy\n" ..
            "each layer in the correct order:\n\n" ..
            "YELLOW: Pull to drop Coarse Gravel.\n" ..
            "GREEN:  Pull to layer Fine Sand.\n" ..
            "RED:    Pull to activate Carbon.\n" ..
            "BLUE:   Pull to engage Micro-Mesh.",
            30, 20, 0.9, 0,
            TEN.Color(70, 40, 20), 1, 1)
    end
end

-- ── Condition de victoire (appelée par trigger Tomb Editor) ─
LevelFuncs.minigame2_success = function(activator)
    if LevelFuncs.Engine.Node.GetFlipMapStatus(0)
    and LevelFuncs.Engine.Node.GetFlipMapStatus(2)
    and LevelFuncs.Engine.Node.GetFlipMapStatus(5)
    and not LevelVars.MessageSuccessAffiche then
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            5, "Congrats! You've completed mini-game 2! Water captation is done!",
            50, 70, 1, 3, TEN.Color(0, 170, 43), 1, 1)
        AddMinigameSuccess()
        LevelVars.MessageSuccessAffiche = true
    end
end

-- ── Levier JAUNE (étape 1/4) ───────────────────────────────
LevelFuncs.LeverYellow = function(activator)
    if LevelVars.FilterComplete then return end
    if LevelVars.FilterProgress == 0 then
        LevelVars.FilterProgress = 1
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Yellow lever successfully activated",
            50, 80, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Wrong sequence! Resetting filters...",
            50, 80, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- ── Levier VERT (étape 2/4) ────────────────────────────────
LevelFuncs.LeverGreen = function(activator)
    if LevelVars.FilterComplete then return end
    if LevelVars.FilterProgress == 1 then
        LevelVars.FilterProgress = 2
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Green lever successfully activated",
            50, 80, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Wrong sequence! Resetting filters...",
            50, 80, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- ── Levier ROUGE (étape 3/4) ───────────────────────────────
LevelFuncs.LeverRed = function(activator)
    if LevelVars.FilterComplete then return end
    if LevelVars.FilterProgress == 2 then
        LevelVars.FilterProgress = 3
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Red lever successfully activated",
            50, 80, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Wrong sequence! Resetting filters...",
            50, 80, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- ── Levier BLEU (étape 4/4 – victoire) ────────────────────
LevelFuncs.LeverBlue = function(activator)
    if LevelVars.FilterComplete then return end

    local keyHole = GetMoveableByName("key_hole5_416")
    local keyUsed = false
    if keyHole and keyHole:GetStatus() == 2 then
        keyUsed = true
    end

    if LevelVars.FilterProgress == 3 then
        if keyUsed then
            LevelVars.FilterProgress = 4
            LevelVars.FilterComplete  = true
            LevelFuncs.Engine.Node.DrawTextForTimespan(
                5, "Congrats! You've finished mini-game 3! Water filtration is done!",
                50, 80, 1, 3, TEN.Color(0, 255, 0), 1, 1)
            AddMinigameSuccess()
            TEN.Audio.PlayAudioTrack("006", 0)
        else
            LevelFuncs.Engine.Node.DrawTextForTimespan(
                3, "The mechanism is locked... Insert the key first!",
                50, 90, 1, 3, TEN.Color(255, 165, 0), 1, 1)
        end
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(
            3, "Wrong sequence! Resetting filters...",
            50, 80, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- SALLE STATION (volume Inside)
LevelFuncs.minigame5success = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(5, "Congrats ! The sanitary station is successfully working !", 50, 90, 1, 3, TEN.Color(255,255,255), 1, 1)
	LevelFuncs.Engine.Node.PlayAudioTrack("006", 0)
	AddMinigameSuccess()
end

-- SALLE LEVIERS (on volume enter)
LevelFuncs.Traitementdeleau = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(5, "Lara : \"They left behind some chlorine and aluminum sulfate, but it was all sealed up.", 50, 85, 1, 1, TEN.Color(255,255,255), 1, 1)
	LevelFuncs.Engine.Node.DrawTextForTimespan(5, "\"I\'m glad I managed to get hold of the security key!\"", 50, 90, 1, 1, TEN.Color(255,255,255), 1, 1)
end

LevelFuncs.Traitementdeleaufait = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(5, "Lara : \"There we go, now the water will be treated for a while !\"", 50, 85, 1, 1, TEN.Color(0,255,0), 1, 1)
end

-- Village (volume inside)
LevelFuncs.dialogue_villageois_mere = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(10, "The Mother: \"The water doesn\'t look that polluted, but it\'s killing our children. Every sip is poison for them.\nMany died of cholera, dysentery, hepatitis A...\nMy daughter is suffering from a typhoid fever...but she is too weak to stand it. I\'m scared to lose her...\"\n", 2, 85, 0, 1, TEN.Color(255,220,100), 0.8, 1)
end

-- Village (volume inside)
LevelFuncs.dialogue_villageois_jeune = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(10, "The Young Man: \"The vandals have contaminated the basins and hidden the mechanisms... We\'re drinking mud and bacteria.\nAt your right : here is the entrance to the source, please help us ma\'am.\"", 2, 85, 0, 1, TEN.Color(255,220,100), 1, 1)
end

-- Village (volume inside)
LevelFuncs.dialogue_vieux = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(5, "The Elder: \"The government installed canals and pipes 10 years ago, just before the elections.\nIt was a fine promise on glossy paper.\nBut once the votes were counted, they never came back.\nNo maintenance, no follow-up... we were forgotten.\"", 2, 80, 0, 1, TEN.Color(255,220,100), 0.8, 1)
end

-- Village (volume enter)
LevelFuncs.fountainempty = function(activator)
	LevelFuncs.Engine.Node.DrawTextForTimespan(3.25, "Lara : \"Oh, the fountain is empty...\"", 50, 90, 1, 1, TEN.Color(212,227,255), 1, 1)
end

-- ── Téléportation via le puits ─────────────────────────────
LevelFuncs.TeleportationPuits = function(activator)
    local destination = GetMoveableByName("horus_statue_630")
    if destination then
        Lara:SetPosition(destination:GetPosition())
        Lara:SetRotation(destination:GetRotation())
    else
        print("Erreur : Le nom 'horus_statue_630' n'est pas reconnu !")
    end
end

LevelFuncs.OnLoad    = function() end
LevelFuncs.OnSave    = function() end
LevelFuncs.OnEnd     = function() end
LevelFuncs.OnUseItem = function() end
LevelFuncs.OnFreeze  = function() end