//===============================================================================
//  Frenchy.
//===============================================================================

class Frenchy extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=FrenchyM MODELFILE=models\Frenchy.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=FrenchyM X=0 Y=0 Z=79.610 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=FrenchyM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=FrenchyM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=FrenchyTex  FILE=Textures\Frenchy.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=FrenchyM NUM=0 TEXTURE=FrenchyTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=FrenchyTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
