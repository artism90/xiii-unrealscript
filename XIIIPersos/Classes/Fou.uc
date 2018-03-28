//===============================================================================
//  Fou.
//===============================================================================

class Fou extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=FouM MODELFILE=models\Fou.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=FouM X=0 Y=0 Z=79.451 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=FouM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=FOUspeA ANIMFILE=models\FOUspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=FOUspeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=FouM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=FouTex  FILE=Textures\Fou.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=FouM NUM=0 TEXTURE=FouTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=FouTex SOUND=ImpCdvr__hPlayImpCdvr


defaultproperties
{
}
