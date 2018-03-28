//===============================================================================
//  Bank2.
//===============================================================================

class Bank2 extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=Bank2M MODELFILE=models\Bank2.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=Bank2M X=0 Y=0 Z=79.814 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=Bank2M X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=Bank2SpeA ANIMFILE=models\Bank2Spe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=Bank2SpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=Bank2M ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Bank2Tex  FILE=Textures\Bank2.tga  GROUP=Skins
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=Bank2Tex SOUND=ImpCdvr__hPlayImpCdvr

#EXEC MESHMAP SETTEXTURE MESHMAP=Bank2M NUM=0 TEXTURE=Bank2Tex


#EXEC ANIM NOTIFY ANIM=Bank2SpeA SEQ=Bank2Escalier TIME=0.267 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=Bank2SpeA SEQ=Bank2Escalier TIME=0.767 FUNCTION=PlayFootStep


defaultproperties
{
}
