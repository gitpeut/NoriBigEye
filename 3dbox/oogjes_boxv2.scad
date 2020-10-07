

cd          = 80+0.2;
ch          = 26+8; //higher from 26, oogjes higher
ww          = 1;

lidh        = ch/4;


//visible area on screen
eyew        = 22 - 0.1; // a bit tighter
eyel        = 22 - 0.1;

eyelw       = 35 + 0.4; 
eyeww       = 28 + 0.4;

eyetopl     = 2 + 0.2;
eyebotl     = 6.4;
eyewdif     = eyeww - eyew;

esp12w      = 20.4;
esp12l      = 48.6;

//esp12 holder
sepcside    = 2;
wfudge      = 0.2;
lfudge      = 0.2;  

butxo       = 5.6;
butyo       = 5.2;

$fn=64;

//----------------------------------------------------
module lidclicks(){

cutoutw = 9;    
        translate( [0,0, lidh/2 + ww] ){
            difference(){
       //   cylinder( d=cd+ww/2, h=ww, center=true );
                union(){
                cube( [ cutoutw, cd + 1.5*ww, ww], center=true );
                cube( [ cd + 1.5*ww, cutoutw, ww], center=true );
                
                rotate( [ 0,0,45] )
                    cube( [ cd + 1.5*ww, cutoutw, ww], center=true );
                rotate( [ 0,0,-45] )
                    cube( [ cd + 1.5*ww, cutoutw, ww], center=true );
                }
                cylinder( d=cd, h=ww, center=true );

            }      
        }  
         
}

//---------------------------------------------------
module boxclicks(){

cutoutw = 10;    
    
        translate( [0,0, ch + ww - lidh/2 ] ){
//        difference(){
//          cylinder( d=cd-ww/2, h=ww, center=true );
//          cylinder( d=cd-ww, h=ww, center=true );
            
          cube( [ cutoutw, cd + 2*ww, ww], center=true );
          cube( [ cd + 2*ww, cutoutw, ww], center=true );
          rotate( [ 0,0,45] )
                cube( [ cd + ww, cutoutw, ww], center=true );
          rotate( [ 0,0,-45] )
                cube( [ cd + ww, cutoutw, ww], center=true );
            
        }  
         
}


//----------------------------------------------------
module pcbsep(){
//tolerances, creep and crimp

//height of pcbbseparation
phi     = 5*sepcside;   
//left
translate( [ -(esp12w/2) - sepcside-wfudge/2, -(esp12l+lfudge)/2, 0] )
        cube( size=[ sepcside, esp12l+lfudge, phi] );
//right
 translate( [(esp12w/2) + wfudge/2, -(esp12l+lfudge)/2, 0] )
        cube( size=[ sepcside, esp12l+lfudge, phi] );
//top    
 translate( [ -(esp12w/2) -sepcside-wfudge/2, (esp12l+lfudge)/2, 0] )
        difference(){
        cube( size=[ esp12w+ 2* sepcside + wfudge, sepcside, phi] );
            
        translate( [sepcside+2.2, 0, 2.5])
        cube( size=[ 16+wfudge, sepcside, phi-2.5] );
        }
           
//bottom    
 translate( [ -(esp12w/2) -sepcside-wfudge/2, -(esp12l+lfudge)/2 - sepcside + 15, 0] )
        cube( size=[ esp12w+ 2* sepcside + wfudge, sepcside + 30.5 -15, 4] );
 
 translate( [ -(esp12w/2) -sepcside-wfudge/2, -(esp12l+lfudge)/2 - sepcside, 4] )       
        cube( size=[ esp12w+ 2* sepcside + wfudge, sepcside, phi -4] );
}

//----------------------------------------------------
module tftholder(){
tfth = 5;

    difference(){
        cube( [ eyeww+2*ww, eyelw+2*ww,tfth ] );
        translate([ww,ww,0 ] )
            cube( [ eyeww, eyelw,tfth ] );
    }
}

//--------------------------------------------
module box(){
 screenxoff = 4;
 screenyoff = 6;//from 8
    
 difference(){
    cylinder( d=cd + 2*ww, h=ch + ww);  
    
    translate([0,0,ww])
        cylinder( d=cd, h=ch); 
   
    //left screen +2
    translate( [-eyew/2-screenxoff,-screenyoff + eyew/2,0] ){
            cylinder(d = eyew, h=ww);
    }
    //right screen
    translate( [ eyew/2+screenxoff, -screenyoff+eyew/2,0 ]){
            cylinder(d = eyew, h=ww);
    }
    //power hole
    translate([ 0,cd/2+ ww/2, (ch+2*ww)/2] )
        rotate([90,0,0])
        cylinder(d=6,h=ww);   
    
    //boxclicks();
  }        

 translate( [-eyeww -ww , -screenyoff-eyebotl,0] ) tftholder();
 translate( [ 0, -screenyoff-eyebotl,0] ) tftholder();


}   

//--------------------------------------------------------------
module lid(){

difference(){
    cylinder( d=cd + 2*ww, h=ww);  
 
    translate([ (esp12w/2)+ (wfudge/2)- butxo, -34.45+ butyo,0])       
          cylinder( d=8, h =50); 
}

 translate([0,0,ww])
 difference(){
    cylinder( d=cd-0.2, h=lidh ); 

    cylinder( d=cd-3*ww, h=lidh); 
    


 }
 
 
 
 translate( [0,-esp12l/4 +2,ww] )
    pcbsep();
 

 
 
 
}

//--------------------------------------------------------------

//translate( [ cd+4*ww, 0,0] )
//    box();

lid();