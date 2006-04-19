import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.JLabel;
import org.aswing.ListCell;
import org.aswing.UIManager;

import test.CircleIcon;
import test.ColorIcon;

/**
 * @author iiley
 */
class test.list.IconListCell implements ListCell {
	
	
	private var jlabel:JLabel;
	
	private var itemBGC:ASColor;
	private var itemSelectedBGC:ASColor;
	private var itemFGC:ASColor;
	private var itemSelectedFGC:ASColor;
	
	private var value:Object;
	private var selected:Boolean;
	
	public function IconListCell(){
		value = null;
		selected = false;
	}
	
	private static var iconPaths:Array = ["pic1","pic2","pic3"];
	
	public function setValue(value : Object) : Void {
		if(this.value != value){
			this.value = value;
			getJLabel().setText(value.toString());
			if(Math.random() > 0.5){
				getJLabel().setIcon(new ColorIcon(null, new ASColor(Math.random()*0xFFFFFF), 10+Math.random()*30, 10+Math.random()*30));
			}else{
				getJLabel().setIcon(new CircleIcon(new ASColor(Math.random()*0xFFFFFF), 10+Math.random()*30, 10+Math.random()*30));
			}
		}
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
		}
		return jlabel;
	}

	public function getListCellComponent() : Component {
		return getJLabel();
	}

}