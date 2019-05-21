/****************************************************************************************
 * @file  Querry.java
 * @author   Alex Kimbrell
 */

import java.sql.*;  
import java.util.Scanner;

/****************************************************************************************
 * This class implements the front-end for Project 2. It contains the list of 6 queries
 * and uses JDBC to connect to a local MySQL database in order to execute queries. The
 * results of each query are printed out in text-based table format.
 */

public class Querry {  
	
	
	/**CHANGE THESE TO MATCH YOUR DATABASE CREDENTIALS SO THAT THE JDBC CAN CONNECT*/
	/** Name of the database on your machine.
	 */
	private static String Database = "employees";
	
	/** Name of the User on your machine
	 */
	private static String User = "root";
	
	/** The Password for User's Account
	 */
	private static String Password = "Basketball31!";
	
	
	
	
	public static void main(String args[]){  
		//Scanner to get input from the user.
		Scanner scan = new Scanner(System.in);//to get index
		Scanner scan2 = new Scanner(System.in);//to continue program loop
		
		//Contains the text of each query description from the Project 2 Documentation
		String[] descriptions = new String[6];
		descriptions[0] = "List department(s) with maximum ratio of average female salaries to average men salaries";
		descriptions[1] = "List manager(s) who holds office for the longest duration";
		descriptions[2] = "For each department, list number of employees born in each decade and their average salaries";
		descriptions[3] = "List employees, who are female, born before Jan 1, 1990, makes more than 80K annually and hold a manager position";
		descriptions[4] = "1 degree: E1 --> D1 <-- E2 (E1 and E2 work at D1 at the same time)";
		descriptions[5] = "2 degree: E1 --> D1 <-- E3 --> D2 <-- E2 (E1 and E3 work at D1 at the same time; E3 and E2 work at D2 at the same time)";
		
		//Contains the queries that will be executed.
		String[] statements = new String[6];
		statements[0] = "SELECT DeptF, (SalF/SalM) AS 'FemaleSalaryRatio' FROM (SELECT D.dept_name AS 'DeptM', AVG(S.salary) AS 'SalM' FROM salaries S "
				+ "JOIN employees E ON S.emp_no=E.emp_no JOIN dept_emp DE ON E.emp_no=DE.emp_no JOIN departments D ON DE.dept_no=D.dept_no "
				+ "WHERE E.gender='M' GROUP BY D.dept_name) AS T1 , (SELECT D2.dept_name AS 'DeptF', AVG(S2.salary) AS 'SalF' "
				+ "FROM salaries S2 JOIN employees E2 ON S2.emp_no=E2.emp_no JOIN dept_emp DE2 ON E2.emp_no=DE2.emp_no JOIN departments D2 ON DE2.dept_no=D2.dept_no "
				+ "WHERE E2.gender='F' GROUP BY D2.dept_name) AS T2 WHERE DeptM=DeptF ORDER BY FemaleSalaryRatio DESC LIMIT 1";
				
		statements[1] = "SELECT E.first_name, E.last_name, DM.from_date, DM.to_date, (DM.to_date - DM.from_date) AS 'Tenure' "
				+ "FROM dept_manager DM JOIN employees E ON DM.emp_no = E.emp_no ORDER BY (DM.to_date - DM.from_date) DESC LIMIT 1";
		
		statements[2] = "(SELECT avg(s.salary) as 'Avg Salary and Employee Count by Decade [1950-1970]' "
				+ "FROM salaries s, employees e WHERE s.emp_no = e.emp_no AND e.birth_date between '1950-01-01' and '1960-01-01') "
				+ "union all (SELECT avg(s.salary) FROM salaries s, employees e WHERE s.emp_no = e.emp_no AND "
				+ "e.birth_date between '1960-01-02' and '1970-01-01') union all (SELECT count(e.emp_no) as 'test' "
				+ "FROM employees e WHERE e.birth_date between '1950-01-02' and '1960-01-01') union all (SELECT "
				+ "count(e.emp_no) FROM employees e WHERE e.birth_date between '1960-01-02' and '1970-01-01')";
		
		statements[3] = "SELECT distinct e.first_name, e.last_name FROM employees as e, salaries as s, dept_manager as d "
				+ "WHERE e.gender = 'F' AND e.birth_date < '1990-01-01' AND e.emp_no = s.emp_no AND s.salary > 80000 "
				+ "AND e.emp_no = d.emp_no";
		
		//defaults for user input on 5a
		String fiveA_employee1 = "10001"; 
		String fiveA_employee2 = "10006";
		statements[4] = "SELECT e1.dept_no FROM dept_emp e1 JOIN dept_emp e2 ON e1.dept_no = e2.dept_no WHERE "
				+ "e1.emp_no = "+fiveA_employee1+" AND e2.emp_no = " +fiveA_employee2+" AND e1.from_date<=e2.from_date "
				+ "AND e1.to_date>=e2.to_date";
		
		//defaults for user input on 5b
		String fiveB_employee1 = "10003";
		String fiveB_employee2 = "10009";
		statements[5] = "SELECT e1.dept_no, e3.dept_no FROM dept_emp e1 JOIN dept_emp e2 ON e1.dept_no = e2.dept_no " 
				+ "JOIN dept_emp e3 ON e2.dept_no = e3.dept_no WHERE e1.emp_no = "+fiveB_employee1+" AND e3.emp_no = "
				+ fiveB_employee2+" AND e1.emp_no != e2.emp_no AND e1.from_date<=e2.from_date AND e1.to_date>=e2.to_date "
				+ "AND e2.from_date<=e3.from_date AND e2.to_date>=e3.to_date";
		
		
		
		
		
		
		
		boolean keepGoing = true;
		
		//Start of program loop
		while(keepGoing == true){
			
			System.out.println("CSCI 4370 Project 2");
			System.out.println();
			System.out.println();
			System.out.println("Enter a number to execute the query");
			System.out.println();
			for(int i = 1; i<=6; i++){
				System.out.println(i + ")  " + descriptions[i-1]);
			}
			int num = 1;
			//Check that the user entered in a valid number.
			try{
				System.out.println();
				System.out.print("Index: ");
				num = scan.nextInt();
				if(num <= 0 || num > 6){
					System.out.println("Index passed does not correspond to a query. Setting Index to 1.");
					num = 1;
				}
			}
			catch(Exception e){
				System.out.println("Please enter an Integer between 1 and 6. Quiting...");
				System.exit(0);
			}
			
			//Pass User indexed statement to runQuery method
			System.out.println("Query In Progress...");
			if(num < 5){ //1 - 4
				runQuery(statements[num-1]);
			}
			else if (num == 5){ //5a
				System.out.print("Please enter employee1 id number: ");
				fiveA_employee1 = scan2.nextLine();
				System.out.print("Please enter employee2 id number: ");
				fiveA_employee2 = scan2.nextLine();
				statements[4] = "SELECT e1.dept_no FROM dept_emp e1 JOIN dept_emp e2 ON e1.dept_no = e2.dept_no WHERE "
						+ "e1.emp_no = "+fiveA_employee1+" AND e2.emp_no = " +fiveA_employee2+" AND e1.from_date<=e2.from_date "
						+ "AND e1.to_date>=e2.to_date";
				runQuery(statements[num-1]);
			}
			else if(num == 6){//5b
				System.out.print("Please enter employee1 id number: ");
				fiveB_employee1 = scan2.nextLine();
				System.out.print("Please enter employee2 id number: ");
				fiveB_employee2 = scan2.nextLine();
				statements[5] = "SELECT e1.dept_no, e3.dept_no FROM dept_emp e1 JOIN dept_emp e2 ON e1.dept_no = e2.dept_no " 
						+ "JOIN dept_emp e3 ON e2.dept_no = e3.dept_no WHERE e1.emp_no = "+fiveB_employee1+" AND e3.emp_no = "
						+ fiveB_employee2+" AND e1.emp_no != e2.emp_no AND e1.from_date<=e2.from_date AND e1.to_date>=e2.to_date "
						+ "AND e2.from_date<=e3.from_date AND e2.to_date>=e3.to_date";
				runQuery(statements[num-1]);
				
			}
			
			System.out.println("Query finished");
			
			//Ask user if they would like to continue program
			System.out.println();
			System.out.println("Would you like to run another query? (y/n)");
			
			String response = scan2.nextLine();
			
			keepGoing = false;
			if(response.equalsIgnoreCase("y") || response.equalsIgnoreCase("yes")){
				keepGoing = true;
			}
			
			
		}//end of program loop
		
		
		//close both input scanners
		scan.close();
		scan2.close();
		
	}//end of main
	
	
	
	
	
	
	/************************************************************************************
     * Run a MySQL query on the User's database given an SQL Query.
     * @author Alex Kimbrell
     * @param query       the SQL query to be run
     */ 
	public static void runQuery(String query){
		
		try{  
			//Find JDBC class
			Class.forName("com.mysql.cj.jdbc.Driver");
			//Connect to database using Database, User, and Password variables.
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/"+Database, User, Password);
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery(query);
			//Get number of columns in result table.
			int cols = rs.getMetaData().getColumnCount();
			
			//Print out the name for each column in result table.
			System.out.print("|-");
			for(int i = 0; i<cols; i++){
				System.out.print("---------------");
			}
			System.out.println("-|");
			System.out.print("| ");		
			for(int c = 1; c<=cols; c++){
				System.out.printf("%15s", rs.getMetaData().getColumnName(c));
			}
			System.out.println(" |");
			System.out.print("|-");
			for(int i = 0; i<cols; i++){
				System.out.print("---------------");
			}
			System.out.println("-|");
			
			//Print out each row in the result table
			while(rs.next()){ 
				System.out.print("| ");
				for(int i = 1; i<=cols; i++){
					System.out.printf("%15s", rs.getString(i)+"  ");  
				}
				System.out.println(" |");
			}
			System.out.print("|-");
			for(int i=0; i<cols;i++){
				System.out.print("---------------");
			}
			System.out.println("-|");
			//Close connection to database.
			con.close();  
		}
		catch(Exception e){ 
			System.out.println(e);
			System.out.println("Could not get result of SQL query...");
		}
		
	}//end of method runQuery()
	
	
	
	
}//end of class Querry



