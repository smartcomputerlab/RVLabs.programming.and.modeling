# rtc_sensor_cycle.py
import machine, time, ustruct
from machine import deepsleep

rtc = machine.RTC()

def rtc_store_sensor_cycle(sensor,cycle):
    data = ustruct.pack('fi',sensor,cycle)
    rtc.memory(data)
    
def rtc_load_sensor_cycle():
    s=20.0; cycle=10
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fi',s,cycle)
        rtc.memory(data)
    s,c = ustruct.unpack('fi', data)
    return s,c

def rtc_reset_sensor_cycle():
    s=0.0; cycle=10
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fi',s,cycle)
        rtc.memory(data)
    else:
        data = ustruct.pack('fi',s,cycle)
        rtc.memory(data)
    return s,c

# test RTC.sensor
# while True:
#     sens,cycle= rtc_load_sensor_cycle()
#     print(sens,cycle)
#     sens= sens+1.0
#     rtc_store_sensor_cycle(sens,cycle)
#     time.sleep(1)
#     deepsleep(5*1000)
    
    
