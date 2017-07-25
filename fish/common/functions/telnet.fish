function telnet
   set -l netcat (which ncat)
   if [ "$netcat" != "" ]
        ncat -v --recv-only --idle-timeout 5s $argv
   else
        nc -v -z $argv
   end
end

