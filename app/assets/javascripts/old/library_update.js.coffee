@initializeRatingInterface = (element, type) ->
  return

  rating = parseInt element.attr("data-rating")
  anime_slug = element.attr("data-anime-slug")
  element.html ""

  if type == "starRatings"
    for i in [1..5]
      star = $("<a class='star' data-rating='" + i + "' href='javascript: void(0)'></a>")
      if rating >= i
        star.append $("<i class='fa fa-star'></i>")
      else
        star.append $("<i class='fa fa-star-o'></i>")

      star.click ->
        element.find('.spinner').html $("<i class='pull-right fa fa-spin fa-spinner'></i>")

        $.post "/api/v1/libraries/" + anime_slug, {rating: parseInt($(this).attr("data-rating"))}, (d) ->
          if d
            element.attr "data-rating", d.rating.value
            initializeRatingInterface element, type

      element.append star
      element.append $("<span> </span>")
      
  else if type == "smileyRatings"
    
    console.log "to be implemented"
    
  
  element.append $("<div class='spinner pull-right'></div>")
  
renderProgress = (element) ->

@initializeProgressIncrement = (element) ->
  anime_slug      = element.attr("data-anime-slug")
  progress        = element.attr("data-progress")
  total_episodes  = element.attr("data-total-episodes")
  allow_incr      = element.attr("data-allow-increment") == "true"
  
  if allow_incr
    icon = $("<a href='javascript:void(0)' class='click-add'><i class='fa fa-angle-up'></i></a>")
    icon.click ->
      icon.find("i").removeClass("fa-angle-up").addClass("fa-spin").addClass("fa-spinner")
      $.post "/api/v1/libraries/" + anime_slug, {increment_episodes: true}, (d) ->
        element.attr "data-progress", d.episodes_watched 
        initializeProgressIncrement element
  else
    icon = $("<span></span>")
  
  element.empty()
  element.append icon
  element.append "<span> </span>"
  element.append "<span class='edit'>" + progress + "</span>"
  element.append " / "
  element.append "<span class='total-episodes'>" + total_episodes + "</span>"

@initializeWatchlistStatusButton = (element) ->
  unless currentUser
    element.append $("<a href='/users/sign_in' class='button radius padded'>Add to Watchlist</a>")
    return

  element.empty()

  anime = element.attr("data-anime")
  status = element.attr("data-status")

  entryModel = new HB.Library.Entry
    anime: 
      slug: anime
    status: status

  widget = new HB.Library.StatusChangeWidget
    model: entryModel

  element.append widget.render().el

$ ->
  $(".watchlist-status-button").each ->
    initializeWatchlistStatusButton $(this)
