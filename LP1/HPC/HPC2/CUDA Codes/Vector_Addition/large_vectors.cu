//CUDA by Example Page 63

#include<iostream>
using namespace std;

__global__ void addition(int *a, int *b, int *c, int n) {
	int large_id = blockIdx.x * blockDim.x + threadIdx.x;
	while (large_id < n) {
	//if(large_id < n) {
		c[large_id] = a[large_id] + b[large_id];
		large_id += blockDim.x*gridDim.x;
	}
}

int main(void) {
	int n;
	cin>>n;
	//int a[n],b[n],c[n];
	int *a, *b, *c;
	a = (int *)malloc(n * sizeof(int));
	b = (int *)malloc(n * sizeof(int));
	c = (int *)malloc(n * sizeof(int));
	for(int i = 0; i < n; i++) {
		a[i] = i;
		b[i] = i;
		c[i] = 0;
	}
	int *dev_a, *dev_b, *dev_c;
	cudaMalloc(&dev_a, n * sizeof(int));
	cudaMalloc(&dev_b, n * sizeof(int));
	cudaMalloc(&dev_c, n * sizeof(int));
	cudaMemcpy(dev_a, a, n * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(dev_b, b, n * sizeof(int), cudaMemcpyHostToDevice);
	//cudaMemcpy(dev_c, c, n * sizeof(int), cudaMemcpyHostToDevice);
	addition<<<128,128>>>(dev_a, dev_b, dev_c, n);
	cudaMemcpy(c, dev_c, n * sizeof(int), cudaMemcpyDeviceToHost);
	
	for(int i = 0; i < n; i++) {
		cout<<a[i]<<"+"<<b[i]<<"="<<c[i]<<endl;
	}
	
	//verify that gpu did work
	int count = 0;
	bool success = true;
	for(int i = 0; i < n; i++) {
		if((a[i] + b[i]) != c[i]) {
			cout<<"Error in "<<a[i]<<"+"<<b[i]<<"="<<c[i]<<endl;
			success = false;
			count++;
		}
	}
	if (success) cout<<"We did it"<<endl;
	cout<<"Number of errors: "<<count<<endl;
	
	
	
	cudaFree(dev_a);
	cudaFree(dev_b);
	cudaFree(dev_c);
	return 0;
}

//nvcc large_vectors.cu
//./a.exe
//nvprof ./a.exe