//===============================================================================
//  XIII.
//===============================================================================

class XIII extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=XIIIM MODELFILE=models\XIII.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=XIIIM X=0 Y=0 Z=80.152 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=XIIIM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=XIIIM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=XIIITex  FILE=Textures\XIII.tga  GROUP=Skins


#EXEC MESHMAP SETTEXTURE MESHMAP=XIIIM NUM=0 TEXTURE=XIIITex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=XIIITex SOUND=ImpCdvr__hPlayImpCdvr


defaultproperties
{
}
