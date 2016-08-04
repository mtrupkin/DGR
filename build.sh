ARTIFACT=DGR
TARGET=./target/$ARTIFACT.DSK

APPLE_HOME=/c/util-apple

MERLIN_HOME=$APPLE_HOME/Merlin32_v1.0
CADIUS_HOME=$APPLE_HOME/Cadius_v1.1
APPLEWIN_HOME=$APPLE_HOME/AppleWin1.25.0.4

CADIUS_TARGET=./target/$ARTIFACT.2MG

MERLIN_CMD="$MERLIN_HOME/Windows/Merlin32.exe -V $MERLIN_HOME/Library"
CADIUS_CMD="$CADIUS_HOME/Cadius.exe ADDFILE $CADIUS_TARGET"
APPLEWIN_CMD="$APPLEWIN_HOME/Applewin.exe -no-printscreen-dlg"

rm -rf ./target
mkdir ./target

cp -a ./src/build/. ./target/

for f in ./src/main/6502/*.s; do
  $MERLIN_CMD $f
  OBJ=$(basename $f .s)
  OBJ_TARGET=./target/$OBJ
  mv ./src/main/6502/$OBJ $OBJ_TARGET
  $CADIUS_CMD $ARTIFACT $OBJ_TARGET
done

mv $CADIUS_TARGET $TARGET

start $APPLEWIN_CMD -d1 $(realpath $TARGET)
