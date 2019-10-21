#include<iostream>
using namespace std;


//standard deviation = sqrt(summation(x-mean^2) / n)
//Did not figure out why this code doesn't work with threads
__global__ void standard_deviation(int *a, float *b, float mean, int n) {
    int tid = blockIdx.x;
    //int tid - threadIdx.x;
    b[0] = 0.0;
    for(int i = tid; i < n; i++) {  
        b[0] += (a[i] - mean) * (a[i] - mean);
        //printf("b[%d] = %d, a[%d] = %d", i, b[0], i, a[i]);
    }
    b[0] = b[0]/n;
}

int main() {
    int n;
    cin>>n;
    //int a[n]; //does not work on some cuda versions
    int *a = (int *)malloc(n * sizeof(int));
    cout<<"The input numbers are: "<<endl;
    for(int i = 0; i < n; i++) {
        a[i] = i+1;
        cout<<a[i]<<"\t";
    }
    cout<<endl;
    float mean = (n + 1)/2;
    cout<<"Mean: "<<mean<<endl;
    int *dev_a;
    float *dev_b;
    cudaMalloc(&dev_a, n * sizeof(int));
    cudaMalloc(&dev_b, sizeof(float));

    cudaMemcpy(dev_a, a, n * sizeof(int), cudaMemcpyHostToDevice);
    standard_deviation<<<n, 1>>>(dev_a, dev_b, mean, n);
    float *ans = (float *)malloc(sizeof(float));
    cudaMemcpy(ans, dev_b, sizeof(float), cudaMemcpyDeviceToHost);
    cout<<"The answer is: "<< sqrt(ans[0])<<endl;
}