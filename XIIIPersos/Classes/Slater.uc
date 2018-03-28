//===============================================================================
//  Slater.
//===============================================================================

class Slater extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SlaterM MODELFILE=models\Slater.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SlaterM X=0 Y=0 Z=80.331 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SlaterM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=SlaterM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=SlaterTex  FILE=Textures\Slater.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=SlaterM NUM=0 TEXTURE=SlaterTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=SlaterTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
