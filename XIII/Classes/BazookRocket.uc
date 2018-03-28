//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BazookRocket extends XIIIProjectile;

var rotator rHit;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
//    Log("--> Spawn projectile"@self); // ::DBUG::
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;

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
      if ( (Level.Game != none) && (Level.Game.DetailLevel > 1) )
        FragLoop = 6;
      else
        FragLoop = 3;
      for(i = 0; i < FragLoop ; i++)
      {
        Frag = Spawn(class'FragmentExplo',self,, HitLocation + HitNormal*50 - vector(rotation)*150,rotator(HitNormal));
        Frag.Velocity = (vRand())*(400+fRand()*200);
      }
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
    SetTimer(0.8, false);
}


defaultproperties
{
     hExploSound=Sound'XIIIsound.Explo__ExploBaz.ExploBaz__hExploBaz'
     MyTrailClass=Class'XIII.BazookRocketTrail'
     StaticMeshName="MeshArmesPickup.RocketIA"
     ShakeMag=900.000000
     shaketime=7.000000
     ShakeVert=(X=5.000000,Y=10.000000,Z=-25.000000)
     ShakeSpeed=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeCycles=2.000000
     ExplosionEmitterClass=Class'XIII.BazookExplosionEmitter'
     Speed=2000.000000
     MaxSpeed=4000.000000
     Damage=600.000000
     DamageRadius=1000.000000
     MomentumTransfer=80000.000000
     MyDamageType=Class'XIII.DTRocketed'
     ExplosionDecal=Class'XIII.BazookBlast'
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
     SaturationDistance=600.000000
     StabilisationDistance=3500.000000
     StabilisationVolume=-10.000000
}
