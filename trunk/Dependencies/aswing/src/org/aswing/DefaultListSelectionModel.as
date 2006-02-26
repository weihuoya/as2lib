/*
 Copyright aswing.org, see the LICENCE.txt.
*/
import org.aswing.EventDispatcher;
import org.aswing.JList;
import org.aswing.ListSelectionModel;

/**
 * Default data model for list selections.
 * @author iiley
 */
class org.aswing.DefaultListSelectionModel extends EventDispatcher implements ListSelectionModel {
	
	private var value:Array;
	private var minIndex:Number;
	private var maxIndex:Number;
	private var archorIndex:Number;
	private var leadIndex:Number;
	private var selectionMode:Number;
	
	public function DefaultListSelectionModel(){
		value       = [];
		minIndex    = Number.MAX_VALUE;
		maxIndex    = Number.MIN_VALUE;
		archorIndex = -1;
		leadIndex   = -1;
		selectionMode = JList.MULTIPLE_SELECTION;
	}
	
	public function setSelectionInterval(index0 : Number, index1 : Number) : Void {
		if (index0 < 0 || index1 < 0) {
            return;
        }
        if (getSelectionMode() == JList.SINGLE_SELECTION) {
            index0 = index1;
        }
        updateLeadAnchorIndices(index0, index1);
		var min:Number = Math.min(index0, index1);
		var max:Number = Math.max(index0, index1);
		var changed:Boolean = false;
		if(min == minIndex && max == maxIndex){
			for(var i:Number=min; i<=max; i++){
				if(value[i] != true){
					changed = true;
					break;
				}
			}
		}else{
			changed = true;
		}
		if(changed){
			minIndex = min;
			maxIndex = max;
			clearSelectionImp(false);
			for(var i:Number=minIndex; i<=maxIndex; i++){
				value[i] = true;
			}
			fireListSelectionEvent();
		}
	}

	public function addSelectionInterval(index0 : Number, index1 : Number) : Void {
		if (index0 < 0 || index1 < 0) {
            return;
        }
        if (getSelectionMode() == JList.SINGLE_SELECTION) {
            setSelectionInterval(index0, index1);
            return;
        }
        updateLeadAnchorIndices(index0, index1);
		var min:Number = Math.min(index0, index1);
		var max:Number = Math.max(index0, index1);
		var changed:Boolean = false;
		for(var i:Number=min; i<=max; i++){
			if(value[i] != true){
				value[i] = true;
				changed = true;
			}
		}
		minIndex = Math.min(min, minIndex);
		maxIndex = Math.max(max, maxIndex);
		if(changed){
			fireListSelectionEvent();
		}
	}

	public function removeSelectionInterval(index0 : Number, index1 : Number) : Void {
		if (index0 < 0 || index1 < 0) {
            return;
        }		
		var min:Number = Math.min(index0, index1);
		var max:Number = Math.max(index0, index1);
		min = Math.max(min, minIndex);
		max = Math.min(max, maxIndex);
		if(min > max){
			return;
		}
		
        updateLeadAnchorIndices(index0, index1);
        
		if(min == minIndex && max == maxIndex){
			clearSelectionImp(true);
			return;
		}else if(min > minIndex && max < maxIndex){
		}else if(min > minIndex && max == maxIndex){
			maxIndex = min - 1;
		}else{//min==minIndex && max<maxIndex
			minIndex = max + 1;
		}
		for(var i:Number=min; i<=max; i++){
			value[i] = undefined;
		}
		fireListSelectionEvent();
	}

	public function getMinSelectionIndex() : Number {
		if(isSelectionEmpty()){
			return -1;
		}else{
			return minIndex;
		}
	}

	public function getMaxSelectionIndex() : Number {
		return maxIndex;
	}

	public function isSelectedIndex(index : Number) : Boolean {
		return value[index] == true;
	}
	
	private function updateLeadAnchorIndices(archor:Number, lead:Number):Void {
		archorIndex = archor;
		leadIndex   = lead;
	}

	public function getAnchorSelectionIndex() : Number {
		return archorIndex;
	}

	public function setAnchorSelectionIndex(index : Number) : Void {
		archorIndex = index;
	}

	public function getLeadSelectionIndex() : Number {
		return leadIndex;
	}

	public function setLeadSelectionIndex(index : Number) : Void {
		leadIndex = index;
	}

	public function clearSelection() : Void {
		clearSelectionImp(true);
	}
	
	private function clearSelectionImp(fireEvent:Boolean):Void{
		value = [];
		if(fireEvent){
			fireListSelectionEvent();
		}
	}

	public function isSelectionEmpty() : Boolean {
		return minIndex > maxIndex;
	}
    /**
     * Sets the selection mode.  The default is
     * MULTIPLE_SELECTION.
     * @param selectionMode  one of three values:
     * <ul>
     * <li>SINGLE_SELECTION
     * <li>MULTIPLE_SELECTION
     * </ul>
     */
	public function setSelectionMode(selectionMode : Number) : Void {
		this.selectionMode = selectionMode;
	}

	public function getSelectionMode() : Number {
		return selectionMode;
	}

	public function addListSelectionListener(func : Function, obj : Object) : Object {
		return addEventListener(JList.ON_SELECTION_CHANGE, func, obj);
	}
	
	private function fireListSelectionEvent():Void{
		dispatchEvent(createEventObj(JList.ON_SELECTION_CHANGE));
	}
}
