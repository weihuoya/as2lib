document.write('<style type="text/css" >.flash { display:none; }</style>');

org = {as2lib:{web:{}}}

org.as2lib.web.FlashCreator = function() {
  this.params = new Array();
  this.setSize(20,20);
  this.setBackgroundColor("#FFFFFF");
  this.setScaleMode(org.as2lib.web.FlashCreator.SCALE_NO_SCALE);
  this.setIdentifierType(org.as2lib.web.FlashCreator.TYPE_ID);
  this.setAlign("TL");
  this.setQuality("high");
  this.hideMenu();
}
static_ = org.as2lib.web.FlashCreator;
static_.TYPE_ID = 1;
static_.TYPE_CLASS = 2;
static_.SCALE_NO_SCALE = "noscale";
public_ = static_.prototype;
public_.setIdentifierType = function(toType) {
  this.identifierType = toType;
}
public_.setIdentifier = function(toString) {
  this.identifier = toString;
}
public_.setFlashUrl = function(toUrl) {
  this.flashUrl = toUrl;
}
public_.setSize = function(width, height) {
  this.width = width;
  this.height = height;
}
public_.setBackgroundColor = function(toColor) {
  this.bgColor = toColor;
}
public_.setScaleMode = function(toMode) {
  this.scaleMode = toMode;
}
public_.addParam = function(param, value) {
  this.params[this.params.length] = [param, value];
}
public_.replaceContent = function() {
}
public_.setTag = function(toTag) {
  this.tag = toTag;
}
public_.getNode = function() {
  if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_ID) {
    return document.getElementById(this.identifier);
  } else if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_CLASS) {
    throw {message: "org.as2lib.web.FlashCreator: .getNode is not available for classifier Identifier. [id:"+this.identifier+""};
  } else {
    throw {message: "org.as2lib.web.FlashCreator: No correct Identifier set. [id:"+this.identifier+"]"};
  }
  throw {message: "org.as2lib.web.FlashCreator: Related Tag not found [tag:"+this.tag+"; id:"+this.identifier+"]"};
}
public_.getNodes = function() {
  var result = new Array();
  if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_ID) {
    throw {message: "org.as2lib.web.FlashCreator: .getNode is not available for id Identifiertype. [id:"+this.identifier+""};
  } else if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_CLASS) {
    return this.findNodes(new Array(), document.body, this.identifier);
  } else {
    throw {message: "org.as2lib.web.FlashCreator: No correct Identifier set. [id:"+this.identifier+"]"};
  }
  throw {message: "org.as2lib.web.FlashCreator: Related Tag not found [tag:"+this.tag+"; id:"+this.identifier+"]"};
}
public_.findNodes = function(resultArray, inNode, byClass) {
  if(inNode.className == byClass) {
    resultArray[resultArray.length] = inNode;
  }
  for(var i=0; i<inNode.childNodes.length; i++) {
    this.findNode(inNode.childNodes[i]);
  }
  return resultArray;
}
public_.initFlash = function() {
  if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_ID) {
    this.createFlash(this.getNode());
  } else if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_CLASS) {
    var divs = this.getNodes();
    for(var i=0; i<divs.length; i++) {
      this.createFlash(divs[i]);
    }
  }
}
public_.evaluateContent = function(domNode) {
  var result = domNode.innerHTML;
  return result;
}
public_.setAlign = function(toAlign) {
  this.align = toAlign;
}
public_.hideMenu = function() {
  this.useMenu = false;
}
public_.showMenu = function() {
  this.useMenu = true;
}
public_.setQuality = function(toQuality) {
  this.quality = toQuality;
}
public_.createFlash = function(domNode) {
  var content = this.evaluateContent(domNode);
  var flashVars = this.getParamsAsString();
      flashVars = "content=content:"+encodeURIComponent(content)+";"+flashVars;
  var result = '<div id="'+domNode.id+'FlashWrapper" class="'+domNode.className+'FlashWrapper"><object '
                 +'id="'+domNode.id+'Flash" '
                 +'class="'+domNode.className+'Flash" '
                 +'width="'+this.width+'" '
                 +'height="'+this.height+'" '
                 +'align="'+this.align+'" '
                 +'classid="D27CDB6E-AE6D-11cf-96B8-444553540000" '
                 +'codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0">'
               +this.createParamNode("movie", this.flashUrl)
               +this.createParamNode("menu", this.useMenu)
               +this.createParamNode("quality", this.quality)
               +this.createParamNode("scale", this.scale)
               +this.createParamNode("bgcolor", this.bgColor)
               +this.createParamNode("FlashVars", flashVars)
               +this.createEmbedNode(flashVars, domNode.id)
               +"</object></div>";
  document.write(result);
}
public_.createParamNode = function(name, value) {
  return '<param name="'+name+'" value="'+value+'">';
}
public_.createEmbedNode = function(flashVars, id) {
  var result = '<embed src="'+this.flashUrl+'" '
              +'menu="'+this.useMenu+'" '
              +'quality="'+this.quality+'" '
              +'scale="'+this.scaleMode+'" '
              +'bgcolor="'+this.bgColor+'" '
              +'width="'+this.width+'" '
              +'height="'+this.height+'" '
              +'name="'+this.id+'Flash" '
              +'type="application/x-shockwave-flash" '
              +'FlashVars="'+flashVars+'" '
              +'pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>'
  return result;
}
public_.getParamsAsString = function() {
  var result = "";
  for(var i=0; i<this.params.length; i++) {
    if(i!=0) result += "*;*";
    result += this.params[i][0]+"*:*"+encodeURIComponent(this.params[i][1]);
  }
  return result;
}
public_.hideTag = function() {
  if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_ID) {
    document.write('<style type="text/css">#'+this.identifier+'{display:none;}</style>');
  } else if(this.identifierType == org.as2lib.web.FlashCreator.TYPE_CLASS) {
    document.write('<style type="text/css">.'+this.identifier+'{display:none;}</style>');
  }
}