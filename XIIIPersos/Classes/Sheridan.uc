//===============================================================================
//  Sheridan.
//===============================================================================

class Sheridan extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SheridanM MODELFILE=models\Sheridan.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SheridanM X=0 Y=0 Z=79.905 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SheridanM X=1.00 Y=1.00 Z=1.00
#EXEC ANIM IMPORT ANIM=SHERIDANspeA ANIMFILE=models\SHERIDANspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=SHERIDANspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=SheridanSpeA ANIMFILE=models\SheridanSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=SheridanSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=SheridanM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=SheridanTex  FILE=Textures\sheridan.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=SheridanM NUM=0 TEXTURE=SheridanTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=SheridanTex SOUND=ImpCdvr__hPlayImpCdvr


#EXEC ANIM NOTIFY ANIM=SheridanSpeA SEQ=marche4 TIME=0.500 FUNCTION=PlayFootStep
#EXEC ANIM NOTIFY ANIM=SheridanSpeA SEQ=marche4 TIME=1.000 FUNCTION=PlayFootStep


defaultproperties
{
}
