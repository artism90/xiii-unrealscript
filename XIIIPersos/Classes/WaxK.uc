//===============================================================================
//  WaxK.
//===============================================================================

class WaxK extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=WaxKM MODELFILE=models\WaxK.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=WaxKM X=0 Y=0 Z=79.493 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=WaxKM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=WaxKM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=WaxKTex  FILE=Textures\WaxK.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=WaxKM NUM=0 TEXTURE=WaxKTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=WaxKTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
