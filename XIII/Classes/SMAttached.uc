//=============================================================================
// SMAttached
// Created by iKi
// Last Modification by iKi
//=============================================================================

class SMAttached extends Actor
	abstract;

FUNCTION AttachTo(Pawn p){}



defaultproperties
{
     bShadowCast=True
     DrawType=DT_StaticMesh
     CollisionRadius=1.000000
     CollisionHeight=1.000000
     bEdShouldSnap=True
}
