//-----------------------------------------------------------
//
//-----------------------------------------------------------
class c9mmAmmoPlus extends c9mmAmmo;

//_____________________________________________________________________________
simulated function bool HasAmmo()
{
    return true;
}


defaultproperties
{
     bInfiniteAmmo=True
     PlayerTransferClassName="XIII.c9mmAmmo"
     ItemName="9MM INFINITE"
}
