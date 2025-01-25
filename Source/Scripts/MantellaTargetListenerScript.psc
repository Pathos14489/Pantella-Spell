Scriptname MantellaTargetListenerScript extends ReferenceAlias
;new property added after Mantella 0.9.2
MantellaRepository property repository auto

;All the event listeners below have 'if' clauses added after Mantella 0.9.2 (except ondying)
Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
    if repository.targetTrackingItemAdded 
        String selfName = self.GetActorReference().getdisplayname()
        string itemName = akBaseItem.GetName()
        string itemPickedUpMessage = "npc<OnItemAdded>|name="+selfName+"|item="+itemName+"\n"
        string sourceName = akSourceContainer.getbaseobject().getname()
        if itemName != "Iron Arrow" && itemName != "" ;Papyrus hallucinates iron arrows
            if sourceName != ""
                itemPickedUpMessage = "npc<OnItemAddedFromDestination>|name="+selfName+"|item="+itemName+"|source="+sourceName+"\n"
            endIf
            ;Debug.Notification(itemPickedUpMessage)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", itemPickedUpMessage)
        endIf
    endif
EndEvent


Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
    if repository.targetTrackingItemRemoved  
        String selfName = self.GetActorReference().getdisplayname()
        string itemName = akBaseItem.GetName()
        if itemName != "" || itemName != "Iron Arrow" ; Papyrus hallucinates iron arrows
            string itemDroppedMessage = "npc<OnItemRemoved>name="+selfName+"|item_name=" + itemName + "\n"

            string destName = akDestContainer.getbaseobject().getname()
            if destName != ""
                itemDroppedMessage = "npc<OnItemRemovedToDestination>name="+selfName+"|item_name=" + itemName + "|source_name=" + destName + "\n"
            endIf
            ;Debug.Notification(itemDroppedMessage)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", itemDroppedMessage)
        endIf
    endif
endEvent


Event OnSpellCast(Form akSpell)
    if repository.targetTrackingOnSpellCast 
        String selfName = self.GetActorReference().getdisplayname()
        string spellCast = (akSpell as form).getname()
        if spellCast != "" 
            if spellCast != "Pantella" && spellCast != "PantellaPower" && spellCast != ""
                ;Debug.Notification(selfName+" casted the spell "+ spellCast)
                string OnSpellCastMessage = "npc<OnSpellCast>name="+selfName+"|spell_cast=" + spellCast + "\n"
                MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnSpellCastMessage)
            endIf
        endIf
    endif
endEvent


String lastHitSource = ""
String lastAggressor = ""
Int timesHitSameAggressorSource = 0
Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    if repository.targetTrackingOnSpellCast 
        String aggressor
        if akAggressor == Game.GetPlayer()
            aggressor = "[player]"
        else
            aggressor = akAggressor.getdisplayname()
        endif
        string hitSource = akSource.getname()
        String selfName = self.GetActorReference().getdisplayname()

        ; avoid writing events too often (continuous spells record very frequently)
        ; if the actor and weapon hasn't changed, only record the event every 5 hits
        if ((hitSource != lastHitSource) && (aggressor != lastAggressor)) || (timesHitSameAggressorSource > 5)
            lastHitSource = hitSource
            lastAggressor = aggressor
            timesHitSameAggressorSource = 0

            string OnHitMessage = ""
            if (hitSource == "None") || (hitSource == "")
                OnHitMessage = "npc<OnHit>name="+selfName+"|aggressor=" + aggressor + "\n"
                ;Debug.MessageBox(aggressor + " punched the player.")
            else
                OnHitMessage = "npc<OnHitFromSource>name="+selfName+"|aggressor=" + aggressor + "|hit_source="+hitSource+"\n"
                ;Debug.MessageBox(aggressor + " hit the player with " + hitSource+".\n")
            endIf
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnHitMessage)
        else
            timesHitSameAggressorSource += 1
        endIf
    endif
EndEvent


Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    if repository.targetTrackingOnCombatStateChanged
        String selfName = self.GetActorReference().getdisplayname()
        String targetName
        if akTarget == Game.GetPlayer()
            targetName = "[player]"
        else
            targetName = akTarget.getdisplayname()
        endif

        String combatStateMessage = ""
        if (aeCombatState == 0)
            ;Debug.MessageBox(selfName+" is no longer in combat")
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", selfName+" is no longer in combat.\n")
            combatStateMessage = "npc<OnCombatStateChanged0>name="+selfName+"|target="+targetName+"n"
        elseif (aeCombatState == 1)
            ;Debug.MessageBox(selfName+" has entered combat with "+targetName)
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", selfName+" has entered combat with "+targetName+".\n")
            combatStateMessage = "npc<OnCombatStateChanged1>name="+selfName+"|target="+targetName+"\n"
        elseif (aeCombatState == 2)
            ;Debug.MessageBox(selfName+" is searching for "+targetName)
            combatStateMessage = "npc<OnCombatStateChanged2>name="+selfName+"|target="+targetName+"\n"
        endIf
    endif
endEvent


Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
    if repository.targetTrackingOnObjectEquipped
        String selfName = self.GetActorReference().getdisplayname()
        string itemEquipped = akBaseObject.getname()
        if itemEquipped != ""
            ;Debug.MessageBox(selfName+" equipped " + itemEquipped)
            string OnObjectEquippedMessage = "npc<OnObjectEquipped>name="+selfName+"|item_name="+itemEquipped+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnObjectEquippedMessage)
        endIf
    endif
endEvent


Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
    if repository.targetTrackingOnObjectUnequipped
        String selfName = self.GetActorReference().getdisplayname()
        string itemUnequipped = akBaseObject.getname()
        if itemUnequipped != ""
            ;Debug.MessageBox(selfName+" unequipped " + itemUnequipped)
            string OnObjectUnequippedMessage = "npc<OnObjectUnequipped>name="+selfName+"|item_name="+itemUnequipped+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnObjectUnequippedMessage)
        endIf
    endif
endEvent


Event OnSit(ObjectReference akFurniture)
    if repository.targetTrackingOnSit
        String selfName = self.GetActorReference().getdisplayname()
        ;Debug.MessageBox(selfName+" sat down.")
        String furnitureName = akFurniture.getbaseobject().getname()
        ; only save event if actor is sitting / resting on furniture (and not just, for example, leaning on a bar table)
        if furnitureName != ""
            String OnSitMessage = "npc<OnSit>name="+selfName+"|furniture_name="+furnitureName+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnSitMessage)
        endIf
    endif
endEvent


Event OnGetUp(ObjectReference akFurniture)
    if  repository.targetTrackingOnGetUp
        String selfName = self.GetActorReference().getdisplayname()
        ;Debug.MessageBox(selfName+" stood up.")
        String furnitureName = akFurniture.getbaseobject().getname()
        ; only save event if actor is sitting / resting on furniture (and not just, for example, leaning on a bar table)
        if furnitureName != ""
            String OnGetUpMessage = "npc<OnGetUp>name="+selfName+"|furniture_name="+furnitureName+"\n"
            MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnGetUpMessage)
        endIf
    endif
EndEvent

Event OnDying(Actor akKiller)
    MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
EndEvent

Event OnVampireFeed(Actor akTarget)
    if repository.playerTrackingOnVampireFeed
        String selfName = self.GetActorReference().getdisplayname()
        string OnVampireFeedMessage = "npc<OnVampireFeed>name="+selfName+"|target="+akTarget.getdisplayname()+"\n"
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnVampireFeedMessage)
    endif
EndEvent
Event OnPlayerFastTravelEnd(float afTravelDuration)
    if repository.playerTrackingOnFastTravelEnd
        String selfName = self.GetActorReference().getdisplayname()
        string OnFastTravelEndMessage = "npc<OnFastTravelEnd>name="+selfName+"|travel_duration="+afTravelDuration+"\n"
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnFastTravelEndMessage)
    endif
EndEvent
Event OnVampirismStateChanged(bool abVampire)
    if repository.playerTrackingOnVampirismStateChanged
        String selfName = self.GetActorReference().getdisplayname()
        string OnVampirismStateChangedMessage = ""
        if abVampire
            OnVampirismStateChangedMessage = "npc<OnVampirismStateChangedTrue>name="+selfName+"\n"
        else
            OnVampirismStateChangedMessage = "npc<OnVampirismStateChangedFalse>name="+selfName+"\n"
        endif
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnVampirismStateChangedMessage)
    endif
EndEvent
Event OnLycanthropyStateChanged(Bool abIsWerewolf)
    if repository.playerTrackingOnLycanthropyStateChanged
        String selfName = self.GetActorReference().getdisplayname()
        string OnLycanthropyStateChangedMessage = ""
        if abIsWerewolf
            OnLycanthropyStateChangedMessage = "npc<OnLycanthropyStateChangedTrue>name="+selfName+"\n"
        else
            OnLycanthropyStateChangedMessage = "npc<OnLycanthropyStateChangedFalse>name="+selfName+"\n"
        endif
        MiscUtil.WriteToFile("_pantella_in_game_events.txt", OnLycanthropyStateChangedMessage)
    endif
EndEvent