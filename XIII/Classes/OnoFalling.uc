//-----------------------------------------------------------
//
//-----------------------------------------------------------
class OnoFalling extends Effects;

var texture ATex, HTex;
var int index;
var vector RefLocation;
var OnoFalling NextOF;

var float fDestroyingtimer;

const SPACEDIST=80.0;
const SIZEDECREASE=0.20;
const SPACEINCREASE=5.0;

//_____________________________________________________________________________
event PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( OnoFalling(Owner) != none )
      index = OnoFalling(Owner).index + 1;

    if (index == 0)
      RefLocation = Owner.Location;

    if ( Index < 5 )
      Texture = ATex;
    else
      Texture = HTex;

    SetDrawScale(fmax(0.0,2.0 - (Index - 2)*SIZEDECREASE));
//    Log(self$" PostBeginPlay, index="$Index$" texture="$texture);
}

//_____________________________________________________________________________
function Tick(float deltatime)
{
    local vector vPos, vDir;
    local float RefDrawScale, RefDist;

    if ( Index == 0 )
      RefDist = SPACEDIST + 100.0;
    else
      RefDist = SPACEDIST;
    RefDrawScale = 2.0 - (Index - 3)*SIZEDECREASE;

//    Log(self$" index="$Index$" Location="$Location$" RefDrawScale="$RefDrawScale);
    if ( (NextOF == none) && (RefDrawScale > 0.0) && (vSize(Location - RefLocation) > (RefDist + (Index-5)*SPACEINCREASE)) )
    {
      NextOF = Spawn(class'OnoFalling', self,,RefLocation);
      NextOF.RefLocation = RefLocation;
    }
    vPos = Owner.Location + normal(Location - Owner.Location) * (RefDist + (Index-5)*SPACEINCREASE);
    SetLocation(vPos);
}

//_____________________________________________________________________________
function OnoEnd()
{
    GotoState('OnoEnding');
    if (NextOF != none)
      NextOF.OnoEnd();
}

//_____________________________________________________________________________
event Destroyed()
{
    if (NextOF != none)
      NextOF.Destroy();
}

//_____________________________________________________________________________
state OnoEnding
{
    function Tick(float deltatime)
    {
      local vector vPos, vDir;
      local float RefDrawScale, RefDist;

      fDestroyingtimer += Deltatime*10.0;
      if ( Index == 0 )
        RefDist = SPACEDIST + 100.0;
      else
        RefDist = SPACEDIST;
      RefDrawScale = 2.0 - (Index - 3 + fDestroyingtimer)*SIZEDECREASE;

      if ( RefDrawScale < 0.0 )
        destroy();
      else
        SetDrawScale(RefDrawScale);
      vPos = Owner.Location + normal(Location - Owner.Location) * (RefDist + (Index-5)*SPACEINCREASE);
      SetLocation(vPos);
    }
}



defaultproperties
{
     ATex=Texture'XIIIMenu.SFX.ALetterM'
     HTex=Texture'XIIIMenu.SFX.HLetterM'
     DrawScale=2.000000
}
