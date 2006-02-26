import com.asual.enflash.EnFlashObject;
import com.asual.enflash.data.List;

/**
 * Composition class partly implements the Composite pattern and allows the creation of
 * hierarchical structures. It's useful for describing application's data model and XML
 * to Object conversion. 
 */
class com.asual.enflash.data.Composition extends EnFlashObject {
	
	private var _list:List;
	private var _properties:Object;
	private var _name:String = "Composition";

	/**
	 * Event that notifies when this object has loaded an XML file.
	 */	
	public var onload:Function;

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */	
	public function Composition(id:String){
		super(id);
		_list = new List();
		_list.init(_ref);
		
		_properties = new Object();
	}
	
	/**
	 * Adds a child to this object.
	 * 
	 * @param item (optional) Composition object that will be added
	 * @return Newly added child element
	 */
	public function addItem(item:Composition):Composition {

		if (item == undefined) {
			item = new Composition();
		}
		item.init(_ref);
		item.addEventListener("remove", this, removeItem);
		_list.addItem(item);

		return item;
	}

	/**
	 * Adds a child to this object at the specified index.
	 * 
	 * @param index Index number of the new child element
	 * @param item (optional) Composition object that will be added
	 * @return Newly added child element
	 */
	public function addItemAt(index:Number, item:Composition):Composition {
		
		if (item == undefined) {
			item = new Composition();
		}
		item.init(_ref);
		item.addEventListener("remove", this, removeItem);
		_list.addItemAt(index, item);
		
		return item;
	}
	
	/**
	 * Removes a child from this object.
	 * 
	 * @param Composition object that will be removed
	 * @return The removed object
	 */
	public function removeItem(item:Composition):Object {
		item.removeEventListener("remove", this);
		return _list.removeItem(item);
	}
	
	/**
	 * Removes a child at the specified index.
	 * 
	 * @param Index number of the child that will be removed
	 * @return The removed object
	 */
	public function removeItemAt(index:Number):Object {
		_list.getItem(index).removeEventListener("remove", this);
		return _list.removeItemAt(index);
	}

	/**
	 * The first child of this object.
	 */
	public function get firstItem():Object {
		return _list.firstItem;
	}

	/**
	 * The last child of this object.
	 */	
	public function get lastItem():Object {
		return  _list.lastItem;
	}

	/**
	 * The number of childs in this object.
	 */
	public function get length():Number {
		return _list.length;
	}

	/**
	 * Provides access to an object that stores custom properties.
	 */
	public function get properties():Object {
		return _properties;
	}

	/**
	 * Provides the index number of a child object.
	 * 
	 * @param item A child of this object
	 * @return Index number of the child
	 */
	public function getIndex(item:Composition):Number {
		return  _list.getIndex(item);
	}
	
	/**
	 * Provides access to a child object based on an index number.
	 * 
	 * @param index Index number
	 * @return Child object residing on the provided index
	 */
	public function getItem(index:Number):Composition {
		return _list.getItem(index);
	}
	
	/**
	 * Provides access to an object placed before the specified child.
	 * 
	 * @param item A child that belongs to this object
	 * @param loop (optional) Enables a loop feature
	 * @return The previous child object
	 */
	public function getPreviousItem(item:Composition, loop:Boolean):Composition {
		return _list.getPreviousItem(item, loop);
	}
	
	/**
	 * Provides access to an object placed after the specified child.
	 * 
	 * @param item A child that belongs to this object
	 * @param loop (optional) Enables a loop feature
	 * @return The next child object
	 */
	public function getNextItem(item:Composition, loop:Boolean):Composition {
		return _list.getNextItem(item, loop);
	}

	/**
	 * Asks about the existance of at least one child in this object.
	 * 
	 * @return True for at least one child and false for no childs
	 */	
	public function hasChildren():Boolean {
		return (_list.length == 0) ? false : true;
	}

	/**
	 * Creates tab formatted text representation of this object.
	 * 
	 * @param tab (optional) Initial tabbing
	 * @return Tab formatted presentation of this object
	 */
	public function toOutput(tab:String):String {

		if (tab == undefined) tab = "";	
		
		var output = tab + toString() + _ref;
		var properties = "";
		for (var p in _properties) {
			properties += p + "=" + _properties[p] + ", ";
		}
		
		if (properties.length > 1) {
			output += " [" + properties.substring(0, properties.length - 2) + "]";
		}
		
		if (_list.length > 0) {
			output += "\n" + _list.getItem(0).toOutput(tab + "\t");
		}
		
		var nextItem = parent.getNextItem(this);
		if (tab != "" && nextItem != undefined) {
			output += "\n" + nextItem.toOutput(tab);
		}

		return output;
	}

	/**
	 * Loads an XML file and converts it to a hierarchical object structure.
	 * 
	 * @param url The location of the XML file
	 */	
	public function loadXML(url:String):Void {
		var xml = new XML();
		xml.ignoreWhite = true;
		xml.base = this;
		xml.onLoad = createDelegate(this, _loadHandler, {xml: xml});
		xml.load(url);
	}

	private function _loadXML(success:Boolean):Void {
		_loadHandler(success, this);
		delete this;
	}

	private function _loadHandler(evt:Object):Void {
		if (evt.success){ 
			setXML(evt.xml.firstChild);
			dispatchEvent("load", true);
		} else {
			dispatchEvent("load", false);
		}
	}

	private function _getXML():XMLNode {
		
		var xml = super._getXML();
		xml.firstChild.nodeName = _properties["_xmlNode"];

		for (var p in _properties){
			if (p != "_xmlNode") {
				xml.firstChild.attributes[p] = _properties[p];
			}
		}
		
		if (_list.length > 0) {

			var i:Number = -1;
			var iMax:Number = _list.length;
			while(++i != iMax) {
				xml.firstChild.appendChild(_list.getItem(i).getXML());
			}
		}
				
		return xml;
	}

	private function _setXML(xml:XMLNode):Void {

		_properties["_xmlNode"] = xml.nodeName;
		
		for (var attr in xml.attributes){
			_properties[attr] = xml.attributes[attr];
		}

		var node;
		var i:Number = -1;
		var iMax:Number = xml.childNodes.length;
		while(++i != iMax) {
				node = xml.childNodes[i];
				addItem(node.attributes.id).setXML(node);
		}
		
		super._setXML(xml);
	}
}