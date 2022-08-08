#include <iostream>
#include <mpi.h>
#include <string>



double f(double x) {
	return 4 / (1 + x*x);
}



int main(int argc, char *argv[]) {

	int rank, size;
	MPI_Status status;
	// MPI_Request r_send, r_recv; //future

	MPI_Init(&argc, &argv);

	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	int start_ind, n_per_thread, remainder;
	int n_per_thread1;
	double dx;


	if (rank == 0) {
		start_ind = 0;
		int n = std::stoi(argv[1]);
		// std::cout <<"\n\n\n--------==============" << argv[1] << "asldjvndjvna";
		// return 1;;

		n_per_thread = n / size;
		n_per_thread1 = n_per_thread + 1;
		remainder = n % size;
		int cur_ind = n - n_per_thread;
		int cur_reminder = 0;
		cur_ind -= ( (remainder == 0 || cur_reminder == remainder) ? 0 : 1 );
		++cur_reminder;
		
		int* start_inds = new int[size];
		dx = (double) 1 / n;


		for (int i = size - 1; i >= 0; --i) {
			start_inds[i] = cur_ind;
			cur_ind -= n_per_thread;
			cur_ind -= ( (remainder == 0 || cur_reminder >= remainder) ? 0 : 1 );
			++cur_reminder;
		}


		cur_reminder = 0;
		for (int i = size - 1; i > 0; --i) {

			MPI_Send(
				start_inds + i,
				1, 
				MPI_INT,
				i,
				42,
				MPI_COMM_WORLD
			);
			

			MPI_Send(
				&( (remainder == 0 || cur_reminder >= remainder) ? n_per_thread : n_per_thread1 ),
				1, 
				MPI_INT,
				i,
				42,
				MPI_COMM_WORLD
			);
			++cur_reminder;

			MPI_Send(
				&dx,
				1, 
				MPI_DOUBLE,
				i,
				42,
				MPI_COMM_WORLD
			);

		}


		delete[] start_inds;

	} else {
		MPI_Recv(
			&start_ind,
			1, 
			MPI_INT,
			0,
			42,
			MPI_COMM_WORLD,
			&status
		);
		MPI_Recv(
			&n_per_thread,
			1, 
			MPI_INT,
			0,
			42,
			MPI_COMM_WORLD,
			&status
		);
		MPI_Recv(
			&dx,
			1, 
			MPI_DOUBLE,
			0,
			42,
			MPI_COMM_WORLD,
			&status
		);
	}

	double res_per_thread = 0;
	for (int i = start_ind; i < start_ind + n_per_thread; ++i) {
		res_per_thread += (f(i * dx) + f((i + 1) * dx)) / 2 * dx;
	}


	if (rank == 0) {
		double* array_res = new double[size];


		array_res[0] = res_per_thread;
		for (int i = 1; i < size; ++i) {
			MPI_Recv(
				array_res + i,
				1, 
				MPI_DOUBLE,
				i,
				43,
				MPI_COMM_WORLD,
				&status
			);
		}

		double sum_res = 0;
		for (int i = 0; i < size; ++i) {
			sum_res += array_res[i];
		}
		std::cout << sum_res << '\n';


		delete[] array_res;
	} else {
		MPI_Send(
			&res_per_thread,
			1, 
			MPI_DOUBLE,
			0,
			43,
			MPI_COMM_WORLD
		);
	}


	MPI_Finalize();


	return 0;
}