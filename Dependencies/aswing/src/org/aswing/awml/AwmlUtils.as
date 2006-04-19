/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.awml.AwmlConstants;

/**
 * Provides utility routines for AWML parser.
 * 
 * @author Igor Sadovskiy
 */
class org.aswing.awml.AwmlUtils {
	
	/**
	 * Extracts pure node name from the passed XML element omitting namespace prefix.
	 * 
	 * @param xml the <code>XMLNode</code> to extract node name from
	 * @return extracted node name
	 */
	public static function getNodeName(xml:XMLNode):String {
		var idx:Number = xml.nodeName.indexOf(":");
		return (idx == -1) ? xml.nodeName : xml.nodeName.substr(idx + 1);
	}
	
	/**
	 * Checks if passed <code>nodeName</code> belongs to component.
	 * 
	 * @param nodeName the node name to check
	 * @return <code>true</code> if belongs and <code>false</code> if not
	 */
	public static function isComponentNode(nodeName:String):Boolean {
		return (nodeName == AwmlConstants.NODE_TEXT_AREA ||
			nodeName == AwmlConstants.NODE_TEXT_FIELD ||
			nodeName == AwmlConstants.NODE_SEPARATOR ||
			nodeName == AwmlConstants.NODE_PROGRESS_BAR ||
			nodeName == AwmlConstants.NODE_LABEL ||
			nodeName == AwmlConstants.NODE_BUTTON ||
			nodeName == AwmlConstants.NODE_TOGGLE_BUTTON ||
			nodeName == AwmlConstants.NODE_CHECK_BOX ||
			nodeName == AwmlConstants.NODE_RADIO_BUTTON ||
			nodeName == AwmlConstants.NODE_PANEL ||
			nodeName == AwmlConstants.NODE_BOX ||
			nodeName == AwmlConstants.NODE_SOFT_BOX ||
			nodeName == AwmlConstants.NODE_TOOL_BAR ||
			nodeName == AwmlConstants.NODE_SCROLL_BAR ||
			nodeName == AwmlConstants.NODE_LIST ||
			nodeName == AwmlConstants.NODE_COMBO_BOX ||
			nodeName == AwmlConstants.NODE_ACCORDION ||
			nodeName == AwmlConstants.NODE_TABBED_PANE ||
			nodeName == AwmlConstants.NODE_LOAD_PANE ||
			nodeName == AwmlConstants.NODE_ATTACH_PANE ||
			nodeName == AwmlConstants.NODE_SCROLL_PANE ||
			nodeName == AwmlConstants.NODE_VIEW_PORT);
	}
	
	/**
	 * Checks if passed <code>nodeName</code> belongs to border.
	 * 
	 * @param nodeName the node name to check
	 * @return <code>true</code> if belongs and <code>false</code> if not
	 */
	public static function isBorderNode(nodeName:String):Boolean {
		return (nodeName == AwmlConstants.NODE_BEVEL_BORDER ||
			nodeName == AwmlConstants.NODE_EMPTY_BORDER ||
			nodeName == AwmlConstants.NODE_LINE_BORDER ||
			nodeName == AwmlConstants.NODE_SIDE_LINE_BORDER ||
			nodeName == AwmlConstants.NODE_TITLED_BORDER ||
			nodeName == AwmlConstants.NODE_SIMPLE_TITLED_BORDER);
	} 

	/**
	 * Checks if passed <code>nodeName</code> belongs to layout.
	 * 
	 * @param nodeName the node name to check
	 * @return <code>true</code> if belongs and <code>false</code> if not
	 */
	public static function isLayoutNode(nodeName:String):Boolean {
		return (nodeName == AwmlConstants.NODE_EMPTY_LAYOUT ||
			nodeName == AwmlConstants.NODE_FLOW_LAYOUT ||
			nodeName == AwmlConstants.NODE_SOFT_BOX_LAYOUT ||
			nodeName == AwmlConstants.NODE_GRID_LAYOUT ||
			nodeName == AwmlConstants.NODE_BOX_LAYOUT ||
			nodeName == AwmlConstants.NODE_BORDER_LAYOUT);
	} 

	/**
	 * Checks if passed <code>nodeName</code> belongs to icon.
	 * 
	 * @param nodeName the node name to check
	 * @return <code>true</code> if belongs and <code>false</code> if not
	 */
	public static function isIconNode(nodeName:String):Boolean {
		return (nodeName == AwmlConstants.NODE_ATTACH_ICON ||
			nodeName == AwmlConstants.NODE_LOAD_ICON ||
			nodeName == AwmlConstants.NODE_OFFSET_ICON);
	} 

	/**
	 * Checks if passed <code>nodeName</code> belongs to icon wrapper.
	 * 
	 * @param nodeName the node name to check
	 * @return <code>true</code> if belongs and <code>false</code> if not
	 */
	public static function isIconWrapperNode(nodeName:String):Boolean {
		return (nodeName == AwmlConstants.NODE_ICON ||
			nodeName == AwmlConstants.NODE_SELECTED_ICON ||
			nodeName == AwmlConstants.NODE_PRESSED_ICON ||
			nodeName == AwmlConstants.NODE_DISABLED_ICON ||
			nodeName == AwmlConstants.NODE_DISABLED_SELECTED_ICON ||
			nodeName == AwmlConstants.NODE_ROLL_OVER_ICON ||
			nodeName == AwmlConstants.NODE_ROLL_OVER_SELECTED_ICON);
	} 
	 
}