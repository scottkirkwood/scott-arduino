#!/bin/python
import serial

def Loop(port, speed):
  p1 = serial.Serial(port, speed)
  while True:
    ch = p1.read()
    if not ch:
      break;
    print ch


if __name__ == '__main__':
  Loop('/dev/ttyUSB0', 9600)
