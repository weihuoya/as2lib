/*
 Copyright aswing.org, see the LICENCE.txt.
*/
 
import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.JLabel;
import org.aswing.UIManager;

import org.aswing.ListCell;

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
	
	public function DefaultListCell(){
		value = null;
		selected = false;
	}
	
	public function setValue(value : Object) : Void {
		this.value = value;
		getJLabel().setText(value.toString());
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
