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

/**
 * Interface for a filter for a changelog list.
 * Add a implementation of this view to @see org.as2lib.tool.changelog.Config#addFilter.
 * It will act as filter for the list retruned by @see org.as2lib.tool.changelog.
 * 
 * @author Martin Heidegger
 */
interface org.as2lib.tool.changelog.EntryFilter extends BasicInterface {
	
	/**
	 * Method to filter a list
	 * 
	 * @param list List that should be filtered.
	 * @return list Filtered list.
	 */
	public function filter(list:Array):Array;
}