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

import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.navigation.Button;
import org.as2lib.sample.filebrowser.view.View;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.navigation.Navigation extends AbstractView implements View {
	
	private var nextButton:Button;
	private var previousButton:Button;
	
	public function Navigation(Void) {
	}
	
	public function draw(movieClip:MovieClip):Void {
		super.draw(movieClip);
		nextButton.draw(movieClip.createEmptyMovieClip("next", 0));
		previousButton.draw(movieClip.createEmptyMovieClip("previous", 1));
	}
	
	public function setNextButton(nextButton:Button):Void {
		this.nextButton = nextButton;
	}
	
	public function setPreviousButton(previousButton:Button):Void {
		this.previousButton = previousButton;
	}
	
}