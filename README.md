# Shell_grep
search in globe and print

* Script

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

       for lineon in $(grep -n "$pattern" $1 | cut -d: -f1) #(a) 
       do
           if [$context -gt 0]; then
              prev = "$(( $lineon - $context))"


                 if [ $prev -lt 1]; then
                    prev="1"

                 fi
                   next = "(( $lineon + $context ))"

                 if [ $matches -gt 0]; then
                 echo "${prev}i\\" >> $sedscript #(b) 

                 fi
                  echo "${prev,${next}p}" >> $sedscript


           else
             echo "${lineon}p" >> $sedscript #(c) 


           fi
            matches = "$(( matches +1 ))"
       done

       if [$matches -gt 0]; then
          sed -n -f $sedscript $1 | uniq | more #(d)
       fi

      }


      exit 0
      
* Syntax

   * (a) grep -n
   
      取得所有符合模板文字的行號。
   
      
   
   * (b)
   
   * (c)
   
   * (d)
      
* Execution Scripts

此腳本可接受輸入串流或是檔案，可將串流暫存至暫存檔案，方才處理暫存檔案，抑或是命令列指定檔案（可指定一個或是多個檔案）。

        $ cgrep -c 1 tea tea.txt


