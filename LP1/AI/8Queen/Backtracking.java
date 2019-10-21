import java.util.Scanner;
public class Backtracking
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
	
	boolean isSafe(int board[][], int row, int col)
	{
		for(int i=0;i<col;i++)
		{
			if(board[row][i]==1)
				return false;
		}
		int i,j;
		for(i=row,j=col;i>=0 && j>=0;i--,j--)
		{
			if(board[i][j]==1)
				return false;
		}
		for(i=row, j=col; i<N && j>=0;i++,j--)
		{
			if(board[i][j]==1)
				return false;
		}
		return true;
	}
	
	boolean solNQUtil(int[][] board, int col)
	{
		if(col>=N)
			return true;
		for(int i=0;i<N;i++)
		{
			if(isSafe(board, i, col))
			{
				board[i][col]=1;
				if(solNQUtil(board, col+1)==true)
					return true;
				board[i][col]=0;
			}
		}
		return false;
	}
	
	boolean solNQueen(int N)
	{
		int board[][]=new int[N][N];
		for(int i=0;i<N;i++)
		{
			for(int j=0;j<N;j++)
			{
				board[i][j]=0;
			}
		}
		
		if(solNQUtil(board,0)==false)
		{
			System.out.println("\nCannot be solved!");
			return false;
		}
		System.out.println("\nSolution for "+N+" Queens Problem : \n");
		printSolution(board);
		return true;
	}
	
	void setN(int n)
	{
		this.N=n;
	}
	public static void main(String[] args)
	{
		Backtracking b=new Backtracking();
		int n;
		Scanner sc=new Scanner(System.in);
		System.out.println("\nEnter value of N : ");
		n=sc.nextInt();
		b.setN(n);
		b.solNQueen(n);
	}
}