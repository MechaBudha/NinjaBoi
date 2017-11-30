package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxColor;

/**
 * ...
 * @author Tomás Mugetti
 */
class Enemigo extends FlxSprite 
{
	private var jugador:Jugador;
	private var angulo:Float;
	private var emisor:FlxEmitter;
	private var estado:PlayState;
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset, _jugador:Jugador, _estado:PlayState) 
	{
		super(X, Y, SimpleGraphic);
		jugador = _jugador;
		loadGraphic(AssetPaths.Bicho1__png, true, 32, 32);
		animation.add("wea", [0, 1], 8, true);
		animation.play("wea");
		
		emisor = new FlxEmitter(this.x,this.y,30);
		estado = _estado;
		estado.add(emisor);
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//angulo = Math.atan2(jugador.y - this.y, jugador.x - this.x) * 57.2958;
		//if (this.x < jugador.x + (jugador.width - this.width)/2) 
		//{
			//velocity.x = Math.cos(angulo) * 100;
		//} else if (this.x > jugador.x + (jugador.width - this.width)/2) 
		//{
			//velocity.x = -(Math.cos(angulo) * 100);
		//} else 
		//{
			//velocity.x = 0;
		//}
		//if (this.y < jugador.y + (jugador.height - this.height)/2) 
		//{
			//velocity.y = Math.tan(angulo) * 100;
		//} else if (this.y > jugador.y + (jugador.height - this.height)/2) 
		//{
			//velocity.y = -(Math.tan(angulo) * 100);
		//} else 
		//{
			//velocity.y = 0;
		//}
		if (this.x < jugador.x + (jugador.width - this.width)/2) 
		{
			velocity.x = 50;
		} else if (this.x > jugador.x + (jugador.width - this.width)/2) 
		{
			velocity.x = -50;
		} else 
		{
			velocity.x = 0;
		}
		if (this.y < jugador.y + (jugador.height - this.height)/2) 
		{
			velocity.y = 50;
		} else if (this.y > jugador.y + (jugador.height - this.height)/2) 
		{
			velocity.y = -50;
		} else 
		{
			velocity.y = 0;
		}
	}
	override public function destroy():Void
	{
		emisor.focusOn(this);
		emisor.makeParticles(2,2,FlxColor.RED,30);
		emisor.lifespan.set(1,1);
		emisor.solid = true;
		emisor.start(true);
		//emisor.destroy();
		super.destroy();
	}
	
}