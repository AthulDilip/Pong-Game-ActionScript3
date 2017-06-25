package {
//imports	
import flash.display.MovieClip;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;
import flash.events.Event;
	
	public class Main extends MovieClip {
		//constants
		const ballspeed:int = 10;
		const playerspeed:int = 7;
		const computerspeed:int = 10;
		const computerIntelligence:int = 7;//intelligence is 7 out of 10
		
		//global variables
		var vx:int  = -ballspeed; // x component of velocity of ball (velocity is speed with direction)
		var vy:int  = ballspeed;  // y component of velocity of ball
		var v1:int  = 0;  // initial velocity of player
		var v2:int  = 0;  // initial velocity of computer
		var playerScore:int   = 0;
		var computerScore:int = 0;
		
		public function Main() {
			init();
	    }
		//this function will add all event listeners
		function init():void {
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		// this function resets the game
		function reset():void {
			player.y   = stage.stageHeight/2;
			computer.y = stage.stageHeight/2;
			ball.x     = stage.stageWidth/2;
			ball.y     = stage.stageHeight/2;
			if(Math.abs(Math.random()*2) > 1){
			vx = -ballspeed;
			}else{
			vx = ballspeed;	
			}
			if(Math.abs(Math.random()*2) > 1){
			vy = -ballspeed;
			}else{
			vy = ballspeed;	
			}
		}
		//this function sets the velocity of player when key is pressed
		function onKeyDown(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.UP) {
				v1 = -playerspeed;
			}else if(event.keyCode == Keyboard.DOWN) {
				v1 = playerspeed;
			}
		}
		//this function sets the velocity of player to 0 if key is released
		function onKeyUp(event:KeyboardEvent):void {
			if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN) {
				v1 = 0;
			}
		}
		
		//This function is executed when a frame changes
		function onEnterFrame(event:Event):void {
			//variable decleration
			var pHalfHeight = player.height/2; // half height of player(used for collisions)
		    var pHalfWidth  = player.width/2;   // half width of player (used for collisions)
		    var bHalfHeight = ball.height/2; // half height of ball(used for collisions)
		    var bHalfWidth  =  ball.width/2;   // half width of ball (used for collisions)
			
			//moving the player
			player.y += v1;
			//limiting the motion of player (it should not move beyond the stageheight)
			if(player.y + pHalfHeight > stage.stageHeight) {
				player.y = stage.stageHeight - pHalfHeight;
			}else if(player.y - pHalfHeight < 0) {
				player.y = 0 + pHalfHeight;
			}
			
			//moving the ball
			ball.x += vx;
			ball.y += vy;
            
			//moving the computer automatically
			if(Math.abs(Math.random()*10) < computerIntelligence){
				var d:int = computer.y - ball.y;
				if(Math.abs(d) > pHalfHeight){
					if(d>0) {
						v2 = -computerspeed;
					}else{
						v2 = computerspeed;
					}
				}
			}
			computer.y += v2;
			//limiting the motion of computer (it should not move beyond the stageheight)
			if(computer.y + pHalfHeight > stage.stageHeight) {
				computer.y = stage.stageHeight - pHalfHeight;
			}else if(computer.y - pHalfHeight < 0) {
				computer.y = 0 + pHalfHeight;
			}
			
			//collision with horizontal walls
			if(ball.y + bHalfHeight >= stage.stageHeight || ball.y - bHalfHeight <= 0) {
				vy *= -1;
			}
			
			//collision with player and computer
			if(ball.x - bHalfWidth <= player.x + pHalfWidth) {
				if(Math.abs(ball.y - player.y) <= pHalfHeight) {
				vx = ballspeed;
				if(v1!=0){
					vy = 2*v1;
				}
				}
			}else if(ball.x + bHalfWidth >= computer.x - pHalfWidth) {
				if(Math.abs(ball.y - computer.y) <= pHalfHeight) {
				vx = -ballspeed;
				if(v2!=0){
					vy = v2;
				}
				}
			}
			
			//collision with vertical walls & updating scores
			if(ball.x + bHalfWidth >= stage.stageWidth) {
				playerScore += 1;
				reset();
			}else if(ball.x - bHalfWidth <= 0) {
				computerScore += 1;
				reset();
			}
			
			//display the score on the textfield
			txtPlayer.text  = String(playerScore);
			txtComputer.text = String(computerScore);
		}
	}
}