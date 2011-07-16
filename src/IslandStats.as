package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class IslandStats
  {
    private var counter:int;
    public var islands:Array;
    private var islandMap:Array;

    public function IslandStats()
    {
      counter = 0; // holds count of all islands, number will be id for island
      islands = new Array( );
      islandMap = new Array( );

      // initialize map
      for ( var i:int = 0; i < Globals.WORLD_TILES; i++ )
      {
        islandMap[ i ] = 0;
      }
    }

    public function parse( map:Array ):void
    {
      var total:int;

      // mark islands and count size
      for ( var i:int = 0; i < Globals.WORLD_TILES; i++ )
      {
        total = 0;
        // start new cycle
        if ( islandMap[ i ] == 0 && map[ i ] == Globals.INITIAL_TILE )
        {
          total = growAndCount( map, i, ++counter );
          var island:Object = new Object( );
          island.size = total;
          island.id = counter;
          island.startingTile = -1;
          islands.push( island );
        }
      }

      // mark starting points
      for ( i = 0; i < Globals.WORLD_TILES; i++ )
      {
        if ( islandMap[ i ] > 0 && islands[ islandMap[ i ] -1 ].startingTile == -1 )
        {
          islands[ islandMap[ i ] - 1 ].startingTile = i;
        }
      }

    }

    // grow current island, mark it and return counter
    public function growAndCount( map:Array, center:int, id:int ):int
    {
      var left:int, right:int, top:int, bottom:int, retCount:int;
      retCount = 0;

      // determine bording tiles
      // determine left or none (if leftmost)
      if ( center % Globals.WORLD_WIDTH == 0 ) left = -1;
      else left = center - 1;

      // determine right
      if ( center % Globals.WORLD_WIDTH - 1 == 0 ) right = -1;
      else right = center + 1;

      // determine top
      if ( center < Globals.WORLD_WIDTH ) top = -1;
      else top = center - Globals.WORLD_WIDTH;

      // determine bottom
      if ( center > Globals.WORLD_TILES - Globals.WORLD_WIDTH ) bottom = -1;
      else bottom = center + Globals.WORLD_WIDTH;

      // mark and grow
      islandMap[ center ] = id;
      retCount++;

      if ( left != -1 && islandMap[ left ] == 0 && map[ left ] == Globals.INITIAL_TILE ) retCount += growAndCount( map, left, id );
      if ( right != -1 && islandMap[ right ] == 0 && map[ right ] == Globals.INITIAL_TILE ) retCount += growAndCount( map, right, id );
      if ( top != -1 && islandMap[ top ] == 0 && map[ top ] == Globals.INITIAL_TILE ) retCount += growAndCount( map, top, id );
      if ( bottom != -1 && islandMap[ bottom ] == 0 && map[ bottom ] == Globals.INITIAL_TILE ) retCount += growAndCount( map, bottom, id );

      return retCount;
    }

    // returns the island map for use
    public function returnIslandmap( ):Array
    {
      return islandMap;
    }

    // debug output
    public function debug( ):void
    {
      for ( var i:int = 0; i < islands.length; i++ )
      {
        trace( 'ID: '+islands[ i ].id+'; Size: '+islands[ i ].size+'; Starting at: '+islands[ i ].startingTile );
      }
    }

  }

}