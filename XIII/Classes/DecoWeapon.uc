//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoWeapon extends XIIIWeapon;

var int memWeaponGroup;

var bool membWeaponMode;
var bool bFired;
var bool bProjectileThrown;

var class<emitter> SFXWhenBroken;
var class<emitter> SFXWhenBrokenNotPawn;
var class<emitter> SFXWhenBrokenNoTgt;
var float fDelaySFXBroken;
var float fDelayShake;

var sound hDownSound;
var sound hDownUnusedSound;

//_____________________________________________________________________________
function NewWeaponNotify(Pawn Other);

//_____________________________________________________________________________
simulated function Fire( float Value )
{
    bFired = true;
    Super.Fire(Value);
}

//_____________________________________________________________________________
simulated function DetachFromPawn(Pawn P)
{
    if ( ThirdPersonActor != None )
    {
      ThirdPersonActor.Destroy();
      ThirdPersonActor = None;
    }
//  	SetDrawType(DT_None); // can't be used else anims won't play and base soldiers won't work
//    bHidden = true; // ELR can't set bhidden here because when downing it will hide the down anim
}

//_____________________________________________________________________________
// Deco Weapon always are best weapons to change to (not allowed to stay in inv anyway)
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    return self;
}
simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    return self;
}

//_____________________________________________________________________________
function GiveTo(Pawn Other)
{
    // We must get this weapon in hand when we grab it.
    // but memorize the player state.
    if ( XIIIPlayerController(Other.controller).bWeaponMode && (Other.weapon != none) && (DecoWeapon(Other.weapon) == none) )
    {
      DebugLog(self@"Decoweapon Giveto, Memorize WEAPON");
      MemWeaponGroup = Other.weapon.InventoryGroup;
      MembWeaponMode =  XIIIPlayerController(Other.controller).bWaitForWeaponMode;
    }
    else if ( XIIIPlayerController(Other.controller).bWeaponMode && (Other.Weapon == none) )
    {
      DebugLog(self@"Decoweapon Giveto, Memorize NO WEAPON");
      MemWeaponGroup = 0;
      MembWeaponMode =  XIIIPlayerController(Other.controller).bWaitForWeaponMode;
    }
    else if ( !XIIIPlayerController(Other.controller).bWeaponMode )
    {
      DebugLog(self@"Decoweapon Giveto, Memorize ITEM");
      MemWeaponGroup = 0;
      MembWeaponMode =  false;
    }
    else
    { // not possible anymore but just in case come back
      DebugLog(self@"Decoweapon Giveto, Memorize Weapon WAS DECO");
      MemWeaponGroup = DecoWeapon(Other.weapon).MemWeaponGroup;
      MembWeaponMode = DecoWeapon(Other.weapon).MembWeaponMode;
    }
    if ( membWeaponMode )
    { // Player In weapon mode state, just switch weapon
      Super.GiveTo(Other);
      DebugLog(self@"Decoweapon Giveto, WEAP in hand");
      XIIIPlayerController(Other.controller).SwitchWeapon(InventoryGroup);
    }
    else
    {
      // Player in Items mode, need to put down
      DebugLog(self@"Decoweapon Giveto, ITEM in hand putting down"@Other.SelectedItem);
      Other.PendingWeapon = self;
      Other.Weapon = self;
      Super.GiveTo(Other);
      XIIIItems(Other.SelectedItem).PutDown();
      XIIIPlayerController(Other.controller).bWaitForWeaponMode = true;
//      XIIIPlayerController(Instigator.controller).SwitchWeaponMode();
//      XIIIPlayerController(Instigator.controller).Pawn.PendingWeapon = self;
//      XIIIPlayerController(Instigator.controller).NextWeapon();
//      XIIIPlayerController(Instigator.controller).SwitchWeapon(InventoryGroup);
    }
}

//_____________________________________________________________________________
// ELR Text to be displayed in HUD
simulated function string GetAmmoText(out int bDrawbulletIcon)
{
    local string AmmoText;

    AmmoText = ItemName;
    bDrawbulletIcon = 0;
    return AmmoText;
}

//_____________________________________________________________________________
function ProjectileAltFire()
{
    bProjectileThrown = true;
    Super.ProjectileAltFire();
}

//_____________________________________________________________________________
simulated function LocalFire()
{
    local PlayerController P;

    if ( DBWeap ) Log("  Localfire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@" HasAmmo="$HasAmmo());

    if ( HasAmmo() )
    {
      if ( (Instigator != None) && Instigator.IsLocallyControlled() )
      {
        P = PlayerController(Instigator.Controller);
        if (P!=None)
          SetTimer2(fDelayShake, false);
//          P.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, ShakeCycles);
      }
    }
    PlayFiring();
}

//_____________________________________________________________________________
simulated event Timer2()
{
    local PlayerController P;

    P = PlayerController(Instigator.Controller);
    P.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, ShakeCycles);
}

//_____________________________________________________________________________
function Finish()
{
    if ( DBWeap ) Log("Decoweapon Finish in state"@GetStateName());

    if ( GetStateName() == 'Active' )
    {
      GotoState('Idle');
      return;
    }
    // Owner must restore states, this one is OoO
//    if ( bChangeWeapon )
      GotoState('DownWeapon');
}

//_____________________________________________________________________________
function AltFinish()
{
    Finish();
}

//_____________________________________________________________________________
State DownWeapon
{
    simulated function AnimEnd(int Channel)
    {
      if ( DBWeap ) Log("DOWNWEAPON AnimEnd for"@self);

      Instigator.PendingWeapon = none;
      Instigator.Weapon = none;
      PlayerController(Instigator.Controller).SwitchWeapon(MemWeaponGroup);
      if ( !XIIIPlayerController(Instigator.Controller).bWaitForWeaponMode )
         XIIIPlayerController(Instigator.controller).HideWeapon();
      if ( DBWeap ) Log("           Restoring Previous weapon "$Instigator.PendingWeapon);

      bChangeWeapon = false;
      Pawn(Owner).ChangedWeapon();
      AmmoType.Destroy();
      bRendered = false;
      bHidden = true;
      RefreshDisplaying();
      Destroy();
    }
    simulated function BeginState()
    {
//      Log("DOWNWEAPON BeginState for"@self);
      Super.BeginState();
      DetachFromPawn(Instigator);
      if ( (fDelaySFXBroken > 0.0) && !bProjectileThrown && DecoAmmo(AmmoType).bUnused )
        SetTimer2(fDelaySFXBroken, false);
      else if ( !bProjectileThrown && (DecoAmmo(AmmoType).bUnused) )
        Spawn(SFXWhenBrokenNoTgt,self,,Location+vector(owner.rotation)*120.0, owner.rotation);
    }
    simulated event Timer2()
    {
      Spawn(SFXWhenBrokenNoTgt,self,,Location+vector(owner.rotation)*120.0, owner.rotation);
    }
}

//_____________________________________________________________________________
/* Bring newly active weapon up.
The weapon will remain in this state while its selection animation is being played (as well as any postselect animation).
While in this state, the weapon cannot be fired.
*/
state Active
{
    simulated function bool PutDown()
    { // for deco weapons don't allow putdown till the end of the state (else will keep some inventory & will not be able to grab same later
      bChangeWeapon = true;
      return True;
    }
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    PlayAnim('Down', 1.0);
    Instigator.PlayRolloffSound(hDownSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
    if (!bProjectileThrown && DecoAmmo(AmmoType).bUnused)
      Instigator.PlayRolloffSound(hDownUnusedSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}

//_____________________________________________________________________________
simulated event FPSDownNote1()
{
    if (!bProjectileThrown && DecoAmmo(AmmoType).bUnused)
      Instigator.PlayRolloffSound(hDownSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 1 );
    if (!bProjectileThrown && DecoAmmo(AmmoType).bUnused)
      Instigator.PlayRolloffSound(hDownUnusedSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 1 );
}


defaultproperties
{
     fDelaySFXBroken=0.300000
     fDelayShake=0.600000
     bMeleeWeapon=True
     WHand=WHA_Deco
     AmmoName=Class'XIII.DecoAmmo'
     PickupAmmoCount=1
     FireOffset=(Y=5.000000,Z=-2.000000)
     ShotTime=0.700000
     FiringMode="FM_Stun"
     FireNoise=0.400000
     EmptyFiringAnim="Fire"
     ShakeMag=1600.000000
     shaketime=6.000000
     ShakeVert=(Z=30.000000)
     ShakeSpeed=(X=500.000000,Y=500.000000,Z=500.000000)
     ShakeCycles=4.000000
     AIRating=-5.000000
     TraceDist=30.000000
     InventoryGroup=20
     PlayerViewOffset=(X=5.000000,Y=4.500000,Z=-4.500000)
     ItemName="DECORATION"
     bTravel=False
     DrawScale=0.300000
}
