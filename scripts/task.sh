#!/usr/bin/env bash


function print_time() {
  seconds=$1
  hour=$(( $seconds/3600 ))
  min=$(( ($seconds-${hour}*3600)/60 ))
  sec=$(( $seconds-${hour}*3600-${min}*60 ))

  [[ $hour == 0 ]] && hour="" || hour=`printf "%02d" $hour`
  [[ $min == 0 ]] && min="" || min=`printf "%02d" $min`
  [[ $sec == 0 ]] && sec="" || sec=`printf "%02d" $sec`
  [[ $seconds -lt 0 ]] && prefix='-' && sec=${sec#-}

  echo $prefix${hour:+${hour#-}":"}${min:+${min#-}":"}${sec:-00}
}

index=1
for line in $(task list |sed -n 3p); do
  if [ $index == 1 ]; then
    rule=$index-${#line}
  else
    rule=$(( $index ))-$(( $index + ${#line} ))
    index=$(( $index + 1 ))
  fi
  index=$(( $index + ${#line} ))
  read head value <<< $(task list | cut -b$rule | sed -n "2s/^[ \t]*//p;4s/^[ \t]*//p" | tr -s '\n' ' ')
  case $head in
    ID) taskid=$value && echo $value > /tmp/task.id && printf " %s " $value ;;
    Active) printf "%s " $value ;;
    Project) printf "@%s " $value ;;
    Tags) printf "#%s " $value ;;
    Description) printf "  " && printf "%s " $value ;;
    Due) due="$(( `task $taskid rc.verbose: rc.report.next.columns:due.epoch rc.report.next.labels:1 limit:1 next` - `date '+%s'` ))" ;;
    Urg) ;;
    *) [ -n "$value" ] && printf "%s " $value ;;
  esac
done

[ -n "$due" ] && printf "祥 %s" `print_time $due` || echo
