<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
  <head>
    <meta content="text/html;charset=utf-8" http-equiv="content-type" />
    <title>AS2LIB - <?=$homepageInfo->title?> - Open Source ActionScript 2.0 library</title>
    <link rel="stylesheet" type="text/css" media="screen" href="<?=$homepageInfo->path?>css/screen.css" />
  </head>
  <body>
    <? /*
    <script language="JavaScript" type="text/javascript" src="<?=$homepageInfo->path?>js/flashModifier.js"></script>
    <script language="JavaScript" type="text/javascript">
      window.mainFlash = new org.as2lib.web.FlashCreator();
      mainFlash.setTag('div');
      mainFlash.setIdentifierType(org.as2lib.web.FlashCreator.TYPE_ID);
      mainFlash.setIdentifier("mainNavigation");
      mainFlash.setFlashUrl("<?=$homepageInfo->path?>swf/main.swf");
      mainFlash.setSize(647,53);
      mainFlash.setBackgroundColor("#D3E1C0");
      mainFlash.setScaleMode(org.as2lib.web.FlashCreator.SCALE_NO_SCALE);
      mainFlash.addParam("myParam", "hohoho");
      mainFlash.addParam("myParam2", "hi:;hihi");
      mainFlash.hideTag();
    </script> */?>
    <div id="wrapper">
      <div id="mainNavigationWrapper">
        <? /*
        <h1><?=$homepageInfo->title?></h1>
        <menu>
          <li><a href="<? if($homepageInfo->page != "about") { ?><?=$homepageInfo->path?>index.php<? } ?>" title="About the as2lib">About</a></li>
          <li><a href="<? if($homepageInfo->page != "download") { ?><?=$homepageInfo->path?>download.html<? } ?>" title="Newest Downloads to as2lib">Download</a></li>
          <li><a href="<? if($homepageInfo->page != "weblog") { ?><?=$homepageInfo->path?>weblog.html<? } ?>" title="Weblog with news from the front">Weblog</a></li>
          <li><a href="<? if($homepageInfo->page != "documentation") { ?><?=$homepageInfo->path?>documentation.html<? } ?>" title="All you need for life">Documentation</a></li>
          <li><a href="<? if($homepageInfo->page != "features") { ?><?=$homepageInfo->path?>features.html<? } ?>" title="The fast facts about as2lib">Features</a></li>
        </menu>
             */ ?>
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="647" height="53" id="main" align="middle">
          <param name="allowScriptAccess" value="sameDomain" />
          <param name="movie" value="/swf/main.swf" />
          <param name="quality" value="high" />
          <param name="bgcolor" value="#D3E1C0" />
          <embed src="/swf/main.swf" quality="high" bgcolor="#D3E1C0" width="647" height="53" name="main" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
        </object>
      </div>
      <? //<script language="JavaScript" type="text/javascript">window.mainFlash.initFlash();</script> ?>