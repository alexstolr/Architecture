#include <stdio.h>
#include <stdlib.h>

extern int calc_func(long long *x, int numOfRounds);










int compare (long long * x, long long * y){
  
  unsigned long long* original = (unsigned long long*)(y);
  unsigned long long* new = (unsigned long long*)(x);
 
  /*
printf("comparing x: %016llx with new: %016llx\n",*original,*new);

  */
  
if(*x != *y){
  /*
  printf("\n not equal \n");
  */
 return 0;
}
/*
printf("\nEQUAL!\n");
*/

return 1;
    
  
}

/*
void print_arr_normal(char* c){
  
  printf("\n*******normal********\n");
  int i=0;
  char temp;

  for(i=0;i<16;i++){
    temp = *(c+i);
    temp = temp + 48;
    printf("%c",temp);

  }
  printf("\n*******normal*******\n");
  
  
}



void print_unsigned_long_long(char* c){
  
  printf("\n*******printing unsigned number********\n");
  int i=0;
  char left;
  char right;
  for(i=7;i>=0;i--){
    left = *(c+i);
    left = left >> 4;
    right = *(c+i);
    right = right << 4;
    right = right >> 4;
    right = right + 48;
    left = left + 48;
    if(right >57){
      right = right + 8;
    }
    if(left >57){
      right = right + 8;
    }
    if(right <48){
      right = right + 23;
    }
        if(left <48){
      left = left + 23;
    }
    printf("%c%c",left,right);

  }
  printf("\n*******printing unsigned number********\n");
  
  
}
*/







int main(int argc, char** argv)
{
	
char str[18] = "";
int num = 0;

  scanf("%s",str);

   char *ptr;
   unsigned long long ret;
   scanf("%d",&num);
    
   ret = strtoull(str, &ptr, 16);
 
   //printf("%016llx\n",ret);
   //printf("%016llx\n", ret);
   
   calc_func(&ret,num);
   
   /*
   num = ret;
	for(i = 0;i<16;i++){
		mod = num%16;	
		printf("%x\n",mod);
		num = num/16;
		
	}
	*/
  
	
  return 0;
}
