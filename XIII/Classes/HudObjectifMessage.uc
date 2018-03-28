//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudObjectifMessage extends Info
  NotPlaceable;

var HudObjectifMessage NextHudMsg;
var HudObjectifMessage PrevHudMsg;
var int index;
var texture WhiteTex;
var texture ValidatedTex;

struct HUDLocalizedMessage
{
    var Class<LocalMessage> Message;
    var int Switch;
    var PlayerReplicationInfo RelatedPRI;
    var Object OptionalObject;
    var float EndOfLife;
    var float StartOfLife;
    var float LifeTime;
    var bool bDrawing;
    var int numLines;
    var string StringMessage;
    var color DrawColor;
    var bool bCenter;
    var float fXSize;
};

var HUDLocalizedMessage MyMessage;
var float YP, XL, YL;
var float CharCount;                        // special display for main objective

//var bool bIsSpecial; // If true, don't erase (increase lifetime indefinetly until player access info menu)
var bool bIsHudCartoonFX;

CONST DBMSG=false;
CONST MAXDISPLAYEDMESSAGES = 7;

// new method using auto-line cut
//____________________________________________________________________
simulated function SetUpLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( CriticalString == "" )
      CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

    if ( DBMSG ) Log(" SetUpLocalizedMessage"@switch@CriticalString);
    if ( CriticalString == "" )
      RemoveMe();

//    bIsSpecial = Message.Default.bIsSpecial;
    MyMessage.Message = Message;
    MyMessage.Switch = switch;
    MyMessage.RelatedPRI = RelatedPRI_1;
    MyMessage.OptionalObject = OptionalObject;
    MyMessage.StartOfLife = Level.TimeSeconds;
    if ( MessageTrigger(OptionalObject) != none )
    {
      MyMessage.EndOfLife = MessageTrigger(OptionalObject).fMessageDuration + Level.TimeSeconds;
      MyMessage.LifeTime = MessageTrigger(OptionalObject).fMessageDuration;
    }
    else
    {
      MyMessage.EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
      MyMessage.LifeTime = Message.Default.Lifetime;
      if ( (Switch >= 8) && (PrevHudMsg != none) ) // delay 1 second before display
        MyMessage.EndOfLife += 1.0;
    }
    MyMessage.bDrawing = true;
    MyMessage.NumLines = 0; // should be initialized first time we draw the string
    MyMessage.StringMessage = CriticalString;
    MyMessage.DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
    MyMessage.bCenter = Message.default.bCenter;
    MyMessage.fXSize = 0; // should be initialized first time we draw the string

    if ( PrevHudMsg != none )
      index = PrevHudMsg.index + 1;
    else
      index = 0;

    if ( DBMSG ) log("MESSAGE index="$index@"'"$CriticalString$"'");
    if ( index >= MAXDISPLAYEDMESSAGES )
      PrevHudMsg.DestroyFirstMessage();

    bIsHudCartoonFX = true;

    if ( DBMSG ) Log("MESSAGE "$self$" SetUpLocalizedMessage index="$index);
}

//____________________________________________________________________
simulated function AddLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( DBMSG ) Log("MESSAGE "$self$" AddLocalizedMessage index="$index$" NextHudMsg="$NextHudMsg);

//    if ( Message.default.bIsSpecial && bIsSpecial )
//      return; // don't draw 2 special messages.

    if ( NextHudMsg == none )
    {
      NextHudMsg = Spawn(class'HudObjectifMessage',Owner);
      NextHudMsg.PrevHudMsg = self;
      NextHudMsg.SetUpLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
    }
    else
      NextHudMsg.AddLocalizedMessage( Message, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject, CriticalString );
}

//____________________________________________________________________
function ProcessMessage(Canvas C)
{
    Local int i; // Index of the processed space
    local int j; // number of lines
    local int k; // index of the starting current string
    local string SubString, NewCriticalString, NewCriticalCurrentString;
    local float XT,XT2,YT;
    local bool bNotFirstTime;
    local string LeftString;

    C.StrLen("A",XL,YL);

    MyMessage.fXSize = C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin);
    MyMessage.fXSize *= 0.7;

    j = 1;

    SubString = MyMessage.StringMessage;
    NewCriticalString = "";
    NewCriticalcurrentString = "";
    i = InStr(SubString, " ");
    //if ( DBMSG ) Log("NewCriticalCurrentString='"$NewCriticalCurrentString$"' SHOULD BE ''");
    While ( i >= 0 )
    {
      LeftString = Left(SubString, i);
      //if ( DBMSG ) Log("pass I="$i$" adding '"$NewCriticalCurrentString$"' with '"$LeftString$"'");
      NewCriticalCurrentString = NewCriticalCurrentString$LeftString;
      C.StrLen(NewCriticalCurrentString, XT2, YT);
      if ( DBMSG ) Log("NewCriticalCurrentString='"$NewCriticalCurrentString$"' Len="$XT2);
      if ( (XT2 >= MyMessage.fXSize) || (XT2 == XT) )
      {
        NewCriticalString = NewCriticalString$"#N"$LeftString;
        NewCriticalcurrentString = LeftString$" ";
        j++;
      }
      else
      {
        if ( bNotFirstTime )
          NewCriticalString = NewCriticalString$" "$LeftString;
        else
          NewCriticalString = LeftString;
        NewCriticalcurrentString = NewCriticalcurrentString$" ";
      }
      bNotFirstTime=true;
      XT = XT2;
      SubString = right(SubString, len(SubString) - i - 1);
      //if ( DBMSG ) Log("  NewCriticalString='"$NewCriticalString$"' SubString='"$SubString$"'");
      i = InStr(SubString, " ");
    }
    // Last Word
    //if ( DBMSG ) Log("Processing Last Word,  NewCriticalCurrentString='"$NewCriticalCurrentString$"' SubString='"$SubString$"'");
    NewCriticalCurrentString = NewCriticalCurrentString$SubString;
    C.StrLen(NewCriticalCurrentString, XT2, YT);
    //if ( DBMSG ) Log("NewCriticalCurrentString='"$NewCriticalCurrentString$"' Len="$XT2);
    if ( (XT2 >= MyMessage.fXSize) || (XT == XT2) )
    {
      NewCriticalString = NewCriticalString$"#N"$SubString;
      j++;
    }
    else
    {
      if ( bNotFirstTime )
        NewCriticalString = NewCriticalString$" "$SubString;
      else
        NewCriticalString = SubString;
    }
    if ( DBMSG ) Log("  NewCriticalString='"$NewCriticalString$"'");

    MyMessage.NumLines = j;
    MyMessage.StringMessage = NewCriticalString;
}

//____________________________________________________________________
simulated function DrawHudCartoonSFXMsg(Canvas C)
{
    local float XP, TmpH;
    local float XT, YT;
    Local int i,j;
    local string OutString, SubString;
    local bool bSkip;
    local int NbChars;
    local float fAlpha;

    if ( MyMessage.Switch >= 8 )
    { // delay display
      if ( MyMessage.EndOfLife - Level.TimeSeconds > MyMessage.LifeTime )
        return;
      MyMessage.Switch -= 8;
    }
    if ( CharCount == 0.0 )
    {
      MyMessage.StartOfLife = Level.TimeSeconds;
      CharCount = 0.01;
    }
    else
      CharCount = Level.TimeSeconds - MyMessage.StartOfLife;
    NbChars = int(charcount*50.0);
    if ( DBMSG ) Log("CharCount = "$NbChars); // 5 characters by second ?

    if ( PrevHudMsg != none )
      YP = PrevHudMsg.YP + 8;
    else if ( NextHudMsg != none )
      YP = C.ClipY/2.0 + 80 - NextHudMsg.MyMessage.NumLines*YL;
    else
      YP = C.ClipY/2.0 + 80;
    XP = ( C.ClipX - MyMessage.fXSize )/2.0 - 4;

    if ( XIIIBaseHUD(Owner).HudCartoonSFX ) // extend life only if SFX still active
    {
      fAlpha = 1.0;
      MyMessage.EndOfLife = MyMessage.Lifetime + Level.TimeSeconds;
    }
    else
    {
      fAlpha = fMin(0.25, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;
      fAlpha = fMin(0.5882, fAlpha);
    }

    if ( fAlpha > 0.1 )
    {
      C.Style = ERenderStyle.STY_Alpha;
      // Background
      // White background for all
      C.DrawColor = C.Static.MakeColor(255,255,255);
      C.DrawColor.A = 255*fAlpha;
      C.bUseBorder = false;
      C.SetPos(XP - 6,YP - 6);
      C.DrawRect(WhiteTex, MyMessage.fXSize + 8 + 12 , MyMessage.NumLines*YL + 8 + 12);

//      Log("MSG Display switch="$MyMessage.Switch);
      // then background for message w/ black border
      if ( MyMessage.switch == 2 ) // antigoal
        C.DrawColor = C.Static.MakeColor(255,150,0,180*fAlpha);
      else  if ( MyMessage.switch == -1 ) // Help Msg
        C.DrawColor = C.static.MakeColor(65,186,212,180*fAlpha);
      else
        C.DrawColor = C.Static.MakeColor(0,0,0,30);
      C.BorderColor= C.Static.MakeColor(0,0,0);
      C.BorderColor.A = 255;
      C.bUseBorder = true;
      C.SetPos(XP,YP);
      C.DrawRect(WhiteTex, MyMessage.fXSize + 8 , MyMessage.NumLines*YL + 8);
      C.bUseBorder = false;

      // Text
      C.DrawColor= C.Static.MakeColor(0,0,0, 255*fAlpha);
      C.bTextShadow = true;
      j = 0;
      SubString = MyMessage.StringMessage;
      i = InStr(SubString, "#N");
      while ( i >= 0 )
      {
        OutString = Left(SubString, i);
        C.StrLen(OutString, XT, YT);
        if ( Len(OutString) > NbChars )
        {
          bSkip = true;
          OutString = left(OutString, NbChars);
        }
        C.SetPos(XP + (MyMessage.fXSize + 8 - XT)/2.0 + 2, YP + 4 + j*YT);
        C.DrawText(OutString);
        if ( MyMessage.Switch == 1 ) // objective complete
        {
//          Log("MSG Display text for completed");
          C.SetPos(XP + (MyMessage.fXSize + 8 - XT)/2.0 + 2, YP + 4 + j*YT + YT*0.52);
          C.StrLen(OutString, XT, YT);
          C.DrawRect(WhiteTex, XT , 2);
        }
        j ++;
        if ( bSkip )
          i = -1;
        else
        {
          NbChars -= Len(OutString);
          SubString = right(SubString, Len(SubString)-i-2);
          i = InStr(SubString, "#N");
        }
      }
      C.StrLen(SubString, XT, YT);
      if ( !bSkip )
      {
        if (Len(SubString) > NbChars)
        {
          bSkip = true;
          SubString = left(SubString, NbChars);
        }
        C.SetPos(XP + (MyMessage.fXSize + 8 - XT)/2.0 + 2, YP + 4 + j*YT);
        C.DrawText(SubString);
        if ( MyMessage.Switch == 1 ) // objective complete
        {
//          Log("MSG Display text for completed");
          C.SetPos(XP + (MyMessage.fXSize + 8 - XT)/2.0 + 2, YP + 4 + j*YT + YT*0.52);
          C.StrLen(SubString, XT, YT);
          C.DrawRect(WhiteTex, XT , 2);
        }
      }
    }
    else
      fAlpha = 0;

    YP += YL*MyMessage.NumLines + 12;

    if ( !bSkip && (NextHudMsg != none) )
    {
      if ( bIsHudCartoonFX )
        NextHudMsg.bIsHudCartoonFX = true;
      NextHudMsg.DrawMsg(C);
    }
    else
      XIIIBaseHUD(Owner).YP = YP;

    if ( MyMessage.EndOfLife < Level.TimeSeconds )
      ReMoveMe();

    C.SpaceX = 0;
}

//____________________________________________________________________
simulated function DrawMsg(Canvas C)
{
    local float XP, TmpH;
    local float fAlpha, XT, YT, MXT;
    Local int i,j;
    local string OutString, SubString;

    C.SpaceX = 1;
    XIIIBaseHUD(Owner).UseMsgFont(C);

    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    if ( MyMessage.Switch == -1 ) // Help message
    {
      if ( ((PrevHudMsg != none) && (PrevHudMsg.MyMessage.Switch != -1)) || ((NextHudMsg != none) && (NextHudMsg.MyMessage.Switch != -1)) )
      { // Delay Help Message (MessageTriggers) until no objectives drawn
        MyMessage.EndOfLife = MyMessage.Lifetime + Level.TimeSeconds;
        if ( NextHudMsg != none )
        {
          if ( PrevHudMsg != none )
            YP = PrevHudMsg.YP + 8;
          else if ( NextHudMsg != none )
            YP = C.ClipY/2.0 + 80 - NextHudMsg.MyMessage.NumLines*YL;
          else
            YP = C.ClipY/2.0 + 80;
          NextHudMsg.DrawMsg(C);
        }
        return;
      }
    }
    if( XIIIBaseHUD(Owner).HudCartoonSFX || bIsHudCartoonFX )
    {
      bIsHudCartoonFX = true;
      DrawHudCartoonSFXMsg(C);
      return;
    }
}

//____________________________________________________________________
function RemoveMe()
{
    if (PrevHudMsg == none)
    {
      if (NextHudMsg != none)
      {
        XIIIBaseHUD(Owner).HudObjMsg = NextHudMsg;
        NextHudMsg.PrevHudMsg = none;
      }
      else
        XIIIBaseHUD(Owner).HudObjMsg = none;
    }
    else
    {
      PrevHudMsg.NextHudMsg = NextHudMsg;
      if ( NextHudMsg != none )
        NextHudMsg.PrevHudMsg = PrevHudMsg;
    }
    Destroy();
}

//____________________________________________________________________
function DestroyFirstMessage()
{
    if ( (index == 0) || (PrevHudMsg == none) )
    {
      index = -1;
      NextHudMsg.ActualizeIndex();
      RemoveMe();
    }
    else
      PrevHudMsg.DestroyFirstMessage();
}

//____________________________________________________________________
function ActualizeIndex()
{
    if ( PrevHudMsg != none )
      Index = PrevHudMsg.index + 1;
    if ( NextHudMsg != none )
      NextHudMsg.ActualizeIndex();
}



defaultproperties
{
     WhiteTex=Texture'XIIIMenu.HUD.blanc'
     ValidatedTex=Texture'XIIIMenu.HUD.Valid'
}
