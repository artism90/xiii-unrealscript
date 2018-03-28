//===============================================================================
//  Tueur4.
//===============================================================================

class Tueur4 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Tueur4M MODELFILE=models\Tueur4.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Tueur4M X=0 Y=0 Z=80.250 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Tueur4M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=Tueur4M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Tueur4Tex  FILE=Textures\Tueur4.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Tueur4M NUM=0 TEXTURE=Tueur4Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Tueur4Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
