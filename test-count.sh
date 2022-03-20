#!/bin/bash

namespace="amazon-cloudwatch"
pod_search="fluentd"
search_word=""
date_start=`date -d "-$1 minutes" '+%Y-%m-%dT%H:%M:%SZ'`
#date_start=`date -d "-1 days" '+%Y-%m-%dT%H:%M:%SZ'`
echo $date_start
array_list_name=$(echo $(kubectl get po -n $namespace | grep "$pod_search*"  | awk '{print $1 }') )

#echo ${#array_name[@]}  # 배열갯수  ${#array[*]}

read -a pod_names <<< "${array_list_name}"
#echo ${pod_names[1]}

for (( i = 0 ; i < ${#pod_names[@]} ; i++ )) ; do
    #echo "pod[$i] = ${pod_names[$i]}"
    #echo ${pod_names[$i]}        
    #echo "-------------------"
    #eval eval_val[$i]="aaa"
    #echo ${eval_val[$1]}
    
    #string_cmd="kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start | grep 'retry succeeded. chunk_id' | wc -l"
    #echo $string_cmd
    #eval $string_cmd
    #exit

    success_count[$i]=`kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start | grep "retry succeeded. chunk_id" | wc -l`
    fail_count[$i]=`kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start | grep -v "failed to flush the buffer. retry_time=" | wc -l`
    fail_count_429[$i]=`kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start | grep  ":429" | wc -l`
    etc_count[$i]=`kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start | grep -v "retry succeeded. chunk_id" | grep -v   "failed to flush the buffer. retry_time=" | wc -l`
    tot_count[$i]=`kubectl logs -n $namespace ${pod_names[$i]} --since-time=$date_start |  wc -l`
    let tot_sum=${success_count[$i]}+${fail_count[$i]}+${etc_count[$i]}
    #echo "totsum : $tot_sum   "
    
    let tot_success_count+=success_count[$i]
    let tot_fail_count+=fail_count[$i]
    let tot_fail_count_429+=fail_count_429[$i]
    let tot_etc_count+=etc_count[$i]
    let tot_tot_sum+=tot_sum

    echo "${pod_names[$i]} : success: ${success_count[$i]} + fail: ${fail_count[$i]} + etc: ${etc_count[$i]} = tot: ${tot_count[$i]}, fail_429: ${fail_count_429[$i]} "
   
    
done


let confirm_tot=tot_tot_sum-tot_etc_count
let success_per=tot_success_count*100/confirm_tot
let fail_per=tot_fail_count*100/confirm_tot
let fail_429_per=tot_fail_count_429*100/confirm_tot

echo "Total"
echo ""
echo "success   fail    etc     tot    fail_429  suc_rate  fail_rate fail_429_rate" 
echo "$tot_success_count        $tot_fail_count     $tot_etc_count      $tot_tot_sum       $tot_fail_count_429        $success_per       $fail_per           $fail_429_per"
