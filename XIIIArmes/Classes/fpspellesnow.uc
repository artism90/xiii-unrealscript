//===============================================================================
//  fpspellesnow.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class FpsPelleSnow extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=FpsPelleSnowM MODELFILE=models\FpsPelleSnow.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=FpsPelleSnowM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=FpsPelleSnowM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpspellesnowA ANIMFILE=models\fpspellesnow.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpspellesnowA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=FpsPelleSnowA ANIMFILE=models\FpsPelleSnow.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FpsPelleSnowA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=FpsPelleSnowM ANIM=FpsPelleSnowA

#EXEC MESHMAP SETTEXTURE MESHMAP=FpsPelleSnowM NUM=1 TEXTURE=pellesnow
#EXEC MESHMAP SETTEXTURE MESHMAP=FpsPelleSnowM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpspellesnowA SEQ=Down TIME=0.492 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpspellesnowA SEQ=Fire TIME=0.135 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpspellesnowA SEQ=Fire TIME=0.280 FUNCTION=FPSFireNote2
#EXEC ANIM NOTIFY ANIM=fpspellesnowA SEQ=Select TIME=0.230 FUNCTION=FPSSelWPNote1



defaultproperties
{
}
