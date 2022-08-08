#include <MatrixVectorMul.cuh>

__global__
void MatrixVectorMul(int height, int width, float* matrix, float* vector, float* result) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = blockDim.x * gridDim.x;

    for (int i = idx; i < height; i += stride) {
        float current_element = 0;
        for (int j = 0; j < width; ++j) {
            current_element += matrix[i * width + j] * vector[j];
        }
        result[i] = current_element;
    }
}

