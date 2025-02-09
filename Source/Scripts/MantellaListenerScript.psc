Scriptname MantellaListenerScript extends ReferenceAlias

Spell property MantellaSpell auto
Spell property MantellaPower auto;gia
MantellaRepository property repository auto
Quest Property MantellaActorList  Auto  
ReferenceAlias Property PotentialActor1  Auto  
ReferenceAlias Property PotentialActor2  Auto  

event OnInit()
    Game.GetPlayer().AddSpell(MantellaSpell)
    Game.GetPlayer().AddSpell(MantellaPower);gia
    Debug.Notification("Pantella Spell added.")
    Debug.Notification("Pantella Hotkey is " + repository.MantellaCustomGameEventHotkey)
    Debug.Notification("IMPORTANT: Please save and reload to activate Pantella.")
endEvent

Float meterUnits = 71.0210
Float Function ConvertMeterToGameUnits(Float meter)
    Return Meter * meterUnits
EndFunction

Float Function ConvertGameUnitsToMeter(Float gameUnits)
    Return gameUnits / meterUnits
EndFunction

Event OnPlayerLoadGame()
    RegisterForSingleUpdate(repository.radiantFrequency)
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
    MiscUtil.WriteToFile("_pantella_player_name.txt", playerName, append=false)
    MiscUtil.WriteToFile("_pantella_player_race.txt", playerRace, append=false)
    MiscUtil.WriteToFile("_pantella_player_gender.txt", playerGender, append=false)
    MiscUtil.WriteToFile("_pantella_in_game_events.txt", "", append=false) ; Clear the game events file on load from last session
    MiscUtil.WriteToFile("_pantella_actor_count.txt", "0", append=false)
    MiscUtil.WriteToFile("_pantella_character_selection.txt", "True", append=false)
    
	MantellaMCM_MainSettings.ForceEndAllConversations(repository) ; Clean up any lingering conversations on load

    Debug.Notification("Pantella loaded - player is " + playerName + ", a " + playerGender + " " + playerRace + ".")
EndEvent

event OnRaceSwitchComplete()
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
    MiscUtil.WriteToFile("_pantella_player_name.txt", playerName, append=false)
    MiscUtil.WriteToFile("_pantella_player_race.txt", playerRace, append=false)
    MiscUtil.WriteToFile("_pantella_player_gender.txt", playerGender, append=false)
EndEvent

event OnUpdate()
    Debug.Notification("Checking for radiant conversations...")
    if repository.radiantEnabled
        Debug.Notification("Checking for nearby actors...")
        String activeActors = MiscUtil.ReadFromFile("_pantella_active_actors.txt") as String
        ; if no Mantella conversation active
        Debug.Notification("Active actors: " + activeActors)
        if activeActors == ""
            ;MantellaActorList taken from this tutorial:
            ;http://skyrimmw.weebly.com/skyrim-modding/detecting-nearby-actors-skyrim-modding-tutorial
            MantellaActorList.start()
            Debug.Notification("Querying for nearby actors...")
            ; if both actors found
            if (PotentialActor1.GetReference() as Actor) && (PotentialActor2.GetReference() as Actor)
                Debug.Notification("Found two actors nearby.")
                Actor Actor1 = PotentialActor1.GetReference() as Actor
                Actor Actor2 = PotentialActor2.GetReference() as Actor
                String Actor1Name = Actor1.getdisplayname()
                String Actor2Name = Actor2.getdisplayname()
                Debug.Notification("Actor 1: " + Actor1Name)
                Debug.Notification("Actor 2: " + Actor2Name)

                float distanceToClosestActor = game.getplayer().GetDistance(Actor1)
                Debug.Notification("Distance to closest actor: " + ConvertGameUnitsToMeter(distanceToClosestActor) + " meters")
                float maxDistance = ConvertMeterToGameUnits(repository.radiantDistance)
                if distanceToClosestActor <= maxDistance
                    float distanceBetweenActors = Actor1.GetDistance(Actor2)

                    Debug.Notification("Distance between actors: " + ConvertGameUnitsToMeter(distanceBetweenActors) + " meters")

                    ;TODO: make distanceBetweenActors customisable
                    if (distanceBetweenActors <= 1000)
                        MiscUtil.WriteToFile("_pantella_radiant_dialogue.txt", "True", append=false)

                        Debug.Notification("Cast spell on Actor 1 by Actor 2")
                        ;have spell casted on Actor 1 by Actor 2
                        MantellaSpell.Cast(PotentialActor2.GetReference() as ObjectReference, PotentialActor1.GetReference() as ObjectReference)

                        ; MiscUtil.WriteToFile("_pantella_character_selected.txt", "False", append=false)

                        ; String character_selected = "False"
                        ; while character_selected == "False" 
                        ;     character_selected = MiscUtil.ReadFromFile("_pantella_character_selected.txt") as String
                        ; endWhile
                        Utility.Wait(0.5)

                        Debug.Notification("Waiting for character selection confirmation...")
                        String character_selection_enabled = "False"
                        while character_selection_enabled == "False" ; wait for the Mantella spell to give the green light that it is ready to load another actor
                            character_selection_enabled = MiscUtil.ReadFromFile("_pantella_character_selection.txt") as String
                        endWhile

                        Debug.Notification("Cast spell on Actor 2 by Actor 1")
                        MantellaSpell.Cast(PotentialActor1.GetReference() as ObjectReference, PotentialActor2.GetReference() as ObjectReference)
                    else
                        ;TODO: make this notification optional
                        Debug.Notification("Radiant dialogue attempted. No NPCs available")
                    endIf
                else
                    ;TODO: make this notification optional
                    Debug.Notification("Radiant dialogue attempted. NPCs too far away at " + ConvertGameUnitsToMeter(distanceToClosestActor) + " meters")
                    Debug.Notification("Max distance set to " + repository.radiantDistance + "m in Pantella MCM")
                endIf
            else
                Debug.Notification("Radiant dialogue attempted. No NPCs available")
            endIf

            Debug.Notification("Radiant conversation check complete, setting up for next check in " + repository.radiantFrequency as string + " seconds.")
            MantellaActorList.stop()
        endIf
    endIf
    Debug.Notification("Radiant conversation check completed.")
    RegisterForSingleUpdate(repository.radiantFrequency)
endEvent

;All the event listeners  below have 'if' clauses added after Mantella 0.9.2 (except ondying)
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if repository.playerTrackingOnItemAdded
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        
        string itemName = akBaseItem.GetName()
        if itemName != "" && itemName != "Iron Arrow" ; Papyrus hallucinates iron arrows
            string itemPickedUpMessage = playerName + " picked up " + itemName + ".\n"
            itemPickedUpMessage = "player<OnItemAdded>item_name=" + itemName + "\n"
            string sourceName = akSourceContainer.getbaseobject().getname()
            if sourceName != ""
                itemPickedUpMessage = "player<OnItemAddedFromDestination>item_name=" + itemName + "|source_name=" + sourceName + "\n"
            endIf
            
            ;Debug.MessageBox(itemPickedUpMessage)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", itemPickedUpMessage)
        endIf
    endif
EndEvent

Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if Repository.playerTrackingOnItemRemoved
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()

        string itemName = akBaseItem.GetName()
        if itemName != "" || itemName != "Iron Arrow" ; Papyrus hallucinates iron arrows
            string itemDroppedMessage = "player<OnItemRemoved>item_name=" + itemName + "\n"

            string destName = akDestContainer.getbaseobject().getname()
            if destName != ""
                itemDroppedMessage = "player<OnItemRemovedToDestination>item_name=" + itemName + "|source_name=" + destName + "\n"
            endIf
            
            ;Debug.MessageBox(itemDroppedMessage)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", itemDroppedMessage)
        endIf
    endif
endEvent

Event OnSpellCast(Form akSpell)
    if repository.playerTrackingOnSpellCast
        string spellCast = (akSpell as form).getname()
        if spellCast != "" 
            if spellCast != "Pantella" && spellCast != "PantellaPower" && spellCast != ""
                Actor player = Game.GetPlayer()
                String playerName = player.GetActorBase().GetName()
                string OnSpellCastMessage = "player<OnSpellCast>spell_cast=" + spellCast + "\n"
                ;Debug.Notification(playerName + " casted the spell "+ spellCast)
                MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnSpellCastMessage)
            endIf
        endIf
    endif
endEvent

String lastHitSource = ""
String lastAggressor = ""
Int timesHitSameAggressorSource = 0
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if repository.playerTrackingOnHit
        string aggressor = akAggressor.getdisplayname()
        string hitSource = akSource.getname()

        ; avoid writing events too often (continuous spells record very frequently)
        ; if the actor and weapon hasn't changed, only record the event every 5 hits
        if ((hitSource != lastHitSource) && (aggressor != lastAggressor)) || (timesHitSameAggressorSource > 5)
            lastHitSource = hitSource
            lastAggressor = aggressor
            timesHitSameAggressorSource = 0

            Actor player = Game.GetPlayer()
            String playerName = player.GetActorBase().GetName()
            string OnHitMessage = ""
            if (hitSource == "None") || (hitSource == "")
                OnHitMessage = "player<OnHit>aggressor=" + aggressor + "\n"
                ;Debug.MessageBox(aggressor + " punched the player.")
            else
                OnHitMessage = "player<OnHitFromSource>aggressor=" + aggressor + "|hit_source="+hitSource+"\n"
                ;Debug.MessageBox(aggressor + " hit the player with " + hitSource+".\n")
            endIf
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnHitMessage)
        else
            timesHitSameAggressorSource += 1
        endIf
    endif
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    ; check if radiant dialogue is playing, and end conversation if the player leaves the area
    String radiant_dialogue_active = MiscUtil.ReadFromFile("_pantella_radiant_dialogue.txt") as String
    if radiant_dialogue_active == "True"
        MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
    endIf

    if repository.playerTrackingOnLocationChange
        String currLoc = (akNewLoc as form).getname()
        if currLoc == ""
            currLoc = "Skyrim"
        endIf
        string OnHitMessage = "player<OnLocationChange>current_location=" + currLoc + "\n"
        ;Debug.MessageBox("Current location is now " + currLoc)
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnHitMessage)
    endif
endEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    if repository.playerTrackingOnObjectEquipped
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()

        string itemEquipped = akBaseObject.getname()
        if itemEquipped != ""
            string OnObjectEquippedMessage = "player<OnObjectEquipped>item_name="+itemEquipped+"\n"
            ;Debug.MessageBox(playerName + " equipped " + itemEquipped)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnObjectEquippedMessage)
        endIf
    endif
endEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    if repository.playerTrackingOnObjectUnequipped
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()

        string itemUnequipped = akBaseObject.getname()
        if itemUnequipped != ""
            string OnObjectUnequippedMessage = "player<OnObjectUnequipped>item_name="+itemUnequipped+"\n"
            ;Debug.MessageBox(playerName + " unequipped " + itemUnequipped)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnObjectUnequippedMessage)
        endIf
    endif
endEvent

Event OnPlayerBowShot(Weapon akWeapon, Ammo akAmmo, float afPower, bool abSunGazing)
    if repository.playerTrackingOnPlayerBowShot
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        String akAmmoName = akAmmo.GetName()
        String akWeaponName = akWeapon.GetName()
        string OnPlayerBowShotMessage = "player<OnBowShot>\n"
        if akAmmoName != ""
            if akWeaponName != ""
                OnPlayerBowShotMessage = "player<OnBowShotAmmoNamedWeaponNamed>item_name="+akWeaponName+"|ammo="+akAmmoName+"\n"
            else
                OnPlayerBowShotMessage = "player<OnBowShotAmmoNamed>ammo="+akAmmoName+"\n"
            endif
        else
            if akWeaponName != ""
                OnPlayerBowShotMessage = "player<OnBowShotWeaponNamed>item_name="+akWeaponName+"\n"
            endif
        endif
        ;Debug.MessageBox(playerName + " fired an arrow.")
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnPlayerBowShotMessage)
    endif
endEvent

Event OnSit(ObjectReference akFurniture)
    if repository.playerTrackingOnSit
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()

        ;Debug.MessageBox(playerName + " sat down.")
        String furnitureName = akFurniture.getbaseobject().getname()
        if furnitureName != ""
            string OnSitMessage = "player<OnSit>furniture_name="+furnitureName+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnSitMessage)
        endIf
    endif
endEvent

Event OnGetUp(ObjectReference akFurniture)
    if repository.playerTrackingOnGetUp
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        
        ;Debug.MessageBox(playerName + " stood up.")
        String furnitureName = akFurniture.getbaseobject().getname()
        if furnitureName != ""
            string OnGetUpMessage = "player<OnGetUp>furniture_name="+furnitureName+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnGetUpMessage)
        endIf
    endif
EndEvent

Event OnDying(Actor akKiller)
    MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
EndEvent

Event OnVampireFeed(Actor akTarget)
    if repository.playerTrackingOnVampireFeed
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        string OnVampireFeedMessage = "player<OnVampireFeed>target="+akTarget.getdisplayname()+"\n"
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnVampireFeedMessage)
    endif
EndEvent
Event OnPlayerFastTravelEnd(float afTravelDuration)
    if repository.playerTrackingOnFastTravelEnd
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        string OnVampireFeedMessage = "player<OnFastTravelEnd>travel_duration="+afTravelDuration+"\n"
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnVampireFeedMessage)
    endif
EndEvent
Event OnVampirismStateChanged(bool abVampire)
    if repository.playerTrackingOnVampirismStateChanged
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        string OnVampirismStateChangedMessage = ""
        if abVampire
            OnVampirismStateChangedMessage = "player<OnVampirismStateChangedTrue>\n"
        else
            OnVampirismStateChangedMessage = "player<OnVampirismStateChangedFalse>\n"
        endif
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnVampirismStateChangedMessage)
    endif
EndEvent
Event OnLycanthropyStateChanged(Bool abIsWerewolf)
    if repository.playerTrackingOnLycanthropyStateChanged
        Actor player = Game.GetPlayer()
        String playerName = player.GetActorBase().GetName()
        string OnLycanthropyStateChangedMessage = ""
        if abIsWerewolf
            OnLycanthropyStateChangedMessage = "player<OnLycanthropyStateChangedTrue>\n"
        else
            OnLycanthropyStateChangedMessage = "player<OnLycanthropyStateChangedFalse>\n"
        endif
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnLycanthropyStateChangedMessage)
    endif
EndEvent