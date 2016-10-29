# SoXBot - Graphical Audio File Manipulation

SoXBot is a work in progress!  

SoXBot is a graphical front-end for the [SoX](http://sox.sourceforge.net/) command line sound processing tool. As such, it requires a Sox installation as well as Ruby and Zenity.  

![commands_dialog](https://s3.amazonaws.com/shared-img-res/on_github_or_gist/soxbot_commands.png)  

![file_dialog](https://s3.amazonaws.com/shared-img-res/on_github_or_gist/soxbot_files.png)  

## MacOS Integration

You could make a "Service" with MacOS Automator.app which would make execution possible from the finder. When selecting files you'll see the option when you right click. The Automator Service would look something like this, with the path in the last line changed:  

![Automator](https://s3.amazonaws.com/shared-img-res/on_github_or_gist/soxbot_macos_service.png)  
