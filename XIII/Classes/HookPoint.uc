//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HookPoint extends Decoration;

var() float RopeLength;   // Length of the rope if we do hook on it
var() HookNavPoint ClimbableHookNavPoint;



defaultproperties
{
     RopeLength=10000.000000
     bStatic=False
     bHidden=True
     bCollideActors=True
     bCollideWorld=True
     bProjTarget=True
     bCanSeeThrough=True
     bCanShootThroughWithRayCastingWeapon=True
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Teleport'
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}
