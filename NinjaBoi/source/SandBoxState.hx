package;

import entities.Jugador;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.FlxObject;
import flixel.FlxG;
/**
 * ...
 * @author Tomás Mugetti
 */
class SandBoxState extends FlxState 
{
	private var map:FlxOgmoLoader;
	private var mPiso:FlxTilemap;
	private var mPlat:FlxTilemap;
	private var jugador:Jugador;
	public function new() 
	{
		super();
		map = new FlxOgmoLoader(AssetPaths.sandbox__oel);
		mPiso = map.loadTilemap(AssetPaths.tilesPetes__png,16,16,"Piso");
		mPlat = map.loadTilemap(AssetPaths.tilesPetes__png, 16, 16, "Plataforma");
		mPiso.setTileProperties(0, FlxObject.NONE);
		mPiso.setTileProperties(1, FlxObject.DOWN);
		mPiso.setTileProperties(2, FlxObject.NONE);
		mPiso.setTileProperties(3, FlxObject.ANY);
		
		mPlat.setTileProperties(0, FlxObject.NONE);
		mPlat.setTileProperties(1, FlxObject.DOWN);
		mPlat.setTileProperties(2, FlxObject.NONE);
		mPlat.setTileProperties(3, FlxObject.ANY);
		
		add(mPiso);
		add(mPlat);
		
		jugador = new Jugador(50, 50);
		add(jugador);
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(jugador, mPiso);
	}
	
	
}