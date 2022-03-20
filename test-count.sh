#!/bin/bash

namespace="prometheus"
search_word=""

array_list_name=$(echo $(kubectl get po -n prometheus | grep "stack-prome*"  | awk '{print $1 }') )

#echo ${#array_name[@]}  # 배열갯수  ${#array[*]}

read -a pod_names <<< "${array_list_name}"
#echo ${pod_names[1]}

for (( i = 0 ; i < ${#pod_names[@]} ; i++ )) ; do
    #echo "pod[$i] = ${pod_names[$i]}"
    #echo ${pod_names[$i]}        
    #echo "-------------------"
    #eval eval_val[$i]="aaa"
    #echo ${eval_val[$1]}
    
    
    success_count[$i]=`kubectl logs -n prometheus ${pod_names[$i]} | grep collector | wc -l`
    fail_count[$i]=`kubectl logs -n prometheus ${pod_names[$i]} | grep -v collector | wc -l`
    fail_count_429[$i]=`kubectl logs -n prometheus ${pod_names[$i]} | grep -v collector | wc -l`
    #etc_count[$i]=`kubectl logs -n prometheus ${pod_names[$i]} | grep collector | wc -l`
    etc_count[$i]=0
    tot_count[$i]=`kubectl logs -n prometheus ${pod_names[$i]} |  wc -l`
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
