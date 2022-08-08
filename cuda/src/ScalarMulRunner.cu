#include <ScalarMulRunner.cuh>
#include <ScalarMul.cuh>
#include <CommonKernels.cuh>
#include <KernelMul.cuh>

float ScalarMulTwoReductions(int numElements, float* vector1, float* vector2, int blockSize) {
  int numBlocks = (numElements + blockSize - 1) / blockSize;

  float* d_mul_result;
  cudaMalloc(&d_mul_result, numElements * sizeof(float));

  KernelMul<<<numBlocks, blockSize>>>(numElements, vector1, vector2, d_mul_result);

  float* d_reduced_result;
  cudaMalloc(&d_reduced_result, numBlocks * sizeof(float));

  Reduce<<<numBlocks, blockSize, sizeof(float) * blockSize>>>(d_mul_result, d_reduced_result);

  float* d_result;
  cudaMalloc(&d_result, sizeof(float));

  Reduce<<<1, blockSize, sizeof(float) * blockSize>>>(d_reduced_result, d_result);
  
  float h_result = 0;
  cudaMemcpy(&h_result, d_result, sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(d_result);
  cudaFree(d_reduced_result);
  cudaFree(d_mul_result);
  return h_result;
}

float ScalarMulSumPlusReduction(int numElements, float* vector1, float* vector2, int blockSize) {
  int numBlocks = (numElements + blockSize - 1) / blockSize;

  float* d_mul_result;
  cudaMalloc(&d_mul_result, blockSize * sizeof(float));

  ScalarMulBlock<<<numBlocks, blockSize, sizeof(float) * blockSize>>>(numElements, vector1, vector2, d_mul_result);

  float* d_result;
  cudaMalloc(&d_result, sizeof(float));

  Reduce<<<1, blockSize, sizeof(float) * blockSize>>>(d_mul_result, d_result);
  
  float h_result = 0;
  cudaMemcpy(&h_result, d_result, sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(d_result);
  cudaFree(d_mul_result);
  return h_result;
}
