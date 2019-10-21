import java.util.Scanner;
public class BranchBound
{
	int N;
	void printSolution(int[][] board)
	{
		for(int i=0;i<N;i++)
		{
			for(int j=0;j<N;j++)
			{
				System.out.print("  "+board[i][j]);
			}
			System.out.println();
		}
	}
	
	boolean isSafe(int row, int col, int slashcode[][], int backslashcode[][],
			boolean rowlookup[], boolean slashcodelookup[], boolean backslashlookup[])
	{
		if(slashcodelookup[slashcode[row][col]]||backslashlookup[backslashcode[row][col]]||
				rowlookup[row])
			return false;
		return true;
	}
	
	boolean solvNQUtil(int[][] board, int col, int slashcode[][], int backslashcode[][],
			boolean rowlookup[], boolean slashcodelookup[], boolean backslashlookup[])
	{
		if(col>=N)
			return true;
		for(int i=0;i<N;i++)
		{
			if(isSafe(i,col,slashcode,backslashcode,rowlookup,slashcodelookup,backslashlookup))
			{
				board[i][col]=1;
				rowlookup[i]=true;
				slashcodelookup[slashcode[i][col]]=true;
				backslashlookup[backslashcode[i][col]]=true;
				if(solvNQUtil(board,col+1,slashcode,backslashcode,rowlookup,slashcodelookup,
						backslashlookup)==true)
					return true;
				
				board[i][col]=0;
				rowlookup[i]=false;
				slashcodelookup[slashcode[i][col]]=false;
				backslashlookup[backslashcode[i][col]]=false;
			}
		}
		return false;
	}
	
	boolean solvNQueens()
	{
		int[][] board=new int[N][N];
		int slashcode[][]=new int[N][N];
		int backslashcode[][]=new int[N][N];
		boolean slashcodelookup[]=new boolean[2*N-1];
		boolean backslashlookup[]=new boolean[2*N-1];
		boolean rowlookup[]=new boolean[N];
		
		for(int i=0;i<N;i++)
			for(int j=0;j<N;j++)
				board[i][j]=0;
		
		for(int i=0;i<N;i++)
			rowlookup[i]=false;
		
		for(int i=0;i<2*N-1;i++)
		{
			slashcodelookup[i]=false;
			backslashlookup[i]=false;
		}
		
		for(int r=0;r<N;r++)
		{
			for(int c=0;c<N;c++)
			{
				slashcode[r][c]=r+c;
				backslashcode[r][c]=r-c+N-1;
			}
		}
		
		if(solvNQUtil(board,0,slashcode,backslashcode,rowlookup,slashcodelookup,backslashlookup)
				==false)
		{
			System.out.println("\nCannot be Solved!");
			return false;
		}
		System.out.println("Solution with Branch and Bound is : ");
		printSolution(board);
		return true;
	}
	
	void setN(int n)
	{
		this.N=n;
	}
	
	public static void main(String[] args)
	{
		int n;
		Scanner sc=new Scanner(System.in);
		System.out.println("\nEnter value of N : ");
		n=sc.nextInt();
		BranchBound b=new BranchBound();
		b.setN(n);
		b.solvNQueens();
	}
}