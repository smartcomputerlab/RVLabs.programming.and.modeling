from machine import Pin, I2C, SPI
import ustruct, random, ubinascii, urequests
from lora_init import *
from display_sensors import *
from aes_tools import *
import machine,time
from wifi_tools import *

# WiFi credentials
SSID = 'Bbox-9ECEBF79'
PASS = '54347A3EA6A1D6C36EF6A9E5156F7D'

AES_KEY = b'smartcomputerlab'  # Replace with your actual 16-byte AES key
# Initialize LoRa modem
lora_modem = lora_init()
rssi=0; chan=0; wkey=""; lumi=0.0; temp=0.0; humi=0.0

 # Function to send data to ThingSpeak
def send_data_to_thingspeak(lumi, temp, humi, rssi):
    try:
        sf1="&field1="+str(lumi); sf2="&field2="+str(temp); sf3="&field3="+str(humi); sf4="&field4="+str(rssi)
        url = "https://thingspeak.com/update?key=YOX31M0EDKO0JATK"+sf1+sf2+sf3+sf4
        response = urequests.get(url)
        response.close()
        print("Data sent to ThingSpeak:", lumi, temp, humi, rssi)
    except Exception as e:
        print("Failed to send data:", e)
        
# --- Receive LoRa Packet ---
def onReceive(lora_modem,payload):
    global rssi; global chan; global wkey; global lumi; global temp; global humi
    rssi = lora_modem.packetRssi()
    if len(payload)==32:
        rssi = lora_modem.packetRssi()
        data=aes_decrypt(payload,AES_KEY)
        chan, wkey, lumi, temp, humi = ustruct.unpack('i16s3f', data)
        print("Received encrypted LoRa packet with RSSI: "+str(rssi))   #, payload.decode())
        print(chan,wkey,lumi,temp,humi)
        display_sensors(8,9,lumi,temp,humi,0)
        rcycle=random.randint(5,15)
        ack=ustruct.pack('2ifi',chan,rcycle,0.01,10)  # chan,cycle, delta, kpack
        enc_ack=aes_encrypt(ack,AES_KEY)
        lora_modem.println(enc_ack)  # sending ACK packet
        print("send encrypted ack AES packet")
        lora_modem.receive()


def main():
    global rssi; global lumi; global temp; global humi
    lora_modem.onReceive(onReceive)
    lora_modem.receive()
    while True:
        if connect_WiFi(SSID, PASS):
            print("WiFi connected")
        send_data_to_thingspeak(lumi, temp, humi, rssi)
        time.sleep(1)
        disconnect_WiFi()
        time.sleep(15)

        
main()
