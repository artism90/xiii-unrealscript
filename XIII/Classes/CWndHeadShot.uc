// Specific FX to be displayed when a HeadShot occured
//-----------------------------------------------------------
class CWndHeadShot extends CWndBase;

var int iPhase;
var XIIIPawn Killed;  // should be the dying guy
var texture CornerTexture;
var vector campos1, campos2, campos3, MemDir;
var rotator RotMem;

var bool bAnimateInRealTime;
CONST WNDSIZE=128;
CONST SFXDURATION=3.0;
CONST SPACEX=17;

//_____________________________________________________________________________
event PostBeginPlay()
{
    Super.PostBeginPlay();
    if ( (Level.Game != none) && (Level.Game.DetailLevel > 1) )
    {
//      Log("Plateform ="$XIIIGameInfo(Level.Game).PlateForme@"XBOX, enable tick");
      bAnimateInRealTime = true;
//      Enable('Tick'); // why dis/en able don't work ?
    }
    else
    {
//      Log("Plateform ="$XIIIGameInfo(Level.Game).PlateForme@"NOT XBOX, disable tick");
      bAnimateInRealTime = false;
//      Disable('Tick'); // why dis/en able don't work ?
    }
}

//_____________________________________________________________________________
//SOUTHEND Moving frame code
event Tick(float DeltaT)
{
    if ( bAnimateInRealTime )
    {
      HideUnwanted();
      MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = true;
      switch (iPhase)
      {
        Case 1:
          MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + campos1, RotMem, 20, FilterColor,HighLight,FilterTexture );
        break;
        Case 2:
          MyHudForFX.CWndMat.Update( WNDSIZE, 0, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + campos2, RotMem, 17, FilterColor,HighLight,FilterTexture );
        break;
        Case 3:
          MyHudForFX.CWndMat.Update( 0, WNDSIZE, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + campos3, RotMem, 14, FilterColor,HighLight,FilterTexture );
        break;
      }
      RestoreUnwanted();
    }
}

//_____________________________________________________________________________
event Timer()
{
    local HudCartoonWindow temp;
    if (iPhase==0)
    {
      if (MyHudForFX.HudWnd!=none)
      {
        Destroy();
        return;
      }
    }
    else
    {
      temp = MyHudForFX.HudWnd;
      while (temp != none)
      {
        if (!temp.bLowPriority)
        {
          Destroy();
          return;
        }
        temp = temp.NextHudWnd;
      }
    }

    iPhase ++;
    HideUnwanted();
    MyHudForFX.PlayerOwner.Pawn.bOwnerNoSee = true;
    switch (iPhase)
    {
      Case 1:
        FilterColor.A = 200;
        MemDir = normal(killed.Location - owner.location);
        campos1 = vect(0,0,3) - 120*MemDir;
        RotMem = rotator(killed.Location - owner.location);
        MyHudForFX.CWndMat.Update( 0, 0, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + CamPos1, RotMem, 20, FilterColor,HighLight,FilterTexture );
        Owner.PlaySound(hCWndSound);
        AddWnd(0, 0, WNDSIZE-10, (WNDSIZE-10)*3/4, MyHudForFX.CWndMat, 0, WNDSIZE*1/8, WNDSIZE, WNDSIZE*3/4, SFXDURATION, true);
        SetTimer(0.2, false);
        break;
      case 2:
        FilterColor.A = 200;
        campos2 = campos1 - vect(0,0,1);
        MyHudForFX.CWndMat.Update( WNDSIZE, 0, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + CamPos2, RotMem, 17, FilterColor,HighLight,FilterTexture );
        Owner.PlaySound(hCWndSound);
        AddWnd(WNDSIZE-10+SPACEX, 0, WNDSIZE, WNDSIZE*3/4, MyHudForFX.CWndMat, WNDSIZE, WNDSIZE*1/8, WNDSIZE, WNDSIZE*3/4, SFXDURATION, true);
        SetTimer(0.2, false);
        break;
      Case 3:
        FilterColor.A = 200;
        campos3 = campos1 - vect(0,0,2);
        MyHudForFX.CWndMat.Update( 0, WNDSIZE, WNDSIZE, WNDSIZE, killed.GetBoneCoords('X Head').Origin + CamPos3, RotMem, 14, FilterColor,HighLight,FilterTexture );
        Owner.PlaySound(hCWndSound);
        AddWnd(WNDSIZE-10+SPACEX+WNDSIZE+SPACEX, 0, WNDSIZE+10, (WNDSIZE+10)*3/4, MyHudForFX.CWndMat, 0, WNDSIZE*9/8, WNDSIZE, WNDSIZE*3/4, SFXDURATION, true);
        if ( Killed.MyDeathOno != none )
        {
          CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
          AddWnd(WNDSIZE-10+SPACEX+WNDSIZE+SPACEX-60, -50, Killed.MyDeathOno.Emitters[0].Texture.USize, Killed.MyDeathOno.Emitters[0].Texture.VSize*3/4, Killed.MyDeathOno.Emitters[0].Texture, 0, 0, Killed.MyDeathOno.Emitters[0].Texture.USize, Killed.MyDeathOno.Emitters[0].Texture.VSize, SFXDURATION, true);
          CWndBorderColor = class'canvas'.static.MakeColor(255,0,0,255);
        }

        // send splash at the same time to synchronize erasing windows after headshot
        if ( Level.Game.GoreLevel == 0 )
        {
          CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
          if ( Level.bLonePlayer && Level.Game.bAlternateMode )
            CornerTexture = texture'XIIICine.effets.vignetteblood_2';
          AddWnd(WNDSIZE-10+SPACEX+WNDSIZE+SPACEX+WNDSIZE+10-48, 0+(WNDSIZE+10)*3/4-48, CornerTexture.USize, CornerTexture.VSize, CornerTexture, 0, 0, CornerTexture.USize, CornerTexture.VSize, SFXDURATION-0.2, true);
          CWndBorderColor = class'canvas'.static.MakeColor(255,0,0,255);
        }
        SetTimer(0.2, false);
        break;
      Case 4:
/*
        CWndBorderColor = class'canvas'.static.MakeColor(0,0,0,0);
        if ( Level.bLonePlayer && Level.Game.bAlternateMode )
          CornerTexture = texture'XIIICine.effets.vignetteblood_2';
        AddWnd(WNDSIZE-10+SPACEX+WNDSIZE+SPACEX+WNDSIZE+10-48, 0+(WNDSIZE+10)*3/4-48, CornerTexture.USize, CornerTexture.VSize, CornerTexture, 0, 0, CornerTexture.USize, CornerTexture.VSize, SFXDURATION-0.2, true);
        CWndBorderColor = class'canvas'.static.MakeColor(255,0,0,255);
        SetTimer(0.2, false);
        break;
      Case 5:
*/
        Destroy();
        break;
    }
    RestoreUnwanted();
}


defaultproperties
{
     CornerTexture=Texture'XIIICine.effets.vignetteblood'
     hCWndSound=Sound'XIIIsound.Interface__VignettesFx.VignettesFx__hHeadshot'
     FilterColor=(B=0,G=116,R=244,A=150)
     HighLight=0.300000
     CWndSoundType=0
}
