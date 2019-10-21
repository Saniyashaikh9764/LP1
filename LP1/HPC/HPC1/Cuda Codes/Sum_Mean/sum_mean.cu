#include<iostream>
#include<cstdio>

using namespace std;

__global__ void sum(int *a, int *b, int n)
{
	int tid = threadIdx.x;
	int sum = 0;

    for(int i=tid; i<min(tid+256,n); i++)
    //tid starts at 0, from i = 0 till whatever is lower, n or 256, keep going to next thread till thread = 256
    //since 256 number of threads is max number of threads one block can have
	{
		sum += a[i];
	}
    b[tid]=sum; //cannot have b[0]=b[0] + a[i] instead of sum += a[i]
                //because it is adding the last element of array twice to the "sum" variable
}

int main()
{
	cout<<"Enter the no of elements"<<endl;
	int n;
    cin>>n;

    //int a[n];
    //cannot create an array as above in nvcc 10.1, so we have created *a 
    int *a;
    a = (int *)malloc(n * sizeof(int));

    //initializing values in the host array, feel free to input what you want
	for(int i=0; i<n; i++)
	{
        a[i] = i;
        //a[i] = rand();
    }
    
	int *dev_a,*dev_b;
    int size = n * sizeof(int);
    
    cudaMalloc(&dev_a, size);
    cudaMalloc(&dev_b, sizeof(int));
    cudaMemcpy(dev_a, a, size, cudaMemcpyHostToDevice);
    
    sum<<<1,n>>>(dev_a, dev_b, n);
    
	int *add;
    add = (int *)malloc(sizeof(int));
	cudaMemcpy(add, dev_b, sizeof(int), cudaMemcpyDeviceToHost);
    cout<<"The sum is  "<<add[0]<<endl;

    float mean = 0;
    //we want mean to be float, so we need RHS to be float
	mean = add[0]/(n*1.0);
	cout<<"The mean is   "<<mean<<endl;
}
