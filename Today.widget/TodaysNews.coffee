# Execute the shell command.
command: 'curl -s "https://www.reddit.com/r/news/.rss"'

# Set the refresh frequency (milliseconds).
refreshFrequency: 300000

# Render the output.
render: (output) -> """
  <div id="heading">News</div>
  <div id="title"></div>
  <div id="link"></div>
  <div id="footer"></div>
"""
#<div id="link"><a href="">ClickMe</a></div>

# Update the rendered output.
update: (output, domEl) -> 
  dom = $(domEl)
  
  # Parse our XML.
  xml = jQuery.parseXML(output)
  $xml = $(xml)
  
  # Get the item we care about.
  theItem = ($xml.find('rss').find('channel').find('item'))
  window.todaysNewsMaxStories = theItem.find('title').length
  window.todaysNewsCurrentStory = 0

  @showStory(theItem,dom,window)
  
  # Set the interval. We store the value in a window variable so we can clear it
  # each time the widget is refreshed.
  clearInterval(window.todaysNewsInterval)
  window.todaysNewsInterval = setInterval (=> @showStory(theItem,dom,window)),10000
 
showStory: (theItem,dom,win)-> 
  
  win.todaysNewsCurrentStory += 1
  if win.todaysNewsCurrentStory > win.todaysNewsMaxStories
    win.todaysNewsCurrentStory = 0

  # Get the title and the description from the item.
  theTitle = theItem.find('title')[win.todaysNewsCurrentStory].childNodes[0].data.split(':')
  theLink = theItem.find('link')[win.todaysNewsCurrentStory]
  theDate = theItem.find('pubDate')[win.todaysNewsCurrentStory].childNodes[0].data

  # Convert the date to the local timezone.
  theDate = new Date(theDate)
  
  # Output the variables.
  dom.find(title).html(theTitle)

  ## This one links to 127.0.0.1/%5Bobject%20Element%5D
  #dom.find(link).html("<a href=\"" + theLink + "\">ReadMore</a>") #
  ## Prints the url, but I want to encapsulate it inside of an href
  #dom.find(link).html(theLink) 
  ## This one links back to 127.0.0.1
  #dom.find(link).html("<a href=\"#theLink\">ReadMore</a>")
  
  dom.find(footer).html(theDate + '   (Story ' + win.todaysNewsCurrentStory + ' of ' + win.todaysNewsMaxStories + ')')
  
# CSS Style
style: """
  top: 300px
  right: 8px
  width:360px
  margin:0px
  padding:0px
  background:rgba(#FFF, 0.5)
  border:2px solid rgba(#000, 0.5)
  border-radius:10px
  overflow:hidden

  #heading
    margin:12pt
    margin-bottom:0
    font-family: Helvetica
    font-size: 42pt
    font-weight:bold
    color: rgba(#FFF, 0.75)
  
  #title
    margin-left:12pt
    margin-right:12pt
    xxmargin-bottom:-10pt
    font-family: American Typewriter
    font-size: 20pt
    font-weight:bold

  #description
    margin-left:12pt
    margin-right:12pt
    font-family: American Typewriter
    font-size: 12pt
    line-height:18pt
    max-height:120pt
    overflow:hidden
    hyphens: auto

  #link
    margin-left:12pt
    margin-right:12pt
    font-family: American Typewriter
    font-size: 12pt
    line-height:18pt
    max-height:120pt
    overflow:hidden
    hyphens: auto
    
  #footer
    font-family: Helvetica
    font-size: 9pt
    margin:12pt
    color: rgba(#000, 0.5)
"""
