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

import org.as2lib.io.file.ResourceLoader;

/**
 * {@code LoadStartListener} can be implemented if its necessary to listen
 * to {@code onLoadStart} events of {@link ResourceLoader}s.
 * 
 * @author Martin Heidegger
 * @version 1.0
 */
interface org.as2lib.io.file.LoadStartListener {
	
	/**
	 * Event to be published if the {@code ResourceLoader} started a request.
	 * 
	 * @param resourceLoader {@code ResourceLoader} that was started
	 */
	public function onLoadStart(resourceLoader:ResourceLoader):Void;
}