-- FILE: \Levels\Salle_Eau.lua
require("Levels\\HUD")
require("Levels\\valves")

LevelFuncs.LireJournalSalleLeviers = function(activator)
    if (LevelFuncs.Engine.Node.TestInventoryItem(TEN.Objects.ObjID.DIARY_ITEM)) then
        LevelFuncs.Engine.Node.DisplaySprite(TEN.Objects.ObjID.DIARY_SPRITES, 0, TEN.Color(255,255,255), 50, 50, 0, 100, 100, 0, 0, 0, 0)

        LevelFuncs.Engine.Node.DrawText(
            "MAINTENANCE LOG: FILTRATION\n\n" ..
            "The raw water is ready. To engage the\n" ..
            "filters, pull the levers to deploy\n" ..
            "each layer in the correct order:\n\n" ..
            "YELLOW: Pull to drop Coarse Gravel.\n" ..
            "GREEN:  Pull to layer Fine Sand.\n" ..
            "RED:    Pull to activate Carbon.\n" ..
            "BLUE:   Pull to engage Micro-Mesh.",
            30,    -- X : centre
            20,    -- Y : position haute
            0.9,   -- Échelle (un peu réduit pour que tout rentre)
            0,     -- Rotation
            TEN.Color(70, 40, 20), -- Brun foncé style encre ancienne
            1,     -- Opacité
            1      -- Centré
        )
    end
end

-- mini jeu de la salle
function MiniGameFilter()
   -- Titre du mini‑jeu
    local titleStr = DisplayString(
        "Mini-game 2 : Capture the water\n" ..
        "(step 1 of the water network)",
        Vec2(300, 25), 
        1,
        Color(112, 227, 255),
        false,
        { TEN.Strings.DisplayStringOption.SHADOW,
          TEN.Strings.DisplayStringOption.CENTER }
    )
    ShowString(titleStr, 0.1)

end

-- Initialisation des variables de mémoire (0 = fermé, 1 = ouvert)
LevelVars.VanneA_faite = 0
LevelVars.VanneB_faite = 0
LevelVars.VanneC_faite = 0
LevelVars.VanneD_faite = 0
LevelVars.VanneE_faite = 0
LevelVars.VanneF_faite = 0

-- FONCTION GÉNÉRIQUE AMÉLIORÉE
local function ActualiserVanne(nom, varName, conditionOK, flipID, msgSuccess)
    -- On lit directement la valeur actuelle (0 ou 1) dans LevelVars
    local estOuverte = (LevelVars[varName] == 1)
    
    if not estOuverte then
        -- ÉTAPE : ON PASSE À L'OUVERTURE
        LevelVars[varName] = 1
        if conditionOK then
            LevelFuncs.Engine.Node.ToggleFlipMap(flipID)
            LevelFuncs.Engine.Node.DrawTextForTimespan(3, msgSuccess or (nom .. " : Water flowing"), 50, 90, 1, 3, TEN.Color(0,187,94), 1, 1)
        else
            LevelFuncs.Engine.Node.DrawTextForTimespan(3, nom .. " : Open (But no pression...)", 50, 90, 1, 3, TEN.Color(255,165,0), 1, 1)
        end
    else
        -- ÉTAPE : ON PASSE À LA FERMETURE
        LevelVars[varName] = 0
        -- On ne désactive le FlipMap que si la pression était là
        if conditionOK then 
            LevelFuncs.Engine.Node.ToggleFlipMap(flipID) 
        end
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, nom .. " : Closed", 50, 90, 1, 3, TEN.Color(255,85,85), 1, 1)
    end
end
-- 1. VANNE A : Source principale, s'ouvre sans condition
LevelFuncs.VanneA = function()
    LevelFuncs.Engine.Node.DrawText("Valve A", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        ActualiserVanne("Valve A", "VanneA_faite", true, 0)
    end
end

-- 2. VANNE C : Dépend de A
LevelFuncs.VanneC = function()
    LevelFuncs.Engine.Node.DrawText("Valve C", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        local condA = (LevelVars.VanneA_faite == 1)
        ActualiserVanne("Valve C", "VanneC_faite", condA, 2, "Water flowing : continous circuit")
    end
end

-- 3. VANNE E : Dépend de A
LevelFuncs.VanneE = function()
    LevelFuncs.Engine.Node.DrawText("Valve E", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        local condA = (LevelVars.VanneA_faite == 1)
        ActualiserVanne("Valve E", "VanneE_faite", condA, 1)
    end
end

-- 4. VANNE B : Dépend de C
LevelFuncs.VanneB = function()
    LevelFuncs.Engine.Node.DrawText("Valve B", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        local condC = (LevelVars.VanneC_faite == 1)
        ActualiserVanne("Valve B", "VanneB_faite", condC, 3)
    end
end

-- 5. VANNE D : Dépend de C
LevelFuncs.VanneD = function()
    LevelFuncs.Engine.Node.DrawText("Valve D", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        local condC = (LevelVars.VanneC_faite == 1)
        ActualiserVanne("Valve D", "VanneD_faite", condC, 4)
    end
end

-- 6. VANNE F : Dépend de C
LevelFuncs.VanneF = function()
    LevelFuncs.Engine.Node.DrawText("Valve F", 50, 80, 1, 3, TEN.Color(255,255,255), 1.5, 1)
    if LevelFuncs.Engine.Node.KeyIsHit(11) then
        local condC = (LevelVars.VanneC_faite == 1)
        ActualiserVanne("Valve F", "VanneF_faite", condC, 5, "Water flowing : continous circuit")
    end
end
	
	
-- On crée une variable au début du script (hors de la fonction)
LevelVars.MessageSuccessAffiche = false

LevelFuncs.minigame2_success = function(activator)
    -- On vérifie les FlipMaps ET si le message n'a pas encore été montré
    if LevelFuncs.Engine.Node.GetFlipMapStatus(0) 
       and LevelFuncs.Engine.Node.GetFlipMapStatus(2) 
       and LevelFuncs.Engine.Node.GetFlipMapStatus(5) 
       and not LevelVars.MessageSuccessAffiche then

        -- On affiche le texte pendant 5 secondes
        LevelFuncs.Engine.Node.DrawTextForTimespan(5, "Congrats! You've completed mini-game 2! Water captation is done!", 50, 30, 1, 3, TEN.Color(0,170,43), 1, 1)
        AddMinigameSuccess() 
        -- On verrouille pour ne plus repasser ici
        LevelVars.MessageSuccessAffiche = true
    end
end
	
	
-- VARIABLES DE PROGRESSION 
LevelVars.FilterProgress = 0
LevelVars.FilterComplete = false

-- 1. LEVIER JAUNE (Départ)
LevelFuncs.LeverYellow = function(activator)
    if LevelVars.FilterComplete then return end
    
    if LevelVars.FilterProgress == 0 then
        LevelVars.FilterProgress = 1
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Yellow Lever  successfully activated", 50, 40, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Wrong sequence! Resetting filters...", 50, 40, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- 2. LEVIER VERT
LevelFuncs.LeverGreen = function(activator)
    if LevelVars.FilterComplete then return end

    if LevelVars.FilterProgress == 1 then
        LevelVars.FilterProgress = 2
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Lever Green successfully activated", 50, 40, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Wrong sequence! Resetting filters...", 50, 40, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- 3. LEVIER ROUGE
LevelFuncs.LeverRed = function(activator)
    if LevelVars.FilterComplete then return end

    if LevelVars.FilterProgress == 2 then
        LevelVars.FilterProgress = 3
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Lever Red successfully activated", 50, 40, 1, 3, TEN.Color(255, 255, 255), 1, 1)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Wrong sequence! Resetting filters...", 50, 40, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end

-- 4. LEVIER BLEU (Condition de Victoire)
LevelFuncs.LeverBlue = function(activator)
    if LevelVars.FilterComplete then return end

    if LevelVars.FilterProgress == 3 then
        LevelVars.FilterProgress = 4
        LevelVars.FilterComplete = true -- On bloque le jeu ici
        LevelFuncs.Engine.Node.DrawTextForTimespan(5, "Congrats! You've finished mini-game 3! Water filtration is done!", 50, 50, 1, 3, TEN.Color(0, 255, 0), 1, 1)
        AddMinigameSuccess() 
        TEN.Audio.PlayAudioTrack("006", 0)
    else
        LevelVars.FilterProgress = 0
        LevelFuncs.Engine.Node.DrawTextForTimespan(3, "Wrong sequence! Resetting filters...", 50, 40, 1, 3, TEN.Color(255, 0, 0), 1, 1)
    end
end


LevelFuncs.OnStart = function()
    InitHUD()
end

LevelFuncs.OnLoop = function()
    MiniGameFilter()
    UpdateHUD()
    
end

-- Fonctions système obligatoires
LevelFuncs.OnLoad = function() end
LevelFuncs.OnEnd = function() end
LevelFuncs.OnUseItem = function() end
LevelFuncs.OnFreeze = function() end