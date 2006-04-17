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

import org.as2lib.context.MessageSource;
import org.as2lib.context.MessageSourceAware;
import org.as2lib.core.BasicClass;
import org.as2lib.env.except.IllegalArgumentException;
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.ErrorView;
import org.as2lib.sample.filebrowser.view.file.ErrorListener;
import org.as2lib.sample.filebrowser.view.file.FileView;
import org.as2lib.sample.filebrowser.view.NoSuchFileException;
import org.as2lib.util.ArrayUtil;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.control.Scene extends BasicClass implements ErrorListener, MessageSourceAware {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.control.Scene");
	
	private var fileView:FileView;
	private var errorView:ErrorView;
	private var messageSource:MessageSource;
	private var files:Array;
	private var currentPosition:Number;
	
	public function Scene(Void) {
		files = new Array();
		currentPosition = -1;
	}
	
	public function setMessageSource(messageSource:MessageSource):Void {
		this.messageSource = messageSource;
	}
	
	public function setFileView(fileView:FileView):Void {
		if (!fileView) {
			throw new IllegalArgumentException("Argument 'fileView' must not be 'null' nor 'undefined.", this, arguments);
		}
		this.fileView = fileView;
		fileView.addErrorListener(this);
	}
	
	public function setErrorView(errorView:ErrorView):Void {
		if (!errorView) {
			throw new IllegalArgumentException("Argument 'errorView' [" + errorView + "] must not be 'null' nor 'undefined'", this, arguments);
		}
		this.errorView = errorView;
	}
	
	public function addFile(file:File):Void {
		if (file) {
			files.push(file);
		}
	}
	
	public function addAllFiles(files:Array):Void {
		for (var i:Number = 0; i < files.length; i++) {
			addFile(File(files[i]));
		}
	}
	
	public function removeFile(file:File):Void {
		if (file) {
			ArrayUtil.removeAllOccurances(files, file);
		}
	}
	
	public function removeAllFiles(Void):Void {
		files = new Array();
	}
	
	public function hasFiles(Void):Boolean {
		return (files.length > 0);
	}
	
	public function hasNextFile(Void):Boolean {
		return (currentPosition < files.length - 1);
	}
	
	public function showNextFile(Void):Void {
		if (!hasNextFile()) {
			throw new NoSuchFileException("There is no next file to show.", this, arguments);
		}
		showFile(++currentPosition);
	}
	
	public function showFirstFile(Void):Void {
		if (files.length == 0) {
			throw new NoSuchFileException("There is no first file to show.", this, arguments);
		}
		showFile(0);
	}
	
	public function hasPreviousFile(Void):Boolean {
		return (currentPosition > 0);
	}
	
	public function showPreviousFile(Void):Void {
		if (!hasPreviousFile()) {
			throw new NoSuchFileException("There is no previous file to show.", this, arguments);
		}
		showFile(--currentPosition);
	}
	
	public function showLastFile(Void):Void {
		if (files.length == 0) {
			throw new NoSuchFileException("There is no last file to show.", this, arguments);
		}
		showFile(files.length - 1);
	}
	
	private function showFile(filePosition:Number):Void {
		currentPosition = filePosition;
		errorView.hide();
		var file:File = files[filePosition];
		try {
			fileView.show(file);
		}
		catch (exception:org.as2lib.sample.filebrowser.view.file.UnsupportedFileExtensionException) {
			//logger.info(org.as2lib.env.except.StackTraceAspect.getStackTrace());
			/*if (logger.isErrorEnabled()) {
				logger.error(exception);
			}*/
			if (logger.isErrorEnabled()) {
				logger.error("File extension '" + file.getExtension() + "' is not supported.");
			}
			showError(exception.getErrorCode(), [file.getExtension()]);
		}
	}
	
	public function showError(errorCode:String, args:Array):Void {
		var message:String;
		try {
			message = messageSource.getMessage(errorCode, args);
		}
		catch (exception:org.as2lib.context.NoSuchMessageException) {
			message = messageSource.getMessage("unknownError");
		}
		errorView.showError(message);
	}
	
	public function onError(errorCode:String, args:Array):Void {
		showError(errorCode, args);
	}
	
}