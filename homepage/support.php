<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Support";
  $homepageInfo->page = "support";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <h2>Sourceforge Related Support</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="http://sourceforge.net/mail/?group_id=94206" title="Mailing lists for different sections">Mailing Lists</a></li>
              <li><a href="http://sourceforge.net/forum/?group_id=94206" title="Available forums on sourceforge">Forum(s)</a></li>
              <li><a href="http://sourceforge.net/tracker/?atid=607074&group_id=94206&func=browse" title="Bug Page to post new bugs and view documented bugs">Bug Page</a></li>
              <li><a href="http://sourceforge.net/tracker/?atid=607077&group_id=94206&func=browse" title="Feature page to post new feature requests">Feature Page</a></li>
              <li><a href="http://sourceforge.net/tracker/?atid=607075&group_id=94206&func=browse" title="Support page where you can post a request for support">Support Page</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>Support</h2>
          <div class="hr"></div>
          <div class="text">
            We restrict our actual support to the <a href="http://sourceforge.net/forum/?group_id=94206" title="Available forums on sourceforge">Forums</a>, <a href="http://sourceforge.net/mail/?group_id=94206" title="Mailing lists for different sections">Mailinglists</a> and the Request Lists at the sourceforge project page.<br />
            <br />
            Please don't be shy and use this service.
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>