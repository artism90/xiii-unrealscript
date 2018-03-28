//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIProjectile extends Projectile;

var bool bSpawnDecal;         // if true spawn ExplosionDecal else spawn VisualImpact
var bool bHaveBlownUp;
var bool bSplashed;

enum DamageLocations
{
    LOC_Head,
    LOC_Body,
    LOC_HeadSide,
};

var float ImpactNoise;        // Noise made by the Projectile when hitting something
var float SoftImpactNoise;    // Noise made by the Projectile when hitting someone
var int HitSoundType;         // Type of sound vs type of impact
// 0 = bullet
// 1 = Fists
// 2 = CommandoKnife UNUSED
// 3 = Bolt/Harpon
// 4 = Grenade bounce
// 5 = TKnife
var class<Effects> aVisualImpact;
var sound hExploSound;
var class<ProjectileInHead> InHeadClass;
var class<Trail> MyTrailClass;
var Trail MyTrail;            // Should be spawned & init() in child classes (because spec inits needed).
var class<ImpactEmitter> ImpactEmitterMem;
var string StaticMeshName;    // to dynamicload it

var float ShakeMag;           // used for shakes on blowup
var float ShakeTime;
var vector ShakeVert;
var vector ShakeSpeed;
var float ShakeCycles;
var vector OrgFrom;
var vector vWaterEntry;       // Memorize water entry to (maybe) spawn water surface explosion

var config class<Emitter> ExplosionEmitterClass;

var int iStunning;            // projectile stun if HeadShot, no damage else (not bool because bool don't work as function params on GC)

CONST DBProj=false;

//_____________________________________________________________________________
Static function StaticParseDynamicLoading(LevelInfo MyLI)
{
    Log("XIIIProjectile StaticParseDynamicLoading class="$default.class);
    if ( default.StaticMeshName != "" )
      MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] =
        StaticMesh(DynamicLoadObject(default.StaticMeshName, class'StaticMesh'));
}

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( (StaticMesh == none) && (StaticMeshName != "") )
    {
      StaticMesh = StaticMesh(dynamicloadobject(StaticMeshName, class'StaticMesh'));
      default.StaticMesh = StaticMesh;
      SetDrawType(DT_StaticMesh);
//      Log("PostBeginPlay DYNAMICLOAD StaticMesh "$StaticMeshName@"result "$StaticMesh);
    }
    vWaterEntry = Location;
    OrgFrom = Location;
    if ( (Instigator != none) && (Instigator.Base != none) && (Instigator.Base.Velocity != vect(0,0,0)) )
      SetBase(Instigator.Base);
}

//_____________________________________________________________________________
event Timer2()
{ // FIXME cheat to make complex staticmesh movers (like elevators) work
    Touching.Length = 0;
}

//_____________________________________________________________________________
// Touching
simulated singular function Touch(Actor Other)
{
    local actor HitActor;
    local vector HitLocation, HitNormal, VelDir;
    local bool bBeyondOther;
    local float BackDist, DirZ;
    local material HitMat;
    local staticMeshActor SMA;
    local VehicleDeco VHD;
    local Mover Mov;
    local int i;

    if ( Other == Instigator )
      return;
    if ( DBProj ) Log("PROJ"@self@"Touched "$Other);
    if ( Velocity == vect(0,0,0) )
    {
      if ( DBProj ) Log("  Touched cancelled because null velocity");
      return;
    }

    if ( StaticMeshActor(Other) != none )
    { // touching a staticmeshactor that is not bWorldGeometry, Get exact hit location
      if ( DBProj ) Log("  Is StaticMeshActor");
      SetTimer2(0.02, false); // to clean touching list later;
      foreach TraceActors(class'StaticMeshActor', SMA, HitLocation, HitNormal, Location + Velocity*0.1, Location - Velocity*0.1, vect(0,0,0), TRACETYPE_DiscardIfCanShootThroughWithProjectileWeapon)
      {
        if (SMA == Other)
        {
          SetLocation(HitLocation);
//          Log("--> proj Other="$other$" HitActor="$SMA$" Location="$Location@"hitLocation="$HitLocation);
          HitWall(HitNormal, Other);
          return;
        }
      }
      HitWall(-vector(rotation), other);
      // Remove other from touching list ::TODO:: Hum Hum check if this is not too dirty & may cause crash for a reason or another
      return;
    }
    else if ( VehicleDeco(Other) != none )
    { // touching a staticmeshactor that is not bWorldGeometry, Get exact hit location
      if ( DBProj ) Log("  Is VehicleDeco");
      SetTimer2(0.02, false); // to clean touching list later;
      foreach TraceActors(class'VehicleDeco', VHD, HitLocation, HitNormal, Location + Velocity*0.1, Location - Velocity*0.1, vect(0,0,0), TRACETYPE_DiscardIfCanShootThroughWithProjectileWeapon)
      {
        if (VHD == Other)
        {
          SetLocation(HitLocation);
//          Log("--> proj Other="$other$" HitActor="$VHD$" Location="$Location@"hitLocation="$HitLocation@"Normal="@HitNormal);
          HitWall(HitNormal, Other);
          return;
        }
      }
      HitWall(-vector(rotation), other);
      // Remove other from touching list ::TODO:: Hum Hum check if this is not too dirty & may cause crash for a reason or another
      return;
    }
    else if ( Mover(Other) != none )
    {
      if ( DBProj ) Log("  Is Mover");
      SetTimer2(0.02, false); // to clean touching list later;
      foreach TraceActors(class'Mover', Mov, HitLocation, HitNormal, Location + Velocity*0.1, Location - Velocity*0.1, vect(0,0,0), TRACETYPE_DiscardIfCanShootThroughWithProjectileWeapon)
      {
        if ( (Mov == Other) && (HitNormal dot Velocity < 0.0) )
        {
//          Log("--> proj Other="$other$" HitActor="$SMA$" Location="$Location@"hitLocation="$HitLocation);
          SetLocation(HitLocation + HitNormal*2.0);
          HitWall(HitNormal, Other);
          return;
        }
      }
      HitWall(-vector(rotation), other);
      // Remove other from touching list ::TODO:: Hum Hum check if this is not too dirty & may cause crash for a reason or another
      return;
    }

    if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
    {
      if ( Velocity == vect(0,0,0) )
      {
        ProcessTouch(Other,Location);
        return;
      }

      //get exact hitlocation - trace back along velocity vector
      bBeyondOther = ( (Velocity dot (Location - Other.Location)) > 0 );
//      Log("--> proj bBeyondOther="$bBeyondOther);
      VelDir = Normal(Velocity);
      DirZ = sqrt(abs(VelDir.Z));
//      Log("-->  Other="$other@"ColRad="$Other.CollisionRadius@"ColHei="$Other.CollisionHeight@"VelDir="$VelDir@"DirZ="$DirZ);
      BackDist = Other.CollisionRadius * (1 - DirZ) + Other.CollisionHeight * DirZ;
//      Log("-->  1rst BackDist="$BackDist);


      if ( bBeyondOther )
        BackDist += VSize(Location - Other.Location);
      else
        BackDist -= VSize(Location - Other.Location);
//      Log("-->  2nd BackDist="$BackDist);

      HitActor = Trace(HitLocation, HitNormal, Location, Location - 1.1 * BackDist * VelDir, true, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithProjectileWeapon);
//      Log("--> proj HitActor="$HitActor$" Location="$Location@"hitLocation="$HitLocation@"BackDist="$BackDist);
      if (HitActor == Other)
        ProcessTouch(Other, HitLocation);
      else if ( bBeyondOther )
// ELR It seem like this code mess up the hitLocation if bBeyondOther=true (as we do have localized damages)
//        ProcessTouch(Other, Other.Location - Other.CollisionRadius * VelDir);
        ProcessTouch(Other, Location - 2.0 * Other.CollisionRadius * VelDir);
      else
        ProcessTouch(Other, Location);
    }
}

//_____________________________________________________________________________
// Override ProcessTouch
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local int Loc;
    Local bool bSpawnHeadProj;
    local ProjectileInHead PIH;

    if ( DBProj ) Log("PROJ"@self@"ProcessTouch"@other@"iStunning="$iStunning);
    if ( Other != Instigator )
    {
      if ( XIIIPawn(Other) != none )
      {
        if ( Velocity != vect(0,0,0) )
          Loc = GetPotentialDamageLocation( XIIIPawn(Other), HitLocation, Velocity);
        else
          Loc = GetPotentialDamageLocation( XIIIPawn(Other), HitLocation, vector(rotation) );
      }
//      Log("  >"@self@"ProcessTouch LOC="@Loc);
      if ( iStunning > 0 )
      {
        if ( Loc == 1 )
        {
//          Log("  >"@self@" No damages, Body hit");
          Explode(HitLocation,Normal(HitLocation-Other.Location));
          if ( Pawn(Other) != none )
            MakeNoise(SoftImpactNoise);
          else
            MakeNoise(ImpactNoise);
          return;
        }
//        else
//          Log("  >"@self@" Damages, Head hit");
      }
      if ( DBProj ) Log("  > "$self$" ProcessTouch other="$other$" Loc="$Loc$" HitLocation="$HitLocation);
      if ( Loc <= 1 )
      {
        if ( (Pawn(Other) != none) &&  !Pawn(Other).bIsDead )
          bSpawnHeadProj = true; // Only spawn once & at first time
        Other.TakeDamage(Damage, Instigator, HitLocation, -MomentumTransfer * normal(velocity), MyDamageType);
        Explode(HitLocation,Normal(HitLocation-Other.Location));
        if ( (Pawn(Other) != none) && (Level.Game != none) && (Level.Game.GoreLevel == 0) )
        {
          if ( (Loc == 0) && bSpawnHeadProj && Pawn(Other).bIsDead && (InHeadClass != none) )
          {
            PIH = Spawn(InHeadClass,Other,,HitLocation, Rotation);
            PIH.StaticMesh = StaticMesh;
          }
          Spawn(class'XIIIDamageType'.default.BloodShotEmitterClass,,, HitLocation, Rotator(normal(HitLocation-Other.Location)));
        }
        if ( Pawn(Other) != none )
          MakeNoise(SoftImpactNoise);
        else
          MakeNoise(ImpactNoise);
      }
      // else do nothing, keep the projectile going
    }
}

//_____________________________________________________________________________
// ELR CheckDamageLocation, used by projectiles
function DamageLocations GetPotentialDamageLocation( XIIIPawn P, vector HitLoc , vector HitDir)
{
    // Inspired from DX (Thanx to the scripter that gave the offset formula to a newB:)
    local Vector offset, HitLoc2, HitNorm2, StartTrace, EndTrace;
    local float headOffsetZ;
    local Actor A;
    local material HitMat;

    if ( P.bIsDead ) return LOC_Body;
    P.LastBoneHit='';

    // Use the hitlocation to determine where the pawn is hit
    // Transform the worldspace hitlocation into objectspace
    // In objectspace, X is front to back Y is side to side, and Z is top to bottom
    offset = (HitLoc - P.Location) << P.Rotation;
    headOffsetZ = P.CollisionHeight * 0.65;

    if ( (iStunning > 0) || (P.IsPlayerPawn() && Level.bLonePlayer) )
    { // ELR Cheat to optimize (no call to foreach trace) when several enemies
      //  are shooting the player in solo game
//      Log("GetPotentialDamageLocation Offset="$Offset.z / P.CollisionHeight);
      if ( Offset.Z > P.CollisionHeight * 0.7 )
        return LOC_Head;
      else
        return LOC_Body;
    }

    StartTrace = HitLoc - normal(HitDir)*P.CollisionRadius*2.0;
    EndTrace = HitLoc + normal(HitDir)*P.CollisionRadius*2.0;
//    Log("P.Location="$P.Location@"HitLoc="$HitLoc@"HitDir="$HitDir@"StartTRace="$StartTrace@"EndTrace="$EndTrace);
    foreach TraceActors(class'Actor', A, HitLoc2, HitNorm2, EndTrace, StartTrace, vect(0,0,0), TRACETYPE_RequestBones)
    {
//      Log(P@"testing actor "$A);
      if ( A == P )
      {
/*
        StartTrace = HitLoc - normal(HitDir)*P.CollisionRadius*2.0;
        EndTrace = HitLoc + normal(HitDir)*P.CollisionRadius*2.0;
        A = Trace(HitLoc2, HitNorm2, HitLoc2 - HitNorm2*P.CollisionRadius*2, HitLoc2 + HitNorm2, True, vect(0,0,0), HitMat, TRACETYPE_RequestBones);
*/
        P.LastBoneHit = GetLastTraceBone();
//        Log(">>> Potential Bone ="$P.LastBoneHit);
        if ( P.LastBoneHit == 'X Head' )
          return LOC_Head;
      }
    }

    if ( Offset.Z > HeadOffsetZ )
      return LOC_HeadSide;
    else
      return LOC_Body;
}

//_____________________________________________________________________________
function SetImpactNoise(float IN1, float IN2)
{
    SoftImpactNoise = IN1;
    ImpactNoise = IN2;
}

//_____________________________________________________________________________
simulated function BlowUp(vector HitLocation)
{
    local XIIIPlayerPawn Victims;
    local vector HitLoc;

    if ( bHaveBlownUp )
      return;

    bHaveBlownUp=true;
//    Log(self$" blowing up w/ MomentumTransfer="$MomentumTransfer);

    if ( Instigator == none )
      Instigator = Pawn(Owner);

    HurtRadius(Damage,DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    if ( ShakeTime != 0 )
    {
    	foreach RadiusActors( class 'XIIIPlayerPawn', Victims, DamageRadius*0.5, HitLoc )
    	{
        PlayerController(Victims.Controller).ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, ShakeCycles);
    	}
    }

    if ( Role == ROLE_Authority )
      MakeNoise(ImpactNoise);
    PlaySound(hExploSound,0,1,2);
}

//_____________________________________________________________________________
simulated function HitWall(vector HitNormal, actor Wall)
{
    if ( DBProj ) Log("PROJ"@self@"HitWall"@Wall@"Normal="$HitNormal);

    if ( Role == ROLE_Authority )
    {
      if ( Mover(Wall) != None )
        Wall.TakeDamage( Damage, instigator, Location, MomentumTransfer * Normal(Velocity), MyDamageType);
      MakeNoise(ImpactNoise);
    }
//    PlayImpactSound(HitNormal, Wall);
    PlayImpactSound(-vector(rotation), Wall);

    Explode(Location + ExploWallOut * HitNormal, HitNormal);

    if ( (Mover(Wall) == None) && !Wall.bMovable )
    {
      if ( bSpawnDecal && (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
        Spawn(ExplosionDecal,self,,Location, rotator(-HitNormal));
      else if ( !bSpawnDecal && (aVisualImpact != None) && (Level.NetMode != NM_DedicatedServer) )
        Spawn(aVisualImpact,self,,Location+0.1*HitNormal, rotator( (vector(rotation)*2.0-HitNormal)/3.0 ));
    }
}

//_____________________________________________________________________________
simulated function PlayImpactSound(vector Normal, actor Wall)
{
    local Material M;
    local actor A;
    local vector HitLoc, HitNorm;
    local ImpactEmitter B;

    if ( Level.NetMode == NM_DedicatedServer )
      return;

    A = Trace(HitLoc, HitNorm, Location - Normal*10, Location + Normal*10, true, vect(0,0,0), M);

    if ( DBProj ) Log("PlayImpactSound A="$A@"M="$M);
    if ( Wall.bWorldGeometry || (Mover(Wall) != none) || (StaticMeshActor(Wall) != none) || (VehicleDeco(Wall) != none))
    {
      if ( (M != none) && (M.HitSound != none) )
        SetUpImpactEmitter(M.HitSound);
      if ( ImpactEmitterMem != none )
      {
        B = Spawn(ImpactEmitterMem,,, HitLoc+HitNorm, Rotator(HitNorm));
        if ( (B != none) && (HitSoundType >= 0) )
        {
          if ( (M != none) && (M.HitSound != none) )
            B.PlaySound(M.HitSound, HitSoundType);
        }
      }
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
//    Log("--'"$Str$"'--");

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
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGra":
        // Gravel type
        ImpactEmitterMem = class'GravelDustEmitter';
        break;
      case "ImpBoiC":
      case "ImpBoiP":
      case "ImpPar":
      case "ImpFeu":
        // Wood type
        ImpactEmitterMem = class'WoodDustEmitter';
        break;
      case "ImpEau":
        // Water type (should not happen but maybe....)
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGla":
      case "ImpVer":
        // Glass type
        ImpactEmitterMem = class'GlassImpactEmitter';
        break;
      case "ImpGri":
      case "ImpMet":
      case "ImpTol":
        // Metal type
        ImpactEmitterMem = class'BulletMetalEmitter';
        break;
      case "ImpHrb":
        // Grass Type
        ImpactEmitterMem = class'GrassDustEmitter';
        break;
      case "ImpTer":
        // Earth type
        ImpactEmitterMem = class'EarthDustEmitter';
        break;
      case "ImpNei":
        // Snow Type
        ImpactEmitterMem = class'SnowDustEmitter';
        break;
      case "ImpMol":
      case "ImpMoq":
        // Soft Types
        ImpactEmitterMem = class'MoqDustEmitter';
        break;
      case "ImpCdvr":
        ImpactEmitterMem = class'BloodShotEmitter';
        break;
      case "ImpLin":
      default:
        // other types, not spawn any SFX
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
    }
/*
handler hPlayImpBtE (int iWhichAmmo)	Béton exterieur
handler hPlayImpBtI (int iWhichAmmo)	Béton interieur
handler hPlayImpBoiC (int iWhichAmmo)	Bois Creux
handler hPlayImpBoiP (int iWhichAmmo)	Bois plein
handler hPlayImpCar (int iWhichAmmo)	Carrelage
handler hPlayImpEau (int iWhichAmmo)	Eau
handler hPlayImpFeu (int iWhichAmmo)	Feuilles
handler hPlayImpFlesh (int iWhichAmmo)	Chair
handler hPlayImpGla (int iWhichAmmo)	Glace
handler hPlayImpGra (int iWhichAmmo)	Gravier
handler hPlayImpGri (int iWhichAmmo)	Grille
handler hPlayImpHrb (int iWhichAmmo)	Herbe
handler hPlayImpLin (int iWhichAmmo)	Lino
handler hPlayImpMar (int iWhichAmmo)	Marbre
handler hPlayImpMet (int iWhichAmmo)	Métal
handler hPlayImpMol (int iWhichAmmo)	diverses textures molles: matelas; fauteuille; liège.
handler hPlayImpMoq (int iWhichAmmo)	Moquette
handler hPlayImpNei (int iWhichAmmo)	Neige
handler hPlayImpPar (int iWhichAmmo)	Parquet
handler hPlayImpPie (int iWhichAmmo)	Pierre
handler hPlayImpTer (int iWhichAmmo)	Terre
handler hPlayImpTol (int iWhichAmmo)	Tôle
handler hPlayImpTil (int iWhichAmmo)	Tuile
handler hPlayImpVer (int iWhichAmmo)	Verre*/
}

//_____________________________________________________________________________
simulated event Destroyed()
{
    if ( DBProj ) Log("PROJ"@self@"Destroyed ");
    if ( MyTrail != none )
      MyTrail.Destroy();
    Super.Destroyed();
}

//_____________________________________________________________________________
function bool CanSplash()
{
  if ( !bSplashed )
  {
    bSplashed = true;
  	return true;
  }
}

//_____________________________________________________________________________
event PhysicsVolumeChange( PhysicsVolume NewVolume )
{
//    Log("PhysicsVolumeChange");
    // no super so don't call
    if ( NewVolume.bWaterVolume )
      vWaterEntry = Location;
}

//_____________________________________________________________________________
// Generic water surface explosion SFX
simulated function SpawnWaterExplo(vector HitLocation)
{
    local vector HitLoc, HitNorm;
    local vector StartTrace;
    local actor other;
    Local Material HitMat;

    StartTrace = (HitLocation + vWaterEntry)/2.0;
    StartTrace.z = vWaterEntry.z + 10;
    Other = Trace(HitLoc, HitNorm, (HitLocation + vWaterEntry)/2.0, StartTrace, false, vect(0,0,0), HitMat, 0x008);
    if ( Other.IsA('Watervolume') )
      PhysicsVolume(Other).BeingHitByProjectile(HitLoc);
}



defaultproperties
{
     bSpawnDecal=True
     HitSoundType=-1
     hExploSound=Sound'XIIIsound.Explo__ExploGren.ExploGren__hExploGren'
     bUnlit=False
     SaturationDistance=100.000000
     StabilisationDistance=794.000000
}
