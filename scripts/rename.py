"""
Usage: python script.py search_string replace_string dir
Eg. python batchreplace.py galleries productions /Sites/cjc/application/modules/productions/
And it will search recursively in dir
and replace search_string in contents
and in filenames.
Case-sensitive
"""
 
from sys import argv
import os
 
def multi_replace(search, replace, path):
    """Replace search with replace in all filenames
    and file contents in directory path.
 
    @type   search: string
    @param  search: The old string.
    @type   replace: string
    @param  replace: The new string.
    @type   path: string
    @param  path: The path in which files area.
 
    @rtype: boolean
    @returns: True or False. Also print a msg to the console.
 
    """
    counter_contents = 0
    counter_names = 0
    if not os.path.exists(path):
        print 'Path does not exist'
        return False
    for dirpath, dirs, files in os.walk(path):
        for filename in files:
            # replace in filename
            if search in filename:
                os.rename(
                    os.path.join(dirpath, filename),
                    os.path.join(dirpath, filename.replace(search, replace))
                )
                counter_names +=1
            
    print '%s files renamed, %s files contents altered' % (counter_names,counter_contents)
    return True
 
script, search_str, replace_str, path_str = argv
 
multi_replace(search_str, replace_str, path_str)
