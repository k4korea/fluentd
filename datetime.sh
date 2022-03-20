

#!/bin/bash

# dt=`date '+%d/%m/%Y_%H:%M:%S'`

echo $1
dt=$1
echo $dt

now_date=`date '+%Y-%m-%dT%H:%M:%SZ'`
echo $now_date


now_date_5min=`date -d "+5 minutes"`
echo $now_date_5min

# minute
now_date_5min_string=`date -d "-$1 minutes" '+%Y-%m-%dT%H:%M:%SZ'`
echo " input minute : $now_date_5min_string"

# day 
hour_start=`date -d "-1 days" '+%Y-%m-%dT%H:%M:%SZ'`

# two deletedate
two_day_hour_start=`date -d "-5 minutes" -d "-9 hours" '+%Y-%m-%dT%H:%M:%SZ'`
echo $two_day_hour_start


date -d 'tomorrow'		# 어제
date -d '1 day'		        # 1일후
date -d '1 week'		# 1주일후
date -d '1 month'		# 1달후
date -d '1 year'		# 1년후
date -d '10 second'		# 10초후
date -d '10 minute'		# 10분후
date -d '10 hour'		# 10시간후
date -d '1 year 2 month'	# 1년 2개월후
echo `date -d '-9 hour -5 minute'` 




