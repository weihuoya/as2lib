import org.aswing.Component;
import org.aswing.JList;
import org.aswing.ListCell;
import org.aswing.LookAndFeel;
import org.aswing.plaf.ListUI;
import org.aswing.util.Delegate;

/**
 * @author firdosh
 */
class org.aswing.plaf.basic.BasicListUI extends ListUI{
	
	private var list:JList;
	private var listListener:Object;
	
	public function BasicListUI(){
		//super();
	}
	
    public function installUI(c:Component):Void {
        list = JList(c);
        installDefaults(list);
        installListeners(list);
    }
    
    private function installDefaults(c:JList):Void {
    	var pp:String = "List.";
        LookAndFeel.installColorsAndFont(c, pp + "background", pp + "foreground", pp + "font");
        LookAndFeel.installBorder(c, "List.border");
        LookAndFeel.installBasicProperties(c, pp);
    }
    private function installListeners(c:JList):Void{
    	listListener = new Object();
    	listListener[JList.ON_ITEM_PRESS] = Delegate.create(this, __onItemPress);
    	listListener[JList.ON_KEY_DOWN]   = Delegate.create(this, __onKeyDown);
    	listListener[JList.ON_FOCUS_LOST] = Delegate.create(this, __onFocusLost);
    	listListener[JList.ON_SELECTION_CHANGE] = Delegate.create(this, __onSelectionChanged);
    	list.addEventListener(listListener);
    }
	
	public function uninstallUI(c:Component):Void {
        var p:JList = JList(c);
        uninstallDefaults(p);
        uninstallListeners(p);
    }
    
    private function uninstallDefaults(p:JList):Void {
        LookAndFeel.uninstallBorder(p);
    }
    private function uninstallListeners(p:JList):Void{
    	list.removeEventListener(listListener);
    }
    
    private var paintFocusedIndex:Number;
    private var paintFocusedCell:ListCell;
    public function paintFocus(c:Component):Void{
    	super.paintFocus(c);
    	paintCurrentCellFocus();
    }
	public function clearFocus(c:Component):Void{
		super.clearFocus(c);
		clearCellFocusGraphics();
	}
    
    private function paintCurrentCellFocus():Void{
    	paintCellFocus(paintFocusedCell.getListCellComponent());
    }
    
    private function paintCellFocusWithIndex(index:Number):Void{
    	clearCellFocusGraphics();
    	if(index < 0 || index >= list.getModel().getSize()){
    		return;
    	}
		paintFocusedCell = list.getCellByIndex(index);
		paintFocusedIndex = index;
		paintCellFocus(paintFocusedCell.getListCellComponent());
    }
    
    private function paintCellFocus(cellComponent:Component):Void{
    	super.paintFocus(cellComponent);
    }
    
    private function clearCellFocusGraphics():Void{
    	paintFocusedCell.getListCellComponent().clearFocusGraphics();
    }
    
    private function getIntervalSelectionKey():Number{
    	return Key.SHIFT;
    }
    private function getAdditionSelectionKey():Number{
    	return Key.CONTROL;
    }
    //----------
    private function __onFocusLost():Void{
    	clearCellFocusGraphics();
    }
    private function __onKeyDown():Void{
    	var code:Number = Key.getCode();
    	var dir:Number = 0;
    	if(code == Key.UP){
    		dir = -1;
    	}else if(code == Key.DOWN){
    		dir = 1;
    	}
    	trace("paintFocusedIndex = " + paintFocusedIndex);
    	if(paintFocusedIndex < -1 || paintFocusedIndex == undefined){
    		paintFocusedIndex = -1;
    	}else if(paintFocusedIndex > list.getModel().getSize()){
    		paintFocusedIndex = list.getModel().getSize();
    	}
    	var index:Number = paintFocusedIndex + dir;
    	if(index < 0 || index >= list.getModel().getSize()){
    		return;
    	}
    	if(dir != 0){
    		if(Key.isDown(getIntervalSelectionKey())){
				var archor:Number = list.getAnchorSelectionIndex();
				if(archor < 0){
					archor = index;
				}
				list.setSelectionInterval(archor, index);
    		}else if(Key.isDown(getAdditionSelectionKey())){
    		}else{
		    	list.setSelectionInterval(index, index);
    		}
    		//this make sure paintFocusedCell rememberd
    		paintCellFocusWithIndex(index);
		    list.ensureIndexIsVisible(index);
    	}else{
    		if(code == Key.SPACE){
		    	list.addSelectionInterval(index, index);
    			//this make sure paintFocusedCell rememberd
    			paintCellFocusWithIndex(index);
		    	list.ensureIndexIsVisible(index);
    		}
    	}
    }
    private function __onSelectionChanged():Void{
    	paintCellFocusWithIndex(list.getLeadSelectionIndex());
    }
    
    private function __onItemPress(source:JList, value:Object, cell:ListCell):Void{
		var index:Number = list.getItemIndexByCell(cell);
		if(list.getSelectionMode() == JList.MULTIPLE_SELECTION){
			if(Key.isDown(getIntervalSelectionKey())){
				var archor:Number = list.getAnchorSelectionIndex();
				if(archor < 0){
					archor = index;
				}
				list.setSelectionInterval(archor, index);
			}else if(Key.isDown(getAdditionSelectionKey())){
				if(!list.isSelectedIndex(index)){
					list.addSelectionInterval(index, index);
				}else{
					list.removeSelectionInterval(index, index);
				}
			}else{
				list.setSelectionInterval(index, index);
			}
		}else{
			list.setSelectionInterval(index, index);
		}
    }
}