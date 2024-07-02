Scriptname MantellaEndConversationScript extends activemagiceffect  

event OnEffectStart(Actor target, Actor caster)
    MiscUtil.WriteToFile("_pantella_end_conversation.txt", "True",  append=false)
endEvent