//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Chronometre extends XIIIItems;

var int BTime;                    // Beginning time
var int CountDownStart;           // CountDown start (time to reach 0 from spawn)
var int WarnTime;                 // Next time a warning message will be sent
var localized string ChronoSeconds, ChronoSecond; //, TimeOver;

//_____________________________________________________________________________
function PostBeginPlay()
{
    ResetTimer(CountDownStart);
}

//_____________________________________________________________________________
function ReSetTimer(float fTime)
{
    BTime=Level.TimeSeconds + fTime;
    SetWarnTime();
    SetTimer(0.5, true);
}

//_____________________________________________________________________________
function SetWarnTime()
{
    // Warntime is ne next time we'll warn the player.
    if ( (BTime-Level.TimeSeconds) > 70 )
    { // Every Minute
      WarnTime=int((BTime-Level.TimeSeconds)/60)*60;
    }
    else if ( (BTime-Level.TimeSeconds) > 11 )
    { // Every 10 seconds
      WarnTime=int((BTime-Level.TimeSeconds)/10)*10;
    }
    else if ( (BTime-Level.TimeSeconds) > 6 )
    { // Every 5 seconds
      WarnTime=int((BTime-Level.TimeSeconds)/5)*5;
    }
    else if ( (BTime-Level.TimeSeconds) > -2 )
    { // Every Second
      WarnTime=int(BTime-Level.TimeSeconds);
    }
}

//_____________________________________________________________________________
function Timer()
{
    local XIIIPlayerController PC;

    PC = XIIIPlayerController(Instigator.Controller);

    if ( (BTime-Level.TimeSeconds) < -2)
    {
      SetTimer(0.0, false);
      TriggerEvent('ChronoEnded', self, Pawn(Owner));
      return;
    }

    if ( XIIIBaseHUD(PC.MyHud) != none )
      XIIIBaseHUD(PC.MyHUD).AddChronoDisplay(GetTimeString());

/*
    if ( int(BTime-Level.TimeSeconds) < WarnTime )
    {
      if ( PC == none )
        return;
      PC.ReceiveLocalizedMessage(class'XIIISoloMessage', 3, PC.PlayerReplicationInfo, none, self);
      SetWarnTime();
    }
*/
}

//_____________________________________________________________________________
function string GetTimeString()
{
    local XIIIPlayerController PC;

    PC = XIIIPlayerController(Instigator.Controller);

    if ( (BTime-Level.TimeSeconds) > 0 )
    {
/*      if ( int(BTime-Level.TimeSeconds)+1 == 1 )
      {
//         if ( XIIIBaseHUD(PC.MyHUD).bNumericDisplay )
//             return ""$int(BTime-Level.TimeSeconds)+1;
//         else
             return ""$int(BTime-Level.TimeSeconds)+1$ChronoSecond;
      }
      else
//         if ( XIIIBaseHUD(PC.MyHUD).bNumericDisplay )
//             return ""$int(BTime-Level.TimeSeconds)+1;
//         else
             return ""$int(BTime-Level.TimeSeconds)+1$ChronoSeconds;*/
	    if ( (BTime-Level.TimeSeconds+1) <= 10 )
		{
			XIIIBaseHUD(PC.MyHUD).bDrawChronoWithWarningColors=true;
			if ( Level.TimeSeconds-int(Level.TimeSeconds)>0.5 )
				return right("00"$(int(BTime-Level.TimeSeconds)+1),3)$"s";
			else
				return "";
		}
		else
		{
			XIIIBaseHUD(PC.MyHUD).bDrawChronoWithWarningColors=false;
			return right("00"$(int(BTime-Level.TimeSeconds)+1),3)$"s";
		}
    }
	XIIIBaseHUD(PC.MyHUD).bDrawChronoWithWarningColors=true;
    return "000s";
}

//_____________________________________________________________________________
event Destroyed()
{
    // time display is deleted when chrono is destroyed

	local XIIIPlayerController PC;

    PC = XIIIPlayerController(Instigator.Controller);
	
	if ( XIIIBaseHUD(PC.MyHud) != none )
		XIIIBaseHUD(PC.MyHud).bDrawChrono = false;
		
	Super.Destroyed();
}

//_____________________________________________________________________________
Simulated function UseMe()
{
    local XIIIPlayerController PC;

    PC = XIIIPlayerController(Instigator.Controller);
    if ( PC == none )
      return;

    PC.ReceiveLocalizedMessage(class'XIIISoloMessage', 3, PC.PlayerReplicationInfo, none, self);
}

//     Icon=texture'XIIISounds.Icons.IIChrono'
//     TimeOver=" Time Over !"

defaultproperties
{
     CountDownStart=60
     ChronoSeconds=" seconds"
     ChronoSecond=" second"
     bCanHaveMultipleCopies=True
     bAutoActivate=True
     ExpireMessage="Chronometre was used."
     Charge=1
     PlayerViewOffset=(X=8.600000,Y=6.000000,Z=-5.800000)
     ItemName="CHRONOMETRE"
}
