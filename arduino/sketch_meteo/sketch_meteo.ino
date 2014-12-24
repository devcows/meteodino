#include <EtherCard.h>
#include <dht11.h>

dht11 DHT11;

//Digital pin 5
#define DHT11PIN 5

//DHT connection 
//BUT TAKE CARE how to connect it : (Data, 5V, GND) when the bleu protection is in front of you.


// ethernet interface mac address
static byte mymac[] = { 0x74,0x69,0x69,0x2D,0x30,0x31 };

// remote website ip address and port
static byte hisip[] = { 10,10,10,103 };
static int hisport = 3000;

byte Ethernet::buffer[1024];
static uint32_t timer;

// change to the page on that server
char apiServer[] = "10.10.10.103:3000/api/v1/weather_stations/1/meteo_data";
char proxyHost[] PROGMEM = "10.10.10.103";
int proxyPort = 3000;

int totalCount = 0; 

// set this to the number of milliseconds delay
// this is 5 seconds
#define delayMillis 5000UL

unsigned long thisMillis = 0;
unsigned long lastMillis = 0;



Stash stash;

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
  
  Serial.println("DHT11 TEST PROGRAM ");
  Serial.print("LIBRARY VERSION: ");
  Serial.println(DHT11LIB_VERSION);
  pinMode(DHT11PIN, INPUT);           // set pin to input
  
  
  if (ether.begin(sizeof Ethernet::buffer, mymac, 10) == 0) 
    Serial.println(F("Failed to access Ethernet controller"));
  
  if (!ether.dhcpSetup())
    Serial.println(F("DHCP failed"));

//  if (!ether.dnsLookup("www.google.com"))
//    Serial.println("DNS failed");
  ether.copyIp(ether.hisip, hisip);
  ether.hisport  =  hisport;
  ether.printIp("Server: ", ether.hisip);

  while (ether.clientWaitingGw())
    ether.packetLoop(ether.packetReceive());
  Serial.println("Gateway found");

  ether.printIp("IP:  ", ether.myip);
  ether.printIp("GW:  ", ether.gwip);  
  ether.printIp("DNS: ", ether.dnsip); 

  sendToAPI(6, 7 , 8);

  Serial.println(F("Ready"));
  Serial.println();
}

static byte sendToAPI (float humidity, float temperature, float dew_point) {
  Serial.println("Sending meteo_datum...");
  
  char temperatureString[10];
  char humidityString[10];
  char dew_pointString[10];
  
  dtostrf(temperature,1,2,temperatureString);
  dtostrf(humidity,1,2,humidityString);
  dtostrf(dew_point,1,2,dew_pointString);
  
  byte sd = stash.create();
   
  stash.print("{\"meteo_data\":{\"token\":\"test_token\",\"humidity\":\"");
  stash.print(humidityString);
  stash.print("\",\"temperature\":\"");
  stash.print(temperatureString);
  stash.print("\",\"dew_point\":\"");
  stash.print(dew_pointString);
  stash.print("\"}}");  
  stash.save();


  // Compose the http POST request, taking the headers below and appending
  // previously created stash in the sd holder. 
  Stash::prepare(PSTR("POST http://10.10.10.103:3000/api/v1/weather_stations/1/meteo_data HTTP/1.1\r\n"
    "Host: 10.10.10.103:3000\r\n"
    "Content-Type: application/json\r\n"
    "Accept: application/json\r\n"
    "Content-Length: $D\r\n"    
    "\r\n"
    "$H"),
  stash.size(), sd);
  
  // send the packet - this also releases all stash buffers once done
  // Save the session ID so we can watch for it in the main loop.
  return ether.tcpSend();
}


void loop()
{
  Serial.println("Loop\n");

  word len = ether.packetReceive();
  word pos = ether.packetLoop(len);

  thisMillis = millis();
  if(thisMillis - lastMillis > delayMillis)
  {
    lastMillis = thisMillis;
/*

    Serial.print("Read sensor: ");
    int chk = DHT11.read(DHT11PIN);
    switch (chk)
    {
    case DHTLIB_OK: 
		Serial.println("OK"); 
		break;
    case DHTLIB_ERROR_CHECKSUM: 
		Serial.println("Checksum error"); 
		break;
    case DHTLIB_ERROR_TIMEOUT: 
		Serial.println("Time out error"); 
		break;
    default: 
		Serial.println("Unknown error"); 
		break;
    }

    float humidity = DHT11.humidity;
    float temperature = DHT11.temperature;
    float dew_point = dewPointFast(DHT11.temperature, DHT11.humidity);

*/
    float humidity = 5;
    float temperature = 6;
    float dew_point = 7;

    Serial.print("Humidity (%): ");
    Serial.println(humidity, 2);

    Serial.print("Temperature (°C): ");
    Serial.println(temperature, 2);

    //Serial.print("Dew Point (°C): ");
    //Serial.println(dewPoint(DHT11.temperature, DHT11.humidity));

    Serial.print("Dew PointFast (°C): ");
    Serial.println(dew_point); 
    sendToAPI(humidity, temperature, dew_point);

    totalCount++;
    Serial.println(totalCount,DEC);
  }    

  delay(2000);
}




