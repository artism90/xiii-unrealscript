//===============================================================================
//  fpspellesand.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpspellesand extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpspellesandM MODELFILE=models\fpspellesand.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpspellesandM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpspellesandM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpspellesandA ANIMFILE=models\fpspellesand.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpspellesandA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpspellesandM ANIM=fpspellesandA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpspellesandM NUM=1 TEXTURE=pellesand
#EXEC MESHMAP SETTEXTURE MESHMAP=fpspellesandM NUM=0 TEXTURE=fps


#EXEC ANIM NOTIFY ANIM=fpspellesandA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpspellesandA SEQ=Fire TIME=0.135 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpspellesandA SEQ=Fire TIME=0.288 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpspellesandA SEQ=Select TIME=0.230 FUNCTION=FPSSelWPNote1



defaultproperties
{
}
