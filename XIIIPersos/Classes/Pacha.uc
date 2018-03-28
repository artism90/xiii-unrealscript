//===============================================================================
//  Pacha.
//===============================================================================

class Pacha extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=PachaM MODELFILE=models\Pacha.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=PachaM X=0 Y=0 Z=81.695 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=PachaM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=PachaM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=PachaTex  FILE=Textures\Pacha.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=PachaM NUM=0 TEXTURE=PachaTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=PachaTex SOUND=ImpCdvr__hPlayImpCdvr


defaultproperties
{
}
