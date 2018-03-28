//===============================================================================
//  XIIIBandages.
//===============================================================================

class XIIIBandages extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=XIIIBandagesM MODELFILE=models\XIIIBandages.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=XIIIBandagesM X=0 Y=0 Z=80.152 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=XIIIBandagesM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=XIIIBandagesM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=XIIIBandagesTex  FILE=Textures\XIIIBandages.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=XIIIBandagesM NUM=0 TEXTURE=XIIIBandagesTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=XIIIBandagesTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
