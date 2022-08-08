#include <iostream>
#include <time.h>
#include "mpi.h"

#include <thread>
#include <chrono>




#define RETURN return 0
#define FIRST_THREAD 0

int* get_interval(int proc, int size, int* interval);
inline void print_simple_range(int, int, int thread);
// void wait(int);

int main(int argc, char **argv)
{
	// инициализируем необходимые переменные
	int thread, thread_size, processor_name_length;
	int* thread_range;
	int* interval;
	double cpu_time_start, cpu_time_fini;
	char* processor_name = new char[MPI_MAX_PROCESSOR_NAME * sizeof(char)];

	MPI_Status status;
	interval = new int[2];
	
	// Инициализируем работу MPI
	MPI_Init(&argc, &argv);
	
	// Получаем имя физического процессора
	MPI_Get_processor_name(processor_name, &processor_name_length);
	
	// Получаем номер конкретного процесса на котором запущена программа
	MPI_Comm_rank(MPI_COMM_WORLD, &thread);
	
	// Получаем количество запущенных процессов
	MPI_Comm_size(MPI_COMM_WORLD, &thread_size);
	
	// Если это первый процесс, то выполняем следующий участок кода
	if(thread == FIRST_THREAD) {
		// Выводим информацию о запуске
		std::cout << "----- Programm information -----\n"
			 << ">>> Processor: " << processor_name << "\n"
			 << ">>> Num threads: " << thread_size << "\n"
			 << ">>> Input the interval: ";

		// Просим пользователья ввести интервал на котором будут вычисления
		std::cin >> interval[0] >> interval[1];

		// Каждому процессу отправляем полученный интервал с тегом сообщения 0. 
		for (int to_thread = 1; to_thread < thread_size; to_thread++) {
   		   MPI_Send(interval, 2, MPI_INT, to_thread, 0, MPI_COMM_WORLD);
  		}

		// Начинаем считать время выполнения
		cpu_time_start = MPI_Wtime();

		// MPI_Send(&cpu_time_start, 1, MPI_DOUBLE, thread_size - 1, 1, MPI_COMM_WORLD);
	} else { // Если процесс не первый, тогда ожидаем получения данных
 	   MPI_Recv(interval, 2, MPI_INT, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
 	   cpu_time_start = MPI_Wtime();
 	   // if (thread == thread_size - 1) {
 	   // 		MPI_Recv(&cpu_time_start, 1, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD, &status);
 	   // 		std::cout << "starty__ time: " << cpu_time_start << "\n";
 	   // }
	}

	// Все процессы запрашивают свой интервал
	thread_range = get_interval(thread, thread_size, interval);
	std::cout << "interval for thread " << thread << ": " << thread_range[0]<< " - " << thread_range[1] << "\n";

	// После чего отправляют полученный интервал в функцию которая производит вычисления
	print_simple_range(thread_range[0], thread_range[1], thread);

	// Последний процесс фиксирует время завершения, ожидает 1 секунду и выводит результат
	if(thread == thread_size - 1)
	{

		cpu_time_fini = MPI_Wtime();
		std::this_thread::sleep_for(std::chrono::milliseconds(1000));
		std::cout << "global time is synchronized - " << (bool)MPI_WTIME_IS_GLOBAL << "\n"
			 << "start: " << cpu_time_start*1000 << ", finish: " << cpu_time_fini*1000 << "\n"
			 << "CPU Time: " << (cpu_time_fini - cpu_time_start) * 1000 << "\n";
	}

	MPI_Finalize();
	RETURN;
}

int* get_interval(int proc, int size, int* interval)
{
	// Функция для рассчета интервала каждого процесса
	int* range = new int[2];
	int interval_size = (interval[1] - interval[0]) / size;

	range[0] = interval[0] + interval_size * proc;
	range[1] = interval[0] + interval_size * (proc + 1);
	range[1] = range[1] == interval[1] - 1 ? interval[1] : range[1];
	return range;
}

inline void print_simple_range(int ibeg, int iend, int thread)
{
	// Прострейшая реализация определения простого числа
	bool res;
	for(int i = ibeg; i <= iend; i++)
	{
		res = true;
		while(res)
		{
			res = false;
			for(int j = 2; j < i; j++) if(i % j == 0) res = true;
			if(res) break;
		}
		res = not res;
		if(res) {
			std::cout << "thread: " << thread << ", Simple value ---> " << i << "\n";
		}

	}
}
// void wait(int seconds)
//  {
//  	// Функция ожидающая в течение seconds секунд
// 	clock_t endwait;
// 	endwait = clock () + seconds * CLOCKS_PER_SEC ;
// 	while (clock() < endwait) {};
// }