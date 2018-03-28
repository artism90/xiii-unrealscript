//-----------------------------------------------------------
// ELR Some can that can be shot using no physic but a 'weird behavioring' system ;)
//-----------------------------------------------------------
class InteractiveCan extends Decoration;

var() bool bFirstTimeGetOffThisWay;

var int NbSpins;
var class<Trail> MyTrailClass;
var Trail MyTrail;            // Should be spawned & init() in child classes (because spec inits needed).
var(sound) sound hHitSound;
var(sound) sound hWallBounceSound;
var(sound) sound hGroundHitSound;

//_____________________________________________________________________________
simulated function Spin(float spinRate)
{
    NbSpins = Max(NbSpins, 0);
    DesiredRotation.Roll = 16384;
    DesiredRotation.Pitch = 0;
    DesiredRotation.Yaw = Rand(65535);
    RotationRate.Yaw = spinRate * ( DesiredRotation.Yaw - rotation.Yaw ) * NbSpins;
    RotationRate.Pitch = spinRate * ( DesiredRotation.Pitch - rotation.Pitch ) * NbSpins;
    RotationRate.Roll = spinRate * ( DesiredRotation.Roll - rotation.Roll ) * NbSpins;
    SetCollisionSize(8,6); // reduce coll height to have can on ground
}

//_____________________________________________________________________________
event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    local ImpactEmitter B;

    PlaySound(hHitSound);

    Instigator = EventInstigator;
    if ( Instigator.Base == self )
      return;

    SetPhysics(PHYS_Falling);
    if ( bFirstTimeGetOffThisWay )
    {
      Velocity = 300.0*vector(Rotation)*(0.8+fRand()*0.4);
      Velocity.Z = fMin(100.0, Velocity.Z);
      Acceleration = vect(0,0,-1.0)*abs(Velocity.Z);
      bFirstTimeGetOffThisWay = false;
    }
    else
    {
      Velocity = vSize(Momentum)/50.0*normal(Location-HitLocation)*(0.8+fRand()*0.4);
      Velocity.Z = fMin(100.0, Velocity.Z);
      Acceleration = vect(0,0,-1.0)*abs(Velocity.Z);
    }
    bBounce = true;
    NbSpins = 3;
    Spin(3);
    B = Spawn(class'BulletMetalEmitter',self,, HitLocation+Normal(-Momentum), Rotator(-Momentum));
//    if ( B!=none && (EventInstigator != none) )
//      B.NoiseMake(XIIIPawn(EventInstigator), 0.3);
    MakeNoise(0.3);
    if ( MyTrail == none )
    {
      MyTrail = Spawn(MyTrailClass,self,,Location);
      MyTrail.Init();
    }
}

//_____________________________________________________________________________
event EndedRotation();

//_____________________________________________________________________________
event HitWall( vector HitNormal, actor HitWall )
{
    local float fSpeed;

//    Log(self@"HitWall="$HitNormal@"NbSpin"@NbSpins);
//    MyTrail.RotationSpeed *= 2.0;

//    if (Wall != none)
//      PlayImpactSound(HitNormal, Wall);
    NbSpins --;
    Spin(3);

    if ( abs(HitNormal.z) < 0.5 )
      PlaySound(hWallBounceSound);
    else
      PlaySound(hGroundHitSound);

    // Reflect off Wall
    if ( HitNormal.Z < 0.85 )
      Velocity = 0.5*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);
    else
    { // On ground
      if ( NbSpins > 0 )
        Velocity = 0.25*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);
      else
        Velocity = vect(0,0,0);
    }
    fSpeed = VSize(Velocity);
    if ( Velocity.Z > 400 )
      Velocity.Z = 0.5 * (400 + Velocity.Z);
    else if ( (fSpeed < 10) && (HitWall != none) ) // don't stop of touching and not hitting real wall.
    {
      bBounce = False;
      SetPhysics(PHYS_None);
    }
}



defaultproperties
{
     MyTrailClass=Class'XIII.ICanTrail'
     hHitSound=Sound'XIIIsound.Items__InteractiveCan.InteractiveCan__hCanTip1'
     hWallBounceSound=Sound'XIIIsound.Items__InteractiveCan.InteractiveCan__hCanRebound1'
     hGroundHitSound=Sound'XIIIsound.Items__InteractiveCan.InteractiveCan__hCanFall1'
     bStatic=False
     bStasis=False
     bInteractive=False
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bUseCylinderCollision=True
     bBounce=True
     bFixedRotationDir=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshObjetsPickup.conserve'
     CollisionRadius=8.000000
     CollisionHeight=10.000000
     bDirectional=True
}
