//===============================================================================
//  Tueur6.
//===============================================================================

class Tueur6 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Tueur6M MODELFILE=models\Tueur6.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Tueur6M X=0 Y=0 Z=79.802 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Tueur6M X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=Tueur6M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Tueur6Tex  FILE=Textures\Tueur6.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Tueur6M NUM=0 TEXTURE=Tueur6Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Tueur6Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
