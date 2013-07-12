#!/usr/bin/python
import re
import subprocess
import sys
import random
import fcntl, termios, struct, os

# Pattern to extract data from log
pattern = re.compile("([VDIWE])/([^\(]+)\([\s]*(\d+)\): (.*)$")

# Formatting properties
LOG_LEVEL_VERBOSE = '\033[0;30;48;5;51m'
LOG_LEVEL_INFO = '\033[0;30;48;5;177m'
LOG_LEVEL_DEBUG = '\033[0;30;48;5;119m'
LOG_LEVEL_WARNING = '\033[0;30;48;5;229m'
LOG_LEVEL_ERROR = '\033[0;30;48;5;197m'
LOG_PROCESS = '\033[0;38;5;244;48;5;236m'
LOG_TAG = '\033[0;38;5;%dm'
END = '\033[0m'

# Column widths
WIDTH_LOG_LEVEL = 3
WIDTH_TAG = 20
WIDTH_PID = 9

# Log Formatting
LogLevelFormat = { 'V':LOG_LEVEL_VERBOSE, 'I':LOG_LEVEL_INFO, 'D':LOG_LEVEL_DEBUG, 'W':LOG_LEVEL_WARNING, 'E':LOG_LEVEL_ERROR }

# Colors for tags
tag_colors = [ '\033[0;38;5;226m', 
              '\033[0;38;5;220m', 
              '\033[0;38;5;213m', 
              '\033[0;38;5;199m', 
              '\033[0;38;5;195m', 
              '\033[0;38;5;190m', 
              '\033[0;38;5;160m', 
              '\033[0;38;5;105m', 
              '\033[0;38;5;87m', 
              '\033[0;38;5;39m' ]

tag_color_cache = dict()

cr = struct.unpack('hh', fcntl.ioctl(0, termios.TIOCGWINSZ, '1234'))
width, height = int(cr[1]), int(cr[0])

WIDTH_MESSAGE = width - WIDTH_LOG_LEVEL - WIDTH_PID - WIDTH_PID - 14

def format(text, width, align='left', format_type=None):
    if (align == 'center'):
        return format_type + text.center(width) + END
    if (align == 'left'):
        return format_type + text.ljust(width) + END
    if (align == 'right'):
        return format_type + text.rjust(width) + END
    return text

def getTagColor(tag):
    if tag_color_cache.get(tag) is None:
        tag_color_cache[tag] = random.choice(tag_colors)

    return tag_color_cache[tag]

def wrap(text):
    length = len(text)
    message = list()
    
    pos = 0
    while True:
        message.append(text[pos:(pos + WIDTH_MESSAGE)])
        pos = pos + WIDTH_MESSAGE + 1
        
        if pos > length:
            break
         
    return message

# Retrieve arguments from command line
args = sys.argv
args.remove(args[0])

cmd = "adb %s logcat "
adb_arg = ''

# Check if we have arguments for -d, -e, or -s <specific device>
if (len(args) > 0):
    if (args[0] == '-e' or args[0] == '-d'):
        adb_arg = args[0]
        args.remove(args[0])
    elif (args[0] == '-s' and len(args) > 1):
        specific_device = "%s %s" % ( args[0], args[1] )
        adb_arg = specific_device
        args.remove(args[1])
        args.remove(args[0])

cmd = cmd % adb_arg
cmd = cmd + ' '.join(args)

proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE)
pipe = proc.stdout

while True:
    try:
        line = pipe.readline()
    except KeyboardInterrupt:
        break

    match = pattern.match(line)

    if match:
        log_level, tag, pid, message = match.groups()
        message = wrap(message)

        line = format(pid, WIDTH_PID, 'center', LOG_PROCESS)
        line = line + " " + format(tag.strip()[:WIDTH_TAG], WIDTH_TAG, 'right', getTagColor(tag))
        line = line + " " + format(log_level, WIDTH_LOG_LEVEL, 'center', LogLevelFormat[log_level])
        line = line + " " + message[0]
        del message[0]

        for m in message:
            line = line + "\n" + format('', WIDTH_PID, 'center', LOG_PROCESS)
            line = line + " " + format('', WIDTH_TAG, 'right', getTagColor(tag))
            line = line + " " + format('', WIDTH_LOG_LEVEL, 'center', LogLevelFormat[log_level])
            line = line + " " + m

    print  line

    if len(line) == 0:
        break

proc.terminate()
