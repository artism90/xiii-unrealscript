//===============================================================================
//  fpslanceharpon.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpslanceharpon extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpslanceharponM MODELFILE=models\fpslanceharpon.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpslanceharponM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpslanceharponM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpslanceharponA ANIMFILE=models\fpslanceharpon.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpslanceharponA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpslanceharponM ANIM=fpslanceharponA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpslanceharponM NUM=2 TEXTURE=harpon
#EXEC MESHMAP SETTEXTURE MESHMAP=fpslanceharponM NUM=1 TEXTURE=harpon
#EXEC MESHMAP SETTEXTURE MESHMAP=fpslanceharponM NUM=0 TEXTURE=fps
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=Select TIME=0.050 FUNCTION=FPSSelWPNote1
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=Select TIME=0.350 FUNCTION=FPSSelWPNote2
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=ReLoad TIME=0.050 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=ReLoad TIME=0.484 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=ReLoad TIME=0.692 FUNCTION=FPSRelNote3
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=FireAlt TIME=0.321 FUNCTION=FPSFireAltNote1
#EXEC ANIM NOTIFY ANIM=fpslanceharponA SEQ=FireAlt TIME=0.690 FUNCTION=FPSFireAltNote2



defaultproperties
{
}
