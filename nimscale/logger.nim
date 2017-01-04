import strutils, times, os

type Level* {.pure.} = enum
  debug, info, warn, error, fatal

var logLevel* = Level.debug

template log*(args: varargs[string, `$`]) =
  if logLevel <= Level.debug:
    const module = instantiationInfo().filename[0 .. ^5]
    echo "[$# $#][$#]: $#" % [getDateStr(), getClockStr(),
      module, join args]
