#!/bin/sh

usage_exit() {
  echo "Usage: $0 [-b branch] [-r repository] [-f Debug|Release] [-t Develop|Staging|Production]" 1>&2
  exit 1
}

if [ "$1" = "" ]
then
  usage_exit
fi

while getopts b:f:r:t:h OPT
do
  case $OPT in
    b) BRANCH=$OPTARG
      ;;
    f) FLAVOR=$OPTARG
      ;;
    r) REPO=$OPTARG
      ;;
    t) BUILD_TYPE=$OPTARG
      ;;
    h) usage_exit
      ;;
    *|\?) usage_exit
      ;;
  esac
done

shift $(( $OPTIND - 1 ))

WORK_DIR=`uuidgen`

git clone $REPO $WORK_DIR

cd $WORK_DIR

git checkout -b $BRANCH origin/$BRANCH

gradle clean assemble$FLAVOR crashlyticsUploadDistribution$BUILD_TYPE$FLAVOR

exit 0
