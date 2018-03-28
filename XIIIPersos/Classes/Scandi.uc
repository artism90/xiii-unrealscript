//===============================================================================
//  Scandi.
//===============================================================================

class Scandi extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=ScandiM MODELFILE=models\Scandi.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=ScandiM X=0 Y=0 Z=80.948 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=ScandiM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=ScandiM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=ScandiTex  FILE=Textures\scandi.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=ScandiM NUM=0 TEXTURE=scandiTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=scandiTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
