import time, ustruct
from machine import I2C, Pin, deepsleep
from sensors import sensors
from lora_init import lora_init
from aes_tools import *
AES_KEY = b'smartcomputerlab'  # Replace with your actual 16-byte AES key
# Initialize LoRa communication
lora = lora_init()
chan = 1234
led=Pin(3)
cycle=10

def onReceive(lora_modem,payload):
    global cycle
    if len(payload)==16:
        ack=aes_decrypt(payload,AES_KEY)
        rchan, cycle, delta, kpack = ustruct.unpack('2ifi', ack)
        print("encrypted ACK received"); 
        if chan==rchan :
            print(cycle,delta,kpack)

# Function to send sensor data over LoRa
def send_lora_data(l, t, h):
    try:
        # Create the message with temperature, humidity, and luminosity
        message = f"L:{l:.2f},T:{t:.2f},H:{h:.2f}"
        print("Sending LoRa packet:", message)
        # prepare data packet with bytes
        data = ustruct.pack('i16s3f', chan,'smartcomputerlab',l,t,h)
        enc_data=aes_encrypt(data,AES_KEY)
        lora.println(enc_data)
        print("LoRa encrypted packet sent successfully.")
    except Exception as e:
        print("Failed to send LoRa packet:", e)

# Main program
ACK_wait_time = 2                     # ACK waiting time depends on the protocol and data rate
def main():
    lora.onReceive(onReceive)
    lora.receive()
    led.off()
    while True:
        led.on()
        lumi, temp, humi = sensors(sda=8, scl=9)
        print("Luminosity:", lumi, "lux")
        print("Temperature:", temp, "C")
        print("Humidity:", humi, "%")
        # Send sensor data over LoRa
        send_lora_data(lumi, temp, humi)
        lora.receive()
        time.sleep(ACK_wait_time)           # waiting for ACK frame
        led.off()
        print(cycle)
        if cycle<600 :						# erroneus value
            time.sleep(cycle)
        else:
            time.sleep(15)
        #lora.sleep()                      # only for deepsleep
        #deepsleep(10*1000)                # 10*1000 miliseconds

# Run the main program
main()
