10 DIMDCK[78,2]:DIMMA$[22]:DIMCC[10]:DIMSG[10]:DIMCC$[10]:DIMSG$[10]
20 GOSUB1000:GOSUB1200
30 MENU
1000 GOSUB1100
1010 PRINT@133,"Tarot Spreads";
1020 PRINT@170,"Josef Chessor, 2005";
1030 FORA=1TO22:READMA$[A]:NEXTA
1040 FORA=1TO10:READCC[A]:NEXTA:
1050 FORA=1TO10:READSG[A]:NEXTA
1060 FORA=1TO10:READCC$[A]:NEXTA
1070 FORA=1TO10:READSG$[A]:NEXTA
1080 RETURN
1100 CLS:PRINT@80,STRING$(40,241):PRINT@200,STRING$(40,241)
1120 RETURN
1200 GOSUB 1100
1210 PRINT@85,"���";:PRINT@205,"���";
1220 PRINT@105,"���";:PRINT@225,"���";
1230 PRINT@120,SPACE$(5);"�C� Celtic Cross    � � ":PRINT@160,SPACE$(5);"�S� Star Gate       �M� Menu"
1240 PRINT@53,"Tarot Spreads";
1250 A$=INKEY$:IFA$=""THEN1240
1260 IFA$="C"ORA$="c"THENT=1:GOSUB1300
1270 IFA$="S"ORA$="s"THENT=2:GOSUB1300
1280 IFA$="M"ORA$="m"THENRETURN
1290 GOTO1200
1300 GOSUB1400
1310 CLS:PRINT"Star Gate"
1320 IFT=1THENPRINT@0,"Celtic Cross"
1330 PRINT@40,STRING$(40,241);
1340 FORA=1TO10:PS=CC[A]:IFT=2THENPS=SG[A]
1343 CARD=DCK[A,1]:FLIP=DCK[A,2]
1347 GOSUB1500:PRINT@PS,CARD$;:NEXTA
1350 PRINT@200,"��������":PRINT@240,"�S�Save�":PRINT@280,"�B�Back�";
1360 A$=INKEY$:IFA$=""THEN1360
1370 IFA$="S"ORA$="s"THENGOSUB1600:GOTO1310
1380 IFA$="B"ORA$="b"THENRETURN
1390 GOTO1360
1400 GOSUB1100:PRINT@132,"Shuffling Cards":PRINT@174,"Please Wait"
1410 B=VAL(RIGHT$(TIME$, 2)+MID$(TIME$,4,2))
1420 FORA=1TOB:C=RND(1):NEXTA
1430 FORA=1TO78:DCK[A,1]=A:DCK[A,2]=0:NEXTA
1440 FORA=1TO78:B=INT(RND(1)*78):C=DCK[A,1]:DCK[A,2]=INT(RND(1)*2):DCK[A,1]=DCK[B,1]:DCK[B,1]=C:NEXTA
1450 RETURN
1500 IFCARD<23THENCARD$=MA$[CARD]:GOTO1560
1505 CARD=CARD-22:S$="C"
1510 IFCARD>14ANDCARD<29THENS$="W":CARD=CARD-14
1515 IFCARD>28ANDCARD<43THENS$="S":CARD=CARD-28
1520 IFCARD>42THENS$="P":CARD=CARD-42
1525 IFCARD<=10THENCARD$=MID$(STR$(CARD),2,2)
1530 IFCARD=1THENCARD$="A"
1535 IFCARD=11THENCARD$="P"
1540 IFCARD=12THENCARD$="N"
1545 IFCARD=13THENCARD$="Q"
1550 IFCARD=14THENCARD$="K"
1555 CARD$=CARD$+"of"+S$
1560 IFFLIP=1THENCARD$=CHR$(27)+"p"+CARD$+CHR$(27)+"q"
1565 RETURN
1600 FAIL=1:FN$="":GOSUB1700:IFFAIL=1THENRETURN
1605 PRINT@173," Please Wait "
1610 OPENFN$FOROUTPUTAS#1
1615 PRINT#1,STRING$(39,61)
1620 IFT=1THENPRINT#1,"Celtic Cross ";
1625 IFT=2THENPRINT#1,"Star Gate ";
1630 PRINT#1,"Report
1635 PRINT#1,"Recorded on ";DATE$;" at ";TIME$;"."
1640 PRINT#1,STRING$(39,61)
1645 FORA=1TO10
1650 IFT=1THENMSG$=CC$[A]
1655 IFT=2THENMSG$=SG$[A]
1660 PRINT#1,MSG$;":";
1670 CARD=DCK[A,1]:FLIP=DCK[A,2]:GOSUB1500
1675 IFLEFT$(CARD$,1)=CHR$(27)THENCARD$=LEFT$(CARD$,LEN(CARD$)-2):CARD$=RIGHT$(CARD$,LEN(CARD$)-2):CARD$=CARD$+" (Rev)"
1676 IFLEN(MSG$)<=14THENPRINT#1,CHR$(9);
1680 PRINT#1,CHR$(9);CARD$
1685 NEXTA
1690 PRINT#1,STRING$(39,61)
1695 CLOSE#1
1699 RETURN
1700 PRINT@0,"Save Report"
1705 PRINT@200,SPACE$(8)
1710 PRINT@240,SPACE$(8)
1715 PRINT@280,"Press ESC to Cancel.";
1720 PRINT@132,"���������������"
1725 PRINT@172,"�Name:        �"
1730 PRINT@212,"���������������"
1735 A$=INKEY$:IFA$=""THEN1735
1740 A=ASC(A$):IFA=27THEN1799
1745 IFA=13ANDLEN(FN$)>0THENFAIL=0:GOTO1799
1750 IF(A=8ORA=29)ANDLEN(FN$)>0THENFN$=LEFT$(FN$,LEN(FN$)-1):GOTO1795
1780 IF(A<48ORA>122)OR(A>90ANDA<97)OR(A>57ANDA<65)THENPRINT@318,CHR$(7);:GOTO1735
1790 IFLEN(FN$)<6THENFN$=FN$+A$
1795 PRINT@179,SPACE$(6):PRINT@179,FN$;:GOTO1735
1799 RETURN 
1800 DATA "MAGI","HPRS","EMPS","EMPR"
1810 DATA "HIER","LOVE","CHAR","STRE"
1820 DATA "HERM","WHEE","JUST","HANG"
1830 DATA "DEAT","TEMP","DEVI","TOWE"
1840 DATA "STAR","MOON","TSUN","JUDG"
1850 DATA "WORL","FOOL"
1860 DATA 171,213,091,164,291
1870 DATA 180,268,188,108,196
1880 DATA 161,169,177,185,193
1890 DATA 213,221,125,149,97
1900 DATA "The subject","Subject's influence","Far past","Near past","Present"
1910 DATA "Near future","Subject's view","Others' view","Hopes and fears","Final outcome"
1920 DATA "Past helping","Past detracting","You now","Future helping","Future detracting"
1930 DATA "Present helping","Present detracting","Past issue","Future issue","Present issue"
