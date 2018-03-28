//===============================================================================
//  fpssniper.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpssniper extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpssniperM MODELFILE=models\fpssniper.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpssniperM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpssniperA ANIMFILE=models\fpssniper.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpssniperM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpssniperM ANIM=fpssniperA

#EXEC ANIM DIGEST ANIM=fpssniperA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpssniperM NUM=1 TEXTURE=sniper
#EXEC MESHMAP SETTEXTURE MESHMAP=fpssniperM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpssniperA SEQ=reload TIME=0.320 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpssniperA SEQ=reload TIME=0.670 FUNCTION=FPSRelNote2



defaultproperties
{
}
