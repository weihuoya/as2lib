import com.asual.enflash.EnFlashObject;
import com.asual.enflash.EnFlashConfiguration;

import com.asual.enflash.data.Composition;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.UI;

/**
 * EnFlash is the main class that creates and manages applications based on the EnFlash Framework. 
 * It provides a quick access to any application object, tracing functionality, simplified 
 * Shared Objects management and other useful methods.
 */
class com.asual.enflash.EnFlash extends EnFlashObject {
	
	private var _mc:MovieClip;
	private var _ui:UI;
	private var _data:Composition;
	private var _objects:Array = new Array();
	private var _logger:Boolean = false;
	private var _loggerString:String = "";
	private var _loggerLabel:Label;
	private var _version:Number = .4;
	private var _os:String;
	private var _interval:Number;
	private var _conf:Object;
	private var _name:String = "EnFlash";

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */	
	public function EnFlash(id:String) {

		super(id);

		_id = (id != undefined) ? id : toString();
		_os = String(System.capabilities.os).toLowerCase();
	}

	/**
	 * Initializes the object and makes it a part of the EnFlash object hierarchy.
	 * 
	 * @param conf Object containing application configuration
	 */
	public function init(conf:EnFlashConfiguration):Void {

		super._init(null);

		_conf = (conf != undefined) ? conf : new EnFlashConfiguration();

		_mc = _conf.mc;
		_mc.stop();

		if (!_conf.xmlMode) {
			_ui = new UI();
			_ui.init(_ref, _mc, 0);
		} else {
			_loadXML(_conf.xmlFile);
		}
	}
	
	/**
	 * Displays program messages in a top-level Label instance.<br />
	 * Example: <code>log("myObject", myObject,...myObject.someProperty);</code>
	 *  
  	 * @param msg One or multiple objects and values to be displayed.
	 */
	public function log(msg:Object):Void {

		var log = getTimer() + ": " + arguments.join(", ");
				
		if (_enflash.ide) {

			trace(log);

		} else {
			
			_loggerString += log + "\n";

			if (_loggerLabel == undefined) {
				_loggerLabel = getById("EnFlashLogLabel");
			}
			
			if (_loggerLabel != undefined) {
				_loggerLabel.value = _loggerString;
				var pane = _loggerLabel.parent.parent;
				pane.refresh();
				pane.vPosition = pane.contentHeight;
			}
		}
	}
	
	/**
	 * Registers an object with this application. This method is invoked automatically for every EnFlash object. 
	 * 
	 * @param object An object to be registered
	 * @return Unique object reference used in EnFlash hierarchy
	 */
	public function register(object:Object):Number {
		_objects.push(object);
		return _objects.length - 1;
	}
	
	/**
	 * Unregisters an object from this application.
	 * 
	 * @param object An object to be unregistered.
	 */
	public function unregister(object:Object):Void {
		delete _objects[object.ref];
	}
	
	/**
	 * Provides access to an EnFlash object based on a known reference number.
	 * 
	 * @param ref Reference number of an object
	 * @return Object reference
	 */
	public function getByRef(ref:Number) {		
		return _objects[ref];
	}

	/**
	 * Provides access to an EnFlash object based on a known object ID.
	 * 
	 * @param id ID of an object
	 * @return Object reference
	 */	
	public function getById(id:String) {
		
		if (id != undefined || String(id).length > 0) {
			var i:Number = _objects.length;
			while(i--) {
				if (_objects[i].id == id) {
					return _objects[i];
				}
			}
		}
	}

	/**
	 * Writes a property/value record in the Shared Object of this application.
	 * 
	 * @param property Name of a record
	 * @param value Value of a record
	 */	
	public function setLocal(property:String, value:Object):Void {
		var so = SharedObject.getLocal("enflash");	
		so.data[property] = value;
		so.flush();	
	}

	/**
	 * Reads a value of a property from the Shared Object of this application.
	 * 
	 * @param property Name of a stored record
	 * @return Value of a stored object
	 */
	public function getLocal(property:String):Object {
		var so = SharedObject.getLocal("enflash");
		return so.data[property]
	}

	/**
	 * Provides access to the functionality of the loader movie.
	 * 
	 * @param method Name of the method that will be executed
	 * @param argument (optional) Method argument
	 */
	public function loaderCall(method:String, argument:Object):Void {
		_mc._parent[method](argument);
	}

	/**
	 * Provides an access to the configuration object of this application.
	 * 
	 * @return Collection of configurable properties 
	 */
	public function get conf():Object {
		return _conf;
	}
		
	/**
	 * Indicates whether this application runs inside the Flash IDE or not.
	 * 
	 * @return True for the Flash IDE, false for everything else 
	 */
	public function get ide():Boolean {
		return (_global.ASnative(302, 0) != undefined) ? true : false;
	}

	/**
	 * Shortcut property that provides information about the Operating System where this application runs.
	 * 
	 * @return OS name and version
	 */
	public function get os():String {
		return _os;
	}

	/**
	 * Provides access to the data associated with this application.
	 * 
	 * @return Composition object
	 */
	public function get data():Composition {
		return _data;
	}
	
	/**
	 * Provides access to the User Interface object of this application.
	 * 
	 * @return UI object
	 */
	public function get ui():UI {
		return _ui;
	}

	/**
	 * MovieClip that hosts this application.
	 * 
	 * @return MovieClip reference
	 */
	public function get movieclip():MovieClip {
		return _mc;
	}

	/**
	 * Version number of the EnFlash framework.
	 * 
	 * @return Version info
	 */
	public function get version():Number {
		return _version;
	}

	public function get logger():Boolean {
		return _logger;
	}

	public function set logger(logger:Boolean):Void {
		_logger = logger;
		getById("EnFlashLogWindow").visible = _logger;			
	}

	private function _loadXML(url:String):Void {

		var xml = new XML();
		xml.ignoreWhite = true;	
		xml.load(url);

		_interval = setInterval(this, "_dataProgress", 100, xml);
		loaderCall("loadData");
	}
	
	private function _dataProgress(xml:XML):Void {

		var bl = xml.getBytesLoaded();
		var bt = xml.getBytesTotal();

		if (bl != undefined && bt != undefined && bt != 0) {
			
			loaderCall("setPercents", Math.round((bl/bt)*100));
			if (bl == bt) {
				clearInterval(_interval);
				_setXML(xml.firstChild);
			}
		} else {
			loaderCall("setPercents", 0);
		}
	}
		
	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		xml.xmlDecl = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
		
		if (_ui != undefined) {
			xml.firstChild.appendChild(_ui.getXML());
		}
		if (_data) {
			xml.firstChild.appendChild(_data.getXML());
		}
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		if (xml.attributes.logger != undefined) {
			logger = (xml.attributes.logger == "true") ? true : false;
		}

		var item;
		var i:Number = -1;
		var iMax = xml.childNodes.length;
		while(++i != iMax) {
			item = xml.childNodes[i];		
			switch(item.nodeName) {
				case "Data":
					_data = new Composition(item.attributes.id);
					_data.init(_ref);
					_data.setXML(item);
					break;
				case "UI":
					_ui = new UI(item.attributes.id);
					_ui.init(_ref, _mc);
					_ui.setXML(item);
					break;					
			}
		}
		super._setXML(xml);
	}

}