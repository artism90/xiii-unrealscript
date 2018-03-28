//-----------------------------------------------------------
//
//-----------------------------------------------------------

class WeaponOno extends Info;

//#exec OBJ LOAD FILE=XIIIXboxPacket.utx

var material MyOno;

enum OnoType
{
    ONOTYPE_DISABLED,
    ONOTYPE_FIXED,
    ONOTYPE_FADECENTERED,
    ONOTYPE_FADECENTER,
    ONOTYPE_EXPAND,
    ONOTYPE_RATATA,
    ONOTYPE_RATARATA
};

var OnoType myOnoType;
var int     weaponFired[4];      // Primary == 0 secondary == 1 noammo == 2         reload == 3 not used yet....
var float   weaponFiredTimer;

// VARS THAT CAN BE TWEAKED
// These default settings should be overridded if required
// in PostBeginPlay() for respective weapon
var float   fadeTime;                 // HOW LONG WILL A TEXT BE VISIBLE (it wades down smoothly using a sine function...
var int     onoPosXRandMin,           // rand position relative Canvas.ClipX*0.5
            onoPosXRandMax;
var int     onoPosYRandMin,           // rand position relative Canvas.ClipY*0.5
            onoPosYRandMax;
var float   scaleRandDeltaMin, scaleRandDeltaMax;  // ]0, 10]      1.0 is default and results in no scaling.
                                                   // for ratatata effects scaleRandDeltaMin is the "left" size and scaleRandDeltaMax the right...  Set to 1.0 for no variation.
// VARS THAT CAN BE TWEAKED
var int     onoPosX, onoPosY;         // position where the ono text is rendered (randomized)
var int     scaleFactor;              // based on scaleRandDeltaMin, scaleRandDeltaMax;   1,0 by default
var bool    renderOno;                // enables /disables the actual rendering of the ono....
var texture weaponOnoTexture;         // Primary texture for primaty weapon.. Also the first texture in the compound RAtatata
var texture weaponOnoTexture2;        // the TA in the compund RATATATA effect
var texture weaponNoAmmoOnoTexture;   // Out of ammo "Click"
var texture weaponReloadOnoTexture;   // not used yet
var texture weaponSilencerOnoTexture; // Only used for the beretta right now
var texture weaponOnoAltTexture;      // Secondary fire on primary weapon
var float   lastBurstTime;            // Makes the Ratata restart when you've released fire for a short time and continues shooting
var texture onoTextureToRender;
var texture onoTexture2ToRender;      // some weapons like the RA TA TA needs two textures

CONST DBOno=false;
//_____________________________________________________________________________
simulated event RenderOverlays( canvas Canvas )
{
//    Canvas.SetPos(0,0);
//    Canvas.font = class'xiiibasehud'.default.smallfont;
//    Canvas.DrawText("WeaponOnoOverLays for class "$owner.class);

  switch (myOnoType)
  {
    case ONOTYPE_DISABLED:
      return;
    break;

    case ONOTYPE_EXPAND:
    case ONOTYPE_FIXED:
      updateFixed();
      renderFixed(Canvas);
    break;

    case ONOTYPE_RATATA:
    case ONOTYPE_RATARATA:
      updateRatata();
      renderRatata(Canvas);
    break;

  }
}

//_____________________________________________________________________________
simulated function updateFixed()
{
  if ( weaponFiredTimer < Level.TimeSeconds )
    renderOno = false;

  if (weaponFired[0] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    onoTextureToRender  = weaponOnoTexture;//
    scaleFactor         = RandRange(scaleRandDeltaMin,scaleRandDeltaMax);
    if ( onoTextureToRender != none )
      renderOno         = true;
    else
      renderOno         = false;
  }
  else if (weaponFired[2] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    onoTextureToRender  = weaponNoAmmoOnoTexture;
    scaleFactor         = RandRange(scaleRandDeltaMin,scaleRandDeltaMax);
    renderOno           = true;
  }
  else if (weaponFired[1] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    scaleFactor         = RandRange(scaleRandDeltaMin,scaleRandDeltaMax);
    onoTextureToRender  = weaponOnoAltTexture;
    renderOno           = true;
  }
  else if (weaponFired[3] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    onoTextureToRender = weaponReloadOnoTexture;
    renderOno          = true;
  }

  if (onoTextureToRender == none)
    renderOno          = false;

  weaponFired[0] = 0;
  weaponFired[1] = 0;
  weaponFired[2] = 0;
  weaponFired[3] = 0;

  //log("updatefixed");

}

//_____________________________________________________________________________
simulated function renderFixed(canvas Canvas)
{
    local byte alpha;
    local float fAlpha;

    if ( !renderOno )
        return;
    // if (weaponFired[2])
    // weaponFiredTimer = Level.TimeSeconds + FlashLength;
    // RandRange(,)
    if ( DBOno )Log("ONO"@self@"RenderFixed");

    Canvas.Style = ERenderStyle.STY_Alpha;

    fAlpha = (weaponFiredTimer - Level.TimeSeconds)/fadeTime;
    alpha  = sin(fAlpha*3.14159265*0.5)*255.0;
    Canvas.SetDrawColor(255,255,255,alpha);

    Canvas.SetPos(Canvas.ClipX*0.5 + onoPosX, Canvas.ClipY*0.5 + onoPosY);
    if (myOnoType == ONOTYPE_EXPAND)
    {
      Canvas.SetDrawColor(255,255,255,255);
      Canvas.DrawTile(onoTextureToRender, scaleFactor*120.0*(1.0-fAlpha)+40.0, scaleFactor*120.0*(1.0-fAlpha)+40.0, 0,0, onoTextureToRender.USize, onoTextureToRender.VSize);
    }
    else
    {
//      if (Weapon(owner).HasSilencer())
//        Canvas.DrawTile(weaponSilencerOnoTexture, scaleFactor*40.0*(fAlpha)+140.0, scaleFactor*40.0*(fAlpha)+40.0, 0,0, weaponSilencerOnoTexture.USize, weaponSilencerOnoTexture.VSize);
//      else
        Canvas.DrawTile(      onoTextureToRender, scaleFactor*40.0*(fAlpha)+40.0, scaleFactor*40.0*(fAlpha)+40.0, 0,0, onoTextureToRender.USize, onoTextureToRender.VSize);
    }
//    Canvas.font = class'xiiibasehud'.default.smallfont;
//    Canvas.DrawText("FIXE0D WeaponOnoOverLays for class "$owner.class);
    //log("renderfixed");
}

//_____________________________________________________________________________
simulated function updateRatata()
{
  if ( DBOno )Log("ONO"@self@"updateRatata");

  if (weaponFiredTimer < Level.TimeSeconds)
  {
    renderOno      = false;
    weaponFired[0] = 0;
    weaponFired[1] = 0;
    weaponFired[2] = 0;
    return;
  }


  if (weaponFired[0] != 0)
  {
    if (weaponFired[0] > 12)
      weaponFired[0] = 11;

    onoTextureToRender  = weaponOnoTexture;
    onoTexture2ToRender = weaponOnoTexture2;
    renderOno           = false;
  }
  else if (weaponFired[1] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    onoTextureToRender  = weaponOnoAltTexture;
    onoTexture2ToRender = none;//weaponOnoTexture2;
    renderOno          = true;
    weaponFired[0] = 0;
    weaponFired[1] = 0;
    weaponFired[2] = 0;
  }
  else if (weaponFired[2] != 0)
  {
    onoPosX             = RandRange(onoPosXRandMin,onoPosXRandMax);
    onoPosY             = RandRange(onoPosYRandMin,onoPosYRandMax);
    onoTextureToRender  = weaponNoAmmoOnoTexture;
    onoTexture2ToRender = none;//weaponOnoTexture2;
    renderOno           = true;
    weaponFired[0] = 0;
    weaponFired[1] = 0;
    weaponFired[2] = 0;
  }

}

//_____________________________________________________________________________
simulated function renderRatata(canvas Canvas)
{
  local byte  alpha;
  local float fAlpha;
  local int   q, x,y;
  local float localscale;

  if (!renderOno)
    return;

  if ( DBOno )Log("ONO"@self@"renderRatata");

  if (weaponFired[0] != 0)
  {
    fAlpha = (weaponFiredTimer - Level.TimeSeconds)/fadeTime;
    alpha  = sin(fAlpha*3.14159265*0.5)*255.0;
    Canvas.Style = ERenderStyle.STY_Alpha;
    Canvas.SetDrawColor(255,255,255,alpha);

    x = Canvas.ClipX*0.5 - weaponFired[0] * 30.0 * 0.5;
    for (q=0; q<weaponFired[0]; q++)
    {
      localscale = (scaleRandDeltaMax-scaleRandDeltaMin)* q/11.0/*weaponFired[0]*/+scaleRandDeltaMin;

      y = sin(x*0.03 + Level.TimeSeconds*4.0)*15.0 + Canvas.ClipY*0.5+50.0;
      Canvas.SetPos(x, y);
      if (myOnoType == ONOTYPE_RATATA)
      {

        if (q==0)
          Canvas.DrawTile(onoTextureToRender, localscale*32, localscale*32, 0,0, onoTextureToRender.USize, onoTextureToRender.VSize);
        else
          Canvas.DrawTile(onoTexture2ToRender, localscale*32, localscale*32, 0,0, onoTexture2ToRender.USize, onoTexture2ToRender.VSize);
      }
      else if (myOnoType == ONOTYPE_RATARATA)
      {
        if ( (q%2) == 0 )
          Canvas.DrawTile(onoTextureToRender, localscale*32, localscale*32, 0,0, onoTextureToRender.USize, onoTextureToRender.VSize);
        else
          Canvas.DrawTile(onoTexture2ToRender, localscale*32, localscale*32, 0,0, onoTexture2ToRender.USize, onoTexture2ToRender.VSize);
      }

      x += 40.0*localscale;
    }
  }
  else
    renderFixed(Canvas);

}

//_____________________________________________________________________________
// called from XIIIWeapon when a shot is fired
simulated function FirePrimaryWeapon()
{
    if ( DBOno )Log("ONO"@self@"FirePrimaryWeapon");

    if (Weapon(owner).HasAmmo())
    {
      if (Level.TimeSeconds - lastBurstTime > 0.2)
        weaponFired[0] = 0;

      weaponFired[0]++;
      weaponFiredTimer  = Level.TimeSeconds + fadeTime;
      lastBurstTime = Level.TimeSeconds;
      weaponFired[1] = 0;
      weaponFired[2] = 0;
    }
    else
    {
      weaponFired[0] = 0;
      weaponFired[1] = 0;
      weaponFired[2]++;
      weaponFiredTimer    = Level.TimeSeconds + fadeTime;
    }
}

//_____________________________________________________________________________
// called from XIIIWeapon when a shot is fired
simulated function FirePrimaryWeaponAlt()
{
    if ( DBOno )Log("ONO"@self@"FirePrimaryWeaponAlt");

    if (Weapon(owner).HasAltAmmo())
    {
      weaponFired[0] = 0;
      weaponFired[2] = 0;
      weaponFired[3] = 0;
      weaponFired[1]++;
      weaponFiredTimer    = Level.TimeSeconds + fadeTime;
    }
    else
    {
      weaponFired[0] = 0;
      weaponFired[1] = 0;
      weaponFired[3] = 0;
      weaponFired[2]++;
      weaponFiredTimer    = Level.TimeSeconds + fadeTime;
    }
}

//_____________________________________________________________________________
simulated function ReloadPrimaryWeapon()
{
/* not finished...
  weaponFired[3]++;
  weaponFiredTimer    = Level.TimeSeconds + fadeTime;
  weaponFired[0] = 0;
  weaponFired[1] = 0;
  weaponFired[2] = 0;
  */
}

 // These default settings should be overridded if required
 // in subclasses for respective weapon


defaultproperties
{
     myOnoType=ONOTYPE_FIXED
     fadeTime=0.600000
     onoPosXRandMin=20
     onoPosXRandMax=140
     onoPosYRandMin=-20
     onoPosYRandMax=40
     scaleRandDeltaMin=0.500000
     scaleRandDeltaMax=1.500000
     scaleFactor=1
}
