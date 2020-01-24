define(cew_Variables,
         `set $cew_Test_Count=0
          set $cew_Error_Count=0'
)

#cew_Variables

define(cew_Summary,
         `printf "__cew__**********Summary**********\n"
         printf "__cew__Total number of test cases = %d \n", $cew_Test_Count
         printf "__cew__Total number of test cases in error = %d \n", $cew_Error_Count'
)

define(cew_Ncase,
          `set $cew_Test_Count++
          $2
          set $cew_act=$3
          set $cew_exp=$4
          if (($cew_act) != ($cew_exp))
             set $cew_Error_Count++
             printf "__cew__Test Case ERROR (Ncase) in script at line number $1\n"
             printf "__cew__   Actual Value is %d \n", $cew_act
             printf "__cew__   Expected Value is %d \n", $cew_exp
          end'
)

