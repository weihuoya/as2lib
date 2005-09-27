////////////////////////////////////////////////////////////////////////////////
//
// Natural Entry Point Method Sample Application
// for Swfmill + MTASC
//
// Particle class.
//
// Author: Aral Balkan
// 
// Copyright:
// Copyright © 2004, 2005 Aral Balkan. All Rights Reserved.
// Copyright © 2004, 2005 Ariaware Limited.
// http://ariaware.com
//
// Flash Platform and RIA blog:
// http://flashant.org
//
// OSFlash - Open Source Flash:
// http://osflash.org
//
// Released under the open-source MIT license.  
//
////////////////////////////////////////////////////////////////////////////////

class Particle extends MovieClip
{
	var vX:Number = null;
	var vY:Number = null;
	var randomness:Number = null;

	function Particle ()
	{
		_x = _width + Math.random() * ( Stage.width - _width );
		_y = _height + Math.random() * ( Stage.height - _height );
		
		_rotation = Math.random() * 360;
		
		var randomness = Math.random()*5;
		
		vX = Math.random() * randomness + 1;
		vY = Math.random() * randomness + 1;		
	}
	
	function onEnterFrame ()
	{
		_rotation += 1.69;
		
		_x += vX;
		_y += vY;
		
		if ( _x < 0 || _x > ( Stage.width - _width/2 ) )
		{
			vX *= -1;
			_x += 2 * vX;
		}
		
		if ( _y < 0 || _y > ( Stage.height - _height/2 ) )
		{
			vY *= -1;	
			_y += 2 * vY;
		}
	}
}