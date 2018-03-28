//-----------------------------------------------------------
//
//-----------------------------------------------------------
class M16GrenadFlying extends XIIIProjectile;

var rotator rHit;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
//    Log("--> Spawn projectile"@self); // ::DBUG::
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
    Velocity.z += 210;

    MyTrail = Spawn(MyTrailClass,self,,Location);
    MyTrail.Init();
}

//_____________________________________________________________________________
simulated function Timer()
{
    if ( bSpawnDecal && (ExplosionDecal != None) && (Level.NetMode != NM_DedicatedServer) )
      Spawn(ExplosionDecal,self,,Location, rHit);
    destroy();
}

//_____________________________________________________________________________
simulated function Explode(vector HitLocation, vector HitNormal)
{
    Local FragmentExplo Frag;
    Local int i, FragLoop;

    BlowUp(HitLocation + 50*HitNormal);
    if ( Level.NetMode != NM_DedicatedServer )
    {
      Spawn(ExplosionEmitterClass,,,HitLocation + HitNormal*50 - vector(rotation)*150,rotator(HitNormal));
/*
      if ( (Level.Game != none) && (Level.Game.DetailLevel > 1) )
        FragLoop = 6;
      else
        FragLoop = 3;
      for(i = 0; i < FragLoop ; i++)
      {
        Frag = Spawn(class'FragmentExplo',self,, HitLocation + HitNormal*50 - vector(rotation)*150,rotator(HitNormal));
        Frag.Velocity = (vRand())*(400+fRand()*200);
      }
*/
      if ( PhysicsVolume.bWaterVolume )
      {
        SpawnWaterExplo(HitLocation);
      }
    }
    rHit = rotator(-HitNormal);
    SetPhysics(PHYS_None);
    Velocity = vect(0,0,0);
    bHidden = true;
    RefreshDisplaying();
    SetTimer(0.05, false);
}

/*
var bool bCanHitOwner, bHitWater;
//var bool bArmed;
//var float Count, SmokeRate;
//var int NumExtraGrenades;
//var int NombreRebonds;
//var float fLifeTime;                // duration before explosion

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    local vector X,Y,Z;
    local rotator RandRot;

    Super.PostBeginPlay();
//    bArmed = false;
    SetTimer(10.0,false);   // to make it blow after 10 seconds

    if ( Role == ROLE_Authority )
    {
      GetAxes(Instigator.GetViewRotation(),X,Y,Z);
      Velocity = X * (Instigator.Velocity Dot X)*0.4 + Vector(Rotation) * (Speed + FRand() * 100);
      Velocity.z += 210;
      MaxSpeed = 1000;
      RandSpin(80000);
      bCanHitOwner = False;
      if (Instigator.HeadVolume.bWaterVolume)
      {
        bHitWater = True;
        Disable('Tick');
        Velocity=0.6*Velocity;
      }
    }
    MyTrail = Spawn(MyTrailClass,self,,Location);
    MyTrail.CurRotation = fRand()*80.0;
    MyTrail.Init();
}


//_____________________________________________________________________________
simulated function Timer()
{
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
    HitWall( HitNormal, None );
}

//_____________________________________________________________________________
simulated function ProcessTouch( actor Other, vector HitLocation )
{
    Local vector vt;

    if ( (Other!=instigator) || bCanHitOwner )
    {
      Velocity = 0.2*Velocity;
      vt = HitLocation - Other.Location;
      HitWall( normal(vt), None );
    }
}

//_____________________________________________________________________________
simulated function HitWall( vector HitNormal, actor Wall )
{
//    bArmed = true;
    // Special for RocketArena mod
    if ( XIIIGameInfo(level.game).bRocketArena )
    {
      Damage=200.0;
      DamageRadius=200.0;
      Velocity = vect(0,0,0);
      SetPhysics(PHYS_None);
      Timer();
      Return;
    }

    // Explosion on contact for Player's grenades
    if ( Instigator.IsPlayerPawn() )
    {
      Velocity = vect(0,0,0);
      SetPhysics(PHYS_None);
      Timer();
      Return;
    }
}

//_____________________________________________________________________________
simulated function Explosion(vector HitLocation)
{
    BlowUp(HitLocation);
    if ( Level.NetMode != NM_DedicatedServer )
    {
      spawn(ExplosionEmitterClass,,,Location + vect(0,0,1)*50,rotator(vect(0,0,1)));
      if ( PhysicsVolume.bWaterVolume )
      {
        SpawnWaterExplo(HitLocation);
      }
    }
    bHidden = true;
    RefreshDisplaying();
}
*/



defaultproperties
{
     HitSoundType=4
     MyTrailClass=Class'XIII.M16GrenadTrail'
     StaticMeshName="MeshArmesPickup.M16Grenade"
     ShakeMag=900.000000
     shaketime=7.000000
     ShakeVert=(X=5.000000,Y=10.000000,Z=-25.000000)
     ShakeSpeed=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeCycles=2.000000
     ExplosionEmitterClass=Class'XIII.GrenadExplosionEmitter'
     Speed=1200.000000
     MaxSpeed=1000.000000
     Damage=300.000000
     DamageRadius=1200.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'XIII.DTGrenaded'
     ExplosionDecal=Class'XIII.GrenadBlast'
     bBounce=True
     bFixedRotationDir=True
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     LifeSpan=12.000000
     SaturationDistance=600.000000
     StabilisationDistance=3500.000000
     StabilisationVolume=-10.000000
}
