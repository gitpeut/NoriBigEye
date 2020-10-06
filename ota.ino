 
void initOTA(){ 

  ArduinoOTA.setHostname( esphostname );
  ArduinoOTA.onStart([]() { 
    mqEyes = false;

    String type;
    if (ArduinoOTA.getCommand() == U_FLASH) {
      type = "sketch";
    } else { // U_FS
      type = "filesystem";
    }

    // NOTE: if updating FS this would be the place to unmount FS using FS.end()
    Serial.println("Start updating " + type);
  });

  ArduinoOTA.onEnd([]() { // do a fancy thing with our board led at end
    mqEyes = true;
  });

  ArduinoOTA.onError([](ota_error_t error) {
    (void)error;
    ESP.restart();
  });

  /* setup the OTA server */
  ArduinoOTA.begin();

}  
