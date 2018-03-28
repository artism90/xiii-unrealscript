//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudState extends Info
  NotPlaceable;

struct HUDLocalizedMessage
{
    var Class<LocalMessage> Message;
    var int Switch;
//    var PlayerReplicationInfo RelatedPRI;
    var Object OptionalObject;
    var float EndOfLife;
    var float LifeTime;
//    var bool bDrawing;
    var int numLines;
    var string StringMessage;
    var color DrawColor;
//    var bool bCenter;
    var float fXSize;
};

var HUDLocalizedMessage MyMessage;
var float YP;

// New method using auto-line cut
//____________________________________________________________________
simulated function SetUpLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( CriticalString == "" )
      CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
    CriticalString=Caps(CriticalString);

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
/*
simulated function AddLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( NextHudDlg == none )
    {
      NextHudDlg = Spawn(class'HudDialog',Owner);
      NextHudDlg.PrevHudDlg = self;
      NextHudDlg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    }
    else
    {
      NextHudDlg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    }
}*/

//____________________________________________________________________
FUNCTION ProcessMessage(Canvas C)
{
    local int i; // Index of the processed space
    local int linesCounter; // number of lines
    local string SubString, NewCriticalString, NewCriticalCurrentString;
    local float XT,XT2,YT;
    local string LeftString;

    MyMessage.fXSize = C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin) * 0.7;
    linesCounter = 1;
    XIIIBaseHUD(Owner).UseMsgFont(C);
    C.SpaceX=0;
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
      SubString = Mid (SubString,i+1);
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
      NewCriticalString = NewCriticalString@SubString;

    MyMessage.NumLines = linesCounter;
    MyMessage.StringMessage = NewCriticalString;
}

//____________________________________________________________________
simulated function DrawStt(Canvas C)
{
    Local float XL,YL,XT,YT,XP;
    local float fAlpha;
    local int i,j;
    local string OutString, SubString;

    if( XIIIBaseHUD(Owner).HudCartoonSFX )
        return;

    C.SpaceX=0;
    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    XIIIBaseHUD(Owner).UseMsgFont(C);
    C.StrLen("A",XL,YL);

    YP = C.ClipY/2.0 - YL*MyMessage.NumLines -8;
    XP = (C.ClipX - MyMessage.fXSize -8)/2.0;

    fAlpha = fMin(0.10, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;

    if (fAlpha > 0.01)
    {
      C.SetPos(XP,YP);
      C.Style = ERenderStyle.STY_Alpha;
      C.DrawColor = MyMessage.DrawColor * 0.3;
      C.DrawColor.A = 150 * fAlpha;
      C.BorderColor = MyMessage.DrawColor;
      C.BorderColor.A = 255 * fAlpha;
      C.bUseBorder = true;
      C.DrawTile(XIIIBaseHUD(Owner).FondMsg, MyMessage.fXSize+8 ,YL*MyMessage.NumLines+8, 0, 0, XIIIBaseHUD(Owner).FondMsg.USize, XIIIBaseHUD(Owner).FondMsg.VSize);
      C.bUseBorder = false;

      C.Style = ERenderStyle.STY_Alpha;

      j = 0;
      SubString = MyMessage.StringMessage;
      do
      {
        i = InStr(SubString, "#N");

        if (i>0)
          OutString = Left(SubString, i);
        else
          OutString = SubString;

        C.StrLen(OutString, XT, YT);
        C.SetPos((C.ClipX-XT)/2+2,YP+4+j*(YT+0)+2);
        C.DrawColor = MyMessage.DrawColor;
        C.DrawColor.A = 255 * fAlpha;
        C.DrawText(OutString);

        j ++;
        SubString = right(SubString, Len(SubString)-i-2);
      } until ( i < 0 );
    }
    else
      fAlpha = 0.0;

    if ( (MyMessage.EndOfLife <= Level.TimeSeconds)  )
      ReMoveMe();
    C.SpaceX=0;
    C.bCenter = false;
}

function RemoveMe()
{
    XIIIBaseHUD(Owner).HudStt = none;
    Destroy();
}

//    HudDlgFont=font'XIIIfonts.PoliceF16'


defaultproperties
{
}
