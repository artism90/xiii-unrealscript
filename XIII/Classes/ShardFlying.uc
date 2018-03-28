//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ShardFlying extends XIIIProjectile;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
//    local vector X,Y,Z;

    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
    RotationRate.Yaw = 80000;
    SetTimer(0.5, false);

    if ( Instigator.Base.Velocity == vect(0,0,0) )
    {
      MyTrail = Spawn(MyTrailClass,self,,Location);
      MyTrail.Init();
    }
}

//_____________________________________________________________________________
simulated function Timer()
{
    SetPhysics(PHYS_Falling);
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    Spawn(class'XIII.DecoThrowShardImpactEmitter',self,, Location, Rotation);
    PlaySound(hExploSound, 0, 1, 2 );
    Destroy();
}



defaultproperties
{
     bSpawnDecal=False
     HitSoundType=5
     hExploSound=Sound'XIIIsound.Items__GlassFire.GlassFire__hGlassExplo'
     InHeadClass=Class'XIII.ProjectileInHead'
     MyTrailClass=Class'XIII.GlassShardTrail'
     StaticMeshName="MeshArmesPickup.GlasShard"
     Speed=1000.000000
     Damage=50.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTBladeCut'
     bBounce=True
     bFixedRotationDir=True
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
