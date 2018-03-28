//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIAmmo extends Ammunition;

/*
function Giveto(Pawn other)
{
    Log("GIVETO call to "$other$" for "$self);
    Super.GiveTo(Other);
}
*/

//_____________________________________________________________________________
function SetUpImpactEmitter(Sound S)
{
    local string Str;
    local int i;

    // First get rid of the beginning of the sound name just to keep whet is needed
    Str = string(S);
    i = InStr(S, 'hPlay');
    Str = Right(Str, Len(Str) - i - 5);
//    Log("--'"$Str$"'--");

    // Then switch/case the result to setup the SFX class
    switch (Str)
    {
      case "ImpBtE":
      case "ImpBtI":
      case "ImpCar":
      case "ImpMar":
      case "ImpTil":
      case "ImpPie":
        // Concrete type
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGra":
        // Gravel type
        ImpactEmitterMem = class'GravelDustEmitter';
        break;
      case "ImpBoiC":
      case "ImpBoiP":
      case "ImpPar":
      case "ImpFeu":
        // Wood type
        ImpactEmitterMem = class'WoodDustEmitter';
        break;
      case "ImpEau":
        // Water type (should not happen but maybe....)
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
      case "ImpGla":
      case "ImpVer":
        // Glass type
        ImpactEmitterMem = class'GlassImpactEmitter';
        break;
      case "ImpGri":
      case "ImpMet":
      case "ImpTol":
        // Metal type
        ImpactEmitterMem = class'BulletMetalEmitter';
        break;
      case "ImpHrb":
        ImpactEmitterMem = class'GrassDustEmitter';
        break;
      case "ImpTer":
        // Earth type
        ImpactEmitterMem = class'EarthDustEmitter';
        break;
      case "ImpNei":
        // Snow type
        ImpactEmitterMem = class'SnowDustEmitter';
        break;
      case "ImpMol":
      case "ImpMoq":
        // Soft Types
        ImpactEmitterMem = class'MoqDustEmitter';
        break;
      case "ImpCdvr":
        ImpactEmitterMem = class'BloodShotEmitter';
        break;
      case "ImpLin":
      default:
        // other types, not spawn any SFX
        ImpactEmitterMem = class'BulletDustEmitter';
        break;
    }
/*
handler hPlayImpBtE (int iWhichAmmo)	Béton exterieur
handler hPlayImpBtI (int iWhichAmmo)	Béton interieur
handler hPlayImpBoiC (int iWhichAmmo)	Bois Creux
handler hPlayImpBoiP (int iWhichAmmo)	Bois plein
handler hPlayImpCar (int iWhichAmmo)	Carrelage
handler hPlayImpEau (int iWhichAmmo)	Eau
handler hPlayImpFeu (int iWhichAmmo)	Feuilles
handler hPlayImpFlesh (int iWhichAmmo)	Chair
handler hPlayImpGla (int iWhichAmmo)	Glace
handler hPlayImpGra (int iWhichAmmo)	Gravier
handler hPlayImpGri (int iWhichAmmo)	Grille
handler hPlayImpHrb (int iWhichAmmo)	Herbe
handler hPlayImpLin (int iWhichAmmo)	Lino
handler hPlayImpMar (int iWhichAmmo)	Marbre
handler hPlayImpMet (int iWhichAmmo)	Métal
handler hPlayImpMol (int iWhichAmmo)	diverses textures molles: matelas; fauteuille; liège.
handler hPlayImpMoq (int iWhichAmmo)	Moquette
handler hPlayImpNei (int iWhichAmmo)	Neige
handler hPlayImpPar (int iWhichAmmo)	Parquet
handler hPlayImpPie (int iWhichAmmo)	Pierre
handler hPlayImpTer (int iWhichAmmo)	Terre
handler hPlayImpTol (int iWhichAmmo)	Tôle
handler hPlayImpTil (int iWhichAmmo)	Tuile
handler hPlayImpVer (int iWhichAmmo)	Verre*/
}


// ELR WarnTargetPct to 0.2 to warn 1 on 5 frame for instant hit weapons.
// ELR not used for projectiles as they warn only on firing.


defaultproperties
{
}
