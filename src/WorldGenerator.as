package
{
  /**
   * ...
   * @author Rafael Wenzel
   */
  /*
  World creation steps:
  - create basic elementary maps (fire, water, earth, air)
    - fire: high means lava area; low means snowy area
    - water: high means sea/swamp area; low means desert area
    - earth: high means stony area; low means earthly/swampy areas
    - air: high means mountain area; low means plain area
    - elementary circle (starting at 12; clockwise)
      - water only; sea
      - water and earth: swamps (left) or jungle (right)
      - earth only: plain land, some woods
      - earth and fire: desert (left) or wastelands (right)
      - fire only: lava
      - fire and air: lava mountain (left) or diamond mountains (right)
      - air only: mountains
      - air and water: snowy mountains (left) or snowy plains/lakes (right)

  */

  import flash.display.BlendMode;
  import org.flixel.FlxTilemap;
  public class WorldGenerator
  {
    private var width:int; // world width
    private var height:int; // world height

    private var map:Array; // will hold final map
    private var elementOverlay:Array; // will hold an overlay of elemental jurisdiction
    private var overlayMap:Array; // world overlays like trees and mountains

    private var islandStats:IslandStats;
    private var cityGenerator:CityGenerator;

    // width and height in tile numbers
    public function WorldGenerator( width:int, height:int )
    {
      this.width = width;
      this.height = height;

      // initialize map
      this.map = new Array( );
      for ( var i:int = 0; i < Globals.WORLD_TILES; i++ )
      {
        map[ i ] = Globals.NULL_TILE;
      }

      // initialize elemental map
      this.elementOverlay = new Array( );
      for ( i = 0; i < Globals.WORLD_TILES; i++ )
      {
        elementOverlay[ i ] = 0;
      }

      // initialize overlay map
      this.overlayMap = new Array( );
      for ( i = 0; i < Globals.WORLD_TILES; i++ )
      {
        overlayMap[ i ] = Globals.EMPTY_TILE;
      }

      islandStats = new IslandStats( );
      cityGenerator = new CityGenerator( islandStats.returnIslandmap( ), overlayMap );

      generateWorld( );

      // DEBUG
      islandStats.debug( );
    }

    public function generateWorld( ):void
    {
      // DAY 1 - CREATION OF THE WORLD
      createColonies( 9 );
      growColonies( 1 );
      growColonies( 1 );
      growColonies( 1 );

      // DAY 2 - CREATION OF THE ELEMENTS
      generateElementJurisdiction( );

      // DAY 3 - PREPARE WORLD TO BE POPULATED
      islandStats.parse( map );

      // DAY 4 - GENERATION OF CIVILIZATION
      cityGenerator.placeCities( );

      // DAY 7 - CLEANING UP
      fixTiles( );
    }

    // adds initial colonies to the map
    public function createColonies( permille:int ):void
    {
      for ( var i:int = 0; i < width * height; i++ )
      {
        if ( Math.random( ) * 1000 < permille )
        {
          map[ i ] = Globals.INITIAL_TILE;
        }
      }

    }

    // grows colonies by itterator
    public function growColonies( itterator:int ):void
    {
      for ( var i:int = 0; i < width * height; i++ )
      {
        if ( map[ i ] == Globals.INITIAL_TILE ) {
          // grow me immediately
          growTileRandom( map, i, itterator );
        }
      }
    }

    public function growTileRandom( map:Array, center:int, itterations:int = 1, source:int = Globals.NULL_TILE ):int
    {
      return growTile( map, center, itterations, source, true );
    }

    // grows a given tile into every direction
    public function growTile( map:Array, center:int, itterations:int = 1, source:int = Globals.NULL_TILE, random:Boolean = false ):int
    {
      var left:int, right:int, top:int, bottom:int, changeto:int, returnVal:int;

      changeto = map[ center ];
      returnVal = 0;

      // determine left or none (if leftmost)
      if ( center % width == 0 ) left = -1;
      else if( random == false || ( random == true && Math.random( ) * 100 < Globals.GROW_RANDOM ) ) left = center - 1;

      // determine right
      if ( center % width - 1 == 0 ) right = -1;
      else if ( random == false || ( random == true && Math.random( ) * 100 < Globals.GROW_RANDOM ) ) right = center + 1;

      // determine top
      if ( center < width ) top = -1;
      else if ( random == false || ( random == true && Math.random( ) * 100 < Globals.GROW_RANDOM ) ) top = center - width;

      // determine bottom
      if ( center > width * height - width ) bottom = -1;
      else if ( random == false || ( random == true && Math.random( ) * 100 < Globals.GROW_RANDOM ) ) bottom = center + width;

      // grow the tiles
      if ( left != -1 && map[ left ] == source )
      {
        map[ left ] = changeto;
        returnVal++;
      }
      if ( right != -1 && map[ right ] == source )
      {
        map[ right ] = changeto;
        returnVal++;
      }
      if ( top != -1 && map[ top ] == source )
      {
        map[ top ] = changeto;
        returnVal++;
      }
      if ( bottom != -1 && map[ bottom ] == source )
      {
        map[ bottom ] = changeto;
        returnVal++;
      }

      if ( itterations > 1 ) {
        returnVal += growTile( map, left, itterations - 1, source, random );
        returnVal += growTile( map, right, itterations - 1, source, random );
        returnVal += growTile( map, top, itterations - 1, source, random );
        returnVal += growTile( map, bottom, itterations - 1, source, random );
      }

      return returnVal;
    }

    // fix tile graphics with proper tileset graphics
    public function fixTiles( ):void
    {
      var left:int, right:int, top:int, bottom:int, connections:int, center:int;

      for ( var i:int = 0; i < width * height; i++ )
      {
        center = i;

        if ( map[ i ] != Globals.NULL_TILE ) {

          connections = 0;

          // determine left or none (if leftmost)
          if ( center % width == 0 ) left = -1;
          else {
            left = map[ center - 1 ];
            if ( left == Globals.NULL_TILE ) left = -1;
            else connections++;
          }

          // determine right
          if ( ( center + 1 ) % width == 0 ) right = -1;
          else {
            right = map[ center + 1 ];
            if ( right == Globals.NULL_TILE ) right = -1;
            else connections++;
          }

          // determine top
          if ( center < width ) top = -1;
          else {
            top = map[ center - width ];
            if ( top == Globals.NULL_TILE ) top = -1;
            else connections++;
          }

          // determine bottom
          if ( center >= width * height - width ) bottom = -1;
          else {
            bottom = map[ center + width ];
            if ( bottom == Globals.NULL_TILE ) bottom = -1;
            else connections++;
          }

          switch( connections ) {
            case 0:
              map[ i ] = getProperTile( elementOverlay[ i ], 1 );
              break;

            case 1:
              if ( left != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 5 );
              else if ( right != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 3 );
              else if ( top != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 2 );
              else if ( bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 4 );
              break;

            case 2:
              if ( left != -1 && top != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 6 );
              else if ( left != -1 && right != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 14 );
              else if ( left != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 9 );
              else if ( top != -1 && right != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 7 );
              else if ( top != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 15 );
              else if ( right != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 8 );
              break;

            case 3:
              if ( left != -1 && right != -1 && top != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 12 );
              else if ( left != -1 && right != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 10 );
              else if ( top != -1 && right != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 13 );
              else if ( top != -1 && left != -1 && bottom != -1 ) map[ i ] = getProperTile( elementOverlay[ i ], 11 );
              break;
            case 4:
              map[ i ] = getProperTile( elementOverlay[ i ], 16 );
              break;
          }
        }
      }
    }

    // populates elemental jurisdiction
    public function generateElementJurisdiction( ):void
    {
      var colonies:int

      for ( var k:int = 0; k < 5; k++ )
      {
        colonies = 0;
        // create initial colonies
        while ( colonies < 4 )
        {
          for ( var i:int = 0; i < width * height; i++ )
          {
            if ( colonies >= 4 ) break;
            if ( Math.random( ) * 10000 < 2 && elementOverlay[ i ] == 0 ) elementOverlay[ i ] = ++colonies;
          }
        }
      }
      colonies = (k + 1) * colonies;
      // grow colonies until whole map is full
      while ( colonies < width * height )
      {
        for ( var j:int = 0; j < width * height; j++ )
        {
          if ( elementOverlay[ j ] != 0 )
          {
            colonies += growTileRandom( elementOverlay, j, 1, 0 );
          }
        }
      }
    }

    // returns proper tile by base number for given element
    public function getProperTile( element:int, tileno:int ):int
    {
      switch( element )
      {
        case 1: // fire
          switch( tileno ) {
            case 1: return 29;
            case 2: return 30;
            case 3: return 31;
            case 4: return 32;
            case 5: return 45;
            case 6: return 46;
            case 7: return 47;
            case 8: return 48;
            case 9: return 61;
            case 10: return 62;
            case 11: return 63;
            case 12: return 64;
            case 13: return 77;
            case 14: return 78;
            case 15: return 79;
            case 16: return 80;
          }
          break;

        case 2: // earth
          switch( tileno ) {
            case 1: return 17;
            case 2: return 18;
            case 3: return 19;
            case 4: return 20;
            case 5: return 33;
            case 6: return 34;
            case 7: return 35;
            case 8: return 36;
            case 9: return 49;
            case 10: return 50;
            case 11: return 51;
            case 12: return 52;
            case 13: return 65;
            case 14: return 66;
            case 15: return 67;
            case 16: return 68;
          }
          break;

        case 3: // water
          switch( tileno ) {
            case 1: return 89;
            case 2: return 90;
            case 3: return 91;
            case 4: return 92;
            case 5: return 105;
            case 6: return 106;
            case 7: return 107;
            case 8: return 108;
            case 9: return 121;
            case 10: return 122;
            case 11: return 123;
            case 12: return 124;
            case 13: return 137;
            case 14: return 138;
            case 15: return 139;
            case 16: return 140;
          }
          break;

        case 4: // air
          switch( tileno ) {
            case 1: return 85;
            case 2: return 86;
            case 3: return 87;
            case 4: return 88;
            case 5: return 101;
            case 6: return 102;
            case 7: return 103;
            case 8: return 104;
            case 9: return 117;
            case 10: return 118;
            case 11: return 119;
            case 12: return 120;
            case 13: return 133;
            case 14: return 134;
            case 15: return 135;
            case 16: return 136;
          }
          break;
      }

      return Globals.NULL_TILE;
    }

    // just return island stats object
    public function returnIslandStats( ):IslandStats
    {
      return islandStats;
    }

    // just return my map
    public function returnMap( ):String
    {
      return FlxTilemap.arrayToCSV( map, width );
    }

    // just return elemental overlay
    public function returnElementalOverlay( ):String
    {
      return FlxTilemap.arrayToCSV( elementOverlay, width );
    }

    // returns overlay map
    public function returnOverlaymap( ):String
    {
      return FlxTilemap.arrayToCSV( overlayMap, width );
    }
  }
}