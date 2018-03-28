//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIWeapon extends Weapon
  config
  abstract;

var bool bSpecialAltFire;     // to not handle keep alt fire pressed (M60, Kalash).

var Config class<WeaponOno> WeaponOnoClass;
var WeaponOno MyWeaponOno;

//_____________________________________________________________________________
Static function StaticParseDynamicLoading(LevelInfo MyLI)
{
    Super.StaticParseDynamicLoading(MyLI);

    if ( default.bUseSIlencer )
    {
      MyLI.ForcedClasses[MyLI.ForcedClasses.Length] = class'XIII.BerettaSilencer';
      class'XIII.BerettaSilencer'.Static.StaticParseDynamicLoading(MyLI);
    }
}

//_____________________________________________________________________________
simulated event postbeginplay()
{
    super.postbeginplay();
//    log("===="@self@" (class"@Class$") PostBeginPlay, WeaponOnoClass="$WeaponOnoClass);
    if ( WeaponOnoClass != none )
      MyWeaponOno = Spawn(WeaponOnoClass, self);
}

//_____________________________________________________________________________
simulated event destroyed()
{
    Super.Destroyed();
    if ( MyWeaponOno != none )
      MyWeaponOno.Destroy();
}

//_____________________________________________________________________________
simulated event RenderOverlays( canvas Canvas )
{
    local rotator NewRot, R;
    local bool bPlayerOwner;
    local int Hand, PitchViewOffset;
    local  PlayerController PlayerOwner;

    if ( bDrawZoomedCrosshair )
    {
      DrawZoomedCrosshair(Canvas);
      if ( !bHidden )
      { // hide weapon in zoom but don't change bRendered to allow back when unzom
        bHidden = true;
        RefreshDisplaying();
      }
      return;
    }

    if ( Instigator == None )
      return;

    if ( bRendered && bHidden )
    {
      bHidden = false;
      RefreshDisplaying();
    }

    PlayerOwner = PlayerController(Instigator.Controller);

    if ( PlayerOwner != None )
    {
      bPlayerOwner = true;
      Hand = PlayerOwner.Handedness;
      if (  Hand == 2 )
        return;
    }

    if ( (FirstPersonMF == none) && bDrawMuzzleFlash && (MFTexture != none) && (Level.NetMode != NM_DedicatedServer) )
    {
      FirstPersonMF = spawn(FirstPersonMFClass, self);
      FirstPersonMF.Texture = MFTexture;
//        FirstPersonMF.SetDrawScale(MuzzleScale * MuzzleFlashSize / MFTexture.USize * 0.03);
      FirstPersonMF.SetDrawScale(MuzzleScale * 0.2); // no more scale because mesh instead of texture
      AttachToBone(FirstPersonMF,GetBaseWeaponBone());
      FirstPersonMF.SetRelativeLocation(FPMFRelativeLoc);
      FirstPersonMF.SetRelativeRotation(FPMFRelativeRot);
      FirstPersonMF.SetDrawType(DT_None);
    }

    if ( bDrawMuzzleFlash && (FirstPersonMF != none) )
    {
      FirstPersonMF.SetDrawType(DT_None); // use DrawType instead of bHidden because attached
      if ( bMuzzleFlash && !bZoomed && (MFTexture != None) )
      {
//          Log("Should muzzleflash");
        if ( !bSetFlashTime )
        {
          bSetFlashTime = true;
          FlashTime = Level.TimeSeconds + FlashLength;
        }
        else if ( FlashTime < Level.TimeSeconds )
          bMuzzleFlash = false;
        if ( bMuzzleFlash )
        {
          if ( !HasSilencer() )
          {
            FirstPersonMF.SetDrawType(FirstPersonMF.default.DrawType);
          }
          if ( AmmoType.bDrawTracingBullets && bTracebullets)
            DrawTraceBullet(Canvas, Canvas.ClipX * Hand * FlashOffsetX, Canvas.ClipY * FlashOffsetY);
        }
      }
      else
        bSetFlashTime = false;
    }

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );

    // Handle view pitch change
    PitchViewOffset = Instigator.GetViewRotation().Pitch;
    if ( PitchViewOffset > 32767 )
      PitchViewOffset = PitchViewOffset - 65535;
    PitchViewOffset /= 35;

    NewRot = Instigator.GetViewRotation() + rot(1,0,0)*PitchViewOffset;
    if ( ShouldDrawCrosshair() )
      NewRot = rotator(vector(NewRot) * 4 + XIIIPlayerController(Instigator.Controller).ViewAdjustAim*(1.0-abs(XIIIPlayerController(Instigator.Controller).ViewAdjustAim.z)));

    // Handle fast turn visual offset
    R = Normalize(rot(0,1,0) * 350 * (PlayerController(Instigator.controller).PlayerInput.WeaponViewTurnAcc));
    NewRot += R;

    if ( Hand == 0 )
      newRot.Roll = 2 * Default.Rotation.Roll;
    else
      newRot.Roll = Default.Rotation.Roll * Hand;

    SetRotation(newRot);

    if ( Pawn(Owner).IsLocallyControlled() && (PlayerController(Pawn(Owner).Controller).DefaultFOV == PlayerController(Pawn(Owner).Controller).DesiredFOV) )
    {
      SetBase(Pawn(Owner).Controller);
      if ( (MySlave != none) && MySlave.bRendered && bEnableSlave )
        MySlave.RenderSlaveOverlays(Canvas);
    }
    if ( MyWeaponOno != none )
      MyWeaponOno.RenderOverlays(Canvas);
}

//_____________________________________________________________________________
// If this is called then just setup pos & render because primary weapon is already rendered
simulated event RenderSlaveOverlays( canvas Canvas )
{
    local bool bPlayerOwner;
    local int Hand;
    local  PlayerController PlayerOwner;

//    if ( DBDual ) Log(">> RenderSlaveOverlays PlayerViewOffset="$PlayerViewOffset);

    if ( bRendered && bHidden )
    {
      bHidden = false;
      RefreshDisplaying();
    }

    PlayerOwner = PlayerController(Instigator.Controller);

    if ( PlayerOwner != None )
    {
      bPlayerOwner = true;
      Hand = PlayerOwner.Handedness;
      if (  Hand == 2 )
        return;
    }

    if ( (FirstPersonMF == none) && bDrawMuzzleFlash && (MFTexture != none) && (Level.NetMode != NM_DedicatedServer) )
    {
      FirstPersonMF = spawn(FirstPersonMFClass, self);
      FirstPersonMF.Texture = MFTexture;
//        FirstPersonMF.SetDrawScale(MuzzleScale * MuzzleFlashSize / MFTexture.USize * 0.03);
      FirstPersonMF.SetDrawScale(MuzzleScale * 0.2); // no more scale because mesh instead of texture
      AttachToBone(FirstPersonMF,GetBaseWeaponBone());
      FirstPersonMF.SetRelativeLocation(FPMFRelativeLoc);
      FirstPersonMF.SetRelativeRotation(FPMFRelativeRot);
      FirstPersonMF.SetDrawType(DT_None);
    }

    if ( bDrawMuzzleFlash && ( FirstPersonMF != none) )
    {
      FirstPersonMF.SetDrawType(DT_None); // use DrawType instead of bHidden because attached
      if ( bMuzzleFlash && !bZoomed && (MFTexture != None) )
      {
        if ( !bSetFlashTime )
        {
          bSetFlashTime = true;
          FlashTime = Level.TimeSeconds + FlashLength;
        }
        else if ( FlashTime < Level.TimeSeconds )
          bMuzzleFlash = false;
        if ( bMuzzleFlash )
        {
          if ( !HasSilencer() )
            FirstPersonMF.SetDrawType(FirstPersonMF.default.DrawType);
          if ( AmmoType.bDrawTracingBullets && bTracebullets)
            DrawTraceBullet(Canvas, -Canvas.ClipX * Hand * FlashOffsetX, Canvas.ClipY * FlashOffsetY);
        }
      }
      else
        bSetFlashTime = false;
    }

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    SetRotation(SlaveOf.Rotation);
    SetBase(Pawn(Owner).Controller);
}

//_____________________________________________________________________________
simulated function DrawZoomedCrosshair(Canvas C)
{
    local float XSize, YSize;
    local float fDrawScale;
    local float fZoomFactor;
    local string sZoomFactor;
    local float fZoomStability;

    fDrawScale = C.ClipX/640.0;

    // ::TODO:: FIX this on ps2 for on-line ?
//    if ( (Level.Game != none) && (XIIIGameInfo(Level.Game).Plateforme == PF_PS2) )
      fDrawScale *= 256 / ZCrossHair.USize; // on PS2 the texture is only 128x128 so scale it
//      fDrawScale *= 2; // on PS2 the texture is only 128x128 so scale it

    fZoomStability = XIIIPlayerController(Pawn(owner).Controller).fSniperPrecision * 2.0 / 3.0;
    fZoomFactor = PlayerController(Pawn(owner).Controller).DefaultFOV / PlayerController(Pawn(owner).controller).FOVAngle;
    sZoomFactor = "zoom x"$int(fZoomFactor)$"."$int( (fZoomFactor-int(fZoomFactor))*100 );

    XSize = ZCrossHair.USize*fDrawScale;

    C.Style = ERenderStyle.STY_Alpha;
    C.SetDrawColor(255,0,0,255);
    C.SetPos(0.50 * C.ClipX - ZCrosshairDot.USize/2.0, 0.50 * C.ClipY - ZCrosshairDot.VSize/2.0);
    C.DrawIcon(ZCrosshairDot, 1.0);

    C.SetDrawColor(255,255,255,255);
    C.SetPos(0.50 * C.ClipX-0.5 - XSize, 0.50 * C.ClipY-0.5 - XSize);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,-ZCrossHair.USize, ZCrossHair.VSize);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,ZCrossHair.USize, ZCrossHair.VSize);
    C.SetPos(0.50 * C.ClipX-0.5 - XSize, 0.50 * C.ClipY-0.5);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,-ZCrossHair.USize, -ZCrossHair.VSize);
    C.DrawTile(ZCrossHair, XSize, XSize, 0, 0,ZCrossHair.USize, -ZCrossHair.VSize);

    // screen cover w/ a part of the ZCrosshair texture
    YSize=0.5*C.ClipY - XSize;
    XSize=0.5*C.ClipX - XSize;
    // Left Part
    C.SetPos(0, 0);
    C.DrawTile(ZCrossHair, XSize-0.5, C.ClipY, 230, 2, 16, 16);
    // Up part
    C.SetPos(XSize-0.5, 0);
    C.DrawTile(ZCrossHair, C.ClipX - XSize*2.0, YSize-0.5, 230, 2, 16, 16);
    // Right Part
    C.SetPos(C.ClipX - XSize-0.5, 0);
    C.DrawTile(ZCrossHair, XSize+0.5, C.ClipY, 230, 2, 16, 16);
    //Down Part
    C.SetPos(XSize-0.5, C.ClipY - YSize-0.5);
    C.DrawTile(ZCrossHair, C.CLipX - XSize*2.0, YSize+0.5, 230, 2, 16, 16);

    // Zoom Level Display
    C.Font=C.smallfont; //font'XIIIFonts.XIIIConsoleFont';
    C.bCenter = false;
    C.SetPos(XSize + 10.0, C.ClipY/2.0 - 20.0);
    C.SetDrawColor(65,186,212,255);
    C.DrawText(sZoomFactor);
    bDrawZoomedCrosshair = false;

    // Stability display
    if ( Level.bLonePlayer && (fZoomStability > 0.0) )
    {
      C.SetPos(C.ClipX*0.5 + ZCrossHair.USize*fDrawScale+1, C.ClipY*0.5 - 8.0*fZoomFactor*fZoomStability+1);
//      C.SetDrawColor(65,186,212,255);
      C.DrawTile(StabilityTex, 8, 8.0*fZoomFactor*2.0*fZoomStability, 0, 0, StabilityTex.USize, StabilityTex.VSize);
    }
}

//_____________________________________________________________________________
// ELR Text to be displayed in HUD
simulated function string GetAmmoText(out int bDrawbulletIcon)
{
    local string AmmoText,AltAmmoText;

    if ( AmmoType == none )
      return "";

    bDrawbulletIcon = 1;

    if ( MySlave != none )
    {
      AmmoText = MySlave.ReLoadCount$"/"$ReloadCount@"|"@(Ammotype.AmmoAmount-ReLoadCount-MySlave.ReloadCount);
      return AmmoText;
    }
    // Setup ammotext
    if ( default.ReLoadCount > 0 )
      AmmoText = ReLoadCount@"|"@(Ammotype.AmmoAmount-ReLoadCount);
    else if ( (WHand == WHA_Fist) || (WHand == WHA_Deco) )
    {
      AmmoText = ItemName;
      bDrawbulletIcon = 0;
    }
    else
      AmmoText = string(Ammotype.AmmoAmount);
    if ( AmmoType.bDisplayNameInHUD )
    {
      AmmoText = "("$AmmoType.ItemName$")"@AmmoText;
    }

    // Setup ammotext
    if ( bHaveAltFire && !bMeleeWeapon && (AltAmmoType != none) )
    {
      if ( default.AltReLoadCount > 0 )
        AltAmmoText = AltReLoadCount$"/"$(AltAmmoType.AmmoAmount-AltReLoadCount);
      else
        AltAmmoText = string(AltAmmotype.AmmoAmount);

      if ( AltAmmoType.bDisplayNameInHUD )
        AmmoText = AmmoText@"|"@AltAmmoText;
      else
        AmmoText = AltAmmoText@AmmoText;
    }
    return AmmoText;
}

//_____________________________________________________________________________
simulated function DrawTraceBullet(Canvas C, float XE, float YE)
{
    C.SetPos(C.ClipX/2.0 + RandRange(-TraceAccuracy*2,TraceAccuracy*2), C.ClipY/2.0 + RandRange(-TraceAccuracy*2,TraceAccuracy*2));
    C.Style = ERenderStyle.STY_Translucent;
    C.DrawColor = C.Static.MakeColor(255,200,100,200);
    C.DrawTile(Ammotype.TBTexture, XE, YE, 0,0, Ammotype.TBTexture.USize, Ammotype.TBTexture.VSize);
}

//_____________________________________________________________________________
simulated function Weapon RecommendWeapon( out float rating )
{
    local Weapon Recommended;
    local float oldRating;

    if (
         !Instigator.IsPlayerPawn()
      || (XIIIPlayerPawn(Instigator) == none)
      || (XIIIPlayerPawn(Instigator).LHand == none)
      || !XIIIPlayerPawn(Instigator).LHand.bActive
       )
      return Super.RecommendWeapon(rating);

    if ( Pawn(Owner).bHaveOnlyOneHandFree && (WHand == WHA_2HShot) )
      rating = -100.0;

    if ( inventory != None )
    {
      Recommended = inventory.RecommendWeapon(oldRating);
      if ( (Recommended != None) && (oldRating > rating) )
      {
        rating = oldRating;
        return Recommended;
      }
    }
    return self;
}

//_____________________________________________________________________________
function NewWeaponNotify(Pawn Other)
{
    if ( !Level.bLonePlayer )
      return;
    if ( (Other.Controller == none) || (XIIIPlayerController(Other.Controller) == none) )
      return;
    // now we can inform that a new weapon has been acquired
    XIIIBaseHud(XIIIPlayerController(Other.Controller).MyHud).NotifyNewWeapon(self.Class);
}

//_____________________________________________________________________________
simulated function NotifyOwnerKilled(controller Killer)
{
    bRendered = false;
    bHidden = true;
    Refreshdisplaying();
}

//_____________________________________________________________________________
event Timer2()
{
    switch (NextSlaveState)
    {
      Case 'BringUp':
        if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
        {
          SlaveOf.bEnableSlave = false;
          return;
        }
        bRendered = true;
//        bHidden = false;
//        RefreshDisplaying();
        BringUp();
        break;
      Case 'Fire':
        Fire(0.0);
        break;
    }
}

//_____________________________________________________________________________
function SetUpDual(Weapon Dual, Pawn other)
{
    local vector tV;
    // inventory Giveto
    Instigator = Other;
    // we must add the inventory but just after dual & before it's ammo.
    Other.InsertInventory( Self, Dual ); // OLD = Other.AddInventory( Self );
    GotoState('');

    bCanThrow = false;      // can't throw weapon if dual else pb when in hand
    dual.bCanThrow = false;

    // Weapon Giveto
    bTossedOut = false;
    Instigator = Other;
    GiveAmmo(Other);
    if ( (AmmoType != None) && Level.Game.bInventorySetUp )
      AmmoType.AddAmmo(ReLoadCount); // For dual need to give the ReloadCount to be sure we do have them in inventory
    ClientWeaponSet(true);

    // Dual setup
    Dual.bHaveSlave = true;
    Dual.MySlave = self;
    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
      Dual.bEnableSlave = false;
    else
      Dual.bEnableSlave = true;
    SlaveOf = Dual;
    Dual.WHand = WHA_1HShot; // Leave as 1HShoot but must deactivate the SlaveBringUp if LeftHand is there.
    bIsSlave = true;
    if ( Silencer != none )
      Silencer.Destroy();
    bCanHaveSlave = false;
    PlayerViewOffset.y *= -1;
    PlayerViewOffset.X -= 1;
    FireOffset.y *= -1;
//    FlashOffsetX *= -1;
    tV = Dual.default.DrawScale3D;
    tV.x *= -1.0;
    SetDrawScale3D(tV);

    bRendered = false;
    bHidden = true;
    RefreshDisplaying();
    if ( Other.Weapon == Dual )
    {
      SlaveBringUp();
    }
}

//_____________________________________________________________________________
simulated function SlaveBringUp()
{
    if ( (XIIIPawn(Owner).LHand != none) && XIIIPawn(Owner).LHand.bActive )
    {
      SlaveOf.bEnableSlave = false;
      return;
    }
    NextSlaveState = 'BringUp';
    SetTimer2(0.2 + fRand()*0.2, false);
}

//_____________________________________________________________________________
simulated function RumbleFX()
{
    if ( (Instigator != none) && Instigator.IsHumanControlled() && Instigator.IsLocallyControlled() )
        if( XIIIPlayerController(Instigator.Controller) != none )
      XIIIPlayerController(Instigator.Controller).RumbleFX(RumbleFXNum);
}

//_____________________________________________________________________________
simulated function bool HasSilencer()
{
    return ( bUseSilencer && !bIsSlave && (Pawn(Owner).FindInventoryKind('Silencer') != none) );
}

//_____________________________________________________________________________
simulated function Name GetBaseWeaponBone()
{
    return '';
}

//_____________________________________________________________________________
simulated function UpDatesilencer()
{
    if ( (Level.Game == none) || !Level.Game.bInventorySetup )
      return;
    if ( HasSilencer() )
    {
      // MFTexture = SilencedMuzzleFlash; // ::TODO:: Change muzzleflash texture there
      if ( Silencer == None )
      {
        Silencer = spawn(class'BerettaSilencer',self);
        AttachToBone(Silencer,GetBaseWeaponBone());
      }
    }
}

//_____________________________________________________________________________
simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( Level.bLonePlayer && XIIIPawn(Owner).LHand.bActive && (WHand == WHA_2HShot) )
    {
      if ( Inventory == None )
        return CurrentChoice;
      else
        return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
    }
    else
      return Super.PrevWeapon(CurrentChoice, CurrentWeapon);
}
//_____________________________________________________________________________
simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
    if ( Level.bLonePlayer && XIIIPawn(Owner).LHand.bActive && (WHand == WHA_2HShot) )
    {
      if ( Inventory == None )
        return CurrentChoice;
      else
        return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
    }
    else
      return Super.NextWeapon(CurrentChoice, CurrentWeapon);
}

//_____________________________________________________________________________
simulated function bool HasScope()
{
    return bHaveScope;
}

//_____________________________________________________________________________
function FeedBack()
{
//    Log("FeedBack call for "$self);
    if ( Instigator.IsPlayerPawn() && (Level.GetPlateforme() != 1) && (Level.GetPlateforme() != 3) )
      XIIIPlayerController(Instigator.controller).ClientViewFeedBackSetUp(Self.Class, bIsSlave);
}

//_____________________________________________________________________________
function AltFeedBack()
{
//    Log("AltFeedBack call for "$self);
    if ( Instigator.IsPlayerPawn() && (Level.GetPlateforme() != 1) && (Level.GetPlateforme() != 3) )
      XIIIPlayerController(Instigator.controller).ClientViewAltFeedBackSetUp(Self.Class, bIsSlave);
}

/*
//_____________________________________________________________________________
simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
    if ( bZoomed )
      return (Instigator.Location + Instigator.EyePosition() + FireOffset.X * X);
    else
      return (Instigator.Location + Instigator.EyePosition() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z);
}
*/

//_____________________________________________________________________________
simulated function vector GetAltFireStart(vector X, vector Y, vector Z)
{
    if ( bZoomed )
      return (Instigator.Location + Instigator.EyePosition() + AltFireOffset.X * X);
    else
      return (Instigator.Location + Instigator.EyePosition() + AltFireOffset.X * X + AltFireOffset.Y * Y + AltFireOffset.Z * Z);
}

//_____________________________________________________________________________
function ProjectileFire()
{
    local Vector Start, X,Y,Z;

//    log("ProjectileFire");

    if ( XIIIProjectilesAmmo(AmmoType).fThrowDelay > 0 )
      SetTimer(XIIIProjectilesAmmo(AmmoType).fThrowDelay, false);
    else
    {
      MakeNoise(FireNoise);
      GetAxes(Instigator.GetViewRotation(),X,Y,Z);
      Start = GetFireStart(X,Y,Z);
      if ( ShouldDrawCrosshair() )
        AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0);
      else
      {
        if ( Instigator.controller != none )
        {
          if ( Instigator.IsPlayerPawn() )
            AdjustedAim = Instigator.controller.rotation;
          else
            AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0);
        }
        else
          AdjustedAim = Instigator.rotation;
      }
//      if ( (Default.ReloadCount != 0) && (ReLoadCount > 0) || ((Default.ReloadCount == 0) && (AmmoType.AmmoAmount > 0)) )
        FeedBack();
      AmmoType.SpawnProjectile(Start,AdjustedAim);
    }
}

//_____________________________________________________________________________
function ProjectileAltFire()
{
    local Vector Start, X,Y,Z;

//    log("ProjectileFire");

    if ( XIIIProjectilesAmmo(AltAmmoType).fThrowDelay > 0 )
      SetTimer(XIIIProjectilesAmmo(AltAmmoType).fThrowDelay, false);
    else
    {
      MakeNoise(AltFireNoise);
      GetAxes(Instigator.GetViewRotation(),X,Y,Z);
      Start = GetAltFireStart(X,Y,Z);
      if ( ShouldDrawCrosshair() )
        AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0); // ELR BIG BUG CAN'T HAVE AUTOAIM FOR ALT AMMOS (ANYWAY NOT BUG BECAUSE NOT COMPATIBLE)
//        AdjustedAim = Instigator.AdjustAim(AltAmmoType, Start, 0); // ELR BIG BUG CAN'T HAVE AUTOAIM FOR ALT AMMOS (ANYWAY NOT BUG BECAUSE NOT COMPATIBLE)
      else
      {
        if ( Instigator.controller != none )
        {
          if ( Instigator.IsPlayerPawn() )
            AdjustedAim = Instigator.controller.rotation;
          else
            AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0);
//            AdjustedAim = Instigator.AdjustAim(AltAmmoType, Start, 0);
        }
        else
          AdjustedAim = Instigator.rotation;
      }
//      if ( (Default.AltReloadCount != 0) && (AltReLoadCount > 0) || ((Default.AltReloadCount == 0) && (AltAmmoType.AmmoAmount > 0)) )
        AltFeedBack();
      AltAmmoType.SpawnProjectile(Start,AdjustedAim);
    }
}

//_____________________________________________________________________________
// 1236탎
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
    if ( AmmoType.fFireDelay > 0 )
      SetTimer(AmmoType.fFireDelay, false);
    else
      RealTraceFire(Accuracy, YOffset, ZOffset);
}

//_____________________________________________________________________________
// 1228탎
function RealTraceFire( float Accuracy, float YOffset, float ZOffset )
{
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z, wHitLocation;
    local actor Other, wOther;
    local Material HitMat;
    local Vector vWaterDir;

    if ( DBWeap ) Log("  # RealTracefire call for "$self);

    GetAxes(Instigator.GetViewRotation(),X,Y,Z);
    if ( WHand == WHA_Fist )
    {
      StartTrace = Instigator.Location + Instigator.EyePosition(); // don't use GetFireStart because we don't want to change the target detection w/ diff weapons.
      AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 0);
      EndTrace = StartTrace + 100*vector(AdjustedAim);
//      EndTrace = StartTrace + 100*X;
    }
    else
    if ( WHand == WHA_Deco )
    {
      StartTrace = Instigator.Location + Instigator.EyePosition(); // don't use GetFireStart because we don't want to change the target detection w/ diff weapons.
      AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 0);
      EndTrace = StartTrace + 150*vector(AdjustedAim);
//      EndTrace = StartTrace + 150*X;
    }
    else
    {
      StartTrace = GetFireStart(X,Y,Z);
      if ( ShouldDrawCrosshair() || !Pawn(Owner).IsPlayerPawn() )
        AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 0);
      else
      {
        if ( Instigator.controller != none )
          AdjustedAim = Instigator.controller.rotation;
        else
          AdjustedAim = Instigator.rotation;
      }
      X = vector(AdjustedAim);
      EndTrace = StartTrace + (TraceDist * X);
      EndTrace += vRand() * fRand() * (Accuracy/100.0) * TraceDist;
    }

    if ( AmmoType.bHandToHand )
      Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(0,0,0), HitMat, TRACETYPE_RequestBones);
    else
      Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);

    if ( Other != none )
    {
      wOther = IntersectWaterPlane(StartTrace, HitLocation, wHitLocation);
      if ( wOther != none )
      {
        vWaterDir = wHitLocation - StartTrace;
        vWaterDir.Z = abs(vWaterDir.z) * 8.0;
        WRE = PhysicsVolume(wOther).BeingHitByBullets(wHitLocation+vect(0,0,1), rotator(vWaterDir cross Y), AmmoType.HitSoundType);
      }
    }
    else
    {
      wOther = IntersectWaterPlane(StartTrace, EndTrace, wHitLocation);
      if ( wOther != none )
      {
        vWaterDir = wHitLocation - StartTrace;
        vWaterDir.Z = abs(vWaterDir.z) * 8.0;
        WRE = PhysicsVolume(wOther).BeingHitByBullets(wHitLocation+vect(0,0,1), rotator(vWaterDir cross Y), AmmoType.HitSoundType);
      }
    }

    // Fire noises
    if ( WHand == WHA_Fist )
    {
      if ( Other != none )
        MakeNoise(FireNoise);
    }
    else if ( HasSilencer() )
      MakeNoise(FireNoise/8.33);
    else
      MakeNoise(FireNoise);

    if ( WeaponAttachment(ThirdPersonActor) != None )
      WeaponAttachment(ThirdPersonActor).iBTrailDist = vSize(hitLocation-StartTrace);

    if ( XIIIPawn(Other) != none )
      XIIIPawn(Other).LastBoneHit = GetLastTraceBone();
//    Log("GetLastTraceBone="$GetLastTraceBone());

    if ( WHand == WHA_Fist )
    { // Can break anything if icon is there even if little too far from fists (debug of breaking horizontal panel while underwater)
      if ( Pawn(Owner).IsLocallyControlled() && XIIIPlayerController(Pawn(Owner).Controller).MyInteraction.bCanBreak )
        Other = XIIIPlayerController(Pawn(Owner).Controller).MyInteraction.TargetActor;
    }

    if ( bShouldGoThroughTraversable && XIIIMover(Other)!=none && XIIIMover(Other).bTraversable )
    {
//      Log("bTraversable, 1rst HitMat="$HitMat);
      if ( HitMat != none )
        AmmoType.PlayImpactSound(HitMat.HitSound);
      FeedBack();
      AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z); // 875탎
//      Log("Shooting a bTraversableMover, health left :"@XIIIMover(Other).Health);
      if ( XIIIMover(Other).Health<=0 )
      {
        Other = trace(HitLocation,HitNormal,EndTrace,HitLocation + normal(EndTrace - StartTrace) * 32,True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);
//        Log("Next Target after btraversable :"@other@"hitMat="$HitMat);
        if ( XIIIPawn(Other) != none )
          XIIIPawn(Other).LastBoneHit = GetLastTraceBone();
        if ( HitMat != none )
      	  AmmoType.PlayImpactSound(HitMat.Hitsound);
        AmmoType.AmmoAmount++;
        AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z); // 875탎
      }
    }
    else
    {
      if ( HitMat != none )
        AmmoType.PlayImpactSound(HitMat.HitSound);
      FeedBack();

      AmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z); // 875탎
    }
}

//_____________________________________________________________________________
function TraceAltFire( float Accuracy, float YOffset, float ZOffset )
{
    if ( AltAmmoType.fFireDelay > 0 )
      SetTimer(AltAmmoType.fFireDelay, false);
    else
      RealTraceAltFire(Accuracy, YOffset, ZOffset);
}

//_____________________________________________________________________________
function RealTraceAltFire( float Accuracy, float YOffset, float ZOffset )
{
    local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
    local actor Other;
    local Material HitMat;

//    log("RealTraceAltFire w/accuracy="$Accuracy@"AltTraceDist="$AltTraceDist);

    if ( HasSilencer() )
      MakeNoise(AltFireNoise/8.33);
    else
      MakeNoise(AltFireNoise);
    GetAxes(Instigator.GetViewRotation(),X,Y,Z);
    if ( WHand == WHA_Fist )
    {
      StartTrace = Instigator.Location + Instigator.EyePosition(); // don't use GetFireStart because we don't want to change the target detection w/ diff weapons.
      AdjustedAim = Instigator.AdjustAim(AltAmmoType, StartTrace, 0);
      EndTrace = StartTrace + 100*vector(AdjustedAim);
    }
    else
    if ( WHand == WHA_Deco )
    {
      StartTrace = Instigator.Location + Instigator.EyePosition(); // don't use GetFireStart because we don't want to change the target detection w/ diff weapons.
      AdjustedAim = Instigator.AdjustAim(AltAmmoType, StartTrace, 0);
      EndTrace = StartTrace + 150*vector(AdjustedAim);
    }
    else
    {
      StartTrace = GetAltFireStart(X,Y,Z)+16*X;
      if ( ShouldDrawCrosshair() || !Pawn(Owner).IsPlayerPawn() )
        AdjustedAim = Instigator.AdjustAim(AltAmmoType, StartTrace, 0);
      else
      {
        if ( Instigator.controller != none )
          AdjustedAim = Instigator.controller.rotation;
        else
          AdjustedAim = Instigator.rotation;
      }
      X = vector(AdjustedAim);
      EndTrace = StartTrace + (AltTraceDist * X);
      EndTrace += vRand() * fRand() * (Accuracy/100.0) * AltTraceDist;
    }
    if ( AltAmmoType.bHandToHand )
      Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(0,0,0), HitMat, TRACETYPE_RequestBones);
    else
      Other = Trace(HitLocation, HitNormal, EndTrace, StartTrace, True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon|TRACETYPE_RequestBones);
    if ( WeaponAttachment(ThirdPersonActor) != None )
    {
      WeaponAttachment(ThirdPersonActor).iBTrailDist = vSize(hitLocation-StartTrace);
    }
    if ( XIIIPawn(Other) != none )
      XIIIPawn(Other).LastBoneHit = GetLastTraceBone();
    if ((XIIIMover(other)!=none) && (XIIIMover(Other).bTraversable && bShouldGoThroughTraversable) )
    {
      Other = trace(HitLocation,HitNormal,EndTrace,HitLocation + normal(HitLocation - StartTrace) * 32,True, vect(0,0,0), HitMat, TRACETYPE_DiscardIfCanShootThroughWithRayCastingWeapon);

      if ( HitMat != none )
        AltAmmoType.PlayImpactSound(HitMat.HitSound);
//      else if ( TerrainInfo(Other) != none )
//        AltAmmoType.PlayImpactSound(TerrainInfo(Other).HitSound);

//      if ( (Default.AltReloadCount != 0) && (AltReLoadCount > 0) || ((Default.ReloadCount == 0) && (AltAmmoType.AmmoAmount > 0)) )
      AltFeedBack();
      AltAmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z);
    }
    else
    {
//      log("RealTraceAltFire hit"@other@"HitMat="$HitMat@"");
      if ( HitMat != none )
        AltAmmoType.PlayImpactSound(HitMat.HitSound);
//      else if ( TerrainInfo(Other) != none )
//        AltAmmoType.PlayImpactSound(TerrainInfo(Other).HitSound);
//      if ( (Default.AltReloadCount != 0) && (AltReLoadCount > 0) || ((Default.AltReloadCount == 0) && (AltAmmoType.AmmoAmount > 0)) )
      AltFeedBack();
      AltAmmoType.ProcessTraceHit(self, Other, HitLocation, HitNormal, X,Y,Z);
    }
}

//_____________________________________________________________________________
simulated function UnFire( float Value );

//_____________________________________________________________________________
simulated function SwitchSlave(bool NewEnableSlave)
{
    if ( bChangeWeapon || !bHaveSlave ) // only switch slave if not going down.
      return;

    if ( DBDual ) Log("SWITCHSLAVE Call for"@self@"NewEnableSlave="$NewEnableSlave);
    bEnableSlave = NewEnableSlave;

    if ( !bEnableSlave )
    { // Put slave down
      MySlave.PutDown();
      MySlave.NextSlaveState = 'DownWeapon';
      MySlave.SetTimer2(0.05, false);
    }
    else
    { // bring up slave
      MySlave.SlaveBringUp();
    }

}

//_____________________________________________________________________________
// 2350 탎
simulated function Fire( float Value )
{
// a fire w/ param 1 should mean IA firing.
// a fire w/ param 2 should mean ignore water test.
// a fire w/ param 4 should mean ignore test on controller bFire.
    if ( DBWeap ) Log("  Fire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@" HasAmmo="$HasAmmo()@"Value="$Value);

    if ( (MySlave != none) && bEnableSlave )
      MySlave.SlaveFire();

    if ( (Value != 2.0) && !bUnderWaterWork && Pawn(Owner).HeadVolume.bWaterVolume )
      return;

    if ( !HasAmmo() ) // 11탎
        bEmptyShot=true;

    if ( NeedsToReload() && HasAmmo() )
    { // This should happen for both Server and client
      if ( CanReLoad() )
      {
        GotoState('Reloading');
        ServerReLoad();
      }
      return;
    }

    if ( Level.bLonePlayer )
    {
      LoneFire(Value); // 2296탎
      return;
    }

    if ( Value == 4.0 ) // Magnum specific cheat to allow same ammo use for fire/altfire
      ServerAltFire();
    else
      ServerFire();

    // ELR do the client part of the script, server done in ServerFire called above.
//    if ( (Role < ROLE_Authority) && (HasAmmo() || bEmptyShot) && ((Instigator.controller.bFire != 0) || bIsSlave) )
    if ( (Role < ROLE_Authority) && (HasAmmo() || bEmptyShot) && ((Instigator.controller.bFire != 0) || (Value == 4.0)) )
    {
      if ( !bMeleeWeapon && HasAmmo() )
        ReloadCount--;
      LocalFire();
      GotoState('ClientFiring');
    }
}

//_____________________________________________________________________________
// 2296탎
function LoneFire(float value)
{
    if ( DBWeap ) Log("  LoneFire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@"bEmptyShot="$bEmptyShot@"State="$GetStateName());

/* should be useless
    if ( AmmoType == None )
    { // ammocheck
//      log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAmmo(Instigator);
    }
*/
    Instigator.Controller.NotifyFiring();

//    if ( (HasAmmo() || bEmptyShot) && ((Instigator.controller.bFire != 0) || bIsSlave) )
    if ( (HasAmmo() || bEmptyShot) && ((Instigator.controller.bFire != 0) || (Value == 4.0)) )
    {
      GotoState('NormalFire');
      if ( !bMeleeWeapon && HasAmmo() )
        ReloadCount--;
      LocalFire(); // 822탎
      if ( AmmoType.bInstantHit )
      {
        if ( HasAmmo() )
          TraceFire(fVarAccuracy,0,0); // 1236탎
      }
      else
        ProjectileFire();
    }
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
function ServerFire()
{
    if ( DBWeap ) Log("  ServerFire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@"bEmptyShot="$bEmptyShot@" HasAmmo="$HasAmmo());

    if ( AmmoType == None )
    { // ammocheck
//      log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAmmo(Instigator);
    }
    Instigator.Controller.NotifyFiring();

    if ( (HasAmmo() || bEmptyShot) )
    {
      GotoState('NormalFire');
      if ( !bMeleeWeapon && HasAmmo() )
        ReloadCount--;
      LocalFire();
      if ( AmmoType.bInstantHit )
      {
        if ( HasAmmo() )
          TraceFire(fVarAccuracy,0,0);
      }
      else
        ProjectileFire();
    }
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
simulated function LocalFire()
{
    local PlayerController P;

    if ( DBWeap ) Log("  Localfire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@" HasAmmo="$HasAmmo());

//    bPointing = true;
    if ( HasAmmo() )
    {
      if ( (Instigator != None) && Instigator.IsLocallyControlled() )
      {
        P = PlayerController(Instigator.Controller);
        if (P!=None)
          P.ShakeView(ShakeTime, ShakeMag, ShakeVert, 120000, ShakeSpeed, ShakeCycles); // 50탎
      }
    }

    if ( MyWeaponOno != none )
      MyWeaponOno.FirePrimaryWeapon();

    PlayFiring(); // 738 탎

    // ELR Try to avoid this client flickering ammo amount left.
    if ( (Level.NetMode == NM_Client) && (default.ReloadCount > 0 ) && ((XIIIBulletsAmmo(AmmoType) == none) || !XIIIBulletsAmmo(AmmoType).bInfiniteAmmo) )
    {
      if ( AmmoType.AmmoAmount > 0 )
        AmmoType.AmmoAmount --;
    }

}

//_____________________________________________________________________________
function CauseAltFire()
{
    if ( Level.bLonePlayer )
      Global.LoneAltFire();
    else
      Global.ServerAltFire();
}

//_____________________________________________________________________________
simulated function AltFire( float Value )
{
//    Log("  AltFire call for"@self@"w/ ReLoadCount="$AltReLoadCount@" AmmoAmount="$AltAmmoType.AmmoAmount);
    if ( !bHaveAltFire )
      return;
    if ( !bUnderWaterWork && Pawn(Owner).HeadVolume.bWaterVolume )
      return;

    if ( AltAmmoType == None )
    { // ammocheck
//      log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAltAmmo(Instigator);
    }

    bAltEmptyShot = !HasAltAmmo();
/*
    if ( !HasAltAmmo() )
    {
//      if ( bAltEmptyShot )
//        return;
//      else
        bAltEmptyShot=true;
    }
*/

    if ( AltNeedsToReload() && HasAltAmmo() )
    { // This should happen for both Server and client
//      Log("  in Fire Should send everybody to ReLoading there");
      if ( CanReLoad() )
      {
        GotoState('Reloading');
        ServerReLoad();
        return;
      }
      else
        return;
    }

    if ( Level.bLonePlayer )
    {
      LoneAltFire();
      return;
    }

    ServerAltFire();
    // ELR do the client part of the script, server done in ServerFire called above.
    if ( (Role < ROLE_Authority) && (HasAltAmmo() || bAltEmptyShot) && (Instigator.controller.bAltFire != 0) )
    {
      if ( !bMeleeWeapon && HasAltAmmo() )
        AltReloadCount--;
      LocalAltFire();
      GotoState('ClientAltFiring');
    }
}


//_____________________________________________________________________________
function LoneAltFire()
{
//    Log("  LoneFire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@"bAltEmptyShot="$bAltEmptyShot@"State="$GetStateName());

    if ( AltAmmoType == None )
    { // ammocheck
//      log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAltAmmo(Instigator);
    }
    Instigator.Controller.NotifyFiring();

    if ( (HasAltAmmo() || bAltEmptyShot) && (Instigator.controller.bAltFire != 0) )
    {
      GotoState('NormalAltFire');
      if ( !bMeleeWeapon && HasAltAmmo() )
        AltReloadCount--;
      LocalAltFire();
      if ( AltAmmoType.bInstantHit )
        TraceAltFire(fVarAccuracy,0,0);
      else
        ProjectileAltFire();
    }
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
function ServerAltFire()
{
//    Log("  ServerFire call for"@self@"w/ ReLoadCount="$ReLoadCount@" AmmoAmount="$AmmoType.AmmoAmount@"bAltEmptyShot="$bAltEmptyShot);

    if ( AltAmmoType == None )
    { // ammocheck
//      log("WARNING "$self$" HAS NO AMMO!!!");
      GiveAltAmmo(Instigator);
    }
    Instigator.Controller.NotifyFiring();

    if ( (HasAltAmmo() || bAltEmptyShot) )
    {
      GotoState('NormalAltFire');
      if ( !bMeleeWeapon && HasAltAmmo() )
        AltReloadCount--;
      LocalAltFire();
      if ( AltAmmoType.bInstantHit )
        TraceAltFire(fVarAccuracy,0,0);
      else
        ProjectileAltFire();
    }
    else
      GotoState('Idle');
}


//_____________________________________________________________________________
simulated function LocalAltFire()
{
    local PlayerController P;

    if ( DBWeap ) Log("  LocalAltFire call for"@self@"w/ AltReLoadCount="$AltReLoadCount@" AltAmmoAmount="$AltAmmoType.AmmoAmount@"Ono="$MyWeaponOno);

//    bPointing = true;
    if ( HasAltAmmo() )
    {
      if ( (Instigator != None) && Instigator.IsLocallyControlled() )
      {
        P = PlayerController(Instigator.Controller);
        if ( P!=None )
          P.ShakeView(AltShakeTime, AltShakeMag, AltShakeVert, 120000, AltShakeSpeed, AltShakeCycles);
      }
    }

    if ( MyWeaponOno != none )
      MyWeaponOno.FirePrimaryWeaponAlt();

    PlayAltFiring();
}

//_____________________________________________________________________________
simulated function bool NeedsToReload()
{
    if ( DBWeap ) Log("  NeedsToReLoad call bForceReload="$bForceReload@" result="@( bForceReload || (Default.ReloadCount > 0) && (ReloadCount == 0) ));
    return ( bForceReload || (Default.ReloadCount > 0) && (ReloadCount == 0) );
}

//_____________________________________________________________________________
simulated function bool AltNeedsToReload()
{
    if ( DBWeap ) Log("  AltNeedsToReLoad call bForceReload="$bForceReload@" result="@( bForceReload || (Default.AltReloadCount > 0) && (AltReloadCount == 0) ));
    return ( bForceReload || (Default.AltReloadCount > 0) && (AltReloadCount == 0) );
}

//_____________________________________________________________________________
simulated function bool CanReLoad()
{
    if ( (XIIIPawn(Owner).LHand!= none) && (XIIIPawn(Owner).LHand.pOnShoulder != none) )
      return false;
    return true;
}

//_____________________________________________________________________________
// Finish a sequence
function Finish()
{
    local bool bForce, bForceAlt;
    if ( DBWeap ) Log("> Finish called w/ bForceFire="$bForceFire@"& bForceReLoad="$bForceReLoad@"in state"@GetStateName());

    if ( HasAmmo() && (bAutoReload || !Level.bLonePlayer) && NeedsToReload() )
    {
      GotoState('Reloading');
      return;
    }

    bForce = bForceFire;
    bForceAlt = bForceAltFire;
    bForceFire = false;
    bForceAltFire = false;

    if ( bChangeWeapon )
    {
      GotoState('DownWeapon');
      return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
      GotoState('');
      return;
    }

    if ( !Instigator.IsHumanControlled() )
    {
      if ( !HasAmmo() )
      {
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
          GotoState('DownWeapon');
        else
          GotoState('Idle');
        return;
      }
      if ( NeedsToReload() )
      {
        GotoState('Reloading');
        return;
      }
      if ( Instigator.PressingFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
      {
        if ( Level.bLonePlayer )
          Global.LoneFire(0.0);
        else
          Global.ServerFire();
      }
      else if ( !bSpecialAltFire && Instigator.PressingAltFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
        CauseAltFire();
      else
      {
        Instigator.Controller.StopFiring();
        GotoState('Idle');
      }
      return;
    }

    if ( !HasAmmo() && !HasAltAmmo() )
    {
//      Log("Finish, bAllowEmptyShot="$bAllowEmptyShot@"bLonePlayer=$"$Level.bLonePlayer);
      if ( !bAllowEmptyShot || !Level.bLonePlayer )
      {
        // if local player, switch weapon
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
        {
          GotoState('DownWeapon');
          return;
        }
        else
          GotoState('Idle');
          return;
      }
    }
    if ( (Instigator.Weapon != self) || (!bUnderWaterWork && Pawn(Owner).HeadVolume.bWaterVolume)  )
      GotoState('Idle');
    else if ( (((StopFiringTime > Level.TimeSeconds) || Instigator.PressingFire()) && bAllowShot) || bForce )
    {
      if ( HasAmmo() && NeedsToReLoad() && CanReLoad() )
      {
//        Log("  in Finish Should send everybody to ReLoading there");
        GotoState('Reloading');
        ClientReLoad();
        return;
      }
      else if ( !CanReLoad() )
      {
        gotoState('Idle');
        return;
      }
      Global.ServerFire();
    }
    else if ( !bSpecialAltFire && bHaveAltFire && (bForceAlt || Instigator.PressingAltFire()) && bAllowShot )
      CauseAltFire();
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
// Finish a sequence
function AltFinish()
{
    local bool bForce, bForceAlt;
    if ( DBWeap ) Log("> AltFinish called w/ bForceAltFire="$bForceAltFire@"& bForceReLoad="$bForceReLoad);

    if ( HasAltAmmo() && (bAutoReload || !Level.bLonePlayer) && AltNeedsToReload() )
    {
      GotoState('Reloading');
      return;
    }

    bForce = bForceFire;
    bForceAlt = bForceAltFire;
    bForceFire = false;
    bForceAltFire = false;

    if ( bChangeWeapon )
    {
      GotoState('DownWeapon');
      return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
      GotoState('');
      return;
    }

    if ( !Instigator.IsHumanControlled() )
    {
      if ( !HasAltAmmo() )
      {
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
          GotoState('DownWeapon');
        else
          GotoState('Idle');
        return;
      }
      if ( AltNeedsToReload() )
      {
        GotoState('Reloading');
        return;
      }
      if ( Instigator.PressingFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
      {
        if ( Level.bLonePlayer )
          Global.LoneFire(0.0);
        else
          Global.ServerFire();
      }
      else if ( !bSpecialAltFire && bHaveAltFire && Instigator.PressingAltFire() && (bUnderWaterWork || !Pawn(Owner).HeadVolume.bWaterVolume) )
        CauseAltFire();
      else
      {
        Instigator.Controller.StopFiring();
        GotoState('Idle');
      }
      return;
    }

    if ( !HasAmmo() && !HasAltAmmo() )
    {
      if ( !bAllowEmptyShot || !Level.bLonePlayer )
      {
        // if local player, switch weapon
        Instigator.Controller.SwitchToBestWeapon();
        if ( bChangeWeapon )
        {
          GotoState('DownWeapon');
          return;
        }
        else
          GotoState('Idle');
          return;
      }
    }
    if ( (Instigator.Weapon != self) || (!bUnderWaterWork && Pawn(Owner).HeadVolume.bWaterVolume)  )
      GotoState('Idle');
    else if ( (((StopFiringTime > Level.TimeSeconds) || Instigator.PressingFire()) && bAllowShot) || bForce )
    {
      if ( HasAmmo() && NeedsToReLoad() && CanReLoad() )
      {
//        Log("  in AltFinish Should send everybody to ReLoading there");
        GotoState('Reloading');
        ClientReLoad();
        return;
      }
      else if ( !CanReLoad() )
      {
        gotoState('Idle');
        return;
      }
      Global.ServerFire();
    }
    else if ( !bSpecialAltFire && bHaveAltFire && (bForceAlt || Instigator.PressingAltFire()) && bAllowShot )
    {
      if ( HasAltAmmo() && AltNeedsToReLoad() && CanReLoad() )
      {
//        Log("  in AltFinish Should send everybody to ReLoading there");
        GotoState('Reloading');
        ClientReLoad();
        return;
      }
      else if ( !CanReLoad() )
      {
        gotoState('Idle');
        return;
      }
      CauseAltFire();
    }
    else
      GotoState('Idle');
}

//_____________________________________________________________________________
simulated function ClientFinish()
{
    if ( DBWeap ) Log("> ClientFinish called HasAmmo="$HasAmmo()@"bAllowShot="$bAllowShot);

    if ( HasAmmo() && (bAutoReload || !Level.bLonePlayer) && NeedsToReload() )
    {
      GotoState('Reloading');
      return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
      GotoState('');
      return;
    }
    if ( HasAmmo() && NeedsToReLoad() && Instigator.PressingFire() )
    {
//      Log("  in ClientFinish goto reloading");
      GotoState('Reloading');
      ServerReLoad();
      return;
    }
    if ( !HasAmmo() && !HasAltAmmo() )
    {
      if ( !bAllowEmptyShot || !Level.bLonePlayer )
      {
        Instigator.Controller.SwitchToBestWeapon();
        if ( !bChangeWeapon )
        {
          PlayIdleAnim();
          GotoState('Idle');
          return;
        }
      }
      else
      {
        PlayIdleAnim();
        GotoState('Idle');
        return;
      }
    }
    if ( bChangeWeapon )
      GotoState('DownWeapon');
    else if ( Instigator.PressingFire() && bAllowShot )
      Global.Fire(0);
    else
    {
      if ( !bSpecialAltFire && bHaveAltFire && Instigator.PressingAltFire() && bAllowShot )
        Global.AltFire(0);
      else
      {
        PlayIdleAnim();
        GotoState('Idle');
      }
    }
}

//_____________________________________________________________________________
simulated function ClientAltFinish()
{
    if ( DBWeap ) Log("> ClientAltFinish called");

    if ( HasAltAmmo() && (bAutoReload || !Level.bLonePlayer) && AltNeedsToReload() )
    {
      GotoState('Reloading');
      return;
    }

    if ( (Instigator == None) || (Instigator.Controller == None) )
    {
      GotoState('');
      return;
    }
    if ( !bSpecialAltFire && bHaveAltFire && HasAltAmmo() && AltNeedsToReLoad() && Instigator.PressingAltFire() )
    {
//      Log("  in ClientAltFinish goto reloading");
      GotoState('Reloading');
      ServerReLoad();
      return;
    }
    if ( !HasAmmo() && !HasAltAmmo() )
    {
      if ( !bAllowEmptyShot || !Level.bLonePlayer )
      {
        Instigator.Controller.SwitchToBestWeapon();
        if ( !bChangeWeapon )
        {
          PlayIdleAnim();
          GotoState('Idle');
          return;
        }
      }
      else
      {
        PlayIdleAnim();
        GotoState('Idle');
        return;
      }
    }
    if ( bChangeWeapon )
      GotoState('DownWeapon');
    else if ( Instigator.PressingFire() && bAllowShot )
      Global.Fire(0);
    else
    {
      if ( !bSpecialAltFire && bHaveAltFire && Instigator.PressingAltFire() && bAllowShot )
        Global.AltFire(0);
      else
      {
        PlayIdleAnim();
        GotoState('Idle');
      }
    }
}

//_____________________________________________________________________________
simulated function SetupMuzzleFlash()
{
    if ( bZoomed )
      return;
    bMuzzleFlash = true;
    // No use in trying to turn if DrawType = DT_Sprite... trying using third person models
    if ( FirstPersonMF != none )
    {
      FPMFRelativeRot.Roll = Rand(2500)-1250;
      FirstPersonMF.SetRelativeRotation(FPMFRelativeRot);
    }
    bSetFlashTime = false;
    fTraceBulletCount += AmmoType.fTraceFrequency * RandRange(0.7, 1.3);
    if ( fTraceBulletCount >= 1.0 )
    {
      bTracebullets = true;
      fTraceBulletCount = 0.0;
    }
    else
      bTracebullets = false;
}

//_____________________________________________________________________________
state NormalFire
{
    event BeginState()
    {
//      Log("> #NormalFire BeginState");
//      if ( Instigator.IsPlayerPawn() && (XIIIWeaponAttachment(ThirdPersonActor) != none) && XIIIWeaponAttachment(ThirdPersonActor).bSpawnShells )
//        Instigator.PlayRolloffSound(hShellsSound, self, 1);
    }

    simulated function Zoom()
    {
//      Log("ZOOM NORMALFIRE call for"@self);
      if ( bZoomed )
      {
        PlayerController(Instigator.Controller).ToggleZoom();
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 1);
        bZoomed = false;
        iAltZoomLevel = 0;
        return;
      }
//      SwitchSlave(!bEnableSlave);
    }

    event AnimEnd(int Channel)
    {
      if ( (fVarAccuracy < TraceAccuracy) && bRapidFire )
        fVarAccuracy = fMin(TraceAccuracy, fVarAccuracy + TraceAccuracy/5.0);
      else
        fVarAccuracy = TraceAccuracy;
      Finish();
    }

    event EndState()
    {
//      if ( Instigator.IsPlayerPawn() && (XIIIWeaponAttachment(ThirdPersonActor) != none) && XIIIWeaponAttachment(ThirdPersonActor).bSpawnShells )
//        Instigator.PlayRolloffSound(hShellsSound, self, 0);
      StopFiringTime = Level.TimeSeconds;
    }

    function Timer()
    {
      local Vector Start, X,Y,Z;

      if ( !AmmoType.bInstantHit )
      {
        MakeNoise(FireNoise);
        GetAxes(Instigator.GetViewRotation(),X,Y,Z);
        Start = GetFireStart(X,Y,Z);
        AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0);
//        if ( (Default.ReloadCount != 0) && (ReLoadCount > 0) || ((Default.ReloadCount == 0) && HasAmmo()) )
          FeedBack();
        AmmoType.SpawnProjectile(Start,AdjustedAim);
      }
      else
      {
        RealTraceFire(fVarAccuracy,0,0);
      }
    }
Begin:
  if ( WeaponMode == WM_SemiAuto )
    bAllowShot = false;
  else if ( WeaponMode == WM_Burst )
  {
    iBurstCount ++;
    if ( iBurstCount > 2 )
    {
      bAllowShot = false;
      iBurstCount = 0;
    }
    else
      bAllowShot = true;
  }
  else
    bAllowShot = true;
}

//_____________________________________________________________________________
state NormalAltFire
{
    event BeginState()
    {
//      Log("> NormalAltFire BeginState");
//      if ( Instigator.IsPlayerPawn() && (XIIIWeaponAttachment(ThirdPersonActor) != none) && XIIIWeaponAttachment(ThirdPersonActor).bSpawnShells )
//        Instigator.PlayRolloffSound(hShellsSound, self, 1);
    }

    simulated function Zoom()
    {
//      Log("ZOOM NORMALALTFIRE call for"@self);
      if ( bZoomed )
      {
        PlayerController(Instigator.Controller).ToggleZoom();
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 1);
        bZoomed = false;
        iAltZoomLevel = 0;
        return;
      }
    }

    event AnimEnd(int Channel)
    {
      if ( (fVarAccuracy < TraceAccuracy) && bRapidFire )
        fVarAccuracy = fMin(TraceAccuracy, fVarAccuracy + TraceAccuracy/5.0);
      else
        fVarAccuracy = TraceAccuracy;
      AltFinish();
    }

    event EndState()
    {
//      if ( Instigator.IsPlayerPawn() && (XIIIWeaponAttachment(ThirdPersonActor) != none) && XIIIWeaponAttachment(ThirdPersonActor).bSpawnShells )
//        Instigator.PlayRolloffSound(hShellsSound, self, 0);
      StopFiringTime = Level.TimeSeconds;
    }

    event Timer()
    {
      local Vector Start, X,Y,Z;

      if ( !AltAmmoType.bInstantHit )
      {
        MakeNoise(AltFireNoise);
        GetAxes(Instigator.GetViewRotation(),X,Y,Z);
        Start = GetAltFireStart(X,Y,Z);
        AdjustedAim = Instigator.AdjustAim(AmmoType, Start, 0);
//        AdjustedAim = Instigator.AdjustAim(AltAmmoType, Start, 0);
//        if ( (Default.AltReloadCount != 0) && (AltReLoadCount > 0) || ((Default.AltReloadCount == 0) && (AltAmmoType.AmmoAmount > 0)) )
          AltFeedBack();
        AltAmmoType.SpawnProjectile(Start,AdjustedAim);
      }
      else
      {
        RealTraceAltFire(fVarAccuracy,0,0);
      }
    }

Begin:
  if ( WeaponMode == WM_SemiAuto )
    bAllowShot = false;
  else if ( WeaponMode == WM_Burst )
  {
    iBurstCount ++;
    if ( iBurstCount > 2 )
    {
      bAllowShot = false;
      iBurstCount = 0;
    }
    else
      bAllowShot = true;
  }
  else
    bAllowShot = true;
}

//_____________________________________________________________________________
//Fire on the client side. This state is only entered on the network client of the player that is firing this weapon.
state ClientFiring
{
Begin:
  if ( WeaponMode == WM_SemiAuto )
    bAllowShot = false;
  else if ( WeaponMode == WM_Burst )
  {
    iBurstCount ++;
    if ( iBurstCount > 2 )
    {
      bAllowShot = false;
      iBurstCount = 0;
    }
    else
      bAllowShot = true;
  }
  else
    bAllowShot = true;
}


//_____________________________________________________________________________
//Fire on the client side. This state is only entered on the network client of the player that is firing this weapon.
state ClientAltFiring
{
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    simulated event AnimEnd(int Channel)
    {
      ClientAltFinish();
    }

    simulated event EndState()
    {
      AmbientSound = None;
      if ( RepeatFire() && !bPendingDelete )
        ServerStopFiring();
    }

    simulated event BeginState()
    {
//      Log("> ClientFiring BeginState");
    }
Begin:
  if ( WeaponMode == WM_SemiAuto )
    bAllowShot = false;
  else if ( WeaponMode == WM_Burst )
  {
    iBurstCount ++;
    if ( iBurstCount > 2 )
    {
      bAllowShot = false;
      iBurstCount = 0;
    }
    else
      bAllowShot = true;
  }
  else
    bAllowShot = true;
}

//_____________________________________________________________________________
state Reloading
{
    function ServerForceReload() {}
    function ClientForceReload() {}
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      bChangeWeapon = true;
      return True;
    }

    simulated event BeginState()
    {
//      Log("> ReLoading BeginState");
      if ( DBDual ) Log(">> Reloading BeginState for "$self);
      if ( bZoomed )
      {
        bZoomed=false;
        PlayerController(Instigator.Controller).ToggleZoom();
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 1);
        iAltZoomLevel = 0;
      }

      bEmptyShot=false;
      bAltEmptyShot=false;

      if ( (MySlave != none) && !MySlave.IsInState('WaitForMasterReload') && bEnableSlave )
      {
        MySlave.GotoState('WaitForMasterReload');
        GotoState('WaitForSlaveDown');
        return;
      }
      if ( (SlaveOf != none) && !SlaveOf.IsInState('WaitForSlaveReload') )
      {
        SlaveOf.GotoState('WaitForSlaveReload');
        GotoState('WaitForMasterDown');
        return;
      }

      if ( !bForceReload )
      {
        if ( Role < ROLE_Authority )
          ServerForceReload();
        else
          ClientForceReload();
      }
      bForceReload = false;

      if ( MyWeaponOno != none )
        MyWeaponOno.ReloadPrimaryWeapon();

      PlayReloading();
      IncrementReloadClientCount();
/*
      if ( XIIIWeaponAttachment(ThirdPersonActor) != None )
        XIIIWeaponAttachment(ThirdPersonActor).ThirdPersonReLoad();
*/
    }

    simulated event AnimEnd(int Channel)
    {
      if ( MySlave != none )
      {
        ReloadCount = Min(Default.ReloadCount, AmmoType.AmmoAmount);
        MySlave.ReloadCount = Min(Default.ReloadCount, AmmoType.AmmoAmount - ReloadCount);
      }
      else if ( SlaveOf != none )
      {
        SlaveOf.ReloadCount = Min(Default.ReloadCount, AmmoType.AmmoAmount);
        ReloadCount = Min(Default.ReloadCount, AmmoType.AmmoAmount - SlaveOf.ReloadCount);
      }
      else
        ReloadCount = Min(Default.ReloadCount, AmmoType.AmmoAmount);

      if ( bHaveAltFire && (AltAmmoType != none) )
        AltReloadCount = Min(Default.AltReloadCount, AltAmmoType.AmmoAmount);
      if ( Role < ROLE_Authority )
        ClientFinish();
      else
        Finish();
      if ( (MySlave != none) && bEnableSlave )// && MySlave.IsInState('WaitForMasterReload') )
      {
        MySlave.BringUp();
      }
      if ( (SlaveOf != none) ) //&& SlaveOf.IsInState('WaitForSlaveReload') )
        SlaveOf.BringUpNoSlave();
    }
}

//_____________________________________________________________________________
state WaitForMasterReload
{
    function ServerForceReload() {}
    function ClientForceReload() {}
    function Fire( float Value ) {}
    function AltFire( float Value ) {}
    event Timer2();

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      bChangeWeapon = true;
      return True;
    }
    event BeginState()
    {
      if ( DBDual ) Log(">> WaitForMasterReload BeginState for "$self);
      PlayAnim('Down', 2.0);
    }
    event AnimEnd(int channel)
    {
      if ( DBDual ) Log(">> WaitForMasterReload AnimEnd for "$self);
      SlaveOf.GotoState('Reloading');
    }
    event EndState()
    {
      if ( DBDual ) Log(" > WaitForMasterReload EndState for "$self);
      Finish();
    }
}

state WaitForSlaveDown
{
    function ServerForceReload() {}
    function ClientForceReload() {}
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      bChangeWeapon = true;
      return True;
    }
    event BeginState()
    {
      if ( DBDual ) Log(">> WaitForSlaveDown BeginState for "$self);
    }
    event EndState()
    {
      if ( DBDual ) Log(" > WaitForSlaveDown EndState for "$self);
    }
}

//_____________________________________________________________________________
state WaitForSlaveReload
{
    function ServerForceReload() {}
    function ClientForceReload() {}
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      bChangeWeapon = true;
      return True;
    }
    event BeginState()
    {
      if ( DBDual ) Log(">> WaitForSlaveReload BeginState for "$self);
      PlayAnim('Down', 2.0);
    }
    event AnimEnd(int channel)
    {
      if ( DBDual ) Log(">> WaitForSlaveReload AnimEnd for "$self);
      MySlave.GotoState('Reloading');
    }
    event EndState()
    {
      if ( DBDual ) Log(" > WaitForSlaveReload EndState for "$self);
      Finish();
    }
}

state WaitForMasterDown
{
    function ServerForceReload() {}
    function ClientForceReload() {}
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      bChangeWeapon = true;
      return True;
    }
    event BeginState()
    {
      if ( DBDual ) Log(">> WaitForMasterDown BeginState for "$self);
    }
    event EndState()
    {
      if ( DBDual ) Log(" > WaitForMasterDown EndState for "$self);
    }
}

//_____________________________________________________________________________
/* Bring newly active weapon up.
The weapon will remain in this state while its selection animation is being played (as well as any postselect animation).
While in this state, the weapon cannot be fired.
*/
state Active
{
    simulated function BringUp() { bRendered = true; }
    function Fire( float Value ) {}
    function AltFire( float Value ) {}

    function ServerFire()
    {
      bForceFire = true;
    }

    function ServerAltFire()
    {
      bForceAltFire = true;
    }

    simulated function bool PutDown()
    {
      local name anim;
      local float frame,rate;

      if ( DBWeap )
        Log(self@"Active PutDown bIsSlave="$bIsSlave@"MySlave="$MySlave);

      GetAnimParams(0,anim,frame,rate);
      bChangeWeapon = true;

      if ( bIsSlave )
      { // immediate order ?
        gotoState('DownWeapon');
        return true;
      }
      if ( bHaveSlave )
      {
        MySlave.PutDown();
        MySlave.NextSlaveState = 'DownWeapon';
        MySlave.SetTimer2(0.05, false);
      }
      return True;
    }

    simulated event BeginState()
    {
      if ( DBWeap )
        Log(self@"Active BeginState");
      Instigator = Pawn(Owner);
      bForceFire = false;
      bForceAltFire = false;
      bChangeWeapon = false;
      bZoomed = false;
      bMuzzleFlash = false;
      bTracebullets = false;
      UpDateSilencer();
      if ( Instigator.IsLocallyControlled() )
      {
//        Log(Level.TimeSeconds@"Activate BeginState, bRendered goes true");
        SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
        SetBase(Instigator.Controller);
        bRendered = true;
//        bHidden = false;
//        RefreshDisplaying();
      }
      if ( Default.ReLoadCount > 0 ) // ELR DBUG of the use of single ammotype for different weapons
      {
        if ( AmmoType == none ) // Multiplayer on-line for client's default weapon ?!
        {
          Log("Active Beginstate GiveAmmo because AmmoType none");
          GiveAmmo(Instigator);
        }

        else if ( MySlave != none )
          ReloadCount = Min(ReloadCount, AmmoType.AmmoAmount - MySlave.ReloadCount);
        else if ( SlaveOf != none )
          ReloadCount = Min(ReloadCount, AmmoType.AmmoAmount - SlaveOf.ReloadCount);
        else
          ReloadCount = Min(ReloadCount, AmmoType.AmmoAmount);
      }
      XIIIPawn(Owner).SetFiringMode(FiringMode);
    }

    simulated event EndState()
    {
      bForceFire = false;
      bForceAltFire = false;
    }

    simulated event AnimEnd(int Channel)
    {
      if ( DBWeap )
        Log(self@"Active AnimEnd");
      if ( WeaponMode == WM_SemiAuto )
        bAllowShot = false;
      if ( bChangeWeapon )
      {
        GotoState('DownWeapon');
        return;
      }
      if ( Owner == None )
      {
//        log(self$" no owner");
//        Global.AnimEnd(0);
        GotoState('');
      }
      else
      {
        if ( Role == ROLE_Authority )
          Finish();
        else
          ClientFinish();
      }
    }
}

//_____________________________________________________________________________
State DownWeapon
{
    function Fire( float Value ) {}
    function AltFire( float Value ) {}
    function ServerFire() {}
    function ServerAltFire() {}

    simulated function bool PutDown()
    {
      return true; //just keep putting it down
    }

    simulated event AnimEnd(int Channel)
    {
      if ( bHeavyWeapon )
        XIIIPawn(Owner).SetGroundSpeed(1.0);
      if ( !bIsSlave )
        Pawn(Owner).ChangedWeapon();
      if ( (Pawn(Owner).Weapon != self) || (Pawn(Owner).IsPlayerPawn() && !XIIIPlayerController(Pawn(Owner).Controller).bWeaponMode) )
      {
        bRendered = false;
        bHidden = true;
        RefreshDisplaying();
        if ( MySlave != none )
        {
          MySlave.bRendered = false;
          MySlave.bHidden = true;
          MySlave.RefreshDisplaying();
        }
      }
    }

    simulated event BeginState()
    {
      if ( DBWeap )
        Log(self@"DownWeapon BeginState MySlave="$MySlave);
      if ( FirstPersonMF != none )
      {
        FirstPersonMF.Destroy();
        FirstPersonMF = none;
      }
      bChangeWeapon = false;
      bMuzzleFlash = false;
      if ( bZoomed )
      {
        bZoomed=false;
        PlayerController(Instigator.Controller).ToggleZoom();
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 1);
        iAltZoomLevel = 0;
      }

      TweenDown();
      if ( XIIIWeaponAttachment(ThirdPersonActor) != None )
        XIIIWeaponAttachment(ThirdPersonActor).ThirdPersonSwitchWeapon();
      if ( MySlave != none )
      {
        MySlave.PutDown();
        MySlave.NextSlaveState = 'DownWeapon';
        MySlave.SetTimer2(0.05, false);
      }
    }
}

//_____________________________________________________________________________
state Zooming
{
    simulated event Tick(float DeltaTime)
    {
      if ( !Instigator.PressingAltFire() )
      {
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 2);
        if ( Instigator.IsLocallyControlled() )
          PlayerController(Instigator.Controller).StopZoom();
        SetTimer(0.0,False);
        bZoomed=true;
        GoToState('Idle');
      }
      else if (PlayerController(Instigator.Controller).FovAngle < ScopeFov)
      {
        if ( Instigator.IsLocallyControlled() )
        {
          PlayerController(Instigator.Controller).StopZoom();
          PlayerController(Instigator.Controller).SetFov(ScopeFov);
        }
        if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
          Instigator.PlayRolloffSound(hZoomSound, self, 2);
        SetTimer(0.0,False);
        bZoomed=true;
        GoToState('Idle');
      }
    }

    simulated event BeginState()
    {
      if ( Instigator.IsHumanControlled() )
      {
        if ( Instigator.IsLocallyControlled() )
        {
          if ( bZoomed )
          {
//            Log(self$"ToggleZoom");
            PlayerController(Instigator.Controller).ToggleZoom();
            if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
              Instigator.PlayRolloffSound(hZoomSound, self, 1);
            gotoState('Idle');
          }
          else
          {
            PlayerController(Instigator.Controller).StartZoom();
            PlayerController(Instigator.Controller).ZoomLevel = 0.3;
            PlayerController(Instigator.Controller).SetFov(FClamp(90.0 - (0.3 * 88.0), 1, 170));
            if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
              Instigator.PlayRolloffSound(hZoomSound, self, 0);
//            Log(self$"StartZoom, ZoomLevel="$PlayerController(Instigator.Controller).ZoomLevel);
          }
          bZoomed = false;
        }
      }
      else
      {
        Instigator.Controller.bFire = 1;
        Instigator.Controller.bAltFire = 0;
        Global.Fire(0);
      }
    }
}

//_____________________________________________________________________________
state AltZooming
{
    simulated event Tick(float DeltaTime)
    {
      if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
        Instigator.PlayRolloffSound(hZoomSound, self, 2);
      SetTimer(0.0,False);
      bZoomed = true;
      if (PlayerController(Instigator.Controller).FovAngle < ScopeFov)
        PlayerController(Instigator.Controller).SetFov(ScopeFov);
      GoToState('Idle');
    }

    simulated event BeginState()
    {
      if ( Instigator.IsHumanControlled() )
      {
        if ( Instigator.IsLocallyControlled() )
        {
          iAltZoomLevel ++;
          if ( bZoomed && (iAltZoomLevel>Default.iAltZoomLevel) )
          {
//            Log(self$"ToggleZoom");
            PlayerController(Instigator.Controller).ToggleZoom();
            if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone)  )
              Instigator.PlayRolloffSound(hZoomSound, self, 1);
            iAltZoomLevel = 0;
            gotoState('Idle');
          }
          else
          {
            PlayerController(Instigator.Controller).ZoomLevel = fAltZoomValue[iAltZoomLevel-1];
            PlayerController(Instigator.Controller).SetFov(FClamp(90.0 - (PlayerController(Instigator.Controller).ZoomLevel * 88.0), 1, 170));
            if ( Instigator.IsLocallyControlled() || (Level.NetMode == NM_StandAlone) )
              Instigator.PlayRolloffSound(hZoomSound, self, 0);
//            Log(self$"StartZoom, ZoomLevel="$PlayerController(Instigator.Controller).ZoomLevel);
          }
          bZoomed=false;
        }
      }
      else
      {
        Instigator.Controller.bFire = 1;
        Instigator.Controller.bAltFire = 0;
        Global.Fire(0);
      }
    }
}

//_____________________________________________________________________________
state Idle
{
    simulated function ForceReload()
    { // ELR check here that we have enough ammo to reload
//      Log("  ForceReload Call in Idle");
      if ( (ReLoadCount < AmmoType.AmmoAmount) && (Default.ReLoadCount > 0) && (Default.ReLoadCount != ReLoadCount) && CanReLoad() )
      {
        if ( bHaveSlave ) // ELR Reset Slave reload count to zero before reloading to avoid bug w/ primary empty & dual full
          MySlave.ReloadCount = 0;

        ServerForceReload();
        if ( HasAmmo() )
          GotoState('Reloading');
      }
      else if ( bHaveAltFire && (AltAmmoType != none) )
      {
        if ( (AltReLoadCount < AltAmmoType.AmmoAmount) && (Default.AltReLoadCount > 0) && (Default.AltReLoadCount != AltReLoadCount) && CanReLoad() )
        {
          ServerForceReload();
          if ( HasAltAmmo() )
            GotoState('Reloading');
        }
      }
    }

    function ServerForceReload()
    {
//      Log("  ServerForceReload Call in Idle");
      if ( HasAmmo() || HasAltAmmo() )
        GotoState('Reloading');
    }
    function ClientForceReload()
    {
//      Log("  ClientForceReload Call in Idle");
      if ( HasAmmo() || HasAltAmmo() )
        GotoState('Reloading');
    }

    simulated event AnimEnd(int Channel)
    {
//      log("AnimEnd received for "@self@"in state"@GetStateName()@"animsequence="@AnimSequence);
      if ( bHaveBoredSfx && (Owner != none) && Pawn(Owner).IsPlayerPawn() )
      {
        if ( Pawn(Owner).Velocity == vect(0,0,0) )
        {
          iBoredCount ++;
        }
      }
      if ( bRapidfire )
        fVarAccuracy = fMax(TraceAccuracy/3.0, fVarAccuracy - TraceAccuracy/6.0);
      else
        fVarAccuracy = TraceAccuracy;
      PlayIdleAnim();
//      Log(self$"Playing Idle, fVarAccuracy="$fVarAccuracy);
    }

    simulated function bool PutDown()
    {
      GotoState('DownWeapon');
      return True;
    }
    simulated function Zoom()
    {
//      Log("ZOOM IDLE call for"@self);
      if ( HasScope() )
      {
        if ( XIIIPlayerController(Pawn(Owner).controller).bAltZoomingSystem )
          GotoState('AltZooming');
        else
          GotoState('Zooming');
        return;
      }
      SwitchSlave(!bEnableSlave);
    }
    simulated event BeginState()
    {
      PlayIdleAnim();
      iBoredCount = 0;
    }
Begin:
  if ( !Instigator.PressingFire() )
    bAllowShot=true;
  if ( WeaponMode == WM_SemiAuto )
    bAllowShot = false;
  if ( Instigator.PressingFire() && bAllowShot) Fire(0.0);
  if ( bHaveAltFire && Instigator.PressingAltFire() ) AltFire(0.0);
}

//    CrossHair=Texture'XIIIMenu.MireCouteau'
//    Icon=texture'XIIIMenu.FistsIcon'
//    hShellsSound=Sound'XIIIsound.Guns__Shells.Shells__hShellsFall'


defaultproperties
{
     bAllowEmptyShot=True
     bAllowShot=True
     ScopeFOV=10.000000
     FireNoise=2.624000
     ReLoadNoise=0.157000
     AltFireNoise=0.157000
     StabilityTex=Texture'XIIIMenu.HUD.fondialog'
     FirstPersonMFClass=Class'XIII.FirstPersonMuzzleFlash'
     FPMFRelativeRot=(Yaw=16384)
     FlashLength=0.030000
     MuzzleFlashSize=128.000000
     MFTexture=Texture'XIIIMenu.SFX.MuzzleFlash1'
     BobDamping=0.900000
     AttachmentClass=Class'XIII.XIIIWeaponAttachment'
     bDelayDisplay=True
     bSpecialDelayFov=True
}
