package;

import entities.Jugador;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import entities.Enemigo;
import flixel.math.FlxRandom;
import flixel.util.helpers.FlxRangeBounds;
import flixel.util.FlxColor;
class PlayState extends FlxState
{
	
	private var jugador:Jugador;
	private var map:FlxOgmoLoader;
	private var mPiso:FlxTilemap;
	private var emisor:FlxEmitter;
	private var puntAhora:Int;
	private var puntAhoraTxt:FlxText;
	private var puntMaxTxt:FlxText;
	private var enemyGroup:FlxTypedGroup<Enemigo>;
	private var tiempo:Float;
	private var contador:Float;
	private var esperar:Float;
	private var r:FlxRandom;
	override public function create():Void
	{
		super.create();
		FlxG.mouse.visible = false;
		bgColor = 0xFFFFFFFF;
		map = new FlxOgmoLoader(AssetPaths.Pilares__oel);
		mPiso = map.loadTilemap(AssetPaths.columnas__png, 50, 50, "Piso");
		mPiso.setTileProperties(0, FlxObject.NONE);
		mPiso.setTileProperties(1, FlxObject.ANY);
		mPiso.setTileProperties(2, FlxObject.ANY);
		mPiso.setTileProperties(3, FlxObject.ANY);
		mPiso.setTileProperties(4, FlxObject.ANY);
		mPiso.setTileProperties(5, FlxObject.ANY);
		mPiso.setTileProperties(6, FlxObject.ANY);
		add(mPiso);
		
		enemyGroup = new FlxTypedGroup<Enemigo>();
		r = new FlxRandom();
		init();
		
		puntAhoraTxt = new FlxText(0, 0, "Score: " + puntAhora, 36);
		puntAhoraTxt.color = 0x0000FF;
		add(puntAhoraTxt);
		
		add(jugador);
		
		//https://github.com/HaxeFlixel/flixel-demos/blob/master/Features/Particles/source/PlayState.hx
		emisor = new FlxEmitter(FlxG.camera.width/2, FlxG.camera.height/2, 30);
		add(emisor);
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		enemyCreator(elapsed);
		FlxG.collide(jugador, mPiso);
		FlxG.collide(jugador, enemyGroup, colisionEnemigo);
		puntAhoraTxt.text = "Score: " + puntAhora;
	}
	private function init():Void
	{
		puntAhora = 0;
		jugador = new Jugador();
		jugador.screenCenter();
		tiempo = 0;
		esperar = 0;
		contador = 10;
		for (i in 0 ... enemyGroup.length -1) 
		{
			enemyGroup.remove(enemyGroup.members[i]);
			remove(enemyGroup.members[i]);
		}
	}
	private function enemyCreator(elapsed:Float):Void
	{
		tiempo += elapsed;
		esperar += elapsed;
		if (tiempo >= contador && esperar >= 1.5) 
		{
			tiempo = 0;
			esperar = 0;
			contador--;
			crearRandomEnemy();
		}
	}
	private function crearRandomEnemy():Void
	{
		var enemy:Enemigo = new Enemigo(jugador);
		switch (r.int(0,5)) 
		{
			case 0:
				enemy.x = 0;
				enemy.y = 0;
			case 1:
				enemy.x = 0;
				enemy.y = FlxG.camera.height + enemy.height;
			case 2:
				enemy.x = FlxG.camera.width + enemy.width;
				enemy.y = 0;
			case 3:
				enemy.x = FlxG.camera.width + enemy.width;
				enemy.y = FlxG.camera.height + enemy.height;
			case 4:
				enemy.x = 0;
				enemy.y = (FlxG.camera.height + enemy.height) / 2;
			case 5:
				enemy.x = FlxG.camera.width + enemy.width;
				enemy.y = (FlxG.camera.height + enemy.height) / 2;
			default:
				enemy.x = 0;
				enemy.y = 0;
		}
		enemyGroup.add(enemy);
		add(enemyGroup);
	}
	
	private function colisionEnemigo(jug:Jugador,ene:Enemigo)
	{
		if (jug.getAttackFlag()) 
		{
			if (ene.x > jug.x && jug.facing == FlxObject.RIGHT) 
			{
				matarEnemigo(ene);
			} else if (ene.x < jug.x && jug.facing == FlxObject.LEFT) 
			{
				matarEnemigo(ene);
			} else 
			{
				matarJugador();
			}
		}else 
		{
			matarJugador();
		}
	}
	private function matarJugador():Void
	{
		jugador.destroy();
	}
	private function matarEnemigo(ene:Enemigo):Void
	{
		puntAhora += (r.int(15, 30));
		emisor.focusOn(ene);
		emisor.makeParticles(2,2,FlxColor.RED,30);
		emisor.lifespan.set(1,1);
		emisor.solid = true;
		emisor.start(true);
		enemyGroup.remove(ene);
		ene.destroy();
	}
}