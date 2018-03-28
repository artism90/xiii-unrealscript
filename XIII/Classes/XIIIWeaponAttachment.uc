class XIIIWeaponAttachment extends WeaponAttachment;

var bool bSpawnShells;
var bool bMuzzleRandRotation;
var bool bTrace;

var shells BulletShellFX;
var vector ShellEffectOffset;
var vector ShellFirstPersonOffset;
var int iBulletShellCount;
var float fShellDelay;
var class<Shells> ShellSFXEmitter;
var MuzzleFlashAttachment MuzzleFlash;
var class<MuzzleFlashAttachment> MuzzleClass;
var vector MuzzleOffset;
var rotator MuzzleRotationOffset;

var class<BulletTrail> TraceClass;    // Class of BulletTrace to spawn
var BulletTrail BT;                   // BulletTrail once spawned to handle update
var float TraceFrequency;             // Frequency of spawn for above class
var int TrailDist;                    // Trail distance to draw, for on-line

var class<Weapon> WeaponClass;  // to get default third person relatives on clients (w/out knowing real weapon)
var rotator WeaponThirdPersonRelativeRotation;

// To spawn impact SFX on clients ::
var class<BulletScorch> DecalProjectorClass;  // Visual Impact to leave on geometry
var BulletScorch DecalProjector;              // projector to update (to avoid spawn each time)
var class<ImpactEmitter> ImpactEmitterMem;    // Visual Impact SFX to run when impacting
var int ClientImpactNb;

//_____________________________________________________________________________
replication
{
    // Things the server should send to the client.
/*
    reliable if (Role==ROLE_Authority)
      MuzzleFlash;
*/
}

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    if ( DBOnline ) Log("WATTACH spawned "$self@"Instigator="$Instigator@"Owner="$Owner);

/*
    FlashCount = Pawn(Owner).FlashCount;
    AltFlashCount = Pawn(Owner).AltFlashCount;
    ReloadClientCount = Pawn(Owner).ReloadClientCount;
*/

    Super.PostBeginPlay();
    Instigator = Pawn(Owner);
}

//_____________________________________________________________________________
simulated function MuzzleAttach()
{
    local name BoneName;

    if ( DBOnline ) Log("WATTACH MuzzleAttach "$self@"Instigator.Weapon="$Instigator.Weapon);
    if ( Instigator == none )
      Instigator = Pawn(Owner);
    if ( (Instigator != None) && (MuzzleClass != None) )
    {
      MuzzleFlash = spawn(MuzzleClass,Instigator);
      BoneName = Instigator.GetWeaponBoneFor(Instigator.Weapon);
      if (BoneName == '')
      {
        Instigator.AttachTobone(MuzzleFlash, 'X R Hand');
//        MuzzleFlash.SetLocation(Instigator.Location);
//        MuzzleFlash.SetBase(Instigator);
      }
      else
        Instigator.AttachToBone(MuzzleFlash,BoneName);

      MuzzleFlash.SetRelativeRotation(MuzzleRotationOffset);
      MuzzleFlash.SetRelativeLocation(MuzzleOffset >> WeaponThirdPersonRelativeRotation);
      MuzzleFlash.bUseRandRotation = bMuzzleRandRotation;
    }
}

//_____________________________________________________________________________
simulated event Destroyed()
{
    if ( DBOnline ) Log("WATTACH destroyed"@self);

    if ( Instigator == none )
      Instigator = Pawn(Owner);
    Instigator.FlashCount = 0;
    Instigator.AltFlashCount = 0;
    Instigator.ReloadClientCount = 0;

    if ( BulletShellFX != None )
      BulletShellFX.Destroy();
    if ( MuzzleFlash != None )
      MuzzleFlash.Destroy();
    if( BT != none )
      BT.Destroy();
    if ( DecalProjector != none )
      DecalProjector.Destroy();
    Super.Destroyed();
}

//_____________________________________________________________________________
simulated event ThirdPersonEffects()
{
    local bool bSpawnShell;

    if ( DBOnline ) Log("WATTACH ThirdPersonEffects call for "$self@"FlashCount="$FlashCount);

    Super.ThirdPersonEffects();

    if ( MuzzleFlash == none )
      MuzzleAttach();
    if (MuzzleFlash != None)
    {
      if ( DBOnline ) Log("  FLASHING"@MuzzleFlash);
      MuzzleFlash.Flash();
    }

    if ( ((Level.NetMode == NM_Client) || (TraceFrequency*3 > fRand())) && (TraceClass != None) )
    {
      bTrace = true;
      SetTimer2(0.05, false);
    }

    if ( bSpawnShells )
    {
      if ( fShellDelay !=0.0 )
      {
        SetTimer( fShellDelay, false);
      }
      else
      {
        if ( BulletShellFX == None )
          BulletShellFX = Spawn(ShellSFXEmitter);

        iBulletShellCount ++;
//        log("iBulletShellCount="$iBulletShellCount$" iBulletShellCount%3="$(iBulletShellCount%3));
        if ( (Instigator != None) && !Instigator.bIsDead && (Instigator.Weapon != None) )
        {
          if ( ( Instigator.controller.bIsBot) || ( ( (Instigator.controller.bIsPlayer) && !XIIIPlayercontroller(Instigator.controller).bBehindView ) ))
          {
            bSpawnShell = true;
            if ( BulletShellFX.Owner != Instigator.Weapon )
            {
//              Log("First person view, spawning bullet from Owner="$Instigator.Weapon@"ShellFirstPersonOffset="$ShellFirstPersonOffset);
              BulletShellFX.SetOwner(Instigator.Weapon);
              BulletShellFX.Emitters[0].StartLocationOffset = ShellFirstPersonOffset;
            }
          }
          else if ( BulletShellFX.Owner != self )
          {
//            Log("not player or behindview, spawning bullet from Owner="$self@"ShellEffectOffset="$ShellEffectOffset);
            BulletShellFX.SetOwner(self);
            BulletShellFX.Emitters[0].StartLocationOffset = ShellEffectOffset;
          }
        }
        else if ( BulletShellFX.Owner != self )
        {
//          Log("instigator or weapon == none, spawning bullet from Owner="$self@"ShellEffectOffset="$ShellEffectOffset);
          BulletShellFX.SetOwner(self);
          BulletShellFX.Emitters[0].StartLocationOffset = ShellEffectOffset;
        }
        if ( bSpawnShell || (iBulletShellCount%3 == 0) )
          BulletShellFX.TriggerParticle();
      }
    }
}

//_____________________________________________________________________________
simulated event ThirdPersonAltEffects()
{
    if ( DBOnline ) Log("WATTACH ThirdPersonAltEffects call for "$self@"AltFlashCount="$AltFlashCount);
    Super.ThirdPersonAltEffects();
}

//_____________________________________________________________________________
simulated event ThirdPersonSwitchWeapon()
{
    if ( DBOnline ) Log("WATTACH ThirdPersonSwitchWeapon call for "$self);
    if ( XIIIPawn(Instigator) != None )
      XIIIPawn(Instigator).PlaySwitchingWeapon(1.0, FiringMode);
//      XIIIPawn(Instigator).PlaySwitchingWeapon(1.0,XIIIWeapon(Instigator.PendingWeapon).FiringMode);
}

//_____________________________________________________________________________
Simulated event Timer()
{
    local bool bSpawnShell;

    if ( BulletShellFX == None )
      BulletShellFX = Spawn(ShellSFXEmitter);

    iBulletShellCount ++;
//    log("iBulletShellCount="$iBulletShellCount$" iBulletShellCount%3="$(iBulletShellCount%3));
    if ( (Instigator != None) && !Instigator.bIsDead && (Instigator.Weapon != None) )
    {
      if ( Instigator.controller.bIsBot || (Instigator.controller.bIsPlayer && !XIIIPlayercontroller(Instigator.controller).bBehindView) )
      {
        bSpawnShell = true;
        if ( BulletShellFX.Owner != Instigator.Weapon )
        {
//            Log("First person view, spawning bullet from Owner="$Instigator.Weapon@"ShellFirstPersonOffset="$ShellFirstPersonOffset);
          BulletShellFX.SetOwner(Instigator.Weapon);
          BulletShellFX.Emitters[0].StartLocationOffset = ShellFirstPersonOffset;
        }
      }
      else if ( BulletShellFX.Owner != self )
      {
//          Log("not player or behindview, spawning bullet from Owner="$self@"ShellEffectOffset="$ShellEffectOffset);
        BulletShellFX.SetOwner(self);
        BulletShellFX.Emitters[0].StartLocationOffset = ShellEffectOffset;
      }
    }
    else if ( BulletShellFX.Owner != self )
    {
//        Log("instigator or weapon == none, spawning bullet from Owner="$self@"ShellEffectOffset="$ShellEffectOffset);
      BulletShellFX.SetOwner(self);
      BulletShellFX.Emitters[0].StartLocationOffset = ShellEffectOffset;
    }
    if ( bSpawnShell || (iBulletShellCount%3 == 0) )
      BulletShellFX.TriggerParticle();
}

//_____________________________________________________________________________
simulated event Timer2()
{
    Local Vector tV, tVRand;
    local float tF;

//    Log(self@"Timer2, bTrace="$bTrace);
    if ( bTrace )
    {
      if (BT == none)
      {
        BT = Spawn(TraceClass,self,,Location, Rotation);
        BT.Instigator = Instigator;
        BT.bOwnerNoSee = true;
        BT.ActorOffset = MuzzleOffset - (WeaponClass.default.ThirdPersonRelativeLocation << WeaponClass.default.ThirdPersonRelativeRotation);
        BT.Init();
      }
      if ( BT != none )
      {
        BT.Reset();
        BT.RibbonColor = BT.default.RibbonColor * fRand();
        BT.OutlineColor = BT.default.OutlineColor * fRand();
        BT.SetDrawType(DT_Trail);
        // Add sections to draw bullet traces
        if ( (Level.NetMode == NM_StandAlone) && (Instigator.Controller != none) && (Instigator.Controller.Enemy != none) && Instigator.Controller.Enemy.IsPlayerPawn() )
        { // Attempt to draw bullet traces in front of player
          tVRand = vRand() * 0.2;
          tVRand += vector(Instigator.Controller.Enemy.Controller.Rotation); // little offset vs view
          // 10% max offset from real trace going out from gun
          tF = vSize(BT.Location + vector(Rotation)*iBTrailDist) * 0.1;
          tVRand = normal(tVRand) * tF;
          BT.AddSection(BT.Location + vector(Rotation)*iBTrailDist + tVRand);
          BT.AddSection(BT.Location);
/*
          tVRand = vRand();
          tVRand.X *= 0.2;
          tVRand.Y *= 0.2;
          tV = Instigator.Controller.Enemy.Location + (vector(Instigator.Controller.Enemy.Controller.Rotation)+tVRand)*120;
          tV += vector(Rotation)*300;
          if ( vSize(tV) > iBTrailDist )
            tV = Normal(tV)*iBTrailDist;
          BT.AddSection(tV);
          BT.AddSection(BT.Location);
*/
        }
        else
        { // Std Bullet Traces
          if ( Level.NetMode == NM_Client )
          { // Client Spawn impactemitter for other pawns
            if ( !Instigator.IsLocallyControlled() )
              HandleClientImpact();
            else
              HandleLocalClientImpact();
          }
          else
            iBTrailDist = TrailDist;
          BT.AddSection(BT.Location + vector(Rotation)*iBTrailDist);
          BT.AddSection(BT.Location);
        }
      }
      bTrace = false;
      SetTimer2(0.5, true);
    }
    else
    { // bullet traces should be reseted often to avoid presence in lot of Leaves & crash the engine
      if ( BT != none )
      {
        BT.SetDrawType(DT_None);
        BT.Reset();
      }
      SetTimer2(1.0+fRand(), true);
    }
}

//_____________________________________________________________________________
// we don't want to replicate emitter/decal spawns so make it local
Simulated function HandleClientImpact()
{
    Local Actor A;
    local vector HitLoc, HitNorm;
    local material HitMat;

    A = Trace(HitLoc, HitNorm, BT.Location + vector(Rotation)*TrailDist, BT.Location, true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);
//    Log(" "$self@"HandleClientImpact Dist="$TrailDist@"A="$A@"HitMat="$HitMat);
    if ( (A != none) && (HitMat != none) && (HitMat.HitSound != none) )
    {
      iBTrailDist = vSize(HitLoc - BT.Location);
      SetUpImpactEmitter(HitMat.HitSound);
//      Log("  DecalClass="$DecalProjectorClass@"ImpactClass="$ImpactEmitterMem);
      SpawnDecal(HitLoc, HitNorm);
      if ( ImpactEmitterMem != none )
        Spawn(ImpactEmitterMem,,, HitLoc+HitNorm, Rotator(HitNorm));
    }
    else if ( Pawn(A) != none )
    {
      iBTrailDist = vSize(HitLoc - BT.Location);
      Spawn(class'BloodShotEmitter',,, HitLoc+HitNorm, Rotator(HitNorm));
    }
    else
      iBTrailDist = TrailDist;
}

//_____________________________________________________________________________
// we don't want to replicate emitter/decal spawns so make it local
Simulated function HandleLocalClientImpact()
{
    Local Actor A;
    local vector HitLoc, HitNorm;
    local material HitMat;
    local int i;

    // locally controled, use controller rotation to have accurate loc.
    for ( i = 0; i < ClientImpactNb; i++)
    {
      A = Trace(HitLoc, HitNorm, Instigator.Location + Instigator.EyePosition() + (vector(Instigator.Controller.Rotation) * 100.0 + vRand()*Instigator.Weapon.TraceAccuracy) * TrailDist/100.0, Instigator.Location + Instigator.EyePosition(), true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);
  //    Log(" "$self@"HandleLocalClientImpact Dist="$TrailDist@"A="$A@"HitMat="$HitMat);
      if ( (A != none) && (HitMat != none) && (HitMat.HitSound != none) )
      {
        iBTrailDist = vSize(HitLoc - ( Instigator.Location + Instigator.EyePosition()));
        SetUpImpactEmitter(HitMat.HitSound);
  //      Log("  DecalClass="$DecalProjectorClass@"ImpactClass="$ImpactEmitterMem);
        SpawnDecal(HitLoc, HitNorm);
        if ( ImpactEmitterMem != none )
          Spawn(ImpactEmitterMem,,, HitLoc+HitNorm, Rotator(HitNorm));
      }
      else if ( Pawn(A) != none )
      {
        iBTrailDist = vSize(HitLoc - ( Instigator.Location + Instigator.EyePosition()));
        Spawn(class'BloodShotEmitter',,, HitLoc+HitNorm, Rotator(HitNorm));
      }
      else
        iBTrailDist = TrailDist;
    }
}

//_____________________________________________________________________________
simulated function SpawnDecal(vector HL, vector HN)
{
    if ( (DecalProjector == none) && (DecalProjectorClass != none) )
    {
      DecalProjector = Spawn(DecalProjectorClass,Owner,,HL + HN, rotator(-HN));
    }
    else if (DecalProjector != none)
    {
      DecalProjector.SetLocation( HL+HN );
      DecalProjector.SetRotation( rotator(-HN) );
      DecalProjector.UpdateScorch();
    }
}

//_____________________________________________________________________________
simulated function SetUpImpactEmitter(Sound S)
{
    local string Str;
    local int i;

    // First get rid of the beginning of the sound name just to keep whet is needed
    Str = string(S);
    i = InStr(S, 'hPlay');
    Str = Right(Str, Len(Str) - i - 5);
//    Log("SetUpImpactEmitter Bullet --'"$Str$"'--");

    // Then switch/case the result to setup the SFX class
    switch (Str)
    {
      case "ImpBtE":
      case "ImpBtI":
      case "ImpCar":
      case "ImpMar":
      case "ImpTil":
      case "ImpPie":
        // Concrete type

        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorch') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGra":
        // Gravel type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorch') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'GravelDustEmitter';
        break;
      case "ImpBoiC":
      case "ImpBoiP":
      case "ImpPar":
      case "ImpFeu":
        // Wood type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorchWood') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorchWood';
        ImpactEmitterMem = class'WoodDustEmitter';
        break;
      case "ImpEau":
        // Water type (should not happen but maybe....)
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorch') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGla":
      case "ImpVer":
        // Glass type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorchGlass') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorchGlass';
        ImpactEmitterMem = class'GlassImpactEmitter';
        break;
      case "ImpGri":
      case "ImpMet":
      case "ImpTol":
        // Metal type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorchMetal') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorchMetal';
        ImpactEmitterMem = class'BulletMetalEmitter';
        break;
      case "ImpHrb":
        // Grass Type
        if ( DecalProjector != none )
          DecalProjector.LifeSpan = 2.0+fRand();
        DecalProjector = none;
        DecalProjectorClass = none;
        ImpactEmitterMem = class'GrassDustEmitter';
        break;
      case "ImpTer":
        // Earth type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorch') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'EarthDustEmitter';
        break;
      case "ImpNei":
        // Snow
        if ( DecalProjector != none )
          DecalProjector.LifeSpan = 2.0+fRand();
        DecalProjector = none;
        DecalProjectorClass = none;
        ImpactEmitterMem = class'SnowDustEmitter';
        break;
      case "ImpMol":
      case "ImpMoq":
        // Soft Types
        if ( DecalProjector != none )
          DecalProjector.LifeSpan = 2.0+fRand();
        DecalProjector = none;
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'MoqDustEmitter';
        break;
      case "ImpCdvr":
        // Body Type
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorchMetal') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorchMetal';
        ImpactEmitterMem = class'BloodShotEmitter';
        break;
      case "ImpLin":
      default:
        // other types, not spawn any SFX
        if ( (DecalProjector != none) && (DecalProjector.Class != Class'XIII.BulletScorch') )
        {
          DecalProjector.LifeSpan = 2.0+fRand();
          DecalProjector = none;
        }
        DecalProjectorClass = Class'XIII.BulletScorch';
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
    }
}




defaultproperties
{
     bMuzzleRandRotation=True
     ShellSFXEmitter=Class'XIII.Shells'
     TraceFrequency=0.330000
     TrailDist=3000
     ClientImpactNb=1
     FiringMode="FM_2H"
     AltFiringMode="FM_Fists"
}
