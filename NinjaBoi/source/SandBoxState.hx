package;

import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;

/**
 * ...
 * @author Tomás Mugetti
 */
class SandBoxState extends FlxState 
{
	private var _map:FlxOgmoLoader;
	private var _mPiso:FlxTilemap;
	private var _mPlat:FlxTilemap;
	
	public function new() 
	{
		_map = new FlxOgmoLoader(AssetPaths.sandbox__oep);
		_mPiso = _map.loadTilemap(AssetPaths.tilesPetes__png,16,16,"Piso");
		_mPlat = _map.loadTilemap(AssetPaths.tilesPetes__png,16,16,"Plataforma");
	}
	
}