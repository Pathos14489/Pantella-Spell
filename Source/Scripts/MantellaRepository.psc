Scriptname MantellaRepository extends Quest  
Spell property MantellaSpell auto
Spell Property MantellaEndSpell auto
Faction Property giafac_Sitters  Auto ;gia
Faction Property giafac_Sleepers  Auto ;gia
Faction Property giafac_talktome  Auto ;gia
Faction Property giafac_AllowFollower  Auto ;gia
Faction Property giafac_AllowAnger  Auto ;gia
Faction Property giafac_AllowForgive  Auto ;gia
Faction Property giafac_AllowDialogue  Auto ;gia
Faction Property giafac_Following  Auto ;gia
Faction Property giafac_Mantella  Auto ;gia
quest property gia_FollowerQst auto ;gia

int property MantellaEndHotkey auto
int property MantellaForgetLastMessageHotkey auto
int property MantellaRegenLastMessageHotkey auto
int property MantellaRadiantHotkey auto

bool property radiantEnabled auto
float property radiantDistance auto
float property radiantFrequency auto



;variables below used by MCM_TargetTrackingSettings
bool property targetTrackingItemAdded auto 
bool property targetTrackingItemRemoved auto
bool property targetTrackingOnSpellCast auto
bool property targetTrackingOnHit auto
bool property targetTrackingOnCombatStateChanged auto
bool property targetTrackingOnObjectEquipped auto
bool property targetTrackingOnObjectUnequipped auto
bool property targetTrackingOnSit auto
bool property targetTrackingOnGetUp auto

bool property AllowForNPCtoFollow auto ;gia
bool property followingNPCsit auto ;gia
bool property followingNPCsleep auto ;gia
bool property NPCstopandTalk auto ;gia
bool property NPCAnger auto ;gia
bool property NPCForgive auto ;gia
bool property NPCDialogue auto ;gia

;variables below used by MCM_PlayerTrackingSettings
bool property playerTrackingOnItemAdded auto
bool property playerTrackingOnItemRemoved auto
bool property playerTrackingOnSpellCast auto
bool property playerTrackingOnHit auto
bool property playerTrackingOnLocationChange auto
bool property playerTrackingOnObjectEquipped auto
bool property playerTrackingOnObjectUnequipped auto
bool property playerTrackingOnPlayerBowShot auto
bool property playerTrackingOnSit auto
bool property playerTrackingOnGetUp auto
bool property playerTrackingOnVampireFeed auto
bool property playerTrackingOnFastTravelEnd auto
bool property playerTrackingOnVampirismStateChanged auto
bool property playerTrackingOnLycanthropyStateChanged auto

;variables below used by MCM_MainSettings
float property MantellaEffectResponseTimer auto
int property MantellaOpenTextInputHotkey auto
int property MantellaAddToConversationHotkey auto
int property MantellaCustomGameEventHotkey auto
bool property microphoneEnabled auto
bool property NPCdebugSelectModeEnabled auto
bool property endFlagMantellaConversationAll auto

string property context_string auto
int property MantellaOpenContextMenuHotkey auto
int property MantellaOpenIndividualContextMenuHotkey auto

event OnInit()
    ;variables below used by MCM_PlayerTrackingSettings
    playerTrackingOnItemAdded = true
    playerTrackingOnItemRemoved = true
    playerTrackingOnSpellCast = true
    playerTrackingOnHit = true
    playerTrackingOnLocationChange = true
    playerTrackingOnObjectEquipped = true
    playerTrackingOnObjectUnequipped = true
    playerTrackingOnPlayerBowShot = true
    playerTrackingOnSit = true
    playerTrackingOnGetUp = true
    playerTrackingOnVampireFeed = true
    playerTrackingOnFastTravelEnd = true
    playerTrackingOnVampirismStateChanged = true
    playerTrackingOnLycanthropyStateChanged = true
    

    ;variables below used by MCM_TargetTrackingSettings
    targetTrackingItemAdded = true
    targetTrackingItemRemoved = true
    targetTrackingOnSpellCast = true
    targetTrackingOnHit = true
    targetTrackingOnCombatStateChanged = true
    targetTrackingOnObjectEquipped = true
    targetTrackingOnObjectUnequipped = true
    targetTrackingOnSit = true
    targetTrackingOnGetUp = true
	
	followingNPCsit = false ;gia
	followingNPCsleep = false ;gia
	NPCstopandTalk = false ;gia
	AllowForNPCtoFollow = false ;gia
	NPCAnger = false ;gia
	NPCForgive = false ;gia
	NPCDialogue = false ;gia

    ;variables below used by MCM_MainSettings
    MantellaEffectResponseTimer = 180
    microphoneEnabled = true
    String microphoneEnabledString = MiscUtil.ReadFromFile("_pantella_microphone_enabled.txt") as String
    if microphoneEnabledString == "false"
        microphoneEnabled = false
    endif
    radiantEnabled = false
    radiantDistance = 20
    radiantFrequency = 10
    
    MantellaOpenTextInputHotkey = 48 ; The default key is the "B" key
    MantellaAddToConversationHotkey = 35 ; The default key is the "H" key
    MantellaCustomGameEventHotkey = -1 ; Used to bind a hotkey to add a custom game event - Unbound by default
    MantellaEndHotkey = -1 ; Used to bind a hotkey to end the conversation - Unbound by default
    MantellaForgetLastMessageHotkey = -1 ; Used to bind a hotkey to forget the last message - Unbound by default
    MantellaRegenLastMessageHotkey = -1 ; Used to bind a hotkey to regenerate the last message - Unbound by default
    MantellaRadiantHotkey = -1 ; Used to bind a hotkey to enable/disable radiant dialogue - Unbound by default
    MantellaOpenContextMenuHotkey = -1 ; Used to bind a hotkey to open the context menu - Unbound by default
    MantellaOpenIndividualContextMenuHotkey = -1 ; Used to bind a hotkey to open the individual context menu - Unbound by default
    
    BindPromptHotkey(MantellaOpenTextInputHotkey)
    BindAddToConversationHotkey(MantellaAddToConversationHotkey)
    BindEndHotkey(MantellaEndHotkey)
    BindForgetLastMessageHotkey(MantellaForgetLastMessageHotkey)
    BindRegenLastMessageHotkey(MantellaRegenLastMessageHotkey)
    BindCustomGameEventHotkey(MantellaCustomGameEventHotkey)
    BindRadiantHotkey(MantellaRadiantHotkey)
    BindOpenContextMenuHotkey(MantellaOpenContextMenuHotkey)
    MantellaOpenIndividualContextMenuHotkey = 49 ; The default key is the "C" key

    NPCdebugSelectModeEnabled = false
    context_string = "" ; This is the string that's fed to the prompt to give extra context to the LLM. When the player reopens the context input menu, this string is reloaded into the menu
endEvent

function BindPromptHotkey(int keyCode)
    ;used by the MCM_MainSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaOpenTextInputHotkey)
    MantellaOpenTextInputHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindAddToConversationHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaAddToConversationHotkey)
    MantellaAddToConversationHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindEndHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaEndHotkey)
    MantellaEndHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindForgetLastMessageHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaForgetLastMessageHotkey)
    MantellaForgetLastMessageHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindRegenLastMessageHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaRegenLastMessageHotkey)
    MantellaRegenLastMessageHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindCustomGameEventHotkey(int keyCode)
    ;used by the MCM_MainSettings when updating the custom game event hotkey KeyMapChange
    UnregisterForKey(MantellaCustomGameEventHotkey)
    MantellaCustomGameEventHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindRadiantHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaRadiantHotkey)
    MantellaRadiantHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindOpenContextMenuHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaOpenContextMenuHotkey)
    MantellaOpenContextMenuHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

function BindOpenIndividualContextMenuHotkey(int keyCode)
    ;used by the MCM_GeneralSettings when updating the prompt hotkey KeyMapChange
    UnregisterForKey(MantellaOpenIndividualContextMenuHotkey)
    MantellaOpenIndividualContextMenuHotkey=keyCode
    RegisterForKey(keyCode)
endfunction

Event OnKeyDown(int KeyCode)
    ;this function was previously in MantellaListener Script back in Mantella 0.9.2
	;this ensures the right key is pressed and only activated while not in menu mode
    if !utility.IsInMenuMode()
        if KeyCode == MantellaOpenTextInputHotkey
            String playerResponse = "False"
            playerResponse = MiscUtil.ReadFromFile("_pantella_text_input_enabled.txt") as String ;Checks if the Mantella is ready for text input and if the MCM has the microphone disabled
            
            ; Debug.Notification("Getting Player Response: "+playerResponse)
            if playerResponse == "True" && !microphoneEnabled
                ;Debug.Notification("Forcing Conversation Through Hotkey")
                UIExtensions.InitMenu("UITextEntryMenu")
                UIExtensions.OpenMenu("UITextEntryMenu") ; Opens the text entry menu
                string result = UIExtensions.GetMenuResultString("UITextEntryMenu") as String ; This is the text that the player entered into the menu
                if result != ""
                    MiscUtil.WriteToFile("_pantella_text_input_enabled.txt", "False", append=False)
                    MiscUtil.WriteToFile("_pantella_text_input.txt", result, append=false)
                endif
            endif
        elseif KeyCode == MantellaAddToConversationHotkey
            String radiantDialogue = MiscUtil.ReadFromFile("_pantella_radiant_dialogue.txt") as String
            String activeActors = MiscUtil.ReadFromFile("_pantella_active_actors.txt") as String ; This is a list of all the actors that are currently loaded into the Mantella
            Actor targetRef = (Game.GetCurrentCrosshairRef() as actor) ; this is the actor that the player is looking at when the hotkey is pressed - If the player is not looking at an actor, this will be None
            String actorName = targetRef.getdisplayname() ; Blank if the player is not looking at an actor
            ; Debug.Notification("Hotkey Pressed while looking at: "+actorName)
            if actorName == ""
                ; Debug.Notification("No Actor Detected")
            else
                ; Debug.Notification("Actor Detected")
                int index = StringUtil.Find(activeActors, actorName)

                if (index == -1) || (radiantDialogue == "True") ; if actor not already loaded or player is interrupting radiant dialogue
                    MantellaSpell.cast(Game.GetPlayer(), targetRef) 
                    Utility.Wait(0.5)
                endif
            endif
        elseif KeyCode == MantellaEndHotkey
            MiscUtil.WriteToFile("_pantella_text_input_enabled.txt", "False", append=False)
            MiscUtil.WriteToFile("_pantella_text_input.txt", "EndConversationNow", append=false)
            Debug.Notification("Ending Conversation")
        elseif KeyCode == MantellaForgetLastMessageHotkey
            MiscUtil.WriteToFile("_pantella_text_input_enabled.txt", "False", append=False)
            MiscUtil.WriteToFile("_pantella_text_input.txt", "ForgetLastMessage", append=false)
            Debug.Notification("Forgetting Last Message")
        elseif KeyCode == MantellaRegenLastMessageHotkey
            MiscUtil.WriteToFile("_pantella_text_input_enabled.txt", "False", append=False)
            MiscUtil.WriteToFile("_pantella_text_input.txt", "RegenLastMessage", append=false)
            Debug.Notification("Regenerating Last Response...")
        elseif KeyCode == MantellaCustomGameEventHotkey 
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.OpenMenu("UITextEntryMenu")
            string gameEventEntry = UIExtensions.GetMenuResultString("UITextEntryMenu")
            gameEventEntry = gameEventEntry+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", gameEventEntry)
            ; endFlagMantellaConversationAll = false
        elseif KeyCode == MantellaRadiantHotkey
            radiantEnabled =! radiantEnabled
            if radiantEnabled == True
                Debug.Notification("Radiant Dialogue Enabled")
            else
                Debug.Notification("Radiant Dialogue Disabled")
            endif
        elseif KeyCode == MantellaOpenContextMenuHotkey
            Debug.Notification("Opening Context Menu with String: "+context_string)
            UIExtensions.InitMenu("UITextEntryMenu")
            UIExtensions.SetMenuPropertyString("UITextEntryMenu", "text", context_string)
            UIExtensions.OpenMenu("UITextEntryMenu")
            UIExtensions.SetMenuPropertyString("UITextEntryMenu", "text", context_string)
            string contextString = UIExtensions.GetMenuResultString("UITextEntryMenu")
            context_string = contextString
            MiscUtil.WriteToFile("_pantella_context_string.txt", contextString, append=false)
        elseif KeyCode == MantellaOpenIndividualContextMenuHotkey
            String playerResponse = "False"
            playerResponse = MiscUtil.ReadFromFile("_pantella_text_input_enabled.txt") as String ;Checks if the Mantella is ready for text input and if the MCM has the microphone disabled
            
            ; Debug.Notification("Getting Player Response: "+playerResponse)
            if playerResponse == "True"
                Debug.Notification("Opening Context Menu with String: "+context_string)
                UIExtensions.InitMenu("UITextEntryMenu")
                UIExtensions.SetMenuPropertyString("UITextEntryMenu", "text", context_string)
                UIExtensions.OpenMenu("UITextEntryMenu")
                UIExtensions.SetMenuPropertyString("UITextEntryMenu", "text", context_string)
                string contextString = UIExtensions.GetMenuResultString("UITextEntryMenu")
                context_string = contextString
                MiscUtil.WriteToFile("_pantella_individual_context_string.txt", contextString, append=false)
            endif
        endif
    endif
endEvent