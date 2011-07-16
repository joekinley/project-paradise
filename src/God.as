package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class God
  {
    // settings
    private var worldWidth:int;
    private var worldHeight:int;

    // classes
    private var worldGenerator:WorldGenerator;
    private var islandStats:IslandStats;

    public function God()
    {
      // settings
      worldWidth = Globals.WORLD_WIDTH;
      worldHeight = Globals.WORLD_HEIGHT;

      initialize( );
    }

    // initializes a new game
    public function initialize( ):void
    {
      worldGenerator = new WorldGenerator( worldWidth, worldHeight );
      islandStats = worldGenerator.returnIslandStats( );

      // DEBUG
      //islandStats.debug( );
    }

    // return world map
    public function getWorldmap( ):String
    {
      return worldGenerator.returnMap( );
    }

    // returns overlay map
    public function getOverlaymap( ):String
    {
      return worldGenerator.returnOverlaymap( );
    }
  }

}