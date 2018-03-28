//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DartFlying extends XIIIProjectile;

var bool Touched;
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

event touch(actor other)
{
    if (other.isa('mover'))
    {
      log("crashed on "@other);
      destroy();
      // log("touch a mover");
    }
    else if (other.isa('pawn'))
    {
      super.touch(other);
    }
}

/* simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
 if (other.isa('mover'))
  {
   destroy();
   log("met a mover");
  }
 else
  super.ProcessTouch(other,hitlocation);
}  */

//event destroyed()
simulated function HitWall (vector HitNormal, actor Wall)
{
    Spawn(class'XIII.DartDecoPick',self,,location ,rotation);
    log("dart is dead");
    super.hitwall(HitNormal,Wall);
}


defaultproperties
{
     bSpawnDecal=False
     HitSoundType=3
     aVisualImpact=Class'XIII.DartInWall'
     InHeadClass=Class'XIII.ProjectileInHead'
     MyTrailClass=Class'XIII.TKnifeTrail'
     StaticMeshName="MeshArmesPickup.BarFlechette"
     Speed=800.000000
     MaxSpeed=1600.000000
     Damage=50.000000
     DamageRadius=375.000000
     MomentumTransfer=10000.000000
     MyDamageType=Class'XIII.DTBladeCut'
     bBounce=True
     DrawType=DT_StaticMesh
     LifeSpan=6.000000
}
