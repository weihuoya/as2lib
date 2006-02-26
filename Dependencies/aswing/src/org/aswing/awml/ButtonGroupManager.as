/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.AbstractButton;
import org.aswing.util.HashMap;
import org.aswing.ButtonGroup;

/**
 * Allows to manage button groups using global group name values.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.ButtonGroupManager {
	
	/**
	 * Stores associations between @link org.aswing.ButtonGroup and
	 * its names.
	 */
	private static var groups:HashMap = new HashMap();
	
	/**
	 * Private Constructor.
	 */
	private function ButtonGroupManager(Void) {
		//
	}	
	
	/**
	 * Appends button to the existed group with the specified name. If group with
	 * the specified name doesn't exist manager creates it. 
	 * 
	 * @param groupName the name of the button group
	 * @param button the button to add to the specified group
	 */
	public static function append(groupName:String, button:AbstractButton):Void {
		
		if (groupName == null) return;
		var group:ButtonGroup = groups.get(groupName);
		
		if (group == null) {
			group = new ButtonGroup();	
			groups.put(groupName, group);
		}
		
		group.append(button);
	}
	
	/**
	 * Removes button from the specified group. 
	 * 
	 * @param groupName the name of the button group to remove button from
	 * @param button the button to remove from the specified group
	 */
	public static function remove(groupName:String, button:AbstractButton):Void {
		var group:ButtonGroup = groups.get(groupName);
		
		if (group != null) {
			group.remove(button);
			
			// if button group is empty purge group
			if (group.getButtonCount() == 0) {
				groups.remove(groupName);
				delete group;	
			}	
		}
	}
}