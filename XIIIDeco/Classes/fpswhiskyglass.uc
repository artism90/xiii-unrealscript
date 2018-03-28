//===============================================================================
//  fpswhiskyglass.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes
#exec OBJ LOAD FILE=XIIIMeshObjets.utx PACKAGE=XIIIMeshObjets


class fpswhiskyglass extends XIIIAccessoires;

#EXEC MESH  MODELIMPORT MESH=fpswhiskyglassM MODELFILE=models\fpswhiskyglass.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpswhiskyglassM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC ANIM IMPORT ANIM=fpswhiskyglassA ANIMFILE=models\fpswhiskyglass.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1

#EXEC MESHMAP SCALE MESHMAP=fpswhiskyglassM X=1.00 Y=1.00 Z=1.00
#EXEC MESH    DEFAULTANIM MESH=fpswhiskyglassM ANIM=fpswhiskyglassA

#EXEC ANIM DIGEST ANIM=fpswhiskyglassA USERAWINFO VERBOSE

#EXEC MESHMAP SETTEXTURE MESHMAP=fpswhiskyglassM NUM=1 TEXTURE=whiskyglass
#EXEC MESHMAP SETTEXTURE MESHMAP=fpswhiskyglassM NUM=0 TEXTURE=fps



defaultproperties
{
}
