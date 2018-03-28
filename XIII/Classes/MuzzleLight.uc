//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MuzzleLight extends Light;

var int TickCount;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
//    Log(Self@"postbeginplay");
    Super.PostBeginPlay();
    LightType=LT_None;
    RefreshLighting();
    Disable('Tick');
}

//_____________________________________________________________________________
simulated function Flash(vector Loc)
{
//    Log(Self@"flash");
    SetLocation(Loc);
    LightType=LT_Steady;
    RefreshLighting();
    TickCount=0;
    Enable('Tick');
}

//_____________________________________________________________________________
simulated event Tick(float dT)
{
//    Log(Self@"tick tickcount="$TickCount);
    TickCount ++;
    if ( (TickCount > 2) || (dT > 1.0/20.0) ) // leave sfx 2 frames or only one if frame rate < 20 fps
    {
      LightType=LT_None;
      RefreshLighting();
      Disable('Tick');
    }
}



defaultproperties
{
     bDecor1Light=False
     bDecor2Light=False
     bDecor3Light=False
     bActorLight=True
     bDecor4Light=False
     bDecor5Light=False
     bDecor6Light=False
     bDecor7Light=False
     bDecor8Light=False
     bDecor9Light=False
     bDecor10Light=False
     bStatic=False
     bNoDelete=False
     bDynamicLight=True
     bTearOff=True
     bMovable=True
     bIgnoredByShadows=True
     RemoteRole=ROLE_None
     LightBrightness=255
     LightHue=34
     LightSaturation=34
     LightRadius=12
}
