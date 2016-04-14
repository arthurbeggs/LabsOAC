#include <stdio.h>

#define N 10
int v[N]={5,8,3,4,7,6,8,0,1,9};

void show(int v[], int n)
{
   int i;
   for(i=0;i<n;i++)
         printf("%d\t",v[i]);
   printf("\n");
}

void swap(int v[], int k)
{
   int temp;
   temp=v[k];
   v[k]=v[k+1];
   v[k+1]=temp;
}

void sort(int v[], int n)
{
   int i,j;
    for(i=0;i<n;i++)
        for(j=i-1;j>=0 && v[j]>v[j+1];j--)
            swap(v,j);
}


void main()
{
   show(v,N);
   sort(v,N);
   show(v,N);
}
