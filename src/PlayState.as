package
{
  /**
   * ...
   * @author Rafael Wenzel
   */
  import org.flixel.*;

  public class PlayState extends FlxState
  {
    private var map:FlxTilemap;
    private var elementMap:FlxTilemap;
    private var overlayMap:FlxTilemap;
    private var player:Player;

    public static var layer_world:FlxGroup;
    public static var layer_overlays:FlxGroup;

    private var god:God;

    [Embed(source = '../assets/graphics/tileset_final.png')] private var Tiles:Class;
    [Embed(source = '../assets/graphics/tileset_elements.png')] private var TilesElements:Class;

    public function PlayState()
    {
      god = new God( );
      super( );
    }

    override public function create():void
    {
      layer_world = new FlxGroup;
      layer_overlays = new FlxGroup;
      player = new Player( );

      // bottommost layer - world map
      map = new FlxTilemap;
      map.loadMap( god.getWorldmap( ), Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 1 );
      layer_world.add( map );

      // next layer, overlays for map like trees or mountains
      overlayMap = new FlxTilemap;
      overlayMap.loadMap( god.getOverlaymap( ), Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 1 );
      layer_overlays.add( overlayMap );

      this.add( layer_world );
      this.add( layer_overlays );
      this.add( player );


      FlxG.camera.follow( player );
      FlxG.camera.setBounds( 0, 0, Globals.TILE_WIDTH * Globals.WORLD_WIDTH, Globals.TILE_HEIGHT * Globals.WORLD_HEIGHT );
      FlxG.worldBounds = new FlxRect( 0, 0, map.width, map.height );
    }

    override public function update():void
    {

      // keep player within world land bounds
      if ( map.getTile( (player.x+Globals.TILE_WIDTH/2) / Globals.TILE_WIDTH, (player.y+Globals.TILE_HEIGHT) / Globals.TILE_HEIGHT ) != 16 ) {
        if ( !player.isFlying( ) ) {
          // TODO: step back player by facing direction
          FlxG.collide( player, map );
        }
      }

      super.update( );
    }
  }

}