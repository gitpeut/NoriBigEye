
#ifdef ESP32
#include <WiFi.h>
#endif
#ifdef ESP8266
#include <ESP8266WiFi.h>
#endif


const char *resetreasons[] PROGMEM = { "Normale poweron reset", "Hardware watchdog reset", "Exception reset", "Software watchdog reset", "Software restart", "Deepsleep wakup", "External system reset" }; 
//------------------------------------------------------------------------------------------

void publish_resetreason(){
  
static bool sentreason = false;
rst_info *resetInfo;

if ( sentreason )return;

resetInfo = ESP.getResetInfoPtr();;

enum rst_reason {
 REASON_DEFAULT_RST = 0,  /* normal startup by power on */
 REASON_WDT_RST = 1,      /* hardware watch dog reset */
 REASON_EXCEPTION_RST = 2, /* exception reset, GPIO status won't change */
 REASON_SOFT_WDT_RST   = 3, /* software watch dog reset, GPIO status won't change */
 REASON_SOFT_RESTART = 4, /* software restart ,system_restart , GPIO status won't change */
 REASON_DEEP_SLEEP_AWAKE = 5, /* wake up from deep-sleep */
 REASON_EXT_SYS_RST      = 6 /* external system reset */
};


 mqclient.publish( "NoriBigEye/out", resetreasons[ resetInfo->reason ], true);


sentreason = true;  
}



//------------------------------------------------------------------------------------------
boolean mqtt_reconnect() {

static int disconcount=0;
  
if ( !mqclient.connected() ) {
    Serial.println("Connecting to MQTT...");

    char mqid[64];
    byte mac[6];
    WiFi.macAddress( mac );
    Serial.printf( "mac: %02x %02x %02x %02x %02x %02x\n",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]); 
    sprintf( mqid,"%s-%02x%02x%02x", esphostname, mac[3],mac[4],mac[5]); 

    if (mqclient.connect( mqid, mqttUser, mqttPassword )) {
      
      Serial.println("connected");
      disconcount=0;

    
    // Subscriptions
    
    mqclient.subscribe( proxtopic ); 
    mqclient.subscribe( statustopic ); 

    publish_resetreason();
      
} else {
      
      Serial.print("Connect to MQTT failed with state ");
      Serial.println(mqclient.state());

       if (WiFi.status() != WL_CONNECTED) {
        //wificonnected = false;
        disconcount++;
        
        if ( disconcount > 10 ){
          Serial.println("Lost WiFi connection, restart in 10 seconds...");
          delay(10000);
          ESP.restart();
        }
       }
  }
}

return mqclient.connected();
}

/*-----------------------------------------------------------------*/
void mqtt_check(){
 static int oldmillis=0;
  
  if ( millis() - oldmillis > 200 ){
    oldmillis = millis();
    
    if ( mqclient.connected() ) {
      mqclient.loop();
    }else{ 
      if ( mqtt_reconnect() == false) oldmillis = oldmillis - 2000;
    }
  }
  
}  
/*-----------------------------------------------------------------*/

void mqtt_init(){

mqclient.setBufferSize( 1024 );
mqclient.setServer(mqttServer, 1883);
mqclient.setCallback( mqtt_callback );


mqtt_reconnect();

}

//-----------------------------------------------------------------

bool mqtt_callback(char* topic, byte *payload, unsigned int len) {
   StaticJsonDocument<1024> payloadz;
   
   deserializeJson( payloadz, payload, len);

   Serial.printf("MQ message received on topic %s, mqEyes is now %d\n", topic, mqEyes ); 

   if ( 0 == strcmp( topic, proxtopic) ){
        mqEyes = payloadz["proximity"];
   }
   if ( 0 == strcmp( topic, statustopic) ){
        const char  *proxs = payloadz["ProxOnOff"];
        
        if (  0 == strcmp( proxs, "On") ) {
          mqEyes = 1;
        }else{
          mqEyes = 0;
        }
   }
   Serial.printf("After reading the message, mqEyes is now %d\n", mqEyes ); 

  return(true);
}
