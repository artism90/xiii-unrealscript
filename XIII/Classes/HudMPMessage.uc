//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HudMPMessage extends Info
 NotPlaceable;

var HudMPMessage NextHudMsg;
var HudMPMessage PrevHudMsg;
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

var int iNbItems;                        // For multiple pickup messages to keep track of nb items in msg
var array< class<Pickup> > PickupClass;  // For multiple pickup messages to keep track of present items in msg

CONST DBMSG=false;


// new method using auto-line cut
//____________________________________________________________________
simulated function SetUpLocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString )
{
    if ( Message == class'XIIIPickupMessage' )
    {
      PickupClass.Length = PickupClass.Length + 1;
      PickupClass[iNbItems] = class<Pickup>(OptionalObject);
    }

    if ( CriticalString == "" )
      CriticalString = Message.Static.GetString(Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);

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
    if ( (Switch >= 0) && (Switch < 5) && (Switch != 4) )
      MyMessage.DrawColor = Message.Static.GetColor(Switch, RelatedPRI_1, RelatedPRI_2);
    else
      MyMessage.DrawColor = class'Canvas'.static.MakeColor(65,186,212,255);
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
      NextHudMsg = Spawn(class'HudMPMessage',Owner);
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

    MyMessage.fXSize = C.ClipX * (1.0 - XIIIBaseHUD(Owner).RightMargin - XIIIBaseHUD(Owner).LeftMargin) / 2;

    if ( DBMSG ) Log("ProcessMessage, Len="$MyMessage.fXSize$" string="$MyMessage.StringMessage);
    j = 1;

    XIIIBaseHUD(Owner).UseMsgFont(C);
    C.SpaceX=0;

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

    if ( MyMessage.NumLines == 0 )
      ProcessMessage(C);

    XP = C.ClipX * ( 1.0 - XIIIBaseHUD(Owner).RightMargin );

    if ( PrevHudMsg != none )
      YP = PrevHudMsg.YP;
    else
      YP = C.ClipY * XIIIBaseHUD(Owner).UpMargin;

    XIIIBaseHUD(Owner).UseMsgFont(C);
    C.StrLen("A",XL,YL);

    fAlpha = fMin(0.25, MyMessage.EndOfLife - Level.TimeSeconds) * 4.0;

    if ( bIsSpecial )
      fAlpha = 1.0;

    if (fAlpha > 0.01)
    {
      C.Style = ERenderStyle.STY_Alpha;

      if ( MyMessage.NumLines == 1 )
      {
        C.StrLen(MyMessage.StringMessage, XT, YT);

        C.SetPos(XP-XT+1,YP+1);
        C.DrawColor = MyMessage.DrawColor*0.3;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(MyMessage.StringMessage);

        C.SetPos(XP-XT,YP);
        C.DrawColor = MyMessage.DrawColor;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(MyMessage.StringMessage);
      }
      else
      {
        j = 0;
        SubString = MyMessage.StringMessage;
        i = InStr(SubString, "#N");

        while ( i >= 0 )
        {
            OutString = Left(SubString, i);

            C.StrLen(OutString, XT, YT);

            C.SetPos(XP-XT+1,YP+j*(YT+2)+1);
            C.DrawColor = MyMessage.DrawColor*0.3;
            C.DrawColor.A = C.DrawColor.A * fAlpha;
            C.DrawText(OutString);

            C.SetPos(XP-XT,YP+j*(YT+2));
            C.DrawColor = MyMessage.DrawColor;
            C.DrawColor.A = C.DrawColor.A * fAlpha;
            C.DrawText(OutString);

            j ++;
            SubString = right(SubString, Len(SubString)-i-2);
            i = InStr(SubString, "#N");
        }

        C.StrLen(SubString, XT, YT);

        C.SetPos(XP-XT+1,YP+j*(YT+2)+1);
        C.DrawColor = MyMessage.DrawColor*0.3;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(SubString);

        C.SetPos(XP-XT,YP+j*(YT+2));
        C.DrawColor = MyMessage.DrawColor;
        C.DrawColor.A = C.DrawColor.A * fAlpha;
        C.DrawText(SubString);
      }
    }
    else
      fAlpha = 0.0;

    YP += ( (YL+2)*MyMessage.NumLines);

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
        XIIIBaseHUD(Owner).HudMPMsg = NextHudMsg;
        NextHudMsg.PrevHudMsg = none;
      }
      else
        XIIIBaseHUD(Owner).HudMPMsg = none;
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
     iNbItems=1
}
