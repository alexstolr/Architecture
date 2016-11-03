#include <stdio.h>


extern void start(char* filename,int table_len, int table_wid,int gen,int prinfreq);
extern int debug_flag;






int main(int argc, char** argv)
{
  int i=0;
  int bool = 0;
  debug_flag = 0;
  for(i=0;i<argc;i++){
    
   if(argv[i][0] == '-' && argv[i][1] == 'd'){
    debug_flag = 1;
    bool = 1;
    if(i == 1){
    start(argv[2],atoi(argv[3]),atoi(argv[4]),atoi(argv[5]),atoi(argv[6]));
    }
    else{
      start(argv[1],atoi(argv[2]),atoi(argv[3]),atoi(argv[4]),atoi(argv[5]));
    }
    
   }
    
  }
    
  if(bool == 0){    
    start(argv[1],atoi(argv[2]),atoi(argv[3]),atoi(argv[4]),atoi(argv[5])); 

  }

 

 
  return 0;
}

  
  
  
