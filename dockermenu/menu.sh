:
opt=""
CONNECT=?
GMATTEST=$GMATROOT/src/test
while [ "$opt" != "XT" ]
  do
        clear
        echo " "
        echo " ================="
        echo " <<< TEST MENU >>>"
        echo " ================="
        echo " ORACLE_SID: $ORACLE_SID"
        echo " CONNECT:    $CONNECT "
        echo " "
		echo "   c.      Enter Oracle connect string          "
        echo "   -----------------------------------------    "
        echo "   a2.     Run all level 2 test suites          "
        echo "   s2.     Run a specific level 2 test suite    "
        echo "   -----------------------------------------    "
        echo "   a3.     Run all level 3 test suites          "
        echo "   s3.     Run a specific level 3 test suite    "
        echo "   -----------------------------------------    "
        echo "   vr.     View report of last full test run    "
        echo "   vt.     View test trail                      "
        echo "   -----------------------------------------    "
        echo "   z.      Zapp! Clean Up Old Test Results      "
        echo "   x.      Exit                                 "
        echo " "
        echo ">>Option?<<"
        read opt opt2 opt3

        case $opt in
                a3|A3) clear ; do.all.sh $CONNECT l3; echo "[Okay]" ; read ans ;;
                s3|S3) clear ; do.suite.sh $CONNECT l3 ? n n ;;
                a2|A2) clear ; do.all.sh $CONNECT l2; echo "[Okay]" ; read ans ;;
                s2|S2) clear ; do.suite.sh $CONNECT l2 ? n n ;;
                #r|R) clear ; do.suite.sh $CONNECT l2 ? n y ;;
                vr|VR) clear ; view $GMATTEST/.test_rpt ;;
                vt|VT) clear ; view $GMATTEST/.test_trail ;;
                c|C) echo "Enter Connect String (userid/password):" ; read ans ; CONNECT=$ans ;;
                z|Z) do.clean.sh ; echo "[Okay]" ; read ans ;;
                x|X) opt="XT"; echo "Exiting..." ;;
                *) echo "ERROR: Unknown Option" ; echo "[Okay]" ; read ans ;;
        esac
done

