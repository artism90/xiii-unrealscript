//-----------------------------------------------------------
//
//-----------------------------------------------------------
class XIIIFontInfo extends Info;

//#exec OBJ LOAD FILE="..\Textures\PS2Fonts.utx" PACKAGE=PS2Fonts
/*
#exec new TrueTypeFontFactory Name=Tahoma30 FontName="Tahoma" Height=30 AntiAlias=1 CharactersPerPage=128
#exec new TrueTypeFontFactory Name=Tahoma20 FontName="Tahoma" Height=20 AntiAlias=1 CharactersPerPage=128
#exec new TrueTypeFontFactory Name=Tahoma14 FontName="Tahoma" Height=14 AntiAlias=1 CharactersPerPage=128

#exec new TrueTypeFontFactory Name=C30 FontName="Comic sans MS" Height=30 AntiAlias=1 CharactersPerPage=128
#exec new TrueTypeFontFactory Name=C20 FontName="Comic sans MS" Height=20 AntiAlias=1 CharactersPerPage=128
#exec new TrueTypeFontFactory Name=C14 FontName="Comic sans MS" Height=14 AntiAlias=1 CharactersPerPage=128
*/
/*
#exec new TrueTypeFontFactory Name=C30 FontName="DigitalStrip" Height=35 AntiAlias=1 CharactersPerPage=32
#exec new TrueTypeFontFactory Name=C20 FontName="DigitalStrip" Height=25 AntiAlias=1 CharactersPerPage=64
#exec new TrueTypeFontFactory Name=C14 FontName="DigitalStrip" Height=15 AntiAlias=1 CharactersPerPage=256
*/
/*
#exec new TrueTypeFontFactory Name=C30 FontName="Lucida Console" Height=35 AntiAlias=1 CharactersPerPage=32
#exec new TrueTypeFontFactory Name=C20 FontName="Lucida Console" Height=25 AntiAlias=1 CharactersPerPage=64
#exec new TrueTypeFontFactory Name=C14 FontName="Lucida Console" Height=15 AntiAlias=1 CharactersPerPage=256
*/
/*
#exec new TrueTypeFontFactory Name=PoliceF30 FontName="franciscan regular" Height=45 AntiAlias=1 CharactersPerPage=16
#exec new TrueTypeFontFactory Name=PoliceF20 FontName="franciscan regular" Height=35 AntiAlias=1 CharactersPerPage=64
#exec new TrueTypeFontFactory Name=PoliceF14 FontName="franciscan regular" Height=25 AntiAlias=1 CharactersPerPage=128
*/

var font HugeFont, BigFont, MediumFont, fSmallFont;
var float SavedWidth[7];
var font SavedFont[7];

function font GetHugeFont(float Width)
{
    if ( (SavedFont[6] != None) && (Width == SavedWidth[6]) )
      return SavedFont[6];

    SavedWidth[6] = Width;
    SavedFont[6] = GetStaticHugeFont(Width);
    return SavedFont[6];
}

static function font GetStaticHugeFont(float Width)
{
    if (Width < 480)
      return Default.MediumFont;
    else if (Width < 640)
      return Default.BigFont;
    else
      return Default.HugeFont;
}

function font GetBigFont(float Width)
{
    if ( (SavedFont[5] != None) && (Width == SavedWidth[5]) )
      return SavedFont[5];

    SavedWidth[5] = Width;
    SavedFont[5] = GetStaticBigFont(Width);
    return SavedFont[5];
}

static function font GetStaticBigFont(float Width)
{
    if (Width < 480)
      return Default.MediumFont;
    else if (Width < 768)
      return Default.BigFont;
    else
      return Default.HugeFont;
}

function font GetMediumFont(float Width)
{
    if ( (SavedFont[4] != None) && (Width == SavedWidth[4]) )
      return SavedFont[4];

    SavedWidth[4] = Width;
    SavedFont[4] = GetStaticMediumFont(Width);
    return SavedFont[4];
}

static function font GetStaticMediumFont(float Width)
{
    if (Width < 480)
      return default.fSmallFont;
    else if (Width < 768)
      return Default.MediumFont;
    else
      return Default.BigFont;
}

function font GetSmallFont(float Width)
{
    if ( (SavedFont[3] != None) && (Width == SavedWidth[3]) )
      return SavedFont[3];

    SavedWidth[3] = Width;
    SavedFont[3] = GetStaticSmallFont(Width);
    return SavedFont[3];
}

static function font GetStaticSmallFont(float Width)
{
    if (Width < 480)
      return default.fSmallFont;
    else
      return Default.MediumFont;
}

function font GetSmallestFont(float Width)
{
    return default.fSmallFont;
}

static function font GetStaticSmallestFont(float Width)
{
    return default.fSmallFont;
}



defaultproperties
{
     HugeFont=Font'XIIIFonts.PoliceF20'
     BigFont=Font'XIIIFonts.PoliceF16'
     MediumFont=Font'XIIIFonts.XIIIConsoleFont'
     fSmallFont=Font'XIIIFonts.XIIISmallFont'
}
