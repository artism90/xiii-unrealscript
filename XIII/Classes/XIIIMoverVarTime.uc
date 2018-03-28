//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIMoverVarTime extends XIIIMover;

var(XIIIMover) float fVarMoveTime[8];
var(XIIIMover) StaticMesh VarStaticMesh[8];

//____________________________________________________________________
function PostBeginPlay()
{
    local int i;

    Super.PostBeginPlay();
    for (i=0;i<8;i++)
      if ( fVarMoveTime[i] == 0.0 )
        fVarMoveTime[i] = Movetime;

}

//____________________________________________________________________
function InterpolateTo( byte NewKeyNum, float Seconds )
{
//    Log("XIIIMoverVarTime InterpolateTo from"@KeyNum@"to"@NewKeyNum);
    NewKeyNum = Clamp( NewKeyNum, 0, ArrayCount(KeyPos)-1 );
    if( NewKeyNum==PrevKeyNum && KeyNum!=PrevKeyNum )
    {
      // Reverse the movement smoothly.
      PhysAlpha = 1.0 - PhysAlpha;
      OldPos    = BasePos + KeyPos[KeyNum];
      OldRot    = BaseRot + KeyRot[KeyNum];
    }
    else
    {
      // Start a new movement.
      OldPos    = Location;
      OldRot    = Rotation;
      PhysAlpha = 0.0;
    }

    // Setup physics.
    SetPhysics(PHYS_MovingBrush);
    bInterpolating   = true;
//    PhysRate         = 1.0 / FMax(Seconds, 0.005);
//    log("use varmovetime of "$fVarMoveTime[ KeyNum ] );
    if ( NewKeyNum == KeyNum-1 ) // Going backward
    {
      PhysRate = 1.0 / FMax( fVarMoveTime[ NewKeyNum ], 0.005);
    }
    else // Going forward
    {
      PhysRate = 1.0 / FMax( fVarMoveTime[ KeyNum ], 0.005);
    }
    if ( VarStaticMesh[KeyNum] != none )
      StaticMesh = VarStaticMesh[KeyNum];
    PrevKeyNum       = KeyNum;
    KeyNum           = NewKeyNum;

    ClientUpdate++;
    SimOldPos = OldPos;
    SimOldRotYaw = OldRot.Yaw;
    SimOldRotPitch = OldRot.Pitch;
    SimOldRotRoll = OldRot.Roll;
    SimInterpolate.X = 100 * PhysAlpha;
    SimInterpolate.Y = 100 * FMax(0.01, PhysRate);
    SimInterpolate.Z = 256 * PrevKeyNum + KeyNum;
}



defaultproperties
{
}
