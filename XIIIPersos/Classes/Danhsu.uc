//===============================================================================
//  Danhsu.
//===============================================================================

class Danhsu extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=DanhsuM MODELFILE=models\Danhsu.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=DanhsuM X=0 Y=0 Z=80.396 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=DanhsuM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=DanhsuM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=DanHsuTex  FILE=Textures\DanHsu.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=DanhsuM NUM=0 TEXTURE=DanHsuTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=DanHsuTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
