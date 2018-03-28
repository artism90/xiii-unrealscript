class WheelVehicle extends VehicleDeco;

VAR bool bDying;
VAR() bool bExplodeIfDead, bDestructible;
VAR(Crash) int Health, DamageAmount, DamageRadius;
VAR int InitialHealth;
VAR() string CrashLabel;
VAR(Sound) Sound SoundExplosion;
VAR(Events) name CrashEvent, DeadEvent;
VAR Class<Emitter> /*SmokeEmitterClass,*/ ExploEmitterClass;
VAR vector ExploEmitterOffset;
VAR	Emitter SmokeEmitter, ExploEmitter;
VAR Vector vSpeed;
VAR WheelVehicle CollisionCopy;

FUNCTION PostBeginPlay()
{
	InitialHealth=Health;
	Super.PostBeginPlay();
}

FUNCTION TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType )
{
	LOCAL Rotator r;
	LOCAL Float f;

	switch (DamageType)
	{
	case class'DTBladeCut':
	case class'DTStunned':
	case class'DTPierced':
	case class'DTFisted':
		return;
	case class'DTRocketed':
	case class'DTGrenaded':
		Damage*=5;
	}

	if ( Level.bLonePlayer && bDestructible && !bDying && ( instigatedBy==none || instigatedBy.IsPlayerPawn()) )
	{
		Health= Max(0,Health-Damage);

		if (Health==0)
		{
			bDying=true;

			ExploEmitter= spawn(ExploEmitterClass,,,Location+ExploEmitterOffset,Rotation);

			Instigator = XIIIGameInfo(Level.Game).MapInfo.XIIIPawn;

			HurtRadius( DamageAmount, DamageRadius, class'DTGrenaded', 0, HitLocation );

			if ( LinkedTo != none )
				LinkedTo.PlaySound( SoundExplosion );
			else
				PlaySound( SoundExplosion );

			if ( SmokeEmitter!=none)
				SmokeEmitter.Destroy();

			GotoState( 'Dying' );
		}
	}
}

STATE Dying
{
	EVENT BeginState()
	{
		LOCAL int i;


		SetCollisionSize( 1, CollisionHeight );
		SetTimer2( 0.25, false );
// Force Stop wheels
		if( NumParts != 0 )
		{
			for ( i=0; i<MAX_PARTS; i++ )
			{
				if ( VehicleParts[i]!=none && VehicleParts[i].IsA('XIIIWheel') )
				{
					XIIIWheel(VehicleParts[i]).OldLocation=Location;
					XIIIWheel(VehicleParts[i]).Update(0.016);
				}
			}
		}
	}

	EVENT Timer2()
	{
		SetPhysics( PHYS_Falling );
		Velocity=vect(0,0,300);
		RotationRate=rot(15000,15000,15000);
		DesiredRotation.Yaw = Rotation.Yaw;
		DesiredRotation.Pitch = Rand(2048)-1024;
		DesiredRotation.Roll = Rand(2048)-1024;
		if ( BrokenSM!=none )
			StaticMesh=BrokenSM;
		class'WheelVehicle'.Default.bCollideWorld=false;
		CollisionCopy = Spawn( class'WheelVehicle' );
		class'WheelVehicle'.Default.bCollideWorld=true;
		if ( CollisionCopy == none )
			LOG( "Can't spawn a copy of "$self );
		else
		{
			CollisionCopy.bCollideWorld=true;
			CollisionCopy.StaticMesh = StaticMesh;
			CollisionCopy.bDestructible = false;
			CollisionCopy.SetCollision( true, true, true );
			CollisionCopy.SetDrawType( DT_StaticMesh );
			CollisionCopy.bHidden=true;
			CollisionCopy.RefreshDisplaying();
			SetCollision( false, false, false );
		}
	}

	EVENT Landed( vector HitNormal )
	{
		LOCAL Rotator r;

//		LOG(self@"LANDED"@DesiredRotation@Physics@Velocity@"("@vSize(velocity)@")"@vSize(velocity)>100);
		if ( vSize(velocity)>10 )
		{
			vSpeed = Velocity;
			SetTimer( 0.001, false );
		}
		else
		{
			r.Yaw   = Rotation.Yaw;
			r.Roll  = 0;
			r.PItch = 0;
			SetRotation( r );
			SetPhysics( PHYS_None );

			if ( CollisionCopy != none )
			{
				CollisionCopy.Destroy();
				SetCollision( true, true, true );
			}
		}

	}

	EVENT Timer( )
	{
		SetPhysics( PHYS_Falling );
		Velocity = vSpeed;
		Velocity.Z*=-(0.4*FRand()+0.25);
		DesiredRotation.Yaw = Rotation.Yaw;
		DesiredRotation.Pitch = -(0.5*FRand()+0.5)*DesiredRotation.Pitch;
		DesiredRotation.Roll = -(0.5*FRand()+0.5)*DesiredRotation.Roll; 
	}

	EVENT Tick(float dt)
	{
//		LOG(")-"@Velocity@"Physics"@Physics);
	}

	FUNCTION TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType )
	{
	}
Begin:
//	SetCollision(false,false,false);
	TriggerEvent( CrashEvent, self, none );
	Sleep( 0.1 );
	TriggerEvent( DeadEvent, self, none );
//	Destroy( );
}

//	SmokeEmitterClass=class'HelicoHSEmitter'
STATE() InvisibleUntilTriggered
{
	EVENT BeginState( )
	{
		DebugLog( "InvisibleUntilTriggered::BeginState" );
		SetTimer( 0.2, false );
	}

	EVENT Timer( )
	{
		LOCAL int i;

		DebugLog( "InvisibleUntilTriggered::Timer" );
		if ( LinkedTo!=none )
			Tag=LinkedTo.Tag;
		bHidden=true;
		RefreshDisplaying();
		SetCollision( false, false, false );
		for (i=0;i<MAX_PARTS;i++)
		{
			if ( VehicleParts[i] != None )
			{
				VehicleParts[i].bHidden=bHidden;
				VehicleParts[i].RefreshDisplaying( );
				VehicleParts[i].Disable( 'Tick' );
				VehicleParts[i].SetCollision( false, false, false );
			}
		}
	}

	EVENT Trigger(actor Other, Pawn EventInstigator)
	{
		DebugLog( "InvisibleUntilTriggered::Trigger" );
		GotoState( '' );
	}

	EVENT EndState( )
	{
		LOCAL int i;

		DebugLog( "InvisibleUntilTriggered::EndState" );
		bHidden=false;
		RefreshDisplaying();
		SetCollision( true, true, true );
		for (i=0;i<MAX_PARTS;i++)
		{
			if ( VehicleParts[i] != None )
			{
				VehicleParts[i].bHidden=bHidden;
				VehicleParts[i].RefreshDisplaying( );
				VehicleParts[i].Disable( 'Tick' );
				VehicleParts[i].SetCollision( true, true, true );
			}
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

	EVENT Tick(float dt) {}
}



defaultproperties
{
     bExplodeIfDead=True
     bDestructible=True
     Health=1000
     DamageAmount=500
     DamageRadius=500
     ExploEmitterClass=Class'XIII.LightVehicleExploEmitter'
     ExploEmitterOffset=(Z=128.000000)
     bOrientOnSlope=False
}
