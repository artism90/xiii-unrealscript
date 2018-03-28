//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIILeftHand extends Inventory;

var bool bActive;           // if the hand is active (corpse or prisonner)
var XIIIPawn pOnShoulder;   // the pawn in hand (corpse or prisonner)

var sound hCatchPrisonnerSound;
var sound hReleasePrisonnerSound;
var sound hCatchBodySound;
var sound hReleaseBodySound;
var sound hReleaseGoodPrisonnerSound;

var mesh mCorpse, mPrisonner;
var inventoryAttachment TheHeldBody;

var vector PlayerViewOffsetCorpse, PlayerViewOffsetPrisonner;

//_____________________________________________________________________________
simulated event RenderOverlays( canvas Canvas )
{
    if ( (Instigator == None) || (Instigator.Controller == None))
      return;
    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation( Instigator.GetViewRotation() );
//    Canvas.DrawActor(self, false);
    SetBase(Pawn(Owner).Controller);
}

/*
//_____________________________________________________________________________
// Select first activatable powerup.
simulated function Powerups SelectNext()
{
//    Log("  > SelectNext for "$self@"call, inventory="$Inventory);
    if ( Inventory != None )
      return Inventory.SelectNext();
    else
      return None;
}
*/

//_____________________________________________________________________________
function GrabPawn(XIIIPawn P)
{
    if ( (pOnShoulder != none) || (P == none) )
      return;

//    Log("--> GrabPawn called");
    pOnShoulder = P;
    if ( pOnShoulder.bIsDead )
      Mesh = mCorpse;
    else
      Mesh = mPrisonner;

    TheHeldBody = spawn(class'HeldBody',self);
    TheHeldBody.Mesh = pOnShoulder.Mesh;
    if ( (pOnShoulder.Skins.Length != 0) && (pOnShoulder.Skins[0] != none) )
      TheHeldBody.Skins[0] = pOnShoulder.Skins[0];

    AttachToBone(TheHeldBody,'Box01');

    pOnShoulder.Instigator = Pawn(Owner);
    pOnShoulder.BeingGrabbed();
    if ( pOnShoulder.bIsDead )
    {
      XIIIPawn(instigator).bPrisonner=false;
      Instigator.PlayRolloffSound(hCatchBodySound, self);
      PlayerViewOffset = PlayerViewOffsetCorpse;
    }
    else
    {
      XIIIPawn(instigator).bPrisonner=true;
      Instigator.PlayRolloffSound(hCatchPrisonnerSound, self);
      PlayerViewOffset = PlayerViewOffsetPrisonner;
    }
    XIIIPawn(Owner).bHaveOnlyOneHandFree=true;

    PlayGrabbing();
    bActive=true;

    GotoState('Grabbing');
}

//_____________________________________________________________________________
function UnGrabPawn()
{
//    Log("--> UnGrabPawn called");

// ELR distinction between ungrabing corpse or prisoner is made in pawn functions upon current state
    if ( !pOnShoulder.bIsDead )
    {
      if ( pOnShoulder.GameOver == GO_Never )
        Instigator.PlayRolloffSound(hReleasePrisonnerSound, self);
      else
        Instigator.PlayRolloffSound(hReleaseGoodPrisonnerSound, self);
    }

    PlayUnGrabbing();

    TheHeldBody.GotoState('UnGrabbed');

    GotoState('UnGrabbing');
    XIIIPawn(instigator).bPrisonner=false;
    XIIIPawn(Owner).bHaveOnlyOneHandFree=false;
}

//_____________________________________________________________________________
state Grabbing
{
    event BeginState()
    {
      bHidden = false;
      RefreshDisplaying();
//      TheHeldBody.bHidden = true;
//      TheHeldBody.RefreshDisplaying();
    }
    function UnGrabPawn();
    function GrabPawn(XIIIPawn P);
    event AnimEnd(int channel)
    {
      PlayWaiting();
      GotoState('Holding');
    }
}

//_____________________________________________________________________________
state Holding
{
    function GrabPawn(XIIIPawn P);
    event AnimEnd(int channel)
    {
      if ( (fRand() < 0.1) && !pOnShoulder.bIsDead )
        PlayMoving();
      else
        PlayWaiting();
    }
}

//_____________________________________________________________________________
state UnGrabbing
{
    function UnGrabPawn();
    function GrabPawn(XIIIPawn P);
    event AnimEnd(int channel)
    {
      bActive = false;
      bHidden = true;
      RefreshDisplaying();
      if ( pOnShoulder != none )
      {
        if ( pOnShoulder.bIsDead )
        {
          Instigator.PlayRolloffSound(hReleaseBodySound, self);
          pOnShoulder.UnGrabbed(Instigator.Location - vect(0,0,50), vector(rotation));
        }
        else
        {
          pOnShoulder.UnGrabbed(Instigator.Location - vect(0,0,50), vector(rotation));
        }
        if ( Mover(Instigator.Base) != none )
          pOnShoulder.SetBase(Instigator.Base);
        pOnShoulder = none;
      }
      XIIIPawn(Owner).CheckMaluses();
      GotoState('');
    }
}

//_____________________________________________________________________________
function PlayGrabbing()
{
    PlayAnim('Select');
    if ( pOnShoulder.bIsDead && (TheHeldBody != none) )
      TheHeldBody.PlayAnim('CadavreSelect');
    else
      TheHeldBody.PlayAnim('OtageSelect');
}

function PlayWaiting()
{
    PlayAnim('Wait');

//    log("pOnShoulder="$pOnShoulder@"TheHeldBody="$TheHeldBody);

    if ( pOnShoulder.bIsDead && (TheHeldBody != none) )
      TheHeldBody.PlayAnim('CadavreWait');
    else
      TheHeldBody.PlayAnim('OtageWait');
}

function PlayMoving()
{
    PlayAnim('Mov');
    TheHeldBody.PlayAnim('OtageMov');
}

function PlayUnGrabbing()
{
    if ( pOnShoulder.bIsDead && (TheHeldBody != none) )
    {
      PlayAnim('Down');
      TheHeldBody.PlayAnim('CadavreDown');
    }
    else
    {
      PlayAnim('DownKill');
      TheHeldBody.PlayAnim('OtageDownKill');
    }
}

event FPSThrowNote()
{
    Instigator.PlayRolloffSound(hReleaseBodySound, self);
}
event FPSKillNote()
{
    Instigator.PlayRolloffSound(hReleasePrisonnerSound, self);
}
event FPSStunNote()
{
    Instigator.PlayRolloffSound(hReleasePrisonnerSound, self);
}

//    bSpecialDelayFov=true


defaultproperties
{
     hCatchPrisonnerSound=Sound'XIIIsound.SpecActions__Hostage.Hostage__hHostageIn'
     hReleasePrisonnerSound=Sound'XIIIsound.SpecActions__Hostage.Hostage__hHostageOut'
     hCatchBodySound=Sound'XIIIsound.SpecActions.BodyCatch'
     hReleaseBodySound=Sound'XIIIsound.SpecActions.BodyThrow'
     hReleaseGoodPrisonnerSound=Sound'XIIIsound.SpecActions__Hostage.Hostage__hHostageOutKiTuPas'
     mCorpse=SkeletalMesh'XIIIArmes.fpsCadavreM'
     mPrisonner=SkeletalMesh'XIIIArmes.fpsOtageM'
     PlayerViewOffsetCorpse=(X=6.000000,Y=2.500000,Z=-6.000000)
     PlayerViewOffsetPrisonner=(X=5.000000,Y=4.500000,Z=-7.500000)
     PlayerViewOffset=(X=6.000000,Y=2.500000,Z=-5.000000)
     bDelayDisplay=True
     bIgnoreDynLight=False
     DrawType=DT_Mesh
     Mesh=SkeletalMesh'XIIIArmes.fpsCadavreM'
     DrawScale=0.300000
}
