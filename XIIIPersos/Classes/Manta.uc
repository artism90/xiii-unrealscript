//===============================================================================
//  Manta.
//===============================================================================

class Manta extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=MantaM MODELFILE=models\Manta.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=MantaM X=0 Y=0 Z=30.558 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM  IMPORT ANIM=MantaA ANIMFILE=models\Manta.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=MantaM X=4.00 Y=4.00 Z=4.00
#EXEC MESH    DEFAULTANIM MESH=MantaM ANIM=MantaA

#EXEC ANIM DIGEST  ANIM=MantaA USERAWINFO VERBOSE

#EXEC TEXTURE IMPORT NAME=MantaTex  FILE=Textures\Manta.tga  MIPS=Off GROUP=Skins
#EXEC MESHMAP SETTEXTURE MESHMAP=MantaM NUM=0 TEXTURE=MantaTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=mantaTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
