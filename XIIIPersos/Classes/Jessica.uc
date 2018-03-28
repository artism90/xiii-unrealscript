//===============================================================================
//  Jessica.
//===============================================================================

class Jessica extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=JessicaM MODELFILE=models\Jessica.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=JessicaM X=0 Y=0 Z=79.420 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=JessicaM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=JessicaM ANIM=JonesMajA

#EXEC TEXTURE IMPORT NAME=JessicaTex  FILE=Textures\JESSICA.TGA  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=JessicaM NUM=0 TEXTURE=JessicaTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=JessicaTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
