//===============================================================================
//  MrBonnet.
//===============================================================================

class MrBonnet extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=MrBonnetM MODELFILE=models\MrBonnet.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=MrBonnetM X=0 Y=0 Z=79.820 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=MrBonnetM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=MrBonnetM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=MrBonnetTex  FILE=Textures\MrBonnet.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=MrBonnetM NUM=0 TEXTURE=MrBonnetTex



defaultproperties
{
}
