#include <MatrixVectorMul.cuh>
#include <cstdlib>
#include <fstream>

void ExportData(const int p, const int block_size, const float time) {
    std::ofstream file;
    file.open("./04-matrix-vector-mul.csv", std::ios::app);
    file << p << "," << block_size << "," << time << std::endl;
    file.close();
}

int main(int argc, char* argv[]) {

    int p = atoi(argv[1]);
    int q = atoi(argv[2]);

    int width = 1 << p;
    int height = 1 << q;
    int N = width * height;
    int matrix_size = N * sizeof(float);
    int vector_size = height * sizeof(float);
    float* h_matrix = (float*)malloc(matrix_size);
    float* h_vector = (float*)malloc(vector_size);
    float* h_result = (float*)malloc(vector_size);

    float* d_matrix;
    float* d_vector;
    float* d_result;

    cudaMalloc(&d_matrix, matrix_size);
    cudaMalloc(&d_vector, vector_size);
    cudaMalloc(&d_result, vector_size);

    for (int i = 0; i < N; ++i) {
        h_matrix[i] = 1.0f;
    }
    for (int i = 0; i < height; ++i) {
        h_vector[i] = 2.0f;
    }

    cudaMemcpy(d_matrix, h_matrix, matrix_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_vector, h_vector, vector_size, cudaMemcpyHostToDevice);

    int blockSize = atoi(argv[3]);
    int numBlocks = (height + blockSize - 1) / blockSize;

    cudaEvent_t start;
    cudaEvent_t stop;

    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    cudaEventRecord(start);
    MatrixVectorMul<<<numBlocks, blockSize>>>(height, width, d_matrix, d_vector, d_result);

    cudaMemcpy(h_result, d_result, vector_size, cudaMemcpyDeviceToHost);
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
        
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    ExportData(p + q, blockSize, milliseconds);

	cudaFree(d_matrix);
	cudaFree(d_vector);
    cudaFree(d_result);
	free(h_matrix);
	free(h_vector);
    free(h_result);
    return 0;
}
