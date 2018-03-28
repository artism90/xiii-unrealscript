//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16Peace extends M16;

//_____________________________________________________________________________
simulated function Fire( float Value )
{
    Super.Fire(Value);
//    ReloadCount = default.ReloadCount;
}

//_____________________________________________________________________________
function ServerFire()
{
    Super.ServerFire();
//    ReloadCount = default.ReloadCount;
}



defaultproperties
{
     AmmoName=Class'XIII.M16AmmoPeace'
     PickupAmmoCount=999
     PlayerTransferClassName="XIII.M16"
     ItemName="M16 Peace&Love Model"
}
