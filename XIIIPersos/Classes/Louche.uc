//===============================================================================
//  Louche.
//===============================================================================

class Louche extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=LoucheM MODELFILE=models\Louche.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=LoucheM X=0 Y=0 Z=79.707 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=LoucheM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=LoucheM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=LoucheTex  FILE=Textures\Louche.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=LoucheM NUM=0 TEXTURE=LoucheTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=LoucheTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
