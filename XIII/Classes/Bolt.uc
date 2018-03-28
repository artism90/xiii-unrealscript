//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Bolt extends XIIIProjectile;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
//    Log("--> Spawn projectile"@self); // ::DBUG::
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
    SetTimer(2.0, false);

    MyTrail = Spawn(MyTrailClass,self,,Location);
    MyTrail.Init();
}

//_____________________________________________________________________________
simulated function Timer()
{
    SetPhysics(PHYS_Falling);
}


defaultproperties
{
     bSpawnDecal=False
     HitSoundType=3
     aVisualImpact=Class'XIII.BoltInWall'
     InHeadClass=Class'XIII.ProjectileInHead'
     MyTrailClass=Class'XIII.BoltTrail'
     StaticMeshName="MeshArmesPickup.CarreauIA"
     Speed=5000.000000
     MaxSpeed=10000.000000
     Damage=52.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTPierced'
     ExplosionDecal=Class'XIII.BulletScorch'
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
