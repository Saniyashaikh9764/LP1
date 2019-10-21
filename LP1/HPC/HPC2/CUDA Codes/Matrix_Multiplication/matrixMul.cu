#include<iostream>
using namespace std;

__global__ void matMul(int *a, int *b, int *c, int n) {
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    int col = threadIdx.x + blockIdx.x * blockDim.x;
    int sum = 0;
    for(int j = 0; j < n; j++) {
        sum += a[row * n + j] * b[j * n + col];
    }
    c[n*row + col] = sum;
}

int main() {
    int n;
    cin>>n;
    int *a = new int[n * n];
    int *b = new int[n * n];
    int *c = new int[n * n];
    int size = n * n * sizeof(int);
    cout<<"Matrix A: "<<endl;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            cin >> a[i * n + j];
        }
    }
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            cout<<"a["<<i * n + j<<"] = "<< a[i * n + j]<<" ";
        }
        cout<<endl;
    }
    cout<<"Matrix B: "<<endl;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            cin >> b[i * n + j];
        }
    }
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            cout<<"b["<<i * n + j<<"] = "<< b[i * n + j]<<" ";
        }
        cout<<endl;
    }
    int *dev_a, *dev_b, *dev_c;
    cudaMalloc(&dev_a, size);
    cudaMalloc(&dev_b, size);
    cudaMalloc(&dev_c, size);
    
    cudaMemcpy(dev_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, size, cudaMemcpyHostToDevice);

    dim3 grid_dim(n, n, 1);
    matMul<<<grid_dim, 1>>> (dev_a, dev_b, dev_c, n);
    
    cudaMemcpy(c, dev_c, size, cudaMemcpyDeviceToHost);

    cout<<"Output: "<<endl;
    for(int i = 0; i < n; i++) {
        for(int j = 0; j < n; j++) {
            cout<< c[i * n + j]<<" ";
        }
        cout<<endl;
    }
    
}