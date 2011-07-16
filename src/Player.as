package
{
  import org.flixel.FlxSprite;
  import org.flixel.FlxG;
  import org.flixel.FlxTilemap;
  /**
   * ...
   * @author Rafael Wenzel
   */
  public class Player extends FlxSprite
  {
    [Embed(source = '../assets/graphics/player_m.png')] protected var Sprites:Class;
    protected static const PLAYER_SPEED:int = 400;

    protected var flying:Boolean;

    public function Player()
    {
      super( 10, 10 );
      loadGraphic( Sprites, true, false, 32, 32 );
      drag.x = PLAYER_SPEED * 8;
      drag.y = PLAYER_SPEED * 8;
      maxVelocity.x = PLAYER_SPEED;
      maxVelocity.y = PLAYER_SPEED;

      flying = true; // DEBUG

      addAnimation( "go_left", [3, 5], 5 );
      addAnimation( "go_right", [6, 8], 5 );
      addAnimation( "go_up", [9, 11], 5 );
      addAnimation( "go_down", [0, 2], 5 );
      addAnimation( "idle_up", [10] );
      addAnimation( "idle_down", [1] );
      addAnimation( "idle_left", [4] );
      addAnimation( "idle_right", [7] );
    }

    override public function update( ):void
    {
      velocity.x = 0;
      velocity.y = 0;

      if ( FlxG.keys.UP ) {
        velocity.y = -PLAYER_SPEED;
        play( "go_up" );
        facing = UP;
      }
      if ( FlxG.keys.DOWN ) {
        velocity.y = PLAYER_SPEED;
        play( "go_down" );
        facing = DOWN;
      }
      if ( FlxG.keys.LEFT ) {
        velocity.x = -PLAYER_SPEED;
        play( "go_left" );
        facing = LEFT;
      }
      if ( FlxG.keys.RIGHT ) {
        velocity.x = PLAYER_SPEED;
        play( "go_right" );
        facing = RIGHT;
      }

      if ( FlxG.keys.justPressed( "F" ) ) {
        flying = !flying;
        trace( 'TOGGLE FLYING to '+flying );
      }

      if ( velocity.x == 0 && velocity.y == 0 ) {
        if ( facing == UP ) play( "idle_up" );
        else if ( facing == DOWN ) play( "idle_down" );
        else if ( facing == LEFT ) play( "idle_left" );
        else if ( facing == RIGHT ) play( "idle_right" );
      }

      // stay within world bounds
      if ( x < 0 ) x = 0;
      else if ( x > FlxG.worldBounds.width - this.width ) x = FlxG.worldBounds.width- this.width;
      if ( y < 0 ) y = 0;
      else if ( y > FlxG.worldBounds.height - this.height ) y = FlxG.worldBounds.height - this.height;

      super.update( );
    }

    public function stop( map:FlxTilemap ):void
    {
      velocity.x = 0;
      velocity.y = 0;
    }

    public function isFlying( ):Boolean
    {
      return flying;
    }

  }

}