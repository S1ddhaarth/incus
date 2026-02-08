#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <LittleFS.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>

const char* ssid = "Tinker Space";
const char* password = "123tinkerspace";
const char* dbUrl = "https://athuvendamone-676767-default-rtdb.firebaseio.com/vitals.json";

ESP8266WebServer server(80);
const int ledPin = 2;

const int LED_ON = LOW;
const int LED_OFF = HIGH;

float breathingRateVar = 0.0;
int diastolicVar = 0;
int glucoseVar = 0;
int spo2Var = 0;
int systolicVar = 0;

unsigned long lastTime = 0;
unsigned long timerDelay = 1000;

void logStatus(String message) {
  File file = LittleFS.open("/logs.txt", "a");
  if (!file) {
    Serial.println("Failed to open file for appending");
    return;
  }
  file.println(message);
  file.close();
}

void setup() {
  Serial.begin(115200);
  
  if (!LittleFS.begin()) {
    Serial.println("An Error has occurred while mounting LittleFS");
    return;
  }

  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, HIGH);

  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
    
  Serial.println("");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP());

  server.on("/logs.txt", []() {
    if (LittleFS.exists("/logs.txt")) {
      File file = LittleFS.open("/logs.txt", "r");
      server.streamFile(file, "text/plain");
      file.close();
    } else {
      server.send(200, "text/plain", "No logs yet.");
    }
  });

  server.onNotFound([]() {
    String path = server.uri();
    path.remove(0, 1);
    int receivedVal = path.toInt();

    switch (receivedVal) {
      case 1:
        Serial.println("Executed Case 1");
        digitalWrite(ledPin, LED_ON);
        logStatus("1");
        break;
        
      case 2:
        Serial.println("Executed Case 2");
        digitalWrite(ledPin, LED_OFF);
        logStatus("2");
        break;

      default:
        Serial.print("Unknown Value: ");
        Serial.println(receivedVal);
        logStatus("Error");
        break;
    }
    
    server.send(200, "text/plain", "Value Received");
  });

  server.begin();
  Serial.println("Server started");
}

void loop() {
  server.handleClient();

  if ((millis() - lastTime) > timerDelay) {
    if (WiFi.status() == WL_CONNECTED) {
      WiFiClientSecure client;
      client.setInsecure();
      
      HTTPClient http;
      http.begin(client, dbUrl);
      
      int httpResponseCode = http.GET();
      
      if (httpResponseCode > 0) {
        String payload = http.getString();
        
        StaticJsonDocument<512> doc;
        DeserializationError error = deserializeJson(doc, payload);

        if (!error) {
          breathingRateVar = doc["breathingRate"];
          diastolicVar = doc["diastolic"];
          glucoseVar = doc["glucose"];
          spo2Var = doc["spo2"];
          systolicVar = doc["systolic"];

          Serial.println("-------------------------");
          Serial.print("Breathing Rate: "); Serial.println(breathingRateVar);
          Serial.print("Diastolic: "); Serial.println(diastolicVar);
          Serial.print("Glucose: "); Serial.println(glucoseVar);
          Serial.print("SpO2: "); Serial.println(spo2Var);
          Serial.print("Systolic: "); Serial.println(systolicVar);
        } else {
          Serial.print("JSON Parsing Failed: ");
          Serial.println(error.c_str());
        }
      } else {
        Serial.print("HTTP Error code: ");
        Serial.println(httpResponseCode);
      }
      http.end();
    }
    lastTime = millis();
  }
}
