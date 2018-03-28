//-----------------------------------------------------------
// Used to delete some actors if not on the specified platform
//-----------------------------------------------------------
class PlatformTrigger extends Triggers;

var() Array<Actor> PlatformList;
enum PlatForm
{
  PF_PC,
  PF_PS2,
  PF_XBOX,
  PF_GC,
};
//var() PlatForm SpecificPlatform;
var() Array<PlatForm> SpecificPlatforms;

//_____________________________________________________________________________
function PostBeginPlay()
{
	local int i;
	local bool bCurrentPlatForm;

/*
  if ((Level.Game != none) && (XIIIGameInfo(Level.Game).PlateForme != SpecificPlatform))
  {
  	for (i=0;i<PlatformList.Length;i++)
  	{
  		if (PlatformList[i]!=none)
  			PlatformList[i].Destroy();
  	}
  }
*/

	if ( Level.Game != none )
	{
		for (i=0;i<SpecificPlatforms.Length;i++)
		{
			if ( XIIIGameInfo(Level.Game).PlateForme == SpecificPlatforms[i] )
			{
				bCurrentPlatForm = true;
				break;
			}
		}
		if ( !bCurrentPlatForm )
		{
			for (i=0;i<PlatformList.Length;i++)
  			{
  				if (PlatformList[i]!=none)
  					PlatformList[i].Destroy();
  			}
		}
	}
	Destroy();
}



defaultproperties
{
}
