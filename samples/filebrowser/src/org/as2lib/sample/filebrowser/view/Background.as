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

import org.as2lib.env.reflect.Delegate;
import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.View;

import flash.display.BitmapData;
import flash.geom.Rectangle;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.Background extends AbstractView implements View {
	
	private var image:MovieClip;
	private var bitmapData:BitmapData;
	private var stepSize:Number;
	private var pixelSize:Number;
	private var maxPixelSize:Number;
	private var minPixelSize:Number;
	private var intervalId:Number;
	
	public function Background(Void) {
		maxPixelSize = 40;
		minPixelSize = 12;
	}
	
	public function draw(movieClip:MovieClip):Void {
		super.draw(movieClip);
		image = movieClip.attachMovie("background", "imageSource", 0);
		bitmapData = new BitmapData(getWidth(), getHeight(), true, 0x000000);
		var container:MovieClip = movieClip.createEmptyMovieClip("image", 1);
		container.attachBitmap(bitmapData, 1);
		bitmapData.draw(image);
		movieClip._width = getWidth();
		movieClip._height = getHeight();
		intervalId = setInterval(this, "initPixelScaling", Math.round(Math.random() * 10 * 1000 * 5 + 10000));
	}
	
	private function initPixelScaling(Void):Void {
		clearInterval(intervalId);
		pixelSize = Math.round(Math.random() * 20 + minPixelSize);
		stepSize = random(5) + 1;
		movieClip.onEnterFrame = Delegate.create(this, scalePixelUp);
	}
	
	private function scalePixel(Void):Void {
		bitmapData.draw(image);
		for (var x:Number = 0; x < width / pixelSize; x++) {
			for (var y:Number = 0; y < height / pixelSize; y++) {
				var pixelColor:Number = bitmapData.getPixel32(x * pixelSize, y * pixelSize);
				bitmapData.fillRect(new Rectangle(x * pixelSize, y * pixelSize, pixelSize, pixelSize), pixelColor);
			}
		}
	}
	
	private function scalePixelUp(Void):Void {
		if (pixelSize >= maxPixelSize) {
			movieClip.onEnterFrame = Delegate.create(this, scalePixelDown);
			return;
		}
		pixelSize += stepSize;
		scalePixel();
	}
	
	private function scalePixelDown(Void):Void {
		if (pixelSize <= minPixelSize) {
			movieClip.onEnterFrame = null;
			intervalId = setInterval(this, "initPixelScaling", Math.round(Math.random() * 10 * 1000 * 5 + 10000));
			return;
		}
		pixelSize -= stepSize;
		scalePixel();
	}
	
}