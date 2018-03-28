//===============================================================================
//  Corsaire.
//===============================================================================

class Corsaire extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=CorsaireM MODELFILE=models\Corsaire.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=CorsaireM X=0 Y=0 Z=79.379 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=CorsaireM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=CorsaireM ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=corsaireTex  FILE=Textures\Corsaire.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=CorsaireM NUM=0 TEXTURE=corsaireTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=CorsaireTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
