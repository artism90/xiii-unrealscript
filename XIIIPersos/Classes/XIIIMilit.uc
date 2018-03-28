//===============================================================================
//  XIIIMilit.
//===============================================================================

class XIIIMilit extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=XIIIMilitM MODELFILE=models\XIIIMilit.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=XIIIMilitM X=0 Y=0 Z=80.033 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=XIIIMilitM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=XIIIMilitM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=XIIIMilitTex  FILE=Textures\XIIIMilit.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=XIIIMilitM NUM=0 TEXTURE=XIIIMilitTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=XIIIMilitTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
