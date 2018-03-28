//-----------------------------------------------------------
//
//-----------------------------------------------------------
class LaserTrigger extends XIIITriggers;

var bool bOn;
var() float fFrequency;
var XIIIPlayerPawn PawnIn;
var() Emitter LaserEmmiter1, LaserEmmiter2, BlueBallAmitter;
var int SNDIndex1, SNDIndex2;

var sound hSoundOn;
var sound hSoundOff;

//_____________________________________________________________________________
function PostBeginPlay()
{
    local LaserTrigger LT;

    foreach allactors(class'LaserTrigger', LT)
    {
      if (LT != none)
      {
        if ( LT.SNDIndex1 == 1 )
        {
          SNDIndex1 = 3;
          SNDIndex2 = 4;
        }
        else
        {
          SNDIndex1 = 1;
          SNDIndex2 = 2;
        }
        break;
      }
    }
//    Log("~~~ Init for"@self@" SNDIndex1="$SNDIndex1@"SNDIndex2="$SNDIndex2@"hSoundOn="$hSoundOn@"hSoundOff="$hSoundOff);
}

//_____________________________________________________________________________
auto state On
{
    function BeginState()
    {
      SetTimer(fFrequency, true);
    }

    event Timer()
    {
      bOn = !bOn;
      if ( bOn && (PawnIn != none) && !PawnIn.bIsDead )
      {
//        Log("Ending Game because PawnIn '"$PawnIn$"' in LaserTrigger ");
        Level.Game.EndGame( PlayerController(PawnIn.Controller).PlayerReplicationInfo, "PlayerKilled" );
        Gotostate('');
      }
      LaserEmmiter1.Emitters[0].Disabled = !bOn;
      LaserEmmiter2.Emitters[0].Disabled = !bOn;
      if ( BlueBallAmitter != none )
        BlueBallAmitter.Emitters[0].Disabled = !bOn;
      if ( bOn )
      {
//        Log("~~~ Playing sounds hSoundOn="$hSoundOn);
        LaserEmmiter1.PlaySound(hSoundOn, SNDIndex1);
        LaserEmmiter2.PlaySound(hSoundOn, SNDIndex2);
      }
      else
      {
//        Log("~~~ Playing sounds hSoundOff="$hSoundOff);
        LaserEmmiter1.PlaySound(hSoundOff, SNDIndex1);
        LaserEmmiter2.PlaySound(hSoundOff, SNDIndex2);
      }
//      Log("Laser "$self$" "$bOn);
    }

    event Touch( Actor Other )
    {
//      Log("Laser "$self$" Touched by "$Other$" in state "$bOn);
      if ( (XIIIPawn(Other) != none) && XIIIPawn(Other).IsPlayerPawn() && !XIIIPawn(Other).bIsDead )
      {
        PawnIn = XIIIPlayerPawn(Other);
        if ( bOn )
        {
          Level.Game.EndGame( PlayerController(PawnIn.Controller).PlayerReplicationInfo, "PlayerKilled" );
          Gotostate('');
        }
      }
    }
    event UnTouch( Actor Other )
    {
//      Log("Laser "$self$" UnTouched by "$Other$" in state "$bOn);
      PawnIn = none;
    }

/*    function tick(float DT)
    {
        local actor A;

        foreach touchingactors(class'actor', A)
          if (A != none)
            Log(self@"touching"@A);
    }*/
}



defaultproperties
{
     bOn=True
     fFrequency=4.000000
     hSoundOn=Sound'XIIIsound.Ambient__Hual2Laser.Hual2Laser__hLaserOn'
     hSoundOff=Sound'XIIIsound.Ambient__Hual2Laser.Hual2Laser__hLaserOff'
     CollisionRadius=210.000000
}
