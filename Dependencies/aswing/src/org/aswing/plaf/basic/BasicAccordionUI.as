﻿/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.geom.Dimension;
import org.aswing.Insets;
import org.aswing.JAccordion;
import org.aswing.LookAndFeel;
import org.aswing.plaf.AccordionUI;
import org.aswing.plaf.basic.accordion.AccordionHeader;
import org.aswing.plaf.basic.accordion.BasicAccordionHeader;
import org.aswing.util.Timer;

/**
 *
 * @author iiley
 */
class org.aswing.plaf.basic.BasicAccordionUI extends AccordionUI{
	
	private static var MOTION_SPEED:Number = 50;
	private static var MOTION_CYCLE:Number = 40;  
	
	private var accordion:JAccordion;
	private var headers:Array;
	private var stateListener:Object;
	private var keyListener:Object;
	private var focusListener:Object;
	//make sure accordion header component destroy get called since it is not append to 
	//accordion's children array
	private var destroyListener:Object;
	private var motionTimer:Timer;
	private var headerDestinations:Array;
	private var childrenDestinations:Array;
	
	public function BasicAccordionUI() {
		super();
	}
    	
    public function installUI(c:Component):Void{
    	headers = new Array();
		accordion = JAccordion(c);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public function uninstallUI(c:Component):Void{
		accordion = JAccordion(c);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
	
	private function installDefaults():Void{
		var pp:String = "Accordion.";
        LookAndFeel.installBorder(accordion, pp + "border");
        LookAndFeel.installColorsAndFont(accordion, pp + "background", pp + "foreground", pp + "font");
        LookAndFeel.installBasicProperties(accordion, pp);
	}
    
    private function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorder(accordion);
    }
    
	private function installComponents():Void{
		__synTabs();
    }
	private function uninstallComponents():Void{
		for(var i:Number=0; i<headers.length; i++){
			getHeader(i).getComponent().destroy();
		}
		headers.splice(0);
    }
	
	private function installListeners():Void{
		stateListener = accordion.addEventListener(Component.ON_STATE_CHANGED, __selectionChanged, this);
		keyListener = accordion.addEventListener(Component.ON_KEY_DOWN, __keyDown, this);
		focusListener = accordion.addEventListener(Component.ON_FOCUS_LOST, __onFocusLost, this);
		destroyListener = accordion.addEventListener(Component.ON_DESTROY, __onDestroy, this);
		motionTimer = new Timer(MOTION_CYCLE);
		motionTimer.addActionListener(__motion, this);
	}
    
    private function uninstallListeners():Void{
    	accordion.removeEventListener(stateListener);
    	accordion.removeEventListener(keyListener);
    	accordion.removeEventListener(focusListener);
    	accordion.removeEventListener(destroyListener);
    	motionTimer.stop();
    }
    
    /**
     * Just override this method if you want other LAF headers.
     */
    private function createNewHeader():AccordionHeader{
    	var header:AccordionHeader = new BasicAccordionHeader();
    	header.getComponent().setFocusable(false);
    	return header;
    }
    
    public function paintFocus(c:Component):Void{
    	clearAllHeaderFocusGraphics();
    	c.clearFocusGraphics();
    	var selectedHeader:AccordionHeader = getSelectedHeader();
    	if(selectedHeader != null){
    		paintHeaderFocus(selectedHeader.getComponent());
    	}else{
    		super.paintFocus(c);
    	}
    }
	public function clearFocus(c:Component):Void{
		super.clearFocus(c);
		clearAllHeaderFocusGraphics();
	}    
    
    private function paintHeaderFocus(headerComponent:Component):Void{
    	super.paintFocus(headerComponent);
    }
    
    private function __keyDown():Void{
    	if(headers.length > 0){
	    	if(Key.getCode() == Key.DOWN){
		    	var index:Number = accordion.getSelectedIndex();
		    	index++;
		    	if(index >= accordion.getComponentCount()){
		    		index = 0;
		    	}
		    	accordion.setSelectedIndex(index);
	    	}else if(Key.getCode() == Key.UP){
		    	var index:Number = accordion.getSelectedIndex();
		    	index--;
		    	if(index < 0){
		    		index = accordion.getComponentCount()-1;
		    	}
		    	accordion.setSelectedIndex(index);
	    	}
    	}
    }
    private function __onFocusLost():Void{
    	clearAllHeaderFocusGraphics();
    }
    private function clearAllHeaderFocusGraphics():Void{
    	for(var i:Number=0; i<headers.length; i++){
    		var header:AccordionHeader = AccordionHeader(headers[i]);
    		header.getComponent().clearFocusGraphics();
    	}
    }
    
    private function __synTabs():Void{
    	var comCount:Number = accordion.getComponentCount();
    	if(comCount != headers.length){
    		if(comCount > headers.length){
    			for(var i:Number = headers.length; i<comCount; i++){
    				var header:AccordionHeader = createNewHeader();
    				header.setTextAndIcon(accordion.getTitleAt(i), accordion.getIconAt(i));
    				header.getComponent().setToolTipText(accordion.getTipAt(i));
    				header.getComponent().addEventListener(Component.ON_RELEASE, __tabReleased, this);
    				header.getComponent().addEventListener(Component.ON_PRESS, __tabPressed, this);
    				header.getComponent().addTo(accordion);
    				headers.push(header);
    			}
    		}else{
    			for(var i:Number = headers.length-comCount; i>0; i--){
    				var header:AccordionHeader = AccordionHeader(headers.pop());
    				header.getComponent().destroy();
    			}
    		}
    	}
    }
    
    private function __ensureHeadersDisplayable():Void{
    	for(var i:Number=0; i<headers.length; i++){
    		var header:AccordionHeader = getHeader(i);
    		header.setTextAndIcon(accordion.getTitleAt(i), accordion.getIconAt(i));
    		header.getComponent().setToolTipText(accordion.getTipAt(i));
    		if(!header.getComponent().isDisplayable()){
    			header.getComponent().addTo(accordion);
    		}
    	}
    }
    
    private function __ensureHeadersOnTopDepths():Void{
    	if(accordion.getComponentCount()<=0){
    		return;
    	}
    	var firstComDepth:Number = accordion.getComponent(0).getDepth();
    	if(firstComDepth == undefined){
    		return;
    	}
    	
    	for(var i:Number=0; i<headers.length; i++){
    		var header:AccordionHeader = getHeader(i);
    		//move all header above accordion child components
    		if(header.getComponent().isDisplayable()){
    			var needDepth:Number = firstComDepth + headers.length + i;
	    		if(header.getComponent().getDepth() != needDepth){
	    			header.getComponent().swapDepths(needDepth);
	    			//trace("header depth to : " + needDepth);
	    		}
    		}
    	}
    }
    
	//make sure accordion header component destroy get called since it is not append to 
	//accordion's children array
    private function __onDestroy():Void{
    	for(var i:Number=0; i<headers.length; i++){
    		getHeader(i).getComponent().destroy();
    	}
    }
    
    public function create(c:Component):Void{
    	__ensureHeadersDisplayable();
    	__ensureHeadersOnTopDepths();
    }
        
    private function getHeader(i:Number):AccordionHeader{
    	return AccordionHeader(headers[i]);
    }
    private function getSelectedHeader():AccordionHeader{
    	if(accordion.getSelectedIndex() >= 0){
    		return getHeader(accordion.getSelectedIndex());
    	}else{
    		return null;
    	}
    }
    
    private function indexOfHeaderComponent(tab:Component):Number{
    	for(var i:Number=0; i<headers.length; i++){
    		if(getHeader(i).getComponent() == tab){
    			return i;
    		}
    	}
    	return -1;
    }
    
    private function __selectionChanged():Void{
    	accordion.revalidate();
    	accordion.repaint();
    }
    private function __tabReleased(source:Component):Void{
    	accordion.setSelectedIndex(indexOfHeaderComponent(source));
    }
    private function __tabPressed():Void{
    	accordion.requestFocus();
    }
	
	//---------------------------------------------------------------
	
    /**
     * may need override in subclass
     */
    public function addLayoutComponent(comp:Component, constraints:Object):Void{
    	__synTabs();
    }

    /**
     * may need override in subclass
     */
    public function removeLayoutComponent(comp:Component):Void{
    	__synTabs();
    }
	
	/**
     * may need override in subclass
	 */
    public function preferredLayoutSize(target:Container):Dimension{
    	if(target === accordion){
	    	var insets:Insets = accordion.getInsets();
	    	
	    	var w:Number = 0;
	    	var h:Number = 0;
	    	
	    	for(var i:Number=accordion.getComponentCount()-1; i>=0; i--){
	    		var size:Dimension = accordion.getComponent(i).getPreferredSize();
	    		w = Math.max(w, size.width);
	    		h = Math.max(h, size.height);
	    	}
	    	
	    	for(var i:Number=accordion.getComponentCount()-1; i>=0; i--){
	    		var size:Dimension = getHeader(i).getComponent().getPreferredSize();
	    		w = Math.max(w, size.width);
	    		h += size.height;
	    	}
	    	
	    	return insets.roundsSize(new Dimension(w, h));
    	}
    	return null;
    }

	/**
     * may need override in subclass
	 */
    public function minimumLayoutSize(target:Container):Dimension{
    	if(target === accordion){
	    	var insets:Insets = accordion.getInsets();
	    	
	    	var w:Number = 0;
	    	var h:Number = 0;
	    	
	    	for(var i:Number=accordion.getComponentCount()-1; i>=0; i--){
	    		var size:Dimension = accordion.getComponent(i).getMinimumSize();
	    		w = Math.max(w, size.width);
	    	}
	    	
	    	for(var i:Number=accordion.getComponentCount()-1; i>=0; i--){
	    		var size:Dimension = getHeader(i).getComponent().getMinimumSize();
	    		w = Math.max(w, size.width);
	    		h += size.height;
	    	}
	    	
	    	return insets.roundsSize(new Dimension(w, h));
    	}
    	return null;
    }
    
    private function __motion():Void{
    	var isFinished:Boolean = true;
    	var n:Number = headerDestinations.length;
    	var selected:Number = accordion.getSelectedIndex();
    	
    	for(var i:Number=0; i<n; i++){
    		var header:AccordionHeader = getHeader(i);
    		var tab:Component = header.getComponent();
    		var curY:Number = tab.getY();
    		var desY:Number = headerDestinations[i];
    		var toY:Number;
    		if(Math.abs(desY - curY) <= MOTION_SPEED){
    			toY = desY;
    		}else{
    			if(desY > curY){
    				toY = curY + MOTION_SPEED;
    			}else{
    				toY = curY - MOTION_SPEED;
    			}
    			isFinished = false;
    		}
    		tab.setLocation(tab.getX(), toY);
    		tab.validate();
    		var child:Component = accordion.getComponent(i);
    		child.setLocation(child.getX(), toY + tab.getHeight());
    		child.validate();
    	}
    	
    	if(isFinished){
    		motionTimer.stop();
    		for(var i:Number=0; i<n; i++){
	    		var child:Component = accordion.getComponent(i);
	    		if(selected == i){
	    			child.setVisible(true);
	    		}else{
	    			child.setVisible(false);
	    		}
    		}
    	}
    	updateAfterEvent();
    }
    
    /**
     * may need override in subclass
     */
    public function layoutContainer(target:Container):Void{
    	var insets:Insets = accordion.getInsets();
    	var x:Number = insets.left;
    	var y:Number = insets.top;
    	var w:Number = accordion.getWidth() - x - insets.right;
    	var h:Number = accordion.getHeight() - y - insets.bottom;
    	
    	var count:Number = accordion.getComponentCount();
    	var selected:Number = accordion.getSelectedIndex();
    	if(selected < 0){
    		return;
    	}
    	
    	headerDestinations = new Array(count);
    	
    	var vX:Number, vY:Number, vWidth:Number, vHeight:Number;
    	vHeight = h;
    	vWidth = w;
    	vX = x;
    	for(var i:Number=0; i<=selected; i++){
    		var header:AccordionHeader = getHeader(i);
    		var tab:Component = header.getComponent();
    		var size:Dimension = tab.getPreferredSize();
    		tab.setSize(w, size.height);
    		tab.setLocation(x, tab.getY());
    		accordion.getComponent(i).setLocation(x, tab.getY()+size.height);
    		headerDestinations[i] = y;
    		y += size.height;
    		vHeight -= size.height;
    		if(i == selected){
    			header.setSelected(true);
    			accordion.getComponent(i).setVisible(true);
    		}else{
    			header.setSelected(false);
    		}
    		tab.validate();
    	}
    	vY = y;
    	
    	y = accordion.getHeight() - insets.bottom;
    	for(var i:Number=count-1; i>selected; i--){
    		var header:AccordionHeader = getHeader(i);
    		var tab:Component = header.getComponent();
    		var size:Dimension = tab.getPreferredSize();
    		y -= size.height;
    		headerDestinations[i] = y;
    		tab.setSize(w, size.height);
    		tab.setLocation(x, tab.getY());
    		accordion.getComponent(i).setLocation(x, tab.getY()+size.height);
    		header.setSelected(false);
    		vHeight -= size.height;
    		tab.validate();
    	}
    	for(var i:Number=0; i<count; i++){
    		accordion.getComponent(i).setSize(vWidth, vHeight);
    	}
    	motionTimer.restart();
    	__ensureHeadersOnTopDepths();
    }
}
