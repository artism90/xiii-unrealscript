//===============================================================================
//  Employee1.
//===============================================================================

class Employee1 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Employee1M MODELFILE=models\Employee1.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Employee1M X=0 Y=0 Z=78.871 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Employee1M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=Employee1SpeA ANIMFILE=models\Employee1Spe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=Employee1SpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=Employee1M ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=Employee1Tex  FILE=Textures\Employee1.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Employee1M NUM=0 TEXTURE=Employee1Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Employee1Tex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC ANIM NOTIFY ANIM=Employee1SpeA SEQ=Otage TIME=0.133 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee1SpeA SEQ=Otage TIME=0.633 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee1SpeA SEQ=Employee1Surprise TIME=0.306 FUNCTION=PlayFootStep


defaultproperties
{
}
