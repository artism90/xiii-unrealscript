//===============================================================================
//  fpsbarflechette.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIbar.utx PACKAGE=XIIIbar

class fpsbarflechette extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsbarflechetteM MODELFILE=models\fpsbarflechette.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsbarflechetteM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsbarflechetteM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsbarflechetteA ANIMFILE=models\fpsbarflechette.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsbarflechetteA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsbarflechetteM ANIM=fpsbarflechetteA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbarflechetteM NUM=0 TEXTURE=fps
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbarflechetteM NUM=1 TEXTURE=barenvmap
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbarflechetteM NUM=2 TEXTURE=barzink
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbarflechetteM NUM=3 TEXTURE=barcomptoir
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsbarflechetteM NUM=4 TEXTURE=barfanion_sinus

#EXEC ANIM NOTIFY ANIM=fpsbarflechetteA SEQ=Down TIME=0.250 FUNCTION=FPSDownNote1
#EXEC ANIM NOTIFY ANIM=fpsbarflechetteA SEQ=Down TIME=0.950 FUNCTION=FPSDownNote2



defaultproperties
{
}
