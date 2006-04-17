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
import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.navigation.ReleaseListener;
import org.as2lib.sample.filebrowser.view.View;
import org.as2lib.util.StringUtil;

import flash.filters.DropShadowFilter;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.navigation.Button extends AbstractView implements View {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.view.navigation.Button");
	
	private var linkage:String;
	private var releaseDistributorControl:EventDistributorControl;
	private var releaseDistributor:ReleaseListener;
	
	public function Button(Void) {
		releaseDistributorControl = new SimpleEventDistributorControl(ReleaseListener, false);
		releaseDistributor = releaseDistributorControl.getDistributor();
	}
	
	public function draw(movieClip:MovieClip):Void {
		if (!linkage) {
			throw new IllegalStateException("A linkage must be set before this button can be drawn.", this, arguments);
		}
		super.draw(movieClip);
		movieClip.attachMovie(linkage, "background", 0);
		movieClip._width = getWidth();
		movieClip._height = getHeight();
		var owner:Button = this;
		movieClip.onRelease = function() {
			owner["distributeRelease"]();
		};
		movieClip.blendMode = "multiply";
		movieClip.filters = [new DropShadowFilter(5, 45, 0x000000, 100, 2, 2, 0.9, 15)];
	}
	
	private function distributeRelease(Void):Void {
		try {
			releaseDistributor.onRelease(this);
		} catch (exception:org.as2lib.env.event.EventExecutionException) {
			if (logger.isErrorEnabled()) {
				logger.error("Distribution of event failed with exception:\n" + StringUtil.addSpaceIndent(exception.toString(), 2));
			}
		}
	}
	
	public function addReleaseListener(releaseListener:ReleaseListener):Void {
		releaseDistributorControl.addListener(releaseListener);
	}
	
	public function setLinkage(linkage:String):Void {
		if (!existsLinkage(linkage)) {
			throw new IllegalArgumentException("Argument 'linkage' [" + linkage + "] is not registered as linkage of a library symbol.", this, arguments);
		}
		this.linkage = linkage;
	}
	
	private function existsLinkage(linkage:String):Boolean {
		var movieClip:MovieClip = _root.attachMovie(linkage, "linkage", _root.getNextHighestDepth());
		if (movieClip == null) {
			return false;
		}
		movieClip.removeMovieClip();
		return true;
	}
	
}