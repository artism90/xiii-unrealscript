//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HookProjectile extends XIIIProjectile;

var sound hHookLockSound;

//_____________________________________________________________________________
// Set up speed
simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();
    if ( (StaticMesh == none) && (StaticMeshName != "") )
    {
      StaticMesh = StaticMesh(dynamicloadobject(StaticMeshName, class'StaticMesh'));
      default.StaticMesh = StaticMesh;
      SetDrawType(DT_StaticMesh);
//      Log("PostBeginPlay DYNAMICLOAD StaticMesh "$StaticMeshName@"result "$StaticMesh);
    }
    vWaterEntry = Location;
    OrgFrom = Location;
    Velocity = Vector(Rotation) * Speed;
}

//_____________________________________________________________________________
// Override ProcessTouch
simulated function ProcessTouch(Actor Other, Vector HitLocation)
{
    local rotator R;

//    Log(self@"ProcessTouch"@Other);
    if (Other == Instigator)
      return;
    if ( HookPoint(Other)!= none )
    {
      TriggerEvent(Other.Event, self, Instigator);
      Velocity = vector(Rotation) * 0.0;
      SetPhysics(PHYS_None);
      SetCollision(false,false,false);
      SetLocation(Other.Location);
      R = rotator(vect(0,0,1));
      SetRotation(R);
      gotostate('Locked');
      return;
    }
    // Else deactivate
//    Log("Releasing hook because Projectile hit actor.");
    Hook(Owner).Release();
}

//_____________________________________________________________________________
// & Override HitWall
simulated function HitWall (vector HitNormal, actor Wall)
{
    // Deactivate
    Log("Releasing hook because Projectile hit wall"@Wall@"(should not happen...).");
    Hook(Owner).Release();
/*
    Velocity = vector(Rotation) * 0.0;
    SetPhysics(PHYS_None);
    gotostate('Locked');
*/
}

//_____________________________________________________________________________
// Maybe use this for the hook to destroy the link when DeActivated.
simulated function Explode(vector HitLocation, vector HitNormal)
{
    Destroy();
}

//_____________________________________________________________________________
state Locked
{
    ignores Touch, ProcessTouch, HitWall;
    function BeginState()
    {
      Hook(Owner).PlaySound(hHookLockSound);
    }
}

//    DrawType=DT_Mesh
//    Mesh=VertMesh'XIIIArmes.GrappinM'


defaultproperties
{
     hHookLockSound=Sound'XIIIsound.SpecActions.HookCatch'
     Speed=1200.000000
     MaxSpeed=3600.000000
     MyDamageType=Class'XIII.DTPierced'
     DrawType=DT_StaticMesh
     LifeSpan=0.000000
     StaticMesh=StaticMesh'MeshArmesPickup.grappin'
     CollisionRadius=5.000000
     CollisionHeight=5.000000
}
