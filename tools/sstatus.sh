#!/bin/bash
sinfo_o=$(sinfo|grep besteffort)
GPU_used=$(sacct -a -X --format=JobID,AllocCPUS,State,Reqgres | grep RUNNING|grep gpu |awk '{print $NF}' | sed -e "s/^gpu://" | awk '{s+=$1} END {print s}')
GPU_available=$(echo "$sinfo_o"|grep -v down | grep -v drain| awk '{s+=$4*4} END {print s}')
Free_Nodes=$(echo "$sinfo_o"|grep idle|awk '{print $4}')
Total_Nodes=$(echo "$sinfo_o"|awk '{s+=$4} END {print s}')

Jobs=$(sacct -a -X -u $USER --format=partition,JobID,JobName,State,Reqgres,CPUTime)
usingGPU=$(echo "$Jobs"|awk '/titanic/ && /gpu/ && /RUNNING/'|awk '{print $5}'|sed -e "s/^gpu://"|awk '{s+=$1} END {print s}')

if (($(echo "$sinfo_o"|grep idle|wc -l)==0))
then
    NodesN=""
else
    NodesN=": "$(echo "$sinfo_o"|grep idle|awk '{print $6}')
fi
printf 'Titanic status: \n\nGPU Usage: %d/%d' "$GPU_used" "$GPU_available"
printf '\nFree Nodes: %d/%d%s' "$Free_Nodes" "$Total_Nodes" "$NodesN"
printf "\n\n==================================================\n"
printf "Job details for user %s:\n\n" "$USER"
printf "Using %d/4 GPUs allowed on priority queue.\n\n" "$usingGPU"
if (($(echo "$Jobs"|wc -l)==2))
then
    printf "No recent jobs for user %s." "$USER"
else
    echo "$Jobs"
fi

printf "\n"
