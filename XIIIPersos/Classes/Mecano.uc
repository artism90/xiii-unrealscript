//===============================================================================
//  Mecano.
//===============================================================================

class Mecano extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=MecanoM MODELFILE=models\Mecano.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=MecanoM X=0 Y=0 Z=80.284 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=MecanoM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=MecanoM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=MecanoTex  FILE=Textures\Mecano.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=MecanoM NUM=0 TEXTURE=MecanoTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=mecanoTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
