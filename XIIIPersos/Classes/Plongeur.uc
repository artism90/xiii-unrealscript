//===============================================================================
//  Plongeur.
//===============================================================================

class Plongeur extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=PlongeurM MODELFILE=models\Plongeur.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=PlongeurM X=0 Y=0 Z=80.937 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=PlongeurM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=plongeurspeA ANIMFILE=models\plongeurspe.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=plongeurspeA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=PlongeurM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=PlongeurTex  FILE=Textures\Plongeur.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=PlongeurM NUM=0 TEXTURE=PlongeurTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=PlongeurTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
