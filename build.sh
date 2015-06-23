ARTIFACT='DGR'

MERLIN_HOME='../Merlin32_v1.0'
MERLIN_CMD=$MERLIN_HOME'/Windows/Merlin32.exe -V '$MERLIN_HOME'/Library'

CADIUS_HOME='../Cadius_v1.1'
CADIUS_TARGET='./target/'$ARTIFACT'.2MG'
CADIUS_CMD=$CADIUS_HOME'/Cadius.exe ADDFILE ./target/'$ARTIFACT'.2MG'
#../Cadius_v1.1/Cadius.exe ADDFILE ./target/DGR.2MG DGR ./target/DGR

rm -rf ./target
mkdir ./target

cp -a ./src/build/. ./target/

for f in ./src/main/6502/*.s; do
  $MERLIN_CMD $f
  OBJ=$(basename $f .s)
  OBJ_TARGET='./target/'$OBJ
  mv ./src/main/6502/$OBJ $OBJ_TARGET
  $CADIUS_CMD $ARTIFACT $OBJ_TARGET
done

mv ./target/$ARTIFACT.2MG ./target/$ARTIFACT.DSK

start ./target/$ARTIFACT.DSK
