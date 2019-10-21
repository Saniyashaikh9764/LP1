#include<iostream>
#include<chrono>
#include<limits>
using namespace std;
using namespace std::chrono;

__global__ void find_maximum(float *arr, float *max, int *mutex, unsigned int n) {
    unsigned int index = threadIdx.x + blockIdx.x * blockDim.x;
    unsigned int stride = gridDim.x * blockDim.x;
    unsigned int offset = 0;

    __shared__ float cache[256];
    float temp = 100000000000.99;
    while (index + offset < n) {
        temp = fmaxf(temp, arr[index + offset]);
        offset += stride;
    }
    cache[threadIdx.x] = temp;
    __syncthreads();
    //Reduction
    unsigned int i = blockDim.x / 2;
    while(i != 0) {
        if (threadIdx.x < i) {
            cache[threadIdx.x] = fmaxf(cache[threadIdx.x], cache[threadIdx.x]);
        }
        __syncthreads();
        i /= 2;
    }
    if(threadIdx.x == 0) {
        while(atomicCAS(mutex, 0, 1)!= 0); //lock
        *max = fmaxf(*max, cache[0]);
        atomicExch(mutex, 0);
    }
}

void find_maximum_CPU(float *a, int n) {
    float max = FLT_MAX;
    for(int i = 0; i < n; i++) {
        if(a[i] < max) {
            max = a[i];
        }
    }
    cout<<"\nThe max number (CPU) is: "<<max<<endl;
}

int main() {
    float *a, *dev_a, *max, *dev_max;
    int *dev_mutex;
    int n = 1024 * 1024 * 20;
    a = (float *)malloc(n * sizeof(float));
    max = (float *)malloc(sizeof(float));
    for(int i = 0; i < n; i++) {
        a[i] = float(rand()) + 69.0f;
    }
    //Max with CPU
    auto startCPU = high_resolution_clock::now();
    find_maximum_CPU(a, n);
    auto stopCPU = high_resolution_clock::now();
    cout<<"\nTime elapsed on CPU: "<<duration_cast<microseconds>(stopCPU - startCPU).count()<<endl;
    
    cudaMalloc(&dev_a, n * sizeof(float));
    cudaMalloc(&dev_max, sizeof(float));
    cudaMalloc(&dev_mutex, sizeof(int));
    cudaMemset(dev_max, 0, sizeof(float));
    cudaMemset(dev_mutex, 0, sizeof(int));
    cudaMemcpy(dev_a, a, n * sizeof(int), cudaMemcpyHostToDevice);

    dim3 gridSize = 256;
    dim3 blockSize = 256;
    auto startGPU = high_resolution_clock::now();
    find_maximum<<<gridSize, blockSize>>> (dev_a, dev_max, dev_mutex, n);
    auto stopGPU = high_resolution_clock::now();
    cudaMemcpy(max, dev_max, sizeof(float), cudaMemcpyDeviceToHost);
    cout<<"\nThe Max number (GPU): "<<*max<<endl;
    cout<<"\nTime elapsed on GPU: "<<duration_cast<microseconds>(stopGPU - startGPU).count()<<endl;
}