Scriptname MantellaEffectScript extends activemagiceffect

Topic property MantellaDialogueLine auto
ReferenceAlias property TargetRefAlias auto
Faction Property PlayerFaction Auto
Faction Property PotentialFollowerFaction Auto
;gia Faction property DunPlayerAllyFactionProperty auto
;gia Faction property PotentialFollowerFactionProperty auto

;#############
float localMenuTimer = 0.0
;#############
MantellaRepository property repository auto

event OnEffectStart(Actor target, Actor caster)
	; these three lines below is to ensure that no leftover Mantella effects are running
	;MiscUtil.WriteToFile("_mantella_end_conversation.txt", "True",  append=false)
	;Utility.Wait(0.5)
	;MiscUtil.WriteToFile("_mantella_end_conversation.txt", "False",  append=false)
    
    Actor player = Game.GetPlayer()
    String playerRace = player.GetRace().GetName()
    Int playerGenderID = player.GetActorBase().GetSex()
    String playerGender = ""
    if (playerGenderID == 0)
        playerGender = "Male"
    else
        playerGender = "Female"
    endIf
    String playerName = player.GetActorBase().GetName()
    MiscUtil.WriteToFile("_mantella_player_name.txt", playerName, append=false)
    MiscUtil.WriteToFile("_mantella_player_race.txt", playerRace, append=false)
    MiscUtil.WriteToFile("_mantella_player_gender.txt", playerGender, append=false)
    
    MiscUtil.WriteToFile("_mantella_skyrim_folder.txt", "Set the folder this file is in as your skyrim_folder path in MantellaSoftware/config.ini", append=false)
	; only run script if actor is not already selected
	; String currentActor = MiscUtil.ReadFromFile("_mantella_current_actor.txt") as String

    String activeActors = MiscUtil.ReadFromFile("_mantella_active_actors.txt") as String ;get list of active actors from _mantella_active_actors.txt from Python
    int actorCount = MiscUtil.ReadFromFile("_mantella_actor_count.txt") as int ;get number of actors from _mantella_actor_count.txt from Python
    actorCount += 1 ; increment actorCount by 1 to account for the actor that was just added to a conversation
    String character_selection_enabled = MiscUtil.ReadFromFile("_mantella_character_selection.txt") as String

    Utility.Wait(0.5)

    String targetName = target.getdisplayname()
    String casterName = caster.getdisplayname()

    ;if radiant dialogue between two NPCs of the same name, label them 1 & 2 to avoid confusion for the LLM
    if (casterName == targetName) ; TODO: only handles case when conversation includes 2 actors with the same name. Would like to handle case when an arbitrary number of actors with the same name are in the conversation
        if actorCount == 1 ;if this is the first actor selected, label them 1
            targetName = targetName + " 1"
            casterName = casterName + " 2"
        elseIf actorCount == 2 ;if this is the second actor selected, label them 2
            targetName = targetName + " 2"
            casterName = casterName + " 1"
        endIf
    endIf

    int index = StringUtil.Find(activeActors, targetName)
    bool actorAlreadyLoaded = true
    if index == -1
        actorAlreadyLoaded = false
    endIf

    String radiantDialogue = MiscUtil.ReadFromFile("_mantella_radiant_dialogue.txt") as String
    
    if (radiantDialogue == "True") && (caster == Game.GetPlayer()) && (actorAlreadyLoaded == false) ; if radiant dialogue is active without the actor selected by player, end the ongoing radiant conversation
        Debug.Notification("Ending radiant dialogue")
        MiscUtil.WriteToFile("_mantella_end_conversation.txt", "True",  append=false)
    elseIf (radiantDialogue == "True") && (actorAlreadyLoaded == true) && (caster == Game.GetPlayer()) ; if selected actor is in radiant dialogue, disable this mode to allow the player to join the conversation 
        Debug.Notification("Adding player to conversation")
        MiscUtil.WriteToFile("_mantella_radiant_dialogue.txt", "False",  append=false)
	elseIf (actorAlreadyLoaded == false) && (character_selection_enabled == "True") ; if actor not already loaded and character selection is enabled
        TargetRefAlias.ForceRefTo(target)
        
        
        ; Write Actor IDs to file for Python to read
        ; get actor's BaseID
        String actorBaseId = (target.getactorbase() as form).getformid() ; get actor's BaseID as int
        ; get actor's RefID
        String actorRefId = target.getformid() ; get actor's RefID as int
        
		if repository.NPCdebugSelectModeEnabled==true ; if debug select mode is active this will allow the user to enter in the RefID of the NPC bio/voice to have a conversation with
            Debug.Messagebox("Enter the actor's RefID(in base 10) that you wish to speak to") ; TODO: Support BaseID input for debug select mode
            Utility.Wait(0.1)
			UIExtensions.InitMenu("UITextEntryMenu")
			UIExtensions.OpenMenu("UITextEntryMenu")
			string result1 = UIExtensions.GetMenuResultString("UITextEntryMenu")
			MiscUtil.WriteToFile("_mantella_current_actor_ref_id.txt", result1, append=false)
		else ; if debug select mode is not active, use the actor's RefID as the ID to have a conversation with
		    MiscUtil.WriteToFile("_mantella_current_actor_ref_id.txt", actorRefId, append=false)
		endIf
        MiscUtil.WriteToFile("_mantella_current_actor_base_id.txt", actorBaseId, append=false)


        ; Get NPC's name and save name to _mantella_current_actor.txt for Python to read
		if repository.NPCdebugSelectModeEnabled==true ;if debug select mode is active this will allow the user to enter in the RefID of the NPC bio/voice to have a conversation with
            Debug.Messagebox("Enter the name of the actor that you wish to speak to")
            Utility.Wait(0.1)
			UIExtensions.InitMenu("UITextEntryMenu")
			UIExtensions.OpenMenu("UITextEntryMenu")
			string result2 = UIExtensions.GetMenuResultString("UITextEntryMenu") ;get actor name from user input
			MiscUtil.WriteToFile("_mantella_current_actor.txt", result2, append=false) ;save actor name to _mantella_current_actor.txt for Python to read
            MiscUtil.WriteToFile("_mantella_active_actors.txt", " "+targetName+" ", append=true) ;add actor name to _mantella_active_actors.txt for Python to read
            MiscUtil.WriteToFile("_mantella_character_selection.txt", "False", append=false) ;disable character selection mode after first actor is selected
		else ;if debug select mode is not active, use the actor's name as the name to have a conversation with
			MiscUtil.WriteToFile("_mantella_current_actor.txt", targetName, append=false) ;save actor name to _mantella_current_actor.txt for Python to read
            MiscUtil.WriteToFile("_mantella_active_actors.txt", " "+targetName+" ", append=true) ;add actor name to _mantella_active_actors.txt for Python to read
            MiscUtil.WriteToFile("_mantella_character_selection.txt", "False", append=false) ;disable character selection mode after first actor is selected
		endIf

		target.addtofaction(repository.giafac_Mantella);gia 
		
        String actorSex = target.getleveledactorbase().getsex()
        MiscUtil.WriteToFile("_mantella_actor_sex.txt", actorSex, append=false)

        String actorRace = target.getrace()
        MiscUtil.WriteToFile("_mantella_actor_race.txt", actorRace, append=false)

        String actorRelationship = target.getrelationshiprank(game.getplayer())
        MiscUtil.WriteToFile("_mantella_actor_relationship.txt", actorRelationship, append=false)

        String actorVoiceType = target.GetVoiceType()
        MiscUtil.WriteToFile("_mantella_actor_voice.txt", actorVoiceType, append=false)

        String isEnemy = "False"
        if (target.getcombattarget() == game.getplayer())
            isEnemy = "True"
        endIf
        MiscUtil.WriteToFile("_mantella_actor_is_enemy.txt", isEnemy, append=false)
        
        String currLoc = (caster.GetCurrentLocation() as form).getname()
        if currLoc == ""
            currLoc = "Skyrim"
        endIf
        MiscUtil.WriteToFile("_mantella_current_location.txt", currLoc, append=false)

        UpdateTime() ; update time to be used for the time of day in the conversation

        MiscUtil.WriteToFile("_mantella_actor_count.txt", actorCount, append=false)

        if actorCount == 1 ; reset player input if this is the first actor selected
            MiscUtil.WriteToFile("_mantella_text_input_enabled.txt", "False", append=False)
            MiscUtil.WriteToFile("_mantella_text_input.txt", "", append=false)
            MiscUtil.WriteToFile("_mantella_in_game_events.txt", "", append=False)
        endif

        if (caster == game.getplayer()) && actorCount == 1
            Debug.Notification(casterName + " is starting conversation with " + targetName)
        elseIf (caster == game.getplayer()) && actorCount >1
                Debug.Notification("Adding " + targetName + " to conversation")
        elseIf actorCount == 1
            Debug.Notification("Starting radiant dialogue with " + targetName + " and " + casterName)
        endIf

        String endConversation = "False"
        String sayFinalLine = "False"
        String sayLineFile = "_mantella_say_line_"+actorCount+".txt"
        Int loopCount = 0

        ; Wait for first voiceline to play to avoid old conversation playing
        Utility.Wait(0.5)

        MiscUtil.WriteToFile("_mantella_character_selected.txt", "True", append=false)

        ; Start conversation loop - this will run over and over until the conversation is ended
        While endConversation == "False" && repository.endFlagMantellaConversationAll==false
            if actorCount == 1 ; if this is the first actor selected, run the MainConversationLoop function
                MainConversationLoop(target, caster, targetName, casterName, actorRelationship, loopCount)
                loopCount += 1
            else ; if this is not the first actor selected, run the ConversationLoop function
                ConversationLoop(target, caster, targetName, casterName, sayLineFile)
            endif
            
            if sayFinalLine == "True"
                endConversation = "True"
                localMenuTimer = -1
            endIf

            ; Wait for Python / the script to give the green light to end the conversation
            sayFinalLine = MiscUtil.ReadFromFile("_mantella_end_conversation.txt") as String
        endWhile


        Debug.Notification("Conversation ended.")
		target.removefromfaction(repository.giafac_Mantella);gia
        radiantDialogue = MiscUtil.ReadFromFile("_mantella_radiant_dialogue.txt") as String
        if radiantDialogue == "True"
            Debug.Notification("Radiant dialogue ended.")
        else
            Debug.Notification("Conversation ended.")
        endIf
        target.ClearLookAt()
        caster.ClearLookAt()
        MiscUtil.WriteToFile("_mantella_actor_count.txt", "0", append=False)
    else
        Debug.Notification("NPC not added. Please try again after your next response.")
    endIf
endEvent


function MainConversationLoop(Actor target, Actor caster, String targetName, String casterName, String actorRelationship, Int loopCount) ; this function is for the first actor selected in a conversation
    ; Debug.Notification("MainConversationLoop")
    String sayLine = MiscUtil.ReadFromFile("_mantella_say_line.txt") as String
    if sayLine != "False" ; if there is a line to say
        Debug.Notification(targetName + " is speaking.")
        MantellaSubtitles.SetInjectTopicAndSubtitleForSpeaker(target, MantellaDialogueLine, sayLine)
        target.Say(MantellaDialogueLine, abSpeakInPlayersHead=false)
        target.SetLookAt(caster)

        ; Set sayLine back to False once the voiceline has been triggered
        MiscUtil.WriteToFile("_mantella_say_line.txt", "False",  append=false)
        localMenuTimer = -1
; 
        ; Debug.Notification("Checking for actor methods")

        ; Check every line of _mantella_actor_methods for the following format: "refID|methodName|args" with the args section being optional, and "<>" separated. Every line that matches this format will be removed and the file updated
        String actorMethods = MiscUtil.ReadFromFile("_mantella_actor_methods.txt") as String
        String newActorMethods = ""
        if actorMethods != "" && actorMethods != "False" ; if the file is not empty or False
            ; Debug.Notification("Found actor" + actorMethodsArray.Length as String + " methods.")
            ; Debug.Notification("Actor INT ID:" + target.GetFormID() as String)
            String[] actorMethodsArray = PapyrusUtil.StringSplit(actorMethods, "\n")
            Int i = 0
            while i < actorMethodsArray.Length
                ; Debug.Notification("Parsing Line: " + actorMethodsArray[i])
                String[] actorMethod = PapyrusUtil.StringSplit(actorMethodsArray[i], "|")
                int ref_id_int = actorMethod[0] as int
                if ref_id_int == target.GetFormID() ; if the refID matches the target's refID
                    Debug.Notification("Calling Method: " + actorMethod[1] + " on " + targetName)
                    if actorMethod.Length > 2
                        PythonActorMethodCall(caster, target, casterName, targetName, actorRelationship, actorMethod[1] as String, actorMethod[2] as String)
                    else
                        PythonActorMethodCall(caster, target, casterName, targetName, actorRelationship, actorMethod[1] as String, "")
                    endIf
                else
                    newActorMethods += actorMethodsArray[i] + "\n"
                endIf
                i += 1
            endwhile
            MiscUtil.WriteToFile("_mantella_actor_methods.txt", newActorMethods,  append=false)
        endIf
        
        ; Debug.Notification("Done checking for actor methods")

        ; ; Check aggro status after every line spoken
        ; String aggro = MiscUtil.ReadFromFile("_mantella_aggro.txt") as String
        ; if aggro == "0"
        ;     if game.getplayer().isinfaction(Repository.giafac_AllowForgive)
        ;     Debug.Notification(targetName + " forgave you.")
        ;     target.StopCombat()
        ;     MiscUtil.WriteToFile("_mantella_aggro.txt", "",  append=false)
		; 	endif
        ; elseIf aggro == "1"
        ;     if game.getplayer().isinfaction(Repository.giafac_AllowAnger)
        ;     Debug.Notification(targetName + " did not like that.")
        ;     ;target.UnsheatheWeapon()
        ;     ;target.SendTrespassAlarm(caster) 
        ;     target.StartCombat(caster)
        ;     MiscUtil.WriteToFile("_mantella_aggro.txt", "",  append=false)
		; 	Endif
        ; elseif aggro == "2"
        ;     if actorRelationship != "4"
        ;         Debug.Notification(targetName + " is willing to follow you.")
        ;         ;gia target.setrelationshiprank(caster, 4)
        ;         ;gia target.addtofaction(DunPlayerAllyFactionProperty)
        ;         ;gia target.addtofaction(PotentialFollowerFactionProperty)
        ;         if game.getplayer().isinfaction(repository.giafac_allowfollower)
		; 			Debug.Notification(targetName + " is following you.");gia
		; 			target.SetFactionRank(repository.giafac_following, 1);gia
		; 			repository.gia_FollowerQst.reset();gia
		; 			repository.gia_FollowerQst.stop();gia
		; 			Utility.Wait(0.5);gia
		; 			repository.gia_FollowerQst.start();gia
		; 			target.EvaluatePackage();gia
        ;         else
        ;             Debug.Notification("Follow action not enabled in the Mantella MCM.")
		; 		endif

        ;         MiscUtil.WriteToFile("_mantella_aggro.txt", "",  append=false)
        ;     endIf
        ; elseif aggro == "3"
        ;     ; Cast MantellaEffect on player
        ;     Debug.Notification("Casting MantellaEffect on player from " + targetName)
        ;     Repository.MantellaSpell.cast(caster, game.getplayer())
        ;     MiscUtil.WriteToFile("_mantella_aggro.txt", "",  append=false)
        ; endIf

        ; Update time (this may be too frequent)
        UpdateTime()

        caster.SetLookAt(target)
    endIf

    ; Run these checks every 5 loops
    if loopCount % 5 == 0
        String status = MiscUtil.ReadFromFile("_mantella_status.txt") as String
        if status != "False"
            Debug.Notification(status)
            MiscUtil.WriteToFile("_mantella_status.txt", "False",  append=false)
        endIf

        String playerResponse = MiscUtil.ReadFromFile("_mantella_text_input_enabled.txt") as String
        if playerResponse == "True"
            StartTimer()
            Utility.Wait(2)
        endIf

        if loopCount % 20 == 0
            target.ClearLookAt()
            caster.ClearLookAt()
            String radiantDialogue = MiscUtil.ReadFromFile("_mantella_radiant_dialogue.txt") as String
            if radiantDialogue == "True"
                float distanceBetweenActors = caster.GetDistance(target)
                float distanceToPlayer = ConvertGameUnitsToMeter(caster.GetDistance(game.getplayer()))
                ;Debug.Notification(distanceBetweenActors)
                ;TODO: allow distanceBetweenActos limit to be customisable
                if (distanceBetweenActors > 1500) || (distanceToPlayer > repository.radiantDistance) || (caster.GetCurrentLocation() != target.GetCurrentLocation()) || (caster.GetCurrentScene() != None) || (target.GetCurrentScene() != None)
                    ;Debug.Notification(distanceBetweenActors)
                    MiscUtil.WriteToFile("_mantella_end_conversation.txt", "True",  append=false)
                endIf
            endIf
        endIf
    endIf
endFunction

function ConversationLoop(Actor target, Actor caster, String targetName, String casterName, String sayLineFile) ; this function is for all actors selected after the first actor in a conversation
    ; Debug.Notification("ConversationLoop")
    String sayLine = MiscUtil.ReadFromFile(sayLineFile) as String
    if sayLine != "False"
        Debug.Notification(targetName + " is speaking.")
        ; Debug.Notification(sayLine)
        ; Debug.Notification(sayLineFile)
        MantellaSubtitles.SetInjectTopicAndSubtitleForSpeaker(target, MantellaDialogueLine, sayLine)
        target.Say(MantellaDialogueLine, abSpeakInPlayersHead=false)
        target.SetLookAt(caster)

        ; Set sayLine back to False once the voiceline has been triggered
        MiscUtil.WriteToFile(sayLineFile, "False",  append=false)
        localMenuTimer = -1
    endIf
endFunction

Bool function PythonActorMethodCall(Actor caster, Actor target, String casterName, String targetName, String actorRelationship, String methodName, String argsString)
    Debug.Notification("Calling " + methodName + " on " + targetName)
    Debug.Notification("Args: " + argsString)
    String[] args = PapyrusUtil.StringSplit(argsString, "<>")
    If methodName == "StartCombat"
        if args.Length == 1
            Debug.Notification(casterName + " is starting combat with " + targetName)
            target.StartCombat(caster)
        else
            Debug.Notification("Invalid number of arguments for StartCombat")
            return false
        endIf
    elseIf methodName == "StopCombat"
        Debug.Notification(targetName + " is stopping combat.")
        target.StopCombat()
    elseIf methodName == "SendTrespassAlarm"
        Debug.Notification(targetName + " is sending a trespass alarm.")
        target.SendTrespassAlarm(caster)
    elseIf methodName == "UnsheatheWeapon" || methodName == "DrawWeapon"
        Debug.Notification(targetName + " is unsheathing their weapon.")
        target.DrawWeapon()
    elseIf methodName == "SheatheWeapon"
        Debug.Notification(targetName + " is sheathing their weapon.")
        target.SheatheWeapon()
    elseIf methodName == "FollowPlayer"
        Debug.Notification(targetName + " is willing to follow you.")
        if target.getrelationshiprank(game.getplayer()) < 4
            target.SetRelationshipRank(game.getplayer(), 4)
        endIf
        target.SetFactionRank(PlayerFaction, 1)
        target.SetFactionRank(PotentialFollowerFaction, 1)
        target.SetPlayerTeammate(True)
        target.SetFactionRank(repository.giafac_following, 1);gia
        repository.gia_FollowerQst.reset();gia
        repository.gia_FollowerQst.stop();gia
        Utility.Wait(0.5);gia
        repository.gia_FollowerQst.start();gia
        target.EvaluatePackage();gia
    elseIf methodName == "StopFollowingPlayer"
        Debug.Notification(targetName + " is no longer willing to follow you.")
        target.RemoveFromFaction(PlayerFaction);gia
        target.RemoveFromFaction(PotentialFollowerFaction);gia
        target.SetPlayerTeammate(False)
        target.SetFactionRank(repository.giafac_following, 0);gia
        repository.gia_FollowerQst.reset();gia
        repository.gia_FollowerQst.stop();gia
        target.EvaluatePackage();gia
    elseIf methodName == "SetPlayerRelationshipRank"
        if args.Length == 1
            Debug.Notification("Setting relationship rank to " + args[0] + " for " + targetName)
            target.SetRelationshipRank(game.getplayer(), args[0] as int)
        else
            Debug.Notification("Invalid number of arguments for SetPlayerRelationshipRank")
            return false
        endIf
    elseIf methodName == "Wait"
        if args.Length == 1
            Debug.Notification("Waiting for " + args[0] + " seconds.")
            Utility.Wait(args[0] as float)
        else
            Debug.Notification("Invalid number of arguments for Wait")
            return false
        endIf
    elseIf methodName == "OpenGiftMenu"
        Debug.Notification("Opening gift menu with " + targetName)
        target.ShowGiftMenu(true)
    elseIf methodName == "OpenTakeMenu"
        Debug.Notification("Opening take menu with " + targetName)
        target.ShowGiftMenu(false)
    elseIf methodName == "OpenTradeMenu"
        Debug.Notification("Opening trade menu with " + targetName)
        target.OpenInventory(true)
    elseIf methodName == "OpenBarterMenu"
        Debug.Notification("Opening trade menu with " + targetName)
        target.ShowBarterMenu()
    elseIf methodName == "Intimidate"
        Debug.Notification(casterName + " intimidated " + targetName)
        target.SetIntimidated(true)
    elseIf methodName == "Unintimidate"
        Debug.Notification("Unintimidating " + targetName)
        target.SetIntimidated(false)
    elseIf methodName == "SendTrepassAlarmCaster"
        Debug.Notification(targetName + " is sending a trespass alarm for " + casterName)
        target.SendTrespassAlarm(caster)
    elseIf methodName == "SendTrespassAlarmPlayer"
        Debug.Notification(targetName + " is sending a trespass alarm for the player")
        target.SendTrespassAlarm(game.getplayer())
    elseIf methodName == "SendAssaultAlarmPlayer"
        Debug.Notification("Sending assault alarm for player")
        target.SendAssaultAlarm()
    elseIf methodName == "ArrestPlayer"
        Debug.Notification("Arresting player")
        Faction crime_fac = target.GetCrimeFaction()
        if crime_fac != None
            crime_fac.ModCrimeGold(100, true)
        endIf
        target.SendAssaultAlarm()
    elseIf methodName == "PlayerResistingArrest"
        Debug.Notification("Player is resisting arrest")
        target.SetPlayerResistingArrest()
    elseIf methodName == "ForceActorValue" || methodName == "ForceAV"
        if args.Length == 2
            Debug.Notification("Forcing actor value " + args[0] + " to " + args[1] + " for " + targetName)
            target.ForceActorValue(args[0] as String, args[1] as float)
        else
            Debug.Notification("Invalid number of arguments for ForceActorValue")
            return false
        endIf
    elseIf methodName == "ModActorValue" || methodName == "ModAV"
        if args.Length == 2
            Debug.Notification("Modifying actor value " + args[0] + " by " + args[1] + " for " + targetName)
            target.ModActorValue(args[0] as String, args[1] as float)
        else
            Debug.Notification("Invalid number of arguments for ModActorValue")
            return false
        endIf
    elseIf methodName == "Bribe"
        Debug.Notification("Bribing " + targetName)
        target.SetBribed(true)
    elseIf methodName == "Unbribe"
        Debug.Notification("Unbribing " + targetName)
        target.SetBribed(false)
    elseIf methodName == "Knockout"
        Debug.Notification("Knocking out " + targetName)
        target.SetUnconscious(true)
    elseIf methodName == "WakeUp"
        Debug.Notification("Waking up " + targetName)
        target.SetUnconscious(false)
    elseIf methodName == "Kill"
        Debug.Notification("Killing " + targetName)
        target.Kill()
    elseIf methodName == "TakeEverythingOff"
        Debug.Notification("Taking everything off " + targetName)
        target.UnequipAll()
    elseIf methodName == "TakeOffHelmet"
        Debug.Notification("Taking off helmet for " + targetName)
        target.UnequipItemSlot(30)
    elseIf methodName == "TakeOffCirclet"
        Debug.Notification("Taking off circlet for " + targetName)
        target.UnequipItemSlot(42)
    elseIf methodName == "TakeOffAmulet"
        Debug.Notification("Taking off amulet for " + targetName)
        target.UnequipItemSlot(35)
    elseIf methodName == "TakeOffRing"
        Debug.Notification("Taking off ring for " + targetName)
        target.UnequipItemSlot(36)
    elseIf methodName == "TakeOffGloves"
        Debug.Notification("Taking off gloves for " + targetName)
        target.UnequipItemSlot(33)
    elseIf methodName == "TakeOffBoots"
        Debug.Notification("Taking off boots for " + targetName)
        target.UnequipItemSlot(37)
    elseIf methodName == "TakeOffArmor"
        Debug.Notification("Taking off armor for " + targetName)
        target.UnequipItemSlot(32)
    elseIf methodName == "TakeOffCalves"
        Debug.Notification("Taking off calves for " + targetName)
        target.UnequipItemSlot(38)
    elseIf methodName == "TakeOffShield"
        Debug.Notification("Taking off shield for " + targetName)
        target.UnequipItemSlot(39)
    elseIf methodName == "MakePlayerFriend"
        Debug.Notification("Making player friend of " + targetName)
        target.MakePlayerFriend()
    elseIf methodName == "UnlockOwnedDoorsInCell"
        Debug.Notification(targetName + " is unlocking their owned doors in this cell.")
        target.UnlockOwnedDoorsInCell()
    elseIf methodName == "PrintLog"
        Debug.Notification(target.GetDisplayName() + ":" + args[0])
    else
        Debug.Notification("Invalid method name: " + methodName)
        return false
    endIf
    return true
endfunction

function UpdateTime()
	string Time = Utility.GameTimeToString(Utility.GetCurrentGameTime()) ; Example: 07/12/0713 10:31 - Will be parsed in Python
    MiscUtil.WriteToFile("_mantella_in_game_time.txt", Time, append=false)
endFunction

function SplitSubtitleIntoParts(String subtitle)
    String[] subtitles = PapyrusUtil.StringSplit(subtitle, ",")
    int subtitleNo = 0
    while (subtitleNo < subtitles.Length)
        Debug.Notification(subtitles[subtitleNo])
        subtitleNo += 1
    endwhile
endFunction

function StartTimer()
	localMenuTimer=180
    ;#################################################
	localMenuTimer = repository.MantellaEffectResponseTimer
    ;################################################
    int localMenuTimerInt = Math.Floor(localMenuTimer)
	Debug.Notification("Awaiting player input for "+localMenuTimerInt+" seconds")
	String Monitorplayerresponse
	String timerCheckEndConversation
	;Debug.Notification("Timer is "+localMenuTimer)
	While localMenuTimer >= 0 && repository.endFlagMantellaConversationAll==false
		; Debug.Notification("Timer is "+localMenuTimer)
		Monitorplayerresponse = MiscUtil.ReadFromFile("_mantella_text_input_enabled.txt") as String
		timerCheckEndConversation = MiscUtil.ReadFromFile("_mantella_end_conversation.txt") as String
		;the next if clause checks if another conversation is already running and ends it.
		if timerCheckEndConversation || "true" || repository.endFlagMantellaConversationAll==true
			localMenuTimer = -1
			MiscUtil.WriteToFile("_mantella_say_line.txt", "False", append=false)
			return
		endif
		if Monitorplayerresponse == "False"
			localMenuTimer = -1
		endif
		If localMenuTimer > 0
			Utility.Wait(1)
			if !utility.IsInMenuMode()
				localMenuTimer = localMenuTimer - 1
			endif
			;Debug.Notification("Timer is "+localMenuTimer)
		elseif localMenuTimer == 0
            ; Debug.Notification("Timer is "+localMenuTimer)
			Monitorplayerresponse = "False"
			;added this as a safety check in case the player stays in a menu a long time.
			Monitorplayerresponse = MiscUtil.ReadFromFile("_mantella_text_input_enabled.txt") as String
			if Monitorplayerresponse == "True"
				;Debug.Notification("opening menu now")
				GetPlayerInput()
			endIf
			localMenuTimer = -1
		endIf
	endWhile
endFunction

function GetPlayerInput()
    UIExtensions.InitMenu("UITextEntryMenu")
    UIExtensions.OpenMenu("UITextEntryMenu")

    string result = UIExtensions.GetMenuResultString("UITextEntryMenu")

    MiscUtil.WriteToFile("_mantella_text_input_enabled.txt", "False", append=False)
    MiscUtil.WriteToFile("_mantella_text_input.txt", result, append=false)
endFunction

Float meterUnits = 71.0210
Float Function ConvertMeterToGameUnits(Float meter)
    Return Meter * meterUnits
EndFunction

Float Function ConvertGameUnitsToMeter(Float gameUnits)
    Return gameUnits / meterUnits
EndFunction

; function GetActorEquipment(Actor actor)
;     ; Array containing list of all Equipment location IDs
;     Int[] EquipmentSlots = [
;         30, ; head
;         31, ; hair
;         32, ; body (full)
;         33, ; hands
;         34, ; forearms
;         35, ; amulet
;         36, ; ring
;         37, ; feet
;         38, ; calves
;         39, ; shield
;         42, ; circlet
;         43  ; ears
;     ]
;     ; Create a new array to store the equipment
;     String[] equipment = new String[EquipmentSlots.Length]
;     ; Loop through each equipment slot
;     Int i = 0
;     While i < EquipmentSlots.Length
;         ; Get the form in the equipment slot
;         Form form = actor.GetWornForm(EquipmentSlots[i])
;         ; If the form is not None, get the name and store it in the array
;         If form != None
;             equipment[i] = form.GetName()
;         Else
;             equipment[i] = ""
;         EndIf
;         ; Increment the counter
;         i += 1
;     EndWhile
;     ; Return the array
;     Return equipment
; EndFunction