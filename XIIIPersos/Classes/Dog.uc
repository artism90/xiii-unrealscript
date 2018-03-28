//===============================================================================
//  Dog.
//===============================================================================

class Dog extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=DogM MODELFILE=models\Dog.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=DogM X=0 Y=0 Z=37.767 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=DogM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=DogA ANIMFILE=models\Dog.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=DogA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=dogA ANIMFILE=models\dog.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=dogA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=DogM ANIM=DogA

#EXEC TEXTURE IMPORT NAME=DogTex  FILE=Textures\Dog.tga MIPS=Off GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=DogM NUM=0 TEXTURE=DogTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=DogTex SOUND=ImpCdvr__hPlayImpCdvr

#EXEC ANIM NOTIFY ANIM=DogA SEQ=Walk TIME=0.150 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Walk TIME=0.300 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Walk TIME=0.600 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Walk TIME=0.750 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=WalkSearch TIME=0.150 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=WalkSearch TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=WalkSearch TIME=0.600 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=WalkSearch TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Run TIME=0.083 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Run TIME=0.250 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Run TIME=0.333 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Run TIME=0.417 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Jump TIME=0.010 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Jump TIME=0.200 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Jump TIME=0.250 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Jump TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Attak TIME=0.050 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Attak TIME=0.150 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Attak TIME=0.650 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=Attak TIME=0.700 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=AttakBackNeu TIME=0.158 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=AttakBackNeu TIME=0.289 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=AttakBackNeu TIME=0.658 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=AttakBackNeu TIME=0.868 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=DogA SEQ=AttakBackNeu TIME=1.026 FUNCTION=PlayFootStep


defaultproperties
{
}
