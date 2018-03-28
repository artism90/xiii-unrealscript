//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIDamageType extends DamageType;

//_____________________________________________________________________________
static function string SoloDeathMessage(controller Killer, Controller Victim)
{
     return Default.DeathString;
}



defaultproperties
{
     bArmorStops=True
     bSpawnDeathOnomatop=True
     bSpawnBloodFX=True
     bBloodSplash=True
     HeadBloodTrailEmitterClass=Class'XIII.HeadBloodTrailEmitter'
     BloodShotEmitterClass=Class'XIII.BloodShotEmitter'
}
