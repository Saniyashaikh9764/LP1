#include<iostream>
#include<chrono>
using namespace std;
using namespace std::chrono; //for execution time checking

__global__ void sumGPU(int *a, long int *b, int n) {
    for(int i = 0; i < n; i++) {
        b[0] += a[i];
    }
    /*int tid = threadIdx.x;
    while (tid < n) {
        b[0] += a[tid];
    }*/
}

void sumCPU(int *a, int n) {
    long int b = 0;
    for(int i = 0; i < n; i++) {
        b += a[i];
    }
    cout<<"CPU sum= "<<b<<endl;
}

int main() {
    int *a, *dev_a;
    long int *dev_b;
    int n;
    cin >> n;
    //allocate a with memory of size of n integers
    a = (int *)malloc(n * sizeof(int)); 
    for(int i = 0; i < n; i++) {
        //a[i] = i;
        a[i] = rand;
    }
    //Allocate memory in CUDA to device dev_a
    cudaMalloc(&dev_a, n * sizeof(int));
    //Allocate memory in CUDA to device dev_b
    cudaMalloc(&dev_b, sizeof(long int));
    //Copy data from host a to device dev_a
    cudaMemcpy(dev_a, a, n * sizeof(int), cudaMemcpyHostToDevice);

    //Compute sum of array on GPU
    auto startGPU = high_resolution_clock::now();
    sumGPU<<<1, n>>>(dev_a, dev_b, n);
    auto stopGPU = high_resolution_clock::now();

    //Print sum of GPU
    long int *output;
    output = (long int *)malloc(sizeof(long int));
    cudaMemcpy(output, dev_b, sizeof(long int), cudaMemcpyDeviceToHost);
    cout<<"GPU sum = "<<output[0]<<endl;
    cout<<"Time required by GPU: "<<duration_cast<microseconds>(stopGPU - startGPU).count() << endl;

    //Compute sum of array on CPU
    auto startCPU = high_resolution_clock::now();
    sumCPU(a, n);
    auto stopCPU = high_resolution_clock::now();
    cout<<"Time required by CPU: "<<duration_cast<microseconds>(stopGPU - startGPU).count() << endl;

}