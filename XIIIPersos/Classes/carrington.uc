//===============================================================================
//  carrington.
//===============================================================================

class Carrington extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=CarringtonM MODELFILE=models\Carrington.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=CarringtonM X=0 Y=0 Z=80.199 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=CARRINGTONSpeA ANIMFILE=models\CARRINGTONSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=CARRINGTONSpeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=CarringtonSpeA ANIMFILE=models\CarringtonSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=CarringtonSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=CarringtonM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=CarringtonTex  FILE=Textures\Carrington.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=CarringtonM NUM=0 TEXTURE=CarringtonTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=CarringtonTex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC MESHMAP SCALE MESHMAP=CarringtonM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Walk TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Walk TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee3 TIME=0.010 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee3 TIME=0.517 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Walk2 TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Walk2 TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=AccueilXIII TIME=0.138 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=AccueilXIII TIME=0.655 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=0.170 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=0.333 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=0.504 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=0.667 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=0.837 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=MarcheTypee2 TIME=1.000 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Jog TIME=0.010 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=Jog TIME=0.579 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=SeRetourne TIME=0.378 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=SeRetourne TIME=0.757 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=SeLeve TIME=0.560 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=CarringtonSpeA SEQ=SeLeve TIME=0.664 FUNCTION=PlayFootStep


defaultproperties
{
}
