﻿/*
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

import org.as2lib.data.io.file.File;
import org.as2lib.data.io.file.FileEventInfo;
import org.as2lib.env.event.EventListener;

/**
 * Listenerdefinition for a listener to fileevents.
 * 
 * @author Martin Heidegger
 * @see File#addListener
 */
interface org.as2lib.data.io.file.FileListener extends EventListener {
	
	/**
	 * Event to be published if the file was loaded.
	 * 
	 * @param fileInfo Informations about the file that was loaded.
	 */
	public function onLoad(fileInfo:FileEventInfo):Void;
	
	/**
	 * Event to be published if the file was not found.
	 * 
	 * @param fileInfo Informations about the file that was not found.
	 */
	public function onFileNotFound(fileInfo:FileEventInfo):Void;
	
	/**
	 * Event to be published if loading of the file is in progress.
	 * 
	 * @param fileInfo Informations about the file that is loading.
	 */
	public function onProgress(fileInfo:FileEventInfo):Void;
}