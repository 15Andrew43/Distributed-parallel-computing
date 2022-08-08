#include "KernelMul.cuh"
#include <cstdlib>
#include <fstream>

void ExportData(const int p, const int block_size, const float time) {
    std::ofstream file;
    file.open("./02-mul.csv", std::ios::app);
    file << p << "," << block_size << "," << time << std::endl;
    file.close();
}

int main(int argc, char* argv[]) {

    int p = atoi(argv[1]);

    int N = 1 << p;
    int size = N * sizeof(float);
    float* h_x = (float*)malloc(size);
    float* h_y = (float*)malloc(size);
    float* h_result = (float*)malloc(size);

    float* d_x;
    float* d_y;
    float* d_result;

    cudaMalloc(&d_x, size);
    cudaMalloc(&d_y, size);
    cudaMalloc(&d_result, size);

    for (int i = 0; i < N; ++i) {
        h_x[i] = 1.0f;
        h_y[i] = 2.0f;
    }

    cudaMemcpy(d_x, h_x, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_y, h_y, size, cudaMemcpyHostToDevice);

    int blockSize = atoi(argv[2]);
    int numBlocks = (N + blockSize - 1) / blockSize;

    cudaEvent_t start;
    cudaEvent_t stop;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    KernelMul<<<numBlocks, blockSize>>>(N, d_x, d_y, d_result);

    cudaMemcpy(h_result, d_result, size, cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    ExportData(p, blockSize, milliseconds);

    cudaFree(d_x);
    cudaFree(d_y);
    cudaFree(d_result);
    free(h_x);
    free(h_y);
    free(h_result);
    return 0;
}
