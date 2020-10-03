void listDir(const char *dirname , int tabs) {
  if ( tabs == 0 ){
    Serial.print("\nListing directory: ");
    Serial.println(dirname);
  }

  Dir dir = FSYS.openDir( dirname );
  while (dir.next()) {
    
    File f = dir.openFile("r");
    
    for( int i=0; i< tabs;++i )Serial.print(" ");
    
    if ( f.isDirectory() ){
        Serial.printf( "%-20.20s  <Directory>\n", f.name() ); 
        listDir ( f.fullName(), tabs+4 );        
    }else{
        Serial.printf("%-20.20s %8d\n",f.name(),f.size());       
    }
    f.close();
  
  } 
}
