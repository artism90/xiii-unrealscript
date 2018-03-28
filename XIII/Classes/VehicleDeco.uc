//-----------------------------------------------------------
//
//-----------------------------------------------------------
class VehicleDeco extends Decoration;

CONST MAX_PARTS=8;

VAR(Actor) class<Actor> PartClass[MAX_PARTS];
VAR Actor VehicleParts[MAX_PARTS];
VAR(Actor) vector PartOffset[MAX_PARTS];
VAR(Vehicle) Actor LinkedTo;
VAR(Vehicle) float inertia;
VAR(Vehicle) float ZOffset;
VAR StaticMesh BrokenSM; // (Vehicle)

var int NumParts;
var float YawOffset,LastTimeLinkedToMove;
var vector PositionOffset, LinkedToOldPosition;

//_____________________________________________________________________________
FUNCTION PostBeginPlay()
{
	LOCAL int i;

	Super.PostBeginPlay();

	for ( i=0; i<MAX_PARTS; i++ )
	{
		if ( PartClass[i] != None )
		{
			VehicleParts[i] = spawn(PartClass[i],self,,Location+(PartOffset[i]>>Rotation));
			if ( VehicleParts[i] == None )
				log("WARNING - "$PartClass[i]$" failed to spawn for "$self);
			else
			{
				VehicleParts[i].SetRotation(Rotation);
				NumParts++;
			}
		}
		else
			break;
	}
	
// Can't Disable Tick in PostBeginPlay
	if ( LinkedTo != none )
	{
		YawOffset=Rotation.Yaw-LinkedTo.Rotation.Yaw;
		PositionOffset=Location-LinkedTo.Location;
		LinkedToOldPosition = LinkedTo.Location;
	}
    if ( (Shadow!=none) && (XIIIGameInfo(Level.Game).MapInfo != none) )
    {
		Shadow.MaxTraceDistance=XIIIGameInfo(Level.Game).MapInfo.MaxTraceDistance;
		Shadow.ShadowIntensity=XIIIGameInfo(Level.Game).MapInfo.ShadowIntensity;
		Shadow.ShadowMaxDist=XIIIGameInfo(Level.Game).MapInfo.ShadowMaxDist;
		Shadow.ShadowTransDist=XIIIGameInfo(Level.Game).MapInfo.ShadowTransDist;
		Shadow.bShadowIsStatic = ( LinkedTo == none );
    }
}

EVENT VehicleSpecialHandling(float dt)
{
}

EVENT Tick(float dt)
{
	LOCAL vector vWantedPosition,gSpot,vNormal;
	LOCAL rotator r;
	LOCAL int i;

	LOCAL Pawn HitPawn;
	LOCAL Vector HitLocation,HitNormal,MemHit;

	LOCAL Vector X, Y, Z, OldPos;

	if ( LinkedTo==none )
	{
		Disable('Tick');
		return;
	}

	if ( ( LinkedToOldPosition != LinkedTo.Location ) || ( Level.TimeSeconds-LastTimeLinkedToMove < 1.0 )  )
	{
		if ( LinkedToOldPosition != LinkedTo.Location )
			LastTimeLinkedToMove=Level.TimeSeconds;
		if( NumParts != 0 )
		{
			for ( i=0; i<MAX_PARTS; i++ )
			{
				if ( VehicleParts[i] != None )
				{
					vWantedPosition=LinkedTo.Location+PositionOffset+(PartOffset[i]>>Rotation); //.X * RotX + PartOffset[i].Y * RotY + PartOffset[i].Z * RotZ;
						
					if (Trace( HitLocation, HitNormal, vWantedPosition+vect(0,0,-1000), vWantedPosition+vect(0,0,10), false )!=none)
					{
						if ( XIIIWheel( VehicleParts[i] )!=none )
							HitLocation.Z+= XIIIWheel(VehicleParts[i]).WheelRadius;
						else
							HitLocation.Z+= 44;
						gSpot+=HitLocation-vWantedPosition;
						vNormal+=HitNormal;
					}
					else
					{
						HitLocation=vWantedPosition;
						vNormal+=vect(0,0,1);
					}

					VehicleParts[i].SetLocation(HitLocation);
					r=VehicleParts[i].Rotation;
					r.Yaw=Rotation.Yaw;
					VehicleParts[i].SetRotation(r);
					if ( VehiclePart(VehicleParts[i])!=none )
						VehiclePart(VehicleParts[i]).Update(dt);
				}
			}
			gSpot/=NumParts;
			gSpot+=LinkedTo.Location+PositionOffset;
			gSpot.z+=ZOffset;
			SetLocation(/*Location*0.85+0.15**/gSpot);
	//log(name@gSpot@Location);
	//		SetLocation(LinkedTo.Location+PositionOffset);
			vNormal/=Numparts;
			r=LinkedTo.Rotation;
			r.Yaw+=YawOffset;
			r=OrthoRotation(vector(r),vNormal cross vector(r),vNormal);
			r.Yaw   = ( ( r.Yaw   - Rotation.Yaw   + 32768 ) & 65535 ) - 32768 ;
			r.Roll  = ( ( r.Roll  - Rotation.Roll  + 32768 ) & 65535 ) - 32768 ;
			r.Pitch = ( ( r.Pitch - Rotation.Pitch + 32768 ) & 65535 ) - 32768 ;
			r = r * (1-inertia) + Rotation;
			SetRotation(r);
		}
		else
		{
			gSpot=LinkedTo.Location+PositionOffset;
			gSpot.z+=ZOffset;
			SetLocation(gSpot);
			r=LinkedTo.Rotation;
	//		r.Yaw+=YawOffset;
			GetAxes(r,x,y,z);
			r=OrthoRotation(y,-x,z);
			r.Yaw  = ( ( r.Yaw   - Rotation.Yaw   + 32768 ) & 65535 ) - 32768;
			r.Roll = ( ( r.Roll  - Rotation.Roll  + 32768 ) & 65535 ) - 32768;
			r.Pitch= ( ( r.Pitch - Rotation.Pitch + 32768 ) & 65535 ) - 32768;
			r = r * ( 1 - inertia ) + Rotation;
			SetRotation( r );
		}
		VehicleSpecialHandling( dt );
		if ( Shadow!=none )
			Shadow.bShadowIsStatic = false;
	}
	else
		if ( Shadow!=none )
			Shadow.bShadowIsStatic = true;
	LinkedToOldPosition = LinkedTo.Location;
}

EVENT Destroyed()
{
	LOCAL int i;

	for ( i=0; i<MAX_PARTS; i++ )
	{
		if ( VehicleParts[i] != None )
		{
			VehicleParts[i].Destroy();
		}
	}
}



defaultproperties
{
     inertia=0.900000
     bStatic=False
     bStasis=False
     bIgnoreDynLight=False
     bCollideActors=True
     bCollideWorld=True
     bBlockActors=True
     bBlockPlayers=True
     bActorShadows=True
     bRotateToDesired=True
     RotationRate=(Yaw=10000)
}
