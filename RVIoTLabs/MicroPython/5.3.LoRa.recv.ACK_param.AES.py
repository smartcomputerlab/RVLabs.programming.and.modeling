from machine import Pin, I2C, SPI
import ustruct, random
from lora_init import *
from sensors_display import *
from aes_tools import *
import time

AES_KEY = b'smartcomputerlab'  # Replace with your actual 16-byte AES key
# Initialize LoRa modem
lora_modem = lora_init()

# --- Receive LoRa Packet ---
def onReceive(lora_modem,payload):
    rssi = lora_modem.packetRssi()
    if len(payload)==32:
        rssi = lora_modem.packetRssi()
        data=aes_decrypt(payload,AES_KEY)
        chan, wkey, lumi, temp, humi = ustruct.unpack('i16s3f', data)
        print("Received encrypted LoRa packet with RSSI: "+str(rssi))   #, payload.decode())
        print(chan,wkey,lumi,temp,humi)
        sensors_display(8,9,lumi,temp,humi,0)
        rcycle=random.randint(5,15)
        ack=ustruct.pack('4i3fi',chan,0,20000000,rcycle,0.02,26.0,16.0,10)  # chan, control, freq, cycle, delta, kpack
        enc_ack=aes_encrypt(ack,AES_KEY)
        lora_modem.println(enc_ack)  # sending ACK packet
        print("send encrypted ack AES packet")
        print(chan,0,20000000,rcycle,0.02,26.0,16.0,10)
        lora_modem.receive()

def main():
    lora_modem.onReceive(onReceive)
    lora_modem.receive()
    while True:
        time.sleep(2)
        print("in the loop")
        
main()
