#include <KernelMatrixAdd.cuh>

__global__ void KernelMatrixAdd(int height, int width, int pitch, float* A, float* B, float* result) {
  int x_index = blockIdx.x * blockDim.x + threadIdx.x;
  int x_stride = blockDim.x * gridDim.x;

  int y_index = blockIdx.y * blockDim.y + threadIdx.y;
  int y_stride = blockDim.y * gridDim.y;
 
  for (int i = x_index; i < width; i += x_stride) {
    for (int j = y_index; j < height; j += y_stride) {
      result[i * pitch + j] = A[i * pitch + j] + B[i * pitch + j];
    }
  }
}

