//-----------------------------------------------------------
// used for if ( ( Message == class'XIIIEndGameMessage' ) || ( Message == class'XIIIMissionCompletedMessage' ) )
//-----------------------------------------------------------
class HudEndMessage extends Info
  NotPlaceable;

var HudEndMessage NextHudMsg;
var HudEndMessage PrevHudMsg;
var int index;
const MAXDISPLAYEDMESSAGES = 7;

struct HUDLocalizedMessage
{
    var Class<LocalMessage> Message;
    var int Switch;
    var PlayerReplicationInfo RelatedPRI;
    var Object OptionalObject;
    var float EndOfLife;
    var float LifeTime;
    var bool bDrawing;
    var int numLines;
    var string StringMessage;
    var color DrawColor;
    var bool bCenter;
    var float fXSize;
};

var HUDLocalizedMessage MyMessage;
var float YP;
var bool bIsSpecial; // If true, don't erase (increase lifetime indefinetly until player access info menu)

var texture BloodTex, WinTex, NooTex, SplatshTex;
var texture WhiteTex;

CONST DBMSG=false;

// new method using auto-line cut
//____________________________________________________________________
simulated function SetUpLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( CriticalString == "" )
      CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

//    Log("EndMsg SetUpLocalizedMessage switch="$switch);
    if ( CriticalString == "" )
      RemoveMe();

    bIsSpecial = Message.Default.bIsSpecial;
    MyMessage.Message = Message;
    MyMessage.Switch = switch;
    MyMessage.RelatedPRI = RelatedPRI_1;
    MyMessage.OptionalObject = OptionalObject;
    if ( MessageTrigger(OptionalObject) != none )
    {
      MyMessage.EndOfLife = MessageTrigger(OptionalObject).fMessageDuration + Level.TimeSeconds;
      MyMessage.LifeTime = MessageTrigger(OptionalObject).fMessageDuration;
    }
    else
    {
      MyMessage.EndOfLife = Message.Default.Lifetime + Level.TimeSeconds;
      MyMessage.LifeTime = Message.Default.Lifetime;
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
}

//____________________________________________________________________
simulated function AddLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( DBMSG ) Log("MESSAGE "$self$" AddLocalizedMessage index="$index$" NextHudMsg="$NextHudMsg);

    if ( Message.default.bIsSpecial && bIsSpecial )
      return; // don't draw 2 special messages.

    if ( NextHudMsg == none )
    {
      NextHudMsg = Spawn(class'HudEndMessage',Owner);
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
    local int k; // index of the starting current strine
    local string SubString, NewCriticalString, NewCriticalCurrentString;
    local float XT,XT2,YT;
    local bool bNotFirstTime;
    local string LeftString;

    MyMessage.fXSize = C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin);

    if ( DBMSG ) Log("ProcessMessage, Len="$MyMessage.fXSize$" string="$MyMessage.StringMessage);
    j = 1;

//    XIIIBaseHUD(Owner).UseMsgFont(C);
//    C.SpaceX=0;

    SubString = MyMessage.StringMessage;
    NewCriticalString = "";
    NewCriticalcurrentString = "";
    i = InStr(SubString, " ");
    if ( DBMSG ) Log("NewCriticalCurrentString='"$NewCriticalCurrentString$"' SHOULD BE ''");
    While ( i >= 0 )
    {
      LeftString = Left(SubString, i);
      if ( DBMSG ) Log("pass I="$i$" adding '"$NewCriticalCurrentString$"' with '"$LeftString$"'");
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
      if ( DBMSG ) Log("  NewCriticalString='"$NewCriticalString$"' SubString='"$SubString$"'");
      i = InStr(SubString, " ");
    }
    // Last Word
    if ( DBMSG ) Log("Processing Last Word,  NewCriticalCurrentString='"$NewCriticalCurrentString$"' SubString='"$SubString$"'");
    NewCriticalCurrentString = NewCriticalCurrentString$SubString;
    C.StrLen(NewCriticalCurrentString, XT2, YT);
    if ( DBMSG ) Log("NewCriticalCurrentString='"$NewCriticalCurrentString$"' Len="$XT2);
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
simulated function DrawMsg(Canvas C)
{
    local float XP;
    local float XL, YL, fAlpha, XT, YT;
    Local int i,j;
    local string OutString, SubString;

    C.SpaceX = 0;
    if ( MyMessage.Switch == 0 )
      C.bTextShadow = false;
    else
      C.bTextShadow = true;

    XIIIBaseHUD(Owner).UseLargeFont(C);
    C.StrLen("A",XL,YL);

    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    if ( PrevHudMsg != none )
      YP = PrevHudMsg.YP;
    else
      YP = XIIIBaseHUD(Owner).YP;


    YP -= ( (YL+0)*MyMessage.NumLines + 8 );

    fAlpha = fMin(0.25, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;

    if ( bIsSpecial )
      fAlpha = 1.0;

// Switch == 0 -> Level Complete
// Switch == 1 -> Death killed
// Switch == 3 -> Goal InComplete
// Switch == 4 -> Player Falling

    if (fAlpha > 0.01)
    {
      C.Style = ERenderStyle.STY_Alpha;

      // Background
      // White background for all
      C.DrawColor = C.Static.MakeColor(255,255,255);
      C.DrawColor.A = 255*fAlpha;
      C.bUseBorder = false;
//        C.SetPos(XP - 6,YP - 6);
      C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin-6,YP+4-6);
      C.DrawRect(WhiteTex, MyMessage.fXSize + 8 + 12 , MyMessage.NumLines*YL + 8 + 12);

//      Log("MSG Display switch="$MyMessage.Switch);
      // then background for message w/ black border
      if ( MyMessage.switch == 0 ) // Complete
        C.DrawColor = C.static.MakeColor(65*0.4,186*0.5,212*0.7,180*fAlpha);
      else // Failure
        C.DrawColor = C.Static.MakeColor(255,150,0,180*fAlpha);
      C.BorderColor= C.Static.MakeColor(0,0,0);
      C.BorderColor.A = 255;
      C.bUseBorder = true;
//        C.SetPos(XP,YP);
      C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin,YP+4);
      C.DrawRect(WhiteTex, MyMessage.fXSize + 8 , MyMessage.NumLines*YL + 8);
      C.bUseBorder = false;

      if ( MyMessage.NumLines == 1 )
      {
        C.StrLen(MyMessage.StringMessage, XT, YT);
/*
        // BackGround
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin,YP+4);
        C.DrawColor = MyMessage.DrawColor *0.3;
        C.DrawColor.A = 90;
        C.BorderColor= MyMessage.DrawColor;
        C.BorderColor.A = 255;
        C.bUseBorder = true;
        C.DrawTile( XIIIBaseHUD(Owner).FondMsg, C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin),YT+4,0,0, XIIIBaseHUD(Owner).FondMsg.USize,XIIIBaseHUD(Owner).FondMsg.VSize );
        C.bUseBorder = false;
*/

        // Text
        C.SetPos((C.ClipX-XT)/2+1,YP+7);
        C.DrawColor = MyMessage.DrawColor*0.3;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(MyMessage.StringMessage);

        C.SetPos((C.ClipX-XT)/2,YP+6);
        C.DrawColor = MyMessage.DrawColor;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(MyMessage.StringMessage);
      }
      else
      {
        C.StrLen("A", XT, YT);

/*
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin,YP+4);
        C.DrawColor = MyMessage.DrawColor *0.3;
        C.DrawColor.A = 90;
        C.BorderColor= MyMessage.DrawColor;
        C.BorderColor.A = 255;
        C.bUseBorder = true;
        C.DrawTile( XIIIBaseHUD(Owner).FondMsg, C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin), (MyMessage.NumLines)*(YT+0)+4,0,0, XIIIBaseHUD(Owner).FondMsg.USize,XIIIBaseHUD(Owner).FondMsg.VSize );
        C.bUseBorder = false;
*/
        j = 0;
        SubString = MyMessage.StringMessage;
        i = InStr(SubString, "#N");

        while ( i >= 0 )
        {
            OutString = Left(SubString, i);

            C.StrLen(OutString, XT, YT);

            C.SetPos((C.ClipX-XT)/2+1,YP+4+j*(YT+0)+3);
            C.DrawColor = MyMessage.DrawColor*0.3;
            C.DrawColor.A = C.DrawColor.A * fAlpha;
            C.DrawText(OutString);

            C.SetPos((C.ClipX-XT)/2,YP+4+j*(YT+0)+2);
            C.DrawColor = MyMessage.DrawColor;
            C.DrawColor.A = C.DrawColor.A * fAlpha;
            C.DrawText(OutString);

            j ++;
            SubString = right(SubString, Len(SubString)-i-2);
            i = InStr(SubString, "#N");
        }

        C.StrLen(SubString, XT, YT);

        C.SetPos((C.ClipX-XT)/2+1,YP+4+j*(YT+0)+3);
        C.DrawColor = MyMessage.DrawColor*0.3;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(SubString);

        C.SetPos((C.ClipX-XT)/2,YP+4+j*(YT+0)+2);
        C.DrawColor = MyMessage.DrawColor;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(SubString);
      }
      if ( MyMessage.Switch == 1 ) // Death
      {
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin + 16,YP-8-BloodTex.vSize/2.0);
        C.DrawColor = C.static.MakeColor(255,100,0,255);
        C.DrawIcon(BloodTex, 1.0);
      }
      if ( MyMessage.Switch == 4 ) // Fall
      {
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin + 16,YP-8-SplatshTex.vSize/4.0);
        C.DrawColor = C.static.MakeColor(255,100,0,255);
        C.DrawIcon(SplatshTex, 0.5);
      }
      else if ( MyMessage.Switch == 3 ) // failure
      {
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin + 16,YP-8-NooTex.vSize/2.0+4);
        C.DrawColor = C.static.MakeColor(255,100,0,255);
        C.DrawIcon(NooTex, 0.6);
      }
      else if ( MyMessage.Switch == 0 ) // Win
      {
        C.SetPos(C.ClipX * XIIIBaseHUD(Owner).LeftMargin + 16,YP-8-WinTex.vSize/2.0);
        C.DrawColor = C.static.MakeColor(255,255,255,255);
        C.DrawIcon(WinTex, 1.0);
      }
    }
    else
      fAlpha = 0.0;

    if ( NextHudMsg != none )
      NextHudMsg.DrawMsg(C);
    else
      XIIIBaseHUD(Owner).YP = YP;

    if ( fAlpha == 0.0 )
      ReMoveMe();

    C.SpaceX = 0;
}

//____________________________________________________________________
function RemoveMe()
{
    if (PrevHudMsg == none)
    {
      if (NextHudMsg != none)
      {
        XIIIBaseHUD(Owner).HudEndMsg = NextHudMsg;
        NextHudMsg.PrevHudMsg = none;
      }
      else
        XIIIBaseHUD(Owner).HudEndMsg = none;
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
     BloodTex=Texture'XIIICine.effets.vignetteblood'
     WinTex=Texture'XIIICine.effets.impactpoing2A'
     NooTex=Texture'XIIICine.effets.death4'
     SplatshTex=Texture'XIIICine.effets.craash'
     WhiteTex=Texture'XIIIMenu.HUD.blanc'
}
