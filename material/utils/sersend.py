#!/usr/bin/python

import serial
import sys
import time


def status_bar(progress, countr, total):
    times = int(progress * 31)
    percentage = progress * 100

    sys.stdout.write('\r')
    sys.stdout.write("Sending [%-30s] %d%%     Command: %i/%i" % ('=' * times, percentage, countr, total))
    sys.stdout.flush()


if(len(sys.argv) is not 3):
    print("Usage: {0} inputfile serialdevice".format(sys.argv[0]))
    sys.exit(-1);


ser = serial.Serial(sys.argv[2], 9600, timeout=0, rtscts=True)

f = open(sys.argv[1], 'r')

print("Reading from {0}".format(sys.argv[1]))
print("Writing to {0}".format(ser.portstr))


lines = f.readlines()
linecount = len(lines)

countr = 0
for line in lines:
    ret = ser.write(line)

    # print("Sent line {0} / {1}   ->  {2} ".format(countr, linecount, ret))
    progress = float(countr) / (linecount - 1)
    countr = countr + 1

    status_bar(progress, countr, linecount)


print(" ")
raw_input("Finished sending. Press [Enter] when the plotter has stopped...")

f.close()
ser.close()