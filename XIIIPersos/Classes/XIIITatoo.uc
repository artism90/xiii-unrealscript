//===============================================================================
//  XIIITatoo.
//===============================================================================

class XIIITatoo extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=XIIITatooM MODELFILE=models\XIIITatoo.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=XIIITatooM X=0 Y=0 Z=80.133 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=XIIITatooM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=XIIITatooM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=XIIITatooTex  FILE=Textures\XIIITatoo.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=XIIITatooM NUM=0 TEXTURE=XIIITatooTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=XIIITatooTex SOUND=ImpCdvr__hPlayImpCdvr


defaultproperties
{
}
