//===============================================================================
//  Fbi2.
//===============================================================================

class FBI2 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=FBI2M MODELFILE=models\FBI2.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=FBI2M X=0 Y=0 Z=80.367 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=FBI2M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=FBI2M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=FBI2Tex  FILE=Textures\FBI2.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FBI2M NUM=0 TEXTURE=FBI2Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=FBI2Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
