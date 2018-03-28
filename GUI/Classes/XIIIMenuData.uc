// XBOX ONLY
class XIIIMenuData extends object;

struct stClasseGUIPage {
	var class<GUIPage> ClassObj;
};

var	Array<stClasseGUIPage>		XIIIMenuStack;	// Holds all pages of XIII
var	Array<string>		XIIIMenuStackStrings;	// Holds all pages names of XIII
var	Array<stClasseGUIPage>		XIIIIngameMenuStack;	// Holds all ingame pages of XIII
var	Array<string>		XIIIIngameMenuStackStrings;	// Holds all ingame pages names of XIII
var bool bMainMenuLoaded;
var bool bIngameMenuLoaded;

function LoadMainMenu()
{
	local int i;
	local class<GUIPage> NewMenuClass;

	XIIIMenuStack.Length = XIIIMenuStackStrings.Length;
	for(i=0; i<XIIIMenuStack.Length; i++ )
	{
		XIIIMenuStack[i].ClassObj = class<GUIPage>(DynamicLoadObject(XIIIMenuStackStrings[i],class'class'));
		if (XIIIMenuStack[i].ClassObj == none)
		{
			log("Unable to get menu class"@XIIIMenuStackStrings[i]);
		}
	}
	bMainMenuLoaded = true;
}

function LoadIngameMenu()
{
	local int i;
	local class<GUIPage> NewMenuClass;

	XIIIInGameMenuStack.Length = XIIIInGameMenuStackStrings.Length;
	for(i=0; i<XIIIIngameMenuStack.Length; i++ )
	{
		XIIIIngameMenuStack[i].ClassObj = class<GUIPage>(DynamicLoadObject(XIIIIngameMenuStackStrings[i],class'class'));
		if (XIIIIngameMenuStack[i].ClassObj == none)
		{
			log("Unable to get menu class"@XIIIIngameMenuStackStrings[i]);
		}
	}
	bIngameMenuLoaded = true;
}

function UnLoadMainMenu()
{
	local int i;
	if (bMainMenuLoaded)
	{
		for(i=0; i<XIIIMenuStack.Length; i++ )
		{	// reset to remove from memory thanks to garbage collector
			XIIIMenuStack[i].ClassObj = none;
		}
		bMainMenuLoaded = false;
		XIIIMenuStack.Length = 0;
	}
	/* never done, ingame menu always stays in memory
	if (bIngameMenuLoaded)
	{
		for(i=0; i<XIIIMenuStack.Length; i++ )
		{	// reset to remove from memory thanks to garbage collector
			XIIIIngameMenuStack[i].ClassObj = none;
		}
		bIngameMenuLoaded = false;
	}
	*/
}



defaultproperties
{
     XIIIMenuStackStrings(0)="XIDInterf.XIIIMenu"
     XIIIMenuStackStrings(1)="XIDInterf.XIIIMenuLoadGameWindow"
     XIIIMenuStackStrings(2)="XIDInterf.XIIIMenuDifficultyWindow"
     XIIIMenuStackStrings(3)="XIDInterf.XIIIMenuOptions"
     XIIIMenuStackStrings(4)="XIDInterf.XIIIMenuVideoClientWindow"
     XIIIMenuStackStrings(5)="XIDInterf.XIIIMenuAudioClientWindow"
     XIIIMenuStackStrings(6)="XIDInterf.XIIIMenuInputPC"
     XIIIMenuStackStrings(7)="XIDInterf.XIIIMenuInputLookClient"
     XIIIMenuStackStrings(8)="XIDInterf.XIIIMenuInputMoveClient"
     XIIIMenuStackStrings(9)="XIDInterf.XIIIMenuInputShootClient"
     XIIIMenuStackStrings(10)="XIDInterf.XIIIMenuInputOtherClient"
     XIIIMenuStackStrings(11)="XIDInterf.XIIIMenuSplitSetupClient"
     XIIIMenuStackStrings(12)="XIDInterf.XIIIMenuProfileClient"
     XIIIMenuStackStrings(13)="XIDInterf.XIIIMenuAdvancedControlsWindow"
     XIIIMenuStackStrings(14)="XIDInterf.XIIIMenuBotsSetupClient"
     XIIIMenuStackStrings(15)="XIDInterf.XIIIMenuContinue"
     XIIIMenuStackStrings(16)="XIDInterf.XIIIMenuMultiplayer"
     XIIIMenuStackStrings(17)="XIDInterf.XIIIMenuMultiProfile"
     XIIIMenuStackStrings(18)="XIDInterf.XIIIMenuMultiGS"
     XIIIMenuStackStrings(19)="XIDInterf.XIIIMenuMultiLANHost"
     XIIIMenuStackStrings(20)="XIDInterf.XIIIMenuMultiLANJoin"
     XIIIMenuStackStrings(21)="XIDInterf.XIIIMenuSelectProfile"
     XIIIMenuStackStrings(22)="XIDInterf.XIIIMenuCreateProfile"
     XIIIMenuStackStrings(23)="XIDInterf.XIIIMenuYesNoWindow"
     XIIIMenuStackStrings(24)="XIDInterf.XIIIMsgBox"
     XIIIMenuStackStrings(25)="XIDInterf.XIIIMenuChooseMap"
     XIIIMenuStackStrings(26)="XIDInterf.XIIIMenuBotChallengeSetupClient"
     XIIIMenuStackStrings(27)="XIDInterf.XIIIMenuMultiGSAccountFirstTime"
     XIIIMenuStackStrings(28)="XIDInterf.XIIIMenuMultiGSAccountSignIn"
     XIIIMenuStackStrings(29)="XIDInterf.XIIIMenuMultiGSAccountPassword"
     XIIIMenuStackStrings(30)="XIDInterf.XIIIMenuMultiGSLicenceAgreement"
     XIIIMenuStackStrings(31)="XIDInterf.XIIIMenuMultiGSFindServers"
     XIIIMenuStackStrings(32)="XIDInterf.XIIIMenuMultiGSCreateGame"
     XIIIMenuStackStrings(33)="XIDInterf.XIIIMenuMultiGSGameDetail"
     XIIIMenuStackStrings(34)="XIDInterf.XIIIMenuMultiGSFilter"
     XIIIMenuStackStrings(35)="XIDInterf.XIIIMenuMultiGSAccountCreation"
     XIIIMenuStackStrings(36)="XIDInterf.XIIIMenuMultiGSAccountConfirmCreation"
     XIIIMenuStackStrings(37)="XIDInterf.XIIIMenuMultiGSExistingAccount"
     XIIIMenuStackStrings(38)="XIDInterf.XIIIMenuMultiGSJoinMsgBox"
     XIIIMenuStackStrings(39)="XIDInterf.XIIIMenuMultiGSConnectingUbiComMsgBox"
     XIIIMenuStackStrings(40)="XIDInterf.XIIIMenuDocument"
     XIIIMenuStackStrings(41)="XIDInterf.XIIIMenuSkill"
     XIIIMenuStackStrings(42)="XIDInterf.XIIIMenuStory"
     XIIIMenuStackStrings(43)="XIDInterf.XIIIMenuConspiracy"
     XIIIMenuStackStrings(44)="XIDInterf.XIIIMenuDoc1"
     XIIIMenuStackStrings(45)="XIDInterf.XIIIMenuDoc2"
     XIIIMenuStackStrings(46)="XIDInterf.XIIIMenuDoc3"
     XIIIMenuStackStrings(47)="XIDInterf.XIIIMenuDoc4"
     XIIIMenuStackStrings(48)="XIDInterf.XIIIMenuDoc5"
     XIIIMenuStackStrings(49)="XIDInterf.XIIIMenuDoc6"
     XIIIMenuStackStrings(50)="XIDInterf.XIIIMenuDoc7"
     XIIIMenuStackStrings(51)="XIDInterf.XIIIMenuDoc8"
     XIIIMenuStackStrings(52)="XIDInterf.XIIIMenuMultiGSAccountCreationRunningMsgBox"
     XIIIMenuStackStrings(53)="XIDInterf.XIIIMenuMultiGSAccountModify"
     XIIIMenuStackStrings(54)="XIDInterf.XIIIMenuMultiGSAccountModifyRunningMsgBox"
     XIIIMenuStackStrings(55)="XIDInterf.XIIIMenuDoc9"
     XIIIMenuStackStrings(56)="XIDInterf.XIIIMenuDoc10"
     XIIIMenuStackStrings(57)="XIDInterf.XIIIMenuDoc11"
     XIIIMenuStackStrings(58)="XIDInterf.XIIIMenuDoc12"
     XIIIMenuStackStrings(59)="XIDInterf.XIIIMenuStory2"
     XIIIMenuStackStrings(60)="XIDInterf.XIIIMenuStory3"
     XIIIMenuStackStrings(61)="XIDInterf.XIIIMenuStory4"
     XIIIMenuStackStrings(62)="XIDInterf.XIIIMenuMultiGSCheckExistingAccountMsgBox"
     XIIIMenuStackStrings(63)="XIDInterf.XIIIMenuStory5"
     XIIIMenuStackStrings(64)="XIDInterf.XIIIMenuStory6"
     XIIIMenuStackStrings(65)="XIDInterf.XIIIMenuStory7"
     XIIIMenuStackStrings(66)="XIDInterf.XIIIMenuStory8"
     XIIIMenuStackStrings(67)="XIDInterf.XIIIMenuMultiGSRegisterServerMsgBox"
     XIIIMenuStackStrings(68)="XIDInterf.XIIIMenuEnterPasswordWindow"
     XIIIMenuStackStrings(69)="XIDInterf.XIIIMsgBoxQuitGame"
     XIIIMenuStackStrings(70)="XIDInterf.XIIIWindowMainMenu"
     XIIIMenuStackStrings(71)="XIDInterf.XIIIMenuMultiGSGetServerInfoMsgBox"
     XIIIMenuStackStrings(72)="XIDInterf.XIIIMenuMultiGSConnectionLostMsgBox"
     XIIIMenuStackStrings(73)="XIDInterf.XIIIMenuInputShootAdvance"
     XIIIIngameMenuStackStrings(0)="XIDInterf.XIIIMenuInGame"
     XIIIIngameMenuStackStrings(1)="XIDInterf.XIIIMenuInGameMulti"
     XIIIIngameMenuStackStrings(2)="XIDInterf.XIIIMenuSave"
     XIIIIngameMenuStackStrings(3)="XIDInterf.XIIIMenuInputPC"
     XIIIIngameMenuStackStrings(4)="XIDInterf.XIIIMenuInputLookClient"
     XIIIIngameMenuStackStrings(5)="XIDInterf.XIIIMenuInputMoveClient"
     XIIIIngameMenuStackStrings(6)="XIDInterf.XIIIMenuInputShootClient"
     XIIIIngameMenuStackStrings(7)="XIDInterf.XIIIMenuInputOtherClient"
     XIIIIngameMenuStackStrings(8)="XIDInterf.XIIIMenuCompetencesIngame"
     XIIIIngameMenuStackStrings(9)="XIDInterf.XIIIMenuItemsIngame"
     XIIIIngameMenuStackStrings(10)="XIDInterf.XIIIMultiControlsWindow"
     XIIIIngameMenuStackStrings(11)="XIDInterf.XIIIMenuInGameControlsWindow"
     XIIIIngameMenuStackStrings(12)="XIDInterf.XIIIMenuProfileClient"
     XIIIIngameMenuStackStrings(13)="XIDInterf.XIIIMultiViewConfigWindow"
     XIIIIngameMenuStackStrings(14)="XIDInterf.XIIIMenuInGameMultiKick"
     XIIIIngameMenuStackStrings(15)="XIDInterf.XIIIMenuBriefingWindow"
     XIIIIngameMenuStackStrings(16)="XIDInterf.XIIIMenuYesNoWindow"
     XIIIIngameMenuStackStrings(17)="XIDInterf.XIIIMsgBox"
     XIIIIngameMenuStackStrings(18)="XIDInterf.XIIIMsgBoxInGame"
     XIIIIngameMenuStackStrings(19)="XIDInterf.XIIIMenuInputShootAdvance"
     XIIIIngameMenuStackStrings(20)="XIDInterf.XIIIMenuInGameSabotage"
}
