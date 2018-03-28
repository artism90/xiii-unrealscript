//===============================================================================
//  StandK.
//===============================================================================

class StandK extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=StandKM MODELFILE=models\StandK.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=StandKM X=0 Y=0 Z=80.937 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=StandKM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=StandKM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=StandKTex  FILE=Textures\StandK.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=StandKM NUM=0 TEXTURE=StandKTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=StandKTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
