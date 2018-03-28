//===============================================================================
//  Quinn.
//===============================================================================

class Quinn extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=QuinnM MODELFILE=models\Quinn.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=QuinnM X=0 Y=0 Z=80.575 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=QuinnM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=QuinnM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=QuinnTex  FILE=Textures\Quinn.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=QuinnM NUM=0 TEXTURE=QuinnTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=QuinnTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
