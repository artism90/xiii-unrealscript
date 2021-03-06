//===============================================================================
//  Employee2.
//===============================================================================

class Employee2 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Employee2M MODELFILE=models\Employee2.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Employee2M X=0 Y=0 Z=79.108 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Employee2M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=EMPLOYEE2speA ANIMFILE=models\EMPLOYEE2spe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=EMPLOYEE2speA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=Employee2SpeA ANIMFILE=models\Employee2Spe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=Employee2SpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=Employee2M ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=Employee2Tex  FILE=Textures\Employee2.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=Employee2M NUM=0 TEXTURE=Employee2Tex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Employee2Tex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Otage TIME=0.133 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Otage TIME=0.633 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.034 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.160 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.286 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.412 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.538 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.664 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.790 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Check TIME=0.916 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Appel TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Employee2SpeA SEQ=Appel1 TIME=1.000 FUNCTION=PlayFootStep


defaultproperties
{
}
