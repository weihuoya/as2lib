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
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.env.overload.Overload;
import org.as2lib.io.file.FileLoader;
import org.as2lib.io.file.LoadCompleteListener;
import org.as2lib.io.file.LoadErrorListener;
import org.as2lib.io.file.XmlFile;
import org.as2lib.io.file.XmlFileLoader;
import org.as2lib.sample.filebrowser.control.Scene;
import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.Background;
import org.as2lib.sample.filebrowser.view.ErrorView;
import org.as2lib.sample.filebrowser.view.file.FileView;
import org.as2lib.sample.filebrowser.view.navigation.Navigation;
import org.as2lib.sample.filebrowser.view.Title;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.FileBrowser extends BasicClass implements LoadCompleteListener, LoadErrorListener {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.FileBrowser");
	
	private var movieClip:MovieClip;
	private var title:Title;
	private var background:Background;
	private var scene:Scene;
	private var fileView:FileView;
	private var errorView:ErrorView;
	private var navigation:Navigation;
	
	public function FileBrowser(Void) {
	}
	
	public function init(Void):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Initializing file browser.");
		}
		movieClip = _root;
		title.draw(movieClip.createEmptyMovieClip("title", 0));
		background.draw(movieClip.createEmptyMovieClip("background", 1));
		fileView.draw(movieClip.createEmptyMovieClip("fileView", 2));
		errorView.draw(movieClip.createEmptyMovieClip("errorView", 3));
		navigation.draw(movieClip.createEmptyMovieClip("navigation", 4));
	}
	
	public function setTitle(title:Title):Void {
		this.title = title;
	}
	
	public function setBackground(background:Background):Void {
		this.background = background;
	}
	
	public function setScene(scene:Scene):Void {
		this.scene = scene;
	}
	
	public function setFileView(fileView:FileView):Void {
		this.fileView = fileView;
	}
	
	public function setErrorView(errorView:ErrorView):Void {
		this.errorView = errorView;
	}
	
	public function setNavigation(navigation:Navigation):Void {
		this.navigation = navigation;
	}
	
	public function browse():Void {
		var o:Overload = new Overload(this);
		o.addHandler([String], browseXml);
		o.addHandler([Array], browseFiles);
		o.forward(arguments);
	}
	
	public function browseXml(filesXml:String):Void {
		if (filesXml == null || filesXml == "") {
			throw new IllegalArgumentException("Argument 'filesXml' [" + filesXml + "] must not be 'null' nor 'undefined' nor an empty string.", this, arguments);
		}
		loadFilesXml(new File(filesXml));
	}
	
	public function browseFiles(files:Array):Void {
		if (!files) {
			throw new IllegalArgumentException("Argument 'files' [" + files + "] must not be 'null' nor 'undefined'.", this, arguments);
		}
		scene.removeAllFiles();
		scene.addAllFiles(files);
		if (scene.hasFiles()) {
			scene.showFirstFile();
		} else {
			if (logger.isWarningEnabled()) {
				logger.error("Argument 'files' [" + files + "] lists no files to browse.");
			}
			scene.showError("noFilesToBrowse");
		}
	}
	
	private function loadFilesXml(filesXml:File):Void {
		var xmlLoader:XmlFileLoader = new XmlFileLoader();
		xmlLoader.addListener(this);
		xmlLoader.load(filesXml.getPath());
	}
	
	public function onLoadComplete(fileLoader:FileLoader):Void {
		var xml:XML = XmlFile(fileLoader.getFile()).getXml();
		var files:Array = new Array();
		var fileNodes:Array = xml.lastChild.childNodes;
		for (var i:Number = 0; i < fileNodes.length; i++) {
			var fileNode:XMLNode = fileNodes[i];
			var filePath:String = fileNode.attributes.path;
			if (filePath != null) {
				try {
					var file:File = new File(filePath);
					files.push(file);
				} catch (exception:org.as2lib.sample.filebrowser.model.MalformedFilePathException) {
					if (logger.isErrorEnabled()) {
						logger.error(exception);
					}
				}
			} else {
				if (logger.isErrorEnabled()) {
					logger.error("Attribute 'path' is missing.");
				}
			}
		}
		if (logger.isInfoEnabled()) {
			logger.info("Loaded file '" + fileLoader.getUri() + "' successfully.");
		}
		browseFiles(files);
	}
	
	public function onLoadError(fileLoader:FileLoader, errorCode:String, error):Boolean {
		if (logger.isErrorEnabled()) {
			logger.error("Error on loading file '" + fileLoader.getUri() + "'.");
		}
		scene.showError("loadingFileFailed", [fileLoader.getUri()]);
		return false;
	}
	
}