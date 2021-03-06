//===============================================================================
//  GI.
//===============================================================================

class Gi extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=GiM MODELFILE=models\Gi.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=GiM X=0 Y=0 Z=80.182 YAW=192 PITCH=0 ROLL=0

#exec MESH ATTACHNAME MESH=GIM TAG="RightHand"  BONE="X R Hand"  X=0.0 Y= 0.0 Z= 0.0  YAW=0 PITCH=0 ROLL=0
#exec MESH ATTACHNAME MESH=GIM TAG="LeftHand"   BONE="X L Hand"  X=0.0 Y= 0.0 Z= 0.0  YAW=0 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=GiM X=1.00 Y=1.00 Z=1.00
#EXEC ANIM IMPORT ANIM=GIspeA ANIMFILE=models\GIspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=GIspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=GiSpeA ANIMFILE=models\GiSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=GiSpeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=GISpeA ANIMFILE=models\GISpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=GISpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=GiM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=GITex  FILE=Textures\GI.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=GiM NUM=0 TEXTURE=GITex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=GITex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=Dial5Marche TIME=0.010 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=Dial5Marche TIME=0.517 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=DeathAscenceur TIME=0.074 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=DeathAscenceur TIME=0.234 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=DeathAscenceur TIME=0.415 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=DeathAscenceur TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=Faction2 TIME=0.163 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=GISpeA SEQ=Faction2 TIME=0.774 FUNCTION=PlayFootStep


defaultproperties
{
}
