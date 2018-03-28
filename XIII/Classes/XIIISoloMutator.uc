//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIISoloMutator extends Mutator;

//_____________________________________________________________________________
function bool CheckRelevance(Actor Other)
{
    // ELR Optimiza, dynamic load mesh for weapons at the init
    if ( (XIIIWeaponPickup(Other) != none) && (class<XIIIWeapon>(XIIIWeaponPickup(Other).InventoryType).default.MeshName != "") )
    {
      DynamicLoadObject(class<XIIIWeapon>(XIIIWeaponPickup(Other).InventoryType).default.MeshName, class'mesh');
    }
    if ( (XIIIDecoPickup(Other) != none) && (class<XIIIWeapon>(XIIIDecoPickup(Other).InventoryType).default.MeshName != "") )
    {
      DynamicLoadObject(class<XIIIWeapon>(XIIIDecoPickup(Other).InventoryType).default.MeshName, class'mesh');
    }
    if ( (XIIIPickup(Other) != none) && (class<XIIIItems>(XIIIPickup(Other).InventoryType)!=none) && (class<XIIIItems>(XIIIPickup(Other).InventoryType).default.MeshName!="") )
    {
      DynamicLoadObject(class<XIIIItems>(XIIIPickup(Other).InventoryType).default.MeshName, class'mesh');
    }
    return Super.CheckRelevance(other);
}



defaultproperties
{
     DefaultWeaponName="XIII.Fists"
}
