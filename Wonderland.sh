#! /bin/bash
type_=PDB
FORMAT_INPUT=$( echo ${type_} )
function remove_fake_rings {
  echo "Removing fake-rings [ This may take a long time...]"
  while read line ; do
    for i in $(seq 1 8) ; do
       atom[$i]=$(echo $line | awk '{print $'$i'}')
    done
    for i in 1 2 3 4 ; do n_atom[$i]=$i ; done
    for j in $(seq 1 8) ; do
     for h in 1 2 3 4 ; do if [ ${n_atom[${h}]} -eq 9 ] ; then n_atom[${h}]=1 ; fi ; done
     sed -i.bak "/ ${atom[${n_atom[1]}]} ${atom[${n_atom[2]}]} ${atom[${n_atom[3]}]} ${atom[${n_atom[4]}]} /d" 16-ring.txt
     sed -i.bak "/ ${atom[${n_atom[4]}]} ${atom[${n_atom[3]}]} ${atom[${n_atom[2]}]} ${atom[${n_atom[1]}]} /d" 16-ring.txt
     for h in 1 2 3 4 ; do let "n_atom[${h}]++" ; done
    done
  done < 8-ring.txt
}
# main:
cd src
  make
  echo "======= Code compiled ======="
  mv White_Rabbit Alicia Cheshire_Cat Queen_of_Hearts The_Hatter ../.
  rm *.o *.mod
cd ..
if [ $FORMAT_INPUT == "CIF" ] ; then
   echo "Cheshire_Cat runing"
   cat input.cif | sed '/occupancy/d' | awk '{print $1,$2,$3,$4}' > c
   mv c input.cif
   ./Cheshire_Cat > input.pdb
   sed -i '/ C /d' input.pdb
   sed -i '/ H /d' input.pdb
   FORMAT_INPUT=$( echo 'PDB' )
fi # lee el input.cif
if [ $FORMAT_INPUT == "ARC" ] ; then 
   sed -i '/BIOSYM/d' input.arc
   sed -i '/PBC=ON/d' input.arc
fi
echo '.false.' > _false
echo $FORMAT_INPUT >> _false
echo '.true.'  > _true
echo $FORMAT_INPUT >> _true
echo "White_Rabbit runing: Down the Rabbit Hole"
./White_Rabbit < _false
for j in 8 12 16 20 ; do           # tipo de anillo
    echo "Alicia runing for $j-ring"
    ./Alicia 10 2 grafo $j 1 > _tmp1
    cat _tmp1 | sed '/simemtrizar/d' | sed '/vectores/d' | sed '/faltan/d' |sed '/borrar/d' > _tmp2
    mv _tmp2 $j-ring.txt
done
#remove_fake_rings
echo "White_Rabbit runing: Up the Rabbit Hole"
./White_Rabbit < _true
for j in 4 6 8 10 ; do
    echo "Queen_of_Hearts runing for $j-histogram"
    cat $j-distance.txt | awk '{print $5}' > input
    ./Queen_of_Hearts > $j-histogram_area.txt
    cat $j-distance.txt | awk '{print $3}' > input
    ./Queen_of_Hearts > $j-histogram_apperture.txt
done
#echo "[The Hatter] Discrete Fourier Transform of area(t) > hat(area)(w)"
#for i in 8 ; do     # type win
#    for j in $(seq 1 10 ) ; do # label win
#        echo "[type: $i, window: $j]"
#        awk '{if ($2=='${j}') print $1,$4}' ${i}-distance.txt > area_ring${j}_${i}.txt
#        cp area_ring${j}_${i}.txt input
#        ./The_Hatter
#        cp out hat_area_ring${j}_${i}.txt
#        rm input out
#    done
#done
rm _* White_Rabbit Alicia Cheshire_Cat Queen_of_Hearts The_Hatter TIEMPO_ATOMS input
mv loopines_grafo_exp.dat grafo* *.txt results
exit 0
