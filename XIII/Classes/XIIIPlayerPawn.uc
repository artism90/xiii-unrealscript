//=============================================================================
// XIIIPlayerPawn.
//=============================================================================
class XIIIPlayerPawn extends XIIIPawn;

var travel SixSenseSkill SSSk;    // To memorize the actor (not searching it everytime.
var travel bool bCanStun;         // to memorize the stunning ability
var travel bool bIsSniper;        // to memorize sniper ability
var travel bool bSilent;          // to memorize silentwalk skill
var sound hHealSound;

//var float LastSnipercheckTime;

//_____________________________________________________________________________
exec function SC( bool b )
{
    bSpineControl = b;
}

//_____________________________________________________________________________
// ELR
simulated event PostBeginPlay()
{
    if ( Level.bLonePlayer )
      bActorShadows = false; // Cancel shadow for Solo player

    Super(Pawn).PostBeginPlay();
    SetTimer( 1.0, false );
    EnableChannelNotify(FIRINGCHANNEL, 1);
    SetTimer2(1.0, true);
}

//_____________________________________________________________________________
function YouCantClimb() // used to send message on-screen.
{
   PlayerController(Controller).MyHud.LocalizedMessage(class'XIIIDialogMessage', 5);
}

//_____________________________________________________________________________
event GainedChild( Actor Other )
{
    if ( XIIISkill(Other) == none ) // don't treat all the tests after
      return;

    if ( SniperSkill(Other) != none )
      bIsSniper = true;
    else if ( StunningSkill(Other) != none )
      bCanStun = true;
    else if ( SilentWalkSkill(Other) != none )
      bSilent = true;
}

/*
//_____________________________________________________________________________
event FellOutOfWorld()
{
    Log("PLAYER FellOutOfWorld !!!");
    if ( Role < ROLE_Authority )
      return;
    Health = -1;
    SetPhysics(PHYS_None);
    Weapon = None;
    Died(None, class'Gibbed', Location);
}
*/

//_____________________________________________________________________________
event Landed(vector HitNormal)
{
//    Log("PLAYER Landed");
// if receving Landed in hooked behaviour, then adjust speed to avoid dying of damages because of increasing speed
    if ( ( (Controller != none) && Controller.IsA('XIIIPlayerController') ) && ( XIIIPlayerController(Controller).bHooked ) )
      Velocity = vect(0,0,0);
    Super.Landed(HitNormal);
}

//_____________________________________________________________________________
// ELR CheckDamageLocation
function int GetDamageWarningSide( vector HitLocation )
{
    local vector offset;

    // Use the hitlocation to determine where the pawn is hit
    // Transform the worldspace hitlocation into objectspace
    // In objectspace, X is front to back Y is side to side, and Z is top to bottom
    offset = normal((HitLocation - Location) << Rotation);

//    Log("GetDamageWarningSide, Offset="$offset);
    if ( offset.y > 0.707 )
      return 1; // Right
    else if ( offset.x > 0.707 )
      return 0; // Front
    else if ( offset.x < -0.707 )
      return 3; // Back
    else
      return 2; // Left
}

//_____________________________________________________________________________
// ELR Take Damage with Damage Location
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    if ( Controller == none )
    { // should only happen when in flashback
      return;
    }
//    Log("PLAYER TakeDamage class="$DamageType);
    if ( (InstigatedBy != none) && (InstigatedBy != self) )
      if( XIIIPlayerController(Controller) != none )
        XIIIPlayerController(Controller).ClientAddDamageWarn( GetDamageWarningSide(InstigatedBy.Location) );
//        XIIIBaseHUD(XIIIPlayerController(Controller).MyHud).AddDamageWarn( GetDamageWarningSide(InstigatedBy.Location) );

    if ( ( Level.bLonePlayer ) && ( DamageType==class'DTGrenaded' || DamageType==class'DTRocketed' ) )
    {
      XIIIPlayerController(Controller).MaxShakeFrame.X = 0.12;
      XIIIPlayerController(Controller).MaxShakeFrame.Y = 0.09;
      XIIIPlayerController(Controller).MaxShakeFrame.Z = Level.TimeSeconds; // EffectStartDate
      XIIIPlayerController(Controller).ShakeFrameTime = 3; //0.06*100;
    }
    if( ( Level.bLonePlayer ) && ( damageType != class'DTFell') )
    {
      Damage *= ((1+Level.Game.Difficulty)*0.15+Level.AdjustDifficulty/100);
    }
    Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
}

//_____________________________________________________________________________
// ELR to heal
function Heal(int H)
{
    Local int i;

//    log("Heal called w/ ammount="$H);
    Health = Min(Default.Health, Health+H);
    PlaySound(hHealSound);
//    CheckMaluses(); // no need in this now that we don't have any negative fx for low health
}

//_____________________________________________________________________________
function bool CanStun(optional XIIIPawn P)
{
    local vector U,V;

    if ( Region.Zone.FlashEffectDesc.IsActivated )
      return false;
    if ( DecoWeapon(Weapon) != none )
      return true;
    if ( !bCanStun )
      return false;

    U = P.Location - Location; U.Z = 0.0;
    V = vector(P.rotation); V.Z = 0.0;
    return ( (U dot V > 0.707) && (Fists(Weapon) != none) && XIIIPlayerController(controller).bWeaponMode );
}

//_____________________________________________________________________________
simulated function bool CanHoldDualWeapons()
{
    return ( FindInventoryKind('DualWeaponSkill') != none );
}

//_____________________________________________________________________________
event Heard(float Loudness, Actor NoiseMaker)
{
    if ( SSSk == none )
      return;
    if ( Region.Zone.FlashEffectDesc.IsActivated )
      return;

    if ( XIIIPawn(NoiseMaker) != none )
      SSSk.Heard(NoiseMaker);
    else
      SSSk.ResetTimer();
//      log(self@"heard"@NoiseMaker@"w/ loudness="$Loudness);
}

function bool IsDead()
{
    if ( Health <= 0 )
      return true;
    return false;
}
//_____________________________________________________________________________
// used for Six Sense skill update
event Timer2()
{
    if ( SSSk != none )
    {
      if ( (bMoving && !bIsWalking) || ((Physics == PHYS_Falling) && !XIIIPlayerController(Controller).bHooked)  )
        SSSk.ResetTimer();
      if ( (LHand != none) && (LHand.pOnShoulder != none) && !LHand.pOnShoulder.bIsDead )
        SSSk.ResetTimer();
      if ( XIIIPlayerController(Controller).bHooked && (hook(SelectedItem) != none) && (hook(SelectedItem).bGoUp || hook(SelectedItem).bGoDown) )
        SSSk.ResetTimer();
    }
}

//_____________________________________________________________________________
//Player Jumped
// ELR Added bAllowJump (Pawn Grabbed)
function DoJump( bool bUpdating )
{
    Super.DoJump( bUpdating );
    Timer();
}

//_____________________________________________________________________________
//
simulated function Tick(float DT)
{
    local int i;
    local XIIIPawn XP;

    if ( ((Controller != None) && Controller.bControlAnimations) || (Controller == none) )
    {
      SetBoneDirection( FIRINGBLENDBONE, rot(0,0,0), vect(0,0,0), 0.0 );
    }

    if ( BaffeTimer > 0.0 )
    {
      BaffeTimer -= DT;
      if ( BaffeTimer <= 0.0 )
      {
        bPaf = true;
        Timer();
      }
    }
    if (MyOldAcceleration != Acceleration)
    {
      if (MyOldAcceleration == vect(0,0,0)) // Start to move
      {
        if ( bDBAnim ) Log("@@ Tick == Animation Start Moving");
        bMoving=true;
        Timer();
      }
      else if ( Acceleration == vect(0,0,0) ) // Stopped moving
      {
        if ( bDBAnim ) Log("@@ Tick == Animation Stop Moving");
        if ( bMoving && (Physics == PHYS_Walking) )
          PlayEndStep();
        bMoving=false;
        Timer();
      }
    }
    MyOldAcceleration = Acceleration;

    // Auto pickup when touching corpses

    if( Controller == none )
        return;

    if ( Level.bLonePlayer && Controller.IsA('XIIIPlayerController') && XIIIPlayerController(Controller).bAutoPickup && (Touching.Length > 0) )
    {
      for (i=0; i<Touching.Length; i++)
      {
        XP = XIIIPawn(Touching[i]);
        if ( (XP != none) && XP.bSearchable && (XP.Inventory != none) )
        {
//          Log("@@@ AUTOPICKUP On touching"@XP);
          XIIIPlayerController(Controller).SearchPawn(XP);
        }
      }
    }
}

/*
//_____________________________________________________________________________
event Touch(actor other)
{
    local XIIIPawn XP;

    Log(self@"touched"@other);
    XP = XIIIPawn(Other);
    if ( (XP.Inventory != none) && XIIIPlayerController(Controller).bAutoPickup )
    {
      XIIIPlayerController(Pawn(Other).Controller).SearchPawn(XP);
    }
}
*/

//_____________________________________________________________________________
function HandlePickup(Pickup pick)
{
    if ( Level.NetMode == NM_StandAlone ) // else pickup sounds will by played by replication
    { // solo/multi offline playing pickup sound
//      Log(Self@"SND HandlePickup"@Pick.PickupSound);
      PlaySound(Pick.PickupSound);
    }
    Super.HandlePickup(pick);
}

//_____________________________________________________________________________
simulated event PlayEndStep()
{
    local material M;
//    local actor A;
//    local vector HitLoc, HitNorm;

    if ( (base == none) || (bIsWalking && bSilent) )
      return; // avoid all cases to prevent trace abuse

//    A = Trace(HitLoc, HitNorm, Location - (CollisionHeight + CollisionRadius) * vect(0,0,1), location, true, vect(0,0,0), M);
    M = LastCollidedMaterial;

/*
    if ( TerrainInfo(A) != none )
    {
      if ( Level.bReplaceHXScripts )
        PlaySndXIIIStep(TerrainInfo(A).XIIISndStep, vsize(velocity), -2, bSilent );
      else
        PlaySound(TerrainInfo(A).XIIIFootstepSound, int(vsize(velocity)), -2, int(bSilent) );
      Instigator = self;
      if ( bIsWalking )
      {
        if ( !bSilent )
          MakeNoise(TerrainInfo(A).NoiseLoudness / 5.0);
      }
      else
      {
        if ( !bSilent )
          MakeNoise(TerrainInfo(A).NoiseLoudness);
        else
          MakeNoise(TerrainInfo(A).NoiseLoudness / 5.0);
      }
    }
    else */
    if (M != none)
    {
      if ( Level.bReplaceHXScripts )
        PlaySndXIIIStep(M.XIIISndStep, vsize(velocity), -2, bSilent );
      else
        PlaySound(M.XIIIFootstepSound, int(vsize(velocity)), -2, int(bSilent) );
      Instigator = self;
      if ( bIsWalking )
      {
        if ( !bSilent )
          MakeNoise(M.NoiseLoudness / 5.0);
      }
      else
      {
        if ( !bSilent )
          MakeNoise(M.NoiseLoudness);
        else
          MakeNoise(M.NoiseLoudness / 5.0);
      }
    }
}

//_____________________________________________________________________________
// ELR
event HeadVolumeChange(PhysicsVolume newHeadVolume)
{
    if ( (Level.NetMode == NM_Client) || (Controller == None) )
      return;

    SetBreatheOn(); // Security/Anti-bug purpose // ::TODO:: Check if may be removed

    //Log("@@@ "$self$" have HeadVolume"$HeadVolume@"newHeadVolume="$newHeadVolume@"Location="$Location);
    if ( HeadVolume.bWaterVolume )
    {
      if (!newHeadVolume.bWaterVolume)
      {
        if ( IsPlayerPawn() && (BreathTime > 0) && (BreathTime < 8) )
          Gasp();
        BreathTime = DTimerStep;
        DrownTimer += 2.0*DTimerStep;
        if ( IsPlayerPawn() )
          PlaySound(hSwimmingSound, 0);
        TriggerEvent('WaterSwitch', self, self);
        //Log("@@@ hSwimmingSound param 0");
      }
    }
    else
    {
      if ( newHeadVolume.bWaterVolume )
      {
        BreathTime = 0.5;
        bDrawBreathtimer = true;
        DrownTimer = min(UnderWaterTime, Drowntimer);
        if ( IsPlayerPawn() )
          PlaySound(hSwimmingSound, 1);
        if ( !HeadVolume.bWatervolume )
          TriggerEvent('WaterSwitch', self, self);
        //Log("@@@ hSwimmingSound param 1");
      }
    }
}
//_____________________________________________________________________________
simulated event PlayFootStep()
{
    local material M;
    local actor A;
    local vector HitLoc, HitNorm;

//    Log("PlayFootStep"@self@"base="$Base@"bMoving="$bMoving);
    if ( (base == none) || (!bMoving && IsLocallyControlled()) )
      return; // avoid all cases to prevent trace abuse

    if ( (Level.NetMode == NM_client) && !IsLocallyControlled() )
      A = Trace(HitLoc, HitNorm, Location - (CollisionHeight + CollisionRadius) * vect(0,0,1), location, true, vect(0,0,0), M);
    else
      M = LastCollidedMaterial;
//    Log(" > Material="$M);

    if (M != none)
    {
      if ( Level.bReplaceHXScripts )
        PlaySndXIIIStep(M.XIIISndStep, vsize(velocity), SoundStepCategory, bSilent );
      else
        PlaySound(M.XIIIFootstepSound, int(vsize(velocity)), SoundStepCategory, int(bSilent) );
      Instigator = self;
      if ( (bIsWalking && bSilent) || bIsCrouched )
        return;
      if ( bIsWalking )
      {
        if ( !bSilent )
          MakeNoise(M.NoiseLoudness / 10.0);
      }
      else
      {
        if ( !bSilent )
          MakeNoise(M.NoiseLoudness);
        else
          MakeNoise(M.NoiseLoudness / 10.0);
      }
    }
}

//_____________________________________________________________________________
// ELR Override dying begin state from xiiipawn
state Dying
{
    function BeginState()
    {
      if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
        LifeSpan = 1.0;
      SetTimer(2.0, false);

      SetPhysics(PHYS_Falling);
      bInvulnerableBody = true;
      if ( Controller != none )
        Controller.PawnDied();
    }
}



defaultproperties
{
     hHealSound=Sound'XIIIsound.XIIIPerso__XIII_othersOnos.XIII_othersOnos__hXIIIonoMedik'
     bCanCrouch=True
     bCanClimbLadders=True
     bCanStrafe=True
     bCanPickupInventory=True
     bSameZoneHearing=True
     bAdjacentZoneHearing=True
     bMuffledHearing=True
     bAroundCornerHearing=True
     bEnableSpineControl=True
     HearingThreshold=5600.000000
     PawnName="XIII"
     Alliance="Player"
     hJumpSound=Sound'XIIIsound.XIIIPerso__XIIIJump.XIIIJump__hXIIIJump'
     hHitSound=Sound'XIIIsound.XIIIPerso__XIIIPaf.XIIIPaf__hXIIIPaf'
     hNotifSwimSound=Sound'XIIIsound.XIIIPerso__XIIISwim.XIIISwim__hXIIISwim'
     bInteractive=False
     bHasRollOff=False
     bHasPosition=False
     Mesh=SkeletalMesh'XIIIPersos.XIIIM'
}
