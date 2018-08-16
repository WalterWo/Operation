#!/bin/sh

_METRIX=$1
_HOSTNAME=`hostname`
_REPORT_PATH=/tmp/reports
#_REPORT_FILE_PATH=${_REPORT_PATH}/${_HOSTNAME}_${_METRIX}_instance_performace.html

if [ ! -d "/tmp/reports/" ];then
mkdir -p /tmp/reports/
fi

#echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' > ${_REPORT_FILE_PATH}

function Check_CPU_average
{
sar -u 1 $1 | grep -i average | awk '{for (i=1 ;i<=NF;i++) if (i==1) { printf "Name :" $1 "%|" ;} else if (i==3) { printf "%USER: " $3 "%|" ;} else if (i==5) { printf "%SYSTEM: " $5 "%|" ;} else if (i==6) { printf "%IOWAIT: " $6 "%" ;}printf "\n"}' > test.txt

awk 'BEGIN{
FS="|"
print "<HTML><TABLE border=2 width='100%' align='centre' BORDERCOLOR='#330000' ><tr bgcolor='#FFFFCC'>" }
{printf "<TR>" "<TD>CPUAverage Top 10 No."NR "</TD>"; for(i=1;i<=NF;i++)printf "<TD>" $i "</TD>"; print "</TR>" }
END{ print "</TABLE></HTML>" }' test.txt >> ${_REPORT_FILE_PATH}
echo $result
}

function Check_MEM_Top_10
{
ps -aux | sort -k4nr | head -n 10 | awk '{for (i=1 ;i<=NF;i++) if (i==1) { printf "USER:" $1 "|" ;} else if (i==2) { printf "PID:" $2 "|" ;} else if (i==4) { printf "%MEM:" $4 "|" ;} else if (i==11) { printf "COMMAND: " $11 " " ;} else if (i!=3 && i!=5 && i!=6 && i!=7 && i!=8 && i!=9 && i!=10){ printf $i " ";} printf "\n"}' > test.txt

#echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' >> mail.html
#echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> '${REPORT_HEADING}'</TH></FONT></TABLE>' >> mail.html

awk 'BEGIN{
FS="|"
print "<HTML><TABLE border=2 width='100%' align='centre' BORDERCOLOR='#330000' ><tr bgcolor='#FFFFCC'>" }
{printf "<TR>" "<TD>Memory Top 10 No."NR "</TD>"; for(i=1;i<=NF;i++)printf "<TD>" $i "</TD>"; print "</TR>" }
END{ print "</TABLE></HTML>" }' test.txt >> ${_REPORT_FILE_PATH}
echo $result
}


function Check_CPU_Top_10
{
ps -aux | sort -k4nr | head -n 10 | awk '{for (i=1 ;i<=NF;i++) if (i==1) { printf "USER:" $1 "|" ;} else if (i==2) { printf "PID:" $2 "|" ;} else if (i==3) { printf "%CPU:" $3 "|" ;} else if (i==11) { printf "COMMAND: " $11 " " ;} else if (i!=4 && i!=5 && i!=6 && i!=7 && i!=8 && i!=9 && i!=10){ printf $i " ";} printf "\n"}' > test.txt

#echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' >> mail.html
#echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> '${REPORT_HEADING}'</TH></FONT></TABLE>' >> mail.html

awk 'BEGIN{
FS="|"
print "<HTML><TABLE border=2 width='100%' align='centre' BORDERCOLOR='#330000' ><tr bgcolor='#FFFFCC'>" }
{printf "<TR>" "<TD>CPU Top 10 No."NR "</TD>"; for(i=1;i<=NF;i++)printf "<TD>" $i "</TD>"; print "</TR>" }
END{ print "</TABLE></HTML>" }' test.txt >> ${_REPORT_FILE_PATH}
echo $result
}

if [ ! -n "$1" ] ;then
    #echo "you have not input a word!"
    echo "step cpu"
    echo "step mem"
    _METRIX=ALL
    _REPORT_FILE_PATH=${_REPORT_PATH}/${_HOSTNAME}_${_METRIX}_instance_performace.html
    
    echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' > ${_REPORT_FILE_PATH}    
    cpu_num=`Check_CPU_Top_10`
    mem_num=`Check_MEM_Top_10`
else
    echo "the word you input is $1"
    if echo $1 | grep -qi "cpu" ;then
    	_REPORT_FILE_PATH=${_REPORT_PATH}/${_HOSTNAME}_${_METRIX}_instance_performace.html
	echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' > ${_REPORT_FILE_PATH}
	if [ ! -n "$2" ] ;then
        Check_CPU_Top_10
        echo "step cpu"
        else
        num=$2
        Check_CPU_Top_10
        Check_CPU_average $num
        echo "step cpu&ave"
        fi
    else
    if echo $1 | grep -qi "mem" ;then
    	echo "step mem"
    	_REPORT_FILE_PATH=${_REPORT_PATH}/${_HOSTNAME}_${_METRIX}_instance_performace.html
	echo '<HTML><TABLE border=1 width=100% align=centre><tr bgcolor=#000080><TH><FONT COLOR=#FFFFFF> BOSTON-MA DATA CENTER REPORTS </TH></FONT></TABLE></HTML>' > ${_REPORT_FILE_PATH}
        Check_MEM_Top_10
    else
      echo "Usage $0 cpu"
      echo "or"
      echo "Usage $0 mem"
   exit 1;
    fi
    fi
fi
