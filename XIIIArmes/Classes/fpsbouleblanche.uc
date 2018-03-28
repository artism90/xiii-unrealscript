//===============================================================================
//  fpsbouleblanche.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIPalace.utx PACKAGE=XIIIPalace


class fpsbouleblanche extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbouleblancheM MODELFILE=models\fpsbouleblanche.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbouleblancheM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbouleblancheM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbouleblancheA ANIMFILE=models\fpsbouleblanche.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbouleblancheA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbouleblancheM ANIM=fpsbouleblancheA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouleblancheM NUM=1 TEXTURE=Pcanbillar
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbouleblancheM NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsbouleblancheA SEQ=Down TIME=0.250 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbouleblancheA SEQ=Down TIME=0.950 FUNCTION=FPSDownNote2



defaultproperties
{
}
