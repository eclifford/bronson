$ ->
  ###
    TODO:
    – This should be encapsulated so it doesn't junk up the global namespace.
    - Maybe this file should be a Utils files and more generic?
  ###
  $sectionGroups = $("section.bronson-layer")
  $sidebarNav = $(".sidebar-nav")

  _.each $sectionGroups, (group) =>

    $groupItems = $(group).find("> section")
    $groupHeader = $(group).find('> h2')
    $sidebarNav.append "<li class='nav-header'>#{$groupHeader.text()}</li>"

    _.each $groupItems, (item) =>
      id = $(item).attr 'id'
      $header = $(item).find('> h3')
      headerStr = $(item).find('> h3').text()
      $header.html "<a href='##{id}'>#{headerStr}</a>"

      # <li class='nav-header'>Api</li>
      # <li><a href="#api-overview">Overview</a></li>
      sidebarList = "<li><a href='##{id}'>#{headerStr}</a></li>"
      $sidebarNav.append sidebarList
      console.log 'item:', id, $header, headerStr
