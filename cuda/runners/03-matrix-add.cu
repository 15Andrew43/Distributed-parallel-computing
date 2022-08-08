#include <KernelMatrixAdd.cuh>
#include <cstdlib>
#include <fstream>

void ExportData(const int p, const int block_size, const float time) {
    std::ofstream file;
    file.open("./03-matrix-add.csv", std::ios::app);
    file << p << "," << block_size << "," << time << std::endl;
    file.close();
}

int main(int argc, char* argv[]) {

    int p = atoi(argv[1]);
    int q = atoi(argv[2]);

    int width = 1 << p;
    int height = 1 << q;
    int N = width * height;
    int width_size = width * sizeof(float);
    float* h_A = (float*)malloc(width_size * height);
    float* h_B = (float*)malloc(width_size * height);
    float* h_result = (float*)malloc(width_size * height);

    float* d_A;
    float* d_B;
    float* d_result;

    size_t pitch;
    cudaMallocPitch(&d_A, &pitch, width_size, height);
    cudaMallocPitch(&d_B, &pitch, width_size, height);
    cudaMallocPitch(&d_result, &pitch, width_size, height);

    for (int i = 0; i < N; ++i) {
    	h_A[i] = 1.0f;
    	h_B[i] = 2.0f;
    }

    cudaMemcpy2D(d_A, pitch, h_A, width_size, width_size, height, cudaMemcpyHostToDevice);
    cudaMemcpy2D(d_B, pitch, h_B, width_size, width_size, height, cudaMemcpyHostToDevice);

    int blockSize1D = atoi(argv[3]);
    dim3 blockSize(blockSize1D, blockSize1D);
    dim3 numBlocks((width + blockSize1D - 1) / blockSize1D, (height + blockSize1D - 1) / blockSize1D);

    cudaEvent_t start;
    cudaEvent_t stop;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    KernelMatrixAdd<<<numBlocks, blockSize>>>(height, width, pitch, d_A, d_B, d_result);

    cudaMemcpy2D(h_result, width_size, d_result, pitch, width_size, height, cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    ExportData(p + q, blockSize1D, milliseconds);

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_result);
    free(h_A);
    free(h_B);
    free(h_result);
    return 0;
}
