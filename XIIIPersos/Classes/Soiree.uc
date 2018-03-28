//===============================================================================
//  Soiree.
//===============================================================================

class Soiree extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SoireeM MODELFILE=models\Soiree.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SoireeM X=0 Y=0 Z=78.997 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SoireeM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=SoireeSpeA ANIMFILE=models\SoireeSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=SoireeSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=SoireeM ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=JonesSoireeTex  FILE=Textures\Soiree.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=SoireeM NUM=0 TEXTURE=JonesSoireeTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=JonesSoireeTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
