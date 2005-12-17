﻿/**
* 
* DebugIt Receiver INCLUDE
* 
* OPEN SOURCE
*
* @ Created by: Robert Hoekman, Jr. (www.rhjr.net) & Interactive Alchemy (www.InteractiveAlchemy.com)
*
* @ PURPOSE: Used in conjunction with Debug class. Receives data sent over LocalConnection by Debug.write()
* calls in your application and displays it.
* This enables you to debug applications outside of the Flash authoring tool, while your application is
* running in its shell. Data is also traced to the Output panel.
*
* @ USAGE: Run DebugIt Receiver at the same time you run your application. Any data returned by Debug.write()
* calls displays in DebugIt Receiver.
*  
*/
// Import component control classes
import mx.controls.Button;
import mx.controls.TextArea;

// Set up Stage alignment and scaling
Stage.scaleMode = "noScale";
Stage.align = "TL";
Stage.showMenu = false;

// Instantiate components and versionID clip
var txt:TextArea;
var clearBtn:Button;
var versionID:MovieClip;

// Set color for btn text
clearBtn.setStyle("color", 0x445567);

// Set global styles
function setStyles():Void {
	_global.style.setStyle("themeColor", 0xcccccc);
	_global.style.setStyle("color", 0x435661);
	_global.style.setStyle("textRollOverColor", 0x435661);
	_global.style.setStyle("textSelectedColor", 0x435661);
	_global.style.setStyle("rollOverColor", 0xcccccc);
	_global.style.setStyle("selectionColor", 0xcccccc);
	_global.style.setStyle("fontFamily", "Verdana");
	_global.style.setStyle("fontSize", "11");
}
setStyles();


// Set up LocalConnection object
var lc:LocalConnection = new LocalConnection();
lc.allowDomain = function() {
	return true;
}
lc.write = function(arguments) {
	write(arguments);
};
function write(arguments) {
	for (var i = 0; i<arguments.length; i++) {
		txt.text += arguments[i]+"\n";
	}
}
lc.connect("_debugIt");

// Use Clear btn to clear all text
clearBtn.onRelease = function() {
	txt.text = "";
}

// Use btn instance as link to IA web site
btn.onRelease = function(){
	getURL("http://www.interactivealchemy.com", "_blank");
}

// Resize events
var resizeListener:Object = new Object();
resizeListener.onResize = function() {
	//title._x = (Stage.width - title._width) - 5;
	logo._y = (Stage.height - title._height) - 15;
	btn._y = (Stage.height - title._height) - 15;
	txt.setSize(Stage.width-10, Stage.height-60);
	clearBtn.move(Stage.width-105, Stage.height-26);
	boxes._x = Stage.width-79;
}
Stage.addListener(resizeListener);
