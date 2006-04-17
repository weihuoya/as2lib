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

import org.as2lib.env.event.distributor.EventDistributorControl;
import org.as2lib.env.event.distributor.SimpleEventDistributorControl;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.except.IllegalStateException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.file.ErrorListener;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.file.AbstractFileView extends AbstractView implements LoadErrorListener, LoadCompleteListener {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.view.file.AbstractFileView");
	
	private var fileLoader:FileLoader;
	private var errorDistributorControl:EventDistributorControl;
	private var errorDistributor:ErrorListener;
	
	private function AbstractFileView(Void) {
		errorDistributorControl = new SimpleEventDistributorControl(ErrorListener, false);
		errorDistributor = errorDistributorControl.getDistributor();
	}
	
	public function show(file:File):Void {
		if (!fileLoader) {
			throw new IllegalStateException("A file loader must be set before this file view can show files.", this, arguments);
		}
		getMovieClip()._visible = true;
		fileLoader.load(file.getPath());
	}
	
	public function hide(Void):Void {
		getMovieClip()._visible = false;
	}
	
	public function addErrorListener(errorListener:ErrorListener):Void {
		errorDistributorControl.addListener(errorListener);
	}
	
	private function setFileLoader(fileLoader:FileLoader):Void {
		if (!fileLoader) {
			throw new IllegalArgumentException("Argument 'fileLoader' [" + fileLoader + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		this.fileLoader = fileLoader;
		fileLoader.addListener(this);
	}
	
	private function getFileLoader(Void):FileLoader {
		return fileLoader;
	}
	
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		if (logger.isErrorEnabled()) {
			logger.error("Error on loading file '" + fileLoader.getUri() + "'.");
		}
		errorDistributor.onError("loadingFileFailed", [fileLoader.getUri()]);
		return false;
	}
	
	public function onLoadComplete(fileLoader:FileLoader):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Loaded file '" + fileLoader.getUri() + "' successfully.");
		}
	}

}