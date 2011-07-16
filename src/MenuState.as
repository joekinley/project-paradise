package  
{
	/**
	 * ...
	 * @author Rafael Wenzel
	 */
	import org.flixel.*;
	public class MenuState extends FlxState
	{
		
		private var gameTitle:FlxText;
		private var startButton:FlxButton;
		public function MenuState()
		{
		}
		override public function create():void
		{
			FlxG.mouse.show();
			gameTitle = new FlxText(0, 0, 80, "Start Game");
			gameTitle.alignment = "center";
			gameTitle.color = 0x8000FF;
			startButton = new FlxButton(120, 90, "My Game", startGame);
			add(startButton);
		}
		private function startGame():void
		{
			FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}

		
	}

}