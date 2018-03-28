//===============================================================================
//  jones.
//===============================================================================

class Jones extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=JonesM MODELFILE=models\Jones.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=JonesM X=0 Y=0 Z=79.104 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=JonesM X=1.00 Y=1.00 Z=1.00
#EXEC ANIM IMPORT ANIM=JonesSpeA ANIMFILE=models\JonesSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=JonesSpeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=jonesSpeA ANIMFILE=models\jonesSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=jonesSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=JonesM ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=JonesTex  FILE=Textures\Jones.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=JonesM NUM=0 TEXTURE=JonesTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=JonesTex SOUND=ImpCdvr__hPlayImpCdvr

#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=WalkMalette TIME=0.133 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=WalkMalette TIME=0.633 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesCrochetteDebut TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesCrochetteFin TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=SouleveMalette TIME=0.244 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JumpLand TIME=0.033 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JumpLand TIME=0.067 FUNCTION=PlayFootStep

#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesPoseMalette1 TIME=0.550 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesPoseMalette2 TIME=2.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=FermeMalette TIME=0.300 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=FermeMalette TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesFermeMalette TIME=1.154 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=JonesSpeA SEQ=JonesFermeMalette TIME=1.538 FUNCTION=PlayFootStep


defaultproperties
{
}