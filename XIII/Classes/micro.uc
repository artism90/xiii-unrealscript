//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Micro extends XIIIItems;

// Charges for the micro are the tenth of seconds you are allowed missing the target you must listen.
// should be 30 = 3.0 seconds

var bool bZoomed;           // are we zoomed.
var bool bMaxZoomed;        // are we zoomed as much as we can ? (used for Sound).
var sound hZoomSound;       // Zooming sound (param 0 = begin, 2 = stop zooming in, 1 = zoom out)
var float ScopeFOV;         // FOV to use in zoom
var Pawn ListenTarget;      // Target to listen
var bool bCanCauseGameOver; // just to allow this for a period of time while spying
var bool bActivated;        // to allow check of sound (not causing gameover, used for training period. If not activated, no timer nor effects)

var sound hMicroSound;      // used to handle micro sfxs
var int MicroState;
var int FakeCharge;         //
VAR XIIIBaseHud HUD;

// MicroState =
    // 0 = do nothing
    // 1 = Wait for didacticiel01 event to be triggered
    // 2 = didacticiel01 triggered

//var localized string sMicroTooFar;
//var localized string sMicroFailure;

var bool bTriggeredMissInTrainMode;

EVENT BeginState()
{
//	LOG("MICRO ==>"@GetStateName() @"MicroState =" @MicroState );
}

//_____________________________________________________________________________
// Called in Beginstate of Downweapon
FUNCTION EndUse()
{
	LOCAL Info dm;

	if ( bCanCauseGameOver )
	{
		Charge = 0;
		UsedUp();
		StopVoice();
		SetTimer2(0,false);
		Instigator.PlaySound(hMicroSound, 0 /*int(bMaxZoomed)*/, /*int(fFactor**/10000/*)*/);
		foreach DynamicActors(class'Info',dm)
		{
			if ( dm.IsA('DialogueManager') )
				dm.Destroy();
		}

	}
	if (bZoomed)
	{
//		PlayerController(Instigator.Controller).ToggleZoom();
		bZoomed=false;
		bMaxZoomed=false;
	}
	XIIIPlayerController(Pawn(Owner).Controller).EndZoom();
}

//_____________________________________________________________________________
FUNCTION bool ShouldDrawCrosshair(Canvas C)
{
	return !bZoomed;
}

//_____________________________________________________________________________
FUNCTION bool PutDown()
{
/*	if ( bCanCauseGameOver )
	{
		Charge = 0;
		UsedUp();
		return false;
	}
	else
	{*/
		bChangeItem=true;
		return true;
//	}
}

//_____________________________________________________________________________
// This is called when a usable inventory item has used up it's charge.
FUNCTION UsedUp()
{
	SetTimer2(0.0, false);
	if ( bCanCauseGameOver )
	{
		Level.Game.EndGame( XIIIPlayercontroller(XIIIPawn(Owner).controller).PlayerReplicationInfo, "GoalIncomplete" );
//		GotoState('DownItem');
		return;
	}

	if ( Pawn(Owner) != None )
	{
		bActivatable = false;
		XIIIPlayercontroller(XIIIPawn(Owner).controller).cNextItem();
		if ( (XIIIPawn(Owner).PendingItem == None) || (XIIIPawn(Owner).PendingItem == self) )
			XIIIPlayercontroller(XIIIPawn(Owner).controller).NextWeapon();
		
		XIIIPawn(Owner).ChangedWeapon();
		if (Level.Game.StatLog != None)
			Level.Game.StatLog.LogItemDeactivate(Self, XIIIPawn(Owner));
		Instigator.ReceiveLocalizedMessage( MessageClass, 0, None, None, Self.Class );
	}
	Instigator.PlayRolloffSound(DeactivateSound, self);
	Destroy();
}

//_____________________________________________________________________________
State InUse
{
    EVENT BeginState()
    {
		Global.BeginState(); //
		PlayUsing();
//		bRendered=false;
//		bHidden=true;
    }
	
    FUNCTION Activate()
	{
	}
	
    EVENT AnimEnd(int Channel)
    {
		UseMe();
		if ( bChangeItem )
		{
			GotoState('DownItem');
			return;
		}
		GotoState('Zooming');
    }
}

//_____________________________________________________________________________
STATE Zooming
{
	EVENT BeginState()
	{
		Global.BeginState(); //

		bHidden=!bHidden;
		RefreshDisplaying();
		bRendered=false;
		
		if ( bZoomed )
		{
			PlayerController(Instigator.Controller).ToggleZoom();
			Instigator.PlayRolloffSound(hZoomSound, self, 1);
			if ( bActivated )
				GoToState('Listening');
			else
				GotoState('Idle');
		}
		else
		{
			PlayerController(Instigator.Controller).StartZoom();
			PlayerController(Instigator.Controller).ZoomLevel = 0.3;
			PlayerController(Instigator.Controller).SetFov(FClamp(90.0 - (0.3 * 88.0), 1, 170));
			Instigator.PlayRolloffSound(hZoomSound, self, 0);
		}
		bZoomed=false;
		bMaxZoomed=false;
	}

	EVENT Tick(float DeltaTime)
	{
		if (PlayerController(Instigator.Controller).FovAngle < ScopeFov)
		{
			PlayerController(Instigator.Controller).StopZoom();
			PlayerController(Instigator.Controller).SetFov(ScopeFov);
			Instigator.PlayRolloffSound(hZoomSound, self, 2);
//			SetTimer(0.0,False);
			bZoomed=true;
			bMaxZoomed=true;
			SetTimer2(0.1, true);
			if ( bActivated )
				GoToState('Listening');
			else
				GoToState('Idle');
		}
	}

    FUNCTION Activate()
	{
	}
}

FUNCTION string StrTime( int i )
{
	LOCAL int iMillisec, iSec;

	iSec = i/10;
	iMilliSec = i - iSec*10;
	return iSec$":"$iMilliSec$"0";

}

FUNCTION DisplayChrono( string str )
{
//	XIIIBaseHUD(Playercontroller(Pawn(Owner).Controller).MyHud)
	HUD.AddChronoDisplay( str );
}

EVENT Timer2()
{
	LOCAL float fFactor;
	LOCAL VECTOR /*X,Y,Z,*/ v2;

	if ( !bActivated && !bCanCauseGameOver )
	{
		// reseted, end sequence
		GotoState('Idle');
		SetTimer2(0.0, false);
	}
//		GetAxes(Pawn(Owner).GetViewRotation(), X, Y, Z);
	v2 = (ListenTarget.Location + ListenTarget.EyePosition()) - (Pawn(Owner).Location + Pawn(Owner).EyePosition());
	fFactor = normal(V2) dot Vector(Pawn(Owner).GetViewRotation());
	fFactor *= (1-fClamp( (vSize(v2)-3100)*0.002, 0, 1));
	Instigator.PlaySound(hMicroSound, int(bMaxZoomed), int(fFactor*10000));
	
	if ( bCanCauseGameOver )
	{
		if ( (fFactor < 0.9997) || !bZoomed )
		{
			if ( bZoomed )
				Charge -= 1;
			else
				Charge -=2;

			if (Charge >= 0)
			{
				HUD.bDrawChronoWithWarningColors=(Charge<21);
				DisplayChrono( StrTime( Charge ) );
			}
			else
			{
				UsedUp();
				HUD.bDrawChronoWithWarningColors=true;
				if ( Level.TimeSeconds-int(Level.TimeSeconds)>0.5 )
					DisplayChrono( "0:00" /*sMicroFailure*/ );
				else
					DisplayChrono( "" );
			}
		}
		else
		{
			Charge = min(default.Charge, Charge+1);
			HUD.bDrawChronoWithWarningColors=(Charge<21);
			DisplayChrono( StrTime( Charge ) );
		}
	}
	else
	{
		if ( MicroState == 0 )
		{
			if ( (fFactor < 0.9997) || !bZoomed )
			{
				SetTimer(0.0, false);
				HUD.bDrawChronoWithWarningColors=true;
				if ( Level.TimeSeconds-int(Level.TimeSeconds)>0.5 )
					DisplayChrono( "?:??" /*sMicroTooFar*/ );
				else
					DisplayChrono( "" );
			}
			else
			{
				MicroState ++;
				SetTimer(0.5, false);
			}
		}
		else if ( (fFactor < 0.9997) || !bZoomed )
		{
			if ( MicroState == 1 )
			{
				FakeCharge = min(default.FakeCharge, FakeCharge+1);
				HUD.bDrawChronoWithWarningColors=true;
				if ( Level.TimeSeconds-int(Level.TimeSeconds)>0.5 )
					DisplayChrono( "?:??" /*sMicroTooFar*/ );
				else
					DisplayChrono( "" );
			}
			else // we ARE in state 2, can't be otherwise
			{
				if ( bZoomed )
					FakeCharge -= 1;
				else
					FakeCharge -=2;
				if (FakeCharge >= 0)
				{
					if ( !bTriggeredMissInTrainMode && FakeCharge<21 )
					{
						bTriggeredMissInTrainMode=true;
						XIIIGameInfo(Level.Game).MapInfo.SetGoalComplete(97);
					}
					HUD.bDrawChronoWithWarningColors=(FakeCharge<21);
					DisplayChrono( StrTime( FakeCharge ) );
				}
				else
				{
					FakeCharge=-1;
					HUD.bDrawChronoWithWarningColors=true;
					if ( Level.TimeSeconds-int(Level.TimeSeconds)>0.5 )
						DisplayChrono( "0:00" /*sMicroFailure*/ );
					else
						DisplayChrono( "" );
				}
			}
		}
		else
		{
			FakeCharge = min(default.FakeCharge, FakeCharge+1);
			HUD.bDrawChronoWithWarningColors=(FakeCharge<21);
			DisplayChrono( StrTime( FakeCharge ) );
		}
	}
}

EVENT Timer()
{
	if ( MicroState == 1 )
	{
		MicroState ++;
		Fakecharge = Default.FakeCharge;
		TriggerEvent('Didacticiel01', self, Pawn(Owner));
	}
}

//_____________________________________________________________________________
STATE Listening extends Idle
{
	EVENT BeginState()
	{
		Global.BeginState();
		SUPER.BeginState();
		FakeCharge = Default.Charge;
		HUD = XIIIBaseHUD(Playercontroller(Pawn(Owner).Controller).MyHud);
	}

	EVENT EndState()
	{
		if ( bCanCauseGameOver )
			Level.Game.EndGame( XIIIPlayercontroller(XIIIPawn(Owner).controller).PlayerReplicationInfo, "GoalIncomplete" );
	}
}



defaultproperties
{
     hZoomSound=Sound'XIIIsound.Guns__Zoom.Zoom__hZoom'
     ScopeFOV=7.000000
     bCanCauseGameOver=True
     hMicroSound=Sound'XIIIsound.SpecActions__MicroCanon.MicroCanon__hMicroCanon'
     FakeCharge=30
     MeshName="XIIIArmes.FpsMicroM"
     IHand=IH_2H
     hSelectItemSound=Sound'XIIIsound.SpecActions__MicroCanon.MicroCanon__hDegaine'
     hDownItemSound=Sound'XIIIsound.SpecActions__MicroCanon.MicroCanon__hRengaine'
     ZCrosshair=Texture'XIIIMenu.HUD.ZMireSniperA'
     ZCrosshairDot=Texture'XIIIMenu.HUD.MireCouteau'
     IconNumber=29
     sItemName="Micro"
     bAutoActivate=True
     bActivatable=True
     ExpireMessage="Zoomer was used."
     InventoryGroup=8
     bDisplayableInv=True
     PickupClassName="XIII.MicroPick"
     Charge=30
     PlayerViewOffset=(X=8.600000,Y=6.000000,Z=-5.800000)
     BobDamping=0.975000
     ThirdPersonRelativeLocation=(X=27.000000,Y=-3.000000,Z=-13.000000)
     ThirdPersonRelativeRotation=(Roll=32768)
     AttachmentClass=Class'XIII.MicroAttach'
     ItemName="MICRO"
     Rotation=(Roll=-15536)
}
