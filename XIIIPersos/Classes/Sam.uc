//===============================================================================
//  Sam.
//===============================================================================

class Sam extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SamM MODELFILE=models\Sam.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SamM X=0 Y=0 Z=80.482 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SamM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=SamM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=SamTex  FILE=Textures\Sam.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=SamM NUM=0 TEXTURE=SamTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=SamTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
