import com.asual.enflash.EnFlashObject;
import com.asual.enflash.utils.XMLNodes;

/**
 * LangManager class. 
 */
class com.asual.enflash.managers.LangManager extends EnFlashObject {

	private var _lang:String;
	private var _xml:XML;
	
	private var _name:String = "LangManager";

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */
	public function LangManager(id:String) {
		super(id);
	}

	public function getLang(component):Void {
		
		var node = XMLNodes.getByName(_xml, component.id);
		if(node != null){
			if (node.attributes.value != undefined) {
				component.value = node.attributes.value;
			}
			if (node.attributes.title != undefined) {
				component.title = node.attributes.title;
			}
		}
	}

	public function get lang():String {
		return _lang;
	}

	public function set lang(lang:String):Void {
		
		lang = lang.toLowerCase();
		
		if (_lang == lang) {
			_loadLang();
		} else {
			_lang = lang;
			_xml.load(_enflash.conf.langsRepository + _lang + ".xml");
			_enflash.setLocal("lang", String(_lang));
		}
	} 

	private function _init(parent:Number):Void {
		
		super._init(parent);

		_xml = new XML();
		_xml.ignoreWhite = true;
		_xml.onLoad = createDelegate(this, _loadLang);

		if (_enflash.getLocal("lang") != undefined){ 
			lang = _enflash.getLocal("lang");
		} else {
			lang = "english";			
		}
	}
	
	private function _loadLang(evt:Object):Void {

		if (!_enflash.ui.loaded) return;

		var item, object;
		var i:Number = -1;
		var iMax = _xml.firstChild.childNodes.length;
		while(++i < iMax) {
			item = _xml.firstChild.childNodes[i];
			object = _enflash.getById(item.nodeName);
			if (item.attributes.value != undefined) {
				if (object.value != item.attributes.value) {
					object.value = item.attributes.value;
				}
			}
			if (item.attributes.shortcut != undefined) {
				if (object.shortcut != item.attributes.shortcut) {
					_enflash.ui.removeShortcut(object);
					object.shortcut = item.attributes.shortcut;
				}
			}
			if (item.attributes.label != undefined) {
				if (object.label != item.attributes.label) {
					object.label = item.attributes.label;
				}
			}
			if (item.attributes.title != undefined) {
				if (object.title != item.attributes.title) {
					object.title = item.attributes.title;
				}
			}
		}
		_enflash.ui.zoom = _enflash.ui.zoom;	
	}
}