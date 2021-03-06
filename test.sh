#!/bin/bash
CURRDIR=$PWD
echo ___________________
echo TESTING JKCS SETUP:

if [ ! -e ~/.JKCSusersetup.txt ]
then
  echo "Did you run already setup.sh? [The ~/..JKCSusersetup.txt is missing]"
fi
if [ -e .log ]
then
  rm .log
fi
source ~/.JKCSusersetup.txt

##########
if [ ! -d "$WRKDIR" ]
then 
  echo "!!!!!!!!!!!! Working directory does not exist. ($WRKDIR)"
else
  touch $WRKDIR/.test
  if [ ! -e "$WRKDIR/.test" ]
  then
    echo "There is no permission for creating file in the WRKDIR"
  else
    rm $WRKDIR/.test
  fi
fi
##########
cd $WRKDIR
printf "== testing Python2.x:"
printf "== testing Python2.x:\n" >> .log
if [ -e .help ]; then rm .help; fi
program_PYTHON2 --version > .help 2>&1
result=`cat .help | tail -n 1 | cut -c-9`
if [ "$result" == "Python 2." ]
then
  printf " SUCCESFULL\n"
  echo "import numpy" > .test.py
  echo "a=numpy.matrix('1 2;3 4')" >> .test.py
  echo "print(a*a)" >> .test.py
  program_PYTHON2 .test.py > .test.out 2> .test.out
  cd $WRKDIR
  result=`grep -c "[15 22]]" .test.out`
  if [ $result -eq 1 ]
  then
    echo "   -- numpy: SUCCESFULL"
  else
    echo "   -- numpy: UNSUCCESFULL"
    echo "   :: see .log for the error"
    echo "   :: your python version probably does not have numpy libraries"
  fi
  rm .test.py .test.out
else
  printf " UNSUCCESFULL\n" 
  cat .help >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_PYTHON2 -> check the function/setup paths"
fi
rm .help
##########
##########
cd $WRKDIR
printf "== testing Python3.x:"
printf "== testing Python3.x:\n" >> .log
if [ -e .help ]; then rm .help; fi
program_PYTHON3 --version > .help 2>&1
result=`cat .help| tail -n 1 |cut -c-9`
if [ "$result" == "Python 3." ]
then
  printf " SUCCESFULL\n"
  echo "a=30" > .test.py
  #echo "a=numpy.matrix('1 2;3 4')" >> .test.py
  echo "print(a)" >> .test.py
  program_PYTHON3 .test.py > .test.out 2> .test.out
  cd $WRKDIR
  result=`grep -c "30" .test.out`
  if [ $result -eq 1 ]
  then
    echo "   -- numpy: NOT TESTED (NOT NEEDED)"
  else
    echo "   -- numpy: UNSUCCESFULL"
    echo "   :: see .log for the error"
    echo "   :: your python version probably does not have numpy libraries"
  fi
  rm .test.py .test.out
else
  printf " UNSUCCESFULL\n"
  cat .help >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_PYTHON3 -> check the function/setup paths"
fi
rm .help
##########
cd $WRKDIR
printf "== testing ABCluster:"
printf "== testing ABCluster:\n" >> .log
touch .calc.inp
program_ABC .calc.inp 2> .calc.out
cd $WRKDIR
result=`grep -c "Cannot read the cluster file name." .calc.out`
if [ $result -eq 1 ]
then 
  printf " SUCCESFULL\n"
else
  printf " UNSUCCESFULL\n"
  cat .calc.out >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_ABC or setup properly path PATH_ABCluster"
fi
rm .calc.inp .calc.out
##########
cd $WRKDIR
printf "== testing XTB:"
printf "== testing XTB:\n" >> .log
if [ -e .test.xyz ]
then 
  rm .test.xyz
fi
touch .test.xyz
program_XTB .test.xyz > .test.log 2> .test.log
cd $WRKDIR
result=`grep -c "#ERROR! no atoms!" .test.log`
if [ $result -eq 1 ]
then
  printf " SUCCESFULL\n"
else
  printf " UNSUCCESFULL\n"
  cat .test.log >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_XTB or setup properly path PATH_XTB"
fi
rm .test.xyz .test.log
##########
cd $WRKDIR
printf "== testing Gaussian(G16):"
printf "== testing Gaussian(G16):\n" >> .log
touch .test.com
program_G16 .test.com > .test.log 2> .test.log
cd $WRKDIR
result=`grep -c "Route card not found." .test.log`
if [ $result -eq 1 ]
then
  printf " SUCCESFULL\n"
else
  printf " UNSUCCESFULL\n"
  cat .test.log >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_G16 or setup properly path PATH_G16"
fi
rm .test.log .test.com
##########
cd $WRKDIR
printf "== testing GoodVibes:"
printf "== testing GoodVibes:\n" >> .log
touch .test.log
program_GoodVibes .test.log > .test.out 2> /dev/null 
cd $WRKDIR
result=`grep -c "Warning! Couldn't " .test.out`
if [ $result -eq 1 ]
then
  printf " SUCCESFULL\n"
else
  printf " UNSUCCESFULL\n"
  cat .test.out >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_GoodVibes or setup properly path PATH_GoodVibes"
fi
rm .test.out .test.log
if [ -e Goodvibes_output.dat ]; then rm Goodvibes_output.dat; fi
##########
cd $WRKDIR
printf "== testing ORCA:"
printf "== testing ORCA:\n" >> .log
touch .test.inp 
program_ORCA .test.inp > .test.out  2> .test.out
cd $WRKDIR
if [ ! -e .test.out ]; then touch .test.out; fi
result=`grep -c "You must have a \[COORDS\] ... \[END\] block in your input" .test.out`
if [ $result -ne 0 ]
then
  printf " SUCCESFULL\n"
else
  printf " UNSUCCESFULL\n"
  cat .test.out >> .log
  echo "####################################" >> .log
  echo "   :: see .log for the error"
  echo "   :: open ~/.JKCSusersetup -> check program_ORCA or setup properly path PATH_ORCA"
fi
cd $CURRDIR
echo ___________________
rm .test.inp .test.inp.out .test.out .test.xyz  2>/dev/null
rm .*.cmd 2>/dev/null
rm .*.out 2>/dev/null
rm .*.log 2>/dev/null
if [ -e TMP ]; then rm -r TMP; fi
