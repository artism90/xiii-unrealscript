class XIIIMenuLiveJoinStartWindow extends XIIILiveWindow;

//var string MapList[64];
//var int MaxMaps, onMap;

//var GUIListBox listbox;
//var GUISlider  slider;
var localized string TitleText;

var XIIIGUIButton Buttons[7];
var localized string ButtonNames[7];
var localized string strLadderInfo,strLadderInfoCap;

function Created()
{
  local int i;
     Super.Created();

/*     leftArrow = XIIIArrowbutton(CreateControl(class'XIIIArrowbutton', 0, 0, 12, 12));
     leftArrow.WinLeft = 200;
     leftArrow.WinTop = ControlOffset + 4;
     leftArrow.bLeftOrient = true;
     rightArrow = XIIIArrowbutton(CreateControl(class'XIIIArrowbutton', 0, 0, 12, 12));
     rightArrow.WinLeft = 208;
     rightArrow.WinTop = ControlOffset + 4;  */

/*
     listbox = GUIListbox(CreateControl(class'GUIListBox', 100, 100, 100, 200));
     listbox.StyleName = "Listbox";
     listbox.List.Add("Hello");
     listbox.List.Add("World");
     listbox.List.ItemsPerPage = 5;
     Controls[0]=listbox;
     */

     //slider = GUISlider(CreateControl(class'GUISlider', 0, 120, 100, 20));
     //Controls[2]=slider;

     //listbox.WinLeft = 200;
     //listbox.WinTop = 100;
}


function InitComponent(GUIController MyController,GUIComponent MyOwner)
{
  //local int numberOfAccounts, q;
  //local string temp;

  Super.InitComponent(MyController, MyOwner);
     //listbox = GUIListBox(Controls[0]);

	Buttons[0] = XIIIGUIButton(Controls[0]);
	Buttons[0].Caption = ButtonNames[0];
	Buttons[1] = XIIIGUIButton(Controls[1]);
	Buttons[1].Caption = ButtonNames[1];
	Buttons[2] = XIIIGUIButton(Controls[2]);
	Buttons[2].Caption = ButtonNames[2];
	Buttons[3] = XIIIGUIButton(Controls[3]);
	Buttons[3].Caption = ButtonNames[3];
	Buttons[4] = XIIIGUIButton(Controls[4]);
	Buttons[4].Caption = ButtonNames[4];
	Buttons[5] = XIIIGUIButton(Controls[5]);
	Buttons[5].Caption = ButtonNames[6];
	Buttons[6] = XIIIGUIButton(Controls[6]);
	Buttons[6].Caption = ButtonNames[5];

	OnClick = InternalOnClick;


     /*
     listbox.list.clear();
     numberOfAccounts = xboxlive.GetNumberOfAccounts();
     for (q=0; q<numberOfAccounts; q++)
     {
       temp = xboxlive.GetAccountName(q);
       listbox.list.Add(temp);
     }

     listbox.list.Add(newAccountString);
     listbox.bVisibleWhenEmpty = true;
     */
}


function ShowWindow()
{
     OnMenu = 0; myRoot.bFired = false;
     Super.ShowWindow();
     bShowBCK = true;
     bShowRUN = false;
     bShowSEL = true;
}


function Paint(Canvas C, float X, float Y)
{
  Super.Paint(C, X, Y);
  PaintStandardBackground(C, X, Y, TitleText);
}

function ReturnMsgBox(byte bButton)
{
  switch (bButton)
  {
    case QBTN_Ok:
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveLadderWindow");
    return;
  }
}

function JoinGameTest()
{
     local string URL, Checksum;
     local int N;

     URL = "192.168.0.18";
     //URL = "192.168.0.18:7777";
/*     class'StatLog'.Static.GetPlayerChecksum(GetPlayerOwner(), Checksum);
     if (Checksum == "")
          URL = URL $ "?Checksum=NoChecksum";
     else
          URL = URL $ "?Checksum="$Checksum;
*/
    myRoot.bXboxStartup = true;
    myRoot.CloseAll(true);
    myRoot.GotoState('');
     GetPlayerOwner().AttribPadToViewport();
     log("TRAVELING w/URL: "$URL);
     //GetPlayerOwner().ClientTravel(URL, TRAVEL_Absolute, false);
    GetPlayerOwner().ConsoleCommand("start 192.168.0.18");
}

// Called when a button is clicked
function bool InternalOnClick(GUIComponent Sender)
{
    local XIIIMenuLiveQuickmatchWindow page;
    local int i;
    if (Sender == Controls[5])
    {
      //Controller.OpenMenu("XIDInterf.XIIIMenuLiveLadderWindow");
      Controller.OpenMenu("XIDInterf.XIIILiveMsgBox",false);
      msgbox = XIIILiveMsgBox(myRoot.ActivePage);
      msgbox.SetupQuestion(strLadderInfo, QBTN_Ok, QBTN_Ok, strLadderInfoCap);
      msgbox.OnButtonClick=ReturnMsgBox;
      msgbox.bCheckNetworkCable=true;
      msgbox.InitBox(160*fRatioX, 130*fRatioY*fScaleTo, 16, 16, 320*fRatioX, 250*fRatioY*fScaleTo);
      return true;
    }
    if (Sender == Controls[6])
    {
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveCreateWindow");
      return true;
    }
    if (Sender == Controls[0])
    {
      //JoinGameTest();
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveQuickmatchWindow");
      page = XIIIMenuLiveQuickmatchWindow(myRoot.ActivePage);
      page.Start(GT_DM);
      return true;
    }
    if (Sender == Controls[1])
    {
      //JoinGameTest();
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveQuickmatchWindow");
      page = XIIIMenuLiveQuickmatchWindow(myRoot.ActivePage);
      page.Start(GT_TeamDM);
      return true;
    }
    if (Sender == Controls[2])
    {
      //JoinGameTest();
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveQuickmatchWindow");
      page = XIIIMenuLiveQuickmatchWindow(myRoot.ActivePage);
      page.Start(GT_CTF);
      return true;
    }
    if (Sender == Controls[3])
    {
      //JoinGameTest();
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveQuickmatchWindow");
      page = XIIIMenuLiveQuickmatchWindow(myRoot.ActivePage);
      page.Start(GT_Sabotage);
      return true;
    }
    if (Sender == Controls[4])
    {
      Controller.OpenMenu("XIDInterf.XIIIMenuLiveOptimatchWindow");
      return true;
    }
    return false;
}


function bool InternalOnKeyEvent(out byte Key, out byte State, float delta)
{
    if (state==1/* || state==2*/)// IST_Press // to avoid auto-repeat
    {
        if ((Key==0x0D/*IK_Enter*/) || (Key==0x01))
	    {
          //Controller.FocusedControl.OnClick(Self);
          InternalOnClick(Controller.FocusedControl);
          return true;
	    }
	    if ((Key==0x08/*IK_Backspace*/)|| (Key==0x1B))
	    {
	        myRoot.CloseMenu(true);
    	    return true;
	    }
	    if (Key==0x25/*IK_Left*/)
	    {
    	    return true;
	    }
	    if (Key==0x27/*IK_Right*/)
	    {
    	    return true;
	    }
    }
    return super.InternalOnKeyEvent(Key, state, delta);
}



