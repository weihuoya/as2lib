<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "License";
  $homepageInfo->page = "about";
  $homepageInfo->path = "";
  include('header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <div class="contentArea">
            <h2>Modules</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="index.php" title="The main project">as2lib</a></li>
              <li><a href="as2libConsole.php" title="as2ib console for the world">as2lib console</a></li>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Informations</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="missionStatement.php" title="Targets at our mission.">Mission Statement</a></li>
              <li><a href="roadmap.php" title="Map to our road to success">Roadmap</a></li>
              <li><a href="license.php" title="You are allowed to...">License</a></li>
              <li><a href="team.php" title="Team members of the as2lib">Team</a></li>
              <li><a href="features.php" title="Features of the as2lib">Features</a></li>
              <li><a href="http://www.sourceforge.net/projects/as2lib" title="Projectpage hosted on Sourceforge">Sourceforge Project</a></li>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Links</h2>
            <div class="hr"></div>
            <a href="http://www.sourceforge.net/projects/as2lib" class="externalIcons"><img src="http://sourceforge.net/sflogo.php?group_id=as2lib&amp;type=1" width="88" height="31" border="0" alt="SourceForge.net Logo"/></a>
          </div>
        </div>
      </div>
      <div id="content">
        <div class="contentArea">
          <h2>License</h2>
          <div class="hr"></div>
          <div class="text">
            The as2lib is licensed according to the terms of the Mozilla Public License, Version 1.1.<br />
            <br />
            The MPL is a full open-source license. This means you can read and change the source and you can
            publish your application without any application fees.<br />
            <br />
            The full text of this license can be found at:<br />
            <a href="http://www.mozilla.org/MPL/MPL-1.1.html" title="Mozilla 1.1 License">http://www.mozilla.org/MPL/MPL-1.1.html</a>
          </div>
        </div>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
      </div>
<? include('footer.inc.php') ?>