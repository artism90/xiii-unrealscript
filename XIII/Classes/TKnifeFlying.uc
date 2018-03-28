//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TKnifeFlying extends XIIIProjectile;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
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



defaultproperties
{
     bSpawnDecal=False
     HitSoundType=5
     aVisualImpact=Class'XIII.TKnifeInWall'
     InHeadClass=Class'XIII.ProjectileInHead'
     MyTrailClass=Class'XIII.TKnifeTrail'
     StaticMeshName="MeshArmesPickup.CoutoLanc"
     Speed=1200.000000
     MaxSpeed=2400.000000
     Damage=50.000000
     DamageRadius=375.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTBladeCut'
     bBounce=True
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
