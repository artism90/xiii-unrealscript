//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIICheatManager extends CheatManager within PlayerController;

/*
//_____________________________________________________________________________
exec function MapListInfo()
{
//    local MapList MyMapList;
    local int i, NbMaps;

    NbMaps = class'MapList'.default.MapListInfo.Length;
    Log("STATIC MapList NbMaps="$NbMaps);
    if ( NbMaps > 0 )
    {
      for (i=0; i<NbMaps; i++)
        Log("  "$i$" - "$class'MapList'.default.MapListInfo[i].MapReadableName@"("$class'MapList'.default.MapListInfo[i].MapUnrName$") Nb="$class'MapList'.default.MapListInfo[i].NbPlayers);
    }
}
*/
/*
//_____________________________________________________________________________
exec function MSkinListInfo()
{
    local int i, NbSkins;

    NbSkins = class'MeshSkinList'.default.MeshSkinListInfo.Length;
    Log("STATIC SkinList NbSkins="$NbSkins);
    if ( NbSkins > 0 )
    {
      for (i=0; i<NbSkins; i++)
        Log("  "$i$" - "$class'MeshSkinList'.default.MeshSkinListInfo[i].SkinReadableName@"("$class'MeshSkinList'.default.MeshSkinListInfo[i].SkinCode$"|"$class'MeshSkinList'.default.MeshSkinListInfo[i].SkinName$")");
    }

}
*/
/*
//_____________________________________________________________________________
exec function NOAG()
{
    local MapInfo MI;
    local int i;

    MI = XIIIGameInfo(Level.Game).MapInfo;
    if (MI.Objectif.Length > 0)
    {
      for (i=0; i < MI.Objectif.Length; i++)
      {
        MI.Objectif[i].bAntiGoal = false;
      }
    }
}
*/

//_____________________________________________________________________________
exec function Diff(int i)
{
    Level.Game.Difficulty = i;
    MyHud.Message(none, "New difficulty level ="$i, 'CHEAT');
}

//_____________________________________________________________________________
exec function ClearSpecialMsg()
{
  local XIIIBaseHUD Hud;
  local HudMessage HMsg;

  Hud = XIIIBaseHUD(MyHud);
  if ( Hud != none )
  {
    //Log("clearing all special msg in HUD "$HUD);
    for ( HMsg = Hud.HudMsg; HMsg!=none; HMsg = HMsg.NextHudMsg)
    {
      //Log("         -"$HMsg);
      HMsg.bIsSpecial = false;
      HMsg.MyMessage.EndOfLife = Level.TimeSeconds;
    }
  }
//  else
//    Log("PB, no hud found to clear special messages");
}

//_____________________________________________________________________________
exec function SuperDeform()
{
    local pawn P;

    MyHud.Message(none, "SUPER DEFORM !!", 'CHEAT');
    foreach allactors(class'Pawn',P)
    {
      P.SetBoneScale(32,3,'X Head');
      P.SetBoneScale(31,0.66,'X Pelvis');
      P.SetBoneScale(34,3,'X L FOOT'); // X R (FOOT)or(TOE0)
      P.SetBoneScale(33,3,'X R FOOT'); // X L (FOOT)or(TOE0)
  	  P.SetCollisionSize(P.CollisionRadius,P.CollisionHeight*0.66);
    }
}

//_____________________________________________________________________________
exec function Nuke()
{
    local pawn P;

    MyHud.Message(none, "NU|<L34R B|_45T !!", 'CHEAT');
    foreach allactors(class'Pawn',P)
    {
      if ( !P.IsPlayerPawn() )
        P.TakeDamage(50000, P, P.Location, vect(0,0,0), class'XIII.DTSureStunned' );
    }
}

//_____________________________________________________________________________
exec function MaxAmmo()
{
    local Inventory Inv;

    for( Inv=Pawn.Inventory; Inv!=None; Inv=Inv.Inventory )
      if (Ammunition(Inv)!=None)
        Ammunition(Inv).AmmoAmount = Ammunition(Inv).MaxAmmo;
}

//_____________________________________________________________________________
exec function LogInventory()
{
  local inventory I;

  log(" -- Begin Inventory List");
  I=Pawn.Inventory;
  while ( I != none )
  {
    if ( Ammunition(I) != none )
      log("   Inv="$I$" Ammo="$Ammunition(I).AmmoAmount);
    else if ( I.Isa('PowerUps') )
      log("   Inv="$I$" charges="$PowerUps(I).Charge);
    else if ( I.Isa('Armor') )
      log("   Inv="$I$" charges="$Armor(I).Charge);
    else if ( Weapon(I) != none )
      log("   Inv="$I@" Ammo="$Weapon(I).AmmoType@"AltAmmo="$Weapon(I).AltAmmoType);
    else
      log("   Inv="$I);

    I=I.Inventory;
  }
  log(" -- End Inventory List");
}

/*
//_____________________________________________________________________________
exec function CheckInventory()
{
  local inventory I;
  local pawn P;

  log(" -- Begin MAP Inventory List");
  foreach allactors(class'inventory', I)
  {
    if ( Ammunition(I) != none )
      log("   Inv="$I@"Owner="$I.Owner@"Ammo="$Ammunition(I).AmmoAmount);
    else if ( I.Isa('PowerUps') )
      log("   Inv="$I@"Owner="$I.Owner@"charges="$PowerUps(I).Charge);
    else if ( I.Isa('Armor') )
      log("   Inv="$I@"Owner="$I.Owner@"charges="$Armor(I).Charge);
    else if ( Weapon(I) != none )
      log("   Inv="$I@"Owner="$I.Owner@"Ammo="$Weapon(I).AmmoType@"AltAmmo="$Weapon(I).AltAmmoType);
    else
      log("   Inv="$I@"Owner="$I.Owner);
    I=I.Inventory;
  }
  log(" -- End MAP Inventory List");
  log(" -- Begin PAWN Inventory List");
  foreach allactors(class'pawn', P)
  {
    log("  -       PAWN"@P);
    I=P.Inventory;
    while ( I != none )
    {
      if ( Ammunition(I) != none )
        log("   Inv="$I$" Ammo="$Ammunition(I).AmmoAmount);
      else if ( I.Isa('PowerUps') )
        log("   Inv="$I$" charges="$PowerUps(I).Charge);
      else if ( I.Isa('Armor') )
        log("   Inv="$I$" charges="$Armor(I).Charge);
      else if ( Weapon(I) != none )
        log("   Inv="$I@" Ammo="$Weapon(I).AmmoType@"AltAmmo="$Weapon(I).AltAmmoType);
      else
        log("   Inv="$I);
      I=I.Inventory;
    }
  }
  log(" -- End PAWN Inventory List");
}
*/

//_____________________________________________________________________________
exec function QSave(int i)
{
    //Level.Game.WriteSlot(i, PlayerReplicationInfo.PlayerName$"-"$Level.Title$"- CheatSave");
}

//_____________________________________________________________________________
exec function QLoad(int i)
{
    /*
    if ( !IsSlotEmpty(i) )
      Level.Game.ReadSlot(i);
    */
}

/*
//_____________________________________________________________________________
exec function KillMI()
{
    XIIIGameInfo(Level.Game).MapInfo.Destroy();
}
*/

//_____________________________________________________________________________
exec function ImAWinner()
{
    Level.Game.EndGame( PlayerReplicationInfo, "GoalComplete" );
    if (XIIIGameInfo(Level.Game).MapInfo != none )
    {
      XIIIGameInfo(Level.Game).MapInfo.DoTravel();
    }
}

//_____________________________________________________________________________
exec function ImALoser()
{
    Level.Game.EndGame( PlayerReplicationInfo, "GoalIncomplete" );
}

//_____________________________________________________________________________
exec function AmbiDX()
{
    GiveItem(class'DualWeaponSkill');
}

//_____________________________________________________________________________
exec function LetMeBreathe()
{
    GiveItem(class'BreathSkill');
}

//_____________________________________________________________________________
exec function LetMeHeal()
{
    GiveItem(class'FirstAidSkill');
}

//_____________________________________________________________________________
exec function HealMe(int A)
{
    XIIIPawn(Pawn).Heal(A);
}

/*
//_____________________________________________________________________________
exec function WeHaveTheLook()
{
  local Inventory NewItem;
  local xiiipawn XP;

  foreach allactors(class'xiiipawn', XP)
  {
    if( XP.FindInventoryType(class'Beret')==None )
    {
      NewItem = Spawn(class'Beret',,,XP.Location);
      if( NewItem != None )
        NewItem.GiveTo(XP);
    }
  }
}
*/

//_____________________________________________________________________________
exec function ImAnAlien()
{
    GiveItem(class'SixSenseSkill');
}

//_____________________________________________________________________________
exec function LetMeSnipe()
{
    GiveItem(class'SniperSkill');
}

//_____________________________________________________________________________
exec function LetMeStun()
{
    GiveItem(class'StunningSkill');
}

//_____________________________________________________________________________
exec function LetMePickLocks()
{
    GiveItem(class'PickLockSkill');
}

/*
//_____________________________________________________________________________
// ELR :Cheat: Code for givin all skills
exec function Powery()
{
    MyHud.Message(none, "CHEATER !!!", 'CHEAT');
    LetMeBreathe();
    ImAnAlien();
    LetMePickLocks();
    LetMeSnipe();
    LetMeHeal();
    AmbiDx();
    LetMeStun();
}
*/

//_____________________________________________________________________________
// ELR GiveWeapon, Called by the Weaponry CheatCode
function GiveWeapon(class<Weapon> WeapClass)
{
  local Weapon newWeapon;

  NewWeapon = Spawn(WeapClass,,,Pawn.Location);
  NewWeapon.Transfer(Pawn);
}

//_____________________________________________________________________________
// ELR GiveItem, Called by the Itemry CheatCode
function GiveSomething(class<Inventory> ItemClass)
{
  local Inventory NewItem;

  NewItem = Spawn(ItemClass,,,Pawn.Location);
  NewItem.Transfer(Pawn);
}

//_____________________________________________________________________________
// ELR GiveItem, Called by the Itemry CheatCode
function GiveItem(class<PowerUps> ItemClass)
{
  local PowerUps NewItem;

  NewItem = Spawn(ItemClass,,,Pawn.Location);
  NewItem.Transfer(Pawn);
}

//_____________________________________________________________________________
// ELR GiveArmor, Called by the Armory CheatCode
function GiveArmor(class<Armor> ArmorClass)
{
  local armor newArmor;

  NewArmor = Spawn(ArmorClass,,,Pawn.Location);
  NewArmor.Transfer(Pawn);
}

/*
//_____________________________________________________________________________
// ELR :Cheat: Code for givin weapons
exec function Weaponry()
{
    local WeaponPickup WP;

    MyHud.Message(none, "CHEATER !!!", 'CHEAT');
    foreach allactors(class'WeaponPickup', WP)
      GiveWeapon(class<Weapon>(WP.InventoryType));
}
*/

/*
//_____________________________________________________________________________
// ELR :Cheat: Code for givin armors
exec function Armory()
{
    local ArmorPickup AP;

    MyHud.Message(none, "CHEATER !!!", 'CHEAT');
    foreach allactors(class'ArmorPickup', AP)
      GiveArmor(class<Armor>(AP.InventoryType));
}
*/

/*
//_____________________________________________________________________________
// ELR :Cheat: Code for givin armors
exec function Itemry()
{
    local XIIIPickup IP;

    MyHud.Message(none, "CHEATER !!!", 'CHEAT');
    foreach allactors(class'XIIIPickup', IP)
      GiveItem(class<PowerUps>(IP.InventoryType));
}
*/

/*
//_____________________________________________________________________________
// ELR :Cheat: Code for givin all equipment & Skills
exec function EquipMe()
{
    local Pickup P;

    Itemry();
    Weaponry();
    Armory();
    Powery();
    MaxAmmo();
}
*/

//_____________________________________________________________________________
// Loaded, increase Health a lot to test
exec function SuperHero(float f)
{
    local int i;

    MyHud.Message(none, "SuperHero health factor "$f, 'CHEAT');
    XIIIPawn(Pawn).Health *= f;
    XIIIPawn(Pawn).MaxHealth *= f;
    XIIIPawn(Pawn).default.Health *= f;
}

/*
//_____________________________________________________________________________
exec function NeuNeu()
{
    local pawn XIDpawn;

    MyHud.Message(none, "All soldiers now in NEUNEU Mode :)", 'CHEAT');
    foreach allactors(class'Pawn',XIDpawn)
    {
      if ( XIDPawn.IsA('BaseSoldier') )
      {
        XIDPawn.controller.bstasis=true;
        XIDPawn.bstasis=true;
      }
    }
}
*/

/*
//_____________________________________________________________________________
exec function AllBosses()
{
    local XIIIPawn XPawn;

    MyHud.Message(none, "All soldiers are now bosses :)", 'CHEAT');
    foreach allactors(class'XIIIPawn',XPawn)
    {
      if ( XPawn != none )
        XPawn.bBoss = true;
    }
}
*/

/*
//_____________________________________________________________________________
// Deaf and Dumb
exec function DandD()
{
    local pawn XIDpawn;

    MyHud.Message(none, "All soldiers now Deaf and Dumb :)", 'CHEAT');
    foreach allactors(class'Pawn',XIDpawn)
    {
      if ( XIDPawn.IsA('BaseSoldier') || XIDPawn.IsA('MitraillGuard') )
      {
        XIDPawn.SightRadius=0.0;
        XIDPawn.HearingThreshold=0.0;
      }
    }
}
*/

/*
//_____________________________________________________________________________
// Loaded, increase Health a lot to test
exec function LoadedSoldiers()
{
    local pawn XIDpawn;
    local int i;

    MyHud.Message(none, "All soldiers now have alot of pvs", 'CHEAT');
    foreach allactors(class'Pawn',XIDpawn)
    {
      if ( XIDPawn.IsA('BaseSoldier') || XIDPawn.IsA('MitraillGuard') )
      {
        if ( XIIIPawn(XIDPawn) != none )
          XIIIPawn(XIDPawn).Health *= 50;
      }
    }
}
*/
/*
//_____________________________________________________________________________
exec function LogSoldier()
{
    local pawn XIDpawn;

//    MyHud.Message(none, "All soldiers now Deaf and Dumb :)", 'CHEAT');
    foreach allactors(class'Pawn',XIDpawn)
    {
      if ( XIDPawn.IsA('BaseSoldier') )
        XIDPawn.UsedBy(XIDPawn);
    }
}
*/



defaultproperties
{
}
