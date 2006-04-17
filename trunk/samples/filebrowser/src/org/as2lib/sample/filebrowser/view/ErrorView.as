/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.View;

import flash.filters.DropShadowFilter;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.ErrorView extends AbstractView implements View {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.view.ErrorView");
	
	private var textField:TextField;
	
	public function ErrorView(Void) {
	}
	
	public function draw(movieClip:MovieClip):Void {
		super.draw(movieClip);
		initTextField();
		movieClip.filters = [new DropShadowFilter(5, 45, 0x000000, 100, 2, 2, 0.9, 15)];
	}
	
	private function initTextField(Void):Void {
		textField = movieClip.createTextField("text", 0, 0, 0, getWidth(), getHeight());
		textField.background = true;
		textField.backgroundColor = 0x000000;
		textField.textColor = 0xFFFFFF;
		textField.selectable = false;
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Verdana";
		textFormat.size = 12;
		textField.setNewTextFormat(textFormat);
	}
	
	public function showError(errorMessage:String):Void {
		if (errorMessage == null || errorMessage == "") {
			if (logger.isWarningEnabled()) {
				logger.warning("Showing empty error message.");
			}
		}
		textField.text = errorMessage;
		movieClip._visible = true;
	}
	
	public function hide(Void):Void {
		movieClip._visible = false;
		textField.text = "";
	}
	
}