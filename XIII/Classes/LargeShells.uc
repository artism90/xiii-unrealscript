class LargeShells extends Shells;



defaultproperties
{
     Begin Object Class=MeshEmitter Name=LargeShellsA
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
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         RotationDampingFactorRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         StartSizeRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         SecondsBeforeInactive=0.000000
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=-10.000000,Max=50.000000),Y=(Min=20.000000,Max=50.000000),Z=(Min=10.000000,Max=20.000000))
         Name="LargeShellsA"
     End Object
     Emitters(0)=MeshEmitter'XIII.LargeShells.LargeShellsA'
}
