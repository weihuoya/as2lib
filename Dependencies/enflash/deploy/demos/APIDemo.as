import com.asual.enflash.EnFlash;
import com.asual.enflash.EnFlashConfiguration;

import com.asual.enflash.ui.Component;
import com.asual.enflash.ui.Button;
import com.asual.enflash.ui.ComboBox;
import com.asual.enflash.ui.Dialog;
import com.asual.enflash.ui.Label;
import com.asual.enflash.ui.LabeledTextArea;
import com.asual.enflash.ui.LabeledTextInput;
import com.asual.enflash.ui.ListBox;
import com.asual.enflash.ui.MenuBar;
import com.asual.enflash.ui.RadioButton;
import com.asual.enflash.ui.ScrollPane;
import com.asual.enflash.ui.UITheme;

class APIDemo extends EnFlash {

	private var _name:String = "APIDemo";

	public static function main():Void {

		var conf = new EnFlashConfiguration();
		conf.marginTop = (_root.enflash != undefined) ? 24 : 0;

		(new APIDemo()).init(conf);
	}

	public function init(conf:EnFlashConfiguration):Void {

		super.init(conf);
		ui.addEventListener("themeload", this, createUI);
	}

	public function createUI():Void {

		var bar = _ui.addBar(new MenuBar());
		
		var menu0 = bar.addItem();
		menu0.value = "File";
		ui.addShortcut(menu0, "Alt+F");
		
		var item = menu0.addItem();
		item.value = "Set Theme";
		ui.addShortcut(item, "Ctrl+T");

		item = menu0.addItem();
		item.value = "Set Zoom";
		ui.addShortcut(item, "Ctrl+Z");

		menu0.addSeparator();

		item = menu0.addItem();
		item.value = "Exit";
		ui.addShortcut(item, "Ctrl+F4");

		menu0.addEventListener("change", this, _fileChange);
	
		var menu1 = bar.addItem();
		menu1.value = "Help";
		ui.addShortcut(menu1, "Alt+H");
		
		item = menu1.addItem();
		item.value = "About";

		menu1.addSeparator();
		
		item = menu1.addItem();
		item.type = "check";
		item.checked = false;
		item.value = "Logger";
		ui.addShortcut(item, "Shift+L");

		menu1.addEventListener("change", this, _helpChange);		

		var pane = _ui.addPane(new ScrollPane("mainPane"));

		var label = pane.addItem(new Label());
		label.align = "right";
		label.display = "block";
		label.setStyle(".text", {color: "#000000", textAlign: "right"});
		label.setStyle("a", {color: "#285090", textDecoration: "underline"});
		label.setStyle("a:hover", {color: "#A30000"});
		label.value = "<p class=\"text\">&nbsp; <a href=\"#\">Home</a> | <a href=\"#\">Contact</a></p>";

		var title = pane.addItem(new Label());
		title.fontSize = 8;
		title.value = "Registration Form";

		var textInput = pane.addItem(new LabeledTextInput());
		textInput.clear = true;		
		textInput.w = 14;
		textInput.label = "Username:";

		textInput = pane.addItem(new LabeledTextInput());
		textInput.w = 14;
		textInput.label = "Password:";

		var textArea = pane.addItem(new LabeledTextArea());
		textArea.w = 29;
		textArea.clear = true;
		textArea.label = "Message:";
		textArea.size = 4;

		var comboLabel = pane.addItem(new Label());
		comboLabel.clear = true;
		comboLabel.value = "Select your age:";
		comboLabel.wordWrap = false;
		comboLabel.margin = {bottom: -0.5};

		var comboBox = pane.addItem(new ComboBox());
		comboBox.w = 29;
		comboBox.clear = true;
		comboBox.addItem().value = "13-18";
		comboBox.addItem().value = "19-25";
		comboBox.addItem().value = "26-32";
		comboBox.addItem().value = "33-40";
		comboBox.addItem().value = "41-50";
		comboBox.selectedIndex = 0;

		var listLabel = pane.addItem(new Label());
		listLabel.clear = true;
		listLabel.value = "Select your current position:";
		listLabel.wordWrap = false;
		listLabel.margin = {bottom: -0.5};
		
		var listBox = pane.addItem(new ListBox());
		listBox.w = 29;
		listBox.clear = true;
		listBox.size = 4;
		listBox.addItem().value = "Database Engineer";
		listBox.addItem().value = "Flash Developer";
		listBox.addItem().value = "Information Architect";
		listBox.addItem().value = "Quality Assurance";
		listBox.addItem().value = "Software Engineer";
		listBox.addItem().value = "Technical Writer";
		listBox.addItem().value = "Web Designer";
		listBox.margin = {bottom: 2};

		var submitButton = pane.addItem(new Button());
		submitButton.w = 8;
		submitButton.clear = true;
		submitButton.value = "Submit";

		var cancelButton = pane.addItem(new Button());
		cancelButton.w = 8;
		cancelButton.value = "Cancel";

		_ui.removeEventListener("themeload", this, createUI);

		log("ui created");
	}

	private function _fileChange(evt:Object){

		switch(evt.menuItem.value){

			case "Set Theme":
			
				var themeDialog = getById("themeDialog");
				if (themeDialog == undefined) {

					themeDialog = new Dialog("themeDialog");
					_ui.addDialog(themeDialog);

					themeDialog.title = "Set Theme";

					var themePane = themeDialog.addPane(new ScrollPane("themePane"));
					themePane.opaque = true;

					var defaultTheme = new RadioButton();
					defaultTheme.clear = true;
					defaultTheme.selected = (_ui.theme.name == "Default") ? true : false;
					defaultTheme.label = "Default Theme";
					defaultTheme.group = "themeGroup";
					themePane.addItem(defaultTheme);

					var oasisTheme = new RadioButton();
					oasisTheme.clear = true;
					oasisTheme.selected = (_ui.theme.name == "Oasis") ? true : false;
					oasisTheme.label = "Oasis Theme";
					oasisTheme.group = "themeGroup";
					themePane.addItem(oasisTheme);

					var officeTheme = new RadioButton();
					officeTheme.clear = true;
					officeTheme.selected = (_ui.theme.name == "Office") ? true : false;
					officeTheme.label = "Office Theme";
					officeTheme.group = "themeGroup";
					themePane.addItem(officeTheme);

					var roboTheme = new RadioButton();
					roboTheme.clear = true;
					roboTheme.selected = (_ui.theme.name == "Robo") ? true : false;
					roboTheme.label = "Robo Theme";
					roboTheme.group = "themeGroup";
					themePane.addItem(roboTheme);

					var okButton = new Button();
					okButton.clear = true;
					okButton.float = "right";
					okButton.value = "OK";
					okButton.w = 8;
					okButton.margin = {top: 1, bottom: 1};					
					okButton.onrelease = createDelegate(this, _okTheme);
					themePane.addItem(okButton);

					_ui.addEventListener("enterframe", this, _dialogLoad, {dialog: themeDialog, components: [themePane.ref, defaultTheme.ref, oasisTheme.ref, officeTheme.ref, roboTheme.ref, okButton.ref]});
				
				} else {
			
					themeDialog.getPane(0).getItem(0).focus();
					themeDialog.refresh();
					themeDialog.open();				
				}
				break;

			case "Set Zoom":

				var zoomDialog = getById("zoomDialog");
				if (zoomDialog == undefined) {
					zoomDialog = new Dialog("zoomDialog");
					_ui.addDialog(zoomDialog);
					
					zoomDialog.title = "Set Zoom";

					var zoomPane = zoomDialog.addPane(new ScrollPane("zoomPane"));
					zoomPane.opaque = true;

					var zoomBox = new ListBox();
					zoomBox.display = "block";
					zoomBox.size = 4;
					zoomPane.addItem(zoomBox);

					zoomBox.addItem().value = "80%";
					zoomBox.addItem().value = "100%";
					zoomBox.addItem().value = "120%";
					zoomBox.addItem().value = "125%";
					zoomBox.addItem().value = "150%";
					zoomBox.addItem().value = "175%";

					var item;
					var i = zoomBox.length;
					while(i--) {
						item = zoomBox.getItem(i)
						if (parseInt(item.value) == _ui.zoom) {
							item.selected = true;
						}
					}

					var okButton = new Button();
					okButton.clear = true;
					okButton.value = "OK";
					okButton.float = "right";
					okButton.w = 8;
					okButton.margin = {top: 1, bottom: 1};					
					okButton.onrelease = createDelegate(this, _okZoom);
					zoomPane.addItem(okButton);

					_ui.addEventListener("enterframe", this, _dialogLoad, {dialog: zoomDialog, components: [zoomPane.ref, zoomBox.ref, okButton.ref]});
				
				} else {
			
					zoomDialog.getPane(0).getItem(0).focus();
					zoomDialog.refresh();
					zoomDialog.open();				
				}
				break;

			case "Exit":
				getURL("javascript:window.close()");
				break;
		}
	}

	private function _helpChange(evt:Object){

		switch(evt.menuItem.value){
			
			case "About":
			
				var aboutDialog = getById("aboutDialog");
				if (aboutDialog == undefined) {

					aboutDialog = _ui.addDialog(new Dialog("aboutDialog"));
					aboutDialog.title = "About";
					aboutDialog.ratio = false;
					
					var aboutPane = aboutDialog.addPane(new ScrollPane("aboutPane"));
					aboutPane.padding = 0;
					
					var aboutComponent = new Component();
					aboutComponent.swf = "../assets/about.swf";
					aboutComponent.margin = 0;
					aboutComponent.zoom = false;
					aboutComponent.setSize(360, 130);
					
					aboutPane.addItem(aboutComponent);				

					var aboutLabel = new Label();
					aboutLabel.value = "© 2004-2005 Asual DZZD.<br />";
					aboutLabel.value += "<a href=\"http://www.asual.com/enflash\">http://www.asual.com/enflash</a>";
					aboutLabel.margin = {top: 0, right: 2, bottom: 4, left: 2};

					aboutPane.addItem(aboutLabel);				

					_ui.addEventListener("enterframe", this, _dialogLoad, {dialog: aboutDialog, components: [aboutPane.ref, aboutComponent.ref]});
				
				} else {
			
					aboutDialog.refresh();
					aboutDialog.open();				
				}
				break;
			case "Logger":
				logger = evt.menuItem.checked;
				getById("EnFlashDebugWindow").addEventListener("close", this, _loggerClose);
				break;
		}
	}

	private function _loggerClose(evt:Object):Void {
		_ui.getBar(0).getItem(1).getItem(2).checked = false;		
	}
	
	private function _okTheme(evt:Object):Void {
					
		getById("themeDialog").close();
		var pane = getById("themePane");
		
		var selected, item;
		var i = pane.length;
		while(i--) {
			item = pane.getItem(i);
			if (item.toString() == "RadioButton" && item.selected) {
				selected = item;
				break;
			}
		}

		switch (selected.label) {
			case "Default Theme":
				_ui.theme = new UITheme(_enflash.conf.themesRepository + "default.swf");
				break;
			case "Oasis Theme":
				_ui.theme = new UITheme(_enflash.conf.themesRepository + "oasis.swf");
				break;
			case "Office Theme":
				_ui.theme = new UITheme(_enflash.conf.themesRepository + "office.swf");
				break;
			case "Robo Theme":
				_ui.theme = new UITheme(_enflash.conf.themesRepository + "robo.swf");
				break;				
		}					
	}

	private function _dialogLoad(evt:Object):Void {

		var i:Number = evt.components.length;
		while(i--) {
			if (!getByRef(evt.components[i]).loaded) {
				return;
			}
		}

		var dialog = evt.dialog;
		var pane = dialog.getPane(0);
		
		pane.getItem(0).focus();
		pane.refresh();
		
		dialog.refresh();
		dialog.open();
		
		_ui.removeEventListener("enterframe", this);
	}	

	private function _okZoom(evt:Object):Void {
					
		getById("zoomDialog").close();
		var pane = getById("zoomPane");
	
		_ui.zoom = parseInt(pane.getItem(0).selectedItem.value);
	}

}