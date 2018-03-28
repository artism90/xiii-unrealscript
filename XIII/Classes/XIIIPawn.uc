//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIPawn extends Pawn
  native;

var XIIILeftHand LHand;   // Left Hand of the character (holding corpses/prisoners)
var float fDrownCount;
var bool bSearchable;     // Can we search the body ?
var bool bIsInCine;       // Player in flashback
var int MaxHealth;
var(Cine_Behavior) int GameOverGoal;
var(Events) name EventOnGrab;

var float LastLandSoundTime;  // Used to avoid playing landed sound to often in case of physics crazyness
var float LastJumpSoundTime;  // Used to avoid playing Jump sound to often (Event PlayJump is called more than once, too touchy to debug now).

//_____________________________________________________________________________
// ELR Replicate things
replication
{
    // functions the client should send to the server.
    reliable if( Role<ROLE_Authority )
      ServerChangedItem;
}

/*
//_____________________________________________________________________________
exec function DBAnimStatus( name St )
{
    SetAnimStatus(St);
}

//_____________________________________________________________________________
exec function DBCartoon( bool b )
{
    bDBCartoon = b;
}
//_____________________________________________________________________________
exec function DBAnim( bool b )
{
    bDBAnim = b;
}
//_____________________________________________________________________________
exec function DBPawnAnim( bool b )
{
    local XIIIpawn P;

    foreach allactors(class'XIIIPawn', P)
      if ( (p != none) && !P.IsPlayerPawn() )
        P.bDBAnim = b;
}

//_____________________________________________________________________________
exec function DBAutoAim( bool b )
{
    bDBShowAutoAim = b;
}
*/
//_____________________________________________________________________________
// ELR ::DBUG:: To check damages effects
exec function TD( int ammount)
//exec function TD( int loc, int ammount)
{
      TakeDamage( ammount, self, Location, vect(0,0,0), class'DTFisted');
}

//_____________________________________________________________________________
// ELR
simulated event PostBeginPlay()
{
    Super(Pawn).PostBeginPlay();
    SetTimer( 1.0, false );
    EnableChannelNotify(FIRINGCHANNEL, 1);
    if ( bBoss )
      MaxHealth = Health;
    SplashTime = Level.TimeSeconds; // to avoid pawn spawning underwater to have their Splash
}

//_____________________________________________________________________________
simulated event Destroyed()
{
//    Log(self$" destroyed");
    if ( MyBloodPool != none )
      MyBloodPool.destroy();
    Super.Destroyed();
}

//_____________________________________________________________________________
// called once at the beginning for initialization
simulated event Timer()
{
    if ( bIsDead || IsDead() )
      return;

    if ( bPaf )
    {
      bPaf=false;
      AnimBlendToAlpha(FIRINGCHANNEL+2,0,0.1);
    }

    if ( (Shadow!=none) && Level.bLonePlayer && (XIIIGameInfo(Level.Game).MapInfo != none) )
    {
      Shadow.MaxTraceDistance = XIIIGameInfo(Level.Game).MapInfo.MaxTraceDistance;
      Shadow.ShadowIntensity = XIIIGameInfo(Level.Game).MapInfo.ShadowIntensity;
      Shadow.ShadowMaxDist = XIIIGameInfo(Level.Game).MapInfo.ShadowMaxDist;
      Shadow.ShadowTransDist = XIIIGameInfo(Level.Game).MapInfo.ShadowTransDist;
    }
    ChangeAnimation();
}

//_____________________________________________________________________________
simulated function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType)
{
    super.PlayTakeHit(HitLoc, Damage, damageType);
    if( ( !bIsDead && !IsDead() ) && ( bIsPafable ) )
    {
      bPaf = true;
      if ( !bIsCrouched )
      {
        Switch(WeaponMode)
        {
          Case 'FM_Snipe':
            PlayAnim('PafSniper',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_1H':
          Case 'FM_44Alt':
            PlayAnim('PafPistolet',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_2H':
          Case 'FM_M16':
          Case 'FM_ARAlt':
          Case 'FM_ShotGunAlt':
          Case 'FM_HarpoonAlt':
            PlayAnim('PafGun',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_Bazook':
          Case 'FM_BazookAlt':
            PlayAnim('PafBazooka',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_2HHeavy':
            PlayAnim('PafM60',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_Fists':
          Case 'FM_Throw':
          Case 'FM_Stun':
          default:
            PlayAnim('PafNeutre',,0.1,FIRINGCHANNEL+2); break;
        }
      }
      else
      {
        Switch(WeaponMode)
        {
          Case 'FM_Snipe':
            PlayAnim('PafSniperAccroupi',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_1H':
          Case 'FM_44Alt':
            PlayAnim('PafPistoletAccroupi',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_Throw':
            PlayAnim('DeathBuste0',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_2H':
          Case 'FM_M16':
          Case 'FM_ARAlt':
          Case 'FM_ShotGunAlt':
          Case 'FM_HarpoonAlt':
            PlayAnim('PafGunAccroupi',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_Bazook':
          Case 'FM_BazookAlt':
            PlayAnim('PafBazookaAccroupi',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_2HHeavy':
            PlayAnim('PafM60Accroupi',,0.1,FIRINGCHANNEL+2); break;
          Case 'FM_Fists':
          Case 'FM_Stun':
          Default:
            PlayAnim('PafNeutreAccroupi',,0.1,FIRINGCHANNEL+2); break;
        }
      }
      AnimBlendParams(FIRINGCHANNEL+2,0.2 + 0.6*FRand(),0,0);
      SetTimer( 0.2, false );
    }
}

//_____________________________________________________________________________
// ELR Add some info to the ShowDebug Exec
simulated function DisplayDebug(Canvas C, out float YL, out float YPos)
{
    Super.DisplayDebug(C, YL, YPos);

    C.DrawText("ALLIANCE="$Alliance@"VISIBILITY "$Visibility);
    YPos += YL;
    C.SetPos(4,YPos);
    C.DrawText("Health "$Health@"bHaveOnlyOneHandFree="$bHaveOnlyOneHandFree@"GroundSpeed="$GroundSpeed);
    YPos += YL;
    C.SetPos(4,YPos);
}

//_____________________________________________________________________________
// ELR CheckDamageLocation
function DamageLocations GetDamageLocation( vector HitLoc , vector HitDir)
{
    local Vector Offset;
    local float HeadOffsetZ;

    if ( bIsDead ) return LOC_Body;

    if ( LastBoneHit == 'X Head' )
      return LOC_Head;
    if ( LastBoneHit == 'X Spine1' )
      return LOC_Body;

    // Use the hitlocation to determine where the pawn is hit
    // Transform the worldspace hitlocation into objectspace
    // In objectspace, X is front to back Y is side to side, and Z is top to bottom
    // Inspired from DX (Thanx to the scripter that gave the offset formula to a newB:)
    Offset = (HitLoc - Location) << Rotation;
    headOffsetZ = CollisionHeight * 0.75;

    if ( Offset.Z > HeadOffsetZ )
    {
      return LOC_HeadSide;
    }
    else
    {
      return LOC_Body;
    }
}

//_____________________________________________________________________________
// ELR CheckDamageLocation
function int GetDamageSide( vector HitLocation )
{
    local int i;
    local vector offset;

    // Use the hitlocation to determine where the pawn is hit
    // Transform the worldspace hitlocation into objectspace
    // In objectspace, X is front to back Y is side to side, and Z is top to bottom
    offset = (HitLocation - Location) << Rotation;
//    Log("GetDamageSide Offset="$Offset$" hitLocation="$hitLocation" Location="$Location);

    if (offset.y >= 0) i+=1;
    if (offset.z >= 0.5 * CollisionHeight) i+=2;
    if (offset.x <= -0.7 * CollisionRadius) i+=4; // from behind
    else if ( (offset.x < 0.0) && (offset.z > 0.95 * CollisionHeight) ) i+=4; // from above

    // The result returned is :
    // - Back Upper shot >=6
    // - Back shot >=4
    // - Front Shot <4
    return i;
}

//_____________________________________________________________________________
// ELR Already dead if any body part HS
function bool IsDead()
{
    Local int i, j;

    if (Controller == none)
      return true;

    if ( Health <= 0 )
      return true;

    return false;
}

//_____________________________________________________________________________
// ELR To test if wounded
function bool IsWounded()
{
    if ( Health < default.Health )
      return true;
}

//_____________________________________________________________________________
simulated function float HealthPercent()
{
    if ( IsDead() || bIsDead )
      return 0;
    if ( bBoss )
      return fMax(1.0, (100.0 * Health / MaxHealth));
    else
      return fMax(1.0, (100.0 * Health / default.Health));
}

//_____________________________________________________________________________
// ::DBUG::
function KilledBy( pawn EventInstigator )
{
    local Controller Killer;

    //Log(self@"killed by"@EventInstigator);
    Health = 0;
    if ( EventInstigator != None )
      Killer = EventInstigator.Controller;
    Died( Killer, class'DTSuicided', Location );
}

//_____________________________________________________________________________
// ELR Take Damage with Damage Location
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
    local int actualDamage;
    local bool bAlreadyDead;
    local Controller Killer;
    local DamageLocations Loc;
    local vector HitLocCode;
    local vector DeathMomentum;
    local float f;
    local color C;

    if ( Role < ROLE_Authority )
    {
      log(self$" client damage type "$damageType$" by "$instigatedBy);
      return;
    }
    if ( Level.bLonePlayer && Level.Game.bGameEnded )
      return;

//    Log(self$"TakeDamage momentum="$momentum);
    bAlreadyDead = bIsDead;

    if (Physics == PHYS_None)
      SetMovementPhysics();
    if (Physics == PHYS_Walking)
      momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
    if ( instigatedBy == self )
      momentum *= 0.6;
    DeathMomentum = momentum/Mass;
    momentum=vect(0,0,0); // ELR No more weapon momentum now

    // Get Damage Location
    // ELR need the hit normal to have accurate head shots, don't have so use the instigator location (bad for area damages but well...)
//    Log(self@"InstigatedBy="$instigatedBy);

    Loc = GetDamageLocation( HitLocation, Location - instigatedBy.Location );

//    DebugLog("  > "$self@"takedamage "$Damage$" type "$damageType$" location="$Loc@"in state"@GetStateName());

    if  ((damageType==class'DTGunned') || (damageType==class'DTShotGunned') || (damageType==class'DTPierced') || (damageType==class'DTSniped') || (damageType==class'DTBladeCut') || (damageType==class'DTH2HBlade') )
    {
//      Log("Possible HeadShot, Loc="$Loc);
      if ( Loc == LOC_HeadSide )
      {
        if (damageType != class'DTH2HBlade')
          return;     // Near but Missed the head !
        else
          Loc = LOC_Head; // force HeadShots w/ H2H use of TKnives
      }
      if ( Loc == LOC_Head )
      {
        if ( XIIIWeapon(InstigatedBy.Weapon).bHaveScope || class<XIIIDamageType>(DamageType).default.bAllowHeadShotSFXTrigger )
          DamageType = Class'XIII.DTHeadShot'; // Used for HeadShotSFXTrigger
        if ( fRand() > (1.25 - XIIIPawn(instigatedBy).Skill*0.25) )
          return;   // For Low level enemis lower the headshot probabilities
      }
    }

    // Handle stunning skill here
    if ( (damagetype == Class'XIII.DTFisted') && (GetDamageside(HitLocation)>=6) && (instigatedBy.FindInventoryKind('StunningSkill')!=none) )
    {
      damagetype = class'XIII.DTStunned';
    }

    // If stun increase damage to be sure we kill
    if ( bCanBeStunned && ((damagetype==Class'XIII.DTStunned') || (damagetype==Class'XIII.DTSureStunned')) )
    {
      Damage += 2000;
      Loc = LOC_Head;
    }

    // DTFisted should be DTStunned but don't kil on first hit, only to prevent Dying Event triggered.
//    if ( (damagetype == Class'XIII.DTFisted') || (damagetype == Class'XIII.DTCouDCross') )
//      damagetype = class'XIII.DTStunned';

    HitLocCode = vect(1,0,0) * Loc;   // HitLodCode.x contain the Location in order to use it in armor absorption

//    Log(self@"takedamage HitLocCode="$HitLocCode@"damagetype="$damagetype);

    // Armor/var. Absorption
    if ( class<XIIIDamageType>(DamageType).default.bGlobalDamages )
    { // damage head & body location, thus damage all armors
      actualDamage = Level.Game.ReduceDamage(2*Damage/5, self, instigatedBy, vect(0,0,0), Momentum, DamageType)
        + Level.Game.ReduceDamage(3*Damage/5, self, instigatedBy, vect(1,0,0), Momentum, DamageType);
    }
    else // only damage the real location.
      actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocCode, Momentum, DamageType);

    if ( Loc == LOC_Head )
      Health -= ActualDamage*HeadShotFactor;
    else
      Health -= ActualDamage;

    if ( HitLocation == vect(0,0,0) )
      HitLocation = Location;

    if ( bAlreadyDead )
    {
      Warn(self$" took regular damage "$damagetype$" from "$instigatedby$" while already dead at "$Level.TimeSeconds);
      return;
    }

    if ( bCanBeStunned && (DamageType == class'XIII.DTSureStunned') && IsDead() )
    { // we had been stunned by deco weapon, if player did it flash the player's view
      if ( instigatedBy.IsLocallyControlled() )
      {
        if ( Level.GetPlateforme() == 3 )
        {
          C.R = 244;
          C.B = 150;
        }
        else
        {
          C.B = 244;
          C.R = 150;
        }
        C.G = 195;
        C.A = 255;
        Playercontroller(instigatedBy.controller).ClientHighLight(C, 0.5);
        XIIIPlayercontroller(instigatedBy.controller).ClientTargetHighLight(150, 0.4, 0.5);
      }
    }

    if ( IsDead() )
    { // Pawn died
      if ( Controller != None )
      {
        Controller.NotifyTakeHit(instigatedBy, HitLocCode, actualDamage, DamageType, Momentum);
        Controller.Enemy = instigatedBy;
      }
      if ( instigatedBy != None )
        Killer = instigatedBy.Controller; // ::FIXME:: what if killer died before killing you
      if ( bPhysicsAnimUpdate )
        TearOffMomentum = momentum;
      AddVelocity( DeathMomentum );
      Died(Killer, damageType, HitLocCode);

//      Log("DYING PlayingSound "$DeathSound[int(f)]);
      if ( !IsPlayerPawn() )
      {
        if ( class<XIIIDamageType>(DamageType).default.bBloodSplash )
        {
          if ( (Level.Game != none) && (Level.Game.GoreLevel == 0) )
            spawn(class'BloodSplash', self,, HitLocation, rotator(HitLocation - (InstigatedBy.Location + InstigatedBy.EyePosition())));
        }
        if ( class<XIIIDamageType>(DamageType).default.bSPawnDeathOnomatop )
          MyDeathOno = Spawn(class'DeathOnomatopEmitter', self,, location + 92 * vect(0,0,1));
        f = frand()*4;
//        PlaySound(DeathSound[int(f)]);
      }
//      Log("DYING Velocity after Died() == "$Velocity$" Physics="$Physics);
    }
    else
    { // Still Alive
//      AddVelocity( momentum );

      PlayHit(actualDamage, HitLocCode, damageType, Momentum);
//      Log("TakeDamage ClientViewFeedBackSetUp");
      if ( (XIIIPlayerController(controller) != none) && (instigatedBy.Weapon != none) && (Level.GetPlateforme() != 31) && (Level.GetPlateforme() != 3) )
        XIIIPlayerController(controller).ClientViewFeedBackSetUp(class<XIIIWeapon>(instigatedBy.Weapon.class));

      CheckMaluses();
      if ( Controller != None )
        Controller.NotifyTakeHit(instigatedBy, HitLocCode, actualDamage, DamageType, Momentum);
    }
//    MakeNoise(1.0);
}

//_____________________________________________________________________________
function PlayHit(float Damage, vector HitLocation, class<DamageType> damageType, vector Momentum)
{
//    local vector BloodOffset, Mo;
    local int param3;
    local sound S;

//    DebugLog(self@"PlayHit hHitSound="$hHitSound@"DamageType="$DamageType@"SndType="$DamageType.default.SoundType);

    if ( (Damage <= 0) && !Controller.bGodMode )
      return;

    if ( IsPlayerPawn() )
      PlaySound(hHitSound, DamageType.default.SoundType, Damage, int(bIsDead) );
    else if ( (DamageType.default.SoundType == 8) || (DamageType.default.SoundType == 9) )
      PlaySound(hHitSound, DamageType.default.SoundType, Damage);

    if ( Health <= 0 )
    {
      if ( PhysicsVolume.bDestructive && (PhysicsVolume.ExitActor != None) )
        Spawn(PhysicsVolume.ExitActor);
      return;
    }
    if ( Level.TimeSeconds - LastPainTime > 0.1 )
    {
      PlayTakeHit(HitLocation,Damage,damageType);
      LastPainTime = Level.TimeSeconds;
      BaffeCount ++;
    }
}

//_____________________________________________________________________________
// ELR
function Died(Controller Killer, class<DamageType> damageType, vector HitLocCode)
{
    local Controller Other;
    local int i;
    local inventory Kapio;

    PawnKiller = Killer.Pawn;

//    Log(self@"Died in state"@GetStateName()@"controller in state"@Controller.GetStateName()@"damageType="@damageType);

    HitDamageType = DamageType;
//    if ( class<XIIIDamageType>(HitDamageType).default.bDieInSilencePlease )
//      Log(self$" Died in silence");

    if ( bDeleteMe )
      return;   // Already destroyed

    if ( Level.Game.PreventDeath(self, Killer, damageType, HitLocCode) )
    {
      Health = max(Health, 1); // mutator should set this higher
      return;
    }

    // ELR Leave controlled actor
    if (MitraillTop(ControlledActor) != none)
      MitraillTop(ControlledActor).LeaveControl();
    if ( Weapon != none )
      Weapon.NotifyOwnerKilled(Killer);

    // ELR
    ShouldCrouch(false);

    Health = Min(0, Health);

/*
    if ( MyHead != none )
    {
//      DetachFromBone( MyHead );
      MyHead.Destroy();
    }
*/

/*    for ( Other=Level.ControllerList; Other!=None; Other=Other.nextController )
      Other.Killed(Killer, self, damageType);   */ // Replaced by NotifyKilled call in gameinfo
    Level.Game.Killed(Killer, Controller, self, damageType);

    // ELR Characters that are stunned MUST NOT Cause their event
    if ( bCauseEventOnStun || ((DamageType != class'DTFisted') && (DamageType != class'DTCouDCross') && (DamageType != class'DTStunned') && (DamageType != class'DTSureStunned') && (DamageType != class'DTDropAfterStun')) )
    {
      if ( Killer != None )
        TriggerEvent(Event, self, Killer.Pawn);
      else
        TriggerEvent(Event, self, None);
    }

    Velocity.Z *= 1.3;
    if ( IsHumanControlled() )
        if( !Controller.bIsBot )
      PlayerController(Controller).ForceDeathUpdate();

    TakeHitLocation = HitLocCode;

    // DONT Set bTear off instead of play anim instead everything wrong for on-line
    if ( Level.NetMode == NM_StandAlone )
      bTearOff = true;
    else
      PlayDying(DamageType, HitLocCode);    // HitLocCode instead of HitLocation

    bIsDead = true;
    SetBoneDirection( FIRINGBLENDBONE, rot(0,0,0), vect(0,0,0), 0.0 );

    if ( Level.Game.bGameEnded )
      return;
    if ( !bPhysicsAnimUpdate && (RemoteRole == ROLE_AutonomousProxy) )
      ClientDying(DamageType, HitLocCode);

    // ELR no more physics anim update for deads
//    bPhysicsAnimUpdate = false;
//    Log("DamageType="$DamageType$"HitLocCode="$HitLocCode);
    if ( (fRand() < 0.7)
      || (DamageType == class'DTStunned')
      || (DamageType == class'DTSureStunned')
      || (DamageType == class'DTHeadShot')
      || (HitLocCode.X == 0) )
    {
      Kapio = Inventory;
      while (Kapio != none)
      {
        if ( Kapio.IsA('Beret') || Kapio.IsA('BeretJungle') || Kapio.IsA('BeretSnow') )
        {
          Kapio.NotifyOwnerKilled(Killer);
          break;
        }
        Kapio = Kapio.Inventory;
      }
    }
}

//_____________________________________________________________________________
// To be sure we do get Get Rid of destruction of the body.
function ChunkUp(int Damage)
{
    XIIIGameInfo(Level.Game).DropInventory(self);
//    Super.ChunkUp(Damage);
}

//_____________________________________________________________________________
// ELR to heal
function Heal(int H)
{
    Local int i;

//    log("Heal called w/ ammount="$H);
    Health = Min(Default.Health, Health+H);
//    CheckMaluses(); // no need in this now that we don't have any negative fx for low health
}

//_____________________________________________________________________________
// ELR used to Check Maluses for Low Health on located body parts, now just used by LHand to grab corpses/hostages
function CheckMaluses()
{
    if ( (LHand != none) && (LHand.pOnShoulder != none) )
    {
      bAllowJump = false;
      bCanCrouch = false;
      ShouldCrouch(false);
    }
    else
    {
      bAllowJump = default.bAllowJump;
      bCanCrouch = true;
    }
}

//_____________________________________________________________________________
function SetGroundSpeed(float SpeedFactor)
{
    local float NewSpeed;
    //Log("]]] SetGroundSpeed call for "$self$" SpeedFactorLimit="$SpeedFactorLimit);
    if ( SpeedFactor < 1.0 )
      NewSpeed = default.Groundspeed * SpeedFactor * SpeedFactorLimit;
    else
      NewSpeed = default.Groundspeed * SpeedFactorLimit;

    NewSpeed = max(NewSpeed, 5.0); // To avoid GroundSpeed=0, pb in checkbob
    if ( GroundSpeed != NewSpeed )
      GroundSpeed = NewSpeed; // ELR for on-line do this to avoid bNetDirtied each frame
//    Debuglog(">> SetGroundSpeed w/ SpeedFactor="$SpeedFactor$" SpeedFactorLimit="$SpeedFactorLimit$" GroundSpeed set to "$GroundSpeed);
}

//_____________________________________________________________________________
// Just changed to pendingWeapon
function ChangedWeapon()
{
    local Weapon OldWeapon;
    local Powerups OldItem;
    local bool bWeaponMode;

    if ( XIIIPlayerController(controller) != none )
    {
      XIIIPlayerController(controller).bWeaponMode = XIIIPlayerController(controller).bWaitforWeaponMode;
      bWeaponMode = XIIIPlayerController(controller).bWeaponMode;
      if ( !bWeaponMode )
      { // Item mode, should chek we really have an item to select
        if ( (SelectedItem == none) && (PendingItem == none) )
        {
          if ( !XIIIPlayerController(controller).bWeaponBlock )
            Warn("!@! ChangeWeapon to item mode but no Pending nor Selected Item");
          XIIIPlayerController(controller).NextWeapon();
          if ( PendingWeapon != none )
            PendingWeapon.BringUp(); // May happen if bWeaponBlock
          return;
        }
      }
    }
    else
    {
      bWeaponMode=true;
    }

/*    if ( bWeaponMode )
    {
      Log(">>> Changed Weapon w/ "$Weapon$" for "$PendingWeapon);
//      Log("  > PendingWeapon Role="$PendingWeapon.Role@"ReMoteRole="$PendingWeapon.RemoteRole);
    }
    else
    {
      Log(">>> Changed Item w/ "$SelectedItem$" for "$PendingItem);
//      Log("  > PendingItem Role="$PendingItem.Role@"ReMoteRole="$PendingItem.RemoteRole);
    } */

    if ( bWeaponMode )
    {
      OldWeapon = Weapon;

      if ( (XIIIPlayerController(controller)!=none) && XIIIPlayerController(controller).bWeaponBlock )
      {
        Weapon = none;
        return;
      }

      if ( (PendingWeapon==none) || (Weapon == PendingWeapon) )
      {
//        Log("  > Weapon="$Weapon@"in state"@Weapon.GetStateName());
        if ( Weapon == None )
        {
          Controller.SwitchToBestWeapon();
          return;
        }
//        else if ( Weapon.IsInState('DownWeapon') )
//          Weapon.GotoState('Idle');
        Weapon.Instigator = self;
        PendingWeapon = None;
        if ( (Weapon != None) && (Level.NetMode == NM_Client) )
        {
          Weapon.bChangeWeapon = false;
          Weapon.BringUp();
        }
        ServerChangedWeapon(OldWeapon, Weapon);
        Weapon.AttachToPawn(self);
        return;
      }
      // ELR Modif here to allow noweapon states
      if ( (PendingWeapon == None) && (XIIIPlayerController(controller)!=none) && !XIIIPlayerController(controller).bWeaponBlock )
        PendingWeapon = Weapon;

      Weapon = PendingWeapon;
      if ( (Weapon != None) && (Level.NetMode == NM_Client) )
      {
        Weapon.bChangeWeapon = false;
        Weapon.BringUp();
      }
      PendingWeapon = None;
      Weapon.Instigator = self;
      ServerChangedWeapon(OldWeapon, Weapon);
      Weapon.AttachToPawn(self);
      if ( Controller != none )
        Controller.ChangedWeapon();
    }
    else
    {
      OldItem = SelectedItem;

      if ( (XIIIPlayerController(controller)!=none) && XIIIPlayerController(controller).bWeaponBlock )
        return;

      if ( (PendingItem==none) || (SelectedItem == PendingItem) )
      {
//        Log("  > SelectedItem="$SelectedItem@"in state"@SelectedItem.GetStateName());
        if ( SelectedItem == None )
        {
          XIIIPlayerController(Controller).cNextItem();
          return;
        }
        SelectedItem.Instigator = self;
        PendingItem = None;
        if ( (SelectedItem != None) && (Level.NetMode == NM_Client) )
        {
          XIIIItems(SelectedItem).bChangeItem = false;
          XIIIItems(SelectedItem).BringUp();
        }
        ServerChangedItem(OldItem, SelectedItem);
        return;
      }
      if ( ( PendingItem == None ) && !XIIIPlayerController(controller).bWeaponBlock )
        PendingItem = SelectedItem;

      SelectedItem = PendingItem;
      if ( (SelectedItem != None) && (Level.NetMode == NM_Client) )
      {
        XIIIItems(SelectedItem).bChangeItem = false;
        XIIIItems(SelectedItem).BringUp();
      }
      PendingItem = None;
      SelectedItem.Instigator = self;
      ServerChangedItem(OldItem, SelectedItem);
      if ( Controller != None )
        Controller.ChangedWeapon();

    }
    PlayWaiting(); // ELR to update wating animation function of the weapon/item in hand
}

//_____________________________________________________________________________
function ServerChangedWeapon(Weapon OldWeapon, Weapon W)
{
//    Log("ServerChangedWeapon w/ OldWeapon="$OldWeapon$" & Weapon="$W@"Owner="$W.Owner);

    if ( SelectedItem != None )
    {
      SelectedItem.SetDefaultDisplayProperties();
      SelectedItem.DetachFromPawn(self);
    }
//    Super.ServerChangedWeapon(OldWeapon, W);
    if ( OldWeapon != None )
    {
      OldWeapon.SetDefaultDisplayProperties();
      OldWeapon.DetachFromPawn(self);
    }
    if ( Weapon != OldWeapon )
    { // ELR Be sure that if old weapon is != oldweapon we don't keep it attached (may happen after throwing last grenade on-line for ex)
      Weapon.SetDefaultDisplayProperties();
      Weapon.DetachFromPawn(self);
    }
    Weapon = W;
    if ( Weapon == None )
      return;

    if ( Weapon != None )
    {
      //log("ServerChangedWeapon: Attaching Weapon to actor bone.");
      Weapon.AttachToPawn(self);
    }

    Weapon.SetRelativeLocation(Weapon.Default.RelativeLocation);
    Weapon.SetRelativeRotation(Weapon.Default.RelativeRotation);
    if ( OldWeapon == Weapon )
    {
//      if ( Weapon.IsInState('DownWeapon') )
      Weapon.BringUp();
//      Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)
      return;
    }
//    else if ( Level.Game != None )
//      MakeNoise(0.1 * Level.Game.Difficulty);
//    Inventory.OwnerEvent('ChangedWeapon'); // tell inventory that weapon changed (in case any effect was being applied)

//    PlayWeaponSwitch(W); // Check utility of this (now in ThirdPersonActor of weapon)
    Weapon.BringUp();
}

//_____________________________________________________________________________
function ServerChangedItem(PowerUps OldItem, PowerUps I)
{
//    Log("ServerChangedItem w/ OldItem="$OldItem$" & Item="$I@"Owner="$I.Owner);

    if ( OldItem != None )
    {
      OldItem.SetDefaultDisplayProperties();
      OldItem.DetachFromPawn(self);
    }
    if ( Weapon != none )
    {
      Weapon.SetDefaultDisplayProperties();
      Weapon.DetachFromPawn(self);
    }
    SelectedItem = I;
    if ( SelectedItem == None )
      return;

    if ( SelectedItem != None )
    {
      //log("ServerChangedWeapon: Attaching Weapon to actor bone.");
      SelectedItem.AttachToPawn(self);
    }

    SelectedItem.SetRelativeLocation(SelectedItem.Default.RelativeLocation);
    SelectedItem.SetRelativeRotation(SelectedItem.Default.RelativeRotation);

    if ( OldItem == SelectedItem )
    {
//      Log("Calling BringUp from OldItem == SelectedItem for "$XIIIItems(SelectedItem));
      XIIIItems(SelectedItem).BringUp();
//      Inventory.OwnerEvent('ChangedItem'); // tell inventory that weapon changed (in case any effect was being applied)
      return;
    }
//    else if ( Level.Game != None )
//      MakeNoise(0.1 * Level.Game.Difficulty);

//    Inventory.OwnerEvent('ChangedItem'); // tell inventory that weapon changed (in case any effect was being applied)

//     PlayWeaponSwitch(W); // ::TODO:: Check utility of this
//    Log("Calling BringUp from OldItem != SelectedItem for "$XIIIItems(SelectedItem));
    XIIIItems(SelectedItem).BringUp();
}

//_____________________________________________________________________________
// The player/bot wants to select next item
simulated function NextItem()
{
    local Inventory Inv;

//    Log(">> NextItem Call SelectedItem="$SelectedItem);

    if (SelectedItem==None)
    {
      SelectedItem = Inventory.SelectNext();
      if ( SelectedItem != none )
      {
        if ( XIIIPlayerController(controller).bWeaponMode )
          XIIIPlayerController(controller).SwitchWeaponMode();
        SelectedItem.Activate();
//        Log(">> Selected Item="$SelectedItem);
      }
      Return;
    }

    if ( XIIIPlayerController(controller).bWeaponMode )
    {
      XIIIPlayerController(controller).SwitchWeaponMode();
      if ( SelectedItem != none)
      {
        SelectedItem.Activate();
//        Log(">> Selected Item="$SelectedItem);
        return; // ELR First time we hide weapon and keep old selected item
      }
    }

    if (SelectedItem.Inventory!=None)
      SelectedItem = SelectedItem.Inventory.SelectNext();
    else
      SelectedItem = Inventory.SelectNext();

    if ( SelectedItem == None )
      SelectedItem = Inventory.SelectNext();

    if ( SelectedItem == None )
    { // switch back to weapons if no items left in inventory
      XIIIPlayercontroller(controller).NextWeapon();
      ChangedWeapon();
      return;
    }

    SelectedItem.Activate();
//    Log(">> Selected Item="$SelectedItem);
}

//_____________________________________________________________________________
function PowerUps FindPowerUpItemName(string DesiredName)
{
    local Inventory Inv;

//    Log("FindPowerUpItemName "$DesiredName);
    for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
      if (PowerUps(Inv) != none)
      {
        if (caps(Inv.ItemName) == caps(DesiredName))
          return PowerUps(Inv);
        if ( (Keys(Inv) != none) && (caps(Keys(Inv).KeyCodeName) == caps(DesiredName)) )
          return PowerUps(Inv);
      }
    return None;
}

//_____________________________________________________________________________
function PowerUps FindPowerUpItemNameForTrigger(name DesiredName)
{
    local Inventory Inv;

//    Log("FindPowerUpItemNameForTrigger "$DesiredName);
    for( Inv=Inventory; Inv!=None; Inv=Inv.Inventory )
    {
//      Log("  testing item "$Inv);
      if (PowerUps(Inv) != none)
      {
        if ( caps(Inv.ItemName) == caps(DesiredName) )
          return PowerUps(Inv);
        if ( (EventItem(Inv) != none) && (caps(EventItem(Inv).Event) == caps(DesiredName)) )
          return PowerUps(Inv);
        if ( (Keys(Inv) != none) && (caps(Keys(Inv).KeyCodeName) == caps(DesiredName)) )
          return PowerUps(Inv);
        if ( (Keys(Inv) != none) && (caps(Keys(Inv).Event) == caps(DesiredName)) )
          return PowerUps(Inv);
      }
    }
    return None;
}

//_____________________________________________________________________________
function name GetWeaponBoneFor(Inventory I)
{
    return 'X R Hand';
}

//_____________________________________________________________________________
function name GetItemBoneFor(Inventory I)
{
    return 'X R Hand'; // ELR Used to be left hand but finally as items are handled the same way as weapons...
}

//_____________________________________________________________________________
event BreathTimer()
{
//    log("BreathTimer call DrownTimer="$DrownTimer@"UnderWaterTime="$UnderWaterTime);
    if ( bIsDead || (Level.NetMode == NM_Client) )
      return;

    if ( !HeadVolume.bWaterVolume )
    {
      DrownTimer += 10.0*DTimerStep;
      if (DrownTimer >= UnderWaterTime)
      {
        bDrawBreathtimer = false;
        BreathTime = -1.0;
      }
      else
        BreathTime = DTimerStep;
    }
    else
    {
      TakeDrowningDamage();
      BreathTime = DTimerStep;
    }

    // Player SFXs
    if ( HeadVolume.bWaterVolume )
    {
      if ( UnderWaterSFX == none )
      {
        UnderWaterSFX = Spawn(class'UnderWaterBreathEmitter',self);
        UnderWaterSFX.SetOwner(self);
      }
      if ( UnderWaterSFX != none )
      {
        UnderWaterSFX.Emitters[0].StartLocationOffset = (EyePosition() - (vect(0,0,8) >> Controller.rotation) + vector(Controller.Rotation) * 20.0) << Rotation;
        if ( UnderWaterSFX.TriggerParticle() && IsPlayerPawn() )
          PlaySound(hBubbleSound);
      }
    }
}

//_____________________________________________________________________________
// ELR
function TakeDrowningDamage()
{
    if ( Level.bLonePlayer && Level.Game.bGameEnded )
      return;

    DrownTimer -= DTimerStep;

    if ( (fDrownCount <= 0.0) && ((Drowntimer/4.0-2.5) <= -0.5) )
    {
      fDrownCount = fMax(0.25, -1.0 / (Drowntimer/4.0-2.5));
    }
    else if ( (Drowntimer/4.0-2.5) > -0.5 )
      fDrownCount = 0.0;

    if ( fDrownCount > 0.0 )
    {
      fDrownCount -= DTimerStep;
      if ( (fDrownCount <= 0.0) && IsLocallyControlled() )
      {
        PlayerController(Controller).ClientFilter(
          class'Canvas'.Static.MakeColor(128,0,0,255),
          class'Canvas'.Static.MakeColor(128,128,128,255),
          1.0/DTimerStep
        );
        XIIIPlayerController(Controller).ClientTargetHighLight( 0, 0, DTimerStep);
      }
      if ( UnderWaterSFX != none )
      {
        UnderWaterSFX.Emitters[0].StartLocationOffset = (EyePosition() - (vect(0,0,8) >> Controller.rotation) + vector(Controller.Rotation) * 20.0) << Rotation;
        if ( UnderWaterSFX.TriggerParticle() && IsPlayerPawn() )
          PlaySound(hBubbleSound);
      }
    }

    if (DrownTimer <= -6.0)
    {
      TakeDamage(25000, self, Location, vect(0,0,0), class'DTDrowned'); // Die Scum !!
      if ( DrowningSFX == none )
        DrowningSFX = Spawn(class'DrowningEmitter',self,, Location);
    }
}

//_____________________________________________________________________________
function Gasp()
{
}

//_____________________________________________________________________________
function SetBreatheOn()
{
//    log("SetBreatheOn call");
    if ( FindInventoryKind('BreathSkill') != None )
    {
      UnderWaterTime = default.UnderWaterTime * 2;
      DrownTimer = min(DrownTimer, UnderWaterTime);
      BreathTime = DTimerStep;
    }
    else
      UnderWaterTime = default.UnderWaterTime;
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
        //Log("@@@ hSwimmingSound param 1");
      }
    }
}

//_____________________________________________________________________________
function bool CanSplash()
{
    if ( Level.TimeSeconds - SplashTime > 1.0)
    {
      SplashTime = Level.TimeSeconds;
      return true;
    }
    return false;
}

//_____________________________________________________________________________
// ELR Executed in Landed()
function TakeFallingDamage()
{
    if ( Level.bLonePlayer && Level.Game.bGameEnded )
      return;
    // ::DBUG::
//    Log(self$" TakeFallingDamage() Velocity.z="$Velocity.z$" JumpZ="$JumpZ@"damage="$-0.3 * (Velocity.Z + 400 + JumpZ));

    // 1rst Banque level = Velocity.z = -1400 = Not Dead.
    // 2nd Banque level = Velocity.z = -1705 = Death.
    // Jump off a tble = Velocity.z = -573 = nothing.

//    if ( Base != none )
//      Velocity += Base.Velocity;
    if (Velocity.Z < -1.4 * JumpZ) // 420 * 1.4 = 588
    {
      if (Velocity.Z <= - 400 - JumpZ) // Velocity.z < -820
      {
        if ( (Velocity.Z < -1200 - JumpZ) && !Controller.bGodMode )
          TakeDamage(1000, self, Location, vect(0,0,0), class'Fell');
        else if ( Role == ROLE_Authority )
        {
          TakeDamage(-0.3 * (Velocity.Z + 400 + JumpZ), self, Location + vect(-20,0,-20), vect(0,0,0), class'DTFell');
        }
      }
    }
}

//_____________________________________________________________________________
event Landed(vector HitNormal)
{
    local float fNoise;

    if ( (bIsDead || IsDead()) && !bIsInCine )
    {
//      Log("LANDED Global");
      LandedSpecial();
      return;
    }
    TakeFallingDamage();
    if ( Health > 0 )
      PlayLanded(Velocity.Z);
    fNoise = fmin(1.0, -0.3*Velocity.Z/JumpZ);
    if ( bIsCrouched || (XIIIPlayerController(Controller) != none) && XIIIPlayerController(Controller).bHooked )
      fNoise /= 3.0;
    //Log("LANDED MakeNoise of "$fNoise@"for velocity="$Velocity.z@"& JumpZ="$JumpZ);
    MakeNoise(fNoise);
    bJustLanded = true;
    if ( bIsCrouched )
      Visibility = CrouchedVisibility;
    else
      Visibility = default.Visibility;
    if ( LastLandSoundTime < Level.TimeSeconds - 0.333 )
    {
      LastLandSoundTime = Level.TimeSeconds;
      PlayLandSound();
    }
//    XIIIPlayerController(Controller).vWeaponFeedBack = vect(0,0.01,0)*Velocity.z;
//    bJumpFeedBack = true;
}

//_____________________________________________________________________________
// Land sounds are footStepSounds w/ negative velocity to warn the Harmonix Script that it is a land
simulated function PlayLandSound()
{
    local material M;
    local actor A;
    local vector HitLoc, HitNorm;
    local bool bSilent;

    bSilent = (FindInventoryKind('SilentWalkSkill')!=none);

    if ( LastCollidedMaterial == none )
      A = Trace(HitLoc, HitNorm, Location - (CollisionHeight + CollisionRadius) * vect(0,0,1), location, true, vect(0,0,0), M);
    else
      M = LastCollidedMaterial;
//    log(self@"PlayFootStep && make noise using M="$M@"play sound"@M.XIIIFootstepSound@"& Make noise"@M.NoiseLoudness);
    Instigator = self;
    if (M != none)
    {
      if ( Level.bReplaceHXScripts )
      {
        if ( IsPlayerPawn() )
          PlaySndXIIIStep(M.XIIISndStep, -(vsize(velocity)), SoundStepCategory, bSilent );
      else
          PlaySndPNJStep(M.PNJSndStep, -(vsize(velocity)), SoundStepCategory, bSilent );
      }
      else
      {
        if ( IsPlayerPawn() )
          PlaySound(M.XIIIFootstepSound, -int(vsize(velocity)), SoundStepCategory, int(bSilent) );
        else
          PlaySound(M.FootstepSound, -int(vsize(velocity)), SoundStepCategory, int(bSilent) );
      }
    }
}

//_____________________________________________________________________________
// ELR Player is hooking
function GoHooking(Hook H)
{
    XIIIPlayerController(Controller).GoHooking(H);
}

//_____________________________________________________________________________
// ELR Used for being grabbed by someone (Here we are alive (taken as prisonner)
// Redefined in Dying state for grabbing corpses.
function bool BeingGrabbed()
{
    Controller.gotostate('otage');
    bInvulnerableBody = false;
    GotoState('Prisonner');
    Velocity = Vect(0,0,0);
    Acceleration = Vect(0,0,0);
    TriggerEvent(EventOnGrab, self, Instigator);
    return true;
}

//_____________________________________________________________________________
function bool UnGrabbed(vector Loc, vector Dir)
{
//    Controller.settimer(0.5,false);
    return false;
}

//_____________________________________________________________________________
// Base change - if new base is pawn or decoration, damage based on relative mass and old velocity
// ELR Modified to stun paws we fall on.
singular event BaseChange()
{
    local float decorMass;

    if ( bInterpolating )
      return;
    if ( Level.bLonePlayer && Level.Game.bGameEnded )
      return;

    if ( XIIIPawn(Base) != None )
    {
      if ( XIIIPawn(Base).bStunnedIfJumpedOn && (vSize(Base.Location - Location) > 0.95*(Base.CollisionHeight+CollisionHeight)) )
      {
        //Log("Stun from above, speed ="$Velocity.z);
        if ( !XIIIPawn(Base).bIsDead && (Velocity.Z < -180.0) )
        {
          playsound(hStunFromAboveSound);
          MakeNoise(0.157);
          Spawn(class'StunningJumpEmitter',self,,Location - vect(0,0,0.7)*CollisionHeight + vector(rotation)*CollisionRadius, rotation);
        }
        Base.TakeDamage( (1-Velocity.Z/400)* Mass/Base.Mass, Self,Location,0.5 * Velocity , class'DTSureStunned');
      }
      JumpOffPawn();
    }
    else if ( (Decoration(Base) != None) && (Velocity.Z < -400) )
    {
      decorMass = FMax(Decoration(Base).Mass, 1);
      Base.TakeDamage((-2* Mass/decorMass * Velocity.Z/400), Self, Location, 0.5 * Velocity, class'Crushed');
    }
}

//_____________________________________________________________________________
// Also, non-players will jump off pawns immediately
// ELR Decrease Z speed.
function JumpOffPawn()
{
    Velocity += (100 + default.CollisionRadius) * VRand();
//    Velocity.Z = 200 + CollisionHeight;
    Velocity.Z = 1 + default.CollisionHeight;
    SetPhysics(PHYS_Falling);
//    bNoJumpAdjust = true;
    Controller.SetFall();
    MakeNoise(0.15);
}

//_____________________________________________________________________________
function CreateInventory(class<Inventory> InventoryClass)
{
    local Inventory Inv;

//     InventoryClass = Level.Game.BaseMutator.GetInventoryClass(InventoryClassName);
    if (InventoryClass!=None) //&& (FindInventoryType(InventoryClass)==None) )
    {
      Inv = spawn(InventoryClass);
      if( Inv != None )
      {
        Inv.GiveTo(self);
        Inv.PickupFunction(self);
      }
    }
}

/*
//_____________________________________________________________________________
// Used for Menu (unable to access AllActors in Object SubClass, must be Actor SubClass).
function FindXIIIDoc(out array<string> doctext, out array<string> docinfo)
{
    local XIIIDocuments d;
    local int i;

    i=0;
    foreach AllActors(class'XIIIDocuments', d)
    {
      if (d.PersoNum == 13)
      {
        Doctext[i] = d.ItemName;
        Docinfo[i] = d.Information;
        i++;
      }
    }
}

//_____________________________________________________________________________
// Used for Menu (unable to access AllActors in Object SubClass, must be Actor SubClass).
function XIIIDocuments FindXXDoc(int NumPerso)
{
    local XIIIDocuments d;

    foreach AllActors(class'XIIIDocuments', d)
    {
      if (d.PersoNum == NumPerso)
        return d;
    }
    return none;
}
*/

//_____________________________________________________________________________
function bool CanGrabCorpse(optional XIIIPawn P)
{
//    Log("CanGrabCorpse "$P@"Physics="$P.Physics);

    if ( !Level.bLonePlayer || bHaveOnlyOneHandFree || (Physics == PHYS_Ladder) || bIsCrouched )
      return false;

    if ( (P != none) && (!P.bCanBeGrabbed || (P.Physics != PHYS_none)) )
      return false;

    if ( XIIIPlayerController(Controller).bHooked )
      return false;

    if ( XIIIPlayerController(Controller).bWeaponMode != XIIIPlayerController(Controller).bWaitForWeaponMode )
      return false; // switching Weapons <-> Items, not allow pick (prevent potential bug)

    if ( !XIIIPlayerController(Controller).bWeaponMode )
    {
      if ( (XIIIItems(SelectedItem).IHand!=IH_2H) && ((XIIIItems(PendingItem)==none) || (XIIIItems(PendingItem).IHand!=IH_2H) ) )
        return true;
    }

    if ( XIIIPlayerController(Controller).bWeaponMode )
    {
      if ( Weapon.IsInState('Reloading') )
        return false;
      if ( (XIIIWeapon(Weapon).WHand != WHA_2HShot) && (XIIIWeapon(Weapon).WHand != WHA_Deco) && ((PendingWeapon == none) || ((XIIIWeapon(PendingWeapon).WHand != WHA_2HShot) && (XIIIWeapon(PendingWeapon).WHand != WHA_Deco))) )
        return true;
    }
    return false;
}

//_____________________________________________________________________________
function bool CanTakePrisonner(optional XIIIPawn P)
{
    if ( !Level.bLonePlayer || bHaveOnlyOneHandFree || (Physics == PHYS_Ladder) || bIsCrouched )
      return false;

    if ( XIIIPlayerController(Controller).bHooked )
      return false;

    if ( XIIIPlayerController(Controller).bWeaponMode != XIIIPlayerController(Controller).bWaitForWeaponMode )
      return false ; // switching Weapons <-> Items, not allow pick (prevent potential bug)

    if ( XIIIPlayerController(Controller).bWeaponMode )
    {
      if ( Weapon == none )
        return false;
      if ( Weapon.IsInState('Reloading') )
        return false;
      if ( (XIIIWeapon(Weapon).WHand == WHA_2HShot) || (XIIIWeapon(Weapon).WHand == WHA_Deco) )
        return false;
      if ( (PendingWeapon != none) && ((XIIIWeapon(PendingWeapon).WHand == WHA_2HShot) || (XIIIWeapon(PendingWeapon).WHand == WHA_Deco)) )
        return false;
    }
    if ( !XIIIPlayerController(Controller).bWeaponMode )
    {
      if ( SelectedItem == none )
        return false;
      if ( (PendingItem != none) && XIIIItems(PendingItem).IHand != IH_1H )
        return false;
      if ( !XIIIPlayerController(Controller).bWeaponMode && (XIIIItems(SelectedItem).IHand != IH_1H) )
        return false;
    }

    if ( (P != none) && !P.bCanBeGrabbed )
      return false;
    if ( P.bTearOff )
      return false;

    if ( vector(Rotation) dot vector(P.Rotation) > 0 )
      return true;
    else
      return false;
}

//_____________________________________________________________________________
function bool CanStun(optional XIIIPawn P)
{
    return false;
}

//_____________________________________________________________________________
//Player Jumped
// ELR Added bAllowJump (Pawn Grabbed)
function DoJump( bool bUpdating )
{
    if ( !bIsCrouched && !bWantsToCrouch && ((Physics == PHYS_Walking) || (Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) )
    {
/* // ELR No use in XIII
     if ( Role == ROLE_Authority )
      {
        if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
          MakeNoise(0.1 * Level.Game.Difficulty);
        if ( bCountJumps && (Inventory != None) )
          Inventory.OwnerEvent('Jumped');
      } */
      if ( Physics == PHYS_Spider )
        Velocity = JumpZ * Floor;
      else if ( bAllowJump )
      {
        Velocity.Z = JumpZ;
        bJumpImpulse = true;
//        PlayJumpImpulse();
      }
      else
        Velocity.Z = JumpZ/100.0; // ELR Only small jump to have visual (else maybe thought of a bug or pb with jump button)
      if ( (Base != None) && !Base.bWorldGeometry )
      { // Try to stay on Base for platforms moving horizontaly
        Velocity.X += Base.Velocity.X;
        Velocity.Y += Base.Velocity.Y;
      }
//        Velocity.Z += (Base.Velocity.Z * 0.5);
      SetPhysics(PHYS_Falling);
      PlaySound(hJumpSound);
    }
    Visibility = default.Visibility;
}

//_____________________________________________________________________________
function SpawnCadavre()
{
    Controller.Destroy();
}

//_____________________________________________________________________________
function AddVelocity( vector NewVelocity)
{
//    Log("AddVelocity of "$NewVelocity$" for "$self$" in state "$GetStateName());

//    if ( bIgnoreForces )
//      return;
    if ( (Physics == PHYS_Walking)
      || (((Physics == PHYS_Ladder) || (Physics == PHYS_Spider)) && (NewVelocity.Z > Default.JumpZ)) )
      SetPhysics(PHYS_Falling);
    if ( (Velocity.Z > 380) && (NewVelocity.Z > 0) )
      NewVelocity.Z *= 0.5;
    Velocity += NewVelocity;
//    Log("AddVelocity of "$NewVelocity$" for "$self$" in state "$GetStateName()$" now Velocity="$Velocity);
}

//_____________________________________________________________________________
simulated function ReduceMyCylinder()
{
    local float OldHeight, OldRadius;
    local vector OldLocation;

//    Log(self@"ReduceMyCylinder");
    SetCollision(false,False,False);
    OldHeight = CollisionHeight;
    OldRadius = CollisionRadius;
    // ELR Only modification, increase collisionradius of carcasses from 1.5 to 1.7x
//      SetCollisionSize(1.7 * Default.CollisionRadius, CarcassCollisionHeight);
    SetCollisionSize(1, CarcassCollisionHeight);
//      PrePivot = vect(0,0,1) * ((OldHeight - CollisionHeight) - vSize(Floor cross vect(0,0,1))*1.7 * Default.CollisionRadius); // FIXME - changing prepivot isn't safe w/ static meshes
    PrePivot = vect(0,0,1) * (OldHeight - CollisionHeight);
    OldLocation = Location;
    if ( !SetLocation(OldLocation - PrePivot) )
    {
      Log("### BIG BUG Can't setup a corpse ("$self$") place...");
    }
    PrePivot = PrePivot + vect(0,0,5);
    SetCollisionSize(1.7 * Default.CollisionRadius, CarcassCollisionHeight);
    SetCollision(True,False,False);
//    Log(self@"    ReduceMyCylinder, H="$CollisionHeight@"R="$CollisionRadius);
}

//_____________________________________________________________________________
// Landed modded to have body in the right place.
simulated function LandedSpecial(optional bool bForceStop)
{
    local rotator finalRot;
    local vector X,Y,Z;
    local vector HitLoc, HitNorm;
    local Actor A;

    if ( !bForceStop )
    {
      A = Trace(HitLoc, HitNorm, Location - vect(0,0,1)*(8+default.CollisionHeight+default.CollisionRadius), Location + vect(0,0,1)*(8+default.CollisionHeight+default.CollisionRadius), true, vect(1,1,0)+vect(0,0,1)*Default.CollisionHeight);
    //      if ( FastTrace(Location - vect(0,0,1.5)*default.CollisionHeight, Location) )
      if ( A == none )
      { // there is no obstacle below body, try falling to avoid body hanging by nothing
  //      Log(self@"LandedSpecial Trying to make the body fall further");
        SetCollisionSize(1.0, Default.CollisionHeight);
        PrePivot = vect(0,0,0);
        SetPhysics(PHYS_Spider); // Trick to keep the PHYS_Falling in the c++Code.
        return;
      }
      else if ( XIIIPawn(A) != none )
      { // kinda jump off pawn
        Velocity += (100 + default.CollisionRadius) * VRand();
        Velocity.Z = 1 + default.CollisionHeight;
        SetPhysics(PHYS_Spider);
        if ( Controller != none )
          Controller.SetFall();
  //      MakeNoise(0.15);
        return;
      }
    }
//    Log(self@"LandedSpecial should have hit floor"@A);
//    SetCollisionSize(Default.CollisionRadius, default.CollisionHeight);
    MakeNoise(0.208); // should be around 4m for default hearing threshold of 1500
    ReduceMyCylinder();
    SetPhysics(PHYS_None); // Set physics BEFORE Else floor will be wrong
    A = Trace(HitLoc, HitNorm, Location - vect(0,0,1)*(8+CollisionRadius+CollisionHeight), Location, false, vect(0,0,0));
    if ( A != none )
    {
      GetAxes(Rotation, X,Y,Z);
      Z = HitNorm;
      Y = Z cross X;
      X = Y cross Z;
      FinalRot = OrthoRotation(X,Y,Z);
      setRotation(finalRot);
      PrePivot = (vect(0,0,1) * default.CollisionHeight) >> Rotation;
//      Log("Location="$Location@"HitLoc="$HitLoc);
      PrePivot -= vect(0,0,1)*(Location.z - HitLoc.z - 5);
    }
}

//_____________________________________________________________________________
state Dying
{
    function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType) {}
    event AnimEnd(int Channel) {}
    function PlayWaiting() {}
    function PlayOpenDoor() {}
    function PlaySearchCorpse() {}
    event PlayJump() {}
    event PlayLandingAnimation(float ImpactVel) {}
    function PlaySwitchingWeapon(float Rate, name FiringMode) {}
    function PlayReLoading(float Rate, name FiringMode) {}
    function PlayFiring(float Rate, name FiringMode) {}
    event SetAnimAction(name NewAnimAction) {}

    event Touch( Actor Other )
    {
//      Log("TOUCH Dying "$Other@"Base="$Base);
      if ( Other == Base ) // dropped in a lift
      {
        LandedSpecial(true);
        Velocity = vect(0,0,0);
//        SetPhysics(PHYS_None); // Set physics BEFORE Else floor will be wrong
        SetBase(Other);
      }
    }

    event Timer2()
    { // Setup by Player when Searchcorpse on self
      if ( (Shadow != none) && !IsAnimating() )
      {
        if ( LastRenderTime < Level.TimeSeconds - 0.3 )
        {
//          Log("Keep shadow dynamic");
          SetTimer2(1.0, false);
        }
        else
        {
//          Log("Setting shadow Static");
          Shadow.bShadowIsStatic = true;
        }
      }
    }
    function Timer()
    { // ELR Disappear in multi, not in solo
//      log(self@"Dying Timer");
      if ( !bSearchable )
      {
        bSearchable = true;
        SetTimer(4.0, false);
        return;
      }
      if ( (MyBloodPool == none) && class<XIIIDamageType>(HitDamageType).default.bSpawnBloodFX )
      {
        if ( (Level.Game != none) && (Level.Game.GoreLevel == 0) )
          MyBloodPool = spawn(class'Bloodflow', self,, Location - (CollisionHeight-8) * vect(0,0,1), rotator(vect(0,0,-1)));
      }

      if ( Level.bLonePlayer )
      {
        if ( bDestroyWhenDead )
        {
          if (
            ((Level.TimeSeconds - LastRenderTime) > DelayBeforeDestroyWhenDead)
            && (vSize(PawnKiller.Location - Location) > DistanceBeforeDestroyWhenDead)
            )
          {
            if ( MyBloodPool != none ) MyBloodPool.destroy();
            if (Shadow != none)
            {
              Shadow.Destroy();
              Shadow = none;
            }
            Destroy();
          }
          else
            SetTimer(1.0, false);
        }
        else
        {
          if ( (Shadow != none) && !IsAnimating() )
          {
            if ( LastRenderTime < Level.TimeSeconds - 0.3 )
            {
              RecomputeBoundingVolume(false);
              SetTimer2(1.0, false);
            }
            else
            {
              RecomputeBoundingVolume(true);
              Shadow.bShadowIsStatic = true;
            }
          }
          else
            SetTimer2(1.0, false);
        }
        return;
      }

/*      if ( !PlayerCanSeeMe() )
      {
        if ( MyBloodPool != none ) MyBloodPool.destroy();
        Destroy();
      }
      else
        SetTimer(1.0,false);
*/
    }

    function bool BeingGrabbed()
    {
//      Landed(vect(0,0,1));
      LieStill();
      GotoState('Grabbed');
      if ( MyBloodPool != none )
        MyBloodPool.GotoState('');
      return True;
    }

    function BeginState()
    {
//      Log("Dying BeginState, should be setting timer to 2.0");
      Buoyancy = 20.0;

      enable('tick');
      bForceInUniverse = false;
      RefreshDisplaying();

      if ( bTearOff && (Level.NetMode == NM_DedicatedServer) )
        LifeSpan = 1.0;
      SetTimer(2.0, false);

      SetPhysics(PHYS_Falling);
      bInvulnerableBody = true;

      if ( Controller != None )
      {
        if( Controller.bIsPlayer )
          Controller.PawnDied();
        else
          SpawnCadavre();
        if (controller != none)
          Controller.bControlAnimations = true;
      }
    }

    function Landed(vector HitNormal)
    {
//      local float OldHeight;

//      Log("LANDED Dying State");
//      Log(self@"Landed in DyingState");
      LandedSpecial();
/*
      if ( FastTrace(Location - vect(0,0,1.2)*default.CollisionHeight, Location) )
      { // there is no obstacle below body, try falling to avoid body hanging by nothing
//        Log(self@"Trying to make the body fall further (Landed)");
        SetCollisionSize(10.0, Default.CollisionHeight);
        SetPhysics(PHYS_Spider); // Trick to keep the PHYS_Falling in the c++Code.
        return;
      }
      else
      {
//        Log(self@"should have hit floor (Landed)");
        SetCollisionSize(Default.CollisionRadius, Default.CollisionHeight);
        ReduceCylinder();
      }

      SetPhysics(PHYS_None); // Set physics BEFORE Else floor will be wrong
      GetAxes(Rotation, X,Y,Z);
//      Log(self@"GetAxes result : X="$X@"Y="$Y@"Z="$Z);
      Z = Floor;
      Y = Z cross X;
      X = Y cross Z;
//      Log(self@"New ortho : X="$X@"Y="$Y@"W="$W);
      FinalRot = OrthoRotation(X,Y,Z);
      setRotation(finalRot);
*/
//      PlaySound(hBodyFallSound);
/*
      finalRot = Rotation;
      finalRot.Roll = 0;
      finalRot.Pitch = 0;
      setRotation(finalRot);
*/
    }

    function LieStill()
    {
      if ( !bThumped )
        LandThump();
//      if ( CollisionHeight != CarcassCollisionHeight )
//        ReduceCylinder(); // ELR Now made in Landed
    }

    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
      LOCAL bool bKilled;

      if ( Level.bLonePlayer && !Level.Game.bGameEnded )
      {
        if ( DamageType.default.bCanKillStunnedCorspes )
        {
          bKilled = (Health<=0) && ((DamageType != class'DTFisted') && (DamageType != class'DTCouDCross') && (DamageType != class'DTStunned') && (DamageType != class'DTSureStunned') && (DamageType != class'DTDropAfterStun'));
          if ( ( instigatedBy.IsPlayerPawn() && ( (GameOver==GO_TakeDamageFromPlayer) || ( GameOver==GO_KillByPlayer && bKilled ) ) ) || ( GameOver==GO_AnyDeath && bKilled ) )
          {
            Log("DEAD Taking deadly damages w/ GameOver type != GO_Never");
            if ( GameOverGoal>=0)
            {
              if (GameOverGoal>=90)
              {
                XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GameOverGoal);
              }
              else
              if ( XIIIGameInfo(Level.Game).MapInfo.Objectif[GameOverGoal].bPrimary )
              {
                XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GameOverGoal);
              }
            }
            else
              Level.Game.EndGame( PlayerReplicationInfo, "GoalIncomplete" );
          }
        }
      }
/*
      if ( bInvulnerableBody )
        return;
      if (Damage > 300)
        ChunkUp(Damage);
*/
    }


Begin:
  Sleep(0.5);
  bInvulnerableBody=false;
  // ELR Added LieStill there 0.5 seconds after state beginning because we don't want the col cyl staying big a long time
  LieStill();
}

//_____________________________________________________________________________
// Dropped to ground after holding corpse/Prisonner
state BodyDropped
{
    function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType) {}
    event AnimEnd(int Channel) {}
    function PlayWaiting() {}
    function PlayOpenDoor() {}
    function PlaySearchCorpse() {}
    event PlayJump() {}
    event PlayLandingAnimation(float ImpactVel) {}
    function PlaySwitchingWeapon(float Rate, name FiringMode) {}
    function PlayReLoading(float Rate, name FiringMode) {}
    function PlayFiring(float Rate, name FiringMode) {}
    event SetAnimAction(name NewAnimAction) {}
//    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType) {}
    event PhysicsVolumeChange( PhysicsVolume NewVolume )
    {
//      Log(self@"PhysicsVolumeChange");
      Buoyancy = 20.0;
      SetPhysics(PHYS_Falling);
    }
    event Touch( Actor Other )
    {
//      Log("TOUCH BodyDropped "$Other@"Base="$Base);
      if ( Other == Base ) // dropped in a lift
      {
        LandedSpecial(true);
        Velocity = vect(0,0,0);
//        SetPhysics(PHYS_None); // Set physics BEFORE Else floor will be wrong
        SetBase(Other);
      }
    }

    event Timer2()
    { // Setup by Player when Searchcorpse on self
      if ( (Shadow != none) && !IsAnimating() )
      {
        if ( LastRenderTime < Level.TimeSeconds - 0.3 )
        {
//          Log("Keep shadow dynamic");
          SetTimer2(1.0, false);
        }
        else
        {
//          Log("Setting shadow Static");
          Shadow.bShadowIsStatic = true;
        }
      }
    }

    event BeginState()
    {
//      Log(self@"LyingStill BeginState");
      Buoyancy = 20.0;
      SetPhysics(PHYS_Falling);
    }
    event Landed(vector HitNormal)
    {
//      local rotator finalRot;
//      local float OldHeight;
//      local vector X,Y,Z;

//      Log("LANDED BodyDropped State");
//      ReduceCylinder();
      LandedSpecial();
/*
      if ( FastTrace(Location - vect(0,0,1.2)*default.CollisionHeight, Location) )
      { // there is no obstacle below body, try falling to avoid body hanging by nothing
//        Log(self@"Trying to make the body fall further (LyingStillLanded)");
        SetCollisionSize(1.0, CarcassCollisionHeight);
        SetPhysics(PHYS_Spider); // Trick to keep the PHYS_Falling in the c++Code.
        return;
      }
      else
      {
//        Log(self@"should have hit floor (LyingStillLanded)");
        SetCollisionSize(1.7 * Default.CollisionRadius, CarcassCollisionHeight);
      }

      SetPhysics(PHYS_None); // Set physics BEFORE Else floor will be wrong
      GetAxes(Rotation, X,Y,Z);
      Z = Floor;
      Y = Z cross X;
      X = Y cross Z;
      FinalRot = OrthoRotation(X,Y,Z);
      setRotation(finalRot);
*/
//      PlaySound(hBodyFallSound);
      Shadow.bShadowIsStatic = false;
      SetTimer2(1.0, false);
    }
    function bool BeingGrabbed()
    {
      GotoState('Grabbed');
      return True;
    }
    function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
    {
      LOCAL bool bKilled;

      if ( Level.bLonePlayer && !Level.Game.bGameEnded )
      {
        if ( DamageType.default.bCanKillStunnedCorspes )
        {
          bKilled = (Health<=0) && ((DamageType != class'DTFisted') && (DamageType != class'DTCouDCross') && (DamageType != class'DTStunned') && (DamageType != class'DTSureStunned') && (DamageType != class'DTDropAfterStun'));
		  if ( PawnName~="galbrain" )
			log ("-=>"@PawnName@bKilled);
          if ( ( instigatedBy.IsPlayerPawn() && ( (GameOver==GO_TakeDamageFromPlayer) || ( GameOver==GO_KillByPlayer && bKilled ) ) ) || ( GameOver==GO_AnyDeath && bKilled ) )
          {
            Log("DEAD Taking deadly damages w/ GameOver type != GO_Never");
            if ( GameOverGoal>=0)
            {
              if (GameOverGoal>=90)
              {
                XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GameOverGoal);
              }
              else
              if ( XIIIGameInfo(Level.Game).MapInfo.Objectif[GameOverGoal].bPrimary )
              {
                XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(GameOverGoal);
              }
            }
            else
              Level.Game.EndGame( PlayerReplicationInfo, "GoalIncomplete" );
          }
        }
      }
/*
      if ( bInvulnerableBody )
        return;
      if (Damage > 300)
        ChunkUp(Damage);
*/
    }
}

//_____________________________________________________________________________
// ELR
// ::TODO:: Check if leaving the corpse invisible on the ground until it is dropped
//   to a new location can not cause Bugs (else will have to make it follow his grabber).
State Grabbed
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, PainTimer, TakeDamage;

    function AnimEnd(int Channel)
    {
      Super.AnimEnd(Channel);
    }

    function bool UnGrabbed(vector Loc, vector Dir)
    {
      local vector vT;

      SetCollisionSize(1.0, CarcassCollisionHeight);
      PrePivot = vect(0,0,1) * (default.CollisionHeight - CarcassCollisionHeight);
      vT = Dir; vT.Z = 0.0;
      if ( !SetLocation(Loc) )
        if ( !SetLocation(Loc+0.5*CollisionRadius*vT) )
          if ( !SetLocation(Loc-0.5*CollisionRadius*vT) )
          {
            Log("BIG BUG CAN'T DROP BODY THERE !!!!!!!!! CHANGE THE BODY DROP TESTS");
            //destroy();
          }
      Setrotation(rotator(vT));
      Velocity = vT*50;
      GotoState('BodyDropped');
//      SetPhysics(PHYS_Falling);
//      Landed(vect(0,0,1));
      return true;
    }

    function BeginState()
    {
      Disable('tick');
      if ( !IsPlayerPawn() )
      {
//        Log("^^^ Cancelling RecomputeBoundingVolume for "$self);
        RecomputeBoundingVolume(false);
      }
      DTMemorize = DrawType;
      SetDrawType(DT_None);
      bBlockZeroExtentTraces=false;
      bBlockNonZeroExtentTraces=false;
      if (Shadow != none)
      {
        Shadow.Destroy();
        Shadow = none;
      }
    }

    function EndState()
    {
      Enable('tick');
      SetDrawType(DTMemorize);
      bBlockZeroExtentTraces=true;
      bBlockNonZeroExtentTraces=true;
      if ( bActorShadows && (Shadow == None) )
      {
        Shadow = Spawn(class'ShadowProjector',Self,'',Location);
        if ( (Shadow!=none) && (XIIIGameInfo(Level.Game).MapInfo != none) )
        {
          Shadow.MaxTraceDistance = XIIIGameInfo(Level.Game).MapInfo.MaxTraceDistance;
          Shadow.ShadowIntensity = XIIIGameInfo(Level.Game).MapInfo.ShadowIntensity;
          Shadow.ShadowMaxDist = XIIIGameInfo(Level.Game).MapInfo.ShadowMaxDist;
          Shadow.ShadowTransDist = XIIIGameInfo(Level.Game).MapInfo.ShadowTransDist;
        }
      }
    }
}

//_____________________________________________________________________________
// ELR
State Prisonner
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, PainTimer;

    function bool UnGrabbed(vector Loc, vector Dir)
    {
      local vector vT, hitLoc, HitNorm;
      local float OldHeight, OldRadius;
      local actor A;

      // must check we don't drop below ground
      A = Trace(HitLoc, HitNorm, Loc - vect(0,0,1)*CollisionHeight, Loc + vect(0,0,1)*CollisionHeight, false);
      if ( A != none )
      {
//        Log("UNGRAB Trace="$A);
        Loc = HitLoc + vect(0,0,8) + vect(0,0,1)*(CollisionHeight + (1.0-HitNorm.Z)*CollisionRadius);
      }
      vT = Dir; vT.Z = 0.0;
      if ( !SetLocation(Loc) )
        if ( !SetLocation(Loc+0.5*30*vT) )
          if ( !SetLocation(Loc-0.5*30*vT) )
          {
            Log("BIG BUG CAN'T DROP BODY THERE !!!!!!!!! CHANGE THE BODY DROP TESTS");
            //destroy();
          }
//      SetCollisionSize(default.collisionRadius, default.CollisionHeight);
//      Log("Dropped body at Loc="$Location@"Wanted="$Loc);
      Setrotation(rotator(vT));
      Velocity = vT*50.0;
      SetCollision(true,false,false);
//      Controller.SetTimer(0.5,false);
      GotoState('');
      TakeDamage( 2000, self, Location, vect(0,0,0) , class'DTDropAfterStun');
      return true;
    }
    function BeginState()
    {
      Disable('tick');
//      PlayGrabbed();
      DTMemorize = DrawType;
      SetDrawType(DT_None);
      SetCollision(false,false,false);
//      log(self$" begin prisonner state, anim="$AnimSequence);
      bBlockZeroExtentTraces=false;
      bBlockNonZeroExtentTraces=false;
      if (Shadow != none)
      {
        Shadow.Destroy();
        Shadow = none;
      }
    }
    function EndState()
    {
      Enable('tick');
      SetDrawType(DTMemorize);
//      log(self$" End prisonner state, anim="$AnimSequence);
      bBlockZeroExtentTraces=true;
      bBlockNonZeroExtentTraces=true;
      if(bActorShadows && (Shadow==None) )
      {
        Shadow = Spawn(class'ShadowProjector',Self,'',Location);
        if ( (Shadow!=none) && (XIIIGameInfo(Level.Game).MapInfo != none) )
        {
          Shadow.MaxTraceDistance = XIIIGameInfo(Level.Game).MapInfo.MaxTraceDistance;
          Shadow.ShadowIntensity = XIIIGameInfo(Level.Game).MapInfo.ShadowIntensity;
          Shadow.ShadowMaxDist = XIIIGameInfo(Level.Game).MapInfo.ShadowMaxDist;
          Shadow.ShadowTransDist = XIIIGameInfo(Level.Game).MapInfo.ShadowTransDist;
        }
      }
    }
}

/*
//_____________________________________________________________________________
//function ControlSpine1Rotation()
simulated function ControlSpineRotation(bool bPlayer)
{
    local rotator R,S;
    local vector X,Y,Z;

    if ( !IsInState('Dying') && (bPlayer || !IsPlayerPawn()) && bEnableSpineControl)
    {
      if ( bPlayer )
        GetAxes(Controller.Rotation, X,Y,Z);
      else
      {
        if ( Controller.focus != none )
          GetAxes(rotator(Controller.focus.Location - Location), X,Y,Z);
        else
          GetAxes(rotator(Controller.FocalPoint - Location), X,Y,Z);
      }

      if ( Controller.Rotation.Pitch == 0 )
        R = OrthoRotation(Z,-X,-Y);
      else
        R = OrthoRotation(Z,X,-Y);
    }
    else
    {
      // Old solution
//      R = GetBoneRotation('X Pelvis');
      // NewSolution
      GetAxes(Rotation, X,Y,Z);
      if ( Rotation.Pitch == 0 )
        R = OrthoRotation(Z,-X,-Y);
      else
        R = OrthoRotation(Z,X,-Y);
    }
    R.Pitch = Max(9000, R.Pitch);
    rSpineRotation = R;
//    if ( bEnableSpineControl )
      SetBoneDirection( FIRINGBLENDBONE, rSpineRotation,, 1.0 );
//    else
//      SetBoneDirection( FIRINGBLENDBONE, rot(0,0,0), vect(0,0,0), 0.0 );
//    if ( Controller.bControlAnimations )
//      log("==(ControlSpineRotation)"@self@"SET rSpineRotation="$rSpineRotation@"Role="$Role);
}
*/

//_____________________________________________________________________________
//
simulated event Tick(float DT)
{
    if ( ((Controller != none) && Controller.bControlAnimations) || (Controller == none) || bIsDead )
    {
      SetBoneDirection( FIRINGBLENDBONE, rot(0,0,0), vect(0,0,0), 0.0 );
      return;
    }

    if (MyOldAcceleration != Acceleration)
    {
      if (MyOldAcceleration == vect(0,0,0)) // Start to move
      {
        if ( bDBAnim ) Log("@@ Tick == Animation Start Moving");
        bMoving=true;
      }
      else if ( Acceleration == vect(0,0,0) ) // Stopped moving
      {
        if ( bDBAnim ) Log("@@ Tick == Animation Stop Moving");

        if ( bMoving && (Physics == PHYS_Walking) )
          PlayEndStep();

        bMoving=false;
      }
    }
    MyOldAcceleration = Acceleration;
}

//_____________________________________________________________________________
simulated function PlayLanded(float impactVel)
{
    local float landVol;
    local material M;
    local actor A;
    local vector HitLoc, HitNorm;
    local bool bSilent;

    if ( bDBAnim ) Log("@@ PlayLanded call for "$self@"w/bPhysicsAnimUpdate="$bPhysicsAnimUpdate);
    //default - do nothing (keep playing existing animation)
    landVol = impactVel/JumpZ;
    landVol = 0.005 * Mass * landVol * landVol;
//    PlaySound(Land, SLOT_Interact, FMin(20, landVol));
//    if ( !bPhysicsAnimUpdate || !bMoving )
    if ( !bPhysicsAnimUpdate )
      PlayLandingAnimation(impactvel);
//    ChangeAnimation();
}

//_____________________________________________________________________________
simulated event ChangeAnimation()
{
    if ( bDBAnim ) Log("@@ Change anim call for "$self);

    if ( (Controller != None) && Controller.bControlAnimations )
    {
      return;
    }
    // player animation - set up new idle and moving animations

    PlayWaiting();
    PlayMoving();
}

//_____________________________________________________________________________
// sent by the beginstate of active state for weapon
simulated function SetFiringMode(name FM)
{
    if ( bDBAnim ) Log("### SetFiringMode "$FM);

    WeaponMode = FM;
    PlayWaiting();
    PlayMoving();
    bChangingWeapon=false;
    bReloadingWeapon=false;
    AnimEnd(FIRINGCHANNEL); // Stop the changing weapon anim using the FIRINGCHANNEL
}

//_____________________________________________________________________________
simulated event AnimEnd(int Channel)
{
    if ( bDBAnim ) Log("@@ AnimEnd w/channel="$Channel$" call for "$self);

    if ( (Controller != none) && Controller.bControlAnimations )
    {
      AnimBlendToAlpha(Channel,0,0.1);
      return;
    }

    if (Physics == PHYS_Ladder)
    {
      PlayWaiting();
      return;
    }

    if ( Channel == FIRINGCHANNEL )
    {
      bRndAnimM16 = true;

      // FIRINGCHANNEL used for upper body (firing weapons, etc.)

      if ( Role < ROLE_Authority )
      {
        PlayWaiting();
        PlayMoving();
      }
      if ( bReloadingWeapon || !bChangingWeapon )
      {
        AnimBlendToAlpha(FIRINGCHANNEL,0,0.2);
      }
      else
      {
        if ( bChangingWeapon )
        {
          Switch(WeaponMode)
          {
            Case 'FM_Bazook':
            Case 'FM_BazookAlt':
            Case 'FM_2H':
            Case 'FM_M16':
            Case 'FM_ARAlt':
            Case 'FM_ShotGunAlt':
            Case 'FM_HarpoonAlt':
              PlayAnim('SearchGun',,0.15,FIRINGCHANNEL); break;
            Case 'FM_2HHeavy':
              PlayAnim('SearchGatling',,0.15,FIRINGCHANNEL); break;
            Default:
              PlayAnim('SearchPistol',,0.15,FIRINGCHANNEL); Break;
          }
          bReloadingWeapon=false;
        }
        else
        {
          if ( !bMoving )
            PlayWaiting();
          else
            PlayMoving();
        }
      }
    }
    else
    {
      if ( !bMoving )
        PlayWaiting();
      else
        PlayMoving();
    }
}

//_____________________________________________________________________________
simulated function PlayWaiting()
{
    if ( bDBAnim ) Log("--@ PlayWaiting call for "$self);

    if ( (Controller != None) && Controller.bControlAnimations )
      return;

    if ( Physics == PHYS_Ladder )
    {
      PlayAnim('WaitEchelle',,0.25);
      return;
    }
    else if ( Physics == PHYS_Swimming )
    {
      PlayAnim('Swim',,0.25);
      return;
    }
    else if ( Physics == PHYS_Falling )
      PlayJump();
    else if ( bIsCrouched )
      PlayAnim('WaitAccroupi',,0.25);
    else if ( AnimStatus =='Alert' )
      PlayAnim('WaitAlerteNeutre',,0.25);
    else
      PlayAnim('WaitNeutre',,0.25);


    if ( bIsCrouched )
    {
      Switch(WeaponMode)
      {
        Case 'FM_Snipe':
          WaitWeaponAnim='SniperWait'; Break;
        Case 'FM_1H':
        Case 'FM_44Alt':
        Case 'FM_Throw':
          WaitWeaponAnim='WaitPistoletAccroupi'; break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_ARAlt':
        Case 'FM_ShotGunAlt':
        Case 'FM_HarpoonAlt':
          WaitWeaponAnim='WaitFusilAccroupi'; break;
        Case 'FM_Bazook':
        Case 'FM_BazookAlt':
          WaitWeaponAnim='WaitBazooka'; break;
        Case 'FM_2HHeavy':
          WaitWeaponAnim='WaitGatling'; break;
        Default:
          WaitWeaponAnim='WaitNeutreAccroupi'; break;
      }
    }
    else
    {
      if ( AnimStatus =='Alert' )
      {
        Switch(WeaponMode)
        {
          Case 'FM_Snipe':
            WaitWeaponAnim='SniperWait'; Break;
          Case 'FM_1H':
          Case 'FM_44Alt':
            WaitWeaponAnim='WaitPistoletAlerte2'; Break;
          Case 'FM_Throw':
            WaitWeaponAnim='WaitCouteauAlerte'; Break;
          Case 'FM_2H':
          Case 'FM_M16':
          Case 'FM_ARAlt':
          Case 'FM_ShotGunAlt':
          Case 'FM_HarpoonAlt':
            WaitWeaponAnim='WaitKalashAlerte'; Break;
          Case 'FM_Bazook':
          Case 'FM_BazookAlt':
            WaitWeaponAnim='WaitBazooka'; Break;
          Case 'FM_2HHeavy':
            WaitWeaponAnim='WaitGatling'; Break;
          Default:
            WaitWeaponAnim = 'WaitNeutreAlerte'; Break;
        }
      }
      else
      {
        Switch(WeaponMode)
        {
          Case 'FM_Snipe':
            WaitWeaponAnim='WaitSniperAlerte'; break;
          Case 'FM_1H':
          Case 'FM_44Alt':
          Case 'FM_Throw':
            WaitWeaponAnim='WaitPistolet'; break;
          Case 'FM_2H':
          Case 'FM_M16':
          Case 'FM_ARAlt':
          Case 'FM_ShotGunAlt':
          Case 'FM_HarpoonAlt':
            WaitWeaponAnim='WaitKalash'; break;
          Case 'FM_Bazook':
          Case 'FM_BazookAlt':
            WaitWeaponAnim='WaitBazooka'; break;
          Case 'FM_2HHeavy':
            WaitWeaponAnim='WaitGatling'; break;
          Default:
            WaitWeaponAnim = 'WaitNeutre'; break;
        }
      }
    }

    PlayAnim(WaitWeaponAnim,,0.25,12);
    AnimBlendParams(12,1.0,0.0,0.0,FIRINGBLENDBONE);
}

//_____________________________________________________________________________
simulated function PlayMoving()
{
    if ( bDBAnim ) Log("--@ PlayMoving call for "$self@"in physics"@Physics);

    if ( Physics == PHYS_Ladder )
    {
      AnimateLadder();
      return;
    }
    else if ( Physics == PHYS_Swimming )
    {
      AnimateSwimming();
      return;
    }

    if ( (Physics == PHYS_None) || ((Controller != None) && Controller.bPreparingMove) )
    {
      // bot is preparing move - not really moving
      PlayWaiting();
      return;
    }
    if ( Physics == PHYS_Falling )
    {
      PlayJump();
    }
    if ( Physics != PHYS_Ladder )
    {
      if ( bIsCrouched )
        AnimateCrouchWalking();
      else if ( bIsWalking )
        AnimateWalking();
      else
        AnimateRunning();
     }
}

/*//_____________________________________________________________________________
simulated function PlayLadder()
{
    if (Velocity == vect(0,0,0) )
      PlayAnim('WaitEchelle',,0.25);
    else if ( Velocity.z > 0 )
      PlayAnim('ClimbUp',,0.25);
    else
      PlayAnim('ClimbDown',,0.25);
    AnimBlendToAlpha(SUBWEAPONCHANNEL,0,0.1);
}*/

//_____________________________________________________________________________
simulated function PlayOpenDoor()
{
    if ( bDBAnim ) Log("--@ PlayOpenDoor call for "$self);
    PlayAnim('OpenDoor',,0.1,FIRINGCHANNEL);
}

//_____________________________________________________________________________
simulated function PlaySearchCorpse()
{
    if ( bDBAnim ) Log("--@ PlayOpenDoor call for "$self);
    PlayAnim('SearchGround',,0.1,FIRINGCHANNEL);
}

//_____________________________________________________________________________
simulated event PlayJump()
{
    local vector XY;

    if ( bDBAnim )
      Log("--@"@Level.TimeSeconds@" PlayJump call for "$self);

    if ( (Level.NetMode == NM_Client) && !IsLocallyControlled() && (LastJumpSoundTime < Level.TimeSeconds - 1.0) )
    {
//      Log("  @"@Level.TimeSeconds@" PlayJump Play sound");
      LastJumpSoundTime = Level.TimeSeconds;
      PlaySound(hJumpSound); // play jump sound on clients
    }
/*    if ( bJumpImpulse )
    {
      PlayAnim('ImpulsionJump',,0.0) ;
      bJumpImpulse = false;
    }
    else
    {*/
      XY = Velocity;
      XY.z = 0.0;
      if ( vSize(XY) < 30.0 )
        PlayAnim('JumpUp',,0.50);
      else
        PlayAnim('Jump',,0.50);
//    }
}

//_____________________________________________________________________________
simulated event PlayLandingAnimation(float ImpactVel)
{
    if ( (Controller != None) && Controller.bControlAnimations )
      return;

    if ( bIsDead || IsDead() )
      return;

    if ( bDBAnim ) Log("--@ PlayLandingAnimation call for "$self);

    AnimateCrouchWalking();

    if( velocity.x + velocity.y > 70 )
    {
        PlayAnim('WaitAccroupi',,0.25);
        SetTimer( 0.3,false );
    }
    else
    {
        PlayAnim('WaitAccroupi',,0.15);
        SetTimer( 0.3,false );
    }
}

//_____________________________________________________________________________
simulated event PlayDying(class<DamageType> DamageType, vector HitLoc)
{
    if ( bDBAnim ) Log("--@ PlayDying call for "$self@"HitLocCode="$HitLoc);

    bPlayedDeath = true;
    if ( bPhysicsAnimUpdate )
    {
      bTearOff = true;
      bReplicateMovement = false;
    }
//    Velocity += TearOffMomentum;
    SetPhysics(PHYS_Falling);

    AnimBlendToAlpha(FIRINGCHANNEL,0,0.1);
    //AnimBlendToAlpha(FIRINGCHANNEL+2,0,0.1);//suppression du paf

    PlayDyingAnim(DamageType,HitLoc);
    GotoState('Dying');
}

//_____________________________________________________________________________
simulated function PlayDyingAnim(class<DamageType> DamageType, vector HitLoc)
{
    local name DeathAnim;

    DeathAnim='DeathTete'; // default

    if ( bIsCrouched )
        DeathAnim = 'deathaccroupi';
    else if ( DamageType == class'DTDropAfterStun' )
    {
        DeathAnim = 'deathotage';
    }
    else if ( (DamageType == class'DTStunned') || (DamageType == class'DTSureStunned') )
        DeathAnim = 'deathassomme';
    else
    {
      if( HitLoc.X == 0 )
      {
          switch( 1 )
//          switch( int(fRand()*2) )
          {
            case 0: DeathAnim='DeathTete'; break;
            case 1: DeathAnim='DeathTete2'; break;
            case 2: DeathAnim='DeathTete'; break;
          }
      }
      else
      {
          switch( int(fRand()*8) )
          {
            case 0: DeathAnim='DeathEpauleGauche'; break;
            case 1: DeathAnim='DeathChevilleGauche'; break;
            case 2: DeathAnim='DeathChevilleDroite'; break;
            case 3: DeathAnim='DeathBuste3'; break;
            case 4: DeathAnim='DeathDos'; break;
            case 5: DeathAnim='DeathVentre' ; break;
            case 6: DeathAnim='DeathBuste0'; break;
            case 7: DeathAnim='DeathBuste2' ; break;
            case 8: DeathAnim='DeathTete2'; break;
          }
      }
    }

    if ( DamageType == class'DTDropAfterStun' )
    {
      PlayAnim(DeathAnim,1.0,0);
      PlayAnim(DeathAnim,1.0,0,FIRINGCHANNEL+2);
      EnableChannelNotify(FIRINGCHANNEL+2, 0);
    }
    else
    {
      PlayAnim(DeathAnim,1.0,0.15);
      PlayAnim(DeathAnim,1.0,0.15,FIRINGCHANNEL+2);
      EnableChannelNotify(FIRINGCHANNEL+2, 0);
    }

    if ( bDBAnim )
        Log("### PlayDyingAnim call for "$self@" HitLoc="$HitLoc@"anim="@DeathAnim);
}

//_____________________________________________________________________________
simulated function PlaySwitchingWeapon(float Rate, name FiringMode)
{
    if ( bDBAnim ) Log("--@ PlaySwitchingWeapon call for "$self@"w/FiringMode="$FiringMode);

    if ( bIsDead )
      return;

    WeaponMode = FiringMode;
    bChangingWeapon = true;
    bWeaponFiring = false;
    AnimBlendParams(FIRINGCHANNEL,1.0,0,0,FIRINGBLENDBONE);

    Switch(WeaponMode)
    {
      Case 'FM_Bazook':
      Case 'FM_BazookAlt':
      Case 'FM_2H':
      Case 'FM_M16':
      Case 'FM_ARAlt':
      Case 'FM_ShotGunAlt':
      Case 'FM_HarpoonAlt':
        AnimAction = 'SearchGun'; break;
      Case 'FM_2HHeavy':
        AnimAction = 'SearchGatling'; break;
      Default:
        AnimAction = 'SearchPistol'; break;
    }

    PlayAnim(AnimAction,Rate,0.15,FIRINGCHANNEL);
}

//_____________________________________________________________________________
simulated function PlayReLoading(float Rate, name FiringMode)
{
    if ( bDBAnim ) Log("--@ PlayReLoading call for "$self@"w/FiringMode="$FiringMode);

    if ( bIsDead )
      return;

    WeaponMode = FiringMode;
    bReloadingWeapon = true;
    bWeaponFiring = false;
    AnimBlendParams(FIRINGCHANNEL,1.0,0,0,FIRINGBLENDBONE);
    AnimBlendToAlpha(FIRINGCHANNEL,1.0, 0.001 );

 Switch(WeaponMode)
    {
		Case 'FM_Snipe':
			if ( bIsCrouched )
          AnimAction = 'ReloadGunAccroupi';
        else
          AnimAction = 'ReLoadGun';
			break;
      Case 'FM_Bazook':
        AnimAction = 'ReloadBazooka'; break;
      Case 'FM_2H':
      Case 'FM_M16':
		  if ( bIsCrouched )
          AnimAction = 'ReloadGunAccroupi';
        else
          AnimAction = 'ReLoadGun';
			break;
      Case 'FM_2HHeavy':
        AnimAction = 'ReLoadGatling'; break;
      Default:
        if ( bIsCrouched )
          AnimAction = 'ReloadPistolAccroupi';
        else
          AnimAction = 'ReLoadPistol';
        break;
    }
    PlayAnim(AnimAction,Rate,0.15,FIRINGCHANNEL);
}

//_____________________________________________________________________________
simulated function PlayFiring(float Rate, name FiringMode)
{
    if ( bDBAnim )
      Log("--@ PlayFiring call for "$self@"w/FiringMode="$FiringMode);

    WeaponMode = FiringMode;
    bWeaponFiring=true;
    AnimBlendParams(FIRINGCHANNEL,1.0,0,0,FIRINGBLENDBONE);
    AnimBlendToAlpha(FIRINGCHANNEL,1.0, 0.001 );

    if ( !bIsCrouched )
    {
      Switch(WeaponMode)
      {
        Case 'FM_Fists':
          if ( fRand() < 0.500 )
            AnimAction = 'HandDRetour';
          else
            AnimAction = 'HandGRetour';
          break;
        Case 'FM_BazookAlt':
          AnimAction='FireAltBazookaRetour'; break;
        Case 'FM_Snipe':
          AnimAction='SniperC'; break;
        Case 'FM_1H':
          AnimAction = 'PistoletRetour'; break;
        Case 'FM_Throw':
          AnimAction = 'ThrowRetour'; break;
        Case 'FM_2H':
          AnimAction = 'GunRetour'; break;
        Case 'FM_ShotGunAlt':
          AnimAction = 'FireAltGunRetour'; break;
        Case 'FM_HarpoonAlt':
          AnimAction = 'FireAltHarponRetour'; break;
        Case 'FM_Bazook':
          AnimAction = 'BazookaRetour'; break;
        Case 'FM_2HHeavy':
          AnimAction = 'GatlingRetour'; break;
        Case 'FM_Stun':
          AnimAction = 'DecoRetour'; break;
        Case 'FM_ARAlt':
          AnimAction = 'FireAltM16Retour'; break;
        Case 'FM_44Alt':
          AnimAction = 'FireAltMagnumRetour'; break;
        Case 'FM_M16':
          if ( bRndAnimM16 )
          {
            AnimM16 = int(fRand()*2);
            bRndAnimM16 = false;
          }
          if( AnimM16 == 0 )
            AnimAction = 'RetourKalash';
          else
            AnimAction = 'GunRetour';
          break;
        Default:
          AnimAction = 'HandDRetour'; break;
      }
    }
    else
    {
      Switch(WeaponMode)
      {
        Case 'FM_Fists':
          if ( fRand() < 0.500 )
            AnimAction = 'HandDRetour';
          else
            AnimAction = 'HandGRetour';
          break;
        Case 'FM_BazookAlt':
          AnimAction='HandDRetour'; break;
        Case 'FM_Snipe':
          AnimAction='SniperC'; break;
        Case 'FM_1H':
          AnimAction = 'PistoletRetour'; break;
        Case 'FM_Throw':
          AnimAction = 'ThrowRetourAccroupi'; break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_HarpoonAlt':
          AnimAction = 'GunRetourAccroupi'; break;
        Case 'FM_ShotGunAlt':
          AnimAction = 'HandDRetour'; break;
        Case 'FM_Bazook':
          AnimAction = 'BazookaRetour'; break;
        Case 'FM_2HHeavy':
          AnimAction = 'GatlingRetour'; break;
        Case 'FM_Stun':
          AnimAction = 'DecoRetour'; break;
        Default:
          AnimAction = 'HandDRetour'; break;
      }
    }

    PlayAnim(AnimAction,Rate,0.03,FIRINGCHANNEL);
}

/*
//_____________________________________________________________________________
simulated function PlayJumpImpulse()
{
    if ( bDBAnim ) Log("@@@ PlayJumpImpulse call for "$self);
    PlayAnim('ImpulsionJump');
}
*/

//_____________________________________________________________________________
simulated function AnimateCrouchWalking()
{
    TurnLeftAnim = 'RotationGAccroupi';
    TurnRightAnim = 'RotationDAccroupi';
    MovementAnims[0] = 'WalkAccroupi';
    MovementAnims[1] = 'StrafeGaccroupi';
    MovementAnims[2] = 'MarcheArrAccroupi';
    MovementAnims[3] = 'StrafeDaccroupi';
    MovementAnimRate[0] = 1.0;
    MovementAnimRate[1] = 1.0;
    MovementAnimRate[2] = 1.0;
    MovementAnimRate[3] = 1.0;

    Switch(WeaponMode)
    {
      Case'FM_Snipe':
        WeaponAnim='SniperWait'; break;
      Case 'FM_1H':
        WeaponAnim='WalkPistoletAccroupi'; break;
      Case 'FM_2H':
      Case 'FM_M16':
      Case 'FM_ShotGunAlt':
      Case 'FM_HarpoonAlt':
        WeaponAnim='RunGunAccroupi'; break;
      Case 'FM_Bazook':
      Case 'FM_BazookAlt':
        WeaponAnim='RunBazook'; break;
      Case 'FM_2HHeavy':
        WeaponAnim='WaitGatling'; break;
      Case 'FM_Fists':
      Case 'FM_Throw':
      Default:
        WeaponAnim='WalkAccroupi';
    }

    if ( bDBAnim ) Log("--@ AnimateCrouchWalking call for "$self@"WeaponMode="$WeaponMode@"WeaponAnim="$WeaponAnim);
}

//_____________________________________________________________________________
simulated function AnimateLadder()
{
    TurnLeftAnim = 'WaitEchelle';
    TurnRightAnim = 'WaitEchelle';
    MovementAnims[0] = 'ClimbUp';
    MovementAnims[1] = 'WaitEchelle';
    MovementAnims[2] = 'ClimbDown';
    MovementAnims[3] = 'WaitEchelle';
    MovementAnimRate[0] = 1.0;
    MovementAnimRate[1] = 1.0;
    MovementAnimRate[2] = 1.0;
    MovementAnimRate[3] = 1.0;

    if ( bDBAnim ) Log("--@ AnimateLadder call for "$self@"WeaponMode="$WeaponMode@"WeaponAnim="$WeaponAnim);
}

//_____________________________________________________________________________
simulated function AnimateSwimming()
{
    TurnLeftAnim = 'Swim';
    TurnRightAnim = 'Swim';
    MovementAnims[0] = 'Swim';
    MovementAnims[1] = 'Swim';
    MovementAnims[2] = 'Swim';
    MovementAnims[3] = 'Swim';
    MovementAnimRate[0] = 1.0;
    MovementAnimRate[1] = 1.0;
    MovementAnimRate[2] = 1.0;
    MovementAnimRate[3] = 1.0;

    if ( bDBAnim ) Log("--@ AnimateSwimming call for "$self@"WeaponMode="$WeaponMode@"WeaponAnim="$WeaponAnim);
}

//_____________________________________________________________________________
simulated function AnimateWalking()
{
    TurnLeftAnim = 'RotationG';
    TurnRightAnim = 'RotationD';
    MovementAnims[0] = 'Walk';
    MovementAnims[1] = 'StrafeG';
    MovementAnims[2] = 'MarcheArrStandar';
    MovementAnims[3] = 'StrafeD';
    MovementAnimRate[0] = 1.0;
    MovementAnimRate[1] = 1.0;
    MovementAnimRate[2] = 1.0;
    MovementAnimRate[3] = 1.0;

    if ( AnimStatus =='Alert' )
    {
      Switch(WeaponMode)
      {
        Case 'FM_Snipe':
          WeaponAnim='SniperWait'; break;
        Case 'FM_1H':
          WeaponAnim='WaitPistoletAlerte2'; break;
        Case 'FM_Throw':
          WeaponAnim='WaitCouteauAlerte'; break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_ShotGunAlt':
        Case 'FM_HarpoonAlt':
          WeaponAnim='WaitKalashAlerte'; break;
        Case 'FM_Bazook':
        Case 'FM_BazookAlt':
          WeaponAnim='WaitBazooka'; break;
        Case 'FM_2HHeavy':
          WeaponAnim='WaitGatling'; break;
        Case 'FM_Fists':
        Default:
          WeaponAnim = 'WaitNeutreAlerte'; break;
      }
      MovementAnims[0] = 'WalkAlerte';
    }
    else
    {
      Switch(WeaponMode)
      {
        Case 'FM_Snipe':
          WeaponAnim='WaitSniperAlerte'; break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_ShotGunAlt':
        Case 'FM_HarpoonAlt':
          WeaponAnim='WaitKalash'; break;
        Case 'FM_Bazook':
        Case 'FM_BazookAlt':
          WeaponAnim='RunBazook'; break;
        Case 'FM_2HHeavy':
          WeaponAnim='WalkGatling'; break;
        Case 'FM_Fists':
        Case 'FM_1H':
        Case 'FM_Throw':
        Default:
          WeaponAnim='Walk'; break;
      }
    }

    if ( bDBAnim ) Log("--@ AnimateWalking call for "$self@"WeaponMode="$WeaponMode@"WeaponAnim="$WeaponAnim);
}

//_____________________________________________________________________________
simulated function AnimateRunning()
{
    TurnLeftAnim = 'RotationG';
    TurnRightAnim = 'RotationD';
    MovementAnims[0] = 'Run';
    MovementAnims[1] = 'StrafeGspeed';
    MovementAnims[2] = 'BackPaddle';
    MovementAnims[3] = 'StrafeDspeed';
    MovementAnimRate[0] = 1.0;
    MovementAnimRate[1] = 1.0;
    MovementAnimRate[2] = 1.0;
    MovementAnimRate[3] = 1.0;

    if ( AnimStatus =='Alert' )
    {
      Switch(WeaponMode)
      {
        Case 'FM_Snipe':
          WeaponAnim='SniperWait'; break;
        Case 'FM_1H':
          WeaponAnim='RunPistoletAlerte'; break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_ShotGunAlt':
        Case 'FM_HarpoonAlt':
          WeaponAnim='WaitKalashAlerte'; break;
        Case 'FM_Bazook':
        Case 'FM_BazookAlt':
          WeaponAnim='WaitBazooka'; break;
        Case 'FM_2HHeavy':
          WeaponAnim='WaitGatling'; break;
        Case 'FM_Throw':
        Case 'FM_Fists':
        Default:
          WeaponAnim='Run'; break;
      }
    }
    else
    {
      Switch(WeaponMode)
      {
        Case 'FM_Snipe':
          WeaponAnim='SniperWait'; Break;
        Case 'FM_Fists':
          WeaponAnim='Run'; Break;
        Case 'FM_1H':
          WeaponAnim='RunPistolet'; Break;
        Case 'FM_Throw':
          WeaponAnim='Run'; Break;
        Case 'FM_2H':
        Case 'FM_M16':
        Case 'FM_ShotGunAlt':
        Case 'FM_HarpoonAlt':
          WeaponAnim='WaitKalashAlerte'; Break;
        case 'FM_Bazook':
        Case 'FM_BazookAlt':
          WeaponAnim='WalkBazook'; Break;
        case 'FM_2HHeavy':
          WeaponAnim='RunGatling'; Break;
        Default:
          WeaponAnim='Run'; Break;
      }
    }

    if ( bDBAnim ) Log("--@ AnimateRunning call for "$self@"WeaponMode="$WeaponMode@"WeaponAnim="$WeaponAnim);
}

//_____________________________________________________________________________
simulated event SetAnimAction(name NewAnimAction)
{
    if ( bDBAnim )
      Log("@@ SetAnimAction call for "$self@"w/ NewAnimAction="$NewAnimAction);

    AnimBlendParams(FIRINGCHANNEL,1.0,0,0,FIRINGBLENDBONE);
    PlayAnim(NewAnimAction,1.0,0.15, FIRINGCHANNEL);
    AnimAction='';
}

//_____________________________________________________________________________
simulated function PlaySwimSound()
{
    PlaySound(hNotifSwimSound, int(vsize(velocity)) );
}

//_____________________________________________________________________________
Simulated function PlayFootladder()
{
    local bool bSilent;

    bSilent = (FindInventoryKind('SilentWalkSkill')!=none);
    if ( LadderVolume(PhysicsVolume) != none )
    {
//      Log("PlayFootladder sound "$LadderVolume(PhysicsVolume).hFootLadderSound$" default="$class'LadderVolume'.default.hFootLadderSound);
      if ( LadderVolume(PhysicsVolume).hFootLadderSound != none )
        PlaySound(LadderVolume(PhysicsVolume).hFootLadderSound, int(vsize(velocity)), SoundStepCategory, int(bSilent) );
      else
        PlaySound(hLadderSound, int(vsize(velocity)), SoundStepCategory, int(bSilent) );
    }
}

//_____________________________________________________________________________
simulated function PlayEndStep()
{
/* Don't do anything for pawns other than player
    local material M;
    local actor A;
    local vector HitLoc, HitNorm;
    local int MemSoundStepCategory;

    if (base == none)
      return;

    A = Trace(HitLoc, HitNorm, Location - (CollisionHeight + CollisionRadius) * vect(0,0,1), location, true, vect(0,0,0), M);

    if ( TerrainInfo(A) != none )
    {
    if( Level.bReplaceHXScripts )
    PlaySndPNJStep( TerrainInfo(A).PNJSndStep, vsize(velocity), -2, false );
    else
      PlaySound(TerrainInfo(A).FootstepSound, int(vsize(velocity)), -2, 0 );
      Instigator = self;
      if ( bIsWalking )
        MakeNoise(TerrainInfo(A).NoiseLoudness / 5.0);
      else
        MakeNoise(TerrainInfo(A).NoiseLoudness);
    }
    else if (M != none)
    {
    if( Level.bReplaceHXScripts )
    PlaySndPNJStep( M.PNJSndStep, vsize(velocity), -2, false );
    else
      PlaySound(M.FootstepSound, int(vsize(velocity)), -2, 0 );
      Instigator = self;
      if ( bIsWalking )
        MakeNoise(M.NoiseLoudness / 5.0);
      else
        MakeNoise(M.NoiseLoudness);
    }
//    else
//      log("FootStepSound not played !! HitActor="$A@"M="$M);
*/
}

//_____________________________________________________________________________
simulated function PlayFootStep()
{
    local material M;
//    local actor A;
//    local vector HitLoc, HitNorm;
//    local int MemSoundStepCategory;

    if ( (base == none) || !bMoving )
      return;

//    A = Trace(HitLoc, HitNorm, Location - (CollisionHeight + CollisionRadius) * vect(0,0,1), location, true, vect(0,0,0), M);
    M = LastCollidedMaterial;
/*    if ( TerrainInfo(A) != none )
    {
      if( Level.bReplaceHXScripts )
        PlaySndPNJStep( TerrainInfo(A).PNJSndStep, vsize(velocity), SoundStepCategory, false );
      else
        PlaySound(TerrainInfo(A).FootstepSound, int(vsize(velocity)), SoundStepCategory, 0 );
      Instigator = self;
      if ( bIsWalking )
        MakeNoise(TerrainInfo(A).NoiseLoudness / 5.0);
      else
        MakeNoise(TerrainInfo(A).NoiseLoudness);
    }
    else */
    if (M != none)
    {
      if( Level.bReplaceHXScripts )
        PlaySndPNJStep( M.PNJSndStep, vsize(velocity), SoundStepCategory, false );
      else
        PlaySound(M.FootstepSound, int(vsize(velocity)), SoundStepCategory, 0 );
      Instigator = self;
      // ELR Cancel Use of M.NoiseLoudness to allow players 'hear' them by six sense always
      /*

      if ( bIsWalking )
        MakeNoise(M.NoiseLoudness / 5.0);
      else
        MakeNoise(M.NoiseLoudness);*/
      MakeNoise(1.0);
    }
//    else
//      log("FootStepSound not played !! HitActor="$A@"M="$M);
}

simulated function SNDNot00() { PlaySound(hSNDNotSound[0]); }
simulated function SNDNot01() { PlaySound(hSNDNotSound[1]); }
simulated function SNDNot02() { PlaySound(hSNDNotSound[2]); }
simulated function SNDNot03() { PlaySound(hSNDNotSound[3]); }
simulated function SNDNot04() { PlaySound(hSNDNotSound[4]); }
simulated function SNDNot05() { PlaySound(hSNDNotSound[5]); }
simulated function SNDNot06() { PlaySound(hSNDNotSound[6]); }
simulated function SNDNot07() { PlaySound(hSNDNotSound[7]); }
simulated function SNDNot08() { PlaySound(hSNDNotSound[8]); }
simulated function SNDNot09() { PlaySound(hSNDNotSound[9]); }

simulated function SNDNot10() { PlaySound(hSNDNotSound[10]); }
simulated function SNDNot11() { PlaySound(hSNDNotSound[11]); }
simulated function SNDNot12() { PlaySound(hSNDNotSound[12]); }
simulated function SNDNot13() { PlaySound(hSNDNotSound[13]); }
simulated function SNDNot14() { PlaySound(hSNDNotSound[14]); }
simulated function SNDNot15() { PlaySound(hSNDNotSound[15]); }
simulated function SNDNot16() { PlaySound(hSNDNotSound[16]); }
simulated function SNDNot17() { PlaySound(hSNDNotSound[17]); }
simulated function SNDNot18() { PlaySound(hSNDNotSound[18]); }
simulated function SNDNot19() { PlaySound(hSNDNotSound[19]); }

simulated function SNDNot20() { PlaySound(hSNDNotSound[20]); }
simulated function SNDNot21() { PlaySound(hSNDNotSound[21]); }
simulated function SNDNot22() { PlaySound(hSNDNotSound[22]); }
simulated function SNDNot23() { PlaySound(hSNDNotSound[23]); }
simulated function SNDNot24() { PlaySound(hSNDNotSound[24]); }
simulated function SNDNot25() { PlaySound(hSNDNotSound[25]); }
simulated function SNDNot26() { PlaySound(hSNDNotSound[26]); }
simulated function SNDNot27() { PlaySound(hSNDNotSound[27]); }
simulated function SNDNot28() { PlaySound(hSNDNotSound[28]); }
simulated function SNDNot29() { PlaySound(hSNDNotSound[29]); }

//    hBodyFallSound=Sound'XIIIsound.SpecActions.BodyFallGen'


defaultproperties
{
     GameOverGoal=-1
     bCanJump=True
     bCanWalkOffLedges=True
     bSpineControl=True
     bDBCartoon=True
     bAllowJump=True
     bIsPafable=True
     bCanBeGrabbed=True
     bStunnedIfJumpedOn=True
     GroundSpeed=472.000000
     AirControl=0.350000
     WalkingPct=0.500000
     CrouchingPct=0.300000
     PawnName="Someone"
     BaseEyeHeight=60.000000
     EyeHeight=50.000000
     CrouchHeight=48.000000
     Health=150
     UnderWaterTime=19.000000
     CarcassCollisionHeight=20.000000
     WeaponAnim="Run"
     WaitWeaponAnim="Run"
     bPhysicsAnimUpdate=True
     MovementAnims(0)="Run"
     MovementAnims(1)="StrafeGSpeed"
     MovementAnims(2)="BackPaddle"
     MovementAnims(3)="StrafeDSpeed"
     TurnLeftAnim="RotationG"
     TurnRightAnim="RotationD"
     Alliance="'"
     SpeedFactorLimit=1.000000
     DrownTimer=30.000000
     DTimerStep=0.250000
     WeaponMode="FM_Fists"
     CrouchedVisibility=85
     hStunFromAboveSound=Sound'XIIIsound.SpecActions.LeonFall'
     hJumpSound=Sound'XIIIsound.PNJ.PNJJump'
     hHitSound=Sound'XIIIsound.Impacts__ImpFlesh.ImpFlesh__hPlayImpFlesh'
     hLadderSound=Sound'XIIIsound.SpecActions__LadderClimb.LadderClimb__hXIIIClimbLadder'
     hCrouchSound=Sound'XIIIsound.XIIIPerso.XIIICrouch1'
     hUnCrouchSound=Sound'XIIIsound.XIIIPerso.XIIICrouch2'
     hSNDNotSound(0)=Sound'XIIIsound.PNJ.SNDNot00'
     hSNDNotSound(1)=Sound'XIIIsound.PNJ.SNDNot01'
     hSNDNotSound(2)=Sound'XIIIsound.PNJ.SNDNot02'
     hSNDNotSound(3)=Sound'XIIIsound.PNJ.SNDNot03'
     hSNDNotSound(4)=Sound'XIIIsound.PNJ.SNDNot04'
     hSNDNotSound(5)=Sound'XIIIsound.PNJ.SNDNot05'
     hSNDNotSound(6)=Sound'XIIIsound.PNJ.SNDNot06'
     hSNDNotSound(7)=Sound'XIIIsound.PNJ.SNDNot07'
     hSNDNotSound(8)=Sound'XIIIsound.PNJ.SNDNot08'
     hSNDNotSound(9)=Sound'XIIIsound.PNJ.SNDNot09'
     hSNDNotSound(10)=Sound'XIIIsound.PNJ.SNDNot10'
     hSNDNotSound(11)=Sound'XIIIsound.PNJ.SNDNot11'
     hSNDNotSound(12)=Sound'XIIIsound.PNJ.SNDNot12'
     hSNDNotSound(13)=Sound'XIIIsound.PNJ.SNDNot13'
     hSNDNotSound(14)=Sound'XIIIsound.PNJ.SNDNot14'
     hSwimmingSound=Sound'XIIIsound.XIIIPerso__XIIISwim.XIIISwim__hIsUnderWater'
     hNotifSwimSound=Sound'XIIIsound.PNJ__PNJSwim.PNJSwim__hPlongeur'
     hBubbleSound=Sound'XIIIsound.XIIIPerso__XIIISwim.XIIISwim__hBubbles'
     bRndAnimM16=True
     HeadShotFactor=3.000000
     bStasis=False
     bActorShadows=True
     CollisionHeight=75.000000
     Buoyancy=99.000000
}
