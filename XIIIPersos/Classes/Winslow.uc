//===============================================================================
//  Winslow.
//===============================================================================

class Winslow extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=WinslowM MODELFILE=models\Winslow.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=WinslowM X=0 Y=0 Z=80.152 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=WinslowM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=winslowspeA ANIMFILE=models\winslowspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=winslowspeA USERAWINFO VERBOSE

#EXEC ANIM IMPORT ANIM=WinslowSpeA ANIMFILE=models\WinslowSpe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=WinslowSpeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=WinslowM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=WinslowTex  FILE=Textures\Winslow.tga  GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=WinslowM NUM=0 TEXTURE=WinslowTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=WinslowTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
