//===============================================================================
//  fpsm16.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsm16 extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsm16M MODELFILE=models\fpsm16.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsm16M X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpsm16A ANIMFILE=models\fpsm16.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpsm16M X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpsm16M ANIM=fpsm16A

#EXEC ANIM DIGEST ANIM=fpsm16A USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsm16M NUM=1 TEXTURE=m16
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsm16M NUM=0 TEXTURE=fps

#EXEC ANIM NOTIFY ANIM=fpsm16A SEQ=reload TIME=0.317 FUNCTION=FPSRelNote1
#EXEC ANIM NOTIFY ANIM=fpsm16A SEQ=reload TIME=0.670 FUNCTION=FPSRelNote2
#EXEC ANIM NOTIFY ANIM=fpsm16A SEQ=FireGrenad TIME=0.129 FUNCTION=FPSFireNote1
#EXEC ANIM NOTIFY ANIM=fpsm16A SEQ=WaitAct TIME=0.161 FUNCTION=FPSFireWaitActNote1



defaultproperties
{
}
