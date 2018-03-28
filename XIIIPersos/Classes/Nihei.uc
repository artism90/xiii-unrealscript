//===============================================================================
//  Nihei.
//===============================================================================

class Nihei extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=NiheiM MODELFILE=models\Nihei.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=NiheiM X=0 Y=0 Z=79.928 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=NiheiM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=NiheiM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=NiheiTex  FILE=Textures\Nihei.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=NiheiM NUM=0 TEXTURE=NiheiTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=NiheiTex SOUND=ImpCdvr__hPlayImpCdvr


defaultproperties
{
}
