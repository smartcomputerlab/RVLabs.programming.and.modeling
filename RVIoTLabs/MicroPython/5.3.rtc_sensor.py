# rtc_sensor.py
import machine, time, ustruct
from machine import deepsleep

rtc = machine.RTC()

def rtc_store_sensor(sensor):
    data = ustruct.pack('fi',sensor,1)
    rtc.memory(data)
    
def rtc_load_sensor():
    s=20.0; 
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fi',s,1)
        rtc.memory(data)
    s,val = ustruct.unpack('fi', data)
    return s

def rtc_reset_sensor():
    s=0.0; 
    data = rtc.memory()
    if not data:
        data = ustruct.pack('fi',s,1)
        rtc.memory(data)
    else:
        data = ustruct.pack('fi',s,1)
        rtc.memory(data)
    return s

# test RTC.sensor
# while True:
#     sens= rtc_load_sensor()
#     print(sens)
#     sens= sens+1.0
#     rtc_store_sensor(sens)
#     time.sleep(1)
#     deepsleep(5*1000)
    
