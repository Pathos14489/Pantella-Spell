Scriptname MantellaMCM_PlayerTrackingSettings  Hidden 
{This is the menu page for setting for player events tracking.}
function Render(MantellaMCM mcm, MantellaRepository Repository) global
     ;This part of the MCM MainSettings script pretty much only serves to tell papyrus what button to display.
    mcm.SetCursorFillMode(mcm.TOP_TO_BOTTOM)
    LeftColumn(mcm, Repository)
    mcm.SetCursorPosition(1)
    ;RightColumn(mcm, Repository)
endfunction


function LeftColumn(MantellaMCM mcm, MantellaRepository Repository) global
     ;This part of the MCM MainSettings script pretty much only serves to tell papyrus what button to display using properties from the repository
    mcm.AddHeaderOption ("Tracked events")
    mcm.oid_playerTrackingOnItemAdded=mcm.AddToggleOption("Item Added", repository.playerTrackingOnItemAdded)
    mcm.oid_playerTrackingOnItemRemoved=mcm.AddToggleOption("Item removed", repository.playerTrackingOnItemRemoved)
    mcm.oid_playerTrackingOnSpellCast=mcm.AddToggleOption("Spell cast", repository.playerTrackingOnSpellCast)
    mcm.oid_playerTrackingOnHit=mcm.AddToggleOption("Player is hit", repository.playerTrackingOnHit)
    mcm.oid_playerTrackingOnLocationChange=mcm.AddToggleOption("Location changes", repository.playerTrackingOnLocationChange)
    mcm.oid_playerTrackingOnObjectEquipped=mcm.AddToggleOption("Object equipped", repository.playerTrackingOnObjectEquipped)
    mcm.oid_playerTrackingOnObjectUnequipped=mcm.AddToggleOption("Object unequipped", repository.playerTrackingOnObjectUnequipped)
    mcm.oid_playerTrackingOnPlayerBowShot=mcm.AddToggleOption("Player shoots arrow", repository.playerTrackingOnPlayerBowShot)
    mcm.oid_playerTrackingOnSit=mcm.AddToggleOption("Player sitting", repository.playerTrackingOnSit)
    mcm.oid_playerTrackingOnGetUp=mcm.AddToggleOption("Player getting up", repository.playerTrackingOnGetUp)
    mcm.oid_playerTrackingOnVampireFeed=mcm.AddToggleOption("Player feeding as vampire", repository.playerTrackingOnVampireFeed)
    mcm.oid_playerTrackingOnFastTravelEnd=mcm.AddToggleOption("How long fast travel took", repository.playerTrackingOnFastTravelEnd)
    mcm.oid_playerTrackingOnVampirismStateChanged=mcm.AddToggleOption("Player vampirism state changed", repository.playerTrackingOnVampirismStateChanged)
    mcm.oid_playerTrackingOnLycanthropyStateChanged=mcm.AddToggleOption("Player lycanthropy state changed", repository.playerTrackingOnLycanthropyStateChanged)
    mcm.oid_playerTrackingAll=mcm.AddToggleOption("All", mcm.playerAllToggle)
endfunction

;function RightColumn(MantellaMCM mcm, MantellaRepository Repository) global   
;endfunction


function OptionUpdate(MantellaMCM mcm, int optionID, MantellaRepository Repository) global
    ;checks option per option what the toggle is and the updates the var repository MantellaRepository so the ListenerScript can access it
    if optionID==mcm.oid_playerTrackingOnItemAdded
        repository.playerTrackingOnItemAdded=!mcm.repository.playerTrackingOnItemAdded
        mcm.SetToggleOptionValue(mcm.oid_playerTrackingOnItemAdded, repository.playerTrackingOnItemAdded)
    ElseIf optionID==mcm.oid_playerTrackingOnItemRemoved
        repository.playerTrackingOnItemRemoved=!repository.playerTrackingOnItemRemoved
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnItemRemoved, repository.playerTrackingOnItemRemoved)
    ElseIf optionID==mcm.oid_playerTrackingOnSpellCast
        repository.playerTrackingOnSpellCast=!repository.playerTrackingOnSpellCast
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnSpellCast, repository.playerTrackingOnSpellCast)
    ElseIf optionID==mcm.oid_playerTrackingOnHit
        repository.playerTrackingOnHit=!repository.playerTrackingOnHit
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnHit, repository.playerTrackingOnHit)
    ElseIf optionID==mcm.oid_playerTrackingOnLocationChange
        repository.playerTrackingOnLocationChange=!repository.playerTrackingOnLocationChange
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnLocationChange, repository.playerTrackingOnLocationChange)
    ElseIf optionID==mcm.oid_playerTrackingOnObjectEquipped
        mcm.repository.playerTrackingOnObjectEquipped=!mcm.repository.playerTrackingOnObjectEquipped
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnObjectEquipped, mcm.repository.playerTrackingOnObjectEquipped)
     ElseIf optionID==mcm.oid_playerTrackingOnObjectUnequipped
        repository.playerTrackingOnObjectUnequipped=!repository.playerTrackingOnObjectUnequipped
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnObjectUnequipped, repository.playerTrackingOnObjectUnequipped)
    ElseIf optionID==mcm.oid_playerTrackingOnPlayerBowShot
        repository.playerTrackingOnPlayerBowShot=!repository.playerTrackingOnPlayerBowShot
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnPlayerBowShot, repository.playerTrackingOnPlayerBowShot)
    ElseIf optionID==mcm.oid_playerTrackingOnSit
        repository.playerTrackingOnSit=!repository.playerTrackingOnSit
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnSit, repository.playerTrackingOnSit)
    ElseIf optionID==mcm.oid_playerTrackingOnGetUp
        repository.playerTrackingOnGetUp=!repository.playerTrackingOnGetUp
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnGetUp, repository.playerTrackingOnGetUp)
    ElseIf optionID==mcm.oid_playerTrackingOnVampireFeed
        repository.playerTrackingOnVampireFeed=!repository.playerTrackingOnVampireFeed
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnVampireFeed, repository.playerTrackingOnVampireFeed)
    ElseIf optionID==mcm.oid_playerTrackingOnFastTravelEnd
        repository.playerTrackingOnFastTravelEnd=!repository.playerTrackingOnFastTravelEnd
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnFastTravelEnd, repository.playerTrackingOnFastTravelEnd)
    ElseIf optionID==mcm.oid_playerTrackingOnVampirismStateChanged
        repository.playerTrackingOnVampirismStateChanged=!repository.playerTrackingOnVampirismStateChanged
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnVampirismStateChanged, repository.playerTrackingOnVampirismStateChanged)
    ElseIf optionID==mcm.oid_playerTrackingOnLycanthropyStateChanged
        repository.playerTrackingOnLycanthropyStateChanged=!repository.playerTrackingOnLycanthropyStateChanged
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnLycanthropyStateChanged, repository.playerTrackingOnLycanthropyStateChanged)
    ElseIf optionID==mcm.oid_playerTrackingAll
        ;This part of the function OptionUpdate flips a bunch of variables in the repository at once :
        mcm.playerAllToggle=!mcm.playerAllToggle
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnItemAdded, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnItemRemoved, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnSpellCast, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnHit, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnLocationChange, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnObjectEquipped, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnObjectUnequipped, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnPlayerBowShot, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnSit, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnGetUp, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnVampireFeed, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnFastTravelEnd, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnVampirismStateChanged, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingOnLycanthropyStateChanged, mcm.playerAllToggle)
        mcm.SetToggleOptionValue( mcm.oid_playerTrackingAll, mcm.playerAllToggle)
        Repository.playerTrackingOnItemAdded=mcm.playerAllToggle
        Repository.playerTrackingOnItemRemoved=mcm.playerAllToggle
        Repository.playerTrackingOnSpellCast=mcm.playerAllToggle
        Repository.playerTrackingOnHit=mcm.playerAllToggle
        Repository.playerTrackingOnLocationChange=mcm.playerAllToggle
        Repository.playerTrackingOnObjectEquipped=mcm.playerAllToggle
        Repository.playerTrackingOnObjectUnequipped=mcm.playerAllToggle
        Repository.playerTrackingOnPlayerBowShot=mcm.playerAllToggle
        Repository.playerTrackingOnSit=mcm.playerAllToggle
        Repository.playerTrackingOnGetUp=mcm.playerAllToggle
        Repository.playerTrackingOnVampireFeed=mcm.playerAllToggle
        Repository.playerTrackingOnFastTravelEnd=mcm.playerAllToggle
        Repository.playerTrackingOnVampirismStateChanged=mcm.playerAllToggle
        Repository.playerTrackingOnLycanthropyStateChanged=mcm.playerAllToggle
    endif
endfunction 

