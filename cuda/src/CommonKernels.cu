#include <CommonKernels.cuh>

__device__ void WarpReduce(volatile float* shared_data, int tid) {
  shared_data[tid] += shared_data[tid + 32];
  shared_data[tid] += shared_data[tid + 16];
  shared_data[tid] += shared_data[tid + 8];
  shared_data[tid] += shared_data[tid + 4];
  shared_data[tid] += shared_data[tid + 2];
  shared_data[tid] += shared_data[tid + 1];
}

__global__ void Reduce(float* vector, float* result) {
  extern __shared__ float shared_data[];

  int tid = threadIdx.x;
  int idx = blockIdx.x * blockDim.x * 2 + threadIdx.x;

  shared_data[tid] = vector[idx] + vector[idx + blockDim.x];
  __syncthreads();
  
  for (int s = blockDim.x / 2; s > 32; s >>= 1) {
      if (tid < s) {
          shared_data[tid] += shared_data[tid + s];
      }
      __syncthreads();
  }

  if (tid < 32) {
      WarpReduce(shared_data, tid);
  }
  
  if (tid == 0) {
      result[blockIdx.x] = shared_data[0];
  }
}