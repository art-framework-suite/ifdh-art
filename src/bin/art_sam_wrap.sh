#!/bin/sh

#
# This job assumes it's being passed:
#  $SAM_PROJECT_NAME 
#  $EXPERIMENT
#  $GRID_USER

set -x

hostname
uname -a 
ls /lib*/libc-*.so

# defaults

dest=""
conf=/dev/null
exe=$EXPERIMENT
quals=nu:e4:debug
vers=v1_2_10
renam=""
limit=""
getconfig=false
use_gdb=false
multifile=false
exports=""
sources=""
prescripts=""
postscripts=""
self_destruct_timeout=""
input_files=""

datadir=$TMPDIR/ifdh_$$

#set -x
#
# parse options we know, collect rest in $args
#
usage() {
cat <<EOF
Usage:
    $0 [Options] [cmd_options]

       find ifdh_art and dependencies in CVMFS or in /nusoft/app/externals,
       register a consumer process, and run an ART executable, 
       fetching input from a SAM Project specified by $SAM_PROJECT
       in the environment.

    Options are:

    -h|--help
        Print this message and exit

    -q|--quals  str
    -v|--vers   version
	Set qualifiers and version of ifdh_art to setup if
        it isn't setup by any --source parameters.

    -X|--exe    executable
    -c|--config file
        executable (defaults to experiment name) and config file to
        run as executable -c config [cmd_options]

    -D|--dest   url
        specify destination path or url for copying back output
        default is to not copy back files

    -R|--rename how
    --rename2    how
    --rename3    how
        call "ifdh rename" to rename output files
        ...possibly 2 or three times

    -g|--getconfig
        get the config file as an input file from SAM
        (i.e. for MonteCarlo simulation) 
        conflicts with --conf.

    --multifile
        Fetches multiple files per job and runs the executable 
        once per file.
        conflicts with --getconfig

    --confbase
        for --getconfig, prepend this file to the fetched
        config file before running the executable

    -G|--with-gdb
        Run the executable under the debugger, and print a
        stack trace if it dies

    -L|--limit
        Pass a number of files limit to establishProcess.

    --inputfile
        Copy this extra input file into the job area before
        running the executable

    --addoutput pattern
        call "ifdh addOutputFile" with files that match this 
        glob pattern (i.e. --addoutput *out.root)

    --export VAR=value
        export the following VAR=value before running the
        executable

    --self-destruct-timer seconds
        suicide if the executable runs more than seconds seconds;
        usually only use this if you have jobs that hang and you
        get no output back

    --source file:arg:arg:...
    --prescript file:arg:arg:...
    --postscript file:arg:arg:...
        source/execute the file before/after the main executable
        is run.
EOF
}

while [ $# -gt 0 ]
do
    echo "debug: \$1 '$1' \$2 '$2'"
    case "x$1" in
    x-h|x--help)    usage; exit 0;;
    x-q|x--quals)   quals="$2"; shift; shift; continue;;
    x-c|x--config)  conf="$2";  shift; shift; continue;;
    x-D|x--dest)    dest="$2";  shift; shift; continue;;
    x-R|x--rename)  renam="$2";   shift; shift; continue;;
    x--rename2)     renam2="$2";   shift; shift; continue;;
    x--rename3)     renam3="$2";   shift; shift; continue;;
    x-X|x--exe)     cmd="$2";   shift; shift; continue;;
    x-v|x--vers)    vers="$2";  shift; shift; continue;;
    x-g|x--getconfig)getconfig=true; shift; continue;;
    x--multifile)   multifile=true; shift; continue;;
    x-G|x--with-gdb)use_gdb=true; shift; continue;;
    x-L|x--limit)   limit="$2"; shift; shift; continue;;
    x--inputfile)   input_files="$input_files $2"; shift; shift; continue;;
    x--addoutput)   addoutput="$2"; shift; shift; continue;;
    x--confbase)    confbase="$2"; shift; shift; continue;;
    x--export)      exports="$exports \"$2\"" shift; shift; continue;;
    x--source)      sources="$sources \"$2\"" shift; shift; continue;;
    x--self-destruct-timer) self_destruct_timeout=$2; shift; shift; continue;;
    x--prescript)  prescripts="$prescripts \"$2\"":; shift; shift; continue;;
    x--postscript) postscripts="$postscripts \"$2\"":; shift; shift; continue;;
    *)              args="$args \"$1\""; shift; continue;;
    esac
    break
done

find_ups() {

    #
    # use our slf6 stuff for systems with 3.x kernels (i.e. MTW2)
    #
    case `uname -r` in
    3.*) export UPS_OVERRIDE="-H Linux64bit+2.6-2.12";;
    esac
    
    for path in /cvmfs/oasis.opensciencegrid.org/$EXPERIMENT/externals /cvmfs/${EXPERIMENT}cfs.fnal.gov/externals /nusoft/app/externals
    do
       if [ -r $path/setup ] 
       then 
	    source $path/setup
	    return 0
       fi
    done
    return 1
}
check_space() {
   set : `df -P . | tail -1`
   avail_blocks=$5
   if [ $avail_blocks -lt 1024 ] 
   then
       echo "Not enough space (only ${avail_blocks}k) on this node in `pwd`."
       df -H .
       return 1
   fi
   return 0
}

kill_proc_kids_after_n() {
    watchpid=$1
    after_secs=$2
    rate=10
    sofar=0

    start=`date +%s`
    echo "Starting self-destruct timer of $after_secs at $start"

    while kill -0 $watchpid 2> /dev/null && [ $sofar -lt $after_secs ]
    do
        sleep $rate
        now=`date +%s`
        sofar=$((now - start))
        printf "."
    done
    printf "\n"
    
    if kill -0 $watchpid
    then
       pslist=`ps -ef | grep " $watchpid " | grep -v grep`
       printf "Timed out after $sofar seconds...\n"
       for signal in 15 9
       do
           echo "$pslist" | 
              while read uid pid ppid rest
              do
                 if [ $ppid = $watchpid ]
                 then
                     echo "killing -$signal $uid $pid $ppid $rest"
                     kill -$signal $pid
                 fi
              done
           echo "killing -$signal $watchpid"
           kill -$signal $watchpid
       done
    fi
}

if [ x"$self_destruct_timeout" != x ]
then
   kill_proc_kids_after_n $$ $self_destruct_timeout &
fi

#
# if we don't have ups or enough space, try again for a bit
# before giving up
#

hostname
count=0
until find_ups && check_space 
do
   count=$((count + 1))
   if [ $count -gt 6 ]
   then
       echo "Timed out waiting for space and/or cvmfs ups area"
       exit 1
   fi
   sleep 600
done

# not sure we need this
if [ "x$IFDH_BASE_URI" = "x" ]
then
    export IFDH_BASE_URI=http://samweb.fnal.gov:8480/sam/$EXPERIMENT/api
fi

#
# treat colons as blanks when eval-ing sources below
# (need a better char? what about PATH changs?) 
# because blanks get split by jobsub no matter what you do...
#
for blat in $exports
do
    echo "doing: export $blat"
    eval export $blat
done

for blat in $sources 
do
   blat=`echo $blat | sed -e 's/:/ /g'`
   eval blat=$blat
   echo "doing: source $blat"
   eval "source $blat"
done

for blat in $prescripts 
do
   blat=`echo $blat | sed -e 's/:/ /g'`
   eval blat=$blat
   echo "doing: $blat"
   eval "$blat"
done

eval "confbase=$confbase"

#
# make sure we have ifdh_art
#
if [ x$IFDH_ART_DIR = x ]
then
    . `ups setup ifdh_art $vers -q $quals:`
fi

# should not need this, but seem to for older releases -- SL5 setup on SL6 bug
PATH=/bin:/usr/bin:`echo $IFDHC_DIR/Linux*/bin`:$PATH
LD_LIBRARY_PATH=`echo $IFDHC_DIR/Linux*/lib`:`echo $IFDH_ART_DIR/Linux*/lib`:$LD_LIBRARY_PATH
setup nova_compat_libs v1_0 -q e2:debug

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NOVA_COMPAT_LIBS_FQ_DIR

if [ -n "$JOBSUBJOBID" ]
then
   description="$JOBSUBJOBID"
elif [ -n "$CLUSTER" ]
then
   description="$CLUSTER.$PROCESS"
else
   description=""
fi

hostname=`hostname --fqdn`
projurl=`ifdh findProject $SAM_PROJECT_NAME ${SAM_STATION:-$EXPERIMENT}`
consumer_id=''
count=0
while [ "$consumer_id" = "" ]
do
    sleep 5
    consumer_id=`IFDH_DEBUG= ifdh establishProcess "$projurl" "$cmd" "$ART_VERSION" "$hostname" "$GRID_USER" "art" "$description" "$limit"`
    count=$((count + 1))
    if [ $count -gt 10 ]
    then
        echo "Unable to establish consumer id!"
        echo "Unable to establish consumer id!" >&2 
        exit 
    fi
done

echo project url: $projurl
echo consumer id: $consumer_id

#
# override flags for grid copies..
# this should be in ifdh_cp, but until it is...
#
export IFDH_GRIDFTP_EXTRA="-p 0 -dp"

#
# Joe says not to do this...
#
#cd $TMPDIR
check_space

echo "Active ups products:"
ups active

if [ -n "$input_files" ]
then
    ifdh cp -D $input_files .
fi

if $getconfig
then

    echo "Getconfig case:"

    uri=`IFDH_DEBUG= ifdh getNextFile $projurl $consumer_id | tail -1`
    res=0
    while [ -n "$uri" -a "$res" = 0 ]
    do
	fname=`IFDH_DEBUG= ifdh fetchInput "$uri" | tail -1 `
        if [ x$confbase != x ]
        then
             cat $confbase $fname > $fname.new
             mv $fname.new $fname
        fi
        
        echo "config is now:"
        echo "=============="
        cat $fname
        echo "=============="
        conf=$fname
        datestamp=`date +%F-%H-%M-%S`
	echo conf is $conf
	ifdh updateFileStatus $projurl  $consumer_id $fname transferred

        #out=`basename $fname | sed -e "s/.fcl$/$datestamp.root/"`
        #command="\"${cmd}\" -c \"$conf\" $args -o $out --process-name test"
        command="\"${cmd}\" -c \"$conf\" $args --process-name test"

	echo "Running: $command"

	if eval "$command"
        then 
	   ifdh updateFileStatus $projurl  $consumer_id $fname consumed
        else
	   res=$?
	   ifdh updateFileStatus $projurl  $consumer_id $fname skipped
        fi
        uri=`ifdh getNextFile $projurl $consumer_id`
    done
elif $multifile
then
    echo "Multi-file case:"
    uri=`IFDH_DEBUG= ifdh getNextFile $projurl $consumer_id | tail -1`
    res=0
    while [ -n "$uri" ]
      do
      fname=`IFDH_DEBUG= ifdh fetchInput "$uri" | tail -1 `
      echo "got file: $fname"
      ifdh updateFileStatus $projurl  $consumer_id $fname transferred
      
      command="\"${cmd}\" -c \"$conf\" $args $fname"
      
      echo "Running: $command"
      if eval "$command"
	  then 
	  ifdh updateFileStatus $projurl  $consumer_id $fname consumed
      else
	  res=$?
	  ifdh updateFileStatus $projurl  $consumer_id $fname skipped
      fi
      # rename after each pass; note that if we're doing uniq, this
      # may make Really Long Filenames on the early outputs
      if [ "x$renam" != "x" -a "$res" = "0" ]
      then
          ifdh renameOutput $renam
      fi 
      uri=`ifdh getNextFile $projurl $consumer_id`
    done
    # stop later script from renaming yet again..
    renam=""
else
    echo "Not Getconfig case:"
    
    update_via_fcl=false

    : $update_via_fcl

    if $update_via_fcl
	then

	cp $conf ${TMPDIR:=/var/tmp}/conf.$$
	conf=$TMPDIR/conf.$$
	cat >> $conf <<EOF
    services.user.IFDH: {}
    services.user.IFDH.debug: "1"
    services.user.CatalogInterface.service_provider: "IFCatalogInterface"
    services.user.CatalogInterface.webURI: "$projurl"
    services.user.FileTransfer.service_provider: "IFFileTransfer"
    source.fileNames: [ "$consumer_id" ]
EOF

    else
	args="$args \"--sam-web-uri=$projurl\" \"--sam-process-id=$consumer_id\""
    fi

    #
    #debugging 
    #
    # ups active
    # printenv

    command="\"${cmd}\" -c \"$conf\" $args"

    if $use_gdb
    then
         printf 'run\nwhere\nquit\n'  > gdbcmds
	 command="gdb -x gdbcmds --args $command"
    fi

    echo "Running: $command"
    eval "$command"
    res=$?

    if $update_via_fcl
    then
        rm ${conf}
    fi

fi

for blat in $postscripts 
do
   blat=`echo $blat | sed -e 's/:/ /g'`
   eval blat=$blat
   echo "doing: $blat"
   eval "$blat"
done

if [ "x$addoutput" != "x" -a "$res" = "0" ]
then
    for f in $addoutput
    do
        ifdh addOutputFile $f 
    done
fi

if [ "x$renam" != "x" -a "$res" = "0" ]
then
    ifdh renameOutput $renam
fi

if [ "x$renam2" != "x" -a "$res" = "0" ]
then
    ifdh renameOutput $renam2
fi

if [ "x$renam3" != "x" -a "$res" = "0" ]
then
    ifdh renameOutput $renam3
fi

case `hostname` in
*.smu.edu) export IFDH_STAGE_VIA='srm://smuosgse.hpc.smu.edu:8443/srm/v2/server?SFN=/data/srm'
           echo "turning on staging and for SMU..."
           ;;
esac

if [ "x$dest" != "x" -a "$res" = "0" ]
then
    # workaround for srmls hangs
    export SRM_JAVA_OPTIONS=-Xmx2048m

    voms-proxy-info -all

    ifdh copyBackOutput "$dest"
fi


if [ "$res" = 0 ]
then
    ifdh setStatus "$projurl" "$consumer_id"  completed
else
    ifdh setStatus "$projurl" "$consumer_id"  bad
fi

ifdh endProcess "$projurl" "$consumer_id"

ifdh cleanup -x

# cleanup temporary script dir
rm -rf $dp

# clean up usual detritus
rm -f *.fcl *.raw *.root t_* stage_*

exit $res
