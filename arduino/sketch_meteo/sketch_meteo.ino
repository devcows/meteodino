#include <EtherCard.h>
#include <dht22.h>
#include <LiquidCrystal.h>

LiquidCrystal lcd(4, 5, 6, 7, 8, 9);

//DHT connection 
//BUT TAKE CARE how to connect it DHT11: (Data, 5V, GND) when the bleu protection is in front of you.
//                                DHT22: (GND, Data, 5V)
//Digital pin 2
#define DHTPIN 2

#define DHTTYPE DHT11   // DHT 11 
//#define DHTTYPE DHT22   // DHT 22  (AM2302)
//#define DHTTYPE DHT21   // DHT 21 (AM2301)

DHT dht(DHTPIN, DHTTYPE);

float humidity_in, temperature_in, dew_point_in;


// ethernet interface mac address
static byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };

byte Ethernet::buffer[700];
static uint32_t timer;

Stash stash;

// change to the page on that server
const char apiServer[] PROGMEM = "http://<<put-here-your-api-server>>/api/v1/weather_stations/<<put-here-station-id>>/meteo_data";
const char server[] PROGMEM = "<<put-here-your-api-server>>";


// set this to the number of milliseconds delay
// this is 10 minute
#define delayMillisSend 600000UL
#define delayMillisLCD 5000UL

unsigned long thisMillis = 0;
unsigned long lastMillisSend = 0;
unsigned long lastMillisLCD = 0;
unsigned int defaultSensorsRetries = 3;


//Celsius to Fahrenheit conversion
double Fahrenheit(double celsius)
{
	return 1.8 * celsius + 32;
}

// fast integer version with rounding
//int Celcius2Fahrenheit(int celcius)
//{
//  return (celsius * 18 + 5)/10 + 32;
//}


//Celsius to Kelvin conversion
double Kelvin(double celsius)
{
	return celsius + 273.15;
}

// dewPoint function NOAA
// reference (1) : http://wahiduddin.net/calc/density_algorithms.htm
// reference (2) : http://www.colorado.edu/geography/weather_station/Geog_site/about.htm
//
double dewPoint(double celsius, double humidity)
{
	// (1) Saturation Vapor Pressure = ESGG(T)
	double RATIO = 373.15 / (273.15 + celsius);
	double RHS = -7.90298 * (RATIO - 1);
	RHS += 5.02808 * log10(RATIO);
	RHS += -1.3816e-7 * (pow(10, (11.344 * (1 - 1/RATIO ))) - 1) ;
	RHS += 8.1328e-3 * (pow(10, (-3.49149 * (RATIO - 1))) - 1) ;
	RHS += log10(1013.246);

        // factor -3 is to adjust units - Vapor Pressure SVP * humidity
	double VP = pow(10, RHS - 3) * humidity;

        // (2) DEWPOINT = F(Vapor Pressure)
	double T = log(VP/0.61078);   // temp var
	return (241.88 * T) / (17.558 - T);
}

// delta max = 0.6544 wrt dewPoint()
// 6.9 x faster than dewPoint()
// reference: http://en.wikipedia.org/wiki/Dew_point
double dewPointFast(double celsius, double humidity)
{
	double a = 17.271;
	double b = 237.7;
	double temp = (a * celsius) / (b + celsius) + log(humidity*0.01);
	double Td = (b * temp) / (a - temp);
	return Td;
}

void setup()
{  
  Serial.begin(9600);
  Serial.println("Begin setup:");
 
  lcd.begin(16, 2);

  lcd.setCursor(0,0);
  lcd.write("Begin setup:");  
  
  pinMode(DHTPIN, INPUT);           // set pin to input
  dht.begin();
  
  if (ether.begin(sizeof Ethernet::buffer, mymac, 10) == 0) {
    Serial.println(F("Failed to access Ethernet controller"));
  }
  
  if (!ether.dhcpSetup()){
    Serial.println(F("DHCP failed"));
  }
  
  if (!ether.dnsLookup(server)){
    Serial.println("DNS failed");
  }  
  ether.printIp("Server: ", ether.hisip);

  while (ether.clientWaitingGw()){
    ether.packetLoop(ether.packetReceive());
  }
  Serial.println("Gateway found");

  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip); 

  Serial.println(F("Ready"));
  Serial.println();

  readSensors(defaultSensorsRetries);
  sendToAPI(humidity_in, temperature_in, dew_point_in);
  writeLCD(humidity_in, temperature_in, dew_point_in);
}

static byte sendToAPI (float humidity, float temperature, float dew_point) {
  Serial.println("Sending meteo_datum...");
  
  Serial.print("Humidity (%): ");
  Serial.println(humidity, 2);

  Serial.print("Temperature (°C): ");
  Serial.println(temperature, 2);

  //Serial.print("Dew Point (°C): ");
  //Serial.println(dewPoint(DHT11.temperature, DHT11.humidity));

  Serial.print("Dew PointFast (°C): ");
  Serial.println(dew_point); 
  
  byte sd = stash.create();   
  stash.print("{\"meteo_data\":{\"token\":\"<<put-here-token-station>>\",\"humidity_in\":\"");
  stash.print(humidity);
  stash.print("\",\"temperature_in\":\"");
  stash.print(temperature);
  stash.print("\",\"dew_point_in\":\"");
  stash.print(dew_point);
  stash.print("\"}}");  
  stash.save();

  // Compose the http POST request, taking the headers below and appending
  // previously created stash in the sd holder. 
  Stash::prepare(PSTR("POST $F HTTP/1.1\r\n"
    "Host: $F\r\n"
    "Content-Type: application/json\r\n"
    "Accept: application/json\r\n"
    "Content-Length: $D\r\n"    
    "\r\n"
    "$H"),
  apiServer, server, stash.size(), sd);
  
  // send the packet - this also releases all stash buffers once done
  // Save the session ID so we can watch for it in the main loop.
  int session = ether.tcpSend();
  delay(50);
  
  return session;
}

void readSensors(int retries){
  Serial.print("Read sensors: ");
    
  humidity_in = dht.readHumidity();
  temperature_in = dht.readTemperature();
  
  while(isnan(temperature_in) || isnan(humidity_in)) {
    humidity_in = dht.readHumidity();
    temperature_in = dht.readTemperature();    
  }
  
  dew_point_in = dewPoint(temperature_in, humidity_in);
   
    
  Serial.print("Humidity (%): ");
  Serial.println(humidity_in, 2);

  Serial.print("Temperature (°C): ");
  Serial.println(temperature_in, 2);

  Serial.print("Dew Point (°C): ");
  Serial.println(dew_point_in);
}

void writeLCD(float humidity, float temperature, float dew_point){
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.write("Tmp:");
  lcd.print(temperature,1);  
  lcd.write("Hum:");  
  lcd.print(humidity,1);
  lcd.setCursor(0,1);
  lcd.write("Dew_point:");
  lcd.print(dew_point,1);   
}


void loop()
{
  word len = ether.packetReceive();
  word pos = ether.packetLoop(len);

  thisMillis = millis();
  if(thisMillis - lastMillisSend > delayMillisSend)
  {
    lastMillisSend = thisMillis;
    readSensors(defaultSensorsRetries);    
    sendToAPI(humidity_in, temperature_in, dew_point_in);
  }
  
  if(thisMillis - lastMillisLCD > delayMillisLCD)
  {
    lastMillisLCD = thisMillis;    
    readSensors(defaultSensorsRetries);   
    writeLCD(humidity_in, temperature_in, dew_point_in);
  }    
}
