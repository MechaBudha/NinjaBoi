package;

import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.FlxG;
import openfl.system.System;

/**
 * ...
 * @author Tomás Mugetti
 */
class Muerte extends FlxSubState 
{
	private var estado:PlayState;
	private var botonRe:FlxButton;
	private var botonSalir:FlxButton;
	private var texto:FlxText;
	public function new(BGColor:FlxColor=FlxColor.TRANSPARENT, _estado:PlayState) 
	{
		super(0x0F000000);
		FlxG.mouse.visible = true;
		estado = _estado;
		texto = new FlxText(0, 0, 0, "Moriste, por pete", 32);
		texto.color = FlxColor.RED;
		texto.screenCenter();
		add(texto);
		botonRe = new FlxButton(0, 0, "Reiniciar", reiniciar);
		botonRe.screenCenter();
		botonRe.y += texto.height;
		add(botonRe);
		botonSalir = new FlxButton(0, 0, "Salir", salir);
		botonSalir.screenCenter();
		botonSalir.y = botonRe.y + botonRe.height;
		add(botonSalir);
		
	}
	private function reiniciar():Void
	{
		FlxG.mouse.visible = false;
		estado.init();
		this.close();
	}
	private function salir():Void
	{
		System.exit(0);
	}
}