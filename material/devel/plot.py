#!/usr/bin/python
import time



class Plotter:
 
    self extra_commands_init = ""
    self.hpgl_version = "1";
    self.color_pen_map =  {
        1 : "black",
        2 : "red",
        3 : "green", 
        4 : "yellow",
        5 : "blue", 
        6 : "magenta",
        7 : "cyan"
    }
 



def which(program):
    """ Imitates the behavior of the Unix which command. 
        
        Returns the absolute path of the executable or 
        None if there is no such executable on the path.

        Stolen from:
        http://stackoverflow.com/questions/377017/test-if-executable-exists-in-python/377028#377028
        """

    import os

    def is_executable(filepath):
        return os.path.isfile(filepath) and os.access(filepath, os.X_OK)

    fpath, fname = os.path.split(program)
    
    if fpath:
        if is_executable(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            exe_file = os.path.join(path, program)
            if is_executable(exe_file):
                return exe_file

    return None



def verify_third_party_tools(cmds):
	def verify(cmd):
		return which(cmd) is not None

	good = True

	for cmd in cmds:
		if(verify(cmd)):
			print("Command {0} found.".format(cmd))
		else:
			print("Command {0} NOT found.".format(cmd))
			good = False

	return good


if(verify_third_party_tools(["pstoedit"])):
	print("Tools are there.")
else:
	print("Error. Exiting.")


    "hpgl via GNU libplot"

