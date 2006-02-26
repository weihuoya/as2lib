/**
 * EnFlashConfiguration.
 */
class com.asual.enflash.EnFlashConfiguration {

	public var marginTop:Number = 0;
	public var marginRight:Number = 0;	
	public var marginBottom:Number = 0;	
	public var marginLeft:Number = 0;	

	public var xmlMode:Boolean = false;	
	public var xmlFile:String;	

	public var initialTheme:String;
	public var defaultTheme:String = "default.swf";

	public var themesLoading:Boolean = true;
	public var themesRepository:String;

	public var langsRepository:String;
	
	public var excludeAssets:Array;	

	/**
	 * Parent MC to the entire application.
	 */
	public var mc:MovieClip;	

	private var _name:String = "EnFlashConfiguration";

	public function EnFlashConfiguration(appRoot:MovieClip) {
		if (appRoot == undefined) appRoot = _root;
		mc = (appRoot.enflash != undefined) ? appRoot.enflash : appRoot;
		xmlFile = (mc.xmlFile != undefined) ? mc.xmlFile : mc._url.split("/")[mc._url.split("/").length - 1].split(".")[0] + ".xml";
		themesRepository = (mc.themesRepository != undefined) ? mc.themesRepository : "../themes/";
		langsRepository = (_root.enflash.langsRepository != undefined) ? _root.enflash.langsRepository : "langs/";
	}

	/**
	 * Basic method that returns the type of this object.
	 * 
	 * @return The type of this object
	 */
	public function toString():String {
		return _name;
	}
	
}