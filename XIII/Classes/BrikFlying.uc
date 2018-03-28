//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BrikFlying extends XIIIProjectile;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    Velocity = Vector(Rotation) * Speed;
    RotationRate.Pitch = -80000; // Around Y
    RotationRate.Roll = 10000; // Around Z
    SetTimer(0.5, false);
}

//_____________________________________________________________________________
simulated function Timer()
{
    SetPhysics(PHYS_Falling);
}

//_____________________________________________________________________________
simulated function Explode(vector HitLocation, vector HitNormal)
{
    Spawn(class'XIII.DecoBrikImpactEmitter',self,, Location, Rotation);
    PlaySound(hExploSound, 0, 1, 2 );
    Destroy();
}

//    MyDamageType=Class'XIII.DTBladeCut'

defaultproperties
{
     bSpawnDecal=False
     HitSoundType=5
     hExploSound=Sound'XIIIsound.Items__BrickFire.BrickFire__hBrickExplo'
     StaticMeshName="MeshArmesPickup.brik"
     iStunning=1
     Speed=1000.000000
     Damage=50.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTStunned'
     bBounce=True
     bFixedRotationDir=True
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
