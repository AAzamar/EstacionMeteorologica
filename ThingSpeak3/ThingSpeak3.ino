#include "secrets.h"          /* Library whith keys and credentials*/
#include <ThingSpeak.h>       /* ThingSpeak protocols*/
#include <ESP8266WiFi.h>      /* Node MCU ESP8266 Wi-Fi library*/
#include <Wire.h>             /* Lux Sensor, I2C*/
#include <DHT.h>              /* Temperature & humidity sensor*/

#define DHTPIN     D5
#define dRain      D6
#define transistor D7
#define DHTTYPE DHT11
#define sleepTime 900e6            /* Time in micro-seconds 15min (900e6)*/
DHT dht(DHTPIN, DHTTYPE);

char ssid[] = SECRET_SSID;
char pass[] = SECRET_PASS;
unsigned long myChannelNumber = SECRET_CH_ID;
const char * myWriteAPIKey = SECRET_WRITE_APIKEY;
WiFiClient client;
float mq, humidity, temperature, voltage, battery;
String myStatus = "";             /* Initializing ThingSpeak channel Status*/
int BH1750_Device = 0x23;         /* I2C address for light sensor*/
int Lux, rain;
int n,z = 0;                      /* Temporal variables*/

void setup() {
  //Serial.begin(115200);                 /* Set serial baud rate*/
  pinMode(transistor, OUTPUT);          /* Transistor gate signal*/
  Wire.begin();                         /* Initialize BH1750 interface*/
  Wire.beginTransmission(BH1750_Device);
  Wire.write(0x10);                     /* Set resolution to 1 Lux*/
  Wire.endTransmission();
  dht.begin();                          /* Initialize DHT11 inteface*/
  WiFi.mode(WIFI_STA);                  /* Setting a WiFi boot mode*/
  ThingSpeak.begin(client);             /* Makes ThingSpeak client*/
}

/* Subroutine to read BH1750 values using the I^2C protocol*/
unsigned int BH1750_Read() {
  unsigned int i=0;
  Wire.beginTransmission(BH1750_Device);
  Wire.requestFrom(BH1750_Device, 2);
  while(Wire.available()){
    i <<=8;
    i|= Wire.read();
    }
  Wire.endTransmission();
  return i/1.2;                         /* Convert to Lux*/
}

void loop() {
  if (millis() >=25500){                /* Interruption timmer priority*/
    //Serial.println("Going to sleep because something went wrong...");
    ESP.deepSleep(200e6);               /* 200 seconds to reboot*/
  }
  digitalWrite(transistor, HIGH);
  if(WiFi.status() != WL_CONNECTED){    /* If not yet connected to WiFi then...*/
    //Serial.print("Attempting to connect to SSID: ");
    //Serial.println(SECRET_SSID);
    while(WiFi.status() != WL_CONNECTED){
      WiFi.begin(ssid, pass);           /* Connect(log) to WPA/WPA2 network*/
      //Serial.print(".");
      //Serial.print(n);
      if(n > 2){
        ESP.deepSleep(sleepTime);       /* SleepTime (in micro-seconds)*/
        }
      n++;
      delay(4700);                      /* Give some seconds to well handshake...*/
    }                                   /* ...too many petitions may hang up the connection*/
    //Serial.println("\nConnected.");
  }
  voltage = analogRead(A0);
  battery = voltage * (4.4427 / 1024.0);/* Scale to voltage*/
  temperature = dht.readTemperature();  /* 0 - 100 °C*/
  humidity = dht.readHumidity();        /* RH %20 - 100 (Dew point)*/
  Lux = BH1750_Read();                  /* Calls subroutine*/
  rain = digitalRead(dRain);            /* Digital rain sensor, binary*/
  if(rain == 0){myStatus = String("It's raining");}
  else{myStatus = String("Is not raining");}
  bak:
  /* ThingSpeak channel only acepts: int, long int, float,char and string values*/
  ThingSpeak.setField(1, temperature);
  ThingSpeak.setField(2, humidity);
  ThingSpeak.setField(3, Lux);
  ThingSpeak.setField(4, rain);
  ThingSpeak.setField(5, battery);
  ThingSpeak.setStatus(myStatus);     /* The string status of rain*/
   
  int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
  if(x == 200){
    //Serial.println("Channel update successful.");
    //Serial.println("Going to sleep... Setting LOW RST pin...");
    ESP.deepSleep(sleepTime); /* SleepTime (in micro-seconds), WiFi signal reboot mode*/
  }
  else{
    //Serial.println("Problem updating channel. HTTP error code " + String(x));
    delay(500);
    z++;
    if(z > 2){
      //Serial.println("Going to sleep... Setting LOW RST pin...");
      ESP.deepSleep(sleepTime); /* SleepTime (in micro-seconds), WiFi signal reboot mode*/
    }
    goto bak;
  }
}
