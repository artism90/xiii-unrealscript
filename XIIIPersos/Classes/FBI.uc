//===============================================================================
//  fbi.
//===============================================================================

class Fbi extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=FbiM MODELFILE=models\Fbi.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=FbiM X=0 Y=0 Z=80.920 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=FbiM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=FBIspeA ANIMFILE=models\FBIspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FBIspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=FbiSpeA ANIMFILE=models\FbiSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FbiSpeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=FBISpeA ANIMFILE=models\FBISpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FBISpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=FbiM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=FBITex  FILE=Textures\FBI.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FbiM NUM=0 TEXTURE=FBITex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=FBITex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC ANIM NOTIFY ANIM=FbiSpeA SEQ=WalkFBI TIME=0.010 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=FbiSpeA SEQ=WalkFBI TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=FbiSpeA SEQ=WalkFBI TIME=1.000 FUNCTION=PlayFootStep

#EXEC ANIM NOTIFY ANIM=FBISpeA SEQ=Arrestation1 TIME=0.050 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=FBISpeA SEQ=Arrestation1 TIME=0.525 FUNCTION=PlayFootStep


defaultproperties
{
}