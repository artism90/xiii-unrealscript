# xiii-unrealscript
The original UnrealScript source code of XIII, initially uploaded by Sonrat on 17th of March 2005 on theoutlawdad.com. No actual changes will be made on this repo. Since the initial source on theoutlawdad.com is no longer accessible, this will act as a new one for anyone to grab who is curious in developing XIII mods.

The existence of classes related to Xbox Live functionality (which are not to be found in a reverse engineered XIII PC build) and hard-coded adjustments for the Xbox platform suggest this is one of the latest (if not even the latest?) code base used for the game's **Xbox branch** in particular.

# Documentation
To browse the classes, use the included [Undox HTML files](https://artism90.github.io/xiii-unrealscript/). **Undox** is a documentation generator for UnrealScript packages.

# Additional Information
Be aware it does not contain all scripts used in the PC version, either they were stripped off via *UCC.exe Editor.StripSourceCommandlet* and are now incomplete or they were simply not included at all (since as aforementioned, this is most likely the Xbox branch).
See the overview below for details.

# Excluded code from this source
## XIDInterf classes
*Stripped(obfuscated) code (only defaultproperties)*
```
XIIIMenuEnterPasswordWindow
XIIIMenuInputLookClient
XIIIMenuInputMoveClient
XIIIMenuInputOtherClient
XIIIMenuInputPC
XIIIMenuInputPCSubBase
XIIIMenuInputShootAdvance
XIIIMenuInputShootClient
XIIIMenuMultiGS
XIIIMenuMultiGSAccountModify
XIIIMenuMultiGSAccountSignIn
XIIIMenuMultiGSBase
XIIIMenuMultiGSCreateGame
XIIIMenuMultiGSFilter
XIIIMenuMultiGSFindServers
XIIIMenuMultiGSGameDetail
XIIIMenuMultiGSJoinMsgBox
XIIIServerPing
```
*Scripts non-existent*
```
XIIIMenuMultiGSAccountFirstTime
XIIIMenuMultiGSAccountPassword
XIIIMenuMultiGSAccountCreation
XIIIMenuMultiGSAccountConfirmCreation
XIIIMenuMultiGSLicenceAgreement
XIIIMenuMultiGSCheckExistingAccountMsgBox
XIIIMenuMultiGSAccountCreationRunningMsgBox
XIIIMenuMultiGSAccountModifyRunningMsgBox
XIIIMenuMultiGSConnectingUbiComMsgBox
XIIIMenuMultiGSConnectionLostMsgBox
XIIIMenuMultiGSRegisterServerMsgBox
XIIIMenuMultiGSGetServerInfoMsgBox
```
## XIIIPersos classes
*Stripped(obfuscated) code (only defaultproperties)*
```
Mioche
```
