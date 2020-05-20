#!/bin/bash
# cgrep-- 顯示前後文並且符合模板的全域搜索和列印指令

 context = 0

 esc = "^["

 boldon = "${esc}[1m"

 boldoff = "${esc}[22m"

 tempout = '/tmp/cgrep.$$'

 sedscript = '/tmp/cgrep.sed.$$'

 function MatchOrNot
 {
 
   matches=0

   echo "s/$pattern/${boldon}$pattern${boldoff}/g" >$sedscript

   for lineon in $(grep -n "$pattern" $1 | cut -d: -f1) #(a) -f1 
   do
       if [$context -gt 0]; then
       
          prev = "$(( $lineon - $context))"


		   if [ $prev -lt 1]; then
		      prev="1"

		   fi
		   next = "(( $lineon + $context ))"

		   if [ $matches -gt 0]; then
			   echo "${prev}i\\" >> $sedscript #(b) i\\

		   fi
		    echo "${prev,${next}p}" >> $sedscript


       else
	       echo "${lineon}p" >> $sedscript #(c) >>, p


       fi
        matches = "$(( matches +1 ))"
   done

   if [$matches -gt 0]; then
      sed -n -f $sedscript $1 | uniq | more #(d) -f
   fi
 
 }


exit 0



