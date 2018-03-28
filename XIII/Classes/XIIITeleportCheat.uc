//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIITeleportCheat extends NavigationPoint
    PlaceAble;

var bool bLastUsed;    // to say this is the last teleporter used
var() XIIITeleportCheat NextXIIITeleportCheat;
var() array< class<Inventory> > InventoryGiven;

//_____________________________________________________________________________
function GiveSomething(class<Inventory> ItemClass, XIIIPawn P)
{
  local Inventory NewItem;

  if( P.FindInventoryType(ItemClass)==None )
  {
    NewItem = Spawn(ItemClass,,,P.Location);
    if( NewItem != None )
      NewItem.GiveTo(P);
  }
  else if ( Class<Ammunition>(ItemClass) != none )
  {
    NewItem = P.FindInventoryType(ItemClass);
    if (NewItem != None)
      Ammunition(NewItem).AmmoAmount += Class<Ammunition>(ItemClass).default.AmmoAmount;
  }
}

//_____________________________________________________________________________
function TeleportPlayer(XIIIPlayerPawn P)
{
    local int i;
    local Inventory Inv;

    Log("Incoming Teleported Player "$P$" for "$self);
    P.SetLocation(Location);
    P.SetRotation(Rotation);
    P.controller.SetRotation(Rotation);
    TriggerEvent(Event, self, P);
    for (i=0; i<InventoryGiven.Length; i++)
    {
      GiveSomething( InventoryGiven[i], P);
    }
}



defaultproperties
{
     Texture=Texture'Engine.S_Teleport'
     bDirectional=True
}
