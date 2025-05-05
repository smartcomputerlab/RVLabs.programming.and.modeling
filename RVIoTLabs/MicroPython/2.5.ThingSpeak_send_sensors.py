from machine import Pin, I2C, deepsleep
import ubinascii, urequests
import machine
from wifi_tools import *
from sensors import sensors
import time
# WiFi credentials
SSID = 'PhoneAP'
PASSWORD = 'smartcomputerlab'

# Initialize MQTT client
rtc = machine.RTC()

 # Function to send data to ThingSpeak
def send_data_to_thingspeak(lumi, temp, humi):
    try:
        sf1="&field1="+str(lumi); sf2="&field2="+str(temp); sf3="&field3="+str(humi)
        url = "https://107.23.148.232/update?key=YOX31M0EDKO0JATK"+sf1+sf2+sf3
        response = urequests.get(url)
        response.close()
        print("Data sent to ThingSpeak:", lumi, temp, humi)
    except Exception as e:
        print("Failed to send data:", e)       

def main():
    delta=0.01
    rtc_mem = rtc.memory()
    if len(rtc_mem) == 0:
        stemp = 20.0
    else:
        stemp = float(rtc_mem.decode())
     
    luminosity, temperature, humidity = sensors(sda=8, scl=9)
    if (abs(stemp-temperature)> delta):
        rtc.memory(str(temperature).encode())
        connect_WiFi(SSID, PASSWORD)
        print("WiFi connected")
        send_data_to_thingspeak(luminosity, temperature, humidity)
        time.sleep(1)
        disconnect_WiFi()
    
    deepsleep(15*1000)
    
# Run the main function
main()