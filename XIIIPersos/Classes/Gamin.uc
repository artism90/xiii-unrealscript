//===============================================================================
//  Gamin.
//===============================================================================

class Gamin extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=GaminM MODELFILE=models\Gamin.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=GaminM X=0 Y=0 Z=80.754 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=GaminM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=GaminM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=GaminTex  FILE=Textures\Gamin.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=GaminM NUM=0 TEXTURE=GaminTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=GaminTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
