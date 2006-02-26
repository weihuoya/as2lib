import com.asual.enflash.EnFlashObject;
import com.asual.enflash.data.List;
import com.asual.enflash.utils.Strings;

/**
 * ShortcutManager class enables execution of shortcut combinations.
 */
class com.asual.enflash.managers.ShortcutManager extends EnFlashObject {

	private var _altDown:Number = 0;
	private var _escDown:Number = 0;
	private var _shortcuts:List;
	private var _name:String = "ShortcutManager";

	private var KEYCODES:Object;

	/**
	 * Event that notifies when a shortcut combination is executed.
	 */	
	public var onshortcut:Function;

	/**
	 * Event that notifies when a shortcut has to be formatted.
	 */	
	public var onformat:Function;

	/**
	 * @param id (optional) Descriptive ID of this object.
	 */
	public function ShortcutManager(id:String) {
		
		super(id);
		
		_shortcuts = new List();
		_shortcuts.init(_ref);
		
		KEYCODES = new Object();

		KEYCODES["BACKSPACE"] = 8;
		KEYCODES["TAB"] = 9;
		KEYCODES["CLEAR"] = 12;
		KEYCODES["ENTER"] = 13;
		KEYCODES["SHIFT"] = 16;
		
		KEYCODES["CONTROL"] = 17;
		KEYCODES["CTRL"] = 17;
		
		KEYCODES["ALT"] = 18;
		KEYCODES["CAPS LOCK"] = 20;
		
		KEYCODES["ESC"] = 27;
		KEYCODES["ESCAPE"] = 27;
		
		KEYCODES["SPACEBAR"] = 32;
		KEYCODES["PAGE UP"] = 33;
		KEYCODES["PAGE DOWN"] = 34;
		KEYCODES["END"] = 35;
		KEYCODES["HOME"] = 36;
		KEYCODES["LEFT ARROW"] = 37;
		KEYCODES["UP ARROW"] = 38;
		KEYCODES["RIGHT ARROW"] = 39;
		KEYCODES["DOWN ARROW"] = 40;

		KEYCODES["INSERT"] = 45;
		KEYCODES["INS"] = 45;
		
		KEYCODES["DELETE"] = 46;
		KEYCODES["DEL"] = 46;
		
		KEYCODES["HELP"] = 47;
		
		KEYCODES["0"] = 48;
		KEYCODES["1"] = 49;
		KEYCODES["2"] = 50;
		KEYCODES["3"] = 51;
		KEYCODES["4"] = 52;
		KEYCODES["5"] = 53;
		KEYCODES["6"] = 54;
		KEYCODES["7"] = 55;
		KEYCODES["8"] = 56;
		KEYCODES["9"] = 57;
		
		KEYCODES["A"] = 65;
		KEYCODES["B"] = 66;
		KEYCODES["C"] = 67;
		KEYCODES["D"] = 68;
		KEYCODES["E"] = 69;
		KEYCODES["F"] = 70;
		KEYCODES["G"] = 71;
		KEYCODES["H"] = 72;
		KEYCODES["I"] = 73;
		KEYCODES["J"] = 74;
		KEYCODES["K"] = 75;
		KEYCODES["L"] = 76;
		KEYCODES["M"] = 77;
		KEYCODES["N"] = 78;
		KEYCODES["O"] = 79;
		KEYCODES["P"] = 80;
		KEYCODES["Q"] = 81;
		KEYCODES["R"] = 82;
		KEYCODES["S"] = 83;
		KEYCODES["T"] = 84;
		KEYCODES["U"] = 85;
		KEYCODES["V"] = 86;
		KEYCODES["W"] = 87;
		KEYCODES["X"] = 88;
		KEYCODES["Y"] = 89;
		KEYCODES["Z"] = 90;
		
		KEYCODES["F1"] = 112;
		KEYCODES["F2"] = 113;
		KEYCODES["F3"] = 114;
		KEYCODES["F4"] = 115;
		KEYCODES["F5"] = 116;
		KEYCODES["F6"] = 117;
		KEYCODES["F7"] = 118;
		KEYCODES["F8"] = 119;
		KEYCODES["F9"] = 120;
		KEYCODES["F11"] = 122;
		KEYCODES["F12"] = 123;
		KEYCODES["F13"] = 124;
		KEYCODES["F14"] = 125;
		KEYCODES["F15"] = 126; 
		
		KEYCODES["NUM LOCK"] = 144;
		
		KEYCODES[";"] = 186;
		KEYCODES[":"] = 186;
		KEYCODES["="] = 187;
		KEYCODES["+"] = 187;
		KEYCODES["-"] = 189;
		KEYCODES["_"] = 189;
		KEYCODES["/"] = 191; 
		KEYCODES["?"] = 191;
		KEYCODES["`"] = 192; 
		KEYCODES["~"] = 192;
		KEYCODES["["] = 219; 
		KEYCODES["{"] = 219;
		KEYCODES["\\"] = 220;
		KEYCODES["|"] = 220;
		KEYCODES["]"] = 221;
		KEYCODES["}"] = 221;
		KEYCODES["\""] = 222;
		KEYCODES["'"] = 222;
	}

	/**
	 * Adds a shortcut to an object.
	 */	
	public function addShortcut(object:Object, shortcut:String):Void {

		dispatchEventOnce(object, "format", shortcut);

		shortcut = Strings.replace(shortcut, "++", "+=");
		var keys = shortcut.split("+");
		
		var obj:Object = new Object();
		obj.object = object;
		obj.execute = false;
		obj.codes = new Array();
		
		var i:Number = keys.length;
		while(i--){
			obj.codes.push(KEYCODES[keys[i].toUpperCase()]);
		}
		
		_shortcuts.addItem(obj);
	}

	public function removeShortcut(object:Object):Void {
		
		object._formatShortcut();
		
		var obj = _shortcuts.getItemByProperty("object", object);
		_shortcuts.removeItem(obj);
		
	}

	private function _init(parent:Number):Void {
		
		super._init(parent);

		_enflash.ui.addEventListener("keydown", this, _keyCheck);
		_enflash.ui.addEventListener("keyup", this, _keyUp);
		
		if (!_enflash.ide){
			setInterval(this, "_specialsCheck", 100);
		}
	}

	private function _keyUp(evt:Object):Void {
		
		var i:Number = _shortcuts.length;
		while(i--){
			_shortcuts.getItem(i).execute = false;
		}		
	}
			
	private function _keyCheck(evt:Object):Void {
		
		var i:Number = _shortcuts.length;
		while(i--){
			var obj:Object = _shortcuts.getItem(i);
			var success:Boolean = true;
			var j:Number = obj.codes.length;
			while(j--){
				if (!Key.isDown(obj.codes[j])) success = false;
			}
			if (success && !obj.execute){
				dispatchEventOnce(obj.object, "shortcut");
				obj.execute = true;
				return;
			}
		}
	}
	
	private function _specialsCheck():Void {
		
		if (!_enflash.ui.visible) return;

		if (Key.isDown(KEYCODES["ESCAPE"])) {
			
			if (_escDown == 0){
				_escDown = 1;
				_enflash.ui.closeComboList();
				_enflash.ui.closeMenu();
				if (_enflash.ui.dialog) {
					_enflash.ui.dialog.close();
				}
			}
			
		} else {
			
			if (_escDown != 0){
				_escDown = 0;
			}
		}

		if (_enflash.ui.dialog != undefined) return;
		
		if (Key.isDown(KEYCODES["CONTROL"])) {
			_keyCheck();
		}
		
		if (Key.isDown(KEYCODES["ALT"])) {
			
			if (_altDown == 0){
				_altDown = 1;
				_enflash.ui.closeMenus();
			}
			
			if (_altDown == 1){
				var i:Number = _shortcuts.length;
				while(i--){
					var obj:Object = _shortcuts.getItem(i);
					var success:Boolean = true;
					var j:Number = obj.codes.length;
					while(j--){
						if (!Key.isDown(obj.codes[j])) success = false;
					}
					if (success && !obj.execute){
						dispatchEventOnce(obj.object, "shortcut");
						obj.execute = true;
						_altDown = 2;
						return;
					}
				}
			}
		} else {
			if (_altDown != 0){
				_altDown = 0;
			}			
		}
	}	
}