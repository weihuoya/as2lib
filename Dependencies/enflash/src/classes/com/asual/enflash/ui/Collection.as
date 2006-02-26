import com.asual.enflash.data.List;

import com.asual.enflash.ui.Mask;
import com.asual.enflash.ui.UIObject;

/**
 * The Collection class hosts a collection of UIObjects on a single MovieClip.
 * 
 * Collection consists of a UIObject with an internal MovieClip and List. When new UIObjects are added to the Collecction,
 * they are added to the List and are given a the internal MovieClip as a parent. 
 * 
 * Collection is used internally by Pane
 */
class com.asual.enflash.ui.Collection extends UIObject {
	
	private var _list:List;
	private var _content:MovieClip;
	private var _mask:Mask;
	private var _name:String = "Collection";

	public function Collection(id:String) {
		super(id);
	}

	/**
	 * See List
	 */
	public function getItem(index:Number) {
		return _list.getItem(index);
	}

	/**
	 * See List
	 */
	public function getIndex(item:UIObject):Number {
		return _list.getIndex(item);
	}

	/**
	 * Sets a new index number for an existing member.
	 * 
	 * @param index The new index of the member
	 * @param obj The member that is going to be re-indexed
	 */
	public function setIndex(index:Number, obj:Object):Void {
		_list.setIndex(index, obj);
		_manageDepths(0);
	}

	/**
	 * See List
	 */
	public function getItemByProperty(prop:String, value:String) {
		return _list.getItemByProperty(prop, value);
	}
	
	/**
	 * See List
	 */
	public function getPreviousItem(item:UIObject, loop:Boolean) {
		return _list.getPreviousItem(item, loop);
	}

	/**
	 * See List
	 */
	public function getNextItem(item:UIObject, loop:Boolean) {
		return _list.getNextItem(item, loop);
	}
	
	/**
	 * Adds the item to the collection and initializes it, making this collection's MovieClip the parent clip
	 * 
	 * See List
	 */
	public function addItem(item:UIObject) {
		_list.addItem(item);
		item.init(_ref, _content, _list.length - 1);
		return item;
	}

	/**
	 * Adds the item to the collection at the specified index and initializes it, making this collection's MovieClip the parent clip
	 * 
	 * See List
	 */	
	public function addItemAt(index:Number, item:UIObject) {
		_list.addItemAt(index, item);
		_manageDepths(index);
		item.init(_ref, _content, index);
		return item;
	}
	
	public function removeItem(item:UIObject) {
		var index = _list.getIndex(item);
		_list.removeItem(item);
		item.remove();
		_manageDepths(index);
		return item;
	}

	public function removeItemAt(index:Number) {
		var item = _list.removeItemAt(index);
		item.remove();
		_manageDepths(index);
		return item;
	}

	public function removeAll(remove:Boolean):Array {
		
		var all = _list.removeAll();

		if (remove || remove == undefined) {
			while(all.length) {
				all.shift().remove();	
			}
		}
		return all;	
	}

	public function swap(obj1:Object, obj2:Object):Void {
		_list.swap(obj1, obj2);
		obj1.movieclip.swapDepths(obj2.movieclip.getDepth());		
	}

	public function get list():List {
		return _list;
	}
	
	public function get length():Number {
		return _list.length;
	}

	public function get firstItem() {
		return _list.firstItem;
	}

	public function get lastItem() {
		return _list.lastItem;
	}	

	private function _init(parent:Number, mc:MovieClip, depth:Number):Void {
		
		super._init(parent, mc, depth);
		
		_content = _mc.createEmptyMovieClip("_content", 0);

		_list = new List();
		_list.init(_ref);

		_mask = new Mask();
		_mask.init(_ref, _mc);
		_mask.apply(_content);
	}
	
	private function _setSize(w:Number, h:Number):Void {
		
		_mask.setSize(w, h);
		super._setSize(w, h);
	}
	
	private function _manageDepths(index:Number):Void {

		var i:Number = index;
		var iMax = _list.length;
		while(++i < iMax) {
			_list.getItem(i).movieclip.swapDepths(i);
		}
	}
	
	private function _remove():Void {
		
		var i:Number = _list.length;	
		while(i--){
			_list.removeItemAt(i);
		}
		_list.remove();
		
		for(var p in _content){
			delete _content[p];
		}
		_content.removeMovieClip();

		_mask.remove();
		
		super._remove();
	}	
}	