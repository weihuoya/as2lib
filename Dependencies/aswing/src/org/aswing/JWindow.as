/*
 Copyright aswing.org, see the LICENCE.txt.
*/

import org.aswing.ASWingUtils;
import org.aswing.BorderLayout;
import org.aswing.Component;
import org.aswing.Container;
import org.aswing.FocusManager;
import org.aswing.geom.Dimension;
import org.aswing.geom.Point;
import org.aswing.LayoutManager;
import org.aswing.MCPanel;
import org.aswing.plaf.WindowUI;
import org.aswing.UIManager;
import org.aswing.util.Delegate;
import org.aswing.util.DepthManager;
import org.aswing.util.MCUtils;
import org.aswing.util.Vector;
import org.aswing.WindowLayout;

/**
 * JWindow is a Container, but you should not add component to JWindow directly,
 * you should add component like this:<br>
 * <pre>
 * 		jwindow.getContentPane().append(child);
 * </pre>
 * <p>The same is true of setting LayoutManagers, removing components, listing children, etc.
 * All these methods should normally be sent to the contentPane instead of the JWindow itself. 
 * The contentPane will always be non-null. Attempting to set it to null will cause the JWindow to throw an Error. 
 * The default contentPane will have a BorderLayout manager set on it. 
 * 
 * <p>But if you really want to add child to JWindow like how JDialog and JFrame does,
 * just do it, normally if you want to extends JWindow to make a new type Window, you may
 * need to add child to JWindow, example a title bar on top, a menubar on top, a status bar on bottom, etc.
 * 
 * @author iiley
 */
class org.aswing.JWindow extends Container{
	/**
	 * The window-activated event type.
	 * onWindowActived(source:JWindow)
	 */	
	public static var ON_WINDOW_ACTIVATED:String = "onWindowActived";
	/**
	 * The window-deactivated event type.
	 * onWindowDeactived(source:JWindow)
	 */
	public static var ON_WINDOW_DEACTIVATED:String = "onWindowDeactived";
	/**
	 * The window closed event means that When a window was opened.
	 * onWindowOpened(source:JWindow)
	 */	
	public static var ON_WINDOW_OPENED:String = "onWindowOpened";		
	/**
	 * The window opened event means that When a window was disposed or hiden.
	 * onWindowClosed(source:JWindow)
	 */	
	public static var ON_WINDOW_CLOSED:String = "onWindowClosed";	
	/**
	 * The "window is closing" event.
	 * onWindowClosing(source:JWindow)
	 */	
	public static var ON_WINDOW_CLOSING:String = "onWindowClosing";
	/**
	 * The window iconified event.
	 * onWindowIconified(source:JWindow)
	 * @see org.aswing.JFrame#ICONIFIED
	 * @see org.aswing.JFrame#setState()
	 */	
	public static var ON_WINDOW_ICONIFIED:String = "onWindowIconified";
	/**
	 * The window restored event, (the JFrame normal button pushed).
	 * onWindowRestored(source:JWindow)
	 * @see org.aswing.JFrame#NORMAL
	 * @see org.aswing.JFrame#setState()
	 */
	public static var ON_WINDOW_RESTORED:String = "onWindowRestored";
	/**
	 * The window maximized event.
	 * onWindowMaximized(source:JWindow)
	 * @see org.aswing.JFrame#MAXIMIZED
	 * @see org.aswing.JFrame#setState()
	 */
	public static var ON_WINDOW_MAXIMIZED:String = "onWindowMaximized";	
	
	private static var windows:Vector;
	
	private var ground_mc:MovieClip;
	
	private var contentPane:Container;
	private var owner:Object;
	private var modal:Boolean;
	private var actived:Boolean;
	private var modalMC:MovieClip;
	
	private var lootActiveFrom:JWindow;
	private var listenerToOwner:Object;
	
	private var lastLAF:Object;
	
	/**
	 * Create a JWindow
	 * <br>
	 * JWindow(owner:JWindow, modal:Boolean)<br>
	 * JWindow(owner:MovieClip, modal:Boolean)<br>
	 * JWindow(owner:JWindow)<br>
	 * JWindow(owner:MovieClip)<br>
	 * JWindow()<br>
	 * 
	 * @param owner the owner of this window, it can be a MovieClip or a JWindow, default it is default 
	 * is <code>ASWingUtils.getRootMovieClip()</code>
	 * @param modal true for a modal dialog, false for one that allows other windows to be active at the same time,
	 *  default is false.
	 * @see org.aswing.ASWingUtils#getRootMovieClip()
	 */
	public function JWindow(owner, modal:Boolean){
		super();
		setName("JWindow");
		this.owner = (owner == undefined ? ASWingUtils.getRootMovieClip() : owner);
		this.modal = (modal == undefined ? false : modal);
		visible = false;
		actived = false;
		layout = new WindowLayout();
		addEventListener(ON_MOVED, resetModalMC, this);
		listenerToOwner = new Object();
		listenerToOwner[ON_WINDOW_ICONIFIED] = Delegate.create(this, __ownerIconified);
		listenerToOwner[ON_WINDOW_RESTORED] = Delegate.create(this, __ownerRestored);
		listenerToOwner[ON_WINDOW_MAXIMIZED] = listenerToOwner[ON_WINDOW_RESTORED];
		
		updateUI();
		lastLAF = UIManager.getLookAndFeel();
	}
	
    public function updateUI():Void{
    	setUI(WindowUI(UIManager.getUI(this)));
    }
    
    public function setUI(newUI:WindowUI):Void{
    	super.setUI(newUI);
    }
	
	public function getUIClassID():String{
		return "WindowUI";
	}
	
	/**
	 * Sets the layout for the window.
	 * @throws Error when you try to set a non-WindowLayout instance.
	 */
	public function setLayout(layout:LayoutManager):Void{
		if(layout instanceof WindowLayout){
			super.setLayout(layout);
		}else{
			trace(this + " Can not set a non-WindowLayout Layout to JWindow");
			throw new Error(this + " Can not set a non-WindowLayout Layout to JWindow");
		}
	}
		
	/**
	 * Check size first to make sure current size is not min than <code>getMinimumSize</code>, 
	 */
	public function paintImmediately():Void{
		if(displayable && isVisible()){
			var minimizSize:Dimension = getMinimumSize();
			var needSize:Dimension = new Dimension(Math.max(getWidth(), minimizSize.width),
													Math.max(getHeight(), minimizSize.height));
			this.setSize(needSize);
			super.paintImmediately();
			revalidate();
		}else{
			super.paintImmediately();
		}
	}
		
	/**
	 * @return true always here.
	 */
	public function isValidateRoot():Boolean{
		return true;
	}
	
	/**
	 * Returns the content pane of this window.
	 * @return the content pane
	 */
	public function getContentPane():Container{
		if(contentPane == null){
			var p:Container = new Container();
			p.setFocusable(false);
			p.setLayout(new BorderLayout());
			setContentPaneImp(p);
		}
		return contentPane;
	}
	
	/**
	 * Sets the window's content pane.
	 * @param cp the content pane you want to set to the window.
	 * @throws Error when cp is null or undefined
	 */
	public function setContentPane(cp:Container):Void{
		if(cp != contentPane){
			if(cp == null){
				trace(this + " Can not set null to be JWindow's contentPane!");
				throw new Error(this + " Can not set null to be JWindow's contentPane!");
			}else{
				setContentPaneImp(cp);
			}
		}
	}
	
	private function setContentPaneImp(cp:Container):Void{
		contentPane.removeFromContainer();
		contentPane = cp;
		append(contentPane, WindowLayout.CONTENT);
	}
	
	/**
	 * This will return the owner of this JWindow, it maybe a MovieClip maybe a JWindow.
	 */
	public function getOwner():Object{
		return owner;
	}
	
	/**
	 * This will return the owner of this JWindow, it return a JWindow if
	 * this window's owner is a JWindow, else return null;
	 */
	public function getWindowOwner():JWindow{
		return JWindow(owner);
	}
	
	/**
	 * Specifies whether this dialog should be modal.
	 */
	public function setModal(m:Boolean):Void{
		if(modal != m){
			modal = m;
			modalMC._visible = modal;
		}
	}
	
	/**
	 * Returns is this dialog modal.
	 */
	public function isModal():Boolean{
		return modal;
	}	
	
	/**
	 * Return an array containing all the windows this window currently owns.
	 */
	public function getOwnedWindows():Array{
		return getOwnedWindowsWithOwner(this);
	}
			
	/**
	 * Shortcut of <code>setVisible(true)</code>
	 */
	public function show():Void{
		setVisible(true);
	}
	
	/**
	 * Shows or hides the Window. 
	 * <p>Shows the window when set visible true, If the Window and/or its owner are not yet displayable(and if Owner is a JWindow),
	 * both are made displayable. The Window will be made visible and bring to top;
	 * <p>Hides the window when set visible false, just hide the Window's MCs.
	 * @param v true to show the window, false to hide the window.
	 * @throws Error if the window has not a {@link JWindow} or <code>MovieClip</code> owner currently, 
	 * generally this should be never occur since the default owner is <code>_root</code>.
	 * @see #show()
	 * @see #hide()
	 */	
	public function setVisible(v:Boolean):Void{
		if(v != visible || (v && !MCUtils.isMovieClipExist(root_mc))){
			super.setVisible(v);
			
			if(v){
				if(!isDisplayable()){
					createWindowContents();
				}
				resetModalMC();
				dispatchEvent(createEventObj(ON_WINDOW_OPENED));
			}else{
				dispatchEvent(createEventObj(ON_WINDOW_CLOSED));
			}
		}
		if(v){
			toFront();
			setActive(true);
		}else{
			lostActiveAction();
		}
	}
	
	/**
	 * Shortcut of <code>setVisible(false)</code>
	 */
	public function hide():Void{
		setVisible(false);
	}
	
	/**
	 * Remove all of this window's source movieclips.(also the components in this window will be removed too)
	 */
	public function dispose():Void{
		visible = false;
		getWindowsVector().remove(this);
		getWindowOwner().removeEventListener(listenerToOwner);
		
		//dispose owned windows
		var owned:Array = getOwnedWindows();
		for(var i:Number=0; i<owned.length; i++){
			var w:JWindow = JWindow(owned[i]);
			w.dispose();
		}
		
		lostActiveAction();
		removeFromContainer();
		ground_mc.unloadMovie();
		ground_mc.removeMovieClip();
		ground_mc = null;
		dispatchEvent(createEventObj(ON_WINDOW_CLOSED));
	}
	
	/**
	 * Causes this Window to be sized to fit the preferred size and layouts of its subcomponents.
	 */
	public function pack():Void{
		setSize(getPreferredSize());
	}
	
	/**
	 * If this Window is visible, sends this Window to the back and may cause it to lose 
	 * focus or activation if it is the focused or active Window.
	 * <p>Infact this sends this JWindow to the back of all the MCs in its owner's MC
	 *  except it's owner's root_mc, it's owner is always below it.<br>
	 * @see #toFront()
	 */
	public function toBack():Void{
		if(displayable && visible){
			if(!DepthManager.isBottom(ground_mc, getOwnerRootMC())){
				DepthManager.bringToBottom(ground_mc, getOwnerRootMC());
			}
		}
	}
	
	/**
	 * If this Window is visible, brings this Window to the front and may make it the focused Window.
	 * <p>Infact this brings this JWindow to the front in his owner, all owner's MovieClips' front.
	 * @see #toBack()
	 */
	public function toFront():Void{
		if(displayable && visible){
			if(!DepthManager.isTop(ground_mc)){
				DepthManager.bringToTop(ground_mc);	
			}
		}
	}
	
	/**
	 * Returns whether this Window is active. 
	 * The active Window is always either the focused Window, 
	 * or the first Frame or Dialog that is an owner of the focused Window. 
	 */
	public function isActive():Boolean{
		return actived;
	}
	
	/**
	 * Sets the window to be actived or unactived.
	 */
	public function setActive(b:Boolean):Void{
		if(actived != b){
			if(b){
				active();
			}else{
				deactive();
			}
		}
	}
	
	/**
	 * Returns the window's ancestor movieclip which it/it's owner is created on.
	 * @return the ancestor movieclip of this window 
	 */
	public function getWindowAncestorMC():MovieClip{
		var ow:JWindow = this;
		while(ow.getWindowOwner() != null){
			ow = ow.getWindowOwner();
		}
		return MovieClip(ow.getOwner());
	}
	
	/**
	 * This is just for WindowUI to draw modalMC face.
	 * @return the modal mc
	 */
	public function getModalMC():MovieClip{
		return modalMC;
	}
	
	/**
	 * Resets the modal mc to cover the hole screen
	 */
	public function resetModalMC():Void{
		var p:Point = new Point(0, 0);
		if(!isModal()){
			p.y = - 100000;
		}
		modalMC._visible = isModal();
		modalMC._parent.globalToLocal(p);
		modalMC._width = Stage.width*3;
		modalMC._height = Stage.height*3;
		modalMC._x = p.x - Stage.width;
		modalMC._y = p.y - Stage.width;
	}
	
	private static function getWindowsVector():Vector{
		if(windows == undefined){
			windows = new Vector();
		}
		return windows;
	}
	
	/**
	 * Returns all displable windows currently. A window was disposed or destroied will not 
	 * included by this array.
	 * @return all displable windows currently.
	 */
	public static function getWindows():Array{
		return getWindowsVector().toArray();
	}
	
	/**
	 * getOwnedWindowsWithOwner(owner:JWindow)<br>
	 * getOwnedWindowsWithOwner(owner:MovieClip)
	 * <p>
	 * Returns owned windows of the specifid owner.
	 * @return owned windows of the specifid owner.
	 */
	public static function getOwnedWindowsWithOwner(owner:Object):Array{
		var ws:Array = new Array();
		for(var i:Number=0; i<getWindowsVector().size(); i++){
			var w:JWindow = JWindow(getWindowsVector().get(i));
			if(w.getOwner() === owner){
				ws.push(w);
			}
		}
		return ws;
	}
	
	private function initialize():Void{
		super.initialize();
		ground_mc._visible = isVisible();
	}
	
	public function doLayout():Void{
		super.doLayout();
		ground_mc._visible = isVisible();
	}
		
	/**
	 * Returns the component's mc's depth
	 */
	public function getDepth():Number{
		return ground_mc.getDepth();
	}
	
	/**
	 * Swap the component's mc's depth
	 */
	public function swapDepths(target):Void{
		ground_mc.swapDepths(target);
	}	
	
	
	private var mouseMoveListener:Object;
	public function startDrag():Void{
		if(mouseMoveListener == null){
			mouseMoveListener = new Object();
			mouseMoveListener.onMouseMove = Delegate.create(this, __onDrag);
		}
		root_mc.startDrag(false);
		Mouse.addListener(mouseMoveListener);
	}
	
	private function __onDrag():Void{
		var oldPos:Point = new Point(bounds.x, bounds.y);
		
		bounds.x = root_mc._x;
		bounds.y = root_mc._y;
		
		var newPos:Point = bounds.getLocation();
		
		dispatchEvent(createEventObj(ON_MOVED, oldPos, newPos));
		updateAfterEvent();
	}
	
	public function stopDrag():Void{
		root_mc.stopDrag();
		__onDrag();
		Mouse.removeListener(mouseMoveListener);
	}
	
    /**
     * Does nothing because Windows must always be roots of a focus traversal
     * cycle. The passed-in value is ignored.
     *
     * @param focusCycleRoot this value is ignored
     * @see #isFocusCycleRoot()
     * @see Container#setFocusTraversalPolicy()
     * @see Container#getFocusTraversalPolicy()
     */
    public function setFocusCycleRoot(focusCycleRoot:Boolean):Void {
    	this.focusCycleRoot = true;
    }
  
    /**
     * Always returns <code>true</code> because all Windows must be roots of a
     * focus traversal cycle.
     *
     * @return <code>true</code>
     * @see #setFocusCycleRoot()
     * @see Container#setFocusTraversalPolicy()
     * @see Container#getFocusTraversalPolicy()
     */
    public function isFocusCycleRoot():Boolean {
		return true;
    }
  
    /**
     * Always returns <code>null</code> because Windows have no ancestors; they
     * represent the top of the Component hierarchy.
     *
     * @return <code>null</code>
     * @see Container#isFocusCycleRoot()
     */
    public function getFocusCycleRootAncestor():Container {
		return null;
    }
	
	//--------------------------------------------------------
	private var visibleWhenOwnerIconing:Boolean;
	private function __ownerIconified():Void{
		visibleWhenOwnerIconing = isVisible();
		if(visibleWhenOwnerIconing){
			lostActiveAction();
			ground_mc._visible = false;
		}
	}
	private function __ownerRestored():Void{
		if(visibleWhenOwnerIconing){
			ground_mc._visible = true;
		}
	}
		
	private function lostActiveAction():Void{
		if(isActive()){
			deactive();
			getLootActiveFrom().active();
		}
		setLootActiveFrom(null);
	}
	
	private function createMCForOwnedWindow():MovieClip{
		return creater.createMC(ground_mc, "ground_mc");
	}
	
	/**
	 * Return the root_mc of the window's owner window.
	 * @return the root_mc of the window's owner window, undefined if 
	 * it has not a window owner.
	 */
	private function getOwnerRootMC():MovieClip{
		return getWindowOwner().root_mc;
	}
	
	
	private function createWindowContents():Void{
		if(owner instanceof MovieClip){
			var ownerMC:MovieClip = MovieClip(owner);
			ground_mc = creater.createMC(ownerMC, "ground_mc");
		}else if(owner instanceof JWindow){
			var jwo:JWindow = JWindow(owner);
			jwo.show();
			ground_mc = jwo.createMCForOwnedWindow();
			jwo.addEventListener(listenerToOwner);
		}else{
			trace(this + " JWindow's owner is not a mc or JWindow, owner is : " + owner);
			throw new Error(this + " JWindow's owner is not a mc or JWindow, owner is : " + owner);
		}
		if(lastLAF != UIManager.getLookAndFeel()){
			ASWingUtils.updateComponentTreeUI(this);
			lastLAF = UIManager.getLookAndFeel();
		}
		var groundPanel:MCPanel = new MCPanel(ground_mc, 10000, 10000);
		groundPanel.append(this); //MCPanel is just a tool to make JWindow created
	}
		
	private function getLootActiveFrom():JWindow{
		return lootActiveFrom;
	}
	private function setLootActiveFrom(activeOwner:JWindow):Void{
		if(activeOwner.getLootActiveFrom() == this){
			activeOwner.lootActiveFrom = lootActiveFrom;
		}
		lootActiveFrom = activeOwner;
	}
	
	private function active():Void{
		actived = true;
		for(var i:Number=0; i<getWindowsVector().size(); i++){
			var w:JWindow = JWindow(getWindowsVector().get(i));
			if(w != this){
				if(w.isActive()){
					w.deactive();
					setLootActiveFrom(w);
				}
			}

		}
		FocusManager.getCurrentManager().setActiveWindow(this);
		focusAtThisWindow();

		dispatchEvent(createEventObj(ON_WINDOW_ACTIVATED));
	}
	
	private function deactive():Void{
		actived = false;
		dispatchEvent(createEventObj(ON_WINDOW_DEACTIVATED));
	}
	
	private function focusAtThisWindow():Void{
		var focusOwner:Component = FocusManager.getCurrentManager().getFocusOwner();
		var currentFocusWindow:JWindow = ASWingUtils.getWindowAncestor(focusOwner);
		if(currentFocusWindow != this){
			var newFocusOwner:Component = getFocusTraversalPolicy().getInitialComponent(this);
			if(newFocusOwner != null){
				newFocusOwner.requestFocus();
			}
		}
	}
	
	private function create():Void{
		if(getWindowsVector().contains(this)){
			getWindowsVector().remove(this);
		}
		getWindowsVector().append(this);
		createModalMC();
		super.create();
	}
		
	private function __onPress():Void{
		super.__onPress();
		__activeWhenClicked();
	}
		
	/**
	 * Active and make this window to front.
	 */
	public function __onChildPressed(child:Component):Void{
		super.__onChildPressed(child);
		__activeWhenClicked();
	}
	
	private function __activeWhenClicked():Void{
		//getWindowOwner().__activeWhenClicked();
		getWindowOwner().toFront();
		if(!isActive()){
			toFront();
			active();
		}
	}
	
	private function createModalMC():Void{
		modalMC = creater.createMC(root_mc, "modal_mc");
		modalMC.tabEnabled = false;
		modalMC.onPress = null;
		modalMC.onRelease = null;
		modalMC._visible = modal;
	}
}
