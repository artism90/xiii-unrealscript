//===============================================================================
//  HelicoFbi.
//===============================================================================

class HelicoFbi extends XIIIVehicule;
#exec OBJ LOAD FILE=XIIIVertexshaders.utx PACKAGE=XIIIVertexshaders

#EXEC MESH  MODELIMPORT MESH=HelicoFbiM MODELFILE=models\HelicoFbi.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=HelicoFbiM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM  IMPORT ANIM=HelicoFbiA ANIMFILE=models\HelicoFbi.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=HelicoFbiM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=HelicoFbiM ANIM=HelicoFbiA

#EXEC ANIM DIGEST  ANIM=HelicoFbiA USERAWINFO VERBOSE


#EXEC MESHMAP SETTEXTURE MESHMAP=HelicoFbiM NUM=2 TEXTURE=echelleM_2Sides
#EXEC MESHMAP SETTEXTURE MESHMAP=HelicoFbiM NUM=1 TEXTURE=helicoroto1b
#EXEC MESHMAP SETTEXTURE MESHMAP=HelicoFbiM NUM=0 TEXTURE=helicoFBI



defaultproperties
{
}
