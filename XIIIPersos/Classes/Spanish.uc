//===============================================================================
//  Spanish.
//===============================================================================

class Spanish extends TousLesPersos;

#EXEC MESH  MODELIMPORT MESH=SpanishM MODELFILE=models\Spanish.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=SpanishM X=0 Y=0 Z=79.973 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=SpanishM X=1.00 Y=1.00 Z=1.00

#EXEC MESH    DEFAULTANIM MESH=SpanishM ANIM=MigA

#EXEC TEXTURE IMPORT NAME=SpanishTex  FILE=Textures\Spanish.tga  GROUP=Skins

#EXEC MESHMAP SETTEXTURE MESHMAP=SpanishM NUM=0 TEXTURE=SpanishTex
#EXEC OBJ LOAD FILE=XIIISound.uax PACKAGE=XIIISound
#EXEC TEXTURE SETHITSOUND TEXTURE=SpanishTex SOUND=ImpCdvr__hPlayImpCdvr



defaultproperties
{
}
