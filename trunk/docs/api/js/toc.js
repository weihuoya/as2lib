

if (parent.location.href != self.location.href) {
    // page not in frameset
    // let all links point to frame "classFrame"
    /*
    // 'setAttribute' does not work properly in Mozilla, so I need to fall back to document.write
    var z = document.getElementsByTagName("head")[0].appendChild(document.createElement("base"));
    z.setAttribute('target','classFrame');
    */
    document.write("<base target=\"classFrame\" />");
}

/*
Adds a id 'toc' to the body node if the page is framed.
This is equivalent to: <body id="toc">
This way the css style 'toc' can give a different appearance to the page.
To set the class <body class="toc"> instead of the id does not seem to work on IE.
*/
window.onload = function () {
    if (parent.location.href != self.location.href) {
        // page is framed
        var bodyNode = document.getElementsByTagName('body')[0];
        bodyNode.setAttribute("id", "toc");
    }
}

/*
Loads the frameset.
*/
function showTOC() {
	self.location = "index.html";
}

/*
Replaces the frameset by the current page.
*/
function hideTOC() {
	parent.location = self.location;
}


