# https://github.com/legendofmiracles/dotnix/blob/8dfa01af04d6391a1f5cb2c788bdecc1ee748ca9/hm/newsboat.nix

{ pkgs, ... }:

{
  home.file = {
    ".newsboat/urls".text = ''
      http://newsrss.bbc.co.uk/rss/newsonline_world_edition/front_page/rss.xml
      http://rss.cnn.com/rss/cnn_latest.rss
      http://rss.cnn.com/rss/cnn_topstories.rss
      https://api.politiet.no/politiloggen/v1/rss
      https://azure.status.microsoft/en-us/status/feed/
      https://github.blog/changelog/feed
      https://news.ycombinator.com/rss
      https://www.reddit.com/r/linux/.rss

      # https://api.politiet.no/politiloggen/v1/atom?districts=&municipalities=L%C3%B8renskog
      # https://api.politiet.no/politiloggen/v1/rss?districts=&municipalities=L%C3%B8renskog
      # https://api.politiet.no/politiloggen/v1/atom?municipalities=L%C3%B8renskog
      # https://api.politiet.no/politiloggen/v1/rss?municipalities=L%C3%B8renskog
    '';
    ".newsboat/config".text = ''
      include ${pkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/plain
    '';
  };

  home.packages = [ pkgs.newsboat ];
}
