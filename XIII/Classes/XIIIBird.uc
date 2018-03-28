//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIBird extends XIIITransientAPawn;

var float Angle;
var bool bDirection;
var bool bDestroyIfHitWall;
var float CircleRadius;
var float HeightOffset;

//_____________________________________________________________________________
function PostBeginPlay()
{
    Super.PostBeginPlay();
    LoopAnim('Vole');
    CircleRadius = 400 + 500 * FRand();
    bDirection = ( FRand() < 0.5 );
    HeightOffset = 500 * FRand() + 200;
}

//_____________________________________________________________________________
function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
    Super.DisplayDebug(Canvas, YL, YPos);

    Canvas.SetDrawColor(255,255,255);
    Canvas.DrawText("Controller Location "$Controller.Location);
    YPos += YL;
    Canvas.SetPos(4,YPos);
    Canvas.DrawText("Master Pawn "$(Controller.Pawn == self));
    YPos += YL;
    Canvas.SetPos(4,YPos);
}

//_____________________________________________________________________________
function float GetSleepTime()
{
    return SleepTime;
}

//_____________________________________________________________________________
function HitWall(vector HitNormal, actor HitWall)
{
    Acceleration *= -1;
    DesiredRotation = Rotator(Acceleration);
    if ( bDestroyIfHitWall )
    {
      if ( LastRenderTime > 1 )
        Destroy();
      else
      {
        bDestroySoon = true;
        GotoState('Wandering');
      }
    }
}

//_____________________________________________________________________________
State Dying
{
    ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

    function BeginState()
    {
//          PlaySound(sound'injur1m');
      if ( FRand() < 0.5 )
        TweenAnim('Dead1', 0.2);
      else
        TweenAnim('Dead2', 0.2);
    }
}

//_____________________________________________________________________________
function PlayGlideOrFly(vector Dest)
{
    if ( (Dest.Z > Location.Z + 5) || (FRand() < 0.5) )
      LoopAnim('Vole');
    else
      LoopAnim('Plane');
}

//_____________________________________________________________________________
function PlayFlying()
{
    LoopAnim('Vole');
}

//_____________________________________________________________________________
function PlayOnGround()
{
    LoopAnim('Sol');
}

//_____________________________________________________________________________
function PlayCall()
{
//     PlaySound(sound'call2b',,0.5 + 0.5 * FRand(),,, 0.8 + 0.4 * FRand());
}

//     Land=None


defaultproperties
{
     CircleRadius=600.000000
     bSameZoneHearing=True
     bAdjacentZoneHearing=True
     AirSpeed=500.000000
     AccelRate=800.000000
     Health=1
     LandMovementState="PlayerFlying"
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
     Physics=PHYS_Flying
     Mesh=SkeletalMesh'XIIIPersos.mouetteM'
     CollisionRadius=28.000000
     CollisionHeight=16.000000
     RotationRate=(Pitch=12000,Yaw=20000,Roll=12000)
}
