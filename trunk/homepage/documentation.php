<?

  require('class.inc.php');

  $homepageInfo = new HomepageInfo;

  $homepageInfo->title = "Documentation";

  $homepageInfo->page = "documentation";

  $homepageInfo->path = "";

  include('header.inc.php');

?>

      <div id="sidebar">

        <div id="sidebarContent">

          <div class="contentArea">

            <h2>Downloads</h2>

            <div class="hr"></div>

            <ul class="links">

              <li><a href="/docs/introduction_german_online.pdf" title="German Introduction to the as2lib">Introduction (German)</a></li>

            </ul>

          </div>

        </div>

      </div>

      <div id="content">

        <div class="contentArea">

          <h2>Documentation</h2>

          <div class="hr"></div>

          <div class="text">

            <h3>ActionScript 2.0 Inline Documentation</h3>

            We use inline documentation during our development process. Usually we do our documentation very similar to JavaDoc to work with standards.

            There is sadly no freeware tool available that parses this kind of documentation for ActionScript 2.0 (we tested all we found).

            <br />

            <br />

            <h3>Introducting</h3>

            Christoph Atteneder wrote a small introduction about the ideas of the as2lib. There is only a german version available right now. An english version

            will be available in the next few days.<br />

            <br />

            <a href="/docs/introduction_german_online.pdf">Download the Introduction in German now</a>
			<br />

            <a href="/docs/introduction_english_online.pdf">Download the Introduction in English now</a>

          </div>

        </div>

      </div>

<? include('footer.inc.php') ?>