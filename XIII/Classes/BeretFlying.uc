//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BeretFlying extends Effects;

var bool bFirstHit;
var() sound    ImpactSound, AltImpactSound;
var()	float  SplashTime;

//_____________________________________________________________________________
function bool CanSplash()
{
	if ( (Level.TimeSeconds - SplashTime > 0.25)
		&& (Physics == PHYS_Falling)
		&& (Abs(Velocity.Z) > 100) )
	{
		SplashTime = Level.TimeSeconds;
		return true;
	}
	return false;
}

//_____________________________________________________________________________
simulated function CalcVelocity(vector Momentum)
{
    local float ExplosionSize;

    ExplosionSize = 0.011 * VSize(Momentum);
    Velocity = 0.0033 * Momentum + 0.7 * VRand()*(ExplosionSize+FRand()*100.0+100.0);
//    Velocity.z += 0.5 * ExplosionSize;
//    Log("CalcVelocity Velocity="$Velocity);
}

//_____________________________________________________________________________
simulated event HitWall (vector HitNormal, actor HitWall)
{
    local float speed;

    Velocity = 0.5*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
    speed = VSize(Velocity);
    if (bFirstHit && speed<400)
    {
      bFirstHit=False;
      bRotatetoDesired=True;
      bFixedRotationDir=False;
      DesiredRotation.Pitch=0;
      DesiredRotation.Yaw=FRand()*65536;
      DesiredRotation.roll=0;
    }
    RotationRate.Yaw = RotationRate.Yaw*0.75;
    RotationRate.Roll = RotationRate.Roll*0.75;
    RotationRate.Pitch = RotationRate.Pitch*0.75;
    if ( (speed < 60) && (HitNormal.Z > 0.7) )
    {
      SetPhysics(PHYS_none);
      bBounce = false;
      GoToState('');
    }
    else if (speed > 80)
    {
      if (FRand()<0.5)
      	PlaySound(ImpactSound);
      else
      	PlaySound(AltImpactSound);
    }
}

/*
//_____________________________________________________________________________
event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
//    Log(self$" TakeDamage");
    GotoState('Flying');
//    bBounce = true;
    SetPhysics(PHYS_Falling);
    CalcVelocity((HitLocation - Location) * vSize(Momentum));
}
*/

//_____________________________________________________________________________
simulated final function RandSpin(float spinRate)
{
    DesiredRotation = RotRand();
    RotationRate.Yaw = spinRate * 2 *FRand() - spinRate;
    RotationRate.Pitch = spinRate * 2 *FRand() - spinRate;
    RotationRate.Roll = spinRate * 2 *FRand() - spinRate;
}

//_____________________________________________________________________________
auto state Flying
{
	simulated singular event PhysicsVolumeChange( PhysicsVolume NewVolume )
	{
		if ( NewVolume.bWaterVolume )
		{
			Velocity = 0.2 * Velocity;
			if (bFirstHit)
			{
				bFirstHit=False;
				bRotatetoDesired=True;
				bFixedRotationDir=False;
				DesiredRotation.Pitch=0;
				DesiredRotation.Yaw=FRand()*65536;
				DesiredRotation.roll=0;
			}
			RotationRate = 0.2 * RotationRate;
		}
	}

	simulated event BeginState()
	{
		RandSpin(125000);
		if (abs(RotationRate.Pitch)<10000)
			RotationRate.Pitch=10000;
		if (abs(RotationRate.Roll)<10000)
			RotationRate.Roll=10000;
	}
}


defaultproperties
{
     bFirstHit=True
     bIgnoreVignetteAlpha=True
     bCollideActors=True
     bCollideWorld=True
     bFixedRotationDir=True
     Physics=PHYS_Falling
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshArmesPickup.beret'
     CollisionRadius=10.000000
     CollisionHeight=8.000000
}
