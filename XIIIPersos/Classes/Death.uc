//===============================================================================
//  Death.
//===============================================================================

class Death extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=DeathM MODELFILE=models\Death.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=DeathM X=0 Y=0 Z=82.687 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=DeathM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=DeathM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=Material #160Tex  FILE=Textures\Death.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=DeathM NUM=0 TEXTURE=Material #160Tex



defaultproperties
{
}
