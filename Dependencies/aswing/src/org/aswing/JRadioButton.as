﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;

/**
 * An implementation of a radio button -- an item that can be selected or
 * deselected, and which displays its state to the user.
 * Used with a {@link ButtonGroup} object to create a group of buttons
 * in which only one button at a time can be selected. (Create a ButtonGroup
 * object and use its <code>append</code> method to include the JRadioButton objects
 * in the group.)
 * <blockquote>
 * <strong>Note:</strong>
 * The ButtonGroup object is a logical grouping -- not a physical grouping.
 * Tocreate a button panel, you should still create a {@link JPanel} or similar
 * container-object and add a {@link org.aswing.border.Border} to it to set it off from surrounding
 * components.
 * </blockquote>
 * @author iiley
 */
class org.aswing.JRadioButton extends JToggleButton{
	
	public function JRadioButton(text:String, icon:Icon) {
		super(text, icon);
		setName("JRadioButton");
		updateUI();
	}
    
	public function getUIClassID():String{
		return "RadioButtonUI";
	}
}
