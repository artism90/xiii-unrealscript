//===============================================================================
//  fpspompe.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpspompe extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpspompeM MODELFILE=models\fpspompe.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpspompeM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpspompeM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpspompeA ANIMFILE=models\fpspompe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpspompeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpspompeM ANIM=fpspompeA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpspompeM NUM=1 TEXTURE=pompe
#EXEC MESHMAP SETTEXTURE MESHMAP=fpspompeM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=Fire TIME=0.548 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=reload TIME=0.630 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=reload TIME=0.678 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=Select TIME=0.188 FUNCTION=FPSSelWPNote1
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=FireAlt TIME=0.200 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpspompeA SEQ=FireAlt TIME=0.530 FUNCTION=FPSFireAltNote2





defaultproperties
{
}
