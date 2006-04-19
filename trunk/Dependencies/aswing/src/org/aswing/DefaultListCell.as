/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.geom.Point;
import org.aswing.JLabel;
import org.aswing.JSharedToolTip;
import org.aswing.ListCell;
import org.aswing.UIManager;

/**
 * @author iiley
 */
class org.aswing.DefaultListCell implements ListCell {
	
	private var jlabel:JLabel;
	
	private var itemBGC:ASColor;
	private var itemSelectedBGC:ASColor;
	private var itemFGC:ASColor;
	private var itemSelectedFGC:ASColor;
	
	private var value:Object;
	private var selected:Boolean;
	
	private static var sharedToolTip:JSharedToolTip;
	
	public function DefaultListCell(){
		value = null;
		selected = false;
		if(sharedToolTip == null){
			sharedToolTip = new JSharedToolTip();
			sharedToolTip.setOffsetsRelatedToMouse(false);
			sharedToolTip.setOffsets(new Point(0, 0));
		}
	}
	
	public function setValue(value : Object) : Void {
		this.value = value;
		getJLabel().setText(value.toString());
		__resized();
	}

	public function getValue() : Object {
		return value;
	}

	public function setSelected(b : Boolean) : Void {
		if(selected != b){
			selected = b;
			if(b){
				getJLabel().setBackground(itemSelectedBGC);
				getJLabel().setForeground(itemSelectedFGC);
			}else{
				getJLabel().setBackground(itemBGC);
				getJLabel().setForeground(itemFGC);				
			}
			getJLabel().repaint();
		}
	}

	public function isSelected() : Boolean {
		return selected;
	}
	
	private function getJLabel():JLabel{
		if(jlabel == null){
			jlabel = new JLabel();
			jlabel.setHorizontalAlignment(JLabel.LEFT);
			itemBGC = UIManager.getColor("List.itemBackground");
			itemSelectedBGC = UIManager.getColor("List.itemSelectedBackground");
			itemFGC = UIManager.getColor("List.itemForeground");
			itemSelectedFGC = UIManager.getColor("List.itemSelectedForeground");
			jlabel.setBackground(itemBGC);
			jlabel.setForeground(itemFGC);
			jlabel.setOpaque(true);
			jlabel.setFocusable(false);
			jlabel.addEventListener(JLabel.ON_RESIZED, __resized, this);
		}
		return jlabel;
	}

	public function getListCellComponent() : Component {
		return getJLabel();
	}
	
	private function __resized():Void{
		if(getJLabel().getWidth() < getJLabel().getPreferredWidth()){
			getJLabel().setToolTipText(value.toString());
			JSharedToolTip.getSharedInstance().unregisterComponent(getJLabel());
			sharedToolTip.registerComponent(getJLabel());
		}else{
			getJLabel().setToolTipText(null);
			sharedToolTip.unregisterComponent(getJLabel());
		}
	}
}
