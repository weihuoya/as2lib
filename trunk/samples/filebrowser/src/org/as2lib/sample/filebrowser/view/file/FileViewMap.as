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

import org.as2lib.core.BasicClass;
import org.as2lib.data.holder.Map;
import org.as2lib.data.holder.map.PrimitiveTypeMap;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.file.ErrorListener;
import org.as2lib.sample.filebrowser.view.file.FileView;
import org.as2lib.sample.filebrowser.view.file.UnsupportedFileExtensionException;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.file.FileViewMap extends BasicClass implements FileView {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.view.file.FileViewMap");
	
	private var fileViews:Map;
	private var defaultFileView:FileView;
	
	public function FileViewMap(Void) {
		fileViews = new PrimitiveTypeMap();
	}
	
	public function draw(movieClip:MovieClip):Void {
		defaultFileView.draw(movieClip.createEmptyMovieClip("defaultFileView", 0));
		var views:Array = fileViews.getValues();
		for (var i:Number = 0; i < views.length; i++) {
			var fileView:FileView = views[i];
			fileView.draw(movieClip.createEmptyMovieClip("fileView" + i, i + 1));
		}
	}
	
	public function putFileView(fileExtension:String, fileView:FileView):Void {
		if (fileExtension == null || fileExtension == "") {
			throw new IllegalArgumentException("Argument 'fileExtension' [" + fileExtension + "] must not be 'null' nor 'undefined' nor an empty string", this, arguments);
		}
		if (!fileView) {
			if (logger.isInfoEnabled()) {
				logger.info("Removing file view for file extension '" + fileExtension + "'.");
			}
			removeFileView(fileExtension);
			return;
		}
		fileViews.put(fileExtension, fileView);
	}
	
	public function removeFileView(fileExtension:String):Void {
		if (fileExtension == null || fileExtension == "") {
			throw new IllegalArgumentException("Argument 'fileExtension' [" + fileExtension + "] must not be 'null' nor 'undefined' nor an empty string", this, arguments);
		}
		fileViews.remove(fileExtension);
	}
	
	public function findFileView(fileExtension:String):FileView {
		if (fileExtension == null || fileExtension == "") {
			throw new IllegalArgumentException("Argument 'fileExtension' [" + fileExtension + "] must not be 'null' nor 'undefined' nor an empty string", this, arguments);
		}
		if (!fileViews.containsKey(fileExtension)) {
			return defaultFileView;
		}
		return fileViews.get(fileExtension);
	}
	
	public function setDefaultFileView(defaultFileView:FileView):Void {
		this.defaultFileView = defaultFileView;
	}
	
	public function getDefaultFileView(Void):FileView {
		return defaultFileView;
	}
	
	public function show(file:File):Void {
		if (!file) {
			throw new IllegalArgumentException("Argument 'file' [" + file + "] must not be 'null' nor 'undefined'.", this, arguments);
		}
		hide();
		var fileExtension:String = file.getExtension();
		var fileView:FileView = findFileView(fileExtension);
		if (!fileView) {
			throw new UnsupportedFileExtensionException("File extension [" + fileExtension + "] of file [" + file.getPath() + "] is not supported.", this, arguments);
		}
		fileView.show(file);
	}
	
	public function hide(Void):Void {
		defaultFileView.hide();
		var views:Array = fileViews.getValues();
		for (var i:Number = 0; i < views.length; i++) {
			var fileView:FileView = views[i];
			fileView.hide();
		}
	}
	
	public function addErrorListener(errorListener:ErrorListener):Void {
		defaultFileView.addErrorListener(errorListener);
		var views:Array = fileViews.getValues();
		for (var i:Number = 0; i < views.length; i++) {
			var fileView:FileView = views[i];
			fileView.addErrorListener(errorListener);
		}
	}
	
}