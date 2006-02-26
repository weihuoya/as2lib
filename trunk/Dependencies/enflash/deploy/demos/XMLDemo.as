import com.asual.enflash.EnFlash;
import com.asual.enflash.EnFlashConfiguration;

import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.TextInput;
import com.asual.enflash.ui.TextArea;
import com.asual.enflash.ui.UITheme;

import com.asual.enflash.utils.*;

class XMLDemo extends EnFlash {
	
	private var _themeTimer:Number = 0;
	private var _zoomTimer:Number = 0;
	private var _name:String = "XMLDemo";

	public static function main():Void {
		
		var conf = new EnFlashConfiguration();
		conf.xmlMode = true;
		conf.xmlFile = "xmldemo.xml";
		conf.themesLoading = false;
		conf.marginTop = (_root.enflash != undefined) ? 24 : 0;
		
		(new XMLDemo()).init(conf);
	}
	
	public function uiLoad(evt:Object):Void {
		
		logger = true;
		getById("infoLabel").value = "EnFlash " + _enflash.version + " XMLDemo";
		log("ui loaded");
	}
	
	public function themeSet(evt:Object):Void {
		
		log("theme setted (" + (getTimer() - _themeTimer) + ")");
		paneResize();
	}

	public function uiZoom(evt:Object):Void {
		
		log("zoom setted (" + (getTimer() - _zoomTimer) + ")");
		paneResize();
	}
	
	public function fileChange(evt:Object){

		switch(evt.menuItem.value){

			case "Exit":
				
				getURL("javascript:window.close()");
				break;

			case "View XML":
			
				var xml = XMLNodes.format(_enflash.getXML());
				xml = Strings.replace(xml, "&lt;p", "&lt;&#112;");
				xml = Strings.replace(xml, "p&gt;", "&#112;&gt;");
				xml = Strings.replace(xml, "<", "&lt;");
				xml = Strings.replace(xml, ">", "&gt;");

				var xmlWindow = getById("xmlWindow");
				var xmlLabel = getById("xmlLabel");
				xmlLabel.value = xml;
				
				xmlWindow.refresh();
				xmlWindow.vScrollPosition = 0;
				xmlWindow.setSize(ui.w - 400, ui.h - 300);
				xmlWindow.x = Math.round((ui.w - xmlWindow.w)/2);
				xmlWindow.y = Math.round((ui.h - xmlWindow.h)/2);								
				xmlWindow.open();
				
				break;
		}
	}

	public function randomComponent(type:Number) {

		switch(type){
			case 0:
				return new Label();
				break;
			case 1:
				return new Button();
				break;
			case 2:
				return new TextInput();
				break;
			case 3:
				return new TextArea();
				break;
		}
	}

	public function randomLabel(type:Number):String {

		switch(type){
			case 0:
				return "New Label";
				break;
			case 1:
				return "New Button";
				break;
			case 2:
				return "New TextInput";
				break;
			case 3:
				return "New TextArea";
				break;
		}
	}
	
	public function randomChange(evt:Object):Void {

		var pane = getById("mainPane");
		var type = Math.floor(Math.random()*4);
		var index = parseInt(Strings.replace(evt.menuItem.value, "At index ", ""));

		var component = randomComponent(type);
		component.value = randomLabel(type);
		pane.addItemAt(index, component);
	}
	
	public function createChange(evt:Object):Void {

		var component;
		var pane = getById("mainPane");
		var index = Math.round(Math.random()*3);
		
		switch(evt.menuItem.value){
			case "Label":
				component = new Label();
				component.value = "New Label";
				break;
			case "Button":
				component = new Button();
				component.value = "New Button";				
				break;
			case "TextInput":
				component = new TextInput();
				component.value = "New TextInput";					
				break;
			case "TextArea":
				component = new TextArea();
				component.value = "New TextArea";				
				break;
		}
		pane.addItem(component);
	}

	public function removeChange(evt:Object):Void {
		
		var pane = getById("mainPane");
		
		switch(evt.menuItem.value){
			case "All":
				pane.removeAll();
				break;
			case "Item at index 0":
				pane.removeItemAt(0).remove();
				break;
			case "Item at index 1":
				pane.removeItemAt(1).remove();
				break;
			case "Item at index 2":
				pane.removeItemAt(2).remove();
				break;
			case "Item at index 3":
				pane.removeItemAt(3).remove();
				break;
			case "Item at index 4":
				pane.removeItemAt(4).remove();
				break;
			case "Item at index 5":
				pane.removeItemAt(5).remove();
				break;
		}
	}

	public function themeLoad(evt:Object):Void {
		var item;
		var i:Number = evt.target.length;
		while(i--) {
			item = evt.target.getItem(i);
			if (item.value == ui.theme.name + " theme") {
				item.checked = true;
			} else {
				item.checked = false;
			}
		}
	}
	
	public function themeChange(evt:Object):Void {

		_themeTimer = getTimer();

		switch(evt.menuItem.value){
			case "Default theme":
				ui.theme = new UITheme(_enflash.conf.themesRepository + "default.swf");
				break;
			case "Oasis theme":
				ui.theme = new UITheme(_enflash.conf.themesRepository + "oasis.swf");
				break;
			case "Office theme":
				ui.theme = new UITheme(_enflash.conf.themesRepository + "office.swf");
				break;
			case "Robo theme":
				ui.theme = new UITheme(_enflash.conf.themesRepository + "robo.swf");
				break;
		}
	}

	public function zoomLoad(evt:Object):Void {

		var item;
		var i:Number = evt.target.length;
		while(i--) {
			item = evt.target.getItem(i);
			if (item.value == (ui.zoom + "%")) {
				item.checked = true;
			}
		}
	}
	
	public function zoomChange(evt:Object):Void {
		
		if (ui.zoom + "%" == evt.menuItem.value) return;

		_zoomTimer = getTimer();

		switch(evt.menuItem.value){
			case "80%":
				ui.zoom = 80;
				break;
			case "100%":
				ui.zoom = 100;
				break;
			case "120%":
				ui.zoom = 120;
				break;
			case "150%":
				ui.zoom = 150;
				break;
			case "200%":
				ui.zoom = 200;
				break;
		}
	}	

	public function helpChange(evt:Object):Void {

		switch(evt.menuItem.value){
			case "Homepage":
				getURL("http://www.asual.com/enflash/", "_blank");
				break;
			case "About":
				var dialog = getById("aboutDialog");
				dialog.open();
				break;
		}
	}

	public function editChange(evt:Object):Void {
		
		var pane = getById("infoPane");
		var label = getById("infoLabel");
		
		switch(evt.menuItem.value){
			case "Clear":
				label.value = "";
				pane.refresh();
				break;
			case "Copy":
				var cb = label.value.split("<br>").join("%0D%0A");
				cb = cb.split("\n").join("%0D%0A");
				System.setClipboard(unescape(cb));
				break;
			case "Cut":
				var cb = label.value.split("<br>").join("%0D%0A");
				cb = cb.split("\n").join("%0D%0A");
				System.setClipboard(unescape(cb));
				label.value = "";
				pane.refresh();
				break;
		}
	}

	public function optionsChange(evt:Object):Void {
		
		var pane = getById("infoPane");
		var label = getById("infoLabel");
		
		switch(evt.menuItem.value){
			case "Enable":
				label.enabled = evt.menuItem.checked;
				pane.refresh();
				break;
			case "Increase Font":
				label.fontSize++;
				pane.refresh();
				break;
			case "Decrease Font":
				label.fontSize--;
				pane.refresh();
				break;
		}
	}

	public function toggleButton(evt:Object):Void {

		var subHeading = getById("subHeading");
		subHeading.fontSize = (subHeading.fontSize == 20) ? 6 : 20;
		getById("mainPane").refresh();
	}

	public function okButton(evt:Object):Void {

		getById("userInput").enabled = true;
		getById("passInput").enabled = true;
		getById("textArea").enabled = true;
		getById("comboBox").enabled = true;
		getById("listBox").enabled = true;
	}

	public function cancelButton(evt:Object):Void {

		getById("userInput").enabled = false;
		getById("passInput").enabled = false;
		getById("textArea").enabled = false;
		getById("comboBox").enabled = false;
		getById("listBox").enabled = false;	
	}

	public function paneResize(evt:Object):Void {

		selectedUpdate();
		var pane = getById("leftPane");
		pane.getItem(2).h = pane.h - (pane.getItem(0).h + pane.getItem(3).h + 4);
		pane.refresh();
	}

	public function expandTree(evt:Object):Void {
		
		var tree = getById("projectTree");
		tree.autoRefresh = false;
		var i:Number = tree.length;
		while(i--) {
			tree.getItem(i).expanded = true;
		}
		tree.autoRefresh = true;
	}

	public function collapseTree(evt:Object):Void {
		
		var tree = getById("projectTree");
		tree.autoRefresh = false;
		var i:Number = tree.length;
		while(i--) {
			tree.getItem(i).expanded = false;
		}
		tree.autoRefresh = true;
		
		while (tree.selectedItem.depth != 0) {
			tree.selectedItem = tree.selectedItem.treeParent;
		}
	}	
	
	public function selectedUpdate():Void {
		
		var selectedItem = getById("projectTree").selectedItem;
		var info = "<br>id: " + selectedItem.ref;
		info += "<br>value: " + selectedItem.value;
		info += "<br>depth: " + selectedItem.depth;
		
		getById("selectedLabel").value = "<b>Selected Item</b>" + info;
	}

}