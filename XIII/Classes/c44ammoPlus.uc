//-----------------------------------------------------------
//
//-----------------------------------------------------------
class c44ammoPlus extends c44Ammo;

//_____________________________________________________________________________
simulated function bool HasAmmo()
{
    return true;
}


defaultproperties
{
     bInfiniteAmmo=True
     PlayerTransferClassName="XIII.c44Ammo"
     ItemName=".44 INFINITE"
}
