//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BulletScorch extends XIIIScorch;

//____________________________________________________________________
simulated function PostBeginPlay()
{
    local rotator R;

    if ( bUseRandRot )
    {
      R = rotation;
      R.Roll = randrange(0, 32767);
      SetRotation(R);
    }

    bMovable = false;
    AttachProjector();
    bMovable = true;
    AbandonProjector(Lifetime);
}

simulated function UpdateScorch()
{
    local rotator R;

    if ( bUseRandRot )
    {
      R = rotation;
      R.Roll = randrange(0, 32767);
      SetRotation(R);
    }

    DetachProjector(false);
    bMovable = false;
    AttachProjector();
    bMovable = true;
    AbandonProjector(Lifetime);
}


defaultproperties
{
     ProjTexture=FinalBlend'XIIICine.effets.BulletImpact'
     bTearOff=True
     bMovable=True
     LifeSpan=0.000000
     DrawScale=0.250000
}
