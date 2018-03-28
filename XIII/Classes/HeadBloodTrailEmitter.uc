//-----------------------------------------------------------
//
//-----------------------------------------------------------
class HeadBloodTrailEmitter extends Emitter;

//_____________________________________________________________________________
simulated event PostBeginPlay()
{
    local int i;
    Super.PostBeginPlay();
    if ( !Level.bHighDetailMode )
      Emitters[0].UseCollision = false;
    if ( (Level.Game != none) && (XIIIGameInfo(Level.Game).PlateForme == 1) ) // PS2
    {
      Emitters[0].UseCollision = false;
      Emitters[0].SetMaxParticles(25);
    }
    if ( Level.bLonePlayer && Level.Game.bAlternateMode )
    {
      Emitters[0].Texture = texture'XIIICine.effets.blobA';
      for (i=0; i<5; i++)
      {
        Emitters[0].ColorScale[i].relativetime = 0.2*i;
        Emitters[0].ColorScale[i].Color.R=RandRange(0, 255);
        Emitters[0].ColorScale[i].Color.G=RandRange(0, 255);
        Emitters[0].ColorScale[i].Color.B=RandRange(0, 255);
      }
    }
}



defaultproperties
{
     Begin Object Class=SpriteEmitter Name=HeadBloodTrailEmitterA
         Acceleration=(Z=-50.000000)
         UseCollision=True
         UseColorScale=True
         ResetAfterChange=True
         RespawnDeadParticles=False
         Initialized=True
         DampingFactorRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.100000))
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         ColorScale(2)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         ColorScale(3)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         ColorScale(4)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         ColorScale(5)=(relativetime=1.000000,Color=(B=192,G=192,R=192))
         MaxParticles=75
         StartSizeRange=(X=(Min=1.000000,Max=5.000000),Y=(Min=1.000000,Max=5.000000),Z=(Min=1.000000,Max=5.000000))
         InitialParticlesPerSecond=15.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'XIIICine.effets.goutteblood'
         SecondsBeforeInactive=10000.000000
         StartVelocityRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-5.000000,Max=5.000000),Z=(Min=-20.000000,Max=20.000000))
         Name="HeadBloodTrailEmitterA"
     End Object
     Emitters(0)=SpriteEmitter'XIII.HeadBloodTrailEmitter.HeadBloodTrailEmitterA'
     bHidden=True
     bUseCylinderCollision=True
}
