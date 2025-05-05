from machine import Pin, I2C, SPI
import ustruct
from lora_init import *
from sensors_display import *
import time

# Initialize LoRa modem
lora_modem = lora_init()

# --- Receive LoRa Packet ---


def onReceive(lora_modem,payload):
    rssi = lora_modem.packetRssi()
    #print("Waiting for LoRa packets...")
    chan, wkey, lumi, temp, humi = ustruct.unpack('i16s3f', payload)
    print("Received LoRa packet:"+str(rssi))   #, payload.decode())
    print(chan,wkey,lumi,temp,humi)
    sensors_display(8,9,lumi,temp,humi,0)
    lora_modem.println("ACK_packet")  # sending ACK packet
    lora_modem.receive()

def main():
    lora_modem.onReceive(onReceive)
    lora_modem.receive()
    while True:
        time.sleep(2)
        print("in the loop")
        
main()
