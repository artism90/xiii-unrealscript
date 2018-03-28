//-----------------------------------------------------------
//
//-----------------------------------------------------------
class FGrenadFlying extends GrenadFlying;

//_____________________________________________________________________________
simulated function Explosion(vector HitLocation)
{
    Local FragmentExplo Frag;
    local Emitter Em;
    Local int i, FragLoop;

    bExploded = true;

    //FRD   appel GenAlerte pour gestion grenade
    if (level.bLonePlayer) XIIIGameInfo(level.game).genalerte.untrigger(self,instigator);

    BlowUp(HitLocation);
    if ( Level.NetMode != NM_DedicatedServer )
    {
//      spawn(class'XIII.GrenadExplosionEmitter',,,Location + vect(0,0,1)*50,rotator(vect(0,0,1)));
      Spawn(ExplosionEmitterClass,,,Location + vect(0,0,1)*50,rotator(vect(0,0,1)));
      if ( (Level.Game != none) && (Level.Game.DetailLevel > 1) )
        FragLoop = 6;
      else
        FragLoop = 6;
      for(i = 0; FragLoop > i; i++)
      {
        Frag = Spawn(class'FragmentExplo',self,, HitLocation);
        Frag.Velocity = (vRand()+vect(0,0,0.4))*(400+fRand()*200);
      }
      if ( PhysicsVolume.bWaterVolume )
      {
        SpawnWaterExplo(HitLocation);
      }
    }
}



defaultproperties
{
     MyTrailClass=Class'XIII.FGrenadTrail'
     StaticMeshName="MeshArmesPickup.Grenade_Frag"
     ExplosionEmitterClass=Class'XIII.FragGrenadFragmentEmitter'
     Damage=700.000000
}
