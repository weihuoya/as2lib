<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "Mission Statement";
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
          <h2>Mission Statement</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>We believe that</h3>
            <ul>
              <li>ActionScript 2 should be easier to use.</li>
              <li>It is best to program to interfaces, rather than classes.</li>
              <li>Good documentation is needed in every project.</li>
              <li>Strict typing is a key part of every OO language.</li>
              <li>Maximum flexibility should be gained.</li>
              <li>ActionScript 2 is a strong language but needs a broad background of classes to efficiently work with it.</li>
              <li>Testcases keep our software strict bundled and ensures quality.</li>
            </ul>
            <br />
            <h3>We aim that:</h3>
            <ul>
              <li>The as2lib should be a pleasure to use.</li>
              <li>You have maximum flexibility in configuring the as2lib to fit your needs.</li>
              <li>The as2lib helps you in your daily life.</li>
            </ul>
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>