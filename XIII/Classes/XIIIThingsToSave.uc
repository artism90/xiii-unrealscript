//-----------------------------------------------------------
// Used for saving things between maps and info on the save point.
//-----------------------------------------------------------
class XIIIThingsToSave extends Powerups;

struct XIIIGoals
{
    var bool bCompleted;
    var() bool bPrimary;
    var() bool bAntiGoal;
};

// MLK: used to record spoken dialogs & to be able to consult them
struct DialIndex
{
    var byte Lineind, Speakerind;
};

var travel int Health;      // Save HP for the player.
var travel name XIIISaveGameTriggerTag; // Save Tag to not save again just after Loading.
var travel float SpeedFactorLimit;      // Save speed modifier for the player
var travel array<XIIIGoals> ObjectivesState;  // Save all objectives states
//var array<DialIndex> DialogtoSave;      // ELR :: DON'T Save dialog states between maps (but keep them in the current map
var travel int CheckpointNumber;          // Indicates the checkpoint number XIII last reached (0 = map start)
var travel sound SoundToLaunch;



defaultproperties
{
     Health=130
     XIIISaveGameTriggerTag="'"
}
