//===============================================================================
//  MouetSol.
//===============================================================================

class MouetSol extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=MouetSolM MODELFILE=models\MouetSol.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=MouetSolM X=0 Y=0 Z=12.985 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=MouetSolM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=MouetSolA ANIMFILE=models\MouetSol.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=MouetSolA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=MouetSolM ANIM=MouetSolA

#EXEC TEXTURE IMPORT NAME=MouetteSolTex  FILE=Textures\MouetPose.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=MouetSolM NUM=0 TEXTURE=MouetteSolTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=MouetteSolTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
