import time, ustruct
from machine import I2C, Pin, freq, deepsleep
from sensors import sensors
from lora_init import lora_init
from aes_tools import *
AES_KEY = b'smartcomputerlab'  # Replace with your actual 16-byte AES key
# Initialize LoRa communication
lora = lora_init()
chan = 1234

def onReceive(lora_modem,payload):
    if len(payload)==32:
        print("encrypted ACK received"); 
        ack=aes_decrypt(payload,AES_KEY)
        rchan, control, freq, cycle, delta, t_high, t_low, kpack = ustruct.unpack('4i3fi', ack)
        print("encrypted ACK received"); 
        if chan==rchan :
            print(rchan,control,freq,cycle,delta,t_high,t_low,kpack)

def send_lora_data(l, t, h):
    try:
        message = f"L:{l:.2f},T:{t:.2f},H:{h:.2f}"
        print("Sending LoRa packet:", message)
        data = ustruct.pack('i16s3f', chan,'smartcomputerlab',l,t,h)
        enc_data=aes_encrypt(data,AES_KEY)
        lora.println(enc_data)
        print("LoRa encrypted packet sent successfully.")
    except Exception as e:
        print("Failed to send LoRa packet:", e)

# Main program
ACK_wait_time = 2                     # ACK waiting time depends on the protocol and data rate
def main():
    freq(20000000)
    lora.onReceive(onReceive)
    lora.receive()
    while True:
        lumi, temp, humi = sensors(sda=8, scl=9)
        print("Luminosity:", lumi, "lux")
        print("Temperature:", temp, "C")
        print("Humidity:", humi, "%")
        send_lora_data(lumi, temp, humi)
        lora.receive()
        time.sleep(ACK_wait_time)           # waiting for ACK frame
        lora.sleep()                      # only for deepsleep
        time.sleep(0.1)
        deepsleep(10*1000)                # 10*1000 miliseconds

# Run the main program
main()
