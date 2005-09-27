////////////////////////////////////////////////////////////////////////////////
//
// Natural Entry Point Method Sample Application
// for Swfmill + MTASC
//
// Application class.
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

import LuminicBox.Log.*;

class Application extends MovieClip
{
	var tfCaption:TextField;
	
	// Clips attached dynamically from Swfmill library
	var mcSpheres:MovieClip;

	var sW:Number = null; 	// Stage width
	var sH:Number = null;	// Stage height 
	
	// Log
	var log:Logger;	
		
	function Application ()
	{
		// Setup logging
		log = new Logger();
		log.addPublisher ( new ConsolePublisher() );
		log.info ( "Application::Constructor" );	
	}

	function onLoad ()
	{
		log.info ( "Application::onLoad" );
		log.debug ( "this = " + this );

		// Store stage dimensions for easy look-up
		sW = Stage.width - 1;
		sH = Stage.height - 1;
		
		// Draw border around the stage
		lineStyle ( 1, 0x000000 );
		moveTo ( 0, 0 );
		lineTo ( sW, 0 );
		lineTo ( sW, sH );
		lineTo ( 0, sH );
		lineTo ( 0, 0 );
		
		//
		// Create a message
		//
		var captionTextFormat = new TextFormat();
		captionTextFormat.size = 12;
		captionTextFormat.font = "_sans";
		
		var captionText:String = "Swfmill + MTASC Natural Entry Point Sample";
		
		var captionTextExtent:Object = captionTextFormat.getTextExtent ( captionText );
		var captionWidth:Number = captionTextExtent.textFieldWidth;
		var captionHeight:Number = captionTextExtent.textFieldHeight;
		var captionX = sW / 2 - captionWidth / 2;
		var captionY = sH - captionHeight;
		
		createTextField( "tfCaption", 10000, captionX, captionY, captionWidth, captionHeight );
	
		// Write caption text
		tfCaption.text = captionText;
		
		// Add ten particles
		for ( var i = 0; i < 10; i++ )
		{
			// Attach a sphere clip
			attachMovie ("EclipseLogo", "eclipseLogo" + i, 1000 + i );
		}
	}
}