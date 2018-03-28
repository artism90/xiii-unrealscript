//===============================================================================
//  Groflic.
//===============================================================================

class Groflic extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=GroflicM MODELFILE=models\Groflic.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=GroflicM X=0 Y=0 Z=81.369 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=GroflicM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=GroflicM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=GroflicTex  FILE=Textures\Groflic.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=GroflicM NUM=0 TEXTURE=GroflicTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=GroflicTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
