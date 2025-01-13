Scriptname MantellaMCM_MainSettings  Hidden 
{Mantella Main settings : hotkeys, timers, etc.}
; 
function Render(MantellaMCM mcm, MantellaRepository Repository) global
    ;This part of the MCM MainSettings script pretty much only serves to tell papyrus what button to display.
    mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
    LeftColumn(mcm, Repository)
    mcm.SetCursorPosition(1)
    RightColumn(mcm, Repository)
endfunction

function LeftColumn(MantellaMCM mcm, MantellaRepository Repository) global
    mcm.AddHeaderOption("Controls")
    mcm.oid_keymapMantellaAddToConversationHotkey = mcm.AddKeyMapOption("Start Conversation / Add to Conversation", repository.MantellaAddToConversationHotkey)
    mcm.oid_keymapPromptHotkey = mcm.AddKeyMapOption("Open Text Prompt", repository.MantellaOpenTextInputHotkey)
    mcm.oid_keymapEndHotkey = mcm.AddKeyMapOption("End Conversation", repository.MantellaEndHotkey)
    ; mcm.oid_keymapEndHotkey = mcm.AddKeyMapOption("Forget Last Message", repository.MantellaForgetLastMessageHotkey) ; commented out until it's implemented
    ; mcm.oid_keymapEndHotkey = mcm.AddKeyMapOption("Regen Last Response", repository.MantellaRegenLastMessageHotkey)
    mcm.oid_keymapCustomGameEventHotkey = mcm.AddKeyMapOption("Add Custom Game Event", repository.MantellaCustomGameEventHotkey)
    mcm.oid_keymapRadiantHotkey = mcm.AddKeyMapOption("Toggle Radiant Dialogue Shortcut", repository.MantellaRadiantHotkey) 
    mcm.oid_keymapOpenContextMenuHotkey = mcm.AddKeyMapOption("Open Context Menu", repository.MantellaOpenContextMenuHotkey)
    ; mcm.oid_keymapOpenIndividualContextMenuHotkey = mcm.AddKeyMapOption("Open Individual Context Menu", repository.MantellaOpenIndividualContextMenuHotkey)

    
    mcm.AddHeaderOption("Input Settings")
    mcm.oid_responsetimeslider=mcm.AddSliderOption ("Text Response Wait Time",repository.MantellaEffectResponseTimer)
    mcm.oid_microphoneEnabledToggle=mcm.AddToggleOption("Microphone Enabled", Repository.microphoneEnabled)
endfunction

function RightColumn(MantellaMCM mcm, MantellaRepository Repository) global
    ;This part of the MCM MainSettings script pretty much only serves to tell papyrus what button to display using properties from the repository

    mcm.AddHeaderOption("Radiant Dialogue")
    mcm.oid_radiantenabled = mcm.AddToggleOption("Enabled", repository.radiantEnabled)
    mcm.oid_radiantdistance = mcm.AddSliderOption("Trigger Distance",repository.radiantDistance)
    mcm.oid_radiantfrequency = mcm.AddSliderOption("Trigger Frequency",repository.radiantFrequency)

    mcm.AddHeaderOption("Debug")
    mcm.oid_endFlagMantellaConversationAll=mcm.AddToggleOption("End All Conversations (Fix Repeating NPCs)", Repository.endFlagMantellaConversationAll)
endfunction

function SliderOptionOpen(MantellaMCM mcm, int optionID, MantellaRepository Repository) global
    ; SliderOptionOpen is used to choose what to display when the user clicks on the slider
    if optionID==mcm.oid_responsetimeslider
        mcm.SetSliderDialogStartValue(repository.MantellaEffectResponseTimer)
        mcm.SetSliderDialogDefaultValue(30)
        mcm.SetSliderDialogRange(0, 5000)
        mcm.SetSliderDialogInterval(1)
    elseif optionID==mcm.oid_radiantdistance
        mcm.SetSliderDialogStartValue(repository.radiantDistance)
        mcm.SetSliderDialogDefaultValue(20)
        mcm.SetSliderDialogRange(1, 250)
        mcm.SetSliderDialogInterval(1)
    elseif optionID==mcm.oid_radiantfrequency
        mcm.SetSliderDialogStartValue(repository.radiantFrequency)
        mcm.SetSliderDialogDefaultValue(10)
        mcm.SetSliderDialogRange(5, 300)
        mcm.SetSliderDialogInterval(1)
    endif
endfunction

function SliderOptionAccept(MantellaMCM mcm, int optionID, float value, MantellaRepository Repository) global
    ;SliderOptionAccept is used to update the Repository with the user input (that input will then be used by the Mantella effect script
    If  optionId == mcm.oid_responsetimeslider
        mcm.SetSliderOptionValue(optionId, value)
        Repository.MantellaEffectResponseTimer=value
    elseif optionId == mcm.oid_radiantdistance
        mcm.SetSliderOptionValue(optionId, value)
        Repository.radiantDistance=value
        debug.MessageBox("Please save and reload for this change to take effect")
    elseif optionId == mcm.oid_radiantfrequency
        mcm.SetSliderOptionValue(optionId, value)
        Repository.radiantFrequency=value
        debug.MessageBox("Please save and reload for this change to take effect")
    endif
endfunction


function KeyMapChange(MantellaMCM mcm,Int option, Int keyCode, String conflictControl, String conflictName, MantellaRepository Repository) global
    ;This script is used to check if a key is already used, if it's not it will update to a new value (stored in MantellaRepository) or it will prompt the user to warn him of the conflict. The actual keybind happens in MantellaRepository
    if option == mcm.oid_keymapPromptHotkey || mcm.oid_keymapCustomGameEventHotkey || mcm.oid_keymapEndHotkey || mcm.oid_keymapRadiantHotkey || mcm.oid_keymapMantellaAddToConversationHotkey || mcm.oid_keymapOpenContextMenuHotkey || mcm.oid_keymapOpenIndividualContextMenuHotkey
        Bool continue = true
        ;below checks if there's already a bound key
        if conflictControl != ""
            String ConflitMessage
            if conflictName != ""
                ConflitMessage = "Key already mapped to:\n'" + conflictControl + "'\n(" + conflictName + ")\n\nAre you sure you want to continue?"
            else
                ConflitMessage = "Key already mapped to:\n'" + conflictControl + "'\n\nAre you sure you want to continue?"
            endif
            continue = mcm.ShowMessage(ConflitMessage, true, "$Yes", "$No")
        endIf
        if continue
            mcm.SetKeymapOptionValue(option, keyCode)
            ;selector to update the correct hotkey according to oid values
            if option == mcm.oid_keymapPromptHotkey 
                repository.BindPromptHotkey(keyCode)
            elseif option == mcm.oid_keymapEndHotkey
                repository.BindEndHotkey(keyCode)
            elseif option == mcm.oid_keymapCustomGameEventHotkey
                repository.BindCustomGameEventHotkey(keyCode)
            elseif option == mcm.oid_keymapRadiantHotkey
                repository.BindRadiantHotkey(keyCode)
            elseif option == mcm.oid_keymapMantellaAddToConversationHotkey
                repository.BindAddToConversationHotkey(keyCode)
            elseif option == mcm.oid_keymapOpenContextMenuHotkey
                repository.BindOpenContextMenuHotkey(keyCode)
            elseif option == mcm.oid_keymapOpenIndividualContextMenuHotkey
                repository.BindOpenIndividualContextMenuHotkey(keyCode)
            endif
        endIf
    endIf
endfunction

function OptionUpdate(MantellaMCM mcm, int optionID, MantellaRepository Repository) global
    ;checks option per option what the toggle is and the updates the variable/function repository MantellaRepository so the MantellaEffect and Repository Hotkey function can access it
    if optionID == mcm.oid_microphoneEnabledToggle
        Repository.microphoneEnabled =! Repository.microphoneEnabled
        mcm.SetToggleOptionValue(mcm.oid_microphoneEnabledToggle, Repository.microphoneEnabled)
        MiscUtil.WriteToFile("_pantella_microphone_enabled.txt", Repository.microphoneEnabled,  append=false)
        debug.MessageBox("Please restart Pantella and start a new conversation for this option to take effect")
    ; elseIf optionID == mcm.oid_debugNPCselectMode
    ;     Repository.NPCdebugSelectModeEnabled =! Repository.NPCdebugSelectModeEnabled
    ;     mcm.SetToggleOptionValue(mcm.oid_debugNPCselectMode, Repository.NPCdebugSelectModeEnabled)
    elseIf optionID == mcm.oid_radiantenabled
        repository.radiantEnabled =! repository.radiantEnabled
        mcm.SetToggleOptionValue(mcm.oid_radiantenabled, repository.radiantEnabled)
    elseIf optionID == mcm.oid_AllowForNPCtoFollowToggle
        Repository.AllowForNPCtoFollow =! Repository.AllowForNPCtoFollow
        mcm.SetToggleOptionValue(mcm.oid_AllowForNPCtoFollowToggle, Repository.AllowForNPCtoFollow)
        if (Repository.AllowForNPCtoFollow) == True 
            game.getplayer().addtofaction(Repository.giafac_AllowFollower)
        elseif (Repository.AllowForNPCtoFollow) == False
            game.getplayer().removefromfaction(Repository.giafac_AllowFollower)
        endif
    elseIf optionID == mcm.oid_NPCAngerToggle
        Repository.NPCAnger =! Repository.NPCAnger
        mcm.SetToggleOptionValue(mcm.oid_NPCAngerToggle, Repository.NPCAnger)
        if (Repository.NPCAnger) == True 
            game.getplayer().addtofaction(Repository.giafac_AllowAnger)
        elseif (Repository.NPCAnger) == False
            game.getplayer().removefromfaction(Repository.giafac_AllowAnger)
        endif
    elseif optionID==mcm.oid_endFlagMantellaConversationAll
        Repository.endFlagMantellaConversationAll=!Repository.endFlagMantellaConversationAll
        mcm.SetToggleOptionValue( mcm.oid_endFlagMantellaConversationAll, Repository.endFlagMantellaConversationAll)
        debug.messagebox("Terminating all conversations, close this menu for the change to take effect.")
    endif
endfunction

function EndAllConversations(MantellaMCM mcm,MantellaRepository Repository) global ; Ends all conversations with popups notifying the user
    MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
    Utility.wait(0.5)
    repository.endFlagMantellaConversationAll = false
    mcm.SetToggleOptionValue(mcm.oid_endFlagMantellaConversationAll, Repository.endFlagMantellaConversationAll)
    debug.messagebox("All ongoing conversations terminated. Restart Pantella. The next conversation might need to be started twice.")
Endfunction
function ForceEndAllConversations(MantellaRepository Repository) global ; Quietly ends all conversations
    MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
    Utility.wait(0.5)
    repository.endFlagMantellaConversationAll = false
Endfunction