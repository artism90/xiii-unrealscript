//===============================================================================
//  Tim.
//===============================================================================

class Tim extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=TimM MODELFILE=models\Tim.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=TimM X=0 Y=0 Z=80.088 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=TimM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=TimM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=TimTex  FILE=Textures\Tim.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=TimM NUM=0 TEXTURE=TimTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=TimTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
