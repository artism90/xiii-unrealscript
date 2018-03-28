//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16AmmoPlus extends M16Ammo;

//_____________________________________________________________________________
simulated function bool HasAmmo()
{
    return true;
}



defaultproperties
{
     bInfiniteAmmo=True
     PlayerTransferClassName="XIII.M16Ammo"
     ItemName="5.56 INFINITE"
}
