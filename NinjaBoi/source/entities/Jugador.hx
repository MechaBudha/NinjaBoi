package entities;


import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author TU MADRE
 */
class Jugador extends FlxSprite 
{
	private var fsm:FlxFSM<FlxSprite>;

	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(15, 15, 0xFF000000);
		
		acceleration.y = Dios.gravedad;
		maxVelocity.set(100, Dios.gravedad);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		
		fsm = new FlxFSM<FlxSprite>(this);
		fsm.transitions
		.add(Idle, Jump, Conditions.jump)
		.add(Jump, Idle, Conditions.grounded)
		.add(Jump, SideSwipe, Conditions.sideSwipe)
		.start(Idle);
	}
	override public function update(elapsed:Float):Void
	{
		fsm.update(elapsed);
		super.update(elapsed);
	}
	override public function destroy():Void 
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
}

//https://github.com/HaxeFlixel/flixel-demos/blob/master/Features/FlxFSM/source/Slime.hx
//http://haxeflixel.com/demos/FlxFSM/
class Conditions
{
	public static function jump(Owner:FlxSprite):Bool
	{
		return (FlxG.keys.justPressed.UP && Owner.isTouching(FlxObject.DOWN));
	}
	
	public static function grounded(Owner:FlxSprite):Bool
	{
		return Owner.isTouching(FlxObject.DOWN);
	}
	public static function animationFinished(Owner:FlxSprite):Bool
	{
		return Owner.animation.finished;
	}
	public static function sideSwipe(Owner:FlxSprite):Bool
	{
		return (FlxG.keys.justPressed.Z && !Owner.isTouching(FlxObject.DOWN));
	}
}

class Idle extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		//owner.animation.play("standing");
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.facing = FlxG.keys.pressed.LEFT ? FlxObject.LEFT : FlxObject.RIGHT;
			//owner.animation.play("walking");
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
		else
		{
			//owner.animation.play("standing");
			owner.velocity.x *= 0.9;
		}
	}
}

class Jump extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		//owner.animation.play("jumping");
		owner.velocity.y = -200;
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
	}
}

class SideSwipe extends FlxFSMState<FlxSprite>
{
	var inicio:Float;
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
	{
		//owner.animation.play("sideswipe");
		inicio = owner.x;
		owner.velocity.x = (owner.facing == FlxObject.LEFT) ? -200 : 200;
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		if (owner.x - inicio == 100 || inicio - owner.x == 100) 
		{
			owner.velocity.x = 0;
		}
	}
}
