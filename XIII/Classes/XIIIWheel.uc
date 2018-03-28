class XIIIWheel extends VehiclePart;

//function Update(float DeltaTime);
VAR float	WheelRadius;
VAR vector	OldLocation;

EVENT PostBeginPlay()
{
	OldLocation=Owner.Location;
	SetBase(Owner);
}

FUNCTION Update(float dt)
{
	LOCAL float sp;
	
	sp=VSize(Owner.Location-OldLocation);
	OldLocation=Owner.Location;
	if (sp>0)
	{
		RotationRate.Roll= -sp/dt/WheelRadius*10435;
		SetPhysics(PHYS_Rotating);
	}
	else
		SetPhysics(PHYS_None);
}



defaultproperties
{
     WheelRadius=44.000000
     bCollideActors=True
     bBlockActors=True
     bBlockPlayers=True
     bFixedRotationDir=True
     RotationRate=(Roll=-50000)
}
