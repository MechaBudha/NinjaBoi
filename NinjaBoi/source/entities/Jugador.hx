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
		loadGraphic(AssetPaths.ninjaBoi__png, true, 96, 96);
		scale.set(0.5,0.5);
		updateHitbox();
		animation.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 8, true);
		animation.add("jump", [9], 8, false);
		animation.add("fall", [10], 8, false);
		animation.add("fell",[8],8,false);
		animation.add("walk", [11, 12, 13, 14, 15], 8, true);
		animation.add("attack", [17, 17, 17], 8, false);
		animation.add("attacking", [16], 8, false);
		animation.add("die", [18, 19, 20, 21], 8, false);
		
		
		
		//acceleration.y = Dios.gravedad;
		maxVelocity.set(100, Dios.gravedad);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		
		fsm = new FlxFSM<FlxSprite>(this);
		fsm.transitions
		.add(Idle, Jumping, Conditions.jump)
		.add(Jumping, Jump,Conditions.animationFinished)
		.add(Idle, Attacking, Conditions.sideSwipe)
		.add(Jump, Idle, Conditions.grounded)
		.add(Fall, Attacking,Conditions.sideSwipe)
		.add(Jump, Attacking, Conditions.sideSwipe)
		.add(Attacking, SideSwipe,Conditions.animationFinished)
		.add(Jump, Fall, Conditions.fall)
		.add(Idle, Fall, Conditions.fall)
		.add(Fall, Fell, Conditions.grounded)
		.add(Fell, Idle,Conditions.animationFinished)
		.add(SideSwipe, Idle, Conditions.animationFinished)
		.add(SideSwipe, Fall, Conditions.animationFinishedFall)
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
	public static function fall(Owner:FlxSprite):Bool
	{
		return Owner.velocity.y > 0;
	}
	public static function grounded(Owner:FlxSprite):Bool
	{
		return (Owner.isTouching(FlxObject.DOWN) || Owner.velocity.y == 0);
	}
	public static function animationFinished(Owner:FlxSprite):Bool
	{
		return Owner.animation.finished;
	}
	public static function animationFinishedFall(Owner:FlxSprite):Bool
	{
		return (Owner.animation.finished && Owner.velocity.y > 0);
	}
	public static function sideSwipe(Owner:FlxSprite):Bool
	{
		return FlxG.keys.justPressed.Z;
	}
}

class Idle extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		owner.animation.play("idle");
		owner.acceleration.y = Dios.gravedad;
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.facing = FlxG.keys.pressed.LEFT ? FlxObject.LEFT : FlxObject.RIGHT;
			owner.animation.play("walk");
			owner.acceleration.y = Dios.gravedad;
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
		else
		{
			owner.animation.play("idle");
			owner.acceleration.y = Dios.gravedad;
			owner.velocity.x = 0;
		}
	}
}

class Fall extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fall");
	}
}
class Attacking extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
	{
		owner.acceleration.y = 0;
		owner.velocity.y = 0;
		owner.velocity.x = 0;
		owner.animation.play("attacking");
	}
}
class Fell extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fell");
	}
}
class Jumping extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fell");
	}
}

class Jump extends FlxFSMState<FlxSprite>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("jump");
		owner.velocity.y -= 400;
		
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		//owner.acceleration.x = 0;
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
		owner.animation.play("attack");
		inicio = owner.x;
		owner.velocity.x = (owner.facing == FlxObject.LEFT) ? -500 : 500;
	}
	
	override public function update(elapsed:Float, owner:FlxSprite, fsm:FlxFSM<FlxSprite>):Void 
	{
		if (owner.x - inicio == 200 || inicio - owner.x == 200) 
		{
			owner.velocity.x = 0;
		}
	}
}
