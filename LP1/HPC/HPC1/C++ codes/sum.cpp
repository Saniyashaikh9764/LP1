#include<iostream>
#define N 10
using namespace std;

void sum(int *input) {
	int tid = 1;
	while (tid <= N) {
		input[tid] += input[tid-1];
		tid += 1;
	}
}

int main() {
	int arr[N+1];
	for(int i = 0; i <= N; i++) {
		arr[i] = i;
	}
	/*for(int i = 0; i <= N; i++) {
		cout<<arr[i]<<endl;
	}*/
	sum(arr);
	cout<<"Sum of first "<<N<<" numbers in an array starting from 0 incremented by 1 to "<<N<<" = "<<arr[N]<<endl;
}
