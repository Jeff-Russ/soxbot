# Zenity Helper Functions

Zenity is great to give your Bash scripts a nice, albiet minimal, graphical interface. 
If you are the type of programmer that likes to stick by the 80 character per line rule 
you'll likely find using it annoying as it involoves some very long statements. On top of that, 
the commands and switches are descriptive but not quick to type. A lot of it is unavoidable but 
some is not.  

```bash
zenity --file-selection --save --confirm-overwrite --title "Your Title"
```
The above would be better if we just had `save("Your Title")`, wouldn't it?  

I made some function that wrap the zenity command, trimming the fat.  

## The Functions

In all of the following functions, the first argument will be used as the text 
content on the dialog box's title bar. In most of the functions the second argument is the message/warning/question displayed in dialog box below the title bar.  

With Zenity directly, most argument, if not provided, default to some text they have set but with most argument here if you leave out an argument it will be an empty string. In short __most arguments are potentially optional.__

You can, however add additional argument after the ones specified below and they will be sent to `zenity` just as if you called it directly. These, if omitted, will follow zenity's default schemes. This goes for nearly all functions below and shown as `<...>`. 

* `get_text "Your Title" "Your message" "default text" <...>`  
    The "default text" is what will be in input field until user types
* `confirm "Your Title" "Your message" <...>`  
* `warn "Your Title" "Your warning!" <...>`  
* `notify "Your Title" "Your message" <...>`  
    THIS IS NOT WORKING!  
* `show_text "Your Title" "Your message" <...>`  
* `show_error "Your Title" "Error message" <...>`  
* `date_picker "Your Title" "Pick date" 31 8 2016 <...>`  
    `31 8 2016` are the day month and year displayed before using input
* `save_dialog "Your Title"   
    note that zenity will ignore --text "Your message"`  
* `hslide_int_picker "Your Title" "Your message" $min $max $default $incr`  
    Integer ONLY!  
* `radio_list "Your Title" "Your message" [TRUE "label" FALSE "label" ...]`  
    This default boolean could also be `true`/`false` Only one can be `TRUE`. 
* `check_list "Your Title" "Your message" [TRUE "label" FALSE "label" ...]`  
    More than one can be `TRUE`/`true`  