//===============================================================================
//  XIIIGal.
//===============================================================================

class XIIIGal extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=XIIIGalM MODELFILE=models\XIIIGal.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=XIIIGalM X=0 Y=0 Z=81.695 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=XIIIGalM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=XIIIGalM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=XIIIGalTex  FILE=Textures\XIIIGal.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=XIIIGalM NUM=0 TEXTURE=XIIIGalTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=XIIIGalTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
