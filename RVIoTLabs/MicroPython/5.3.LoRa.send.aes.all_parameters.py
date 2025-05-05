import time, ustruct
from machine import I2C, Pin, freq, deepsleep
from sensors import sensors
from lora_init import lora_init
from aes_tools import *
from rtc_tools import *
AES_KEY = b'smartcomputerlab'  # Replace with your actual 16-byte AES key
# Initialize LoRa communication
lora = lora_init()
chan = 1234
def_cycle=10; cycle=10; scycle=10
t_high=25.0; t_low=19.0; kpack=10
delta=0.1
led = Pin(3, Pin.OUT)

def onReceive(lora_modem,payload):
    global cycle; global delta; global t_high; global t_low; 
    if len(payload)==32:
        ack=aes_decrypt(payload,AES_KEY)
        rchan, control, freq, cycle, delta, t_high, t_low, kpack = ustruct.unpack('4i3fi', ack)
        print("encrypted ACK received"); 
        if chan==rchan :
            rtc_store_cycle(cycle); rtc_store_par(delta,t_high,t_low,kpack)
            print(rchan,control,freq,cycle,delta,t_high,t_low,kpack)
        lora.sleep()                      # only for deepsleep
        time.sleep(0.1)
        if cycle <600:
            deepsleep(cycle*1000)                # 10*1000 miliseconds
        else:
            deepsleep(def_cycle*1000)
            
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
    global scycle
    freq(20000000)
    lora.onReceive(onReceive)
    lora.receive()
    while True:
        counter= rtc_load_counter()
        print("counter:" +str(counter)); counter= counter+1
        rtc_store_counter(counter)
        lumi, temp, humi = sensors(sda=8, scl=9)
        print("Luminosity:", lumi, "lux")
        print("Temperature:", temp, "C")
        print("Humidity:", humi, "%")
        stemp =rtc_load_sensor();scycle=rtc_load_cycle()
        sdelta,st_high,st_low,skpack =rtc_load_par()
        print(temp,stemp); print(cycle,scycle); print(delta,sdelta); print(t_high,st_high); print(t_low,st_low)
        if abs(stemp-temp)>sdelta or temp>st_high or temp<st_low or (counter%kpack)==0:
            led.on()
            rtc_store_sensor(temp)
            send_lora_data(lumi, temp, humi)
            print("data SENT")
            lora.receive()
            time.sleep(ACK_wait_time)
            led.off()
        else:
            print("data packet NOT sent")
            # waiting for ACK frame
        print("we are here if there is no ack received before")
        lora.sleep()                      # only for deepsleep
        time.sleep(0.1)
        print(scycle)
        if scycle:
            deepsleep(scycle*1000)                # 10*1000 miliseconds
        else:
            deepsleep(def_cycle*1000)   

# Run the main program
main()
