#include <stdio.h>
#include "time.h"
#include "genlib.h"
#include "simpio.h"

#define  Sunday		1
#define  Monday   	2
#define  Tuesday 	3
#define  Wednesday  4
#define  Thursday   5
#define  Friday		6
#define  Saturday   0
main()
{
	int year,month;
	printf("please enter year   :");
	year=GetInteger();
	printf("please enter month  :");
	month=GetInteger();
	string printf_monch(int month){
		switch (month)	{
			case 1: return ("January");
			case 2: return ("Febuary");
			case 3: return ("March");
			case 4: return ("April");
			case 5: return ("May");
			case 6: return ("June");
			case 7: return ("July");
			case 8: return ("August");
			case 9: return ("September");
			case 10: return ("October");
			case 11: return ("November");
			case 12: return ("December");
			default: return ("plesre enter month");
		}
	}
	int everyyear;
    int runnian(year){
        if(( year % 4 == 0)&& (year % 100 != 0) || (year % 400 ==0 )){
            everyyear=366;
            return everyyear;
        }
        else{
            everyyear=365;
        }
    }
	int i,allday,yearnum;
	allday=0;
	int allday_no_theyear(year){
		i=0;
		yearnum=year-1;
		while (i<yearnum){
			runnian(year-1);
			allday=allday+everyyear;	
			year--;
		i++;
		}
		return allday;
	}	
	int day_monch=0,monthday,total_day;
	int day_today(year){
		runnian(year);
		i=1;
		while(i<month){
			switch (i){
				case 2:
				if(everyyear==365){
					monthday=28;
				}
				else {
					monthday=29;
				};break;
				case 4: case 6: case 9: case 11:
					monthday=30;break;
				default:
					monthday=31;break;
			}
//			printf("%d\n",monthday);
			day_monch=day_monch+monthday;
			i++;
		}	
		return day_monch;
	}
	allday_no_theyear(year);
	day_today(year);
	total_day=allday+day_monch+1;
//	printf("the year have %d\n",allday);
//	printf("total is %d\n",total_day);
	int week=total_day%7;
	int mday;
	switch (month){
		case 2:
		if(everyyear==365){
			mday=28;
		}
		else {
			mday=29;
		}
		case 4: case 6: case 9: case 11:
			mday=30;
		default:
			mday=31;
	}	
	int day=1;
	printf("            %d\n",year);
	switch (month)	{
		case 1: printf ("            January\n");break;
		case 2: printf ("            Febuary\n");break;
		case 3: printf ("            March\n");break;
		case 4: printf ("            April\n");break;
		case 5: printf ("            May\n");break;
		case 6: printf ("            June\n");break;
		case 7: printf ("            July\n");break;
		case 8: printf ("            August\n");break;
		case 9: printf ("            September\n");break;
		case 10: printf ("            October\n");break;
		case 11: printf ("            November\n");break;
		case 12: printf ("            December\n");break;
		default: printf ("            plesre enter month\n");break;
	}
//	printf("total is %d\n",week);
	switch (week){
		case 6: printf("                          %2d",day);break;
		case 0: printf("  %2d",day);break;
		case 1: printf("      %2d",day);break;
		case 2: printf("          %2d",day);break;
		case 3: printf("              %2d",day);break;
		case 4: printf("                  %2d",day);break;
		case 5: printf("                      %2d",day);break;
		default: printf("bad!");break;
	}
//	printf("hello world\n");
	if (week==6){
		printf("\n");
	}
	for (i=2;i<mday+1;i++){
		printf("  %2d",i);
		if ((i+total_day-1)%7==6){
		printf("\n");
		}
	}
}
