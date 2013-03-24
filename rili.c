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
        if(( year % 4 == 0)&& (year & 100 != 0) || (year % 400 ==0 )){
            everyyear=366;
            return everyyear;
        }
        else{
            everyyear=365;
        }
    }
	int yearnum;
	int yeartoyear(year){
		yearnum=year-2000;
		if (year<2000){
			yearnum=-yearnum;
		}
		return yearnum;
	}
	int i,allday;
	allday=0;
	int allday_no_theyear(year){
		i=0;
		while (i<yearnum){
			runnian(year);
			allday=allday+everyyear;	
			if (year>2000){
				year--;
			}
			else {
				year++;
			}
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
				if(everyyear=365){
					monthday=28;
				}
				else {
					monthday=29;
				}
				case 4: case 6: case 9: case 11:
					monthday=30;
				default:
					monthday=31;
			}
			day_monch=day_monch+monthday;
			i++;
		}	
		return day_monch;
	}
	yeartoyear(year);
	day_today(year);
	allday_no_theyear(year);
	total_day=allday+day_monch+1;
//	printf("total is %d",total_day);
}
