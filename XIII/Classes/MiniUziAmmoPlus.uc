//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MiniUziAmmoPlus extends MiniUziAmmo;

//_____________________________________________________________________________
simulated function bool HasAmmo()
{
    return true;
}



defaultproperties
{
     bInfiniteAmmo=True
     PlayerTransferClassName="XIII.MiniUziAmmo"
     ItemName="MINIUZI INFINITE"
}
