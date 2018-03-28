//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoChairNoImpactEmitter extends BaseDecoEmitters;



defaultproperties
{
     Begin Object Class=MeshEmitter Name=DecoChairNoImpactEmitterA
         StaticMesh=StaticMesh'StaticExplosifs.chaiselightfragment'
         UseMeshBlendMode=False
         Acceleration=(Z=-950.000000)
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         AutomaticInitialSpawning=False
         Initialized=True
         DampingFactorRange=(X=(Min=0.800000,Max=0.900000),Y=(Min=0.500000,Max=0.500000),Z=(Min=0.100000,Max=0.200000))
         FadeOutStartTime=5.000000
         MaxParticles=10
         StartLocationOffset=(Z=50.000000)
         StartLocationRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Min=-100.000000,Max=100.000000))
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSpinRange=(X=(Min=-32767.000000,Max=32767.000000),Y=(Max=512.000000))
         RotationDampingFactorRange=(X=(Min=0.200000,Max=0.300000),Y=(Min=0.300000,Max=0.300000),Z=(Min=0.100000,Max=0.200000))
         StartSizeRange=(X=(Min=0.700000,Max=2.000000),Y=(Min=0.700000,Max=2.000000),Z=(Min=0.700000,Max=2.000000))
         InitialParticlesPerSecond=50000.000000
         DrawStyle=PTDS_AlphaBlend
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=6.000000,Max=6.000000)
         StartVelocityRange=(X=(Min=-20.000000,Max=200.000000),Y=(Min=-100.000000,Max=100.000000))
         Name="DecoChairNoImpactEmitterA"
     End Object
     Emitters(0)=MeshEmitter'XIII.DecoChairNoImpactEmitter.DecoChairNoImpactEmitterA'
     bUnlit=True
     RemoteRole=ROLE_None
}
