//===============================================================================
//  Tueur5.
//===============================================================================

class Tueur5 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Tueur5M MODELFILE=models\Tueur5.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Tueur5M X=0 Y=0 Z=79.550 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Tueur5M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=Tueur5M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Tueur5Tex  FILE=Textures\Tueur5.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Tueur5M NUM=0 TEXTURE=Tueur5Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Tueur5Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
