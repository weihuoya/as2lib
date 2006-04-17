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
import org.as2lib.env.log.Logger;
import org.as2lib.env.log.LogManager;
import org.as2lib.sample.filebrowser.model.File;
import org.as2lib.sample.filebrowser.view.AbstractView;
import org.as2lib.sample.filebrowser.view.file.ErrorListener;
import org.as2lib.sample.filebrowser.view.file.FileView;

import flash.filters.DropShadowFilter;

/**
 * @author Simon Wacker
 */
class org.as2lib.sample.filebrowser.view.file.VideoView extends AbstractView implements FileView {
	
	private static var logger:Logger = LogManager.getLogger("org.as2lib.sample.filebrowser.view.file.VideoView");
	
	private var video:Video;
	private var connection:NetConnection;
	private var stream:NetStream;
	private var errorDistributorControl:EventDistributorControl;
	private var errorDistributor:ErrorListener;
	
	public function VideoView(Void) {
		errorDistributorControl = new SimpleEventDistributorControl(ErrorListener, false);
		errorDistributor = errorDistributorControl.getDistributor();
	}
	
	public function draw(movieClip:MovieClip):Void {
		super.draw(movieClip);
		createVideo();
		initStream();
		movieClip.filters = [new DropShadowFilter(5, 45, 0x000000, 100, 2, 2, 0.9, 15)];
	}
	
	private function createVideo(Void):Void {
		video = getMovieClip().attachMovie("video", "video", 0).video;
		video["_width"] = getWidth();
		video["_height"] = getHeight();
	}
	
	private function initStream(Void):Void {
		connection = new NetConnection();
		connection.connect(null);
		stream = new NetStream(connection);
		var owner:VideoView = this;
		stream.onStatus = function(info:Object):Void {
			if (info.level == "error") {
				owner["onLoadError"](this["file"]);
				return;
			}
			if (info.code == "NetStream.Play.Start") {
				owner["onLoadComplete"](this["file"]);
				return;
			}
		};
		video.attachVideo(stream);
	}
	
	public function show(file:File):Void {
		getMovieClip()._visible = true;
		stream["file"] = file;
		stream.play(file.getPath());
	}
	
	public function hide(Void):Void {
		getMovieClip()._visible = false;
		video.clear();
		stream.close();
	}
	
	public function addErrorListener(errorListener:ErrorListener):Void {
		errorDistributorControl.addListener(errorListener);
	}
	
	public function onLoadError(file:File):Void {
		if (logger.isErrorEnabled()) {
			logger.error("Error on loading file '" + file.getPath() + "'.");
		}
		errorDistributor.onError("loadingFileFailed", [file.getPath()]);
	}
	
	public function onLoadComplete(file:File):Void {
		if (logger.isInfoEnabled()) {
			logger.info("Loaded file '" + file.getPath() + "' successfully.");
		}
	}
	
}