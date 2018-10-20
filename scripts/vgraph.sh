#!/bin/bash
#
# Value Graph (vgraph)
# Basic ASCII Graphing Tool
#
# Plot values and scale to max
#
# CSV format: Name, Value
#
# Awk isn't perfect at rounding.. .5 rounds down
#
# CREDITS TO:
# v1.1 sol@subnetzero.org
# Thanks!
#

if [ -z $1 ]; then
        printf "Usage: pgraph [datafile]\n"
        exit 1
fi

# Set Vars
# FILLER and ENDDELIM are used for drawing bars.
ENDDELIM="="
FILLER="="
SCALE=40
INPUTFILE=$1
NAME=(`awk -F"," '{print $1}' < "$INPUTFILE"`)
TOTAL=(`awk -F"," '{print $2}' < "$INPUTFILE"`)

# Get Max qty for scaling
MAXQTY=0
for VALUE in ${TOTAL[*]}
do
        if [ "$VALUE" -gt "$MAXQTY" ]; then
                MAXQTY=$VALUE
        fi
done

# Make graph header and markings
printf "\n Relative Value Chart\n"
printf "\nName      Value (Max is $MAXQTY)\n"
printf "____________________0"
QTRSCALE=`echo "$SCALE / 4" | bc -l | awk '{printf("%.0f",$0)}'`
HALFSCALE=`echo "$SCALE / 2" | bc -l | awk '{printf("%.0f",$0)}'`
THRSCALE=`echo "$SCALE * 0.75" | bc -l | awk '{printf("%.0f",$0)}'`
LCNT=1
while [ "$LCNT" -le "$SCALE" ];
do
        case $LCNT in
                $QTRSCALE)      printf ".";;
                $HALFSCALE)     printf "|";;
                $THRSCALE)      printf ".";;
                $SCALE)         printf "|100%% ($MAXQTY)\n";;
                *)              printf "_";;
        esac
        LCNT=$(( $LCNT + 1 ))
done

# Draw graph bars
i=0
for ITEM in ${NAME[*]}
do
        # Print Category name in format along with info and bars
        LENGTH=`echo "scale=2;(( ${TOTAL[$i]} / $MAXQTY ) * $SCALE )" |\
                bc |\
                awk '{printf("%.0f",$0)}'`
        printf "%-12.12s %-6.6s |" "$ITEM" "${TOTAL[$i]}"
        BLOCKS=""
        while [ "$LENGTH" -gt "0" ]; do
                if [ "$LENGTH" -eq "1" ]; then
                        BLOCKS="$BLOCKS$ENDDELIM"
                else
                        BLOCKS="$BLOCKS$FILLER"
                fi
                LENGTH=$(( $LENGTH - 1 ))
        done
        printf "$BLOCKS\n"
        i=$(( $i + 1 ))
done
printf "\n\n"
