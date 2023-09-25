# Icon Theme Tool
Tool for viewing and editing icon themes

Under development...

*Screenshoots:*

Main window:<br>
![](screenshoots/1-main.png)

Found duplicates:<br>
![](screenshoots/2-duplicates.png)

Icons sorted by context:<br>
![](screenshoots/3-contexts.png)

Icons with dimentions and preview:<br>
![](screenshoots/4-icons-preview.png)

The sized folders, where icon of one name was found:<br>
![](screenshoots/5-icons-where-are.png)

In fact, I need the ability to create files with the .icon extension in this application, which will contain information about the name of the icon, its description, the points to which the emblems are attached, the coordinates of the preview frame.

I also need a tool for quickly creating symlinks. In the icon theme, to save space, identical icons with different names for different environments are made by symlinks. I need to be able to make them refer to one name and so that this tool can take the original icon and all its symlinks, and then I chose from them who will be the original so that all the others refer to it.