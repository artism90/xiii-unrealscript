//-----------------------------------------------------------
//  Beretta w/ infinite ammo
//-----------------------------------------------------------
class BerettaPeace extends Beretta;

//_____________________________________________________________________________
simulated function Fire( float Value )
{
    Super.Fire(Value);
    ReloadCount = default.ReloadCount;
}

//_____________________________________________________________________________
function ServerFire()
{
    Super.ServerFire();
    ReloadCount = default.ReloadCount;
}


defaultproperties
{
     bCanHaveSlave=False
     AmmoName=Class'XIII.c9mmAmmoPeace'
     PlayerTransferClassName="XIII.Beretta"
     ItemName="BERETTA Peace&Love Model"
}
