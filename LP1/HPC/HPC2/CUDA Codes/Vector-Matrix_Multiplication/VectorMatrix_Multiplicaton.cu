#include<iostream>
using namespace std;

__global__ void vecMat(int *a, int *b, int *c, int n) {
	int row = blockIdx.y * blockDim.y + threadIdx.y;
	int sum = 0;
	for (int j = 0; j < n; j++) {
		sum += a[row * n + j] * b[j];
	}
	c[row] = sum;
}

int main() {
	int n;
	cin >> n;
	int *a = new int[n * n];
	int *b = new int[n];
	int *c = new int[n];
	int size = n * sizeof(int);
	cout<<"Matrix A: "<<endl;
	for (int i = 0; i < n; i++) {
		for(int j = 0; j < n; j++) {
			cin >> a[i * n + j];
		}
	}

	cout<<"Matrix A is: "<<endl;
	for(int i = 0; i < n; i++) {
		for(int j = 0; j < n; j++) {
			cout << "a[" << i * n + j << "] = " << a[i * n + j] << " ";
		}
		cout << endl;
	}

	cout<<"Vector B: "<<endl;
	for(int i = 0; i < n; i++) {
		cin >> b[i];
	}

	cout<<"Vector B is: "<<endl;
	for(int i = 0; i < n; i++) {
		cout << "b[" << i << "] = " <<b[i] << " ";
	}
	cout<<endl;
	
	int *dev_a, *dev_b, *dev_c;
	cudaMalloc(&dev_a, n * size);
	cudaMalloc(&dev_b, size);
	cudaMalloc(&dev_c, size);

	cudaMemcpy(dev_a, a, n * size, cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, size, cudaMemcpyHostToDevice);

	dim3 grid_dim(n, n, 1);
	vecMat <<< grid_dim, 1 >>> (dev_a, dev_b, dev_c, n);

	cudaMemcpy(c, dev_c, size, cudaMemcpyDeviceToHost);

	cout << "Output: " << endl;
	for(int i = 0; i < n; i++) {
		cout<< "c[" << i << "] = " << c[i] <<" ";
	}
}
