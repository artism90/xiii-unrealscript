//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DeathOnomatopEmitter extends Emitter;

var texture /*Death1Tex,*/ Death2Tex, Death3Tex, Death4Tex;

//_____________________________________________________________________________
simulated event SetInitialState()
{
    local int i;

    Super.SetInitialState();

    i = int (frand() * 3);

//    log(self$" SetInitialState w/ i="$i);
    switch(i)
    {
      Case 0 : Emitters[0].Texture=Death2Tex; break;
      Case 1 : Emitters[0].Texture=Death3Tex; break;
      Case 2 : Emitters[0].Texture=Death4Tex; break;
    }
}


defaultproperties
{
     Death2Tex=Texture'XIIICine.effets.death2'
     Death3Tex=Texture'XIIICine.effets.death3'
     Death4Tex=Texture'XIIICine.effets.death4'
     Begin Object Class=SpriteEmitter Name=DeathOnomatopEmitterA
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Initialized=True
         MaxParticles=1
         StartLocationOffset=(Z=10.000000)
         UseRotationFrom=PTRS_Actor
         SizeScale(0)=(relativetime=0.250000,RelativeSize=0.800000)
         SizeScale(1)=(relativetime=0.500000,RelativeSize=1.500000)
         SizeScale(2)=(relativetime=0.750000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=5000.000000
         DrawStyle=PTDS_AlphaBlend
         TextureUSubdivisions=1
         TextureVSubdivisions=1
         SecondsBeforeInactive=10000.000000
         LifetimeRange=(Min=1.500000,Max=1.500000)
         Name="DeathOnomatopEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.DeathOnomatopEmitter.DeathOnomatopEmitterA'
     bUnlit=True
     RemoteRole=ROLE_None
}
