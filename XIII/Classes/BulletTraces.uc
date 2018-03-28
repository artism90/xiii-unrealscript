//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BulletTraces extends XIIIProjectile;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Local rotator R;

//    Log("--> Spawn projectile"@self); // ::DBUG::
    Super.PostBeginPlay();

    Velocity = Vector(Rotation) * Speed;
    MyTrail = Spawn(MyTrailClass,self,,Location);
    MyTrail.RibbonColor = MyTrail.default.RibbonColor * fRand();
    MyTrail.Init();
}

//_____________________________________________________________________________
// Touching
simulated singular function Touch(Actor Other)
{
    return;
}

//_____________________________________________________________________________
// Override ProcessTouch
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    return;
}

//_____________________________________________________________________________
simulated function HitWall(vector HitNormal, actor Wall)
{
    Velocity = vect(0,0,0);
    Acceleration = vect(0,0,0);
    Speed = 0.0;
  	SetTimer(2.0, false);
}

//_____________________________________________________________________________
event Timer()
{
    Destroy();
}


defaultproperties
{
     bSpawnDecal=False
     MyTrailClass=Class'XIII.BulletTrail'
     Speed=10000.000000
     MaxSpeed=10000.000000
     LifeSpan=1.000000
}
