//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIBulletsAmmo extends XIIIAmmo
  abstract;

var bool bInfiniteAmmo;             // always set ammoamount to default after processtracehit

var float ShortRange;                 // Range at wich we do SRDamages (decreasing)
var float LongRange;                  // Range at wich we do LRDamages (decreasing)
var int SRDamages, LRDamages;         // ShortRange and LongRange damages
var class<BulletScorch> DecalProjectorClass;  // Visual Impact to leave on geometry
var BulletScorch DecalProjector;              // projector to update (to avoid spawn each time)

//_____________________________________________________________________________
// ELR Default
function PostBeginPlay()
{
    // Convert ShortRange & LongRange from Meters into Engine Units
    ShortRange = ShortRange * 200 / 2.54;
    LongRange = LongRange * 200 / 2.54;
    Super.PostBeginPlay();
//    log("@@"@self@"SR="$ShortRange@"LR="$LongRange);
}

//_____________________________________________________________________________
function ProcessTraceHitNoAmmo(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    if (AmmoAmount > 0)
    {
      AmmoAmount += 1;
      ProcessTraceHit(W, Other, HitLocation, HitNormal, X, Y, Z);
    }
}

//_____________________________________________________________________________
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    Local int ActualDamages;
    local int Loc;
    local bool bSpawnHeadBlood;
    local ImpactEmitter B;

//    Log("Processing TraceHit on "$Other);

    if (AmmoAmount > 0)
      AmmoAmount -= 1; // Fire
    else
      return; // EmptyShot.

    if ( bInfiniteAmmo )
      AmmoAmount = default.AmmoAmount;

    if ( Other == None )
      return;

    ActualDamages = min( SRDAmages, LRDamages - (LongRange - VSize(HitLocation - W.Location))*(LRDAmages - SRDamages) / (LongRange - ShortRange) );
//    log(self@"shot for"@ActualDamages@"range"@VSize(HitLocation - W.Location)); // ::DBUG::

    if ( ActualDamages <= 0)
      return;

    if ( Other.bWorldGeometry )
    {
      if ( ImpactEmitterMem != none )
      {
        // check that we don't spawn to far behind the player, it's useless
        if (
          ((W.bRapidFire || (Level.Game.DetailLevel < 2) ) && Level.bLonePlayer)
          && (vector(XIIIGameInfo(Level.Game).MapInfo.XIIIController.Rotation) dot (Hitlocation - XIIIGameInfo(Level.Game).MapInfo.XIIIController.Pawn.Location) < 0.0)
          && (vSize(Hitlocation - XIIIGameInfo(Level.Game).MapInfo.XIIIController.Pawn.Location) > 800.0)
          )
        {
          //Log("avoid spawning ImpactEmitterSFX as not seen & not really heard");
        }
        else
        {
          B = Spawn(ImpactEmitterMem,,, HitLocation+HitNormal, Rotator(HitNormal));
        }
        if (B != none)
        {
          B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
          if ( bPlayHitSound )
          {
            bPlayHitSound = false;
            B.PlaySound(HitSoundMem, HitSoundType);
          }
        }
      }
      if ( (DecalProjectorClass != None) && (!Other.bNoImpact) )
//        ClientSpawnDecal(HitLocation, X);
        SpawnDecal(HitLocation, HitNormal);
    }
    else if ( (Other != self) && (Other != Owner) )
    {
      if ( XIIIPawn(Other) != none )
      {
        Loc = XIIIPawn(Other).GetDamageLocation( HitLocation, Other.Location - Instigator.Location );
        if ( Loc <= 1 )
        {
          if ( !Pawn(Other).bIsDead )
            bSpawnHeadBlood = true;
          Other.TakeDamage(ActualDamages, Pawn(Owner), HitLocation, 30000.0*X, MyDamageType);
          if ( Pawn(Other)!=none )
          {
            if ( (Level.Game != none) && (Level.Game.GoreLevel == 0) )
            {
              B = Spawn(class'XIIIDamageType'.default.BloodShotEmitterClass,Other,, HitLocation+HitNormal, Rotator(-X));
              if ( bSpawnHeadBlood && Pawn(Other).bIsDead )
              {
                if ( XIIIPawn(Other).LastBoneHit == 'X Head' )
                  Spawn(class'ProjectileInHead',Other,,HitLocation, rotator(-HitNormal));
              }
            }
            else
              B = Spawn(class'BulletDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));

            if ( B != none )
              B.NoiseMake(XIIIPawn(Owner), SoftImpactNoise);
          }
        }
        else
        {
          if ( ImpactEmitterMem != none )
          {
            B = Spawn(ImpactEmitterMem,,, HitLocation+HitNormal, Rotator(HitNormal));
            if (B != none)
            {
              B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
              if ( bPlayHitSound )
              {
                bPlayHitSound = false;
                B.PlaySound(HitSoundMem, HitSoundType);
              }
            }
          }
        }
      }
      else
      {
        Other.TakeDamage(ActualDamages, Pawn(Owner), HitLocation, 30000.0*X, MyDamageType);
        if ( ImpactEmitterMem != none )
        {
          B = Spawn(ImpactEmitterMem,,, HitLocation+HitNormal, Rotator(HitNormal));
          if (B!=none)
          {
            B.NoiseMake(XIIIPawn(Owner), ImpactNoise);
            if ( bPlayHitSound )
            {
              bPlayHitSound = false;
              B.PlaySound(HitSoundMem, HitSoundType);
            }
          }
        }
        if ( (DecalProjectorClass != None) && (!Other.bNoImpact) )
  //        ClientSpawnDecal(HitLocation, X);
          SpawnDecal(HitLocation, HitNormal);
      }
    }
}

//_____________________________________________________________________________
function SpawnDecal(vector HL, vector HN)
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
function SetUpImpactEmitter(Sound S)
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

event Destroyed()
{
    Super.Destroyed();
    if ( DecalProjector != none )
      DecalProjector.Destroy();
}



defaultproperties
{
     DecalProjectorClass=Class'XIII.BulletScorch'
     bDrawTracingBullets=True
     ImpactNoise=0.500000
     SoftImpactNoise=0.100000
     TraceType=16384
     HitSoundType=0
     TBTexture=Texture'XIIIMenu.SFX.TraceBullet1'
     fTraceFrequency=0.333330
}
