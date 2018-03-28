//-----------------------------------------------------------
//
//-----------------------------------------------------------
class GrenadFlying extends XIIIProjectile;

var bool bCanHitOwner, bHitWater;
var bool bArmed;
var bool bRecordedByGenAlerte; //recorded in order tobe detected by a basesoldier
var float Count, SmokeRate;
var int NumExtraGrenades;
var float fLifeTime;                // duration before explosion
// SouthEnd XBOX specific use
var vector vLastWallHit;
var bool bLastWallHit;
var bool bPreExplode;
var float fPreExplodeTime;
var bool bExploded;
// SouthEnd XBOX END

replication
{
    Reliable if ( Role == ROLE_Authority )
      fLifeTime;
}

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    local vector X,Y,Z;
    local rotator RandRot;

    Super.PostBeginPlay();
    bArmed=false;
    fLifeTime = 3.0;        // Set this just in case it will be thrown by no player thus intialized after postbeginplay
    SetTimer(0.1,false);    // Call it again later with the right intialized lifetime

    if ( Role == ROLE_Authority )
    {
      GetAxes(Instigator.GetViewRotation(),X,Y,Z);
      Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * (Speed + FRand() * 100);
      Velocity.z += 210;
      MaxSpeed = 1000;
      RandSpin(50000);
      bCanHitOwner = False;
      if (Instigator.HeadVolume.bWaterVolume)
      {
        bHitWater = True;
        Disable('Tick');
        Velocity=0.6*Velocity;
      }
    }
    //FRD   appel GenAlerte pour gestion grenade
    if (level.bLonePlayer && instigator.controller!=none && instigator.controller.bIsPlayer)
    {
      XIIIGameInfo(level.game).genalerte.trigger(self, instigator);
      bRecordedByGenAlerte = true;
    }

    if ( (Instigator != none) && (Instigator.Base.Velocity == vect(0,0,0)) )
    {
      MyTrail = Spawn(MyTrailClass,self,,Location);
      MyTrail.Init();
    }
}

//_____________________________________________________________________________
simulated function BeginPlay()
{
    SmokeRate = 0.15;
}

//_____________________________________________________________________________
function SetPreExplosion(float time)
{
  if ( (Level.Game != none) && (Level.Game.DetailLevel < 2) )
    return;
  if ( !Level.bLonePlayer )
    return;
  fPreExplodeTime = time;
  bPreExplode = true;
}

//_____________________________________________________________________________
simulated function Timer()
{
    if ( !bArmed )
    { // set the timer back one the fLifeTime has been initialized by the weapon
      bArmed=true;
      fLifeTime = fMax(0.05, fLifeTime);
      if (bPreExplode) //SOUTHEND Set a timer to PreExplode (a call just before the explosion occurs)
        SetTimer(fPreExplodeTime, false);
      else
        SetTimer(fLifeTime, false);
      return;
    }

    //SOUTHEND
    // Check if we this is the call to PreExplode before the actual explosion
    if ( bPreExplode )
    {
      bPreExplode = false;
      SetTimer(fLifeTime-fPreExplodeTime, false);
      PreExplode();
      return;
    }

    if ( bSpawnDecal )
    {
      if ( (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
        Spawn(ExplosionDecal,self,,Location, rotator(vect(0,0,-1)));
      Destroy();
    }
    else
    {
      Explosion(Location+Vect(0,0,1)*16);
      bSpawnDecal = true;
      SetTimer(0.2, false);
    }
}

//_____________________________________________________________________________
simulated function Landed( vector HitNormal )
{
//    Log("GRENAD Landed Base="$Base);
    HitWall( HitNormal, Base );
}

//_____________________________________________________________________________
simulated function ProcessTouch( actor Other, vector HitLocation )
{
    Local vector vt;

    if ( Pawn(Other) != none )
    {
      vT = Location - Other.Location;
      if ( VT.Z > Other.CollisionRadius * 0.9 )
      {
//        Log("GRENAD should bounce off pawn"@other@"head");
        vt = HitLocation - Other.Location;
        vT.Z = 0;
        Velocity = 0.3*Speed*(normal(vT) + vect(0,0,1));
//        Velocity = normal(vT)*vSize(Velocity);
        Speed = vSize(Velocity);
//        HitWall( normal(normal(vt) + vect(0,0,1)), Other );
        return;
      }
//      else
//        Log("GRENAD Hit pawn side, std bounce");
    }
    if ( (Other != instigator) || bCanHitOwner )
    {
      Velocity = 0.2*Velocity;
      vt = HitLocation - Other.Location;
      HitWall( normal(vt), None );
    }
}

//_____________________________________________________________________________
simulated function HitWall( vector HitNormal, actor Wall )
{
    Local vector vt;

    MakeNoise(ImpactNoise);
    if ( MyTrail != none )
      MyTrail.RotationSpeed *= 2.0;
//    Log("GRENAD HitWall"@Wall);

    if ( (Wall != none) && (Pawn(Wall) != none) )
    {
      vT = Location - Wall.Location;
      if ( VT.Z > Wall.CollisionRadius * 0.9 )
      {
//        Log("GRENAD should bounce off pawn"@Wall@"head");
        vt = Location - Wall.Location;
        vT.Z = 0;
        Velocity = 0.3*Speed*(normal(vT) + vect(0,0,1));
//        Velocity = normal(vT)*vSize(Velocity);
        Speed = vSize(Velocity);
//        HitWall( normal(normal(vt) + vect(0,0,1)), Other );
        return;
      }
//      else
//        Log("GRENAD Hit pawn side, std bounce");
    }

    if (Wall != none)
    {
      PlayImpactSound(-normal(velocity), Wall);
      if ( (Level.NetMode == NM_StandAlone) && level.bLonePlayer && !bRecordedByGenAlerte ) //grenad launched by a basesoldier
      {
        XIIIGameInfo(level.game).genalerte.trigger(self, instigator);
        bRecordedByGenAlerte = true;
      }
    }
    bCanHitOwner = True;
    Velocity = 0.25*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);
    if ( Velocity.Z > 400 )
      Velocity.Z = 0.5 * (400 + Velocity.Z);
    else if ( (speed < 10) && (Wall != none) ) // don't stop of touching and not hitting real wall.
    {
      bBounce = False;
      SetPhysics(PHYS_None);
    }

    if (!bExploded && abs(HitNormal dot Vect(0,0,1))<0.5)
    {
      vLastWallHit = location + 0.25*HitNormal*200.0/2.54;
      bLastWallHit = true;
    }
//    Log("      NEW Velocity="$Velocity);
}

//_____________________________________________________________________________
function PreExplode()
{
  //SOUTHEND
  // Added this code to generate a CWndExplosion when a grenade thrown by a
  // human player explodes and he cannot see it.
  local CWndExplosion CWnd;
  local vector aim;
  if (instigator != none && XIIIPlayerController(instigator.Controller) != none
   && XIIIPlayerController(instigator.Controller).multiViewport==none
   && XIIIPlayerController(instigator.Controller).fCamViewPercent==0.0)
  {
    aim = XIIIPlayerController(instigator.controller).OldAdjustAim;
    if ((aim dot normal(location-instigator.location) < 0.707) || !instigator.controller.LineOfSightTo(self))
    {
      CWnd = Spawn(class'XIII.CWndExplosion',self);
      if ( CWnd != none )
      {
        CWnd.Explosion = self;
        if (bLastWallHit && VSize(vLastWallHit-location)>1.5*200.0/2.54)
        {
          CWnd.CamPos = vLastWallHit + normal(location-vLastWallHit)*0.5*200.0/2.54;
        }
        else
        {
          CWnd.CamPos = OrgFrom + vect(0,0,30);
        }
        CWnd.MyHudForFX = XIIIBaseHUD(XIIIPlayerController(Pawn(Owner).Controller).MyHud);
        CWnd.Timer();
      }
    }
  }
}

//_____________________________________________________________________________
simulated function Explosion(vector HitLocation)
{
    bExploded = true;

    //FRD   appel GenAlerte pour gestion grenade
    if (level.bLonePlayer) XIIIGameInfo(level.game).genalerte.untrigger(self,instigator);

    BlowUp(HitLocation);
    if ( Level.NetMode != NM_DedicatedServer )
    {
      spawn(ExplosionEmitterClass,,,Location + vect(0,0,1)*50,rotator(vect(0,0,1)));
      if ( PhysicsVolume.bWaterVolume )
      {
        SpawnWaterExplo(HitLocation);
      }
    }
}



defaultproperties
{
     fLifeTime=-5.000000
     bSpawnDecal=False
     HitSoundType=4
     MyTrailClass=Class'XIII.GrenadTrail'
     StaticMeshName="MeshArmesPickup.Grenade_explo"
     ShakeMag=900.000000
     shaketime=7.000000
     ShakeVert=(X=5.000000,Y=10.000000,Z=-25.000000)
     ShakeSpeed=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeCycles=2.000000
     ExplosionEmitterClass=Class'XIII.GrenadExplosionEmitter'
     Speed=800.000000
     MaxSpeed=1000.000000
     Damage=350.000000
     DamageRadius=1200.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'XIII.DTGrenaded'
     ExplosionDecal=Class'XIII.GrenadBlast'
     bBlockActors=True
     bBounce=True
     bFixedRotationDir=True
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     LifeSpan=7.000000
     SaturationDistance=600.000000
     StabilisationDistance=3500.000000
     StabilisationVolume=-10.000000
}
