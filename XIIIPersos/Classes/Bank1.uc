//===============================================================================
//  Bank1.
//===============================================================================

class Bank1 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Bank1M MODELFILE=models\Bank1.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Bank1M X=0 Y=0 Z=79.251 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Bank1M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=Bank1M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Bank1Tex  FILE=Textures\Bank1.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Bank1M NUM=0 TEXTURE=Bank1Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Bank1Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
