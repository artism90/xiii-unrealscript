//===============================================================================
//  Frenchy2.
//===============================================================================

class Frenchy2 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Frenchy2M MODELFILE=models\Frenchy2.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Frenchy2M X=0 Y=0 Z=79.595 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Frenchy2M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=Frenchy2M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=frenchy2Tex  FILE=Textures\Frenchy2.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Frenchy2M NUM=0 TEXTURE=frenchy2Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Frenchy2Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
