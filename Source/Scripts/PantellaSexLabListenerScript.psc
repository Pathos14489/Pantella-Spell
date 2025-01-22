Scriptname PantellaSexLabListenerScript extends ReferenceAlias

Spell property MantellaSpell auto
Spell property MantellaPower auto;gia
MantellaRepository property repository auto
Quest Property MantellaActorList  Auto  
ReferenceAlias Property PotentialActor1  Auto  
ReferenceAlias Property PotentialActor2  Auto  
SexLabFramework Property SexLab auto
sslUtility Property sslU auto

event OnInit()
    Debug.Notification("Pantella SexLab Support Installed")
    UnregisterForModEvent("SexLabGameLoaded")
    UnregisterForModEvent("SexLabOrgasm")
    UnregisterForModEvent("HookAnimationStart")
    RegisterForModEvent("SexLabGameLoaded","OnSexLabGameLoaded")
    RegisterForModEvent("SexLabOrgasm", "OnSexLabOrgasm")
    RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
    Debug.Notification("Pantella has registered for SexLab events.")
endEvent

Event OnPlayerLoadGame()
    UnregisterForModEvent("SexLabGameLoaded")
    UnregisterForModEvent("SexLabOrgasm")
    UnregisterForModEvent("HookAnimationStart")
    RegisterForModEvent("SexLabGameLoaded","OnSexLabGameLoaded")
    RegisterForModEvent("SexLabOrgasm", "OnSexLabOrgasm")
    RegisterForModEvent("HookAnimationStart", "OnAnimationStart")
    Debug.Notification("Pantella has registered for SexLab events.")
EndEvent

Event OnSexLabGameLoaded()
    Debug.Notification("Pantella has detected Sexlab on game load!")
EndEvent

Event OnSexLabOrgasm(Actor ActorRef, int FullEnjoyment, int Orgasms)
    string ActorName = ActorRef.GetActorBase().GetName()
    Debug.Notification("SexLabOrgasm event triggered. " + ActorName + " had an orgasm with " + Orgasms + " orgasms at " + FullEnjoyment + " enjoyment.")
EndEvent

Event OnAnimationStart(int tid, bool HasPlayer)
    Debug.Notification("Pantella has detected that a SexLab animation has started!")
    Debug.Notification("Thread ID: " + tid)
    Debug.Notification("HasPlayer: " + HasPlayer)
    sslThreadController Thread = SexLab.GetController(tid)
    if Thread == None
        Debug.Notification("No thread controller found for thread ID " + tid)
    else
        sslBaseAnimation Animation = Thread.Animation
        Debug.Notification("Lead animation: " + Animation.Name)
    endif
EndEvent