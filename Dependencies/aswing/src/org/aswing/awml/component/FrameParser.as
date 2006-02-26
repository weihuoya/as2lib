﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.component.WindowParser;
import org.aswing.JFrame;

/**
 * Parses {@link org.aswing.JFrame} level elements.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.component.FrameParser extends WindowParser {
	
	private static var ATTR_CLOSABLE:String = "closable";
	private static var ATTR_DRAGGABLE:String = "draggable";
	private static var ATTR_RESIZABLE:String = "resizable";
	private static var ATTR_TITLE:String = "title";
	private static var ATTR_STATE:String = "state";
	
	private static var STATE_NORMAL:String = "normal";
	private static var STATE_ICONIFIED:String = "iconified";
	private static var STATE_MAXIMIZED:String = "maximized";
	
	/**
	 * Constructor.
	 */
	public function FrameParser(Void) {
		super();
	}
	
	public function parse(awml:XMLNode, frame:JFrame):JFrame {
		if (frame == null) {
			// TODO add owner-id support
			var owner = evalOwner(getAttributeAsString(awml, ATTR_OWNER));
			frame = new JFrame(owner);	
		}
		
		super.parse(awml, frame);
		
		// TODO add icon support
		// TODO add maximized bounds support
		
		// init closable
		frame.setClosable(getAttributeAsBoolean(awml, ATTR_CLOSABLE, frame.isClosable()));
		
		// init draggable
		frame.setDragable(getAttributeAsBoolean(awml, ATTR_DRAGGABLE, frame.isDragable()));
		
		// init resizable
		frame.setResizable(getAttributeAsBoolean(awml, ATTR_RESIZABLE, frame.isResizable()));
		
		// init title
		frame.setTitle(getAttributeAsString(awml, ATTR_TITLE, frame.getTitle()));
		
		// init state
		var state:String = getAttributeAsString(awml, ATTR_STATE);
		switch (state) {
			case STATE_ICONIFIED:
				frame.setState(JFrame.ICONIFIED);
				break;
			case STATE_MAXIMIZED:
				frame.setState(JFrame.MAXIMIZED);
				break;
			case STATE_NORMAL:
				frame.setState(JFrame.NORMAL);
				break;
		} 
		
		return frame;
	}
	
}
