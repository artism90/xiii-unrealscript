//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DecoDart extends DecoWeapon;

//_____________________________________________________________________________
simulated function Fire( float Value )
{
    bProjectileThrown = true;
    Super.Fire(0.0);
}

//_____________________________________________________________________________
simulated function TweenDown()
{
    if ( bProjectileThrown )
      PlayAnim('DownUsed', 1.0);
    else
      PlayAnim('Down', 1.0);
    Instigator.PlayRolloffSound(hDownSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
    if (!bProjectileThrown && DecoAmmo(AmmoType).bUnused)
      Instigator.PlayRolloffSound(hDownUnusedSound, self, 0, int(Pawn(Owner).IsPlayerPawn()), 0 );
}


defaultproperties
{
     fDelayShake=0.000000
     hDownSound=Sound'XIIIsound.Items__GlassFire.GlassFire__hGlassFire'
     AmmoName=Class'XIII.DecoDartAmmo'
     MeshName="XIIIArmes.fpsbarflechetteM"
     FireOffset=(X=5.000000,Y=17.000000,Z=-1.000000)
     FiringMode="FM_Throw"
     ShakeMag=0.000000
     shaketime=0.000000
     ShakeVert=(Z=0.000000)
     ShakeSpeed=(X=0.000000,Y=0.000000,Z=0.000000)
     ShakeCycles=0.000000
     hFireSound=Sound'XIIIsound.Items__DartFire.DartFire__hDartFire'
     hSelectWeaponSound=Sound'XIIIsound.Items__GlassPick.GlassPick__hGlassPick'
     PickupClassName="XIII.DartDecoPick"
     PlayerViewOffset=(X=8.000000,Y=6.000000,Z=-7.000000)
     ThirdPersonRelativeRotation=(Pitch=16384,Roll=16384)
     AttachmentClass=Class'XIII.DartAttach'
     ItemName="Dart"
}
