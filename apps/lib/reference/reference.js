(function() {

  $(function() {
    /*
        TODO:
        – This should be encapsulated so it doesn't junk up the global namespace.
        - Maybe this file should be a Utils files and more generic?
    */

    var $sectionGroups, $sidebarNav,
      _this = this;
    $sectionGroups = $("section.bronson-layer");
    $sidebarNav = $(".sidebar-nav");
    return _.each($sectionGroups, function(group) {
      var $groupHeader, $groupItems;
      $groupItems = $(group).find("> section");
      $groupHeader = $(group).find('> h2');
      $sidebarNav.append("<li class='nav-header'>" + ($groupHeader.text()) + "</li>");
      return _.each($groupItems, function(item) {
        var $header, headerStr, id, sidebarList;
        id = $(item).attr('id');
        $header = $(item).find('> h3');
        headerStr = $(item).find('> h3').text();
        $header.html("<a href='#" + id + "'>" + headerStr + "</a>");
        sidebarList = "<li><a href='#" + id + "'>" + headerStr + "</a></li>";
        $sidebarNav.append(sidebarList);
        return console.log('item:', id, $header, headerStr);
      });
    });
  });

}).call(this);
