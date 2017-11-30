package entities;


import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.util.FlxFSM;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.particles.FlxEmitter;
import flixel.util.helpers.FlxRangeBounds;
import flixel.util.FlxColor;

/**
 * ...
 * @author TU MADRE
 */
class Jugador extends FlxSprite 
{
	private var fsm:FlxFSM<Jugador>;
	private var ataque:Bool;
	private var emisor:FlxEmitter;
	private var attackFlag:Bool;
	private var muerteFlag:Bool;
	private var muertoFlag:Bool;
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
		
		ataque = true;
		
		//acceleration.y = Dios.gravedad;
		maxVelocity.set(100, Dios.gravedad);
		
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		facing = FlxObject.RIGHT;
		
		attackFlag = false;
		muerteFlag = false;
		muertoFlag = false;
		fsm = new FlxFSM<Jugador>(this);
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
		.add(Idle, Die, Conditions.die)
		.add(Fell, Die, Conditions.die)
		.add(Fall, Die, Conditions.die)
		.add(SideSwipe, Die, Conditions.die)
		.add(Jump, Die, Conditions.die)
		.add(Attacking, Die, Conditions.die)
		.add(Jumping, Die, Conditions.die)
		.add(Die, Dead, Conditions.animationFinished)
		.start(Idle);
	}
	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.LEFT) 
		{
			facing = FlxObject.LEFT;
		}
		if (FlxG.keys.pressed.RIGHT) 
		{
			facing = FlxObject.RIGHT;
		}
		if (isTouching(FlxObject.FLOOR)) 
		{
			ataque = true;
		}
		fsm.update(elapsed);
		super.update(elapsed);
		
	}
	override public function destroy():Void 
	{
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
	public function negarAtaque():Void
	{
		ataque = false;
	}
	public function getAtaque():Bool
	{
		return ataque;
	}
	public function getAttackFlag():Bool
	{
		return attackFlag;
	}
	public function setAttackFlag(bl:Bool):Void
	{
		attackFlag = bl;
	}
	public function setMuerteFlag(bl:Bool):Void
	{
		muerteFlag = bl;
	}
	public function getMuerteFlag():Bool
	{
		return muerteFlag;
	}
	public function getMuertoFlag():Bool
	{
		return muertoFlag;
	}
	public function setMuertoFlag(bl:Bool):Void
	{
		muertoFlag = bl;
	}
}

//https://github.com/HaxeFlixel/flixel-demos/blob/master/Features/FlxFSM/source/Slime.hx
//http://haxeflixel.com/demos/FlxFSM/
class Conditions
{
	public static function jump(Owner:Jugador):Bool
	{
		return (FlxG.keys.justPressed.UP && Owner.isTouching(FlxObject.DOWN));
	}
	public static function fall(Owner:Jugador):Bool
	{
		return Owner.velocity.y > 0;
	}
	public static function grounded(Owner:Jugador):Bool
	{
		return (Owner.isTouching(FlxObject.DOWN) || Owner.velocity.y == 0);
	}
	public static function animationFinished(Owner:Jugador):Bool
	{
		return Owner.animation.finished;
	}
	public static function animationFinishedFall(Owner:Jugador):Bool
	{
		return (Owner.animation.finished && Owner.velocity.y > 0);
	}
	public static function sideSwipe(Owner:Jugador):Bool
	{
		return FlxG.keys.justPressed.Z && Owner.getAtaque();
	}
	public static function die(Owner:Jugador):Bool
	{
		return Owner.getMuerteFlag();
	}
}

class Idle extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void 
	{
		owner.animation.play("idle");
		owner.acceleration.y = Dios.gravedad;
		owner.setAttackFlag(false);
	}
	
	override public function update(elapsed:Float, owner:Jugador, fsm:FlxFSM<Jugador>):Void 
	{
		owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
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
//atlerar caja con width y heigh, offset.
class Fall extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fall");
	}
}
class Attacking extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void
	{
		owner.acceleration.y = 0;
		owner.velocity.y = 0;
		owner.velocity.x = 0;
		owner.negarAtaque();
		owner.animation.play("attacking");
		owner.setAttackFlag(true);
	}
}
class Fell extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fell");
	}
}
class Jumping extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("fell");
	}
}

class Jump extends FlxFSMState<Jugador>
{
	override public function enter(owner:FlxSprite, fsm:FlxFSM<Jugador>):Void 
	{
		owner.acceleration.y = Dios.gravedad;
		owner.animation.play("jump");
		owner.velocity.y -= 400;
		
	}
	
	override public function update(elapsed:Float, owner:Jugador, fsm:FlxFSM<Jugador>):Void 
	{
		//owner.acceleration.x = 0;
		if (FlxG.keys.pressed.LEFT || FlxG.keys.pressed.RIGHT)
		{
			owner.acceleration.x = FlxG.keys.pressed.LEFT ? -300 : 300;
		}
	}
}

class SideSwipe extends FlxFSMState<Jugador>
{
	var inicio:Float;
	override public function enter(owner:Jugador, fsm:FlxFSM<Jugador>):Void
	{
		owner.animation.play("attack");
		inicio = owner.x;
		owner.velocity.x = (owner.facing == FlxObject.LEFT) ? -500 : 500;
	}
	
	override public function update(elapsed:Float, owner:Jugador, fsm:FlxFSM<Jugador>):Void 
	{
		if (owner.x - inicio == 200 || inicio - owner.x == 200) 
		{
			owner.velocity.x = 0;
		}
	}
}

class Die extends FlxFSMState<Jugador>
{
	override public function enter(owner:Jugador, fms:FlxFSM<Jugador>):Void
	{
		owner.animation.play("die");
		owner.velocity.x = 0;		
	}
}

class Dead extends FlxFSM<Jugador>
{
	override public function enter(owner:Jugador, fxm:FlxFSM<Jugador>):Void 
	{
		owner.setMuertoFlag = true;
	}
}
