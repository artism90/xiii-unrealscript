//-----------------------------------------------------------
//
//-----------------------------------------------------------
class MuzzleFlashAttachment extends InventoryAttachment;

var int TickCount;     // How long to display it

var(MuzzleFlash) bool bUseRandRotation;
var EDrawType MemDrawType;
var MuzzleLight MFLight;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    DebugLog("FLASH"@self@"SPAWN Owner="$Owner);
    MemDrawType = DrawType;
    SetDrawType(DT_None);
    MFLight = Spawn(class'MuzzleLight',self,,Location);
}

//_____________________________________________________________________________
simulated event Timer()
{
    SetDrawType(DT_None);
}

//_____________________________________________________________________________
simulated function Flash()
{
    DebugLog("   FLASHED"@self);
    GotoState('Visible');
}

//_____________________________________________________________________________
simulated state Visible
{
    simulated event Tick(float Delta)
    {
      if ( (DrawType==DT_None) && (TickCount > 3) )
      {
        MFLight.Flash(Instigator.Location + Instigator.EyePosition() + vector(Instigator.GetViewRotation())*70);
        SetDrawType(MemDrawType);
        DebugLog("   - FLASH"@self@"Tick SetDrawType"@DrawType);
      }
      else
        DebugLog("   - FLASH"@self@"Tick DT("$DrawType$")");
      if (TickCount>5)
        gotoState('');
      TickCount++;
    }

    simulated function EndState()
    {
      DebugLog("   FLASH"@self@"EndState DT("$DrawType$")");
      SetDrawType(DT_None);
    }

    simulated function BeginState()
    {
      local Rotator R;
      local vector V;

      DebugLog("   FLASH"@self@"BeginState Location"@Location);
      TickCount=0;

      R = RelativeRotation;
      if ( bUseRandRotation )
        R.Roll = Rand(65535);
      SetRelativeRotation(R);

      V=Default.DrawScale3D;
      V.X += frand() - 0.5;
      V.Y += frand() - 0.5;

      SetDrawScale3D(v);
    }
}

simulated event Destroyed()
{
    DebugLog("FLASH"@self@"DESTROY");
    Super.Destroyed();
    MFLight.Destroy();
}



defaultproperties
{
     bUseRandRotation=True
     bAcceptsProjectors=False
     bTearOff=True
     bUnlit=True
     RemoteRole=ROLE_None
}
