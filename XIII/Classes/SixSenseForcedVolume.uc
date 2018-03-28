//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SixSenseForcedVolume extends Volume;

var SixSenseSkill SSSk;
var XIIIPlayerPawn PawnInside;

//_____________________________________________________________________________
auto state WaitForTouch
{
    function Touch (actor Other)
    {
      Log(self@"touched by"@other);

      if ( XIIIPlayerPawn(Other) != none )
      {
        if ( XIIIPlayerPawn(Other).SSSk == none )
        {
          XIIIPlayercontroller(XIIIPlayerPawn(Other).Controller).ConsoleCommand("ImAnAlien");
          PawnInside = XIIIPlayerPawn(Other);
          SSSk = XIIIPlayerPawn(Other).SSSk;
          SetTimer(0.05, true);
        }
        else
        {
          SSSk = XIIIPlayerPawn(Other).SSSk;
          SetTimer(0.05, true);
        }
      }
    }
    function UnTouch (actor Other)
    {
      Log(self@"untouched by"@other);

      if (XIIIPlayerPawn(Other) != none )
      {
        if ( XIIIPlayerPawn(Other).SSSk != none )
        {
          SSSk = XIIIPlayerPawn(Other).SSSk;
          XIIIPlayerPawn(Other).SSSk = none;
          SSSk.Destroy();
          SetTimer(0.0, false);
        }
      }
    }
}

//_____________________________________________________________________________
function Timer()
{
    if ( SSSk != none )
      SSSk.Timer();
    else
      SSSk = PawnInside.SSSk;

}



defaultproperties
{
     bStatic=False
     bAlwaysRelevant=True
}
