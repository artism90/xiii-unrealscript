//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ProjectileInHead extends Effects;

//_____________________________________________________________________________
event PostBeginPlay()
{
    local vector RelativeLoc;
    local rotator RelativeRot;
    Local BloodOnHead BOH;
    Local Emitter HBTE;

//    Log(self@"spawned");
    RelativeLoc = normal(Location - Owner.GetBoneCoords('X Head').Origin)*11.0;
    if ( vector(Rotation) dot RelativeLoc > -0.7 ) // then projectile is too far behind, bring it a little in front
    {
      RelativeLoc -= vector(Rotation)*11.0; // Move it back along its path
      RelativeLoc *= 0.8; // make it nearer the head to avoid being suspended in void
    }
    RelativeRot = rotator(Vector(Rotation) << Owner.GetBoneRotation('X Head')); // Anyway to do this faster ?
    RelativeRot.Roll = Rand(32767);
    RelativeLoc = RelativeLoc << Owner.GetBoneRotation('X Head');

    Owner.AttachToBone(self, 'X Head');
    SetRelativeLocation(RelativeLoc);
    SetRelativeRotation(RelativeRot);

    Owner.SetBoneRotation('X Jaw', rot(0,0,-2000), 0, 1.0 );

//::TODO:: bring back when projectors are allowed on cartoon meshes
    HBTE = Spawn(class'XIIIDamageType'.Default.HeadBloodTrailEmitterClass, Owner);
    if ( HBTE != none )
    {
      Owner.AttachToBone(HBTE, 'X Head');
      HBTE.SetRelativeLocation(RelativeLoc);
      HBTE.SetRelativeRotation(RelativeRot);
    }

    BOH = Spawn(class'BloodOnHead',Owner);
    if ( BOH != none )
    {
      Owner.AttachToBone(BOH, 'X Head');
      BOH.SetRelativeLocation(RelativeLoc - vector(RelativeRot) * 30.0);
      BOH.SetRelativeRotation(RelativeRot);
    }
}



defaultproperties
{
     bHidden=True
     DrawType=DT_StaticMesh
     LifeSpan=60.000000
     CollisionRadius=10.000000
     CollisionHeight=10.000000
}
