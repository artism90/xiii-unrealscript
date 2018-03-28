//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MitraillTop extends Decoration
    NotPlaceable;

var MitraillTrigger MitTrig;  // the trigger that will be used to use me
var vector vInitDir;          // initial direction to limit the movement of the gun.
var rotator OldRotation;
var texture Crosshair;
var float TraceDist;          // how far instant hit trace fires go
var float TraceAccuracy;      // Accuracy of shots
var class<DamageType> MyDamageType;
var Pawn PawnControlling;
var sound hFireSound;
var float ShakeMag;
var float ShakeTime;
var vector ShakeVert;
var vector ShakeSpeed;
var float ShakeCycles;        // Added this param for weapon shakes (was not handled by default)

var class<Projector> DecalProjector; // Visual Impact to leave on geometry
var int MaxShootAngle;
var int DownAMax, UpAMax;
var float fGuardReactionDelay;

var sound hControlSound;
var string StaticMeshName;  // to dynamicload it

var BulletTrail BT;
var int TeamID;

CONST TRACEFREQ=1.0;

//_____________________________________________________________________________
function PostBeginPlay()
{
//    Log("PostBeginPlay for "$self$" StaticMesh="$StaticMesh$" StaticMeshName="$StaticMeshName);
    if ( (StaticMesh == none) && (StaticMeshName != "") )
    {
      StaticMesh = StaticMesh(dynamicloadobject(StaticMeshName, class'StaticMesh'));
      default.StaticMesh = StaticMesh;
    }
    MitTrig = Spawn(class'MitraillTrigger',self,,Location);
    MitTrig.Tag = 'MitTrig'; // to avoid auto-activation of an item with the none tag when using the trigger
    vInitDir = vector(Rotation);
    TraceDist = TraceDist * 200 / 2.54;
}

//_____________________________________________________________________________
function SpawnGuard(mesh GuardMesh)
{
    Local vector V,W;

    PawnControlling = spawn(class'MitraillGuard',self,,Location,Rotation);
    if ( GuardMesh != none )
      PawnControlling.Mesh = GuardMesh;
    PawnControlling.ControlledActor = Self;
    TakeControl(PawnControlling);

    V = location;
    W = vector(Owner.Rotation);
    W.z = 0.0;
    W = Normal(W);
    V -= CollisionRadius * W;
    V -= PawnControlling.CollisionRadius * W * 2;
    V.z = PawnControlling.Location.z;
    PawnControlling.SetCollision(false,false,false);
    PawnControlling.SetLocation(V);

    if( Level.bLonePlayer )
        PawnControlling.SetCollision(true,true,true);

    MitraillGuard(PawnControlling).TeamID = TeamID;
    //log("++++++++++ MitraillTop"@TEamID@"++++++++++++");
}

//_____________________________________________________________________________
function InvincibleGuard()
{
    PawnControlling.controller.bGodMode = true;
    PawnControlling.bHidden = true;
}

//_____________________________________________________________________________
function bool TrySetRotation(rotator NewRot)
{
    local vector X,Y,Z;
    local vector U;
    local float f;
    local bool bReturn;

    NewRot.Pitch = NewRot.Pitch & 65535;
    If ((NewRot.Pitch > UpAMax) && (NewRot.Pitch < DownAMax))
    {
      If (NewRot.Pitch < 32768)
        NewRot.Pitch = UpAMAx;
      else
        NewRot.Pitch = DownAMax;
    }
    GetAxes(NewRot, X,Y,Z);
    bReturn = true;
    if ( (MaxShootAngle <= 1) && (X dot vInitdir < 0.0) )
    {
      return false;
    }
    else if ( (MaxShootAngle == 0) && (X dot vInitdir < 0.707) )
    {
      bReturn = false;
      U = vInitDir + normal((vInitDir cross X) cross vInitDir);
      U = normal(U);
      Y.z = 0;
      Y = normal(Y);
      Z = U cross Y;
      NewRot = OrthoRotation(U,Y,Z);
    }
    else if ( (MaxShootAngle == 1) && (X dot vInitdir < 0.08) )
    {
      bReturn = false;
      U = vInitDir * 0.08 + normal((vInitDir cross X) cross vInitDir);
      U = normal(U);
      Y.z = 0;
      Y = normal(Y);
      Z = U cross Y;
      NewRot = OrthoRotation(U,Y,Z);
    }
    SetRotation(NewRot);
    return bReturn;
}

//_____________________________________________________________________________
function Fire()
{
    SetTimer(0.05, false);
}

//_____________________________________________________________________________
function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    Local int ActualDamages;
    local ImpactEmitter B;

    PlayFiringSound();

    if (PlayerController(PawnControlling.Controller)!=None)
      PlayerController(PawnControlling.Controller).ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, ShakeCycles);

    if ( Other == None )
      return;

    if( Level.bLonePlayer )
        ActualDamages = 50;
    else
        ActualDamages = 80;
//    log(self@"shot for"@ActualDamages@"range"@VSize(HitLocation - W.Location)); // ::DBUG::

    if ( ActualDamages <= 0)
      return;

    if ( Other.bWorldGeometry )
    {
      B = Spawn(class'BulletDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
      if (B!=none)
        B.NoiseMake(PawnControlling, 0.787);
      if ( (DecalProjector != None) && (Level.NetMode != NM_DedicatedServer) )
        Spawn(DecalProjector,self,,HitLocation + HitNormal, rotator(X-HitNormal));
//        Spawn(DecalProjector,self,,HitLocation + HitNormal, rotator(-HitNormal));
    }
    else if ( (Other != self) && (Other != PawnControlling) && (Other != Owner) )
    {
      Other.TakeDamage(ActualDamages, PawnControlling, HitLocation, 30000.0*X, MyDamageType);
      if ( (Pawn(Other) != none) && (Level.Game != none) && (Level.Game.GoreLevel == 0) )
        B = Spawn(class'XIIIDamageType'.default.BloodShotEmitterClass,,, HitLocation+HitNormal, Rotator(-X));
      else
      {
        B = Spawn(class'BulletDustEmitter',,, HitLocation+HitNormal, Rotator(HitNormal));
      }
      if (B!=none)
        B.NoiseMake(PawnControlling, 0.262);
    }
}

//_____________________________________________________________________________
function TakeControl(Pawn PControl)
{
    TriggerEvent('PlayerTakeMG', self, PControl);
    PawnControlling = PControl;
    if ( PControl.IsPlayerPawn() )
      TraceAccuracy = 2.0;
    else
      TraceAccuracy = 120.0;
    PlaySound(hControlSound, 0);
}

function LeaveControl()
{
    TriggerEvent('PlayerLeaveMG', self, PawnControlling);
    PawnControlling = none;
    GotoState('GoToWaitingPos');
    PlaySound(hControlSound, 1);
}

//_____________________________________________________________________________
function DrawCrossHair( canvas Canvas)
{
    local float XLength;

    if ( CrossHair == None )
      return;
    XLength = 32.0;
    Canvas.bNoSmooth = False;
    Canvas.Style = ERenderStyle.STY_Translucent;
    Canvas.SetDrawColor(255,255,255,255);
    Canvas.SetPos((Canvas.ClipX - XLength)/2.0, (Canvas.ClipY - XLength)/2.0);
    Canvas.DrawTile(CrossHair, XLength, XLength, 0, 0, CrossHair.USize, CrossHair.VSize);

    Canvas.bNoSmooth = True;
    Canvas.Style = Style;
}

//_____________________________________________________________________________
function RenderOverlays(Canvas C)
{
    DrawCrossHair(C);
}

//_____________________________________________________________________________
//state Firing
//{
    function Timer()
    {
      local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
      local actor Other;
      local material HitMat;

      if( level.bLonePlayer )
          XIIIPlayerController(PawnControlling.Controller).RumbleFX(5); // Use Magnum Rumble ?
      GetAxes(Rotation,X,Y,Z);
      StartTrace = Location + 20*X + 16*Z; // ~EyePosition
      X = vector(Rotation);
      EndTrace = StartTrace + (Tracedist * X); // compensation of eye position to have hits in the reticle
      EndTrace += vRand() * fRand() * (TraceAccuracy/100.0) * TraceDist;
//      Other = Trace(HitLocation,HitNormal,EndTrace,StartTrace,True,vect(0,0,0),HitMat,TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);
      Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);
      if ( XIIIPawn(Other) != none )
        XIIIPawn(Other).LastBoneHit = GetLastTraceBone();

      ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);

      ShakeVert=X*1.1;
      if( level.bLonePlayer )
          PawnControlling.Controller.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, 2);

      if ( PawnControlling.Pressingfire() )
        SetTimer(0.05, false);
//      else
//        GotoState('');
      if ( TRACEFREQ > fRand() )
      {
        Spawn(class'BulletTraces', self,,Location + 100*X, Rotation);
/*
        if (BT == none)
        {
          BT = Spawn(Class'BulletTrail',self,,Location, Rotation);
          BT.RibbonColor = BT.default.RibbonColor * fRand();
          BT.Init();
//          LOG("TRAIL Spawned="$BT);
        }
        if ( BT != none )
        {
          BT.Reset();
//          LOG("TRAIL Section="$Location@"to"@HitLocation);
          BT.AddSection(HitLocation);
          BT.AddSection(Location);
        }
*/
      }
    }
//}

//_____________________________________________________________________________
auto state GoToWaitingPos
{
    function BeginState()
    {
//      Log("####"@self@" GoToWaitingPos BeginState");
    }
    function Tick(float deltatime)
    {
      local rotator R;

//      log("####"@self@"rotation="$rotation);
      R = Rotation;
      R.Pitch += 25000 * DeltaTime;
      TrySetRotation(R);
//      Log("Pitch ="$rotation.pitch);
      if (Oldrotation == Rotation)
      {
        GotoState('');
        return;
      }
      OldRotation = Rotation;

    }
}

//_____________________________________________________________________________
simulated function PlayFiringSound()
{
    PawnControlling.MakeNoise(2.62);
    PawnControlling.PlaySound(hFireSound, 0, int(PawnControlling.IsPlayerPawn()));
}

//    DrawType=DT_Mesh
//    Mesh=VertMesh'XIIIArmes.Mit127TopM'
//    DrawType=DT_StaticMesh


defaultproperties
{
     CrossHair=Texture'XIIIMenu.HUD.MireM60'
     TraceDist=300.000000
     TraceAccuracy=2.000000
     MyDamageType=Class'XIII.DTGunned'
     hFireSound=Sound'XIIIsound.Guns__M60Fire.M60Fire__hM60Fire'
     ShakeMag=300.000000
     shaketime=5.000000
     ShakeVert=(Z=5.000000)
     ShakeSpeed=(X=300.000000,Y=300.000000,Z=300.000000)
     ShakeCycles=1.000000
     DecalProjector=Class'XIII.BulletScorch'
     DownAMax=55000
     UpAMax=12000
     hControlSound=Sound'XIIIsound.Guns__MitSelWp.MitSelWp__hMitSelWp'
     StaticMeshName="MeshArmesPickup.Mit127Top"
     bStatic=False
     bInteractive=False
     DrawType=DT_StaticMesh
}
