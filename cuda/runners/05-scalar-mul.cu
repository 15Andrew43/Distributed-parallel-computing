#include <ScalarMulRunner.cuh>
#include <cstdlib>
#include <fstream>

void ExportData(const int p, const int block_size, const float time, bool two_reductions) {
    std::ofstream file;
    file.open(two_reductions ? "./05-scalar-mul-two-reductions.csv" : "./05-scalar-mul-sum-plus-reduction.csv", std::ios::app);
    file << p << "," << block_size << "," << time << std::endl;
    file.close();
}

float GetMeasuredTime(int N, float* h_x, float* h_y, float* d_x, float* d_y, int blockSize, bool two_reductions) {
    int size = N * sizeof(float);

    for (int i = 0; i < N; ++i) {
    	h_x[i] = 1.0f;
    	h_y[i] = 2.0f;
    }

    cudaMemcpy(d_x, h_x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, h_y, size, cudaMemcpyHostToDevice);

    cudaEvent_t start;
    cudaEvent_t stop;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);

    float result = (two_reductions ? ScalarMulTwoReductions(N, d_x, d_y, blockSize) : ScalarMulSumPlusReduction(N, d_x, d_y, blockSize));

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    return milliseconds;
}

int main(int argc, char* argv[]) {

    int p = atoi(argv[1]);

    int N = 1 << p;
    int size = N * sizeof(float);
    float* h_x = (float*)malloc(size);
    float* h_y = (float*)malloc(size);

    float* d_x;
    float* d_y;

    cudaMalloc(&d_x, size);
    cudaMalloc(&d_y, size);

    int blockSize = atoi(argv[2]);

    float milliseconds = GetMeasuredTime(N, h_x, h_y, d_x, d_y, blockSize, true);
    ExportData(p, blockSize, milliseconds, true);

    milliseconds = GetMeasuredTime(N, h_x, h_y, d_x, d_y, blockSize, false);
    ExportData(p, blockSize, milliseconds, false);

    cudaFree(d_x);
    cudaFree(d_y);
    free(h_x);
    free(h_y);
    return 0;
}
