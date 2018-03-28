//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ZigouillateurTriggerBis extends Triggers;

var() Array<Actor> PersosAZigouiller;

//_____________________________________________________________________________
function Zigouill(actor Other)
{
    local int i;
    local XIIIPlayerPawn XPlayer;

    foreach DynamicActors(class'XIIIPlayerPawn', XPlayer)
      break;

    for (i=0;i<PersosAZigouiller.Length;i++)
    {
      if (PersosAZigouiller[i] != none)
      {
        if ( (XIIIPawn(PersosAZigouiller[i]) == none) || (XPlayer == none) )
          PersosAZigouiller[i].Destroy();
        else
        { // destroy only if not visible and not in player's hand
          if ( !XPlayer.Controller.CanSee(Pawn(PersosAZigouiller[i]))
          && ( XIIIPawn(PersosAZigouiller[i]) != XPlayer.LHand.pOnShoulder ) )
            PersosAZigouiller[i].Destroy();
        }
      }
    }
    TriggerEvent(event,self,Pawn(other));
    Destroy();
}

//_____________________________________________________________________________
event Touch(actor other)
{
    Zigouill(other);
}

//_____________________________________________________________________________
event Trigger(actor other, pawn eventinstigator)
{
    Zigouill(other);
}



defaultproperties
{
}
