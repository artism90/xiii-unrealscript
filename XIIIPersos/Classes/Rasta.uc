//===============================================================================
//  Rasta.
//===============================================================================

class Rasta extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=RastaM MODELFILE=models\Rasta.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=RastaM X=0 Y=0 Z=79.516 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=RastaM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=RastaM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=RastaTex  FILE=Textures\Rasta.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=RastaM NUM=0 TEXTURE=RastaTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=RastaTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
