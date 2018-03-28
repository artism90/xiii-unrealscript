//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ZigouillateurTrigger extends Triggers;

var() Array<Actor> PersosAZigouiller;

//_____________________________________________________________________________
function Zigouill(actor Other)
{
    local int i;

    for (i=0; i<PersosAZigouiller.Length; i++)
    {
      if (PersosAZigouiller[i] != none)
      {
        if ( (XIIIPawn(PersosAZigouiller[i]) == none) || (XIIIPlayerPawn(Other) == none) )
          PersosAZigouiller[i].Destroy();
        else
        { // destroy only if not visible and not in player's hand
          if ( !Pawn(Other).Controller.CanSee(Pawn(PersosAZigouiller[i]))
          && ( XIIIPawn(PersosAZigouiller[i]) != XIIIPlayerPawn(Other).LHand.pOnShoulder ) )
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
    if ( Pawn(Other).IsPlayerPawn() )
      Zigouill(other);
}

//_____________________________________________________________________________
event Trigger(actor other, pawn eventinstigator)
{
    if ( EventInstigator.IsPlayerPawn() )
      Zigouill(other);
}



defaultproperties
{
}
