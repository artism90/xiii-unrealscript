//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SixSenseSkill extends XIIISkill;

var float fSixSenseTimer;
var bool bImOn;

//____________________________________________________________________
function PostBeginPlay()
{
    if ( XIIIPlayerPawn(Owner) != none )
    {
      XIIIPlayerPawn(Owner).SSSk = self;
    }
    GotoState('SixSStandBy');
}

//_____________________________________________________________________________
// skills don't go into selected slot
function PickupFunction(Pawn Other)
{
    Super.PickupFunction(Other);
    if ( XIIIPlayerPawn(Other) != none )
    {
      XIIIPlayerPawn(Other).SSSk = self;
    }
    GotoState('SixSStandBy');
}

//____________________________________________________________________
function ResetTimer()
{
    fSixSenseTimer = 2.0;
    if ( bImOn )
      GotoState('SixSStandBy');
}

//____________________________________________________________________
function Timer()
{
    if ( XIIIPlayerPawn(Owner) != none )
      XIIIPlayerPawn(Owner).SSSk = self;
    fSixSenseTimer -= 0.5;
    if ( fSixSenseTimer <= 0.0 )
      GotoState('ImOn');
}

//____________________________________________________________________
function Heard(Actor A);

//____________________________________________________________________
// Waiting for good conditions to be activated
State SixSStandBy
{
    function BeginState()
    {
      SetTimer(0.5, true);
      bImOn = false;
      fSixSenseTimer = 2.0;
    }
}

//____________________________________________________________________
state ImOn
{
    function BeginState()
    {
      bImOn = true;
      SetTimer(0.0,false);
      XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).bDrawSixSense=true;
      XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).ResetSixSenseSFX();
    }
    function EndState()
    {
      XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).bDrawSixSense=false;
      XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).ResetSixSenseSFX();
    }
    function Heard(Actor A)
    {
      local vector V;

// iKi: Don't use sound-display when sound-instigator is visible
// ELR No, Use it anytime
       if ( (XIIIPawn(A) != none) ) //&& (!Pawn(Owner).Controller.CanSee(XIIIPawn(A))) )
      {
        if ( vector(Pawn(owner).rotation) dot normal(A.Location-Pawn(Owner).Location) > 0.707 )
        {
          V = XIIIPlayerController(Pawn(Owner).Controller).Player.Console.WorldToScreen(A.Location - vect(0,0,1)*A.CollisionHeight);
          V.Z = 1.0 - (vSize(Owner.Location - A.Location) / Pawn(Owner).HearingThreshold) * 3;
          XIIIBaseHud(XIIIPlayerController(Pawn(Owner).Controller).MyHud).AddSixSenseFX(V);
        }
      }
    }
}



defaultproperties
{
     bHidden=False
}
