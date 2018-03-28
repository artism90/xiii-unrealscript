//===============================================================================
//  fpsgrappin.
//===============================================================================

#exec OBJ LOAD FILE=XIIIMeshArmes.utx PACKAGE=XIIIMeshArmes


class fpsgrappin extends XIIIArmes;

#EXEC MESH  MODELIMPORT MESH=fpsgrappinM MODELFILE=models\fpsgrappin.PSK LODSTYLE=10
#EXEC MESH  ORIGIN MESH=fpsgrappinM X=0 Y=0 Z=0 YAW=192 PITCH=0 ROLL=0

#EXEC MESHMAP SCALE MESHMAP=fpsgrappinM X=1.00 Y=1.00 Z=1.00

#EXEC ANIM IMPORT ANIM=fpsgrappinA ANIMFILE=models\fpsgrappin.PSA COMPRESS=1 MAXKEYS=999999 IMPORTSEQS=1
#EXEC ANIM DIGEST ANIM=fpsgrappinA USERAWINFO VERBOSE

#EXEC MESH    DEFAULTANIM MESH=fpsgrappinM ANIM=fpsgrappinA

#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrappinM NUM=2 TEXTURE=grappincontrole
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrappinM NUM=1 TEXTURE=grappin
#EXEC MESHMAP SETTEXTURE MESHMAP=fpsgrappinM NUM=0 TEXTURE=fps



defaultproperties
{
}
