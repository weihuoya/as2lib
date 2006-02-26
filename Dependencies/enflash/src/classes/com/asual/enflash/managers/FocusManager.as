import com.asual.enflash.EnFlashObject;

import com.asual.enflash.data.List;
import com.asual.enflash.ui.ScrollPane;

/**
 * FocusManager class controls the focus order and tabulation inside the EnFlash framework.
 * It provides a transparent management for all the User Interface components.
 */
class com.asual.enflash.managers.FocusManager extends EnFlashObject {
	
	private var _panes:List;
	private var _components:List;
	private var _focus:Object;
	private var _lastfocus:Object;
	private var _tab:Boolean = false;
	private var _name:String = "FocusManager";
	
	/**
	 * Event that notifies when a component has received a focus.
	 */	
	public var focus:Function;

	/**
	 * Event that notifies when a component has lost a focus.
	 */	
	public var blur:Function;

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */	
	public function FocusManager(id:String) {
		
		super(id);
			
		_enflash.movieclip._focusrect = false;
		_focus = null;
		
		_components = new List();
		_components.init(_ref);
		
		_panes = new List();
		_panes.init(_ref);
	
		_enflash.ui.movieclip.onSetFocus = createDelegate(this, _handleFocus);

		Selection.addListener(_enflash.ui.movieclip);

		_enflash.ui.addEventListener("keydown", this, _keyDown);
		_enflash.ui.addEventListener("keyup", this, _keyUp);

	}
	
	/**
	 * Currently focused EnFlash component.
	 */
	public function get focusedObject():Object {
		if (_id != undefined) {
			return _focus2object(_focus);
		}
	}

	public function set focusedObject(object:Object):Void {

		if (_id != undefined) {

			if (object == null) {
				Selection.setFocus(null);
			} else if (object.focus != undefined) {
				object.focus();
			}
		}
	}

	/**
	 * The component that stands before the currently focused one in the tabulation order.
	 */
	public function get previousFocus():Object {
		if (_id != undefined) {
			return _getPreviousFocus((_focus != null) ? _focus.tabIndex : _lastfocus.tabIndex);
		}
	}	

	/**
	 * The component that stands after the currently focused one in the tabulation order.
	 */
	public function get nextFocus():Object {
		if (_id != undefined) {
			return _getNextFocus((_focus != null) ? _focus.tabIndex : _lastfocus.tabIndex);
		}
	}

	/**
	 * Registers a ScrollPane with the FocusManager.
	 * 
	 * @pane The pane that has to be registered
	 */
	public function register(pane:ScrollPane):Void {
		pane.index = _panes.length;
		_panes.addItem(pane);
	}

	/**
	 * Unregisters a ScrollPane with the FocusManager.
	 * 
	 * @pane The pane that has to be unregistered
	 */	
	public function unregister(pane:ScrollPane):Void {
		var item = _panes.getItem(getPaneIndex(pane));
		delete item;
	}
	
	/**
	 * Provides the tab index of a ScrollPane.
	 * 
	 * @param pane The pane with unknown tab index
	 * @return Tab index of the pane
	 */
	public function getPaneIndex(pane:ScrollPane):Number {
		return _panes.getIndex(pane);
	}	
	
	/**
	 * Provides access to the currently focused pane.
	 * 
	 * @return The pane that hosts the curretnly focused component 
	 */
	public function getFocusedPane():ScrollPane {
		var focus = (_focus != null) ? _focus : _lastfocus;
		return _panes.getItem(Math.floor(focus.tabIndex/_enflash.ui.paneCapacity));
	}

	/**
	 * Enables tabulation for all the UI components.
	 */
	public function enableAll():Void {

		var pane, component;
		var i:Number = _panes.length;
		while(i--) {
			pane = _panes.getItem(i);
			var j:Number = pane.length;
			while(j--) {
				component = pane.getItem(j);
				component.tabIndex = pane.index*100 + j;
			}
		}
	}

	/**
	 * Disables tabulation for all the UI components except the ones in the current Dialog.
	 */
	public function disableAll():Void {

		var dialogPane = _enflash.ui.dialog.getPane(0);

		var pane, component;
		var i:Number = _panes.length;
		while(i--) {
			pane = _panes.getItem(i);
			if (pane != dialogPane) {
				var j:Number = pane.length;
				while(j--) {
					component = pane.getItem(j);
					component.tabIndex = -1;
				}
			}
		}
	}
	
	private function _getPreviousFocus(tabIndex:Number):Object {
		
		var paneIndex = Math.floor(tabIndex/_enflash.ui.paneCapacity);
		var prevFocus = _panes.getItem(paneIndex).getItem(tabIndex % _enflash.ui.paneCapacity - 2);
		
		if (prevFocus != undefined) {
			if (!prevFocus.focusable || !prevFocus.enabled) {
				return _getPreviousFocus(tabIndex - 1);
			} else {
				return prevFocus;
			}
		} else {

			var prevIndex = paneIndex - 1;
			
			if (prevIndex < 0) {
				return _getPreviousFocus((_panes.length - 1)*_enflash.ui.paneCapacity + _panes.lastItem.length - 1);
			} else {
				return _getPreviousFocus(prevIndex*_enflash.ui.paneCapacity + _panes.getItem(prevIndex).length + 1);
			}
		}
	}

	private function _getNextFocus(tabIndex:Number):Object {

		var paneIndex = Math.floor(tabIndex/_enflash.ui.paneCapacity);
		var nextFocus = _panes.getItem(paneIndex).getItem(tabIndex % _enflash.ui.paneCapacity);

		if (nextFocus != undefined) {
			if (!nextFocus.focusable || !nextFocus.enabled) {
				return _getNextFocus(tabIndex + 1);
			} else {
				return nextFocus;
			}
		} else {
			var nextIndex = paneIndex + 1;
			if (nextIndex >= _panes.length) {
				return _getNextFocus(0);
			} else {
				return _getNextFocus(nextIndex*_enflash.ui.paneCapacity);
			}
		}
	}
	
	private function _handleFocus(evt:Object):Void {
	
		var oldFocus = evt.oldFocus;
		var newFocus = evt.newFocus;
		var component;

		if (_focus == newFocus) return;
		
		if (_focus != null){
			
			if (_focus.multiline != undefined){
				component = _enflash.getByRef(_focus._parent._parent._parent._ref);
			} else {
				component = _enflash.getByRef(_focus._ref);
			}
			
			dispatchEventOnce(component, "blur", newFocus);
			_lastfocus = _focus;
		}

		_focus = newFocus;

		if (_focus != null){
			
			if (_focus.multiline != undefined){
				component = _enflash.getByRef(_focus._parent._parent._parent._ref);
			} else {
				component = _enflash.getByRef(_focus._ref);
			}
			dispatchEventOnce(component, "focus", oldFocus, _tab);
		}
		
		var index = newFocus.tabIndex % 100;
		var focusedPane = getFocusedPane();
		
		var i = _panes.length;
		while(i--){
			var pane = _panes.getItem(i);
			if (pane != focus) {
				pane["_rect"].focusable = false;
			}
		}
	}

	private function _focus2object(focus):Object {
		
		if (focus.tabIndex != undefined && (focus.tabIndex % _enflash.ui.paneCapacity != 0)) {
			return _panes.getItem(Math.floor(focus.tabIndex/_enflash.ui.paneCapacity)).getItem(focus.tabIndex % _enflash.ui.paneCapacity - 1);			
		}
		
		if (focus.multiline != undefined){
			
			return _enflash.getByRef(focus._parent._parent._parent._ref);

		} else {

			var component = _enflash.getByRef(focus._ref);
			switch(component.parent.toString()) {
				case "ListBox":
					return component.parent;
					break;
				case "Pane":
					return component.parent;
					break;
				case "ScrollPane":
					return component.parent;
					break;
				case "Tree":
					return component.parent;
					break;
				default:
					return _enflash.getByRef(focus._ref);
			}
		}
		
	}

	private function _keyDown():Void {
		if (Key.getCode() == 9) {
			_tab = true;
		}
	}

	private function _keyUp():Void {
		if (Key.getCode() == 9) {
			_tab = false;
		}
	}
	
}