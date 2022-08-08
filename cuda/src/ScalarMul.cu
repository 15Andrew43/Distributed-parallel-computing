#include <ScalarMul.cuh>

/*
 * Calculates scalar multiplication for block
 */
__global__
void ScalarMulBlock(int numElements, float* vector1, float* vector2, float *result) {
    extern __shared__ float shared_data[];

    int tid = threadIdx.x;
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    int stride = gridDim.x * blockDim.x;

    if (tid == 0) {
        result[blockIdx.x] = 0;
    }

    shared_data[tid] = vector1[idx] * vector2[idx];
    __syncthreads();

    for (int i = idx; i < numElements; i += stride) {
        atomicAdd(&(result[tid]), shared_data[tid]);
    }
}
