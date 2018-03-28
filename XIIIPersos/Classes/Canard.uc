//===============================================================================
//  Canard.
//===============================================================================

class Canard extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=CanardM MODELFILE=models\Canard.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=CanardM X=0 Y=0 Z=14.530 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=CanardM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=CanardA ANIMFILE=models\Mouette.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=CanardA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=CanardM ANIM=CanardA

#EXEC TEXTURE IMPORT NAME=CanardTex  FILE=Textures\Canard.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=CanardM NUM=0 TEXTURE=CanardTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=canardTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
