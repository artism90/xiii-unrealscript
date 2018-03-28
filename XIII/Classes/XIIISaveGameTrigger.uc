//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIISaveGameTrigger extends Triggers;

var() /*localized*/ string SaveDescription;
var() string TeleporterName;
var XIIIPlayerPawn P;
var() array<Actor> ActorsToDestroy;
var() sound SoundToLaunch;
var transient int ReturnCode;
var transient array<string> ProfileList;
var transient int i;
var transient int IsEmpty;
var transient string Description;

//____________________________________________________________________
// Get rid of all actors in my list ActorsToDestroy, meant to optimize (for checkpoints we are sure are no-return)
function CleanMap()
{
    local int i;

    for (i=0; i<ActorsToDestroy.Length; i++)
    {
/*
      if ( ActorsToDestroy[i] != none ) // may be already destroyed
        ActorsToDestroy[i].Destroy();
*/
      if (ActorsToDestroy[i] != none)
      {
        if ( XIIIPawn(ActorsToDestroy[i]) == none )
          ActorsToDestroy[i].Destroy();
        else
        { // destroy only if not visible and not in player's hand
          if ( !P.Controller.CanSee(Pawn(ActorsToDestroy[i]))
          && ( XIIIPawn(ActorsToDestroy[i]) != P.LHand.pOnShoulder ) )
            ActorsToDestroy[i].Destroy();
        }
      }
    }
}

//____________________________________________________________________
auto state WaitingForColl
{
    event Touch(actor other) // should happen for checkpoints
    {
      P = XIIIPlayerPawn(Other);
      if ( (P != none) && !P.bIsDead )
        GotoState('GoSaving');
    }
    event Trigger( Actor Other, Pawn EventInstigator ) // should happen when entering map
    {
      P = XIIIPlayerPawn(EventInstigator);
      if ( (P != none) && !P.bIsDead )
        GotoState('GoSaving');
    }
}

//____________________________________________________________________
state GoSaving
{
    function bool PrepareSave()
    {
      local XIIIThingsToSave S;
      local Array<string> Profile;
      local int i;

      S = XIIIThingsToSave(P.FindInventoryType(class'XIIIThingsToSave'));
      if ( S!=none && (S.XIIISaveGameTriggerTag==Tag) )
      {
        log("SAVE: "$self$" Destroying because XIIIThingsToSave exists in pawn inventory and Tag matches our");
        Destroy();
        return false;
      }
      return true;
    }
    // Save Game upon touch by pawn if context-ok.
    function DoSave()
    {
        local int MaxSlot, i;
        local NavigationPoint T;
        local XIIIThingsToSave S;
        local string St;
        local mapinfo MI;
        local XIIIGameInfo GI;

        log(":SAVE: "$self);

        S = XIIIThingsToSave(P.FindInventoryType(class'XIIIThingsToSave'));
        if ( S != none )
            S.Destroy();

        S = Spawn(class'XIIIThingsToSave',,,P.Location);
        if ( S == none )
        {
            Log(" ---: Pb, couldn't create XIIIThingsToSave...");
            return;
        }
        MI = XIIIGameInfo(Level.Game).MapInfo;
        if ( MI == none )
        {
            ForEach AllActors(class'MapInfo', MI)
                Break;
        }
        GI = XIIIGameInfo(Level.Game);

        S.GiveTo(P);
        S.XIIISaveGameTriggerTag = Tag;
        S.Health = P.Health;
        S.SpeedFactorLimit = P.SpeedFactorLimit;
        S.SoundToLaunch = SoundToLaunch;
        if (GI == none)
        {
            S.CheckpointNumber = 0;
        }
        else
        {
            GI.CheckpointNumber++;
            S.CheckpointNumber = GI.CheckpointNumber;
        }

        for ( i=0; i<MI.Objectif.Length ; i++ )
        {
            S.ObjectivesState.Length = S.ObjectivesState.Length + 1;
            S.ObjectivesState[i].bCompleted = MI.Objectif[i].bCompleted;
            S.ObjectivesState[i].bPrimary = MI.Objectif[i].bPrimary;
            S.ObjectivesState[i].bAntiGoal = MI.Objectif[i].bAntiGoal;
        }

        /* ELR No use as dialogs will not be saved between maps
        // MLK: Saving dialog states
        for ( i=0; i<MI.DialogToSave.Length ; i++ )
        {
        S.DialogToSave.Length++;
        S.DialogToSave[i].Lineind = MI.DialogToSave[i].Lineind;
        S.DialogToSave[i].Speakerind = MI.DialogToSave[i].Speakerind;
        }
        */

        Log("   -: XIIIThingsToSave have tag "$S.XIIISaveGameTriggerTag);

        if ( TeleporterName != "" )
        {
            foreach allactors(class'NavigationPoint', T, name(TeleporterName))
                break;
            if (T == none)
                Log(" ---: Beware, var TeleporterName ("$TeleporterName$") don't match any NavigationPoint Tag");
        }
        else
            Log(" ---: Beware, var TeleporterName ("$TeleporterName$") empty");

        //        St = P.Controller.PlayerReplicationInfo.PlayerName$"-"$Level.Title$"-"$SaveDescription;
        St = /*Level.Title$"-"$*/SaveDescription;
        XIIICheatManager(PlayerController(P.Controller).CheatManager).LogInventory();

        if ( SaveAtCheckpoint(TeleporterName, St) )
        {
            Log(" ---: Game Saved at checkpoint, TeleporterName="$TeleporterName$" & SaveDescription="$St);
            //P.ReceiveLocalizedMessage( class'XIIISaveMessage', 3, P.Controller.PlayerReplicationInfo, none, self );
        }
        else
        {
            Log(" ---: ERROR Unable to save game at checkpoint, TeleporterName="$TeleporterName$" & SaveDescription="$St);
            //P.ReceiveLocalizedMessage( class'XIIISaveMessage', 5, P.Controller.PlayerReplicationInfo, none, self );
        }

        S.Destroy();
        log(":ENDSAVE:");
        //Destroy();      // for the test, it was moved at the end of the state code
    }
Begin:
  if ( PrepareSave() )
  {
    P.ReceiveLocalizedMessage( class'XIIISaveMessage', 1, P.Controller.PlayerReplicationInfo, none, self );
    CleanMap();
    DoSave();
    //Sleep(1.0);
    //P.ReceiveLocalizedMessage( class'XIIISaveMessage', 2, P.Controller.PlayerReplicationInfo, none, self );
  }


  // TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
  /*
  if (!RequestGetProfileList())
  {
      log("Unable to get profile list");
  }
  else
  {
      log ("GetProfileList requested. Waiting for completion");
      while (!IsGetProfileListFinished(ReturnCode,ProfileList))
      {
          Sleep(0.1);
      }
      if (ReturnCode<0) log ("Failure: Profile list not obtained");
      else
      {
          log ("List of Profiles:");
          for (ReturnCode=0; ReturnCode<ProfileList.Length; ReturnCode++)
          {
              log("    "$ProfileList[ReturnCode]);
          }
      }
  }*/

    /*
  if (!RequestCreateProfile("Tata"))
  {
      log ("Unable to Create profile for Tata");
  }
  else
  {
      log ("CreateProfile requested for Tata. Waiting for completion");
      while (!IsCreateProfileFinished(ReturnCode))
      {
          Sleep(0.1);
      }
      if (ReturnCode<0) log ("Failure: Profile not created for Tata");
      else log ("Profile created successfully for Tata");
  }
  */

  /*
  if (!RequestGetProfileList())
  {
      log("Unable to get profile list");
  }
  else
  {
      log ("GetProfileList requested. Waiting for completion");
      while (!IsGetProfileListFinished(ReturnCode,ProfileList))
      {
          Sleep(0.1);
      }
      if (ReturnCode<0) log ("Failure: Profile list not obtained");
      else
      {
          log ("List of Profiles:");
          for (ReturnCode=0; ReturnCode<ProfileList.Length; ReturnCode++)
          {
              log("    "$ProfileList[ReturnCode]);
          }
      }
  }
  */

  /*
  if (!RequestUseProfile("Tata"))
  {
      log ("Unable to use profile Tata");
  }
  else
  {
      log ("UseProfile requested for Tata. Waiting for completion");
      while (!IsUseProfileFinished(ReturnCode))
      {
          Sleep(0.1);
      }
      if (ReturnCode<0) log ("Failure: Profile Tata cannot be used");
      else log ("Profile Tata is beeing used");
  }


  for (i=0; i<GetMaxNumberOfSavingSlots(); i++)
  {
      if (!RequestIsSlotEmpty(i))
      {
          log("Slot "$i$": Error: unable to access");
      }
      else
      {
          while (!IsSlotEmptyFinished(ReturnCode, IsEmpty))
          {
              Sleep(0.1);
          }
          if (ReturnCode < 0)
          {
              log("Slot "$i$": Error2: access failed");
          }
          else
          {
              if (bool(IsEmpty))
              {
                  log("Slot "$i$": <EMPTY>");
              }
              else
              {
                  if (!RequestGetSlotContentDescription(i))
                  {
                      log("Slot "$i$": Error3: not empty, but unable to get the description");
                  }
                  else
                  {
                      while (!IsGetSlotContentDescriptionFinished(ReturnCode, Description))
                      {
                          Sleep(0.1);
                      }
                      if (ReturnCode < 0)
                      {
                          log("Slot "$i$": Error4: get description failed");
                      }
                      else
                      {
                          log("Slot "$i$": "$Description);
                      }
                  }
              }
          }
      }
  }
  */

  /*
  if (!RequestWriteSlot(5, "Test 2 SauvegardE"))
  {
      log("Unable to save in slot 5");
  }
  else
  {
      while (!IsWriteSlotFinished(ReturnCode))
      {
          Sleep(0.1);
      }
      if (ReturnCode < 0)
      {
          log("FAILED to save in slot 5");
      }
      else
      {
          log("Game successfully saved in slot 5");
      }
  }
  */

  //if (!ReadSlot(5))
  //{
  //    log("Unable to load game in slot 5");
  //}

  /*
  if (!RequestWriteUserConfig())
  {
      log("Unable to write use config !");
  }
  else
  {
      while (!IsWriteUserConfigFinished(ReturnCode))
      {
          Sleep(0.1);
      }
      if (ReturnCode < 0)
      {
          log("Failed to write user config !");
      }
      else
      {
          log("user config successfull written");
      }
  }
  */

  /*
  if (!RequestReadUserConfig())
  {
      log("Unable to read use config !");
  }
  else
  {
      while (!IsReadUserConfigFinished(ReturnCode))
      {
          Sleep(0.1);
      }
      if (ReturnCode < 0)
      {
          log("Failed to read user config !");
      }
      else
      {
          log("user config successfull read");
      }
  }
  */


  Destroy();
}

defaultproperties
{
     TeleporterName="PlayerStart"
}
