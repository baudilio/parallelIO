#!/bin/bash
#SBATCH --job-name=Parallel_IO
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=bltejerina@gmail.com
#SBATCH --ntasks=2
#SBATCH --mem=1gb
#SBATCH --time=00:05:00
#SBATCH --output=BTA_%j.log

#
# Set up working environment
#module use /home/Baudilio.Tejerina/.privatemodules
module load openmpi
module list

# Source code
case $1 in
    2) SOURCE=Paralle_IO_ARRAY_of_CHARACTER.f90;;
    1) SOURCE=Paralle_IO_CHARACTER.f90;;
    *) echo "Select version of the code to test: 1 or 2";exit 1;;
esac

printf "Testing ASCII parallel IO. Code version: %s\n" $SOURCE

# Compile
EXEC=parallel_IO.x
mpif90 -Wall -O2 `pkg-config --cflags --libs ompi-fort` $SOURCE -o $EXEC


# printf "And now run the job:\n"
TI=$SECONDS
# ./par_k3.x
#mpirun -np 2 $EXEC
# mpirun -np ${SLURM_NPROCS} $EXEC; # OK but, old env. var. name
mpirun -np ${SLURM_NTASKS} $EXEC
TF=$SECONDS

printf "TEST code: %s - %d tasks took %d seconds\n" ${SOURCE} ${SLURM_NTASKS} $(($TF - $TI))

#
printf "All Done! -- Have a Great Day!\n"
date

## The End
