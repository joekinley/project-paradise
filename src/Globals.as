package
{
	/**
   * ...
   * @author Rafael Wenzel
   */
  public class Globals
  {
    // basic information - DO NOT TOUCH
    public static const TILE_WIDTH:int = 32;
    public static const TILE_HEIGHT:int = 32;

    // world variables
    public static const WORLD_WIDTH:int = 100;
    public static const WORLD_HEIGHT:int = 100;
    public static const WORLD_TILES:int = WORLD_WIDTH * WORLD_HEIGHT;

    // generator variables
    public static const TILESET_WIDTH:int = 16; // width of tile image
    public static const TILESET_HEIGHT:int = 15; // height of tile image

    // special tile information
    public static const NULL_TILE:int = 1;
    public static const EMPTY_TILE:int = 3; // empty transparent tile
    public static const INITIAL_TILE:int = 2; // initial tile within growing algorithm

    // generation percentages
    public static const GROW_RANDOM:int = 45; // probability of random growing algorithm to grow a tile
    public static const CITY_RANDOM:int = 2; // probability for a city to be placed on an island

  }

}