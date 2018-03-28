//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FragmentExplo extends Fragment;

var class<Trail> MyTrailClass;
var Trail MyTrail;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    MyTrail = Spawn(MyTrailClass,self,,Location);
    MyTrail.RotationSpeed = (fRand()*2.0-1.0)*MyTrail.default.RotationSpeed;
    MyTrail.RibbonColor = MyTrail.default.RibbonColor * fRand();
    MyTrail.ActorOffset = vRand() * 5.0;
    MyTrail.Init();
}

//_____________________________________________________________________________
simulated function HitWall (vector HitNormal, actor HitWall)
{
    MyTrail.RibbonColor = MyTrail.RibbonColor * 0.5;
    MyTrail.RotationSpeed *= 0.5;
    MyTrail.ActorOffset *= 0.5;
    MyTrail.FadePeriod *= 0.5;
    Super.HitWall(HitNormal, HitWall);
}

//_____________________________________________________________________________
simulated event Destroyed()
{
    Super.Destroyed();
    if ( (MyTrail != none) && !MyTrail.bDeleteMe )
      MyTrail.Destroy();
}



defaultproperties
{
     MyTrailClass=Class'XIII.FragmentTrail'
     bCollideActors=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'StaticExplosifs.grenadfragment'
}
