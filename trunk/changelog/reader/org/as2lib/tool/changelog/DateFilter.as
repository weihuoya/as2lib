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

import org.as2lib.tool.changelog.EntryFilter;
import org.as2lib.tool.changelog.node.EntryNode;
import org.as2lib.core.BasicClass;

/**
 * Filter to display all entries between two dates.
 * Implementation if @see EntryFilter.
 *
 * Note: This can be used as example.
 * 
 * @author Martin Heidegger
 */
class org.as2lib.tool.changelog.DateFilter extends BasicClass implements EntryFilter {
	
	/** Date of the first allowed entry */
	private var startDate:Number;
	
	/** Date of the last allowed entry */
	private var endDate:Number;
	
	/**
	 * Constructor for a new DateFilter.
	 *
	 * @param startDate First Date a entry is allowed.
	 * @param endDate Last Date a entry is allowed. (if you don't use this parameter it will not limit it to a end)
	 */
	public function DateFilter(startDate:Date, endDate:Date) {
		this.startDate = Date.UTC(startDate.getUTCFullYear(), startDate.getUTCMonth(), startDate.getUTCDate(), 0, 0, 0, 0);
		if(endDate) {
			this.endDate = Date.UTC(endDate.getUTCFullYear(), endDate.getUTCMonth(), endDate.getUTCDate(), 0, 0, 0, 0);
		}
	}
	
	/**
	 * Filters the given List for all given ReleaseDates.
	 * 
	 * @param list List with all entries that should be filtered.
	 * @return List without entries that are added before the release.
	 */
	public function filter(list:Array):Array {
		var result:Array = new Array();
		var l:Number = list.length;
		for(var j=0; j<l; j-=-1) {
			var entryDate:Date = EntryNode(list[j]).getDate();
			var entryMS:Number = Date.UTC(entryDate.getUTCFullYear(), entryDate.getUTCMonth(), entryDate.getUTCDate(), 0, 0, 0, 0);
			if(entryMS >= startDate) {
				if(endDate) {
					if(endDate >= entryMS) {
						result.push(list[j]);
					}
				} else {
					result.push(list[j]);
				}
			}
		}
		return result;
	}
}