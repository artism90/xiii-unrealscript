//-----------------------------------------------------------
//
//-----------------------------------------------------------
class SkillDocumentPick extends XIIIDocumentPick
    abstract;

var class<XIIISkill> SkillGiven;    // skill to give at the same time we pick up the doc.

//_____________________________________________________________________________
function inventory SpawnCopy(Pawn Other)
{
    local XIIISkill Skill;
    local inventory Inv;
    local Inventory Copy;

    Skill = XIIISkill(Other.FindInventoryType(SkillGiven));
    if ( Skill == none )
    {
      Copy = spawn(SkillGiven,Other,,,rot(0,0,0));
      Copy.GiveTo( Other );
      Skill = XIIISkill(Copy);
      Inv = Super.SpawnCopy(other);
      SkillDocument(Inv).RelatedSkill = Skill;
    }
    else
    {
      for( Inv=Other.Inventory; Inv!=None; Inv=Inv.Inventory )
      {
        if ( (SkillDocument(Inv) != none) && (SkillDocument(Inv).RelatedSkill == Skill) )
          return Inv;
      }
      // Should never be there.
//      Level.Game.Broadcast( self, "WARNING :: Skill "$Skill$" already in inventory but no document related, CHEATING HAVE OCCURED" );
      return none;
    }
}



defaultproperties
{
     InventoryType=Class'XIII.SkillDocument'
     PickupMessage="IMPORTANT DOCUMENT"
     StaticMesh=StaticMesh'MeshObjetsPickup.dossierXIII'
     MessageClass=Class'XIII.DocumentPickupMessage'
}
