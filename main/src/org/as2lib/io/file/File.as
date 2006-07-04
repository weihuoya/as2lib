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

import org.as2lib.core.BasicInterface;
import org.as2lib.data.type.Byte;

/**
 * {@code File} represents any file.
 *
 * <p>Any {@code File} has to have a location and a size.
 *
 * <p>{@link FileLoader} contains the functionality to load a certain
 * file.
 *
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.File extends BasicInterface {

	/**
	 * Returns the location of the {@code File} corresponding to the content.
	 *
	 * <p>Note: Might be the URI of the resource or null if its not requestable
	 * or the internal location corresponding to the instance path (if its without
	 * any connection to a real file).
	 *
	 * @return location of the resource related to the content
	 */
	public function getLocation(Void):String;

	/**
	 * Returns the size of the {@code File} in bytes.
	 *
	 * @return size of the {@code File} in bytes
	 */
	public function getSize(Void):Byte;
}