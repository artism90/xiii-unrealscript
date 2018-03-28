//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Mitrailleuse extends Decoration;

var MitraillTop MitTop;
//var() bool bHaveGuard;
var() enum eMitAngle
{
  MA_45,
  MA_90,
  MA_180,
} MaxShootAngle;
var() float fMaxShotDistance;
var() float fGuardReactionDelay;
var() enum eGuardType
{
  GT_NoGuardThere,
  GT_Guarded,
  GT_Automatic,
} GuardType;
var() float DownAngle, UpAngle;
var string StaticMeshName;  // to dynamicload it
var() mesh GuardMesh;
var() int TeamID;

//_____________________________________________________________________________
event ParseDynamicLoading(LevelInfo MyLI)
{
    Log("Mitrailleuse StaticParseDynamicLoading Actor="$self);
    MyLI.ForcedStaticMeshes[MyLI.ForcedStaticMeshes.Length] = StaticMesh(DynamicLoadObject(class'MitraillTop'.default.StaticMeshName, class'StaticMesh'));
}

//_____________________________________________________________________________
function PostBeginPlay()
{
    if ( !Level.bLonePlayer )
    {
      Destroy();
      return;
    }
    MitTop = Spawn(class'MitraillTop',self,, Location + vect(0,0,35.0), Rotation);
    if ( MitTop != none )
    {
      if ( GuardType == GT_Guarded )
      {
        MitTop.SpawnGuard(GuardMesh);
      }
      if ( GuardType == GT_Automatic )
      {
        MitTop.TeamID = TeamID;
        MitTop.SpawnGuard(GuardMesh);
        MitTop.InvincibleGuard();

      }
      MitTop.MaxShootAngle = MaxShootAngle;
      MitTop.fGuardReactionDelay = fGuardReactionDelay;
      MitTop.TraceDist = fMaxShotDistance;
      MitTop.DownAMax = (360-DownAngle)*65535/360;
      MitTop.UpAMax = UpAngle*65535/360;
    }
    else
      Destroy();
}



defaultproperties
{
     fMaxShotDistance=6000.000000
     fGuardReactionDelay=1.500000
     DownAngle=30.000000
     UpAngle=30.000000
     bInteractive=False
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bBlockZeroExtentTraces=False
     bUseCylinderCollision=True
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'MeshArmesPickup.mit127stand'
     CollisionRadius=24.000000
     CollisionHeight=48.000000
}
