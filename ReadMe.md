# rWeb

rWeb is Watershed's in house Web kiosk. It allows visitors to explore Watershed's wider cinema programme, DShed which showcases our previous projects and the Pervasive Media Studio.

The application was written in **Swift** and **Objective-C**.

![Interface](rWeb.jpg "Logo")

We have stripped the application down so that you can implement your own Kiosk.

### What is the Catch? 
<s>We haven't yet stopped Command-Q from quitting the application, so either use a keyboard with no command key, or disable the command key in OS X somehow. </s>

Command-Q no longer quits the applcation.

Users can also specify whether the application enables the Force Quit Menu. Simply enter the Config.plist and set the Can Force Quit to NO to lock out the Force Quit Menu.

### What is in the Application?

There are 2 View Controllers. The Main Controller and the Saver Controller.

The Main Controller contains two WebView objects, a Header bar and the Main view.
We used the Header bar like a home panel where people could quickly access certain parts of our Website quickly. Any interactions in this bar were fired and loaded into the Main View.

The Saver Controller is a semi screen saver, containing one WebView. This is loaded with a promotional url which cycles through our custom what's on page.

![Layout](appLayout.png "UI")

### How to Customise
We have left some of the variables open for you to customise the kiosk. Simply open the Config.plist and add your own urls, regex strings and timings.

If you have any specific questions feel free to contact us.

