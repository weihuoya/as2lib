



var isShowingPrivateMembers = 0;
var privateElements = null;
var view_btn = null;
var hide_btn = null;


/*
Adds a id 'framed' to the body node if the page is framed.
This is equivalent to: <body id="framed">
This way the css style 'framed' can give a different appearance to the page.
*/
window.onload = function(e) {
	if (parent.location.href != self.location.href) {
		// page is framed
		// set body id to 'framed': <body id="framed">
		// to address css style 'framed'
		// so that the margins can be defined differently
		var bodyNode = document.getElementsByTagName('body')[0];
		bodyNode.setAttribute("id", "framed");
	}
 
	var cookie = readCookie("privateMembers");
	var showPrivateMembers = cookie;
	if (showPrivateMembers == "1") {
		showPrivate();
	} else {
		setButtonsToHidePrivateState();
	}
		
	/* Init the highlight script */
	fragHLload();
 	fragHLlink();
}

window.onunload = function(e) {
	setCookie("privateMembers", isShowingPrivateMembers, 365);
}

/*
Loads the frameset, passing the current page url as parameter so this
page can be loaded into the frame classFrame.
*/
function showTOC() {
	parent.location = "index.html?" + self.location.href;
}

/*
Replaces the frameset by the current page.
*/
function hideTOC() {
	parent.location = self.location;
}

function getElementsByClassName(class_name)
{
	var all_obj, ret_obj = new Array();
	if (document.all)
		all_obj=document.all;
 	else if (document.getElementsByTagName && !document.all)
		all_obj=document.getElementsByTagName("*");
	var len = all_obj.length;
	for (i=0;i<len;++i) {
		var myClass = all_obj[i].className;
 	if (myClass == class_name) {
			ret_obj.push(all_obj[i]);
		} else {
			var classElems = myClass.split(" ");
			var elemLen = classElems.length;
			for (ii=0; ii<elemLen; ++ii) {
				if (classElems[ii] == class_name) {
					ret_obj.push(all_obj[i]);
				}
			}	
		}
	}
	return ret_obj;
}

function getPrivateElements () {
	privateElements = getElementsByClassName('private');
}

function setButtonsToShowPrivateState() {
	if (view_btn == null) {
		view_btn = getElementsByClassName('viewPrivate')[0];
	}
	view_btn.style.display = "none";
	if (hide_btn == null) {
		hide_btn = getElementsByClassName('hidePrivate')[0];
	}
}

function setButtonsToHidePrivateState() {
	if (view_btn == null) {
		view_btn = getElementsByClassName('viewPrivate')[0];
	}
	view_btn.style.display = "inline";
	if (hide_btn == null) {
		hide_btn = getElementsByClassName('hidePrivate')[0];
	}	
	hide_btn.style.display = "none";
}

function showPrivate() {
	isShowingPrivateMembers = "1";
	setButtonsToShowPrivateState();
	hide_btn.style.display = "inline";
	if (privateElements == null) {
		getPrivateElements();
	}
	var len = privateElements.length;
	for (i=0; i<len; ++i) {
		privateElements[i].style.display = "block";
	}
	setCookie("privateMembers", isShowingPrivateMembers, 365);
}

function hidePrivate() {
	isShowingPrivateMembers = "0";
	setButtonsToHidePrivateState();
	if (privateElements == null) {
		getPrivateElements();
	}
	var len = privateElements.length;
	for (i=0; i<len; ++i) {
		privateElements[i].style.display = "none";
	}
	setCookie("privateMembers", isShowingPrivateMembers, 365);
}

function setCookie(name,value,days) {
	if (days) {
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	} else expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) { 
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	if (ca.length == 0) {
		ca = document.cookie.split(';');
	}
	for(var i=0;i < ca.length;i++) {
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}


/* Fragment Highlight version 0.1 */

//*** This JavaScript highlight code is copyright 2003 by David Dorward; http://dorward.me.uk
//*** Re-use or modification permitted provided the previous line is included and
//*** modifications are indicated

/*********** Start of JavaScript Library *********/

//*** This JavaScript library is copyright 2002 by Gavin Kistner and Refinery; www.refinery.com
//*** Re-use or modification permitted provided the previous line is included

//Adds a new class to an object, preserving existing classes
function AddClass(obj,cName) {
	KillClass(obj,cName);
	return obj.className += (obj.className.length>0?' ':'') + cName;
}

//Removes a particular class from an object, preserving other existing classes.
function KillClass(obj,cName) {
	return obj.className=obj.className.replace(new RegExp("^"+cName+"\\b\\s*|\\s*\\b"+cName+"\\b",'g'),'');
}

/*********** End of JavaScript Library ***********/

/* Fragment Highlight */

/* Indicates area that has been linked to if fragment identifiers have
 * been used. Especially useful in situations where a short fragment
 * is near the end of a page. */

var fragHLed = '';
var fragExclude = ('header');

Array.prototype.search = function(myVariable) {
	for(x in this) if(x == myVariable) return true; return false;
}

/* Highlight link target if the visitor arrives at the page with a # */

function fragHLload() {
 fragHL(location.hash.substring(1));
}

/* Highlight link target from an onclick event after unhighlighting the old one */

function fragHL(frag) {
 if (fragHLed.length > 0 && document.getElementById(fragHLed)) {
		KillClass(document.getElementById(fragHLed),'highlight');
 }
 if (frag.length > 0 && document.getElementById(frag)) {
		fragHLed = frag;
		AddClass (document.getElementById(frag),'highlight');
 }
}

/* Add onclick events to all <a> with hrefs that include a "#" */

function fragHLlink() {
 if (document.getElementsByTagName) {
	var an = document.getElementsByTagName('a');
	for (i=0; i<an.length; i++) {
	 if (an.item(i).getAttribute('href').indexOf('#') >= 0) {
		var fragment = an.item(i).getAttribute('href').substring(an.item(i).getAttribute('href').indexOf('#') + 1);
		if (fragExclude.search(fragment)) {
		 var evn = "fragHL('" + fragment + "')";
		 var fun = new Function('e',evn);
		 an.item(i).onclick = fun;
		}
	 }
	}
 }
}


