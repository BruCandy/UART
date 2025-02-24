from machine import Pin, UART
import time

uart = UART(0, 115200)
led = Pin("LED", Pin.OUT)
led.value(0)
state = 0

while True:
    buf = uart.read(1)
    if buf is not None and buf[0] == 0x01:
        state += 1
    
    if state % 2 == 1:
        led.value(1)
    elif state % 2 == 0:
        led.value(0)
        
    time.sleep(0.1)