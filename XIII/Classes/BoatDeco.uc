//-----------------------------------------------------------
//
//-----------------------------------------------------------
class BoatDeco extends VehicleDeco;

VAR Trail BT;
VAR float TimeStamp,t;
EVENT VehicleSpecialHandling(float dt)
{
	LOCAL Vector x,y,z;
//	LOCAL Rotator r;
	
	TimeStamp+=dt;
	t+=dt;
	if (t>0.2)
	{
		t=0;
//		TimeStamp=0;
		GetAxes(Rotation,x,y,z);
		if ( BT == none )
		{
//			r=Rotation;
//			r.Roll+=16384;
			BT = Spawn( class'Trail',none, , Location/*, r */ );

			BT.RibbonColor.R=224;
			BT.RibbonColor.G=160;
			BT.RibbonColor.B=128;
//			BT.SpawnFreq=100;
			BT.FadePeriod=2;
  			BT.ScaleLin=120.0;
			BT.Width=60;
  			BT.CrossMode=false;
  			BT.DrawOutline=true;
			BT.AutoDestroy=false;
			BT.bGameRelevant=false;
			BT.Instigator = Instigator;
			BT.bOwnerNoSee = true;
			BT.RotationSpeed=0;
			//        BT.ActorOffset = MuzzleOffset - (Instigator.Weapon.ThirdPersonRelativeLocation << Instigator.Weapon.ThirdPersonRelativeRotation);
	//		BT.RibbonColor = BT.default.RibbonColor;// * fRand();
			BT.Init();
		}
		if ( BT != none )
		{
		
			BT.CurRotation=1.57+0.15*cos(2*TimeStamp);
			BT.AddSection( Location+Y*200-Z*20 );
		}
	}
}


defaultproperties
{
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'Meshes_Vehicules.bateau'
}
