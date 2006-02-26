/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.*;
import org.aswing.plaf.*;
import org.aswing.plaf.basic.*;
 
/**
 *
 * @author iiley
 */
class org.aswing.plaf.asw.ASWingLookAndFeel extends BasicLookAndFeel{
	
	
	public function ASWingLookAndFeel(){
		super();
	}
	
	private function initClassDefaults(table:UIDefaults):Void{
		super.initClassDefaults(table);
		
		var uiDefaults:Array = [
			   "ButtonUI", org.aswing.plaf.asw.ASWingButtonUI,
			   "PanelUI", org.aswing.plaf.asw.ASWingPanelUI,
			   "ToggleButtonUI", org.aswing.plaf.asw.ASWingToggleButtonUI,
			   "RadioButtonUI", org.aswing.plaf.asw.ASWingRadioButtonUI,
			   "CheckBoxUI", org.aswing.plaf.asw.ASWingCheckBoxUI,
			   "FrameUI", org.aswing.plaf.asw.ASWingFrameUI
			   ];
		table.putDefaults(uiDefaults);
	}

	
	private function initComponentDefaults(table:UIDefaults):Void{
		super.initComponentDefaults(table);
	   // *** JButton
	    var comDefaults:Array = [
	    "Button.background", new ASColorUIResource(0xE7E7E5),
		    "Button.border", org.aswing.plaf.asw.border.ButtonBorder];
	    table.putDefaults(comDefaults);
	    
	    // *** ToggleButton
	    comDefaults = [
		    "ToggleButton.border", org.aswing.plaf.asw.border.ButtonBorder];
	    table.putDefaults(comDefaults);
	    
	    // *** RadioButton
	    comDefaults = [
		    "RadioButton.icon", org.aswing.plaf.asw.icon.RadioButtonIcon];
	    table.putDefaults(comDefaults);	    
	    	    
	    // *** CheckBox
	    comDefaults = [
		    "CheckBox.icon", org.aswing.plaf.asw.icon.CheckBoxIcon];
	    table.putDefaults(comDefaults);
	    
	    // *** ScrollBar
	    
	    // *** Panel
	    
	    
	   
	    // *** Frame
	    comDefaults = [	   
	    "Frame.titleBarUI", org.aswing.plaf.asw.frame.ASWingTitleBarUI,
	    "Frame.border", org.aswing.plaf.asw.border.FrameBorder	   
	    ];
	    table.putDefaults(comDefaults);
	}
	
	
}
