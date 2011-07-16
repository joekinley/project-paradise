package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class CityGenerator
  {

    private var islandMap:Array; // reference to the island map
    private var overlayMap:Array; // place to put cities to

    public function CityGenerator( map:Array, overlay:Array )
    {
      islandMap = map;
      overlayMap = overlay;
    }

    // places initial cities
    public function placeCities( ):void
    {
      for ( var i:int = 0; i < Globals.WORLD_TILES; i++ )
      {
        if ( islandMap[ i ] != 0 )
        {
          if ( Math.random( ) * 1000 < Globals.CITY_RANDOM )
          {
            trace( 'PLACING CITY' );
            overlayMap[ i ] = 145;
          }
        }
      }
    }

  }

}