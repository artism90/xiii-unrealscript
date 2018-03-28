//===============================================================================
//  Doc.
//===============================================================================

class Doc extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=DocM MODELFILE=models\Doc.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=DocM X=0 Y=0 Z=79.445 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=DocM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=DocSpeA ANIMFILE=models\DocSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=DocSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=DocM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=DocTex  FILE=Textures\Doc.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=DocM NUM=0 TEXTURE=DocTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=DocTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
