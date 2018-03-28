//===============================================================================
//  fpsfchasse.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsfchasse extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsfchasseM MODELFILE=models\fpsfchasse.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsfchasseM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsfchasseA ANIMFILE=models\fpsfchasse.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsfchasseM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsfchasseM ANIM=fpsfchasseA

#EXEC ANIM DIGEST ANIM=fpsfchasseA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsfchasseM NUM=1 TEXTURE=fchasse
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsfchasseM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt1 TIME=0.200 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt1 TIME=0.530 FUNCTION=FPSFireAltNote2
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt2 TIME=0.200 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt2 TIME=0.530 FUNCTION=FPSFireAltNote2
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt3 TIME=0.200 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpsfchasseA SEQ=FireAlt3 TIME=0.530 FUNCTION=FPSFireAltNote2



defaultproperties
{
}
