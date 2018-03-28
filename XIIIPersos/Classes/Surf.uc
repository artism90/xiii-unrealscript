//===============================================================================
//  Surf.
//===============================================================================

class Surf extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SurfM MODELFILE=models\Surf.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SurfM X=0 Y=0 Z=80.062 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SurfM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=SurfM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=SurfTex  FILE=Textures\Surf.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=SurfM NUM=0 TEXTURE=SurfTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=SurfTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
