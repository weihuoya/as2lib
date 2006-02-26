/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.Icon;
import org.aswing.LayoutManager;
import org.aswing.plaf.AccordionUI;
import org.aswing.UIManager;
import org.aswing.util.ArrayUtils;
import org.aswing.util.StringUtils;

/**
 * Accordion Container.
 * @author iiley
 */
class org.aswing.JAccordion extends Container {
	public static var ON_STATE_CHANGED:String = "onStateChanged";		
		
    private var titles:Array;
    private var icons:Array;
    private var tips:Array;
    
    private var selectedIndex:Number;
    
    /**
     * JAccordion()
     * <p>
     */
	public function JAccordion() {
		super();
		setName("JAccordion");
		titles = new Array();
		icons = new Array();
		tips = new Array();
		
		selectedIndex = -1;
		
		updateUI();
	}
	
    public function updateUI():Void{
    	setUI(AccordionUI(UIManager.getUI(this)));
    	setLayout(getUI());
    }
    
    public function setUI(newUI:AccordionUI):Void{
    	super.setUI(newUI);
    }
    
    public function getUI():AccordionUI{
    	return AccordionUI(ui);
    }
	
	public function getUIClassID():String{
		return "AccordionUI";
	}
	
	/**
	 * Generally you should not set layout to JAccordion.
	 * @param layout layoutManager for JAccordion
	 * @throws Error when you set a non-AccordionUI layout to JAccordion.
	 */
	public function setLayout(layout:LayoutManager):Void{
		if(layout instanceof AccordionUI){
			super.setLayout(layout);
		}else{
			trace("Cannot set non-AccordionUI layout to JAccordion!");
			throw Error("Cannot set non-AccordionUI layout to JAccordion!");
		}
	}
		
	/**
	 * Adds a component to the accordion. 
	 * If constraints is a String or an Icon or an Object(object.toString() as a title), 
	 * it will be used for the tab title, 
	 * otherwise the component's name will be used as the tab title. 
	 * Shortcut of <code>insert(-1, com, constraints)</code>. 
	 * @param com  the component to be displayed when this tab is clicked
	 * @param constraints  the object to be displayed in the tab
	 * @see Container#append()
	 * @see #insert()
	 * @see #insertTab()
	 */
	public function append(com:Component, constraints:Object):Void{
		insert(-1, com, constraints);
	}
	
	/**
	 * Adds a component to the accordion with spesified index.
	 * If constraints is a String or an Icon or an Object(object.toString() as a title), 
	 * it will be used for the tab title, 
	 * otherwise the component's name will be used as the tab title. 
	 * Cover method for insertTab. 
	 * @param i index the position at which to insert the component, or less than 0 value to append the component to the end 
	 * @param com the component to be added
	 * @param constraints the object to be displayed in the tab
	 * @see Container#insert()
	 * @see #insertTab()
	 */
	public function insert(i:Number, com:Component, constraints:Object):Void{
		var title:String = null;
		var icon:Icon = null;
		if(constraints == undefined){
			title = com.getName();
		}else if(StringUtils.isString(constraints)){
			title = String(constraints);
		}else if(constraints instanceof Icon){
			icon = Icon(constraints);
		}else{
			title = constraints.toString();
		}
		insertTab(i, com, title, icon, null);
	}
	
	/**
	 * Adds a component and tip represented by a title and/or icon, either of which can be null.
	 * Shortcut of <code>insertTab(-1, com, title, icon, tip)</code>
	 * @param com The component to be displayed when this tab is clicked
	 * @param title the title to be displayed in this tab
	 * @param icon the icon to be displayed in this tab
	 * @param tip the tooltip to be displayed for this tab, can be null means no tool tip.
	 */
	public function appendTab(com:Component, title:String, icon:Icon, tip:String):Void{
		insertTab(-1, com, title, icon, tip);
	}
	
	/**
	 * Inserts a component, at index, represented by a title and/or icon, 
	 * either of which may be null.
	 * @param i the index position to insert this new tab
	 * @param com The component to be displayed when this tab is clicked
	 * @param title the title to be displayed in this tab
	 * @param icon the icon to be displayed in this tab
	 * @param tip the tooltip to be displayed for this tab, can be null means no tool tip.
	 * @throws Error when index > children count
	 */
	public function insertTab(i:Number, com:Component, title:String, icon:Icon, tip:String):Void{
		if(i > getComponentCount()){
			trace("illegal component position when insert comp to container");
			throw new Error("illegal component position when insert comp to container");
		}
		insertToArray(titles, i, title);
		insertToArray(icons, i, icon);
		insertToArray(tips, i, tip);
		super.insert(i, com);
		if(selectedIndex < 0){
			setSelectedIndex(0);
		}
	}
	
	/**
	 * Removes the specified child component.
	 * After the component is removed, its visibility is reset to true to ensure it will be visible if added to other containers. 
	 * @param i the index of component, less than 0 mean the component in the end of children list.
	 * @return the component just removed, or null there is not component at this position.
	 */
	public function removeTabAt(i):Component{
		removeFromArray(titles, i);
		removeFromArray(icons, i);
		removeFromArray(tips, i);
		
		var rc:Component = super.removeAt(i);
		rc.setVisible(true);
		
		if(i < 0) i = getComponentCount();
		if(getComponentCount() > 0){
			setSelectedIndex(i);
		}else{
			selectedIndex = -1;
		}
		
		return rc;
	}
	
	/**
	 * Removes the specified child component.
	 * After the component is removed, its visibility is reset to true to ensure it will be visible if added to other containers. 
	 * 
	 * Cover method for removeTabAt. 
	 * @see Container#remove()
	 * @see #removeTabAt()
	 */
	public function remove(com:Component):Component{
		var index:Number = getIndex(com);
		return removeAt(index);
	}
	
	/**
	 * Removes the specified index child component. 
	 * After the component associated with index is removed, its visibility is reset to true to ensure it will be visible if added to other containers.
	 * Cover method for removeTabAt. 
	 * @see #removeTabAt() 
	 * @see Container#removeAt()
	 */	
	public function removeAt(index:Number):Component{
		return removeTabAt(index);
	}
	
	/**
	 * Remove all child components.
	 * After the component is removed, its visibility is reset to true to ensure it will be visible if added to other containers. 
	 * @see #removeAt()
	 * @see #removeTabAt()
	 * @see Container#removeAll()
	 */
	public function removeAll():Void{
		while(children.length > 0){
			removeAt(children.length - 1);
		}
	}
	
	/**
	 * Returns the count of tabs.
	 */
	public function getTabCount():Number{
		return getComponentCount();
	}
	
	/**
	 * Returns the tab title at specified index. 
	 * @param i the index
	 * @return the tab title
	 */
	public function getTitleAt(i:Number):String{
		return titles[i];//StringUtils.castString(titles[i]);
	}
	
	/**
	 * Returns the tab icon at specified index. 
	 * @param i the index
	 * @return the tab icon
	 */	
	public function getIconAt(i:Number):Icon{
		return Icon(icons[i]);
	}
	
	/**
	 * Returns the tab tool tip text at specified index. 
	 * @param i the index
	 * @return the tab tool tip text
	 */	
	public function getTipAt(i:Number):String{
		return tips[i];//StringUtils.castString(tips[i]);
	}
	
	/**
	 * Returns the first tab index with a given title, or -1 if no tab has this title. 
	 * @param title the title for the tab 
	 * @return the first tab index which matches title, or -1 if no tab has this title
	 */
	public function indexOfTitle(title:String):Number{
		return ArrayUtils.indexInArray(titles, title);
	}
	
	/**
	 * Returns the first tab index with a given icon, or -1 if no tab has this icon. 
	 * @param title the title for the tab 
	 * @return the first tab index which matches icon, or -1 if no tab has this icon
	 */	
	public function indexOfIcon(icon:Icon):Number{
		return ArrayUtils.indexInArray(icons, icon);
	}
	
	/**
	 * Returns the first tab index with a given tip, or -1 if no tab has this tip. 
	 * @param title the title for the tab 
	 * @return the first tab index which matches tip, or -1 if no tab has this tip
	 */		
	public function indexOfTip(tip:String):Number{
		return ArrayUtils.indexInArray(tips, tip);
	}
	
	public function setSelectedIndex(i:Number):Void{
		if(i>=0 && i<getComponentCount() && i != selectedIndex){
			selectedIndex = i;
		}
		fireStateChanged();
	}
	
	public function setSelectedComponent(com:Component):Void{
		setSelectedIndex(getIndex(com));
	}
	
	public function getSelectedIndex():Number{
		return selectedIndex;
	}
	
	public function getSelectedComponent():Component{
		if(selectedIndex >= 0){
			return getComponent(selectedIndex);
		}
		return null;
	}
    
    //----------------------------------------------------------------
    
	private function insertToArray(arr:Array, i:Number, obj:Object):Void{
		if(i < 0){
			arr.push(obj);
		}else{
			arr.splice(i, 0, obj);
		}
	}	
	
	private function removeFromArray(arr:Array, i:Number):Void{
		if(i < 0){
			arr.pop();
		}else{
			arr.splice(i, 1);
		}
	}    
}
