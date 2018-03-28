//===============================================================================
//  Tueur3.
//===============================================================================

class Tueur3 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Tueur3M MODELFILE=models\Tueur3.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Tueur3M X=0 Y=0 Z=79.917 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Tueur3M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=Tueur3SpeA ANIMFILE=models\Tueur3Spe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=Tueur3SpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=Tueur3M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Tueur3Tex  FILE=Textures\Tueur3.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=Tueur3M NUM=0 TEXTURE=Tueur3Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Tueur3Tex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
