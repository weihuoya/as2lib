<?
  require('class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = "About";
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
          <h2>as2lib - team</h2>
          <div class="hr"></div>
          <div class="text">
            <h3>Core Members</h3>
            <table class="members">
              <tbody>
                <tr>
                  <th>Martin Heidegger</th>
                  <td>Project Management / Development</td>
                  <td>mastakaneda [at] sourceforge.net</td>
                  <td>Austria</td>
                </tr>
                <tr>
                  <th>Simon Wacker</th>
                  <td>Chief Developer</td>
                  <td>simonwacker [at] sourceforge.net</td>
                  <td>Germany</td>
                </tr>
                <tr>
                  <th>Christoph Atteneder</th>
                  <td>Developer</td>
                  <td>ripcurlx [at] sourceforge.net</td>
                  <td>Austria</td>
                </tr>
                <tr>
                  <th>Michael Herrman</th>
                  <td>Developer</td>
                  <td>hamster2k [at] sourceforge.net</td>
                  <td>Austria</td>
                </tr>
              </tbody>
            </table>
            <br />
            <h3>New members</h3>
            There are many open tasks to be delegated to free volunteers in the as2lib.
            If your are interested in supporting the as2lib send us a mail
            or post a thread in the as2lib forum.
          </div>
        </div>
      </div>
<? include('footer.inc.php') ?>