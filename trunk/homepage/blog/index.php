<?
  /* Don't remove these lines. */
  $blog = 1;
  require('wp-blog-header.php');
  // Uncomment the next line if you want to track blog updates from weblogs.com
  //include_once(ABSPATH.WPINC.'/links-update-xml.php');
  require('../class.inc.php');
  $homepageInfo = new HomepageInfo;
  $homepageInfo->title = get_bloginfo('name').wp_title('&raquo;', false);
  $homepageInfo->page = "weblog";
  $homepageInfo->path = "../";
  include('../header.inc.php');
?>
      <div id="sidebar">
        <div id="sidebarContent">
          <?if(count($HTTP_GET_VARS) > 0) { ?>
          <div class="contentArea">
            <a href="index.php" title="weblog root" class="levelUp">Weblog Startpage</a>
          </div>
          <? } ?>
          <div class="contentArea">
            <h2>Categories</h2>
            <div class="hr"></div>
            <ul class="links">
              <?php list_cats(0, 'All', 'name'); ?>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Links</h2>
            <div class="hr"></div>
            <ul class="weblogLinks">
              <?php get_links_list(); ?>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Search</h2>
            <div class="hr"></div>
            <form id="searchform" method="get" action="<?php echo $PHP_SELF; /*$siteurl."/".$blogfilename*/ ?>">
              <input type="text" name="s" size="15" /><br />
              <input type="submit" name="submit" value="search" class="button" />
            </form>
          </div>
          <div class="contentArea">
            <h2>Calendar</h2>
            <div class="hr"></div>
            <?php get_calendar(); ?>
          </div>
          <div class="contentArea">
            <h2>Archives</h2>
            <div class="hr"></div>
            <ul class="links">
              <?php get_archives('monthly'); ?>
            </ul>
          </div>
          <div class="contentArea">
            <h2>Syndicate</h2>
            <div class="hr"></div>
            <ul class="links">
              <li><a href="wp-rss.php">RSS</a></li>
              <li><a href="wp-rss2.php">RSS 2.0</a></li>
            </ul>
          </div>
        </div>
      </div>
      <div id="content">
          <div class="ignore">
        <? if ($posts) { foreach ($posts as $post) { start_wp(); ?>
          <? the_date('',"\n          </div>\n          <div class=\"contentArea\">\n            <h2>","</h2>\n            <div class=\"hr\"></div>\n"); ?>
            <div class="text">
              <h3 id="post-<? the_ID(); ?>"><a href="<?= get_permalink() ?>" rel="bookmark" title="Permanent Link: <? the_title(); ?>"><? the_title(); ?></a></h3>
              <?php the_content(); ?>
              <div class="weblogMeta"> by <?php the_author() ?> at <?php the_time() ?><br /> Categories: <?php the_category(',') ?><br /><?php edit_post_link(); ?></div>
              <div class="weblogFeedback">
                <?php link_pages('<br />Pages: ', '<br />', 'number'); ?> 
                <?php comments_popup_link('No Comments', '1 Comment', '% Comments'); ?> 
              </div>
            </div>
        <? } } else { /* end foreach, end if any posts  */?>
            <div class="contentArea">
              <div class="text">Sorry, no posts matched your criteria.</div>
        <? } ?>
            </div>
<?php include(ABSPATH . 'wp-comments.php'); ?>
      </div>

<? include('../footer.inc.php'); ?>