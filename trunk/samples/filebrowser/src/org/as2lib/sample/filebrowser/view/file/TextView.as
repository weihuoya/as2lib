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

import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.TextFile;
import org.as2lib.sample.filebrowser.view.file.AbstractFileView;
import org.as2lib.sample.filebrowser.view.file.FileView;

import flash.filters.DropShadowFilter;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.file.TextView extends AbstractFileView implements FileView {
	
	private var textField:TextField;
	
	public function TextView(Void) {
	}
	
	public function draw(movieClip:MovieClip):Void {
		super.draw(movieClip);
		createTextField();
	}
	
	private function createTextField(Void):Void {
		textField = getMovieClip().createTextField("text", 0, 0, 0, getWidth(), getHeight());
		textField.wordWrap = true;
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Verdana";
		textFormat.size = 11;
		textField.setNewTextFormat(textFormat);
		textField.filters = [new DropShadowFilter(2, 45, 0x000000, 100, 2, 2, 0.5, 15)];
	}
	
	public function onLoadComplete(fileLoader:FileLoader):Void {
		super.onLoadComplete(fileLoader);
		var textFile:TextFile = TextFile(fileLoader.getFile());
		textField.text = textFile.getContent();
	}
	
}