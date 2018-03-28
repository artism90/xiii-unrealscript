class Shells extends TriggerParticleEmitter;

//_____________________________________________________________________________
function bool TriggerParticle()
{
    if ( (Level.Game != none) && (XIIIGameInfo(Level.Game).PlateForme == 1) ) // PS2
    {
      Emitters[0].UseCollision = false;
    }
    Emitters[0].RotationOffset = Owner.Rotation;
    Emitters[0].SpawnParticle(1);
    if ( bHidden )
    {
      bHidden = false;
      RefreshDisplaying();
    }
    SetTimer(2.0, false);
    return true;
//    Log("StartLocationOffset Emitter="$Emitters[0].StartLocationOffset);
}

//_____________________________________________________________________________
event Timer()
{
    bHidden = true;
    RefreshDisplaying();
}



defaultproperties
{
     Begin Object Class=MeshEmitter Name=ShellsA
         StaticMesh=StaticMesh'MeshArmesPickup.douille'
         Acceleration=(Z=-150.000000)
         UseCollision=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         AutomaticInitialSpawning=False
         Initialized=True
         DampingFactorRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         MaxParticles=40
         StartLocationOffset=(X=2.000000,Y=2.000000,Z=1.000000)
         UseRotationFrom=PTRS_Offset
         RotationOffset=(Roll=16384)
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=4.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-1.000000,Max=1.000000))
         RotationDampingFactorRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         StartSizeRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.500000,Max=0.500000))
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-20.000000,Max=60.000000),Y=(Min=30.000000,Max=70.000000),Z=(Min=10.000000,Max=20.000000))
         Name="ShellsA"
     End Object
     Emitters(0)=MeshEmitter'XIII.Shells.ShellsA'
     AutoDestroy=False
     bTrailerSameRotation=True
     bIgnoreDynLight=False
     Physics=PHYS_Trailer
     RemoteRole=ROLE_None
     Mass=4.000000
}
