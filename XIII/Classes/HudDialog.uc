//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudDialog extends Info
  NotPlaceable;

struct HUDLocalizedMessage
{
    var Class<LocalMessage> Message;
    var int Switch;
    var Object OptionalObject;
    var float EndOfLife;
    var float LifeTime;
    var int numLines;
    var string StringMessage;
    var color DrawColor;
    var float fXSize;
};

var HUDLocalizedMessage MyMessage;
var float YP;

// Optimization, global vars to comput only once
var float XL, YL;
var Pawn SpeakingPawn;                // the pawn that speak this sentence
//var float NameXL, NameYL;

var color BackGrndColor, TextColor, WarnColor;   // Because we may change them upon character speaking

var bool bSpecialBackGround;          // Special display for HF/HP/Unlocalized voices
var Texture NoiseTex;                 // texture for above display

//____________________________________________________________________
simulated function SetUpLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( CriticalString == "" )
      CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if ( CriticalString == "" )
      RemoveMe();

    MyMessage.Message = Message;
    MyMessage.Switch = Switch;
    MyMessage.OptionalObject = OptionalObject;
    MyMessage.EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
    MyMessage.LifeTime = Message.Default.Lifetime;
    MyMessage.NumLines = 0; // should be initialized first time we draw the string
    MyMessage.StringMessage = CriticalString;
    MyMessage.DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
    MyMessage.fXSize = 0; // should be initialized first time we draw the string
}

//____________________________________________________________________
FUNCTION ProcessMessage(Canvas C)
{
    local int i; // Index of the processed space
    local int linesCounter; // number of lines
    local string SubString, NewCriticalString, NewCriticalCurrentString;
    local float XT,XT2,YT;
    local string LeftString;

    // Max message width
    MyMessage.fXSize = C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin) - 80*C.ClipX/640.0;

    linesCounter = 1;
    SubString = MyMessage.StringMessage;
    NewCriticalString = "";
    NewCriticalcurrentString = "";
    i = InStr(SubString, " ");

    while ( i >= 0 )
    {
      LeftString = Left(SubString, i);
      NewCriticalCurrentString = NewCriticalCurrentString$LeftString;
      C.StrLen(NewCriticalCurrentString, XT2, YT);

      if ( (XT2 >= MyMessage.fXSize-20) || (XT2 == XT) )
      {
        NewCriticalString = NewCriticalString$"#N"$LeftString;
        NewCriticalcurrentString = LeftString$" ";
        linesCounter++;
      }
      else
      {
        NewCriticalString = NewCriticalString@LeftString;
        NewCriticalcurrentString = NewCriticalcurrentString$" ";
      }
      XT = XT2;
      SubString = Mid (SubString,i+1); //right(SubString, len(SubString) - i - 1);

      i = InStr(SubString, " ");
    }
// Last Word

    NewCriticalCurrentString = NewCriticalCurrentString$SubString;
    C.StrLen(NewCriticalCurrentString, XT2, YT);

    if ( (XT2 >= MyMessage.fXSize-20) || (XT == XT2) )
    {
      NewCriticalString = NewCriticalString$"#N"$SubString;
      linesCounter++;
    }
    else
    {
      NewCriticalString = NewCriticalString@SubString;
    }

    MyMessage.NumLines = LinesCounter;
    MyMessage.StringMessage = NewCriticalString;
    if ( MyMessage.NumLines == 1 )
    { // Only one line, change FXSize
//      C.StrLen(MyMessage.StringMessage, XT, YT);
      MyMessage.fXSize = fMin(XT2 + YT, MyMessage.fXSize);
    }

    // this can be done to optimize only if the UseDialogFont() can't change the font upon res change
    C.StrLen("A",XL,YL);
    SpeakingPawn = Pawn(MyMessage.OptionalObject);
//    if ( SpeakingPawn != none )
//      C.StrLen(XIIIPawn(SpeakingPawn).PawnName, NameXL, NameYL);

    switch ( MyMessage.Switch )
    {
      Case 2:
        bSpecialBackGround = true;
      Case 0:
        BackGrndColor = default.BackGrndColor;
        TextColor = MyMessage.DrawColor;
        break;
      Case 1:
        BackGrndColor = MyMessage.DrawColor;
        TextColor = default.BackGrndColor;
        break;
      Case 3:
        BackGrndColor = WarnColor;
        TextColor = MyMessage.DrawColor;
        break;
      Case 4: // XIIIDialogMessages, spoken by XIII
      Case 5:
        BackGrndColor = MyMessage.DrawColor;
        TextColor = default.BackGrndColor;
        break;
      Default:
        BackGrndColor = default.BackGrndColor;
        TextColor = MyMessage.DrawColor;
        break;
    }
}

/* // ELR Old way using text scrolling / Line limitation (unoptimized)
//____________________________________________________________________
simulated FUNCTION DrawDlg(Canvas C)
{
    local float XP;
    local float XL, YL, fAlpha, XT, YT, NameXL, NameYL;
    local int i,j;
    local string OutString, SubString;
    local pawn SpeakingPawn;
    local float dSAT;
    local float dSTAB;
    local float dist;
    local float offset;
    local int NumVisibleLines;
    local int OldClipX,OldClipY,OldOriginX,OldOriginY;
    const MaxVisibleLines=5;
    local vector vT, vT2;
    local bool bMemSmooth;

    C.SpaceX=0;
    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    if (MyMessage.NumLines>MaxVisibleLines)
      NumVisibleLines=MaxVisibleLines;
    else
      NumVisibleLines=MyMessage.NumLines;

    C.StrLen("A",XL,YL);

    YP = XIIIBaseHUD(Owner).UpMargin * C.ClipY;
    XP = XIIIBaseHUD(Owner).LeftMargin * C.ClipX;

// iKi : visual RollOff
    SpeakingPawn=Pawn(MyMessage.OptionalObject);
    if (SpeakingPawn!=none)
    {
      dSAT=SpeakingPawn.VoicesSaturationDistance;
      dSTAB=SpeakingPawn.VoicesStabilisationDistance;
      dist=VSize(SpeakingPawn.Location-XIIIGameInfo(Level.Game).MapInfo.XIIIPawn.Location);

//      if (dist<dSAT)
//        fAlpha=1.0;
//      else
//        if (dist>dSTAB)
//          fAlpha=0.0;
//        else
//          fAlpha= (dist-dSTAB)/(dSAT-dSTAB);
        fAlpha=1.0;
    }
    else
      fAlpha=1.0;
// iKi : END

    fAlpha *= fMin(0.25, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;

    if (fAlpha > 0.01)
    {
      C.SetPos(XP-3,YP-3);
      C.Style = ERenderStyle.STY_Alpha;
      C.SetDrawColor(220,220,220,255);
      C.BorderColor = C.Static.makecolor(0,0,0,255);
      C.bUseBorder = true;
//      C.bDialogWindow = true;
      C.DrawTile(XIIIBaseHUD(Owner).FondDlg, MyMessage.fXSize ,YL*NumVisibleLines+6, 0, 0, XIIIBaseHUD(Owner).FondDlg.USize, XIIIBaseHUD(Owner).FondDlg.VSize);
      C.bUseBorder = false;
//      C.bDialogWindow = false;

      if ( ( SpeakingPawn != none ) && (Level.TimeSeconds < SpeakingPawn.LastRenderTime + 0.1) )
//      if ( (SpeakingPawn != none) && FastTrace(SpeakingPawn.Location, XIIIGameInfo(Level.Game).MapInfo.XIIIPawn.EyePosition()) )
      {
        vT = XIIIBaseHUD(Owner).XIIIPlayerOwner.Player.Console.WorldToScreen(SpeakingPawn.Location);
        vT2.Y = YP-3+YL*NumVisibleLines+2;

        if ( vT.X < ( C.ClipX*XIIIBaseHUD(Owner).LeftMargin ) )
          vT2.x = C.ClipX*XIIIBaseHUD(Owner).LeftMargin;
        else if ( vT.X > C.ClipX*XIIIBaseHUD(Owner).LeftMargin + MyMessage.fXSize -XIIIBaseHUD(Owner).FlechDlg.USize )
          vT2.x = C.ClipX*XIIIBaseHUD(Owner).LeftMargin + MyMessage.fXSize -XIIIBaseHUD(Owner).FlechDlg.USize;
        else
          vT2.x = vT.x;


        // Display PawnName
        C.StrLen(XIIIPawn(SpeakingPawn).PawnName,NameXL,NameYL);
        C.Style = ERenderStyle.STY_Normal;
        C.SetPos(XP, YP-NameYL);
        C.SetDrawColor(220,220,220,255);
        C.bUseBorder = true;
        C.DrawTile(XIIIBaseHUD(Owner).FondDlg, NameXL+8, NameYL, 0, 0, XIIIBaseHUD(Owner).FondDlg.USize, XIIIBaseHUD(Owner).FondDlg.VSize);
        C.bUseBorder = false;
        C.SetPos(XP+4, YP-NameYL);
        C.SetDrawColor(0,0,0,255);
        C.DrawText(XIIIPawn(SpeakingPawn).PawnName);
        // Display comic arrow
        C.SetPos(vT2.x, vT2.y);
        C.Style = ERenderStyle.STY_Alpha;
        C.SetDrawColor(220,220,220,255);
        bMemSmooth = C.bNoSmooth;
        C.bNoSmooth = true;

        if ( C.CurX > MyMessage.fXSize/2.0 )
//        if ( C.CurX > C.ClipX/2.0 )
          C.DrawTile(XIIIBaseHUD(Owner).FlechDlg, XIIIBaseHUD(Owner).FlechDlg.USize ,XIIIBaseHUD(Owner).FlechDlg.VSize, 0, 0, -XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize);
        else
          C.DrawTile(XIIIBaseHUD(Owner).FlechDlg, XIIIBaseHUD(Owner).FlechDlg.USize ,XIIIBaseHUD(Owner).FlechDlg.VSize, 0, 0, XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize);
        C.bNoSmooth = bMemSmooth;
      }

      C.Style = ERenderStyle.STY_Alpha;

      j = 0;
      SubString = MyMessage.StringMessage;
      OldOriginX=C.OrgX;
      OldOriginY=C.OrgY;
      OldClipX=C.ClipX;
      OldClipY=C.ClipY;

      C.SetOrigin(XP,YP);
      C.SetClip(C.ClipX,YL*NumVisibleLines);

      if (MyMessage.NumLines>NumVisibleLines)
      {
        offset=(1-(MyMessage.EndOfLife - Level.TimeSeconds)/MyMessage.LifeTime);
        if (offset<0.15)
          offset=0;
        else
          if (offset>0.80)
            offset=YL*(MyMessage.NumLines-NumVisibleLines);
          else
            offset=YL*(MyMessage.NumLines-NumVisibleLines)*(offset-0.15)/0.65;
//            offset=YL*(MyMessage.NumLines-NumVisibleLines)*(1-(MyMessage.EndOfLife - Level.TimeSeconds)/MyMessage.LifeTime);
      }
      else
        offset=0;
      do
      {
        i = InStr(SubString, "#N");
        if (i>0)
          OutString = Left(SubString, i);
        else
          OutString = SubString;

        C.StrLen(OutString, NameXL, NameYL);
        C.SetPos((MyMessage.fXSize-10.0)/2.0 - NameXL/2.0, j*YL - offset );
        C.DrawColor = MyMessage.DrawColor * 0.15;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawTextClipped(OutString);

        j ++;
        SubString = right(SubString, Len(SubString)-i-2);
      } until ( i < 0 );

      C.SetOrigin(OldOriginX,OldOriginY);
      C.SetClip(OldClipX,OldClipY);
    }
    else
      fAlpha = 0.0;

//    if ( fAlpha == 0.0 ) // ELR can't use anymore with fadeout because must be able to start dialog and approch later (don't remove it if it's not really finished)
    if ( (MyMessage.EndOfLife <= Level.TimeSeconds)  )
      ReMoveMe();
}
*/

//____________________________________________________________________
simulated function DrawDlg(Canvas C)
{
    local float XP;
    local float fAlpha;
    local int i,j;
    local string OutString, SubString;
    local vector vT, vT2;
    local bool bMemSmooth;
    local bool bMirrorDlgArrow;

    C.SpaceX = 0;
    XIIIBaseHUD(Owner).UseDialogFont(C);
    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    YP = XIIIBaseHUD(Owner).UpMargin * C.ClipY;
    XP = XIIIBaseHUD(Owner).LeftMargin * C.ClipX + 80*C.ClipX/640.0;

    fAlpha = fMin(0.25, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;

    if (fAlpha > 0.01)
    {
      C.Style = ERenderStyle.STY_Alpha;
      C.SetPos(XP-5,YP-5);
      C.DrawColor = TextColor;
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, MyMessage.fXSize + 4 ,YL*MyMessage.NumLines+6 + 4);
      C.SetPos(XP-3,YP-3);
      C.DrawColor = BackGrndColor;
      C.DrawRect(XIIIBaseHUD(Owner).FondDlg, MyMessage.fXSize ,YL*MyMessage.NumLines+6);
      if ( bSpecialBackGround )
      { // Draw special background there
        C.SetPos(XP-3,YP-3);
        C.DrawColor = BackGrndColor;
        C.DrawColor.A = 130;
        C.DrawTile(NoiseTex, MyMessage.fXSize ,YL*MyMessage.NumLines+6,0,0,NoiseTex.USize*(Frand()+2),NoiseTex.VSize*(Frand()+2));
      }

      if ( SpeakingPawn != none )
      {

/* Activate to enable pawn name display
        if ( SpeakingPawn.PawnName != "" )
        { // Display Name
          C.SetPos(XP-2, YP-NameYL-2);
          C.DrawColor = TextColor;
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, NameXL+8 + 4, NameYL + 4);
          C.SetPos(XP, YP-NameYL);
          C.DrawColor = BackGrndColor;
          C.DrawRect(XIIIBaseHUD(Owner).FondDlg, NameXL+8, NameYL);
          C.SetPos(XP+4, YP-NameYL);
          C.DrawColor = TextColor;
          C.DrawText(SpeakingPawn.PawnName);
        }
*/

        if ((SpeakingPawn.Location-XIIIBaseHUD(Owner).PlayerOwner.Pawn.Location) dot vector(XIIIBaseHUD(Owner).PlayerOwner.Rotation) > 0.707)
        { // Display comic arrow
          vT = XIIIBaseHUD(Owner).PlayerOwner.Player.Console.WorldToScreen(SpeakingPawn.Location);
          if ( vT != vect(0,0,0) )
          {
            vT2.Y = YP-3+YL*MyMessage.NumLines+2;
            if ( vT.x < XP )
              vT2.x = XP;
            else if ( vT.X > (XP + MyMessage.fXSize - XIIIBaseHUD(Owner).FlechDlg.USize) )
            {
              vT2.x = XP + MyMessage.fXSize - XIIIBaseHUD(Owner).FlechDlg.USize;
              bMirrorDlgArrow = true;
            }
            else
              vT2.x = vT.x;

            C.SetPos(vT2.x, vT2.y);
            C.DrawColor = BackGrndColor;
            bMemSmooth = C.bNoSmooth;
            C.bNoSmooth = true;
            if ( bMirrorDlgArrow )
              C.DrawTile(XIIIBaseHUD(Owner).FlechDlg, XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize, 0, 0, XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize);
            else
              C.DrawTile(XIIIBaseHUD(Owner).FlechDlg, XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize, 0, 0, -XIIIBaseHUD(Owner).FlechDlg.USize, XIIIBaseHUD(Owner).FlechDlg.VSize);
            C.bNoSmooth = bMemSmooth;
          }
        }
      }

      C.DrawColor = TextColor;
      C.DrawColor.A = C.DrawColor.A * fAlpha;
      C.bTextShadow = false;
      j = 0;
      SubString = MyMessage.StringMessage;
      do
      {
        i = InStr(SubString, "#N");
        if (i>0)
          OutString = Left(SubString, i);
        else
          OutString = SubString;

        C.SetPos(XP + 2, YP + j*YL + 1);
        C.DrawText(OutString);
        j ++;
        SubString = right(SubString, Len(SubString)-i-2);
      }
      until ( i < 0 );
    }
    else
      fAlpha = 0.0;

    if ( (MyMessage.EndOfLife <= Level.TimeSeconds)  )
      ReMoveMe();
}

//____________________________________________________________________
function RemoveMe()
{
    XIIIBaseHUD(Owner).HudDlg = none;
    Destroy();
}



defaultproperties
{
     BackGrndColor=(B=220,G=220,R=220,A=255)
     WarnColor=(B=20,G=150,R=255,A=255)
     NoiseTex=Texture'XIIICine.Bruit'
}
