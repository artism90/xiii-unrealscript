//=============================================================================
// dorade.
//=============================================================================

class grdorade extends XIIIAccessoires;
#exec OBJ LOAD FILE=XIIIMeshobjets.utx PACKAGE=XIIIMeshobjets

#exec MESH IMPORT MESH=doradeM ANIVFILE=MODELS\dorade_a.3d DATAFILE=MODELS\dorade_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=doradeM X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=doradeM SEQ=All STARTFRAME=0 NUMFRAMES=60
#exec MESH SEQUENCE MESH=doradeM SEQ=nage STARTFRAME=0 NUMFRAMES=60

#exec MESHMAP NEW   MESHMAP=doradeM MESH=dorade
#exec MESHMAP SCALE MESHMAP=doradeM X=0.192 Y=0.192 Z=0.384

#exec MESHMAP SETTEXTURE MESHMAP=doradeM NUM=1 TEXTURE=aqgrofish



defaultproperties
{
}
