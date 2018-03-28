//===============================================================================
//  Requin.
//===============================================================================

class Requin extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=RequinM MODELFILE=models\Requin.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=RequinM X=0 Y=0 Z=-3 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM  IMPORT ANIM=RequinA ANIMFILE=models\Requin.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=RequinM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=RequinM ANIM=RequinA

#EXEC ANIM DIGEST  ANIM=RequinA USERAWINFO VERBOSE

#EXEC TEXTURE IMPORT NAME=RequinTex  FILE=Textures\Requin.tga  MIPS=Off GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=RequinM NUM=0 TEXTURE=RequinTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=RequinTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
